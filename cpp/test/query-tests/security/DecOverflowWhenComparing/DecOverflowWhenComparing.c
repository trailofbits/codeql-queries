#include "../../../include/libc/string_stubs.h"
#include "../../../include/libc/stdlib.h"
#include "../../../include/libc/unistd.h"
#include "../../../include/libc/stdint.h"

// BAD
// from https://github.com/apple-oss-distributions/Libinfo/blob/9fce29e5c5edc15d3ecea55116ca17d3f6350603/lookup.subproj/mdns_module.c#L1033C1-L1079C2
char* _mdns_parse_domain_name(const uint8_t *data, uint32_t datalen)
{
	int i = 0, j = 0;
	uint32_t domainlen = 0;
	char *domain = NULL;

	if ((data == NULL) || (datalen == 0)) return NULL;

	while (datalen-- > 0)
	{
		uint32_t len = data[i++];
		domainlen += (len + 1);
		domain = reallocf(domain, domainlen);

		if (domain == NULL) return NULL;

		if (len == 0) break;

		if (j > 0)
		{
			domain[j++] = datalen ? '.' : '\0';
		}

		// bug is in datalen decrementation here
		while ((len-- > 0) && (0 != datalen--))
		{
			if (data[i] == '.')
			{
				domain = reallocf(domain, ++domainlen);
				if (domain == NULL) return NULL;

				domain[j++] = '\\';
			}

			domain[j++] = data[i++];
		}
	}

	domain[j] = '\0';

	return domain;
}

// BAD: n used after loop without overwrite (overflowed on last iteration)
void simple_use_after_loop(uint32_t n, int *buf) {
    while (n-- > 0) {
        buf[0] = 1;
    }
    buf[n] = 0; // BAD: n is UINT32_MAX here
}

// BAD: use in false branch of != 0
void use_after_neq(uint32_t n, int *buf) {
    if (n-- != 0) {
        buf[0] = 1;
    }
    buf[n] = 0; // BAD
}

// GOOD: variable overwritten by assignment before use
void overwrite_by_assignment(uint32_t n, int *buf) {
    while (n-- > 0) {
        buf[0] = 1;
    }
    n = 42;
    buf[n] = 0;
}

// GOOD: signed integer - not unsigned
void signed_decrement(int n, int *buf) {
    while (n-- > 0) {
        buf[n] = 0;
    }
}

// GOOD: variable not used after comparison
void no_use_after(uint32_t n, int *buf) {
    while (n-- > 0) {
        buf[0] = 1;
    }
}

// BAD: reversed comparison form 0 < n--
void reversed_lt(uint32_t n, int *buf) {
    while (0 < n--) {
        buf[0] = 1;
    }
    buf[n] = 0; // BAD
}

// BAD: n-- == 0, use in true branch where n just wrapped to UINT32_MAX
void eq_zero(uint32_t n, int *buf) {
    if (n-- == 0) {
        buf[n] = 0; // BAD
    }
}

// BAD: do-while, use after loop
void do_while(uint32_t n, int *buf) {
    do {
        buf[0] = 1;
    } while (n-- > 0);
    buf[n] = 0; // BAD
}

// BAD: conditional overwrite (only one branch overwrites)
void conditional_overwrite(uint32_t n, int *buf, int cond) {
    if (n-- != 0) {
        buf[0] = 1;
    }
    if (cond) {
        n = 42;
    }
    buf[n] = 0; // BAD: path exists where n is not overwritten
}

// GOOD: use only in true branch of > 0 (n was confirmed > 0)
void use_in_true_branch(uint32_t n, int *buf) {
    if (n-- > 0) {
        buf[n] = 0;
    }
}

// GOOD: prefix decrement (query only checks postfix)
void prefix_decrement(uint32_t n, int *buf) {
    while (--n > 0) {
        buf[n] = 0;
    }
}

// GOOD: overwrite in all branches before use
void overwrite_all_branches(uint32_t n, int *buf, int cond) {
    while (n-- > 0) {
        buf[0] = 1;
    }
    if (cond) {
        n = 10;
    } else {
        n = 20;
    }
    buf[n] = 0;
}

int main() {
    const uint16_t datalen = 128;
    uint8_t data[datalen] = {};
    memcpy(data, "\x04quildu\x03xyz\x00", 11);
    _mdns_parse_domain_name(data, datalen);
}
