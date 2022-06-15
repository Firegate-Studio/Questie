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

# The interface contaniing the consumable data
var consumable_editor

# the interface containing the material data
var material_editor

# the interface containing the special item data
var special_editor

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

			# Load weapon data
			weapon_editor.title.text = item.title
			weapon_editor.description.text = item.description
			weapon_editor.icon.text = item.icon_path
			weapon_editor.damage_type.text = weapon_editor.damage_type.get_popup().get_item_text(item.damage_type)
			weapon_editor.min_damage.value = item.min_damage
			weapon_editor.max_damage.value = item.max_damage
			weapon_editor.can_be_sold.pressed = item.can_be_sold
			weapon_editor.purchase_price.value = item.purchase_price
			weapon_editor.sell_price.value = item.sell_price
			print("[questie]: weapon item with [uuid]: " + uuid + " loaded")
			
			break

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

		return
	
	# Check if the selected item is a consumable
	if items_tree.consumable_uuid_map.has(selected):

		# Get consumable UUID
		var uuid = items_tree.consumable_uuid_map[selected]

		# Prepare data to bake from database
		var data = null

		# Get consumable data
		for item in database.consumables:

			# Ignore invalid UUIDs
			if not item.uuid == uuid: continue

			# Get data
			data = item

			break

		# Load data from database
		consumable_editor.title.text = data.title
		consumable_editor.description.text = data.description
		consumable_editor.icon_path = data.icon_path

		if not data.icon_path == "": consumable_editor.icon_preview.set_texture(data.icon)
		else: consumable_editor.icon_preview.set_texture(null)

		consumable_editor.can_be_sold.pressed = data.can_be_sold
		consumable_editor.purchase_price.value = data.purchase_price
		consumable_editor.sell_price.value = data.sell_price

		consumable_editor.value = data.value

		# Swap interfaces
		empty_area.hide()
		consumable_editor.show()
			
	# Check if selected item is a material
	if items_tree.material_uuid_map.has(selected):

		# Get material UUID
		var uuid = items_tree.material_uuid_map[selected]

		# Prepare data to bake
		var data = null

		# Retrieve material data from database
		for item in database.materials:

			# Ignore invalid UUIDs
			if not item.uuid == uuid: continue

			# Get data
			data = item

			break

		# Check if data is not valid
		if not data:

			# Log error
			print("[questie]: invalid data for material item with [uuid]: " + uuid)

			return

		# Load material data
		material_editor.title.text = data.title
		material_editor.description.text = data.description
		material_editor.icon_path.text = data.icon_path
		
		if not data.icon: material_editor.icon_preview.set_texture(null)
		else: material_editor.icon_preview.set_texture(data.icon)

		material_editor.can_be_sold.pressed = data.can_be_sold
		material_editor.purchase_price.value = data.purchase_price
		material_editor.sell_price.value = data.sell_price

		# Log
		print("[questie]: loaded data for material item with [uuid]: " + uuid)

		# Swap workspaces
		empty_area.hide()
		material_editor.show()
	
	# Check if selected item is special
	if items_tree.special_uuid_map.has(selected):

		# Get special item UUID
		var uuid = items_tree.special_uuid_map[selected]

		# Prepare data to bake
		var data = null

		# Retrieve special item data
		for item in database.specials:

			# Ignore invalid UUIDs
			if not item.uuid == uuid: continue

			# Get data
			data = item

			break
		
		# Load data from database
		special_editor.title.text = data.title
		special_editor.description.text = data.description
		
		special_editor.icon_path.text = data.icon_path
		if not data.icon: 
			special_editor.icon_preview.set_texture(null)
		else:
			special_editor.icon_preview.set_texture(data.icon)

		special_editor.can_be_sold.pressed = data.can_be_sold
		special_editor.purchase_price.value = data.purchase_price
		special_editor.sell_price.value = data.sell_price

		special_editor.as_weapon.pressed = data.as_weapon
		special_editor.damage_type.text = special_editor.damage_type.get_popup().get_item_text(data.armor_type)
		special_editor.min_damage.value = data.min_damage
		special_editor.max_damage.value = data.max_damage

		special_editor.as_armor.pressed = data.as_armor
		special_editor.armor_type.text = special_editor.armor_type.get_popup().get_item_text(data.armor_type)
		special_editor.armor_value.value = data.armor_value

		special_editor.as_consumable.pressed = data.as_consumable
		special_editor.consumable_value.value = data.consumable_value

		special_editor.is_unique.pressed = data.is_unique

		# Log
		print("[questie]: special editor loaded for item with [uuid]: " + uuid)

		# Swap workspaces
		empty_area.hide()
		special_editor.show()

