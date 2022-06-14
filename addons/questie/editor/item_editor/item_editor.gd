tool
extends Control

var database

# the tree contianint all items
var items_tree

# A toolbar for all action allowed in item editor (i.e., Create Weapon, Armor, Consumables, ..., etc.)
var toolbar

# An empty area that displays a message as placehodler for any workspace
var empty_area

# The interface containing the weapon data
var weapon_editor

# The interface containing the armor data
var armor_editor

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

	unselect_tree_item()

# @brief					Display the correct workspace by item selection and loads data from database
func tree_item_selected():

	# Close all workspaces
	unselect_tree_item()

	# Get selected item IID
	var selected = items_tree.get_selected().get_instance_id()

	# Check if the selected item is a weapon
	if items_tree.weapon_uuid_map.has(selected):

		# Get weapon UUID
		var uuid = items_tree.weapon_uuid_map[items_tree.get_selected().get_instance_id()]

		# Preapare data to bake
		var data = null

		# Get data
		for item in database.weapons:

			# Ignore invalid UUIDs
			if not item.uuid == uuid: continue

			data = item
			break

		# Load weapon data
		weapon_editor.title.text = data.title
		weapon_editor.description.text = data.description
		weapon_editor.icon.text = data.icon_path
		weapon_editor.damage_type.text = weapon_editor.damage_type.get_popup().get_item_text(data.damage_type)
		weapon_editor.min_damage.value = data.min_damage
		weapon_editor.max_damage.value = data.max_damage
		weapon_editor.can_be_sold.pressed = data.can_be_sold
		weapon_editor.purchase_price.value = data.purchase_price
		weapon_editor.sell_price.value = data.sell_price
		print("[questie]: weapon item with [uuid]: " + uuid + " loaded")

		# Swap interfaces
		empty_area.hide()
		weapon_editor.show()

	# Check if the selected item is an armor
	if items_tree.armor_uuid_map.has(selected):

		# Get armor UUID
		var uuid = items_tree.armor_uuid_map[selected]

		# Prepare data to bake from database
		var data = null

		# Get data from database
		for item in database.armors:

			# Ignore invalid UUIDs
			if not item.uuid == uuid: continue

			# Bake data
			data = item
			
			break

		# Load data to display in armor workspace
		armor_editor.title.text = data.title
		armor_editor.description.text = data.description
		armor_editor.icon_path.text = data.icon_path
		if not data.icon_path == "": armor_editor.icon_preview.set_texture(load(data.icon_path))
		else: armor_editor.icon_preview.set_texture(null)
		armor_editor.armor.value = data.armor
		armor_editor.armor_type.text = armor_editor.armor_type.get_popup().get_item_text(data.type)
		armor_editor.can_be_sold.pressed = data.can_be_sold
		armor_editor.purchase_price.value = data.purchase_price
		armor_editor.sell_price.value = data.sell_price
		print("[questie]: armor data with [UUID]: " + uuid + " loaded")

		# Swap interfaces to show workspace
		empty_area.hide()
		armor_editor.show()

# @brief				Deselect the current selected item and swap interfaces
func unselect_tree_item():

	# Swap interfaces
	weapon_editor.hide()
	armor_editor.hide()
	empty_area.show()

################################################################################################################

# @brief				update the name for both weapon data and tree item
# @param title			the changed name as String
func weapon_name_changed(var title):
	
	# Get weapon UUID
	var uuid = items_tree.weapon_uuid_map[items_tree.get_selected().get_instance_id()]

	# Prepare weapon data
	var data : String = ""

	# Retrive weapon data from database
	for item in database.weapons:

		# Ignore different UUIDs
		if not item.uuid == uuid : continue

		# Change title
		item.title = title

		# Update tree item name
		items_tree.get_selected().set_text(0, title)
		return

	# Log error
	print("[questie]: can't update title for weapon with [UUID]: "+uuid)

# @brief				update the weapon description
func weapon_description_changed():

	# Get weapon UUID
	var uuid = items_tree.weapon_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve weapon data from database
	for item in database.weapons:

		# Ignore different UUIDs
		if not item.uuid == uuid: continue
		
		# Update description
		item.description = weapon_editor.description.text

		return

	# Log error
	print("[questie]: can't update weapon description for weapon with [UUID]:" + uuid)

# @brief				update weapon damage type
func weapon_damage_changed(var id):

	# Get weapon UUID
	var uuid = items_tree.weapon_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve weapon data
	for item in database.weapons:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update damage type
		item.damage_type = id
		weapon_editor.damage_type.text = weapon_editor.damage_type.get_popup().get_item_text(id)

		return

	# Log error
	print("[questie]: can't update weapon damage type")

# @brief				update the min damage dealt from a weapon
# @param value			the new value
func weapon_min_damage_changed(var value):

	# Get weapon UUID
	var uuid = items_tree.weapon_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve weapon data from database
	for item in database.weapons:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update damage
		item.min_damage = value
		
		# Log changes
		print("[questie]: weapon min damage changed to " + var2str(value))

		return
	
	# Log error
	print("[questie]: can't update the weapon min value")

