module Facebook.Cookie(fbidFromCookie) where

import qualified Codec.Binary.Base64Url as B64(decode)
import Data.ByteString.Internal as BS(w2c)
import System.IO.Unsafe (unsafePerformIO)

import Facebook.FBID

base64pad :: String -> String
base64pad str =
	let
		n = 4
		padlen = n - (length str `mod` n)
	in
		if padlen == n then str else str ++ (replicate padlen '=')

fbidFromCookie :: String -> Maybe FBID
fbidFromCookie cookie = do
	let (signatureEncoded, jsonEncoded) =
		(\(x,y) -> (x, drop 1 y)) (break ((==) '.') cookie)
	() <- return $ unsafePerformIO $ print "before"
	signature <- B64.decode $ base64pad signatureEncoded
	() <- return $ unsafePerformIO $ print "got signature"
	json <- B64.decode $ base64pad jsonEncoded
	() <- return $ unsafePerformIO $ print "got json"
	() <- return $ unsafePerformIO $ print $ map BS.w2c json
	Nothing