# @brief				Deselect the current selected item and swap interfaces
func unselect_tree_item():

	# Swap interfaces
	weapon_editor.hide()
	armor_editor.hide()
	consumable_editor.hide()
	material_editor.hide()
	special_editor.hide()
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

# @brief					update consumable name
# @param title				the new name
func consumable_name_changed(var title):

	# Get consumable UUID
	var uuid = items_tree.consumable_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve data
	for item in database.consumables:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data and tree item
		item.title = title
		items_tree.get_selected().set_text(0, title)

		# Log
		print("[questie]: consumable name updated for consumable item with [UUID]: " + uuid)

		return

	# Log error
	print("[questie]: can't update consumable title for consumable with [UUID]: " + uuid)

# @brief				update consumable description
func consumable_description_changed():

	# Get consumable UUID
	var uuid = items_tree.consumable_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve data
	for item in database.consumables:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data
		item.description = consumable_editor.description.text

		# Log
		print("[questie]: consumable description updated for consumable item with [UUID]: " + uuid)

		return

	# Log error
	print("[questie]: can't update consumable description for consumable with [UUID]: " + uuid)

# @brief				update consumable icon
# @param path			the new path to icon
func consumable_icon_changed(var path):
	
	# Get consumable UUID
	var uuid = items_tree.consumable_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve data
	for item in database.consumables:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Check if path is valid
		if not ".png" in path: continue

		# Check if icon is valid
		var icon = load(path)
		if not icon:

			# Log icon error
			print("[questie]: can't load icon from path " + path + " for consumable item with [UUID]: " + uuid)
			
			return

		# Update path and editor preview
		item.icon_path = path
		item.icon = icon
		consumable_editor.icon_preview.set_texture(icon)

		# Log
		print("[questie]: consumable icon set to " + path + " for consumable item with [UUID]: " + uuid)

		return
		
# @brief				update consumable sellability capacity
# @param enabled		the sellability value
func consumable_sellability_changed(var enabled):
	
	# Get consumable UUID
	var uuid = items_tree.consumable_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve data
	for item in database.consumables:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data
		item.can_be_sold = enabled

		# Log
		print("[questie]: consumable sellability set to " + var2str(enabled) + " for consumable item with [UUID]: " + uuid)

		return

	# Log error
	print("[questie]: can't update consumable sellability for consumable with [UUID]: " + uuid)

# @brief				update consumable purchase price
# @param price			the new purhase price
func consumable_purchase_price_changed(var price):
	
	# Get consumable UUID
	var uuid = items_tree.consumable_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve data
	for item in database.consumables:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data
		item.purchase_price = price

		# Log
		print("[questie]: consumable purchase price set to " + var2str(price) + " for consumable item with [UUID]: " + uuid)

		return

	# Log error
	print("[questie]: can't update consumable purchase price for consumable item with [UUID]: " + uuid)

# @brief				update consumable sell price
# @param price			the new sell price
func consumable_sell_price_changed(var price):
	
	# Get consumable UUID
	var uuid = items_tree.consumable_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve data
	for item in database.consumables:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data
		item.sell_price = price

		# Log
		print("[questie]: consumable sell price set to " + var2str(price) + " for consumable item with [UUID]: " + uuid)

		return

	# Log error
	print("[questie]: can't update consumable sell price for consumable item with [UUID]: " + uuid)

