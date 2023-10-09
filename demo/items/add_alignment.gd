extends Area2D

var item : QuestieItem

func _ready():

	item = get_parent()

	connect("body_entered", self, "on_trigger_enter")

func on_trigger_enter(_body):
	
	if not _body is QuestieCharacter : return
	
	_body.add_alignment(1)
	print("Alignment added - alignment: " + var2str(_body.get_alignment()))
