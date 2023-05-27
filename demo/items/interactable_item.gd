extends Area2D

var item_tag : ItemTag

var questie : Questie 

var questie_events : QuestieEvents


func _ready():

	item_tag = $"ItemTag"
	questie = get_node("../Questie")
	questie_events = get_node("../QuestieEvents")

	connect("body_entered", self, "on_trigger_enter")

func on_trigger_enter(_body):

	var item_id = item_tag.get_item_id()
	questie_events.emit_signal("interact_item", item_id)

	
