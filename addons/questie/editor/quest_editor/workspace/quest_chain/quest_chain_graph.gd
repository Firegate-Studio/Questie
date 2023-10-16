tool
extends GraphEdit
class_name QuestChainGraph

var chain_database : ChainDatabase = null

# blocks
var entry_blocks : Array
var quest_blocks : Array

func _enter_tree():
    chain_database = ResourceLoader.load("res://questie/chain-db.tres")
    if not chain_database:
        print("[Questie]: can't load chain database")
        return

    