{-# LANGUAGE DeriveDataTypeable #-}

module Facebook.Cookie(fbidFromCookie) where

import qualified Codec.Binary.Base64Url as B64
import qualified Data.ByteString.Internal as BS
import Data.Generics (Data)
import Data.Typeable (Typeable)
import qualified Text.JSON as JSON
import qualified Text.JSON.Generic as JSONG
import qualified Text.JSON.String as JSONS
import System.IO.Unsafe (unsafePerformIO)

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

decodeFBJson :: (Monad m) => String -> m FBJson
decodeFBJson json =
	case JSONS.runGetJSON JSONS.readJSValue json of
		Left s -> fail s
		Right j -> case JSONG.fromJSON j of
			JSON.Error s -> fail s
			JSON.Ok x -> return x

fbidFromCookie :: String -> Maybe FBID
fbidFromCookie cookie = do
	let (signatureEncoded, jsonEncoded) = splitCookie cookie
	signature <- B64.decode $ base64pad signatureEncoded
	json <- B64.decode $ base64pad jsonEncoded
	() <- return $ unsafePerformIO $ print "got json"
	() <- return $ unsafePerformIO $ print $ map BS.w2c json
	foo <- decodeFBJson $ map BS.w2c json
	() <- return $ unsafePerformIO $ print "decoded json"
	() <- return $ unsafePerformIO $ print foo
	Nothing

