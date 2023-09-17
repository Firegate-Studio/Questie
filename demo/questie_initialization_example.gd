extends Node

func _enter_tree():
	Questie.setup()

func _ready():
	var inv = Questie.player_inventory
	
