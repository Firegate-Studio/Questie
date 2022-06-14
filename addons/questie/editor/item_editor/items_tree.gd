tool
extends Tree

# The root node is the very root of the tree
var root

# All weapon objects are built under this item
var weapons

# All armor objects are built under this item
var armors

# All consumable objects are built under this item
var consumables

# All material objects are built under this item
var materials

# All special objects are build under this item
var specials

# A map with valid [UUID] for weapon items
var weapon_uuid_map : Dictionary = {}

# A map with valid [UUID] for armor items
var armor_uuid_map : Dictionary = {}

# A map with valid [UUID] for material items
var material_uuid_map : Dictionary = {}

# A map with valid [UUID] for consumable items
var consumable_uuid_map : Dictionary = {}

# A map with valid [UUID] for special items
var special_uuid_map : Dictionary = {}

# @brief                Creates a root [TreeItem]
# @param title          the item name that will be displayed inside the tree
# @param icon           the path to the icon to load as item icon (displyed on the left side of the item)
func create_root(var title, var icon):

	# Create tree item
	var result = create_item(root)
	result.set_text(0, title)
	result.set_selectable(0, false)
	result.set_editable(0, false)
	result.set_expand_right(0, true)

	# Create icon
	result.set_custom_as_button(0, true)
	result.set_icon(0, load(icon))
	result.set_icon_max_width(0, 32)

	return result

# @brief                create a new item in tree-view
# @param storage        the item type container in item database
# @param icon           the path to icon to load as item icon (displayed on the left side of the item)
# @return               the new tree item
func create_subitem(var storage : Array, var icon : String, var parent : TreeItem = null)->TreeItem:

	# create tree item
	var item = create_item(parent)
	item.set_text(0, "weapon_"+var2str(storage.size()))
	item.set_selectable(0, true)
	item.set_editable(0, true)
	item.set_expand_right(0, true)

	# create icon
	item.set_custom_as_button(0, true)
	item.set_icon(0, load(icon))
	item.set_icon_max_width(0, 32)

	# if weapon item
	if parent == weapons: 

		# Register UUID for weapons
		weapon_uuid_map[item.get_instance_id()] = storage[storage.size() - 1].uuid

		# Log
		print("[questie]: weapon uuid registred...")

		# Get item
		return item

	# if armor item
	if parent == armors: 

		# Register UUID for armors
		armor_uuid_map[item.get_instance_id()] = storage[storage.size() - 1].uuid

		# Log
		print("[questie]: armor uuid registred...")

		# Get item
		return item

	# if consumable item
	if parent == consumables: 

		# Register UUID for consumables
		consumable_uuid_map[item.get_instance_id()] = storage[storage.size() - 1].uuid

		# Log
		print("[questie]: consumable uuid registred...")

		# Get item
		return item

	# if material item
	if parent == materials: 

		# Register UUID for weapons
		material_uuid_map[item.get_instance_id()] = storage[storage.size() - 1].uuid

		# Log
		print("[questie]: material uuid registred...")

		# Get item
		return item

	# if weapon item
	if parent == specials: 

		# Register UUID for weapons
		special_uuid_map[item.get_instance_id()] = storage[storage.size() - 1].uuid

		# Log
		print("[questie]: special uuid registred...")

		# Get item
		return item

	return item

# @brief				remove a tree item from viewport
# @param item			the item to remove. Must be a [TreeItem]
# @param category		the category represents the folder containing the item. See [QuestDatabase.ItemCategory] for possible values
# @param idb			the item database containing the item data(see [item_data.gd]) represented from the tree item.
func remove_subitem(var item : TreeItem, var category : int, var idb : ItemDatabase):

	# Remove tree item by category
	match category:
		idb.ItemCategory.WEAPON:
			weapon_uuid_map.erase(item.get_instance_id())
			weapons.remove_child(item)
		
		idb.ItemCategory.ARMOR:
			armor_uuid_map.erase(item.get_instance_id())
			armors.remove_child(item)

		idb.ItemCategory.CONSUMABLE:
			consumable_uuid_map.erase(item.get_instance_id())
			consumables.remove_child(item)

		idb.ItemCategory.MATERIAL:
			material_uuid_map.erase(item.get_instance_id())
			materials.remove_child(item)

		idb.ItemCategory.SPECIAL:
			special_uuid_map.erase(item.get_instance_id())
			specials.remove_child(item)

	# Free memory
	#item.free()

	# Log
	print("[questie]: tree item removed")

func _enter_tree(): 

	# Construct root
	root = create_item(null)

	# Construct folders
	weapons = create_root("Weapons", "res://addons/questie/editor/icons/folder.png")
	armors = create_root("Armors", "res://addons/questie/editor/icons/folder.png")
	consumables = create_root("Consumables", "res://addons/questie/editor/icons/folder.png")
	materials = create_root("Materials", "res://addons/questie/editor/icons/folder.png")
	specials = create_root("Specials", "res://addons/questie/editor/icons/folder.png")

	# TODO: items loding
	print("[questie]: items loading not yet ported")

func _exit_tree(): pass
