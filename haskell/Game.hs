module Game
    ( can_see
    , make_visible
    , hide
    , answered
    , how_answered
    , add_answer
    , lvo
    , kacper_hate
    , baca_hate
    , Object
    , Who
    , Question
    , Answer
    , Game
    , GameState(..)
    ) where


import Say
import Control.Monad.State
import qualified Data.Set as Set
import Data.List (isPrefixOf)

type Object = String
type Who = String
type Question = String
type Answer = String

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x

-- TODO: dodac tutaj reszte zmiennych, baca_hates, odpowiedzi, pytania itd
data GameState = GameState
    { visibleObjects :: Set.Set Object
    , answers        :: Set.Set (Who, Question, Answer)
    , bacaHates      :: Who
    , kacperHates    :: Who
    , atIntroduction :: Bool
    }

type Game = StateT GameState IO

can_see :: Object -> Game Bool
can_see obj = do
    gs <- get
    return (obj `Set.member` visibleObjects gs)

make_visible :: Object -> Game ()
make_visible toShow = modify $ \gs ->
    gs { visibleObjects = Set.insert toShow (visibleObjects gs) }

hide :: Object -> Game ()
hide toHide = modify $ \gs ->
    gs { visibleObjects = Set.delete toHide (visibleObjects gs) }

answered :: Who -> Question -> Answer -> Game Bool
answered who question answer = do
    gs <- get
    return ((who, question, answer) `Set.member` answers gs)

how_answered :: Who -> Question -> Game (Maybe Answer)
how_answered who question = do
    gs <- get
    let ans = [a | (w, q, a) <- Set.toList (answers gs), w == who, q == question]
    return (safeHead ans)

add_answer :: Who -> Question -> Answer -> Game ()
add_answer who question answer = modify $ \gs ->
    gs { answers = Set.insert (who, question, answer) (answers gs) }

baca_hate :: Who -> Game ()
baca_hate who = modify $ \gs ->
    gs { bacaHates = who  }

kacper_hate :: Who -> Game ()
kacper_hate who = modify $ \gs ->
    gs { kacperHates = who }

lvo :: Game()
lvo = do
    objs <- gets visibleObjects
    if Set.null objs
        then liftIO $ putStrLn "Nie widzisz teraz żadnych obiektów"
        else do
            liftIO $ putStrLn "Możesz spojrzeć na:"
            mapM_ (liftIO . putStrLn . ("- " ++)) (Set.toList objs)