# @brief				update the max damage dealt from a weapon
# @param value			the new value
func weapon_max_damage_changed(var value):

	# Get weapon UUID
	var uuid = items_tree.weapon_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve weapon data from database
	for item in database.weapons:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update damage
		item.max_damage = value

		# Log changes
		print("[questie]: weapon max damage changed to " + var2str(value))

		return
	
	# Log error
	print("[questie]: can't update the weapon max value")

# @brief				update sellability setting
# @param enabled		if true the item can be sold to a vendor
func weapon_sellable_changed(var enabled : bool):

	# Get weapo UUID
	var uuid = items_tree.weapon_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrive weapon data
	for item in database.weapons:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data
		item.can_be_sold = enabled

		return

	# Log error
	print("[questie]: can't update sellable option for weapon data with [uuid]: "+uuid)

# @brief				update purchase price for weapon item
# @param value			the new value
func weapon_purchase_price_changed(var value):

	# Get weapo UUID
	var uuid = items_tree.weapon_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrive weapon data
	for item in database.weapons:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data
		item.purchase_price = value

		# Log changes
		print("[questie]: weapon purchase price changed to " + var2str(value))

		return

	# Log error
	print("[questie]: can't update purchase price for weapon data with [uuid]: "+uuid)

# @brief 				update sell price for weapon item
# @param value			the new value
func weapon_sell_price_changed(var value):

	# Get weapo UUID
	var uuid = items_tree.weapon_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrive weapon data
	for item in database.weapons:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data
		item.sell_price = value

		# Log changes
		print("[questie]: weapon sell price changed to " + var2str(value))

		return

	# Log error
	print("[questie]: can't update sellable option for weapon data with [uuid]: "+uuid)

# @brief				update the weapon icon and path
func weapon_icon_changed(var path):

	# Get weapon UUID
	var uuid = items_tree.weapon_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve weapon data from database
	for item in database.weapons:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Skip if invalid path
		if not ".png" in path: return

		# Prepare icon
		var icon = load(path)

		# Check if icon is invalid
		if not icon: 
			
			# Log error
			print("[questie]: unable to load icon at path: " + path)
			return

		# Load icon in weapon data
		item.icon = icon
		item.icon_path = path

		# Log new icon
		print("[questie]: stored icon with path " + path)

		return

	# Log error
	print("[questie]: can't find valid weapon data to store icon with [uuid]: " + uuid)

######################################################################################################################################################################################################

# @brief					update the armor name for both database data and tree item
# @param title				the new name
func armor_name_changed(var title):

	# Get selected item
	var selected = items_tree.get_selected().get_instance_id()

	# Get armor UUID
	var uuid = items_tree.armor_uuid_map[selected]

	# Retrive armor from database
	for item in database.armors:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update armor name
		item.title = title

		# Update armor tree item
		items_tree.get_selected().set_text(0, title)

		return

	# Log error
	print("[questie]: can't update armor name with [uuid]: " + uuid)

# @brief					update armor description in database
func armor_description_changed():

	# Get selected item
	var selected = items_tree.get_selected().get_instance_id()

	# Get armor UUID
	var uuid = items_tree.armor_uuid_map[selected]

	# Retrive armor from database
	for item in database.armors:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update armor description
		item.description = armor_editor.description.text

		return

	# Log error
	print("[questie]: can't update armor description with [uuid]: " + uuid)

# @brief 					update the icon path and workspace preview
# @param path				the updated path
func armor_icon_changed(var path):

	# Get selected item
	var selected = items_tree.get_selected().get_instance_id()

	# Get armor UUID
	var uuid = items_tree.armor_uuid_map[selected]

	# Retrive armor from database
	for item in database.armors:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Check if path is valid
		if not ".png" in path: return
		
		# prepare texture to preview
		var icon = load(path)
		if not icon:
			
			# Log invalid icon
			print("[questie]: can't load texture at path: " + path)

			return

		# Update path and preview
		item.icon_path = path
		item.icon = icon
		armor_editor.icon_preview.set_texture(icon)

		# Log
		print("[questie]: armor icon loaded from path: " + path)

		return

	# Log error
	print("[questie]: can't update armor icon with [uuid]: " + uuid)		
		
# @brief					update the armor value
# @param value				the new armor value
func armor_value_changed(var value):

	# Get selected item
	var selected = items_tree.get_selected().get_instance_id()

	# Get armor UUID
	var uuid = items_tree.armor_uuid_map[selected]
	
	# Retrive armor from database
	for item in database.armors:
	
		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue
	
		# Update armor value
		item.armor = value
	
		# Log
		print("[questie]: armor value set to " + var2str(value) + " for armor with [UUID]: " + uuid)

		return
	
	# Log error
	print("[questie]: can't update armor value with [uuid]: " + uuid)

