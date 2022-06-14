# The data structure for each game item

tool
extends Resource

# the item identifier
export(String) var uuid

# The name of the item which will be displayed in inventory
export(String) var title

# The description of the item
export(String) var description

# The item category
# See [QuestDatabase.ItemCategory] for possible values
export(int) var category

# The item icon for inventory
export(Texture) var icon

# The purchase price from vendor
export(float) var vendor = 50

# The sell price
export(float) var sell = 10

