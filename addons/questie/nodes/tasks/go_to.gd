extends TaskNode

# the location identifier
var location_id : String

# the category identifier
var category_id : String

func _enter_tree():

	QuestieEvents.connect("player_enter_location", self, "on_player_enter_location")
	QuestieEvents.connect("player_exit_location", self, "on_player_exit_location")

func _exit_tree():
	var main = get_tree().root

	for child in main.get_children():
		
		if not child is QuestieLocation: continue

		if not location_id == GameLocations.location_map[child.location]: 
			print("Location id is not " + var2str(GameLocations.location_map[child.location]))
			continue
		
		child.disconnect("player_entered", self, "on_player_enter_location")
		child.disconnect("player_exited", self, "on_player_exit_location")

func on_player_enter_location(_location_id): 

	if not location_id == _location_id: 
		return
		
	state = TaskComplention.COMPLETED
	emit_signal("task_completed", id)

func on_player_exit_location(_location_id): 

	if not location_id == _location_id: 
		return

	state = TaskComplention.ONGOING
	emit_signal("task_updated", id)




