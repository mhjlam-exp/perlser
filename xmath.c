#include <assert.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "xmath.h"

/// xmath.fibonacci
/// 
unsigned int fibonacci(unsigned int n)
{
    if (n == 0) return 0;
    else if (n < 3) return 1;
    return fibonacci(n-1) + fibonacci(n-2);
}

/// 
/// 
unsigned int *sieve(unsigned int n, unsigned int *m)
{
    assert(n > 1 && "input integer must be 2 or higher");

    int i, j;
    unsigned int *a = (unsigned int*)malloc(n * sizeof(unsigned int));

    for (i = 2; i < n; ++i)
    {
        a[i] = 1;
    }

    for (i = 2; i < n; ++i)
    {
        if (a[i])
        {
            for (j = i; i * j < n; j++)
            {
                a[i * j] = 0;
            }
        }
    }

    *m = 0;  
    for (i = 2; i < n; ++i)
    {
        if (a[i])
        {
            (*m)++;
        }
    }

    unsigned int *primes = (unsigned int*)malloc(*m * sizeof(unsigned int));

    for (j = 0, i = 2; i < n; ++i)
    {
        if (a[i])
        {
            primes[j++] = i;
        }
    }

    return primes;
}