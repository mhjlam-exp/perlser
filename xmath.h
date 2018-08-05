/// xmath.fibonacci
/// Compute Fibonacci number of the input number.
/// @param n (unsigned int) input integer
/// @return (unsigned int) Fibonacci number of the given integer
extern unsigned int fibonacci(unsigned int n);

/// xmath.sieve
/// Compute all prime numbers up to the input number.
/// Use Sieve of Eratosthenes to find all prime numbers up to any given limit.
/// @param n (unsigned int) input integer
/// @param m (unsigned int*) pointer to the number of prime numbers returned
/// @return (unsigned int*) array of prime numbers
extern unsigned int *sieve(unsigned int n, unsigned int *m);
