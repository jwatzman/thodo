{-# LANGUAGE DeriveDataTypeable #-}

module Facebook.Cookie(fbidFromCookie) where

import qualified Codec.Binary.Base64Url as B64
import qualified Data.ByteString.Internal as BS
import Data.Word (Word8)
import Data.Generics (Data)
import Data.Typeable (Typeable)
import qualified Text.JSON as JSON
import qualified Text.JSON.Generic as JSONG
import qualified Text.JSON.String as JSONS
--import System.IO.Unsafe (unsafePerformIO)

import Facebook.FBID

data FBJson = FBJson {
	algorithm :: String,
	user_id :: String
} deriving (Eq, Show, Data, Typeable)

base64pad :: String -> String
base64pad str =
	let
		n = 4
		padlen = n - (length str `mod` n)
	in
		if padlen == n then str else str ++ (replicate padlen '=')

splitCookie :: String -> (String, String)
splitCookie cookie = (\(x,y) -> (x, drop 1 y)) (break ((==) '.') cookie)

decodeB64 :: (Monad m) => String -> m [Word8]
decodeB64 encoded = case B64.decode $ base64pad encoded of
	Just l -> return l
	Nothing -> fail "Failed to deocde base64"

decodeFBJson :: (Monad m) => String -> m FBJson
decodeFBJson json =
	case JSONS.runGetJSON JSONS.readJSValue json of
		Left s -> fail s
		Right j -> case JSONG.fromJSON j of
			JSON.Error s -> fail s
			JSON.Ok x -> return x

safeRead :: (Read r, Monad m) => String -> m r
safeRead s = case reads s of
	[(v, "")] -> return v
	_ -> fail $ "Invalid read of " ++ s

fbidFromCookie :: (Monad m) => String -> m FBID
fbidFromCookie cookie = do
	let (signatureEncoded, jsonEncoded) = splitCookie cookie
	signature <- decodeB64 signatureEncoded
	json <- decodeB64 jsonEncoded
	fbjson <- decodeFBJson $ map BS.w2c json
	if algorithm fbjson == "HMAC-SHA256" then
		return ()
	else
		fail $ "Invalid algorithm " ++ algorithm fbjson
	-- todo: verify signature
	safeRead $ user_id fbjson
