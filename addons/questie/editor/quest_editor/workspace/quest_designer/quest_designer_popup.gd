tool
extends Panel
class_name QuestDesignerPopup

var constraint_blocks_container : ConstraintBlocksContainer
var trigger_blocks_container
var task_blocks_container

func _enter_tree():
	constraint_blocks_container = $"VBoxContainer/Constraints Container"
