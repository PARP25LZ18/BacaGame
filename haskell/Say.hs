{-
    Character say and think code
    Contains instances with and without description.

    Usage:
        baca_say "Witom"  -- no desc
        baca_say ("Witom", "said baca")  -- with description
-}

-- TODO: replace putStrLn with typewriterWrite

module Say
    ( BacaSay
    , baca_say
    , kacper_say
    , karolina_say
    , player_say
    , player_think
    , KacperSay
    , KarolinaSay
    , PlayerSay
    , PlayerThink
    , narrate
    , write_tip
    , write_info
    , write_dialogue_option
    ) where

import Control.Monad.IO.Class (MonadIO, liftIO)

class BacaSay a where
    baca_say :: MonadIO m => a -> m ()

instance BacaSay String where
    baca_say msg = liftIO $ putStrLn $ "\x1b[31m\"" ++ msg ++ "\"\x1b[0m"

instance BacaSay (String, String) where
    baca_say (msg, desc) = liftIO $ putStrLn $ "\x1b[31m\"" ++ msg ++ "\"\x1b[0m - " ++ desc


class KacperSay a where
    kacper_say :: MonadIO m => a -> m ()

instance KacperSay String where
    kacper_say msg = liftIO $ putStrLn $ "\x1b[32m\"" ++ msg ++ "\"\x1b[0m"

instance KacperSay (String, String) where
    kacper_say (msg, desc) = liftIO $ putStrLn $ "\x1b[32m\"" ++ msg ++ "\"\x1b[0m - " ++ desc


class KarolinaSay a where
    karolina_say :: MonadIO m => a -> m ()

instance KarolinaSay String where
    karolina_say msg = liftIO $ putStrLn $ "\x1b[36m\"" ++ msg ++ "\"\x1b[0m"

instance KarolinaSay (String, String) where
    karolina_say (msg, desc) = liftIO $ putStrLn $ "\x1b[36m\"" ++ msg ++ "\"\x1b[0m - " ++ desc


class PlayerSay a where
    player_say :: MonadIO m => a -> m ()

instance PlayerSay String where
    player_say msg = liftIO $ putStrLn $ "\x1b[1m\"" ++ msg ++ "\"\x1b[0m"

instance PlayerSay (String, String) where
    player_say (msg, desc) = liftIO $ putStrLn $ "\x1b[1m\"" ++ msg ++ "\"\x1b[0m - " ++ desc


class PlayerThink a where
    player_think :: MonadIO m => a -> m ()

instance PlayerThink String where
    player_think msg = liftIO $ putStrLn $ "\x1b[90m\"" ++ msg ++ "\"\x1b[0m"

instance PlayerThink (String, String) where
    player_think (msg, desc) = liftIO $ putStrLn $ "\x1b[90m\"" ++ msg ++ "\"\x1b[0m - " ++ desc

narrate :: MonadIO m => String -> m ()
narrate msg = liftIO $ putStrLn $ "\x1b[0m" ++ msg;

write_tip :: MonadIO m => String -> m ()
write_tip msg = liftIO $ putStrLn $ "\x1b[2mTIP: " ++ msg ++ "\x1b[0m"

write_info :: MonadIO m => String -> m ()
write_info msg = liftIO $ putStrLn $ "\x1b[2mINFO: " ++ msg ++ "\x1b[0m"

write_dialogue_option :: MonadIO m => String -> String -> m ()
write_dialogue_option msg desc = liftIO $ putStrLn $ "\x1b[1m" ++ msg ++ "\x1b[0m: \x1b[4;50m" ++ desc ++ "\x1b[0m"
