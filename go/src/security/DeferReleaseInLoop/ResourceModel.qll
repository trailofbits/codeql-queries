/**
 * Models for file, network, and database resource acquisition and release in Go.
 *
 * These models identify:
 * - "Source" functions that return closeable resources (files, connections, etc.)
 * - "Sink" methods that release/close those resources
 */

import go

/**
 * A function that opens or acquires a file-based resource. No common trait used
 */
class FileResourceAcquisition extends Function {
  FileResourceAcquisition() {
    // os package: file open/create
    this.hasQualifiedName("os", ["Open", "OpenFile", "Create", "CreateTemp", "NewFile", "Pipe"])
    or
    // net package: connections and listeners
    this.hasQualifiedName("net", ["Dial", "DialTimeout", "Listen", "ListenPacket"])
    or
    this.hasQualifiedName("net", ["FileConn", "FileListener", "FilePacketConn"])
    or
    this.(Method).hasQualifiedName("net", "Dialer", ["Dial", "DialContext"])
    or
    // net/http: client requests returning response bodies
    this.hasQualifiedName("net/http", ["Get", "Post", "PostForm", "Head"])
    or
    this.(Method).hasQualifiedName("net/http", "Client", ["Do", "Get", "Post", "PostForm", "Head"])
    or
    // crypto/tls
    this.hasQualifiedName("crypto/tls", ["Dial", "DialWithDialer", "Client", "Server"])
    or
    this.(Method).hasQualifiedName("crypto/tls", "Dialer", "DialContext")
    or
    // compress readers/writers (implement io.Closer)
    this.hasQualifiedName("compress/gzip", ["NewReader", "NewWriter", "NewWriterLevel"])
    or
    this.hasQualifiedName("compress/zlib",
      ["NewReader", "NewWriter", "NewWriterLevel", "NewWriterLevelDict"])
    or
    this.hasQualifiedName("compress/flate", ["NewReader", "NewWriter"])
    or
    this.hasQualifiedName("compress/lzw", ["NewReader", "NewWriter"])
    or
    // archive readers
    this.hasQualifiedName("archive/zip", "OpenReader")
  }
}

/**
 * A method that closes or releases a file-based resource that shouldn't be leaked.
 * Matching on those that implement `io.Closer` for now.
 */
class ResourceCloseMethod extends Method {
  ResourceCloseMethod() {
    this.getName() = "Close" and
    (
      this.getReceiverType().implements("io", "Closer")
      or
      exists(Type base |
        base = this.getReceiverType().(PointerType).getBaseType()
        or
        not this.getReceiverType() instanceof PointerType and
        base = this.getReceiverType()
      |
        base.implements("io", "Closer")
      )
    )
  }
}
