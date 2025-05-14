module Rendering
    ( typewriter_write_text
    , typewriter_write_img
    ) where

import Control.Concurrent (threadDelay)
import System.IO (hFlush, stdout)

typewriter_write_text :: String -> IO ()
typewriter_write_text text = do
    typewriter_write text 20000
    putStrLn ""

typewriter_write_img :: String -> IO ()
typewriter_write_img text = do 
    typewriter_write text 150
    putStrLn ""


typewriter_write :: String -> Int -> IO ()
typewriter_write [] _ = return ()
typewriter_write (h:xs) delay = do
    putChar h
    hFlush stdout
    threadDelay delay
    typewriter_write xs delay