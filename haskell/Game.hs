module Game
    ( can_see
    , make_visible
    , hide
    , lvo
    , Object
    , Game
    , GameState(..)
    ) where


import Say
import Control.Monad.State
import qualified Data.Set as Set
import Data.List (isPrefixOf)

type Object = String

-- TODO: dodac tutaj reszte zmiennych, baca_hates, odpowiedzi, pytania itd
data GameState = GameState
    { visibleObjects :: Set.Set Object
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

lvo :: Game()
lvo = do
    objs <- gets visibleObjects
    if Set.null objs
        then liftIO $ putStrLn "Nie widzisz teraz żadnych obiektów"
        else do
            liftIO $ putStrLn "Możesz spojrzeć na:"
            mapM_ (liftIO . putStrLn . ("- " ++)) (Set.toList objs)
