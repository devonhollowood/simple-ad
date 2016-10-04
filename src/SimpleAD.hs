module SimpleAD
    ( at
    , AD (..)
    ) where

import Data.Ratio (numerator, denominator)

infixr 0 `at`
at :: Num a => (AD a -> AD a) -> a -> (a, a)
f `at` x = unAD . f $ AD (x, 1)

newtype AD a = AD { unAD :: (a, a) }

instance Num a => Num (AD a) where
    AD (x, x') + AD (y, y') = AD (x + y, x' + y')
    AD (x, x') * AD (y, y') = AD (x * y, x' * y + x * y')
    negate = unary negate (const (-1))
    abs = unary abs signum
    signum = unary signum (const 0)
    fromInteger x = AD (fromInteger x, 0)

instance Fractional a => Fractional (AD a) where
    AD (x, x') / AD (y, y') = AD (x / y, (y * x' - x * y') / (y * y) )
    fromRational x = fromInteger (numerator x) / fromInteger (denominator x)

instance Floating a => Floating (AD a) where
    pi = AD (pi, 0)
    exp = unary exp exp
    log = unary log recip
    sin = unary sin cos
    cos = unary cos (negate . sin)
    asin = unary asin (\x -> 1 / sqrt (1 - x * x))
    acos = unary acos (\x -> (-1) / sqrt (1 - x * x))
    atan = unary atan (\x -> 1 / (1 + x * x))
    sinh = unary sinh cosh
    cosh = unary cosh sinh
    asinh = unary asinh (\x -> 1 / sqrt (x * x + 1))
    acosh = unary acosh (\x -> 1 / sqrt (x * x - 1))
    atanh = unary atanh (\x -> 1 / (1 - x * x))

unary :: Num a => (a -> a) -> (a -> a) -> AD a -> AD a
unary f f' (AD (x, x')) = AD (f x, x' * f' x)
