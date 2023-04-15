extends RewardNode
class_name Reward_AddItemNode

# the identifier of the item to add to the inventory
var item_id : String

# the quantity of the item to add to the inventory
var item_quantity : int

# reference to the player inventory
var inventory

func _enter_tree(): pass

func _exit_tree(): pass

func complete(quest_id): 
    if not inventory:
        print("[Questie]: player inventory not valid for reward with identifier: " + id)
        return

    inventory.add_item(item_id, item_quantity)

    emit_signal("reward_completed", id, quest_id)