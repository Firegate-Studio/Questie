tool
extends Control

##########################################################
#######               INTERFACE BUTTONS            #######
##########################################################
var new_weapon_btn : ToolButton
var new_armor_btn : ToolButton
var new_consumable_btn : ToolButton
var new_material_btn : ToolButton
var new_special_btn : ToolButton
var delete_btn : ToolButton

##########################################################
#######                   EVENTS                  #######
##########################################################

# @brief                handle a request to create a new weapon item
signal new_weapon_item_request()

# @brief                handle a request to create a new armor item
signal new_armor_item_request()

# @brief                handle a request to create a new consumable item
signal new_consumable_item_request()

# @brief                handle a request to create a new material item
signal new_material_item_request()

# @brief                handle a request to create a new special item
signal new_special_item_request()

# @brief                handle a request to delete an item
signal delete_item_request()

##########################################################
#######                 CALLBACKS                  #######
##########################################################

# @brief            send a signal to create a new weapon item
func on_new_weapon_request():       emit_signal("new_weapon_item_request")

# @brief            send a signal to create a new armor item
func on_new_armor_request():        emit_signal("new_armor_item_request")

# @brief            send a signal to create a new consumable item
func on_new_consumable_request():   emit_signal("new_consumable_item_request")

# @brief            send a signal to create a new material item
func on_new_material_request():     emit_signal("new_material_item_request")

# @brief            send a signal to create a new special item
func on_new_special_request():      emit_signal("new_special_item_request")

# @brief            send a signal to delete a tree item
func on_delete_item_request():       emit_signal("delete_item_request")

func _enter_tree():

	# Get references from GUI buttons
	new_weapon_btn = get_node("HBoxContainer/new weapon")
	new_armor_btn = get_node("HBoxContainer/new armor")
	new_consumable_btn = get_node("HBoxContainer/new consumable")
	new_material_btn = get_node("HBoxContainer/new material")
	new_special_btn = get_node("HBoxContainer/new special")
	delete_btn = get_node("HBoxContainer/delete")

	# Subscribe button events
	new_weapon_btn.connect("button_down", self, "on_new_weapon_request")
	new_armor_btn.connect("button_down", self, "on_new_armor_request")
	new_consumable_btn.connect("button_down", self, "on_new_consumable_request")
	new_material_btn.connect("button_down", self, "on_new_material_request")
	new_special_btn.connect("button_down", self, "on_new_special_request")
	delete_btn.connect("button_down", self, "on_delete_item_request")

func _exit_tree():

	# Unsubscribe button events
	new_weapon_btn.disconnect("button_down", self, "on_new_weapon_request")
	new_armor_btn.disconnect("button_down", self, "on_new_armor_request")
	new_consumable_btn.disconnect("button_down", self, "on_new_consumable_request")
	new_material_btn.disconnect("button_down", self, "on_new_material_request")
	new_special_btn.disconnect("button_down", self, "on_new_special_request")
	delete_btn.disconnect("button_down", self, "on_delete_item_request")
