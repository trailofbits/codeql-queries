import cpp
import crypto.common

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
class RAND_bytes extends FunctionCall {
  RAND_bytes() { this.getTarget().getName() in ["RAND_bytes", "RAND_priv_bytes"] }

  int getRequestedBytes() { result = this.getArgument(1).getValue().toInt() }

  int getBufferSize() { result = this.getArgument(0).getUnderlyingType().getSize() }

  Expr getBuffer () {result = this.getArgument(0)}
}
