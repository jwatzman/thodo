module User(load, uid) where

type User = ()

load :: IO (Maybe User)
load = return Nothing

uid :: User -> Int
uid _ = 42