# @brief				update consumable value
# @param value			the new consumable value
func consumable_value_changed(var value):
	
	# Get consumable UUID
	var uuid = items_tree.consumable_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve data
	for item in database.consumables:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data
		item.value = value

		# Log
		print("[questie]: consumable value set to " + var2str(value) + " for consumable item with [UUID]: " + uuid)

		return

	# Log error
	print("[questie]: can't update consumable value for consumable item with [UUID]: " + uuid)

#################################################################################################################

# @brief				update material name
# @param title 			the new material name
func material_name_changed(var title):

	# Get material UUID
	var uuid = items_tree.material_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve data from database
	for item in database.materials:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data
		item.title = title
		items_tree.get_selected().set_text(0, title)

		# Log
		print("[questie]: updated name for material item with [uuid]: " + uuid)

		return
	
	# Log error
	print("[questie]: unable to set a new name for material item with [uuid]: " + uuid)

# @brief				update material description
func material_description_changed():
	
	# Get material UUID
	var uuid = items_tree.material_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve data from database
	for item in database.materials:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data
		item.description = material_editor.description.text

		# Log
		print("[questie]: updated description for material item with [uuid]: " + uuid)

		return
	
	# Log error
	print("[questie]: unable to set a new description for material item with [uuid]: " + uuid)

# @brief				update material icon
# @param path			the new icon path
func material_icon_changed(var path):

	# Get material UUID
	var uuid = items_tree.material_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve data from database
	for item in database.materials:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Check if path is valid
		if not ".png" in path: continue

		# Prepare icon for editor preview
		var icon = load(path)

		# Check if icon is valid
		if not icon:

			# Log error
			print("[questie]: can't load icon at path " + path + " for the material item with [uuid]: " + uuid)

			return

		# Update data
		item.icon = icon
		item.icon_path = path
		material_editor.icon_preview.set_texture(icon)

		# Log 
		print("[questie]: updated icon from path " + path + " for material item with [uuid]: " + uuid)

		return
	
	# Log error - disbaled for smart logging
	#print("[questie]: unable to set a new icon from path" + path + " for material item with [uuid]: " + uuid)

# @brief				update material sellability capacity
# @param enabled		the new sellability capacity
func material_sellability_changed(var enabled):

	# Get material UUID
	var uuid = items_tree.material_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve data from database
	for item in database.materials:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data
		item.can_be_sold = enabled

		# Log
		print("[questie]: set sellability to " + var2str(enabled) + " for material item with [uuid]: " + uuid)

		return
	
	# Log error
	print("[questie]: unable to set a sellability for material item with [uuid]: " + uuid)

# @brief				update material purchase price
# @param price			the new purchase price
func material_purchase_price_changed(var price):

	# Get material UUID
	var uuid = items_tree.material_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve data from database
	for item in database.materials:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data
		item.purchase_price = price

		# Log
		print("[questie]: set purcahse price to "+ var2str(price) + " for material item with [uuid]: " + uuid)

		return
	
	# Log error
	print("[questie]: unable to set a new purchase price for material item with [uuid]: " + uuid)

# @brief				update material sell price
# @param price			the new sell price
func material_sell_price_changed(var price):

	# Get material UUID
	var uuid = items_tree.material_uuid_map[items_tree.get_selected().get_instance_id()]

	# Retrieve data from database
	for item in database.materials:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		# Update data
		item.sell_price = price

		# Log
		print("[questie]: set sell price to " + var2str(price) + " for material item with [uuid]: " + uuid)

		return
	
	# Log error
	print("[questie]: unable to set a new sell price for material item with [uuid]: " + uuid)

#################################################################################################################

