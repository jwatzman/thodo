module Page.Home(render) where

import qualified Happstack.Lite as S
import qualified Text.Blaze.Html5 as H

import qualified Template.Page
import qualified Model.User as U

render :: S.ServerPart S.Response
render = do
	user <- U.load
	S.ok $ S.toResponse $
		Template.Page.render "Home" $ return $ H.toHtml $ show $ U.uid user
