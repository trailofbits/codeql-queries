#include "../../../include/openssl/engine.h"

int main() {

    int rc1 = 0;
    int rc2 = 0;

    ENGINE *eng1 = ENGINE_by_id("rdrand");
    rc1 = ENGINE_init(eng1);
    // rc1 = ENGINE_set_default(eng1, NULL);

    ENGINE *eng2 = ENGINE_by_id("rdrand");
    rc2 = ENGINE_init(eng2);
    rc2 = ENGINE_set_default(eng2, NULL);
}