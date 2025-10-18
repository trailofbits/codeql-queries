#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

size_t min(size_t a, size_t b) {
	return a < b ? a : b;
}

void MlasReorderInputNhwc(
    const float* S,
    float* D,
    size_t InputChannels,
    size_t RowCount,
    size_t FullRowCount
    )
{
    const size_t BlockSize = FullRowCount % 123;

    //
    // Iterate over batches of the input size to improve locality.
    //

    for (size_t OuterRowCountRemaining = RowCount; OuterRowCountRemaining > 0; ) {

        size_t OuterRowCountBatch = 32;

        const size_t OuterRowCountThisIteration = min(OuterRowCountRemaining, OuterRowCountBatch);
        OuterRowCountRemaining -= OuterRowCountThisIteration;

        //
        // Iterate over BlockSize batches of the input channels.
        //

        const float* s = S;
        float* d = D;

        for (size_t i = InputChannels; i > 0;) {

            const size_t InputChannelsThisIteration = min(i, BlockSize);
            i -= InputChannelsThisIteration;

            const float* ss = s;
            float* dd = d;
            size_t InnerRowCountRemaining = OuterRowCountThisIteration;

            if (InputChannelsThisIteration == BlockSize) {

                if (BlockSize == 8) {

                    while (InnerRowCountRemaining-- > 0) {
                        ss += InputChannels;
                        dd += 8;
                    }

                } else {

                    while (InnerRowCountRemaining-- > 0) {
                        ss += InputChannels;
                        dd += 16;
                    }
                }

            } else {

                size_t BlockPadding = BlockSize - InputChannelsThisIteration;

                while (InnerRowCountRemaining-- > 0) {
                    ss += InputChannels;
                    dd += BlockSize;
                }
            }

            s += InputChannelsThisIteration;
            d += BlockSize * FullRowCount;
        }

        S += InputChannels * OuterRowCountThisIteration;
        D += BlockSize * OuterRowCountThisIteration;
    }
}

// from https://github.com/apple-oss-distributions/Libinfo/blob/9fce29e5c5edc15d3ecea55116ca17d3f6350603/lookup.subproj/mdns_module.c#L1033C1-L1079C2
char* _mdns_parse_domain_name(const uint8_t *data, uint32_t datalen)
{
	int i = 0, j = 0;
	// uint32_t len;
	uint32_t domainlen = 0;
	char *domain = NULL;

	if ((data == NULL) || (datalen == 0)) return NULL;

	/*
	 * i: index into input data
	 * j: index into output string
	 */
	while (datalen-- > 0)
	{
		// printf("%d\n", len);
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

