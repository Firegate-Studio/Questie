extends Area2D

var questie_events : QuestieEvents

func _enter_tree():
	questie_events = get_node("../../QuestieEvents")
	
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
	questie_events.emit_signal("kill", character_id, owner.is_player)
	
	owner.queue_free()
