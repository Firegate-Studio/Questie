tool
extends Object
class_name TriggerBlockBuilder

static func alignment_amount():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/triggers/alignment_amount.tscn").instance()
    if not block:
        print("[Questie]: can not load alignment amount block")
        return null

    return block


static func enter_location(): 
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/triggers/enter_location.tscn").instance()
    if not block:
        print("[Questie]: can not load enter location block")
        return null

    return block

static func exit_location():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/triggers/exit_location.tscn").instance()
    if not block:
        print("[Questie]: can not load exit location block")
        return null

    return block

static func get_item():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/triggers/get_item.tscn").instance()
    if not block:
        print("[Questie]: can not load get item block")
        return null

    return block

static func interact_character():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/triggers/interact_character.tscn").instance()
    if not block:
        print("[Questie]: can not load interact character block")
        return null

    return block

static func interact_item():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/triggers/interact_item.tscn").instance()
    if not block:
        print("[Questie]: can not load interact item block")
        return null

    return block
