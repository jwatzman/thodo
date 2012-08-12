module StaticResource(addCss, addJs, runSR, StaticResource) where

import Control.Monad.State

type SRPair = ([String], [String])
newtype StaticResource a = SR { getSR :: State SRPair a }

instance Monad StaticResource where
	return = SR . return
	(SR a) >>= bgen = SR $ a >>= (getSR . bgen)

addCss :: String -> StaticResource ()
addCss newCss = do
	(css, js) <- SR get
	SR $ put (newCss:css, js)

addJs :: String -> StaticResource ()
addJs newJs = do
	(css, js) <- SR get
	SR $ put (css, newJs:js)

runSR :: StaticResource a -> (a, SRPair)
runSR sr = runState (getSR sr) ([], [])
