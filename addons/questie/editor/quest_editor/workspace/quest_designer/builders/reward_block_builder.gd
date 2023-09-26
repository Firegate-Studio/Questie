extends Object
class_name RewardBlockBuilder

static func add_item():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/rewards/add_item.tscn").instance()
    if not block:
        print("[Questie]: Can't create add item reward block!")
        return null

    return block

static func add_alignment():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/rewards/add_alignment.tscn").instance()
    if not block:
        print("[Questie]: Can't create add item reward block!")
        return null

    return block
