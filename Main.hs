module Main where

import Control.Monad.Trans.Class (lift)
import qualified Happstack.Server as S

import qualified User as U

dispatch :: S.ServerPartT IO String
dispatch = do
	u <- lift U.load
	case u of
		Nothing -> lift $ print "Nothing"
		Just _ -> lift $ print "Just"
	S.ok "hi"

main :: IO ()
main = S.simpleHTTP S.nullConf dispatch
