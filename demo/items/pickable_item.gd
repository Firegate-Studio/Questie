extends Area2D

var item_tag : ItemTag

var questie : Questie 

func _ready():
	item_tag = $"ItemTag"
	questie = get_node("../Questie")
	connect("body_entered", self, "on_trigger_enter")

func on_trigger_enter(_body):

	var item_id = item_tag.get_item_id()
	questie.player_inventory.add_item(item_id, 1)
	
	disconnect("body_entered", self, "on_trigger_enter")

	queue_free()



