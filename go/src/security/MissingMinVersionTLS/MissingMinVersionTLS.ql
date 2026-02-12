/**
 * @name Missing MinVersion in tls.Config
 * @id tob/go/missing-min-version-tls
 * @description Finds uses of tls.Config where MinVersion is not set and the project's minimum Go version (from go.mod) indicates insecure defaults: Go < 1.18 for clients or Go < 1.22 for servers. Does not mark explicitly set versions (including explicitly insecure ones).
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision medium
 * @security-severity 2.0
 * @group security
 */

import go
import semmle.go.GoMod as GoMod

/**
 * Flow of a `tls.Config` to a write to the `MinVersion` field.
 */
module TlsVersionConfig implements DataFlow::ConfigSig {
  /**
   * Holds if `source` is a TLS.Config instance.
   */
  predicate isSource(DataFlow::Node source) {
    exists(Variable v |
      configOrConfigPointer(v.getType()) and
      source.asExpr() = v.getAReference()
    )
  }

  /**
   * Holds if a write to `sink`.MinVersion exists.
   */
  predicate isSink(DataFlow::Node sink) {
    exists(Write fieldWrite, Field fld |
      fld.hasQualifiedName("crypto/tls", "Config", "MinVersion") and
      fieldWrite.writesField(sink, fld, _)
    )
  }
}

module TlsVersionFlow = TaintTracking::Global<TlsVersionConfig>;

predicate structLitSetsMinVersion(StructLit lit) {
  exists(Write w, Field fld |
    fld.hasQualifiedName("crypto/tls", "Config", "MinVersion") and
    w.writesField(DataFlow::exprNode(lit), fld, _)
  )
}

module TlsConfigCreationConfig implements DataFlow::ConfigSig {
  /**
   * Holds if `source` is a TLS.Config literal without MinVersion set.
   */
  predicate isSource(DataFlow::Node source) {
    exists(StructLit lit |
      lit.getType().hasQualifiedName("crypto/tls", "Config") and
      source.asExpr() = lit and
      not structLitSetsMinVersion(lit)
    )
  }

  /**
   * Holds if it is TLS.Config instance (a Variable).
   */
  predicate isSink(DataFlow::Node sink) { exists(Variable v | sink.asExpr() = v.getAReference()) }

  /**
   * Holds if TLS.Config literal is saved in a structure's field
   */
  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Write w | w.writesField(succ, _, pred))
  }
}

module TlsConfigCreationFlow = TaintTracking::Global<TlsConfigCreationConfig>;

/**
 * Holds if `t` is a TLS.Config type or a pointer to it (or ptr to ptr...) or a struct containing it.
 */
predicate configOrConfigPointer(Type t) {
  t.hasQualifiedName("crypto/tls", "Config")
  or
  exists(Type tp |
    tp.hasQualifiedName("crypto/tls", "Config") and
    t = tp.getPointerType+()
  )
  or
  exists(Type tp |
    tp.hasQualifiedName("crypto/tls", "Config") and
    t.(NamedType).getUnderlyingType().(StructType).hasField(_, tp)
  )
  or
  exists(Type tp, Type tp2 |
    tp.hasQualifiedName("crypto/tls", "Config") and
    tp2 = tp.getPointerType+() and
    t.(NamedType).getUnderlyingType().(StructType).hasField(_, tp2)
  )
}

/**
 * Holds if v is a Go version string for Go 1.x that is >= 1.18.
 * Matches: "1.18", "1.19", "1.20", ..., "1.99", "1.100", "1.18.0", etc.
 */
bindingset[v]
predicate goVersionAtLeast_1_18(string v) {
  v.regexpMatch("1\\.(1[89]|[2-9][0-9]|[1-9][0-9]{2,})(\\.\\d+)?")
}

/**
 * Holds if v is a Go version string for Go 1.x that is >= 1.22.
 * Matches: "1.22", "1.23", ..., "1.99", "1.100", "1.22.0", etc.
 */
bindingset[v]
predicate goVersionAtLeast_1_22(string v) {
  v.regexpMatch("1\\.(2[2-9]|[3-9][0-9]|[1-9][0-9]{2,})(\\.\\d+)?")
}

/**
 * Holds if the project may be built with a Go version where a server with
 * an unset MinVersion still defaults to TLS 1.0/1.1 (Go < 1.22).
 *
 * - If there is no go.mod: assume yes
 * - Otherwise: if any go.mod has a `go` < 1.22: yes.
 */
predicate projectSupportsOldTlsDefaultsForServers() {
  not exists(GoModGoLine l | l = l) or
  exists(GoModGoLine l | not goVersionAtLeast_1_22(l.getVersion()))
}

/**
 * Holds if the project may be built with a Go version where a client with
 * an unset MinVersion still defaults to TLS 1.0/1.1 (Go < 1.18).
 *
 * - If there is no go.mod: assume YES (be conservative).
 * - Otherwise: if any go.mod has a `go` < 1.18: YES.
 */
predicate projectSupportsOldTlsDefaultsForClients() {
  not exists(GoModGoLine l | l = l) or
  exists(GoModGoLine l | not goVersionAtLeast_1_18(l.getVersion()))
}

