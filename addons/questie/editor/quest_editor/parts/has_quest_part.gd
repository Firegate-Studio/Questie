tool
extends Panel

# Called when a new quest is selected from the popup menu
signal quest_select(id, instance_id)
signal delete(part)

# The quest database
var database

var quest : MenuButton
var uuid : LineEdit
var delete : Button

# @brief                    Refresh the quest list
func refresh(): 
	var popup = quest.get_popup()
	popup.clear()

	for item in database.data: popup.add_item(item.title)

func quest_selected(var id):
	quest.text = quest.get_popup().get_item_text(id)
	uuid.text = database.data[id].uuid

	emit_signal("quest_select", id, get_instance_id())

func delete_button_pressed() : emit_signal("delete", self)

func _enter_tree():

	# Load Database Asset
	database = load("res://questie/quest-db.tres")

	# Get references from scene
	quest = $HBoxContainer/Quest
	uuid = $HBoxContainer/UUID
	delete = $HBoxContainer/Delete

	# Refresh database list
	refresh()
	
func _ready():
	
	# Subscribe events
	quest.get_popup().connect("id_pressed", self, "quest_selected")
	delete.connect("button_down", self, "delete_button_pressed")



