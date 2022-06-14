tool
extends Control

var database

# the tree contianint all items
var items_tree

# A toolbar for all action allowed in item editor (i.e., Create Weapon, Armor, Consumables, ..., etc.)
var toolbar

# @brief					creates a weapon item inside the item tree
func create_weapon():
	
	# Creates data and tree item
	database.push_item(database.ItemCategory.WEAPON)
	var result = items_tree.create_subitem(database.weapons, "res://addons/questie/editor/icons/item.png", items_tree.weapons)

# @brief					creates an armor item inside the item tree
func create_armor():
	
	# Creates data and tree item
	database.push_item(database.ItemCategory.ARMOR)
	var result = items_tree.create_subitem(database.armors, "res://addons/questie/editor/icons/armor.png", items_tree.armors)
	
# @brief					creates a consumable item inside the item tree
func create_consumable():
	
	# Creates data and tree item
	database.push_item(database.ItemCategory.CONSUMABLE)
	var result = items_tree.create_subitem(database.consumables, "res://addons/questie/editor/icons/potion.png", items_tree.consumables)

# @brief					creates a material item inside the item tree
func create_material(): 

	# Creates data and tree item
	database.push_item(database.ItemCategory.MATERIAL)
	var result = items_tree.create_subitem(database.materials, "res://addons/questie/editor/icons/material.png", items_tree.materials)

# @brief 					creates a special item inside the item tree
func create_special(): 
	
	# Creates data and tree item
	database.push_item(database.ItemCategory.SPECIAL)
	var result = items_tree.create_subitem(database.specials, "res://addons/questie/editor/icons/coin.png", items_tree.specials)

# @brief					removes an item from tree and the pointing data of the items database
func delete_item():

	# Get selected item
	var selected = items_tree.get_selected()

	# Check if any item is selected
	if not selected:
		print("[questie]: no item selected!")
		return
	
	# Prepare the UUID to bake data
	var uuid : String = ""
	
	if items_tree.weapon_uuid_map.has(selected.get_instance_id()): 

		# Get UUID from map
		uuid = items_tree.weapon_uuid_map[selected.get_instance_id()]

		# Clean cached data
		database.erase_item(uuid, database.ItemCategory.WEAPON)
		items_tree.remove_subitem(selected, database.ItemCategory.WEAPON, database)
		
	if items_tree.armor_uuid_map.has(selected.get_instance_id()):

		# Get UUID from map
		uuid = items_tree.armor_uuid_map[selected.get_instance_id()]
		
		# Clean cached data
		database.erase_item(uuid, database.ItemCategory.ARMOR)
		items_tree.remove_subitem(selected, database.ItemCategory.ARMOR, database)

	if items_tree.consumable_uuid_map.has(selected.get_instance_id()):

		# Get UUID from map
		uuid = items_tree.consumable_uuid_map[selected.get_instance_id()]

		# Clean cached data
		database.erase_item(uuid, database.ItemCategory.CONSUMABLE)
		items_tree.remove_subitem(selected, database.ItemCategory.CONSUMABLE, database)

	if items_tree.material_uuid_map.has(selected.get_instance_id()):

		# Get UUID from map
		uuid = items_tree.material_uuid_map[selected.get_instance_id()]

		# Clean cached data
		database.erase_item(uuid, database.ItemCategory.MATERIAL)
		items_tree.remove_subitem(selected, database.ItemCategory.MATERIAL, database)

	if items_tree.special_uuid_map.has(selected.get_instance_id()):

		# Get UUID from map
		uuid = items_tree.special_uuid_map[selected.get_instance_id()]

		# Clean cached data
		database.erase_item(uuid, database.ItemCategory.SPECIAL)
		items_tree.remove_subitem(selected, database.ItemCategory.SPECIAL, database)

func _enter_tree():

	# Load database
	database = load("res://questie/item-db.tres")

	# Get references from interface
	toolbar = get_node("VBoxContainer/Toolbar")
	items_tree = get_node("VBoxContainer/HSplitContainer/ItemTree/ScrollContainer/Tree")

	# Subscribe toolbar events
	toolbar.connect("new_weapon_item_request", self, "create_weapon")
	toolbar.connect("new_armor_item_request", self, "create_armor")
	toolbar.connect("new_consumable_item_request", self, "create_consumable")
	toolbar.connect("new_material_item_request", self, "create_material")
	toolbar.connect("new_special_item_request", self, "create_special")
	toolbar.connect("delete_item_request", self, "delete_item")

func _exit_tree():

	# Unsubscribe toolbar events
	toolbar.disconnect("new_weapon_item_request", self, "create_weapon")
	toolbar.disconnect("new_armor_item_request", self, "create_armor")
	toolbar.disconnect("new_consumable_item_request", self, "create_consumable")
	toolbar.disconnect("new_material_item_request", self, "create_material")
	toolbar.disconnect("new_special_item_request", self, "create_special")
	toolbar.disconnect("delete_item_request", self, "delete_item")

