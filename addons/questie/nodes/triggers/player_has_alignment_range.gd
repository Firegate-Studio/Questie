extends TriggerNode

var min_alignment_required : float
var max_alignment_required : float

func _enter_tree():
	QuestieEvents.connect("character_alignment_changed", self, "on_character_alignment_changed")

func _exit_tree():
	QuestieEvents.disconnect("character_alignment_changed", self, "on_character_alignment_changed")

func on_character_alignment_changed(_character_id : String, alignment : float):

	# get reference to the scene
	var root = get_parent().get_parent().get_node("MasterScene")

	var player : QuestieCharacter = null # prepare player variable

	# scan the scene for player
	for character in root.get_children():
		if not character is QuestieCharacter: continue
		if not character.is_player: continue

		player = character
		break

	var current_alignment = player.get_alignment()

	if not current_alignment >= min_alignment_required and current_alignment <= max_alignment_required:
		return

	state = TaskComplention.COMPLETED
	emit_signal("trigger_activated", id)


