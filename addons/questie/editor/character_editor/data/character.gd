tool
extends Resource

# the identifier of the character
export(String) var id

# the name for the character item
export(String) var title

# the character name
export(String) var name

# the character surname
export(String) var surname

# the character bio
export(String) var biography

# the character background
export(String) var background

# the character note - used as memo for the use
export(String) var note

# the parent item of this one - used with the editor
export(String) var parent

# check if the character has a game shop
export(bool) var is_vendor

# check if the character is a mob
export(bool) var has_loot

# check if the character has an inventory
export(bool) var has_inventory

# the inventory of the character
export(Array) var inventory

# the shop of the character
export(Array) var shop

# the loot of the character
export(Array) var loot



