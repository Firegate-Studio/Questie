extends "res://addons/questie/nodes/questie_node.gd"

signal constraint_passed(constraint_uuid)
signal constraint_failed(constraint_uuid)

var questie : QuestDirector             # the quest director
var inventory                           # the player inventory. DO NOT SET IT FROM EXTERNAL FILES!

export(String) var uuid                 # the UUID of the node
export(String) var quest_uuid           # the UUID of the quest owning this constraint
export(String) var constraint_uuid      # the UUID of the constraint itself
export(String) var item_uuid            # the UUID of the item from the item database
export(String) var item_category        # the category of the item to track
export(int) var item_quantity = 1       # the amount needed to pass this constraint

func _enter_tree():

    tag = "QN_HasItem"
    inventory = get_parent()

    # subscribe event
    inventory.connect("item_added", self, "on_item_added")

func _exit_tree():
    inventory.disconnect("item_added", self, "on_item_added")

func on_item_added(var item_uuid : String, var item_category : int):

    if item_uuid != self.item_uuid: return

    var obj = inventory.get_item(item_uuid)
    if not obj:
        print("[Questie]: can't retrieve item data from uuid: " + item_uuid)
        return

    if obj.quantity >= item_quantity:
        emit_signal("constraint_passed", constraint_uuid)

    else:
        emit_signal("constraint_failed", constraint_uuid)

