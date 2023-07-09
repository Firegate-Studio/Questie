extends Area2D

func _enter_tree():
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
	
	# call character interaction event            
	QuestieEvents.emit_signal("interact_character", character_id)
