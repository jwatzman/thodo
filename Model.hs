{-# LANGUAGE DeriveDataTypeable, GeneralizedNewtypeDeriving,
	RecordWildCards, TemplateHaskell, OverloadedStrings #-}

module Model (ItemID, Status, Item, TodoList, initialTodoListState) where

import Control.Monad.State (get, put)
import qualified Data.Acid as A
import Data.Data (Data, Typeable)
import qualified Data.IxSet as IxS
import qualified Data.SafeCopy as SC
import Data.Text (Text)

import qualified User

newtype ItemID = ItemID { getItemID :: Integer }
	deriving (Eq, Ord, Data, Enum, Typeable, SC.SafeCopy)

data Status = Incomplete | Complete
	deriving (Eq, Ord, Data, Typeable)
$(SC.deriveSafeCopy 0 'SC.base ''Status)

data Item = Item
	{
		owner :: User.User,
		itemID :: ItemID,
		body :: Text,
		status :: Status
	}
	deriving (Eq, Ord, Data, Typeable)
$(SC.deriveSafeCopy 0 'SC.base ''Item)

instance IxS.Indexable Item where
	empty = IxS.ixSet
		[
			IxS.ixFun $ \i -> [itemID i],
			IxS.ixFun $ \i -> [status i]
		]

data TodoList = TodoList
	{
		nextItemID :: ItemID,
		items :: IxS.IxSet Item
	}
	deriving (Data, Typeable)
$(SC.deriveSafeCopy 0 'SC.base ''TodoList)

initialTodoListState :: TodoList
initialTodoListState = TodoList
	{
		nextItemID = ItemID ((2 ^ 33) + 1),
		items = IxS.empty
	}

newItem :: User.User -> A.Update TodoList Item
newItem u = do
	list@TodoList{..} <- get
	put $ list { nextItemID = succ nextItemID }
	return $ Item
		{
			owner = u,
			itemID = nextItemID,
			body = "New item",
			status = Incomplete
		}

