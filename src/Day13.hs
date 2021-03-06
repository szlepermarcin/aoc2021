{-# LANGUAGE ViewPatterns #-}
module Day13
  ( solution
  , part1
  , part2
  )
where

import           Utils

type Coords = (Int, Int)
type Fold = [Coords] -> [Coords]

type Input = ([Coords], [Fold])

solution :: Solution
solution = (part1, part2, "day13")

part1 :: String -> String
part1 = show . processPart1 . parseInput

processPart1 :: Input -> Int
processPart1 (s,f) = length $ foldl (\a fn -> fn a) s (take 1 f)

part2 :: String -> String
part2 = processPart2 . parseInput

processPart2 :: Input -> String
processPart2 (s,f) = unlines ("" : ((\y -> (\x -> if (x,y) `elem` coords then '#' else ' ') <$> [0..maxX]) <$> [0..maxY]))
  where
  coords = foldl (\a fn -> fn a) s f
  maxX = maximum $ fst <$> coords
  maxY = maximum $ snd <$> coords

parseInput :: String -> Input
parseInput (splitOn "" . lines -> [c,f]) = (parseCoord <$> c, parseFold <$> f)
  where
  parseCoord (splitOn ',' -> [x,y]) =  (read x, read y)
  parseCoord _                      = undefined
  parseFold (splitOn '=' -> ["fold along y", y]) = fh (read y)
  parseFold (splitOn '=' -> ["fold along x", x]) = fv (read x)
  parseFold _                                    = id
parseInput _ = undefined

fv :: Int -> [Coords] -> [Coords]
fv i v = adjust $ nub $ first (\x -> if x > i then i - (x - i) else x) <$> v

fh :: Int -> [Coords] -> [Coords]
fh i v = adjust $ nub $ second (\y -> if y > i then i - (y - i) else y) <$> v

adjust :: [Coords] -> [Coords]
adjust c = bimap (adjx +) (adjy +) <$> c
  where
  adjx = negate (minimum (fst <$> c))
  adjy = negate (minimum (snd <$> c))
