{-# LANGUAGE OverloadedStrings #-}

import System.Environment (getArgs, lookupEnv, getProgName)
import System.Exit (exitFailure)
import System.Process
import System.Directory (createDirectoryIfMissing, doesDirectoryExist)
import System.FilePath ((</>))
import System.IO (hSetBinaryMode)
import Text.Regex.TDFA ((=~))
import Data.Aeson (decode, Value(..), (.:), eitherDecode, Object)
import Data.Aeson.Types (parseMaybe)
import qualified Data.Aeson as Aeson
import qualified Data.Aeson.Key as K
import qualified Data.ByteString.Lazy as BL
import Data.List (intercalate)
import Data.Char (isDigit)
import qualified Data.Text as T

runDownloader :: String -> IO ()
runDownloader url = do
    -- 1. Setup Directory
    homeDir <- lookupEnv "HOME"
    mapsDir <- case homeDir of
        Just home -> return (home </> "Maps")
        Nothing   -> putStrLn "Error: $HOME not set" >> exitFailure

    createDirectoryIfMissing True mapsDir

    -- 2. Extract ID
    let urlBase = head $ wordsBy '#' url
    let regex = "beatmapsets/([0-9]+)" :: String
    let matches = (urlBase =~ regex) :: [[String]]

    beatmapsetId <- case matches of
        [[_, bId]] -> return bId
        _          -> putStrLn "Error: Could not find beatmapset ID in URL." >> exitFailure

    exitFailure

downloadMap :: FilePath -> String -> Value -> IO ()
downloadMap mapsDir bid meta = do
    let artist = parseField "artist" meta
    let title  = parseField "title"  meta

    -- Sanitize filename: replace / : * ? < > | with nothing
    let beatmapName = sanitize $ artist ++ " - " ++ title
    let filename = bid ++ " " ++ beatmapName ++ ".osz"
    let fullPath = mapsDir </> filename

    putStrLn $ "Downloading " ++ filename ++ " ..."

    -- 5. Download file
    let downloadUrl = "https://osu.direct/d/" ++ bid
    callProcess "curl" ["-#", "-L", "-o", fullPath, downloadUrl]

    putStrLn $ "\nSuccessfully downloaded: '" ++ filename ++ "' to '" ++ mapsDir ++ "'."

-- --- Helpers ---

-- Extract string from Aeson Value
parseField :: String -> Value -> String
parseField key val = case val of
    Object obj -> case parseMaybe (\o -> o .: K.fromString key) obj of
        Just s  -> s
        Nothing -> "Unknown"
    _ -> "Unknown"
-- Basic string splitter
wordsBy :: Char -> String -> [String]
wordsBy c s = case dropWhile (== c) s of
    "" -> []
    s' -> w : wordsBy c s''
          where (w, s'') = break (== c) s'

-- Simple regex-based sanitization
sanitize :: String -> String
sanitize str = filter (`notElem` ("\\/:*?<>|" :: String)) str

readProcessBinary :: FilePath -> [String] -> IO BL.ByteString
readProcessBinary cmd args = do
    (exitCode, stdout, stderr) <- System.Process.readCreateProcessWithExitCode (System.Process.proc cmd args) ""
    return $ BL.pack (map (fromIntegral . fromEnum) stdout)

-- | Main entry point
main :: IO ()
main = do
    args <- getArgs
    case args of
        [url] -> runDownloader url
        _     -> do
            progName <- getProgName
            putStrLn $ "Usage: " ++ progName ++ " <osu beatmap URL>"
            exitFailure
