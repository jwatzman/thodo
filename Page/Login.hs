module Page.Login(render) where

import qualified Happstack.Server as S
import qualified Text.Blaze.Html5 as H

import qualified Facebook.Config
import qualified Template.Login

render :: S.ServerPartT IO H.Html
render = S.ok $ Template.Login.render Facebook.Config.appid
