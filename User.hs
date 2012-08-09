module User(load, uid) where

import qualified Happstack.Lite as S

import qualified Facebook.Config
import qualified Facebook.Cookie
import Facebook.FBID

type User = FBID

load :: S.ServerPart User
load = do
	let cookiename = "fbsr_" ++ (show Facebook.Config.appid)
	cookie <- S.lookCookieValue cookiename
	case Facebook.Cookie.fbidFromCookie cookie of
		Nothing -> fail "Failed to load user"
		Just u -> return u

uid :: User -> FBID
uid = id
