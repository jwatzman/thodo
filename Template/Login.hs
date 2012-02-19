{-# LANGUAGE OverloadedStrings #-}

module Template.Login(render) where

import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import qualified Text.Blaze.Internal as I (HtmlM (Parent))

import Facebook.FBID

loginbutton :: H.Html
loginbutton = I.Parent "fb:login-button" "<fb:login-button" "</fb:login-button>"""

connectjs :: FBID -> String
connectjs appid =
	concat [
		"FB.init({appId: '", show appid, "', status: true, cookie: true, xfbml: true});",
		"FB.Event.subscribe('auth.login', function(_) {window.location.reload();});"
	]

render :: FBID -> H.Html
render appid =
	H.div $ do
		H.div ! A.id "fb-root" $ ""
		loginbutton
		H.script ! A.src "http://connect.facebook.net/en_US/all.js" $ ""
		H.script ! H.customAttribute "language" "javascript" ! H.customAttribute "type" "text/javascript" $ do
			H.preEscapedString $ connectjs appid
