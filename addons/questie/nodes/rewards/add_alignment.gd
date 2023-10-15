extends RewardNode

var alignment_amount : float

var player : QuestieCharacter

func _enter_tree():
	var root = get_parent().get_parent().get_node("MasterScene")
	for character in root.get_children():
		print(character.name)
		if not character is QuestieCharacter: continue
		if not character.is_player: continue

		player = character
		break

func complete(quest_id):
	if not player:
		print("[Questie]: can not activate alignment reward cause player was not found into the MasterScene")
		return

	player.add_alignment(alignment_amount)
	print("alignment: " + var2str(player.get_alignment()))
	queue_free()
