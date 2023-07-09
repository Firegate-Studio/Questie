extends Area2D

func _enter_tree():
	connect("body_entered", self, "on_player_entered")

func _exit_tree():
	disconnect("body_entered", self, "on_player_entered")

func on_player_entered(body):
	if not body is QuestieCharacter: return
	if not body.is_player: return

	var owner = get_parent()
	if not owner or not owner is QuestieCharacter:
		print("invalid owner or owner is not a questie character")
		return

	# get character identifier
	var character_id = owner.get_id()

	# call kill event to notify questie
	QuestieEvents.emit_signal("kill", character_id, owner.is_player)
	
	owner.queue_free()
