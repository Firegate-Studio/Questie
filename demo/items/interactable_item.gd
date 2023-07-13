extends Area2D

var item : QuestieItem

func _ready():

	item = get_parent()

	connect("body_entered", self, "on_trigger_enter")

func on_trigger_enter(_body):

	Questie.player_inventory.add_item(item.get_item_id())
	
	item.interact()
	queue_free()

	
