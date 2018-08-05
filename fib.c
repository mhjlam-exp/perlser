#include <stdio.h>
#include <stdlib.h>
#include "xmath.h"

int main(int argc, char* argv[])
{
    if (argc < 2 || argc > 3)
    {
        fprintf(stderr, "Usage: fib n\n");
        return 1;
    }

    unsigned int n = (unsigned int)atoi(argv[1]);

    unsigned int f = fibonacci(n);
    fprintf(stdout, "fibonacci(%d) = %d", n, f);
    return 0;
}
