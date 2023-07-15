tool
extends GridContainer

var item_database = preload("res://questie/item-db.tres")

# the identifier of the selected item to find him into the items database
var selected_item_id : String

# the current selected button
var selected_node : Button

func _enter_tree():
	load_all_items()

func load_all_items(keyword = ""):

	for child in get_children():
		child.queue_free()

	load_item_collection(item_database.items, keyword)


func load_item_collection(collection, keyword):
	for item in collection:

		if not keyword in item.name and keyword != "": continue 

		var node = load("res://addons/questie/editor/character_editor/workspace/inventory/inventory_item_preview.tscn").instance()
		add_child(node)
		node._id = item.id
		node._name.text = item.name
		node._icon.texture = item.icon
		node.connect("selected", self, "on_item_selected", [node])

func on_item_selected(item_id, node): 
	selected_item_id = item_id

	if selected_node:
		selected_node.flat = false

	node.flat = true
	selected_node = node

	print("[Questie]: selected item " + item_id)


