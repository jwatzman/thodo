module Main where

import Control.Monad (msum)
import qualified Happstack.Lite as S
import qualified Text.Blaze.Html5 as H

import qualified Page.Home
import qualified Page.Login

dispatch :: S.ServerPart S.Response
dispatch =
	msum [
		Page.Home.render,
		Page.Login.render
	]

main :: IO ()
main = S.serve Nothing dispatch
