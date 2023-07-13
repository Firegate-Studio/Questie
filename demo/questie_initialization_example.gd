extends Node

func _enter_tree():
	Questie.setup()

func _ready():
	var inv = Questie.player_inventory
	var item_id = ItemsCollection.items_map[ItemsCollection.Items.Stone]
	
	inv.add_item(item_id, 99)
	inv.debug()
	
	inv.remove_item(item_id, 17)
	inv.debug()
	
