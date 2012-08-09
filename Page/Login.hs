module Page.Login(render) where

import qualified Happstack.Lite as S
import qualified Text.Blaze.Html5 as H

import qualified Facebook.Config
import qualified Template.Login
import qualified Template.Page

render :: S.ServerPart S.Response
render = S.ok $ S.toResponse $
	Template.Page.render "Log In" $
		Template.Login.render Facebook.Config.appid
