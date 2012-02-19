module User(load, uid) where

import Control.Monad.Trans.Class (lift)
import qualified Happstack.Server as S

import Facebook.FBID
import qualified Facebook.Config

type User = ()

load :: S.ServerPartT IO User
load = do
	let cookiename = "fbsr_" ++ (show Facebook.Config.appid)
	cookie <- S.lookCookieValue cookiename
	return ()

uid :: User -> FBID
uid _ = 42
