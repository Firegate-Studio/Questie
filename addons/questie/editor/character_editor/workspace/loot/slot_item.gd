tool
extends Button

signal quantity_changed(quantity)
signal percentage_changed(percentage)
signal deletion_requested()

var _name : Label
var _icon : TextureRect
var _quantity : SpinBox
var _percentage_slider : HSlider
var _percentage_text : Label
var _delete_btn : Button

func _enter_tree():
	_name = $VBoxContainer/Name
	_icon = $VBoxContainer/Icon
	_quantity = $VBoxContainer/HBoxContainer/quantity
	_percentage_slider = $"VBoxContainer/HBoxContainer2/percentege slider"
	_percentage_text = $"VBoxContainer/HBoxContainer2/percentage text"
	_delete_btn = $"VBoxContainer/delete button"

	_percentage_slider.connect("drag_ended", self, "on_percentage_changed")
	_quantity.connect("value_changed", self, "on_quantity_changed")
	_delete_btn.connect("button_down", self, "on_delete_button_clicked")


func on_percentage_changed(value_changed):

	if not value_changed: return
	
	_percentage_text.text = var2str(_percentage_slider.value) + "%"
	print("[Questie]: set loot percentage to " + var2str(_percentage_slider.value))
	emit_signal("percentage_changed", _percentage_slider.value)

func on_quantity_changed(value): 
	print("[Questie]: quantity changed to " + var2str(value))
	emit_signal("quantity_changed", value)
	
func on_delete_button_clicked():
	print("[Questie]: loot item deletion requested...")
	emit_signal("deletion_requested")


