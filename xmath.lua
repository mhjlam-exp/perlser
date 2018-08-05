local math = require "math"

local xmath = {}

local function isint(n)
    return n == math.floor(n)
end

--- xmath.fact
--- Compute factorial of input number.
--- Computes the product of all positive integers less than 
--- or equal to input number n by using recursion. 
--- @param n (number) input number
--- @return (number) result of the factorial operation
function xmath.fact(n)
    assert(n >= 0, "input number must be a non-negative integer")
    assert(isint(n), "input number must be a non-negative integer")
    if n == 0 then
        return 1
    else
        return n * fact(n-1)
    end
end

--- xmath.square
--- Compute square number of input integer.
--- @param n (number) input integer
--- @return (number) perfect square of input integer
function xmath.square(n)
    assert(n > 0, "input number must be a positive integer")
    assert(isint(n), "input number must be a positive integer")
    return n * n
end
