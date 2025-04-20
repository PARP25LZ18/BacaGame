import Game
import Story
import Control.Monad.State
import qualified Data.Set as Set
import System.IO (hFlush, stdout)

gameLoop :: Game ()
gameLoop = do
  liftIO $ putStr "\n> " >> hFlush stdout
  input <- liftIO getLine
  case words input of
    ["spojrz", obj] -> spojrz obj >> gameLoop
    ["lvo"] -> lvo >> gameLoop
    _ -> liftIO (putStrLn "Nie rozumiem tej komendy 😕") >> gameLoop

initialState :: GameState
initialState = GameState
   { visibleObjects = Set.fromList ["schronisko"]
   , answers        = Set.empty
   , bacaHates      = ""
   , kacperHates    = ""
   , atIntroduction = True
   }

main :: IO ()
main = do
    putStrLn "\x1b[31m░▒▓███████▓▒░ ░▒▓██████▓▒░ ░▒▓██████▓▒░ ░▒▓██████▓▒░ \x1b[32m       ░▒▓██████▓▒░ ░▒▓██████▓▒░░▒▓██████████████▓▒░░▒▓████████▓▒░\x1b[0m "
    putStrLn "\x1b[31m░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░\x1b[32m      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \x1b[0m "
    putStrLn "\x1b[31m░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░\x1b[32m      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \x1b[0m "
    putStrLn "\x1b[31m░▒▓███████▓▒░░▒▓████████▓▒░▒▓█▓▒░      ░▒▓████████▓▒░\x1b[32m      ░▒▓█▓▒▒▓███▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓██████▓▒░  \x1b[0m "
    putStrLn "\x1b[31m░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░\x1b[32m      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \x1b[0m "
    putStrLn "\x1b[31m░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░\x1b[32m      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \x1b[0m "
    putStrLn "\x1b[31m░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░\x1b[32m       ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░\x1b[0m "

    evalStateT gameLoop initialState
