# Decrementation overflow when comparing
Finds unsigned integer overflow issues with the following heuristic: \* variable is compared to 0 and decremented \* variable is used after the comparison and decrementation In such cases it is likely that the decrementation was not expected.

You can read about a real-world vulnerability here: https://github.com/trailofbits/exploits/tree/main/obts-2025-macos-lpe


## Recommendation
Move the decrementation outside of comparison and/or add explicit checks for overflows.


## Example

```c
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

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

		if (len == 0) break;	// DNS root (NUL)

		if (j > 0)
		{
			domain[j++] = datalen ? '.' : '\0';
		}

		while ((len-- > 0) && (0 != datalen--))
		{
			if (data[i] == '.')
			{
				/* special case: escape the '.' with a '\' */
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

int main() {
    const uint16_t datalen = 128;
    uint8_t data[datalen] = {};
    memcpy(data, "\x04quildu\x03xyz\x00", 11);
    _mdns_parse_domain_name(data, datalen);
}

```
The `datalen` variable may overflow to UINT_MAX given a specific input.

