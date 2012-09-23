{-# LANGUAGE DeriveDataTypeable, TemplateHaskell #-}

module Model.TodoList(TodoList(..), initialTodoListState) where

import Data.Data (Data, Typeable)
import qualified Data.IxSet as IxS
import qualified Data.SafeCopy as SC

import qualified Model.Item as I

data TodoList = TodoList
	{
		nextItemID :: I.ItemID,
		items :: IxS.IxSet I.Item
	}
	deriving (Data, Typeable)
$(SC.deriveSafeCopy 0 'SC.base ''TodoList)

initialTodoListState :: TodoList
initialTodoListState = TodoList
	{
		nextItemID = I.ItemID ((2 ^ 33) + 1),
		items = IxS.empty
	}
