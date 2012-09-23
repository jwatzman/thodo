{-# LANGUAGE RecordWildCards, OverloadedStrings #-}

module Model.Mutators(newItem) where

import Control.Monad.State (get, put)
import qualified Data.Acid as A
-- import qualified Data.IxSet as IxS
import Data.Text (Text)

import qualified Model.Item as I
import qualified Model.TodoList as L
import qualified Model.User as U

newItem :: U.User -> A.Update L.TodoList I.Item
newItem u = do
	list@L.TodoList{..} <- get
	put $ list { L.nextItemID = succ nextItemID }
	return $ I.Item
		{
			owner = u,
			itemID = nextItemID,
			body = "New item",
			status = I.Incomplete
		}

