tool
extends GridContainer

var item_database = preload("res://questie/item-db.tres")

# the identifier of the selected item to find him into the items database
var selected_item_id : String

# the current selected button
var selected_node : Button

func _enter_tree():
	load_all_items()

func load_all_items(keyword = "", has_weapon = true, has_armor = true, has_consumable = true, has_material = true, has_special = true):

	for child in get_children():
		child.queue_free()

	if has_weapon: load_item_by_collection(item_database.weapons, keyword)
	if has_armor: load_item_by_collection(item_database.armors, keyword)
	if has_consumable: load_item_by_collection(item_database.consumables, keyword)
	if has_material: load_item_by_collection(item_database.materials, keyword)
	if has_special: load_item_by_collection(item_database.specials, keyword)

func load_item_by_collection(collection, keyword):
	for item in collection:

		if not keyword in item.title and keyword != "": continue 

		var node = load("res://addons/questie/editor/character_editor/workspace/inventory/inventory_item_preview.tscn").instance()
		add_child(node)
		node._id = item.uuid
		node._name.text = item.title
		node._icon.texture = item.icon
		node.connect("selected", self, "on_item_selected", [node])

func on_item_selected(item_id, node): 
	selected_item_id = item_id

	if selected_node:
		selected_node.flat = false

	node.flat = true
	selected_node = node

	print("[Questie]: selected item " + item_id)


