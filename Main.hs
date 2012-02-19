module Main where

import Control.Monad.Trans.Class (lift)
import qualified Happstack.Server as S
import qualified Text.Blaze.Html5 as H

import qualified Template.Page
import qualified User

dispatch :: S.ServerPartT IO H.Html
dispatch = do
	u <- lift User.load
	case u of
		Nothing -> lift $ print "Nothing"
		Just _ -> lift $ print "Just"
	S.ok $ Template.Page.render "hi" H.hr

main :: IO ()
main = S.simpleHTTP S.nullConf dispatch