# @brief					update the armor type
# @param id					the new armor type. See [ArmorType] for possible values
func armor_type_changed(var id):
	
	# Get selected item
	var selected = items_tree.get_selected().get_instance_id()

	# Get armor UUID
	var uuid = items_tree.armor_uuid_map[selected]

	# Retrive armor from database
	for item in database.armors:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update armor type for database and workspace
		item.type = id
		armor_editor.armor_type.text = armor_editor.armor_type.get_popup().get_item_text(id)

		# Log
		print("[questie]: armor type updated with the value " + var2str(id))

		return

	# Log error
	print("[questie]: can't update armor description with [uuid]: " + uuid)

# @brief 					update the capacity to sell an item to a vendor
# @param enabled			the new sellability
func armor_sellable_changed(var enabled):
	
	# Get selected item
	var selected = items_tree.get_selected().get_instance_id()

	# Get armor UUID
	var uuid = items_tree.armor_uuid_map[selected]

	# Retrive armor from database
	for item in database.armors:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update armor proficiency to sell item to a vendor
		item.can_be_sold = enabled
		
		# Log
		print("[questie]: set armor sellability to " + var2str(enabled) + " for armor with [UUID]: " + uuid)

		return

	# Log error
	print("[questie]: can't update armor description with [uuid]: " + uuid)

# @brief					update the armor purchase price 
# @param value				the new purchase price
func armor_purchase_price_changed(var value):
	
	# Get selected item
	var selected = items_tree.get_selected().get_instance_id()

	# Get armor UUID
	var uuid = items_tree.armor_uuid_map[selected]

	# Retrive armor from database
	for item in database.armors:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update armor purchase price
		item.purchase_price = value

		# Log
		print("[questie]: armor purchase price set to " + var2str(value) + " for armor with [UUID]: " + uuid)

		return

	# Log error
	print("[questie]: can't update armor purchase price with [uuid]: " + uuid)

# @brief					update armor sell price
# @param value				the new sell price
func armor_sell_price_changed(var value):

	# Get selected item
	var selected = items_tree.get_selected().get_instance_id()

	# Get armor UUID
	var uuid = items_tree.armor_uuid_map[selected]

	# Retrive armor from database
	for item in database.armors:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update armor purchase price
		item.sell_price = value

		# Log
		print("[questie]: armor sell price set to " + var2str(value) + " for armor with [UUID]: " + uuid)

		return

	# Log error
	print("[questie]: can't update armor purchase price with [uuid]: " + uuid)

####################################################################################################################################################################################################

func _ready():

	# Load database
	database = load("res://questie/item-db.tres")

	# Get references from interface
	toolbar = get_node("VBoxContainer/Toolbar")
	items_tree = get_node("VBoxContainer/HSplitContainer/ItemTree/ScrollContainer/Tree")
	empty_area = $VBoxContainer/HSplitContainer/Empty
	weapon_editor = $"VBoxContainer/HSplitContainer/Weapon Editor"
	armor_editor = $"VBoxContainer/HSplitContainer/Armor Editor"

	# Subscribe toolbar events
	toolbar.connect("new_weapon_item_request", self, "create_weapon")
	toolbar.connect("new_armor_item_request", self, "create_armor")
	toolbar.connect("new_consumable_item_request", self, "create_consumable")
	toolbar.connect("new_material_item_request", self, "create_material")
	toolbar.connect("new_special_item_request", self, "create_special")
	toolbar.connect("delete_item_request", self, "delete_item")

	# Subscribe item tree events
	items_tree.connect("item_selected", self, "tree_item_selected")
	items_tree.connect("nothing_selected", self, "unselect_tree_item")

	# Subscribe weapon editor events
	weapon_editor.title.connect("text_changed", self, "weapon_name_changed")
	weapon_editor.description.connect("text_changed", self, "weapon_description_changed")
	weapon_editor.damage_type.get_popup().connect("id_pressed", self, "weapon_damage_changed")
	weapon_editor.min_damage.connect("value_changed", self, "weapon_min_damage_changed")
	weapon_editor.max_damage.connect("value_changed", self, "weapon_max_damage_changed")
	weapon_editor.can_be_sold.connect("toggled", self, "weapon_sellable_changed")
	weapon_editor.purchase_price.connect("value_changed", self, "weapon_purchase_price_changed")
	weapon_editor.sell_price.connect("value_changed", self, "weapon_sell_price_changed")
	weapon_editor.icon.connect("text_changed", self, "weapon_icon_changed")

	# Subscribe armor editor events
	armor_editor.title.connect("text_changed", self, "armor_name_changed")
	armor_editor.description.connect("text_changed", self, "armor_description_changed")
	armor_editor.icon_path.connect("text_changed", self, "armor_icon_changed")
	armor_editor.armor.connect("value_changed", self, "armor_value_changed")
	armor_editor.armor_type.get_popup().connect("id_pressed", self, "armor_type_changed")
	armor_editor.can_be_sold.connect("toggled", self, "armor_sellable_changed")
	armor_editor.purchase_price.connect("value_changed", self, "armor_purchase_price_changed")
	armor_editor.sell_price.connect("value_changed", self, "armor_sell_price_changed")


