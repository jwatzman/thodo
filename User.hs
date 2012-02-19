module User(load, uid) where

import Facebook.FBID

type User = ()

load :: IO (Maybe User)
load = return Nothing

uid :: User -> FBID
uid _ = 42
