# The data structure for each game item

#tool
extends Resource

# the item identifier
export(String) var uuid

# The name of the item which will be displayed in inventory
export(String) var title

# The description of the item
export(String) var description

# The weight for this item
export(float) var weight = 0.1

# The item category
# See [QuestDatabase.ItemCategory] for possible values
export(int) var category

# The path of the icon loaded
export(String) var icon_path = ""

# The item icon for inventory
export(Texture) var icon

export(bool) var can_be_sold = true

# The purchase price from vendor
export(float) var purchase_price = 50

# The sell price
export(float) var sell_price = 10

