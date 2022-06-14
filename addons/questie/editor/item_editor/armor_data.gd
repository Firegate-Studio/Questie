tool
extends "res://addons/questie/editor/item_editor/item_data.gd"

# The value of armoring provided by this item
export(float) var armor

enum ArmorType{
    NONE = -1,
    PHYSIC,             # A kind of armor that can be damaged only by brute-force attacks
    MAGIC               # A kind of armor that cab be damaged only by magic spells (i.e., fire spell)
}

# The type of armor. 
# See [ArmorType] for possible values
export(int) var type