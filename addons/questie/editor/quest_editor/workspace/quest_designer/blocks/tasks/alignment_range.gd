tool
extends GraphNode
class_name TaskBlock_AlignmentRange

signal alignment_range_changed(current_min, current_max)

var current_min_alignment : float = 0
var current_max_alignment : float = 0

var min_box : SpinBox
var max_box : SpinBox

func _enter_tree():
    min_box = $HBoxContainer/VBoxContainer/HBoxContainer/MinSpin
    max_box = $HBoxContainer/VBoxContainer/HBoxContainer2/MaxSpin

    min_box.connect("value_changed", self, "on_min_alignment_changed")
    max_box.connect("value_changed", self, "on_max_alignment_changed")

func _exit_tree():
    min_box.disconnect("value_changed", self, "on_min_alignment_changed")
    max_box.disconnect("value_changed", self, "on_max_alignment_changed")

func on_min_alignment_changed(new_value):
    current_min_alignment = new_value
    emit_signal("alignment_range_changed", current_min_alignment, current_max_alignment)

func on_max_alignment_changed(new_value):
    current_max_alignment = new_value
    emit_signal("alignment_range_changed", current_min_alignment, current_max_alignment)
