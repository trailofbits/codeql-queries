import cpp
import tob.crypto.common

// void mbedtls_mpi_init( mbedtls_mpi *X );
class Mbedtls_mpi_init extends CustomAllocator {
  Mbedtls_mpi_init() {
    this.getQualifiedName() = "mbedtls_mpi_init" and
    dealloc instanceof Mbedtls_mpi_free
  }

  override int getPointer() {
    result = 0
  }
}

// void mbedtls_mpi_free( mbedtls_mpi *X );
class Mbedtls_mpi_free extends CustomDeallocator {
  Mbedtls_mpi_free() {
    this.getQualifiedName() = "mbedtls_mpi_free"
  }

  override int getPointer() {
    result = 0
  }
}
