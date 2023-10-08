extends Area2D

var item : QuestieItem

func _ready():

	item = get_parent()

	connect("body_entered", self, "on_trigger_enter")

func on_trigger_enter(_body):
	
	item.interact()
	var item_id = get_parent().get_item_id()
	QuestieEvents.emit_signal("interact_item", item_id)

	
