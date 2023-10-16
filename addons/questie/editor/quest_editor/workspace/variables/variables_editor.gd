tool
extends VBoxContainer

var new_boolean_button
var new_integer_button
var new_decimal_button

var variables_tree : VariablesTree

func _enter_tree(): 

    variables_tree = $VariablesTree

    new_boolean_button = $HBoxContainer/NewBooleanButton
    new_integer_button = $HBoxContainer/NewIntegerButton
    new_decimal_button = $HBoxContainer/NewDecimalButton

    new_boolean_button.connect("button_down", self, "on_new_boolean_requested")
    new_integer_button.connect("button_down", self, "on_new_integer_requested")
    new_decimal_button.connect("button_down", self, "on_new_decimal_requested")

func _exit_tree():
    new_boolean_button.disconnect("button_down", self, "on_new_boolean_requested")
    new_integer_button.disconnect("button_down", self, "on_new_integer_requested")
    new_decimal_button.disconnect("button_down", self, "on_new_decimal_requested")

func on_new_boolean_requested():
    variables_tree.create_boolean_item("new boolean")

func on_new_integer_requested():
    variables_tree.create_integer_item("New Integer")

func on_new_decimal_requested():
    variables_tree.create_decimal_item("New Decimal")
