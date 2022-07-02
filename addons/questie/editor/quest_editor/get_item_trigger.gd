class_name Trigger_GetItem
extends Resource

# The UUID of this trigger
export(String) var uuid = UUID.generate()

# The UUID of the quest owning this trigger
export(String) var trigger_owner

# The uuid of the item to track into player inventory
export(String) var item_uuid

# The category of the tracked item
export(ItemDatabase.ItemCategory) var item_category

