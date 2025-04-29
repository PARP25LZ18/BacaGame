import Game
import Story
import Control.Monad.State
import qualified Data.Set as Set
import System.IO (hSetEncoding, stdout, stdin, hFlush)
import GHC.IO.Encoding (utf8)

gameLoop :: Game ()
gameLoop = do
  liftIO $ putStr "\n> " >> hFlush stdout
  input <- liftIO getLine
  case words input of
    ["spojrz", obj] -> spojrz obj >> gameLoop
    ["lvo"] -> lvo >> gameLoop
    ["start_story"] -> start_story >> gameLoop
    ["show_map"] -> show_map >> gameLoop
    ["rozpocznij_eksploracje"] -> rozpocznij_eksploracje >> gameLoop
    ["oskarz_baca"] -> oskarz_baca >> gameLoop
    ["oskarz_kacper"] -> oskarz_kacper >> gameLoop
    _ -> liftIO (putStrLn "Nie rozumiem tej komendy 😕") >> gameLoop

initialState :: GameState
initialState = GameState
   { visibleObjects = Set.fromList ["schronisko"]
   , lookedObjects  = Set.fromList []
   , answers        = Set.empty
   , bacaHates      = ""
   , kacperHates    = ""
   , atIntroduction = True
   }

main :: IO ()
main = do
    hSetEncoding stdout utf8
    hSetEncoding stdin utf8
    putStrLn "\x1b[31m░▒▓███████▓▒░ ░▒▓██████▓▒░ ░▒▓██████▓▒░ ░▒▓██████▓▒░ \x1b[32m       ░▒▓██████▓▒░ ░▒▓██████▓▒░░▒▓██████████████▓▒░░▒▓████████▓▒░\x1b[0m "
    putStrLn "\x1b[31m░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░\x1b[32m      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \x1b[0m "
    putStrLn "\x1b[31m░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░\x1b[32m      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \x1b[0m "
    putStrLn "\x1b[31m░▒▓███████▓▒░░▒▓████████▓▒░▒▓█▓▒░      ░▒▓████████▓▒░\x1b[32m      ░▒▓█▓▒▒▓███▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓██████▓▒░  \x1b[0m "
    putStrLn "\x1b[31m░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░\x1b[32m      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \x1b[0m "
    putStrLn "\x1b[31m░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░\x1b[32m      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \x1b[0m "
    putStrLn "\x1b[31m░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░\x1b[32m       ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░\x1b[0m "

    evalStateT gameLoop initialState