# @brief				update the special name
# @param title			the new special item name
func special_name_changed(var title):

	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.title = title
	items_tree.get_selected().set_text(0, title)
	print("[questie]: updated item name for special item with [uuid]: " + uuid)

# @brief				update description for special item
func special_description_changed():
	
	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.description = special_editor.description.text
	print("[questie]: updated item description for special item with [uuid]: " + uuid)

# @brief 				update special icon
# @param path			the new icon path
func special_icon_changed(var path):
	
	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Check path validation
	if not ".png" in path: return

	# Prepare icon
	var icon = load(path)
	if not icon:

		# Log error
		print("[questie]: can't load data at path " + path + " for special item with [uuid]: " + uuid)

		return

	# Update data
	data.icon_path = path
	data.icon = icon
	special_editor.icon_preview.set_texture(icon)
	print("[questie]: set icon to " + path + " for special item with [uuid]: " + uuid)

# @brief 				update special item sellabity
# @param enabled		the new sellabilty
func special_sellability_changed(var enabled):

	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.can_be_sold = enabled
	print("[questie]: set sellabity to " + var2str(enabled) + " for special item with [uuid]: " + uuid)

# @brief				update purchase price for special item
# @param price			the new price
func special_purchase_price_changed(var price):
	
	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.purchase_price = price
	print("[questie]: set purchase price to " + var2str(price) + " for special item with [uuid]: " + uuid)

# @brief				update sell price for special item
# @param price			the new price
func special_sell_price_changed(var price):
	
	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.sell_price = price
	print("[questie]: set sell price to " + var2str(price) + " for special item with [uuid]: " + uuid)

# @brief				update weapon casting for special item
# @param enabled		if true this item will be used just like a weapon
func special_weapon_changed(var enabled):

	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.as_weapon = enabled
	print("[questie]: set as_weapon to " + var2str(enabled) + " for special item with [uuid]: " + uuid)

# @brief				update damage type for special item
# @param id				the new damage type identifier
func special_damage_type_changed(var id):

	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.damage_type = id
	print("[questie]: set damage type to " + var2str(special_editor.damage_type.get_popup().get_item_text(id)) + " for special item with [uuid]: " + uuid)

# @brief				update minimum damage for special item
# @param dmg			the new damage
func special_min_damage_changed(var dmg):

	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.min_damage = dmg
	print("[questie]: set min_damage to " + var2str(dmg) + " for special item with [uuid]: " + uuid)

# @brief				update max damage for special item
# @param dmg			the new damage
func special_max_damage_changed(var dmg):

	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.max_damage = dmg
	print("[questie]: set max_damage to " + var2str(dmg) + " for special item with [uuid]: " + uuid)

# @brief				update armor cast for special item
# @param enabled		if true this item will be used just like an armor item
func special_armor_changed(var enabled):

	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.as_armor = enabled
	print("[questie]: set as_armor to " + var2str(enabled) + " for special item with [uuid]: " + uuid)
	
# @brief				update armor type for special item
# @param id				the new armor type identifier
func special_armor_type_changed(var id):

	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.armor_type = id
	print("[questie]: set armor_type to " + var2str(special_editor.armor_type.get_popup().get_item_text(id)) + " for special item with [uuid]: " + uuid)

# @brief				update armor value for special item
# @param armor			the new armor value
func special_armor_value_changed(var armor):

	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.armor_value = armor
	print("[questie]: set armor to " + var2str(armor) + " for special item with [uuid]: " + uuid)

# @brief				update consumable casting for special item
# @param enabled		if true this item will be used just like a consumable item		
func special_consumable_changed(var enabled):

	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.as_consumable = enabled
	print("[questie]: set as_consumable to " + var2str(enabled) + " for special item with [uuid]: " + uuid)

# @brief				update consumable value for special item
# @param value			the new consumable item
func special_consumable_value_changed(var value):

	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.consumable_value = value
	print("[questie]: set consumable_value to " + var2str(value) + " for special item with [uuid]: " + uuid)

