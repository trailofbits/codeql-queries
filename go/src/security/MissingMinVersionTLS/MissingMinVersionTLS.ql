/**
 * @name Missing MinVersion in tls.Config
 * @id tob/go/missing-min-version-tls
 * @description This rule finds cases when you do not set the `tls.Config.MinVersion` explicitly for servers. By default version 1.0 is used, which is considered insecure. This rule does not mark explicitly set insecure versions
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision medium
 * @security-severity 2.0
 * @group security
 */

import go

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
        fld.hasQualifiedName( "crypto/tls", "Config", "MinVersion") and
        fieldWrite.writesField(sink, fld, _)
      )
    }
}
module TlsVersionFlow = TaintTracking::Global<TlsVersionConfig>;


/**
 * Flow of a `tls.Config` with `MinVersion` to a variable.
 */
module TlsConfigCreationConfig implements DataFlow::ConfigSig {
    additional predicate isSecure(DataFlow::Node source) {
        exists(StructLit lit, Field fld |
            lit.getType().hasQualifiedName("crypto/tls", "Config") and
            fld.hasQualifiedName("crypto/tls", "Config", "MinVersion") and
            source.asExpr() = lit and
            fld = lit.getType().getField(_) and
            exists(Write w | w.writesField(DataFlow::exprNode(lit), fld, _))
        )
    }
  
    /**
     * Holds if `source` is a TLS.Config literal.
     */
    predicate isSource(DataFlow::Node source) {
        exists(StructLit lit, Field fld |
            lit.getType().hasQualifiedName("crypto/tls", "Config") and
            fld.hasQualifiedName("crypto/tls", "Config", "MinVersion") and
            source.asExpr() = lit
        )
        and not isSecure(source)
    }
  
    /**
     * Holds if it is TLS.Config instance (a Variable).
     */
    predicate isSink(DataFlow::Node sink) {
        exists(Variable v |
            sink.asExpr() = v.getAReference()
        )
    }

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
    t.hasQualifiedName("crypto/tls", "Config") or
    exists(Type tp |
        tp.hasQualifiedName("crypto/tls", "Config") and
        t = tp.getPointerType+()
    ) or 
    exists(Type tp | 
        tp.hasQualifiedName("crypto/tls", "Config") and
        t.(NamedType).getUnderlyingType().(StructType).hasField(_, tp)
    ) or 
    exists(Type tp, Type tp2 | 
        tp.hasQualifiedName("crypto/tls", "Config") and
        tp2 = tp.getPointerType+() and
        t.(NamedType).getUnderlyingType().(StructType).hasField(_, tp2)
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
    )
    
    // exclude if tls.Config is used as TLSClientConfig, as default for clients is TLS 1.2
    and not exists(KeyValueExpr kv |
        kv.getKey().(VariableName).getTarget().getName() = "TLSClientConfig" and
        (
        kv.getValue().getAChild*() = v.getARead().asExpr()
        or
        kv.getValue().getAChild*() = configStruct
        )
    )

    and not exists(Type t | 
        t.hasQualifiedName("net/http", "Client") and
        v.getType() = t.getPointerType*()
    )

    // only explicitely defined, e.g., skip function arguments
    and (
        exists(DeclStmt decl | v.getAReference() = decl.getAChild+()) 
        or
        exists(DefineStmt decl | v.getAReference() = decl.getAChild+()) 
    )

    // skip field declarations
    and not exists(FieldDecl decl | v.getAReference() = decl.getAChild+())
    
    // if the tls.Config is assigned to a variable
    and if configOrConfigPointer(v.getType()) then
    (   
        // exclude if there is a later write to MinVersion
        not exists(DataFlow::Node source2, DataFlow::Node sink2 | 
            TlsVersionFlow::flow(source2, sink2) and
            source2.asExpr() = v.getAReference()
        )
    ) else
        any()

select configStruct, "TLS.Config.MinVersion is never set for variable $@ ", v, v.getName()