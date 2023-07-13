extends Area2D


func _ready():
	connect("body_entered", self, "on_trigger_enter")

func on_trigger_enter(_body):

	var item_id = get_parent().get_item_id()
	Questie.player_inventory.add_item(item_id, 1)
	
	disconnect("body_entered", self, "on_trigger_enter")

	get_parent().queue_free()



