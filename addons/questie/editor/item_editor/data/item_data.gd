# The data structure for each game item

#tool
extends Resource

# the item identifier
export(String) var id

# the identifier of the folder owning this item
export(String) var folder_id 

# the identifier of tag for this item
export(String) var tag_id 

# The name of the item which will be displayed in inventory
export(String) var name

# The description of the item
export(String) var description

# The weight for this item
export(float) var weight = 0.1

# The item icon for inventory
export(Texture) var icon

export(bool) var can_be_sold = true

# The purchase price from vendor
export(float) var purchase_price = 50

# The sell price
export(float) var sell_price = 10

