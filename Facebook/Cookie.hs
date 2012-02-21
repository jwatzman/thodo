{-# LANGUAGE DeriveDataTypeable #-}

module Facebook.Cookie(fbidFromCookie) where

import qualified Codec.Binary.Base64Url as B64
import Codec.Utils (Octet)
import qualified Data.ByteString.Internal as BS
import Data.Generics (Data)
import qualified Data.HMAC as HMAC
import qualified Data.Digest.SHA256 as SHA256
import Data.Typeable (Typeable)
import Data.Word (Word8)
import qualified Text.JSON as JSON
import qualified Text.JSON.Generic as JSONG
import qualified Text.JSON.String as JSONS

import qualified Facebook.Config
import Facebook.FBID

data FBJson = FBJson {
	algorithm :: String,
	user_id :: String
} deriving (Eq, Show, Data, Typeable)

hmac_sha256 :: [Octet] -> [Octet] -> [Octet]
hmac_sha256 = HMAC.hmac $ HMAC.HashMethod SHA256.hash 512

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
decodeB64 encoded =
	case B64.decode $ base64pad encoded of
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
	let signatureExpected =
		hmac_sha256
			(map BS.c2w Facebook.Config.appsecret)
			(map BS.c2w jsonEncoded)
	if signature == signatureExpected then
		return ()
	else
		fail "Invalid HMAC"
	safeRead $ user_id fbjson
