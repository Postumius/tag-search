import Data.HashSet

data Filter = Tag String | Pred (HashSet String -> Bool)

getPred (Tag str) = member str
getPred (Pred p) = p

composePreds op p1 p2 =
  Pred (\(st) -> op (getPred p1 st) (getPred p2 st))

tand [] = Pred (\(st) -> True)
tand (f:fs) = composePreds (&&) f (tand fs)

tor :: [Filter] -> Filter
tor = foldl (composePreds (||)) (Pred (\(st) -> False))

tnot f = Pred (\(st) -> not $ getPred f st)


set :: HashSet String
set = insert "3" $ insert "2" $ insert "1" empty

