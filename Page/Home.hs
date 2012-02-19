module Page.Home(render) where

import qualified Happstack.Server as S
import qualified Text.Blaze.Html5 as H

import qualified User

render :: S.ServerPartT IO H.Html
render = do
	user <- User.load
	S.ok $ H.hr
