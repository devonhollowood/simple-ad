# simple-ad
_Simple automatic differentiation_

This is a mostly-for-fun automatic differentiator. Import this library and use the `at` function to simultaneously evaluate an analytic function and its derivative at a point. This is, of course, subject to the precision of the given point's type, so don't expect infinitely precise answers when using things like Doubles (see: anything involving `pi` in the examples below).

Examples:

```haskell
-- Integers
(\x -> x^3) `at` 2 -- (8,12)
(\x -> x^2 + 1) `at` 3 -- (10,6)

-- Rationals
(\x -> x^2) `at` 1 % 3 -- (1 % 9,2 % 3)
(\x -> (x^2 + 1) / 3) `at` 1 % 3 -- (10 % 27,2 % 9)

-- Doubles
sin `at` 0.0 -- (0.0,1.0)
cos `at` 0.0 -- (1.0,-0.0)
sin `at` pi / 2 -- (1.0,6.123233995736766e-17)
(\x -> exp (2 * log x) + 1) `at` 3.0 -- (10.000000000000002,6.000000000000001)
sqrt `at` 4.0 -- (2.0,0.25)
(\x -> sin x / x) `at` pi -- (3.8981718325193755e-17,-0.3183098861837907)
(\x -> log (acosh x * sqrt x)) `at` 4.0 -- (1.417520253041309,0.2501304891432236)
```