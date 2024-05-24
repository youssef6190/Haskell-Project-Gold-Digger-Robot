--- cell= robot position / [cell]=positions of gold / String =last move done / MyState= previous states for the robot (perivous moves) 
type Cell = (Int,Int)
data MyState = Null | S Cell [Cell] String MyState deriving (Show,Eq)


up :: MyState-> MyState
up (S (0,b) _ _ _ ) = Null
up (S (a,b) l s x) = S (a-1,b) l "up" (S (a,b) l s x)

down :: MyState -> MyState
down (S (3,_) _ _ _) = Null
down (S (x, y) gold move previous) = S (x + 1, y) gold "down" (S (x, y) gold move previous)

left :: MyState -> MyState
left (S (x,0) _ _ _) = Null
left (S (x,y) r t previous )= (S (x,y-1) r "left" (S (x,y) r t previous))

right :: MyState -> MyState
right (S (x,3) _ _ _)=Null
right (S (x,y) s t prev)=(S (x,y+1) s "right" (S (x,y) s t prev)) 



isGoal :: MyState -> Bool
isGoal (S _ [] _ _) = True
isGoal _ = False

dig :: MyState -> MyState 
dig (S rp gp lm prev) |elem rp gp = S rp (filter (/=rp) gp) "dig" (S rp gp lm prev)
                      |otherwise = Null

nextMyStates :: MyState -> [MyState]

nextMyStates (S (x,y) s t prev)=(filter (/=Null) z)
                        where z=[up (S (x,y) s t prev ),down ( S (x,y) s t prev ),left ( S (x,y) s t prev ), right (S (x,y) s t prev ),dig (S (x,y) s t prev)]

search :: [MyState] -> MyState
search [] = Null
search (x:xs)   | isGoal x = x
                | otherwise = search (xs ++ nextMyStates x)  


constructSolution :: MyState -> [String]
constructSolution (S _ _ "" _) = []
constructSolution (S _ _ s rest) = constructSolution rest++[s]

solve :: Cell -> [Cell] -> [String]
solve position goldPos = constructSolution ( search [S position goldPos "" Null])
