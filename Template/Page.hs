{-# LANGUAGE OverloadedStrings #-}

module Template.Page(render) where

import Control.Monad (mapM_)
import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import qualified StaticResource as SR

render :: String -> SR.StaticResource H.Html -> H.Html
render title body =
	let (bodyMarkup, (css, js)) = SR.runSR body in
	H.docTypeHtml $ do
		H.head $ do
			H.title $ H.toHtml title
			mapM_ renderJs js
			-- TODO: render CSS
		H.body $ do
			bodyMarkup

renderJs :: String -> H.Html
renderJs js = H.script ! (A.src $ H.toValue js) $ ""
