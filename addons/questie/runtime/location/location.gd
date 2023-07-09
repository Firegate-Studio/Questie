extends Area2D
class_name QuestieLocation, "res://addons/questie/editor/icons/village.png"

signal player_entered(player, location_id)
signal player_exited(player, loaction_id)

export(GameLocations.Locations) var location

var questie_events : QuestieEvents

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	questie_events = get_node("../QuestieEvents")

func on_body_entered(node): 
	if not node is QuestieCharacter: return
	if not node.is_player: return
	
	print("[Questie]: player entered location with identifier " + GameLocations.location_map[location])
	emit_signal("player_entered", node, GameLocations.location_map[location])#todo: remove this event
	questie_events.emit_signal("player_enter_location", GameLocations.location_map[location])


func on_body_exited(node) :
	if not node is QuestieCharacter: return
	if not node.is_player: return
	
	print("[Questie]: player exited location with identifier " + GameLocations.location_map[location])
	emit_signal("player_exited", node, GameLocations.location_map[location])#todo: remove this event
	questie_events.emit_signal("player_exit_location", GameLocations.location_map[location])

