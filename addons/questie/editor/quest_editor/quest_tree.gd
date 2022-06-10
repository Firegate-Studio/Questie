tool
extends Tree

# The master root branch for tree view
var root : TreeItem

var quest_database = preload("res://questie/quest-db.tres")

# A map to store all [uuid]
# 
# Extending [TreeItem] is also possible, but i can't create one of them like a tree item
# so it's better stores an map of all identifier to check them.
var uuid_map : Dictionary

# Add a quest item pointing to a database quest as child of the tree root
func add_quest_item(var uuid : String)->void: 
	
	# Create quest item
	var quest = create_item(root)
	quest.set_custom_as_button(0, true)
	quest.set_editable(0, false)
	quest.set_expand_right(0, true)
	quest.set_icon(0, load("res://addons/questie/editor/icons/chest.png"))
	quest.set_icon_max_width(0, 32)

	# Use [uuid] to set the quest name if quest is generic
	var data = quest_database.get_data(uuid)
	if data.title == "fill quest title here":
		quest.set_text(0,"Quest-"+uuid)
	else:
		quest.set_text(0, data.title)

	# Set new [uuid] 
	uuid_map[quest.get_instance_id()] = uuid
	print("[questie]: added a new quest quest item ("+uuid_map[quest.get_instance_id()]+")")

func remove_quest_item(var item : TreeItem):
	var parent = item.get_parent()
	uuid_map.erase(uuid_map[item.get_instance_id()])
	parent.remove_child(item)
	item.free()
	
func _ready():

	# Create tree root
	root = create_item(null)
	root.set_text(0, "root")
	
	# Check if any quest exists
	if quest_database.data.size() == 0: return

	# Load all quest from database
	for item in quest_database.data:
		add_quest_item(item.uuid)

	
	
	

