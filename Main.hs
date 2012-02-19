module Main where

import Control.Monad (msum)
import qualified Happstack.Server as S
import qualified Text.Blaze.Html5 as H

import qualified Page.Home
import qualified Page.Login

dispatch :: S.ServerPartT IO H.Html
dispatch =
	msum [
		Page.Home.render,
		Page.Login.render
	]

main :: IO ()
main = S.simpleHTTP S.nullConf dispatch
