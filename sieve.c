#include <stdio.h>
#include <stdlib.h>
#include "xmath.h"

int main(int argc, char* argv[])
{
    if (argc < 2 || argc > 3)
    {
        fprintf(stderr, "Usage: sieve n\n");
        return 1;
    }

    unsigned int n = (unsigned int)atoi(argv[1]);

    unsigned int m;
    unsigned int *primes = sieve(n, &m);
    
    for (int i = 0; i < m; ++i)
    {
        printf("%d, ", primes[i]);
    }

    return 0;
}
