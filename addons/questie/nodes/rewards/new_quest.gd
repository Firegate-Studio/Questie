extends RewardNode

signal activate_quest(quest_id)

var target_quest_id : String

func complete(quest_id):

    emit_signal("activate_quest", target_quest_id)
    emit_signal("reward_completed", id, quest_id)

