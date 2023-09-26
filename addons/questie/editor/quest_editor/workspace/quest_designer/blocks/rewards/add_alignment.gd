tool
extends GraphNode
class_name RewardBlock_AddAlignment

signal alignment_changed(alignment)

var alignment_amount : float

var alignment_box : SpinBox

func _enter_tree():
    alignment_box = $HBoxContainer/QuantityBox

    alignment_box.connect("value_changed", self, "on_alignment_changed")

func _exit_tree():
    alignment_box.disconnect("value_changed", self, "on_alignment_changed")

func on_alignment_changed(amount):
    alignment_amount = amount
    emit_signal("alignment_changed", amount)