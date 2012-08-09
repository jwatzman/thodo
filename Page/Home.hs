module Page.Home(render) where

import qualified Happstack.Lite as S
import qualified Text.Blaze.Html5 as H

import qualified Template.Page
import qualified User

render :: S.ServerPart S.Response
render = do
	user <- User.load
	S.ok $ S.toResponse $
		Template.Page.render "Home" $ H.toHtml $ show $ User.uid user
