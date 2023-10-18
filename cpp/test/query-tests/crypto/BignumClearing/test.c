#include "../../../include/openssl/bn.h"

int main(){
    BIGNUM *BN = BN_new();
    BN_rand(BN, 128, BN_RAND_TOP_ANY, BN_RAND_BOTTOM_ANY);
    // BN_clear(BN);  // use to clear any Bignums in memory
}