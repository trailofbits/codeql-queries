/**
 * @name Message not hashed before signature verification
 * @id tob/go/msg-not-hashed-sig-verify
 * @description Detects calls to (EC)DSA APIs with a message that was not hashed. If the message is longer than the expected hash digest size, it is silently truncated
 * @kind path-problem
 * @tags security
 * @problem.severity error
 * @precision medium
 * @security-severity  8.0
 * @group cryptography
 */

import go

/**
 *  Function that performs signing or signature verification on a hash of a message
 *  and silently truncates the input hash if it is longer than expected
 */
class SignatureMsgTruncationFunction extends Function {
    int msgHashPosition;

    SignatureMsgTruncationFunction() {
        // https://cs.opensource.google/go/go/+/refs/tags/go1.20.2:src/crypto/ecdsa/ecdsa.go;l=376-382;drc=457fd1d52d17fc8e73d4890150eadab3128de64d
        (this.hasQualifiedName("crypto/ecdsa", ["VerifyASN1", "Verify"]) and msgHashPosition = 1)
        or
        (this.hasQualifiedName("crypto/ecdsa", ["SignASN1", "Sign"]) and msgHashPosition = 2)
        or

        // doesn't truncate, but also doesn't hash internally
        // https://cs.opensource.google/go/go/+/refs/tags/go1.20.2:src/crypto/dsa/dsa.go;l=296
        (this.hasQualifiedName("crypto/dsa", "Verify") and msgHashPosition = 1)
        or
        (this.hasQualifiedName("crypto/dsa", "Sign") and msgHashPosition = 2)
        or

        // https://github.com/btcsuite/btcd/blob/2f508b3f86ed9ef87bcf3426b87b6c0dc0d3632c/btcec/signature.go#L256-L263
        (this.hasQualifiedName("github.com/btcsuite/btcd/btcec", "SignCompact") and msgHashPosition = 2)
        or
        (this.hasQualifiedName("github.com/btcsuite/btcd/btcec.PrivateKey", "Sign") and msgHashPosition = 0)
        or
        (this.hasQualifiedName("github.com/btcsuite/btcd/btcec.PublicKey", "RecoverCompact") and msgHashPosition = 2)
        or
        (this.hasQualifiedName("github.com/btcsuite/btcd/btcec.Signature", "Verify") and msgHashPosition = 0)
        or
        
        // https://github.com/btcsuite/btcd/blob/2f508b3f86ed9ef87bcf3426b87b6c0dc0d3632c/btcec/signature.go#L256-L263
        (this.hasQualifiedName("github.com/umbracle/ethgo/wallet", "Ecrecover") and msgHashPosition = 0)
        or
        (this.hasQualifiedName("github.com/umbracle/ethgo/wallet", "RecoverPubkey") and msgHashPosition = 1)
        or
        (this.hasQualifiedName("github.com/umbracle/ethgo/wallet.Key", "Sign") and msgHashPosition = 0)
        or

        // https://github.com/decred/dcrd/blob/3bc18a3be50822100773789cb3ecff08cb17f938/dcrec/secp256k1/modnscalar.go#L345-L356
        (
            exists(string dcrdVersion | dcrdVersion = ["", "/v2", "/v3", "/v4"] |
                (this.hasQualifiedName("github.com/decred/dcrd/dcrec/secp256k1" + dcrdVersion, ["RecoverCompact", "RecoverCompact", "Sign"]) and msgHashPosition = 1)
                or
                (this.hasQualifiedName("github.com/decred/dcrd/dcrec/secp256k1" + dcrdVersion + ".Signature", "Verify") and msgHashPosition = 0)
            )
        )
        
        // examples of secure implementations:
        // https://github.com/ethereum/go-ethereum/blob/v1.11.3/crypto/secp256k1/secp256.go#L127
        // https://cs.opensource.google/go/go/+/refs/tags/go1.20.2:src/crypto/ed25519/ed25519.go;l=322;drc=457fd1d52d17fc8e73d4890150eadab3128de64d
        // https://github.com/btccom/secp256k1-go/blob/master/secp256k1/secp256k1.go#L270-L274
    }

