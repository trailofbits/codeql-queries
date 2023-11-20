#include "../../../include/openssl/bn.h"
#include "../../../include/openssl/rand.h"

void handleErrors(){}

int main(){

    unsigned char buffer[128];

    int rc = RAND_bytes(buffer, sizeof(buffer));

    // if(rc != 1) {  // handle appropiate error
    //     /* RAND_bytes failed */
    //     /* `err` is valid    */
    //     handleErrors();
    // }  // will fail here
}