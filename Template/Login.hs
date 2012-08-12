{-# LANGUAGE OverloadedStrings #-}

module Template.Login(render) where

import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import qualified Text.Blaze.Internal as I

import qualified Facebook.Config
import Facebook.FBID
import qualified StaticResource as SR

loginbutton :: H.Html
loginbutton = I.Parent "fb:login-button" "<fb:login-button" "</fb:login-button>"""

connectjs :: String
connectjs =
	concat [
		"FB.init({appId: '", show Facebook.Config.appid, "', status: true, cookie: true, xfbml: true});",
		"FB.Event.subscribe('auth.login', function(_) {window.location.reload();});"
	]

render :: SR.StaticResource H.Html
render = do
	SR.addJs "http://connect.facebook.net/en_US/all.js"
	return $ H.div $ do
		H.div ! A.id "fb-root" $ ""
		loginbutton
		H.script ! H.customAttribute "language" "javascript" ! H.customAttribute "type" "text/javascript" $ do
			I.preEscapedString connectjs