# @brief				update unique tag for special item
# @param enabled		if true this item will be unique
func special_unique_changed(var enabled):

	# Get special item UUID
	var uuid = items_tree.special_uuid_map[items_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.find_data(uuid, database.ItemCategory.SPECIAL)

	# Check if data is valid
	if not data:

		#Log error
		print("[questie]: can't update data for special item with [uuid]: " + uuid)

		return

	# Update data
	data.is_unique = enabled
	print("[questie]: set is_unique to " + var2str(enabled) + " for special item with [uuid]: " + uuid)

func _ready():

	# Load database
	database = load("res://questie/item-db.tres")

	# Get references from interface
	toolbar = get_node("VBoxContainer/Toolbar")
	items_tree = get_node("VBoxContainer/HSplitContainer/ItemTree/ScrollContainer/Tree")
	empty_area = $VBoxContainer/HSplitContainer/Empty
	weapon_editor = $"VBoxContainer/HSplitContainer/Weapon Editor"
	armor_editor = $"VBoxContainer/HSplitContainer/Armor Editor"
	consumable_editor = $"VBoxContainer/HSplitContainer/Consumable Editor"
	material_editor = $"VBoxContainer/HSplitContainer/Material Editor"
	special_editor = $"VBoxContainer/HSplitContainer/Special Editor"

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

	# Subscribe consumable editor events
	consumable_editor.title.connect("text_changed", self, "consumable_name_changed")
	consumable_editor.description.connect("text_changed", self, "consumable_description_changed")
	consumable_editor.icon_path.connect("text_changed", self, "consumable_icon_changed")
	consumable_editor.can_be_sold.connect("toggled", self, "consumable_sellability_changed")
	consumable_editor.purchase_price.connect("value_changed", self, "consumable_purchase_price_changed")
	consumable_editor.sell_price.connect("value_changed", self, "consumable_sell_price_changed")
	consumable_editor.value.connect("value_changed", self, "consumable_value_changed")

	# Subscribe material editor events
	material_editor.title.connect("text_changed", self, "material_name_changed")
	material_editor.description.connect("text_changed", self, "material_description_changed")
	material_editor.icon_path.connect("text_changed", self, "material_icon_changed")
	material_editor.can_be_sold.connect("toggled", self, "material_sellability_changed")
	material_editor.purchase_price.connect("value_changed", self, "material_purchase_price_changed")
	material_editor.sell_price.connect("value_changed", self, "material_sell_price_changed")

	# Subscribe special editor events
	special_editor.title.connect("text_changed", self, "special_name_changed")
	special_editor.description.connect("text_changed", self, "special_description_changed")
	special_editor.icon_path.connect("text_changed", self, "special_icon_changed")
	special_editor.can_be_sold.connect("toggled", self, "special_sellability_changed")
	special_editor.purchase_price.connect("value_changed", self, "special_purchase_price_changed")
	special_editor.sell_price.connect("value_changed", self, "special_sell_price_changed")
	special_editor.as_weapon.connect("toggled", self, "special_weapon_changed")
	special_editor.damage_type.get_popup().connect("id_pressed", self, "special_damage_type_changed")
	special_editor.min_damage.connect("value_changed", self, "special_min_damage_changed")
	special_editor.max_damage.connect("value_changed", self, "special_max_damage_changed")
	special_editor.as_armor.connect("toggled", self, "special_armor_changed")
	special_editor.armor_type.get_popup().connect("id_pressed", self, "special_armor_type_changed")
	special_editor.armor_value.connect("value_changed", self, "special_armor_value_changed")
	special_editor.as_consumable.connect("toggled", self, "special_consumable_changed")
	special_editor.consumable_value.connect("value_changed", self, "special_consumable_changed")
	special_editor.is_unique.connect("toggled", self, "special_unique_changed")


