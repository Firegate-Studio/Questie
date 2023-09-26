tool
extends Object
class_name TaskBlockBuilder

static func alignment_range():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/tasks/alignment_range.tscn").instance()
    if not block:
        print("[Questie]: can't build alignment range task block!")
        return null

    return block

static func collect():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/tasks/collect.tscn").instance()
    if not block:
        print("[Questie]: can't build collect task block!")
        return null

    return block

static func go_to():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/tasks/go_to.tscn").instance()
    if not block:
        print("[Questie]: can't build go to block!")
        return null

    return block

static func kill():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/tasks/kill.tscn").instance()
    if not block:
        print("[Questie]: can't build kill block!")
        return null

    return block

static func talk():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/tasks/talk.tscn").instance()
    if not block:
        print("[Questie]: can't build talk  block!")
        return null

    return block

static func interact_item():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/tasks/interact_item.tscn").instance()
    if not block:
        print("[Questie]: can't build interact item block!")
        return null

    return block

static func interact_character():
    var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/tasks/interact_character.tscn").instance()
    if not block:
        print("[Questie]: can't build interact_character block!")
        return null

    return block