/**
 * Holds if expression `e` mentions the config variable or struct literal.
 */
predicate mentionsConfig(Expr e, Variable v, StructLit configStruct) {
  e.getAChild*() = v.getARead().asExpr() or
  e.getAChild*() = configStruct
}

/**
 * Holds if the config is used as a client config (TLSClientConfig or tls.Dial/Client APIs).
 */
predicate usedAsClient(Variable v, StructLit configStruct) {
  exists(StructLit outer, KeyValueExpr kv |
    outer.getType().hasQualifiedName("net/http", "Transport") and
    kv.getParent*() = outer and
    kv.getKey().(Ident).getName() = "TLSClientConfig" and
    mentionsConfig(kv.getValue(), v, configStruct)
  )
  or
  exists(Write w, Field fld, DataFlow::Node recv, DataFlow::Node rhs |
    fld.hasQualifiedName("net/http", "Transport", "TLSClientConfig") and
    w.writesField(recv, fld, rhs) and
    mentionsConfig(rhs.asExpr(), v, configStruct)
  )
  or
  exists(CallExpr call |
    // tls.Dial(network, addr, config) => argument 2 is config (0-based)
    call.getTarget().hasQualifiedName("crypto/tls", "Dial") and
    mentionsConfig(call.getArgument(2), v, configStruct)
  )
  or
  exists(CallExpr call |
    // tls.DialWithDialer(dialer, network, addr, config) => argument 3 is config
    call.getTarget().hasQualifiedName("crypto/tls", "DialWithDialer") and
    mentionsConfig(call.getArgument(3), v, configStruct)
  )
  or
  exists(CallExpr call |
    // tls.Client(conn, config) => argument 1 is config
    call.getTarget().hasQualifiedName("crypto/tls", "Client") and
    mentionsConfig(call.getArgument(1), v, configStruct)
  )
}

/**
 * Holds if the config is used as a server config (TLSConfig or tls.Listen/Server APIs).
 */
predicate usedAsServer(Variable v, StructLit configStruct) {
  exists(StructLit outer, KeyValueExpr kv |
    outer.getType().hasQualifiedName("net/http", "Server") and
    kv.getParent*() = outer and
    kv.getKey().(Ident).getName() = "TLSConfig" and
    mentionsConfig(kv.getValue(), v, configStruct)
  )
  or
  exists(Write w, Field fld, DataFlow::Node recv, DataFlow::Node rhs |
    fld.hasQualifiedName("net/http", "Server", "TLSConfig") and
    w.writesField(recv, fld, rhs) and
    mentionsConfig(rhs.asExpr(), v, configStruct)
  )
  or
  exists(CallExpr call |
    // tls.Listen(network, addr, config) => argument 2 is config
    call.getTarget().hasQualifiedName("crypto/tls", "Listen") and
    mentionsConfig(call.getArgument(2), v, configStruct)
  )
  or
  exists(CallExpr call |
    // tls.NewListener(inner, config) => argument 1 is config
    call.getTarget().hasQualifiedName("crypto/tls", "NewListener") and
    mentionsConfig(call.getArgument(1), v, configStruct)
  )
  or
  exists(CallExpr call |
    // tls.Server(conn, config) => argument 1 is config
    call.getTarget().hasQualifiedName("crypto/tls", "Server") and
    mentionsConfig(call.getArgument(1), v, configStruct)
  )
}

// v - a variable holding any structure which is or contains the tls.Config
from StructLit configStruct, Variable v, DataFlow::Node source, DataFlow::Node sink
where
  // find tls.Config structures with MinVersion not set on the structure initialization
  (
    TlsConfigCreationFlow::flow(source, sink) and
    sink.asExpr() = v.getAReference() and
    source.asExpr() = configStruct
  ) and
  // only explicitely defined, e.g., skip function arguments
  (
    exists(DeclStmt decl | v.getAReference() = decl.getAChild+())
    or
    exists(DefineStmt decl | v.getAReference() = decl.getAChild+())
  ) and
  // skip field declarations
  not exists(FieldDecl decl | v.getAReference() = decl.getAChild+()) and
  // if the tls.Config is assigned to a variable
  (
    if configOrConfigPointer(v.getType())
    then
      // exclude if there is a later write to MinVersion
      not exists(DataFlow::Node source2, DataFlow::Node sink2 |
        TlsVersionFlow::flow(source2, sink2) and
        source2.asExpr() = v.getAReference()
      )
    else any()
  ) and
  // Version-aware filtering based on client vs server usage:
  // - For clients: only flag if Go < 1.18 (when client default is TLS 1.0)
  // - For servers: only flag if Go < 1.22 (when server default is TLS 1.0)
  // - If neither classified, be conservative as "server-like"
  (
    usedAsClient(v, configStruct) and projectSupportsOldTlsDefaultsForClients()
    or
    usedAsServer(v, configStruct) and projectSupportsOldTlsDefaultsForServers()
    or
    not usedAsClient(v, configStruct) and
    not usedAsServer(v, configStruct) and
    projectSupportsOldTlsDefaultsForServers()
  )
select configStruct, "TLS.Config.MinVersion is never set for variable $@.", v, v.getName()
