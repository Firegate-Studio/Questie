extends "res://addons/questie/nodes/questie_node.gd"

signal task_completed(task_uuid)
signal task_updated(task_uuid)

var questie : QuestDirector             # Questie!!!!
var inventory                           # the player inventory. DO NOT SET IT FROM EXTERNAL FILES!!!!

export(String) var quest_uuid           # the UUID of the quest owning this task
export(String) var task_uuid            # the UUID of the task itself stored into database
export(String) var item_uuid            # the UUID of the items from item database
export(int) var item_quantity = 1       # the amount needed to complete the task

func item_added(var item_uuid : String, var item_category : int):

    if state == TaskComplention.ONGOING:
        if item_uuid == self.item_uuid:     
            var obj = inventory.get_item(item_uuid)
            if obj.quantity >= item_quantity:
                state = TaskComplention.COMPLETED
                emit_signal("task_completed", task_uuid)
            else:
                emit_signal("task_updated", task_uuid)

func _enter_tree():
    tag = "QN_CollectItem"
    inventory = get_parent()

    inventory.connect("item_added", self, "item_added")

func _exit_tree():
    inventory.disconnect("item_added", self, "item_added")

