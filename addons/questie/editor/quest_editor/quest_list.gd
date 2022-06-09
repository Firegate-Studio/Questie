tool
extends VBoxContainer

var database = preload("res://questie/quest-db.tres")

# @brief			Add a quest button in viewport
# @param uuid       the unique identifier of the quest
func add_quest_button(var uuid : String)->QuestLabel: 
	var result = load("res://addons/questie/editor/quest_editor/quest_label.tscn").instance()
	result.uuid = uuid
	add_child(result)
	result.quest_btn.text = "Quest-"+uuid
	return result

# @brief Removes all childrens from viewport
func purge()->void:
	for item in get_children().size():
		remove_child(item)
		item.queue_free()

func _enter_tree():

	# Check if any quest exists
	if database.data.size() == 0: return

	# If yes, load all quest buttons in viewport
	for item in database.data:
		add_quest_button(item.uuid)
	
