tool
extends "res://addons/questie/editor/item_editor/item_data.gd"

# A unique item is an item that the player can own only once
export(bool) var is_unique

# The capacity for being used like an armor item
export(bool) var as_armor

# The armor value
export(float) var armor_value

# The armor type
export(int) var armor_type

# The capacity to be used like a weapon item
export(bool) var as_weapon

export(int) var damage_type

export(float) var min_damage

export(float) var max_damage

# The capacity to be used like a consumable item
export(bool) var as_consumable

export(float) var consumable_value