    predicate hashArgPosition(int position) {
        msgHashPosition = position
    }
}

/**
 * Models a hash function
 * The list is extended from (private) experimental/CWE-327/CryptoLibraries.qll 
 * TODO: received methods support, e.g., package.Hash(msg).Sum()
 */
class HashFunction extends Function {
    HashFunction() {
        this.getName().toUpperCase().matches([
            "DSA", "ED25519", "SHA256", "SHA384", "SHA512", "SHA3", "ES256", "ECDSA256", "ES384",
            "ECDSA384", "ES512", "ECDSA512", "SHA2", "SHA224", "RIPEMD320", "SHA0",
            "HAVEL128", "MD2", "SHA1", "MD4", "MD5", "PANAMA", "RIPEMD", "RIPEMD128", "RIPEMD256",
            "ARGON2", "PBKDF2", "BCRYPT", "SCRYPT",
            "KECCAK256", "KECCAK256RLP", "HASH"
        ])
    }
}

private module LongestFlowConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source = source }
    predicate isSink(DataFlow::Node sink) { sink = sink }
}
module LongestFlowFlow = TaintTracking::Global<LongestFlowConfig>;

/**
 *  Flows from anything to SignatureMsgTruncationFunction
 *  that do not cross a hash function or slicing expression
 */
module AnythingToSignatureMsgTrunFuncConfig implements DataFlow::ConfigSig {    
    // anything that is not a function's argument
    // TODO: alternatively, set sources to be ExternalInputs
    predicate isSource(DataFlow::Node source) {
        not isSink(source)
        and not source.asInstruction() instanceof IR::ReadArgumentInstruction
    }

    predicate isSink(DataFlow::Node sink) {
        exists(SignatureMsgTruncationFunction sigUseF, CallExpr sigUseCall, int position | 
            sigUseCall.getTarget() = sigUseF
            and sigUseF.hashArgPosition(position)
            and sink.asExpr() = sigUseCall.getArgument(position)
        )
    }

    // sanitize if
    // * data goes through a hash function
    // * data is truncated with a hardcoded value
    // * TODO: data is of type Hash
    predicate isBarrier(DataFlow::Node node) {
        // direct hash function call
        exists(HashFunction hf | hf.getACall().getResult(_) = node or hf.getACall().getArgument(_) = node)
        or
        // hash function call via .Sum()
        node.(DataFlow::CallNode).getTarget().hasQualifiedName("hash.Hash" + ["", "32", "64"], "Sum")
        or
        // slicing
        exists(SliceExpr e |
            e = node.asExpr()
            and 
            (e.getHigh().isConst() or e.getLow().isConst())
        )
        // note that not hashing message may be bad even for short messages; 66 is max truncation size
        or
        node.asExpr().(SliceExpr).getBase().getType().getUnderlyingType().(ArrayType).getLength() <= 66
        or
        node.asExpr().getType().getUnderlyingType().(ArrayType).getLength() <= 66
    }
}
module AnythingToSignatureMsgTrunFuncFlow = TaintTracking::Global<AnythingToSignatureMsgTrunFuncConfig>;

from AnythingToSignatureMsgTrunFuncFlow::PathNode source, AnythingToSignatureMsgTrunFuncFlow::PathNode sink
where
    AnythingToSignatureMsgTrunFuncFlow::flowPath(source, sink)

    // only the longest flow
    and not exists(DataFlow::Node source2 |
        LongestFlowFlow::flow(source2, source.getNode())
        and source2 != source.getNode()
    )

    // TODO: ignore if conditionally hashed

select sink.getNode(), source, sink, "Message must be hashed before signing/veryfing operation"
