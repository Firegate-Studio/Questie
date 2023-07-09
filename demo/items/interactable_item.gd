extends Area2D

var item_tag : ItemTag


func _ready():

	item_tag = $"ItemTag"

	connect("body_entered", self, "on_trigger_enter")

func on_trigger_enter(_body):

	var item_id = item_tag.get_item_id()
	QuestieEvents.emit_signal("interact_item", item_id)

	
