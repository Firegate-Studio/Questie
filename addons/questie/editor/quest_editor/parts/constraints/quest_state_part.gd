tool
extends Panel

# @brief                    Notify when the quest changes in viewport
# @param part               The interface who has called the event
# @param quest_id           The identifier of the quest representing the position inside the menu popup
# **NB**:                   The [quest_id] represent the ordering of each quest inside the [QuestTree].
#
# **EXAMPLE**
# 
# quest_id = 4
# The fifth element inside the quest tree represents this quest
signal quest_changed(part, quest_id)

# @brief                    Notify when the state changes in viewport
# @param part               The interfaces who has called the event
# @param state_id           The identifier of the state representing the position inside the menu popup
# **NB**:                   The [state_id] must be specular to the **QuestComplention** of [QuestData.QuestComplention]
signal state_changed(part, state_id)

signal delete(part)

# The quest database
onready var database = preload("res://questie/quest-db.tres")

# The quest we want check
var quest : MenuButton

# The state of the quest
var state : MenuButton

var delete : Button

func delete_part() : emit_signal("delete", self)

# @brief                    Update the quest menu
# @param quest_id           The [id] representing the quest position inside the list
func change_quest(var quest_id):

	# Update text
	quest.text = quest.get_popup().get_item_text(quest_id)

	# Throw signal
	emit_signal("quest_changed", self, quest_id)

# @brief                    Update state menu 
# @param state_id           The [id] representing the state pressed
func change_state(var state_id): 

	# Set state text by selection
	state.text = state.get_popup().get_item_text(state_id)

	# Throw signal
	emit_signal("state_changed", self, state_id)

# @brief                    Update the quest list
func refresh(): 
	var popup = quest.get_popup()

	# Removes items from the list to avoid duplicated nodes
	popup.clear()

	# Generate list from database
	for item in database.data:
		popup.add_item(item.title)

func _enter_tree():

	quest = $HBoxContainer/Quest
	state = $HBoxContainer/State
	delete = $"HBoxContainer/Delete"

func _ready():

	# Generate state popup
	var popup = state.get_popup()
	popup.clear()
	popup.add_item("Disabled")
	popup.add_item("Ongoing")
	popup.add_item("Failed")
	popup.add_item("Completed")

	# Refresh quest list
	refresh()

	# Subscribe events
	quest.get_popup().connect("id_pressed", self, "change_quest")
	state.get_popup().connect("id_pressed", self, "change_state")
	delete.connect("button_down", self, "delete_part")
