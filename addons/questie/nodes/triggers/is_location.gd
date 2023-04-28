extends TriggerNode

# the location identifier
var location_id : String

# the category identifier
var category_id : String

func _enter_tree():

	var main = get_parent().get_parent()

	for child in main.get_children():
		
		if not child is QuestieLocation: continue
		
		var target_id = GameLocations.location_map[child.location]
		print(location_id + "==" + target_id)
		if not location_id == target_id: continue
			
		print("location registred")
		child.connect("player_entered", self, "on_player_enter_location")

func _exit_tree():
	var main = get_tree().root

	for child in main.get_children():
		
		if not child is QuestieLocation: continue

		if not location_id == GameLocations.location_map[child.location]: continue
		
		child.disconnect("player_entered", self, "on_player_enter_location")

func on_player_enter_location(player, location_id): 
    print("location trigger")
    state = TaskComplention.COMPLETED
    emit_signal("trigger_activated", id)
	

	