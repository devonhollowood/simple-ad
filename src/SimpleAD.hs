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
    negate = chain negate (const (-1))
    abs = chain abs signum
    signum = chain signum (const 0)
    fromInteger x = AD (fromInteger x, 0)

instance Fractional a => Fractional (AD a) where
    AD (x, x') / AD (y, y') = AD (x / y, (y * x' - x * y') / (y * y) )
    fromRational x = fromInteger (numerator x) / fromInteger (denominator x)

instance Floating a => Floating (AD a) where
    pi = AD (pi, 0)
    exp = chain exp exp
    log = chain log recip
    sin = chain sin cos
    cos = chain cos (negate . sin)
    asin = chain asin (\x -> 1 / sqrt (1 - x * x))
    acos = chain acos (\x -> (-1) / sqrt (1 - x * x))
    atan = chain atan (\x -> 1 / (1 + x * x))
    sinh = chain sinh cosh
    cosh = chain cosh sinh
    asinh = chain asinh (\x -> 1 / sqrt (x * x + 1))
    acosh = chain acosh (\x -> 1 / sqrt (x * x - 1))
    atanh = chain atanh (\x -> 1 / (1 - x * x))

-- Utility function for applying chain rule
chain :: Num a => (a -> a) -> (a -> a) -> AD a -> AD a
chain f f' (AD (x, x')) = AD (f x, x' * f' x)
