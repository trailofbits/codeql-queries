import cpp
import tob.crypto.common

// void RAND_seed(const void *buf, int num);
class RAND_seed extends CsprngInitializer {
  RAND_seed() { this.getName() = "RAND_seed" }

  override int getAStrongRandomnessSink() { result = 0 }
}

// void RAND_add(const void *buf, int num, double randomness);
class RAND_add extends CsprngInitializer {
  RAND_add() { this.getName() = "RAND_add" }

  override int getAStrongRandomnessSink() { result = 0 }
}

// int RAND_bytes(unsigned char *buf, int num);
class RAND_bytes extends Csprng, ReturnsErrorCode {
  RAND_bytes() { this.getName() = "RAND_bytes" }

  override int getAStrongRandomnessSource() { result = 0 }

  override int getRequestedBytes() { result = 1 }
}

// int RAND_bytes_ex(OSSL_LIB_CTX *ctx,
//                   unsigned char *buf,
//                   size_t num,
//                   unsigned int strength);
class RAND_bytes_ex extends Csprng, ReturnsErrorCode {
  RAND_bytes_ex() { this.getName() = "RAND_bytes_ex" }

  override int getAStrongRandomnessSource() { result = 1 }

  override int getRequestedBytes() { result = 2 }
}

// int RAND_priv_bytes(unsigned char *buf, int num);
class RAND_priv_bytes extends Csprng, ReturnsErrorCode {
  RAND_priv_bytes() { this.getName() = "RAND_priv_bytes" }

  override int getAStrongRandomnessSource() { result = 0 }

  override int getRequestedBytes() { result = 1 }
}

// int RAND_priv_bytes_ex(OSSL_LIB_CTX *ctx,
//                   unsigned char *buf,
//                   size_t num,
//                   unsigned int strength);
class RAND_priv_bytes_ex extends Csprng, ReturnsErrorCode {
  RAND_priv_bytes_ex() { this.getName() = "RAND_priv_bytes_ex" }

  override int getAStrongRandomnessSource() { result = 1 }

  override int getRequestedBytes() { result = 2 }
}
