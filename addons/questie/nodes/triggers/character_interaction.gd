extends TriggerNode

# the character identifier
var character_id : String

var questie_events : QuestieEvents 

func _enter_tree():
	questie_events = get_node("../../QuestieEvents")
	questie_events.connect("interact_character", self, "on_character_interaction")

func _exit_tree():
	questie_events.disconnect("interact_character", self, "on_character_interaction")

func on_character_interaction(character):

	print("target id: " + character_id)
	print("current id: " + character)

	if not character == character_id: 
		return

	state = TaskComplention.COMPLETED
	emit_signal("trigger_activated", id)

