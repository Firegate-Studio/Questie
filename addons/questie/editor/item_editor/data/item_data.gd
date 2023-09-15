# The data structure for each game item

#tool
extends Resource

# the item identifier
export(String) var id

# the identifier of the folder owning this item
export(String) var folder_id 

# the identifier of tag for this item
export(String) var tag_id 

# The name of the item
export(String) var name

# the name of the item which will be displayed in game inventory
export(String) var display_name = "fill display name"

# the alignment of the item - i.e., evil staff, wand of the greater good, ..., etc.
export(float) var alignment

# define if this item is unique (i.e., The Might Ring)
export(bool) var is_unique = false

# The description of the item
export(String) var description = "fill item description"

# The weight for this item
export(float) var weight = 0.1

export(String) var icon_path = "res://YOUR_ICON_PATH"

# The item icon for inventory
export(Texture) var icon

export(float) var min_damage = 0.0
export(float) var max_damage = 0.0

export(float) var min_defense = 0.0
export(float) var max_defense = 0.0

export(float) var min_healing = 0.0
export(float) var max_healing = 0.0

export(float) var min_custom = 0.0
export(float) var max_custom = 0.0

export(bool) var can_be_sold = true

export(float) var original_price = 0.0

# The purchase price from vendor
export(float) var purchase_price = 0

# The sell price
export(float) var sell_price = 0

