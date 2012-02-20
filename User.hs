module User(load, uid) where

import qualified Happstack.Server as S

import qualified Facebook.Config
import qualified Facebook.Cookie
import Facebook.FBID

type User = ()

load :: S.ServerPartT IO User
load = do
	let cookiename = "fbsr_" ++ (show Facebook.Config.appid)
	cookie <- S.lookCookieValue cookiename
	case Facebook.Cookie.fbidFromCookie cookie of
		Nothing -> fail "Failed to load user"
		Just u -> return ()

uid :: User -> FBID
uid _ = 42
