module Page.Home(render) where

import qualified Happstack.Server as S
import qualified Text.Blaze.Html5 as H

import qualified Template.Page
import qualified User

render :: S.ServerPartT IO H.Html
render = do
	user <- User.load
	S.ok $ Template.Page.render "Home" $ H.toHtml $ show $ User.uid user
