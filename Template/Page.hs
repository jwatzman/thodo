module Template.Page(render) where

import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

render :: String -> H.Html -> H.Html
render title body =
	H.docTypeHtml $ do
		H.head $ do
			H.title $ H.toHtml title
		H.body $ do
			body
