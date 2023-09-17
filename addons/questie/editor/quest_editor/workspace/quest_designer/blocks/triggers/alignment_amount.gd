tool
extends GraphNode
class_name TriggerBlock_HasAlignmentRange

signal alignment_range_changed(min_alignment, max_alignment)

var current_min : float
var current_max : float

var min_alignment_spin : SpinBox
var max_alignment_spin : SpinBox

func _enter_tree():
	min_alignment_spin = $"HBoxContainer/VBoxContainer/HBoxContainer/Min Alignment"
	max_alignment_spin = $"HBoxContainer/VBoxContainer/HBoxContainer2/Max Alignment"

	min_alignment_spin.connect("value_changed", self, "on_min_alignment_changed")
	max_alignment_spin.connect("value_changed", self, "on_max_alignment_changed")

func _exit_tree():
	min_alignment_spin.disconnect("value_changed", self, "on_min_alignment_changed")
	max_alignment_spin.disconnect("value_changed", self, "on_max_alignment_changed")

func on_min_alignment_changed(new_value : float):
	current_min = new_value
	emit_signal("alignment_range_changed", current_min, current_max)

func on_max_alignment_changed(new_value : float):
	current_max = new_value
	emit_signal("alignment_range_changed", current_min, current_max)
