extends Area2D

var questie_events : QuestieEvents

func _enter_tree():
	questie_events = get_node("../../QuestieEvents")

	connect("body_entered", self, "on_player_enter_trigger")

func on_player_enter_trigger(body):
	if not body is QuestieCharacter: return     # check if the rigidbody is a QuestieCharacter

	if not body.is_player: return               # check if the character is the player itself

	var parent  = get_parent()
	if not parent is QuestieCharacter:
		print("[Questie]: to work the parent node must be a QuestieCharacter")
		return
	
	# get the character identifier
	var character_id = parent.get_id()

	var dialogue = Dialogic.start("/Tutorial")
	add_child(dialogue)
	questie_events.emit_signal("talk", character_id)
