tool
extends TabContainer

var display_name : LineEdit
var icon_path : LineEdit
var icon_preview : TextureRect
var is_unique : CheckButton
var description : TextEdit
var min_damage : SpinBox
var max_damage : SpinBox
var min_defense : SpinBox
var max_defense : SpinBox
var min_healing : SpinBox
var max_healing : SpinBox
var min_custom : SpinBox
var max_custom : SpinBox
var original_price : SpinBox
var selling_price : SpinBox
var purchase_price : SpinBox

const DB_PATH = "res://questie/item-db.tres"
var database = preload("res://questie/item-db.tres")

var index : int = -1

func _enter_tree():
	display_name = $"Settings/Display Name"
	icon_path = $"Settings/HBoxContainer/Icon Path"
	icon_preview = $"Settings/HBoxContainer2/Icon Preview"
	is_unique = $"Settings/HBoxContainer3/Is Unique"
	description = $Settings/Description
	min_damage = $"Values/HBoxContainer/Min Damage"
	max_damage = $"Values/HBoxContainer/Max Damage"
	min_defense = $"Values/HBoxContainer2/Min Defense"
	max_defense = $"Values/HBoxContainer2/Max Defense"
	min_healing = $"Values/HBoxContainer3/Min Healing"
	max_healing = $"Values/HBoxContainer3/Max Healing"
	min_custom = $"Values/HBoxContainer4/Min Custom"
	max_custom = $"Values/HBoxContainer4/Max Custom"
	original_price = $"Selling/HBoxContainer/Original Price"
	selling_price = $"Selling/HBoxContainer2/Selling Price"
	purchase_price = $"Selling/HBoxContainer2/Purchase Price"

	display_name.connect("text_changed", self, "on_display_name_changed")
	icon_path.connect("text_changed", self, "on_icon_path_changed")
	is_unique.connect("toggled", self, "on_is_unique_changed")
	description.connect("text_changed", self, "on_description_changed")
	min_damage.connect("value_changed", self, "on_min_damage_changed")
	max_damage.connect("value_changed", self, "on_max_damage_changed")
	min_defense.connect("value_changed", self, "on_min_defense_changed")
	max_defense.connect("value_changed", self, "on_max_defense_changed")
	min_healing.connect("value_changed", self, "on_min_healing_changed")
	max_healing.connect("value_changed", self, "on_max_healing_changed")
	min_custom.connect("value_changed", self, "on_min_custom_changed")
	max_custom.connect("value_changed", self, "on_max_custom_changed")
	original_price.connect("value_changed", self, "on_original_price_changed")
	selling_price.connect("value_changed", self, "on_selling_price_changed")
	purchase_price.connect("value_changed", self, "on_purchase_price_changed")

func _exit_tree(): 
	display_name.disconnect("text_changed", self, "on_display_name_changed")
	icon_path.disconnect("text_changed", self, "on_icon_path_changed")
	is_unique.disconnect("toggled", self, "on_is_unique_changed")
	description.disconnect("text_changed", self, "on_description_changed")
	min_damage.disconnect("value_changed", self, "on_min_damage_changed")
	max_damage.disconnect("value_changed", self, "on_max_damage_changed")
	min_defense.disconnect("value_changed", self, "on_min_defense_changed")
	max_defense.disconnect("value_changed", self, "on_max_defense_changed")
	min_healing.disconnect("value_changed", self, "on_min_healing_changed")
	max_healing.disconnect("value_changed", self, "on_max_healing_changed")
	min_custom.disconnect("value_changed", self, "on_min_custom_changed")
	max_custom.disconnect("value_changed", self, "on_max_custom_Changed")
	original_price.disconnect("value_changed", self, "on_original_price_changed")
	selling_price.disconnect("value_changed", self, "on_selling_price_changed")
	purchase_price.disconnect("value_changed", self, "on_purchase_price_changed")

func on_display_name_changed(text): 
	database.items[index].display_name = text
	ResourceSaver.save(DB_PATH, database)

func on_icon_path_changed(text): 
	var texture = load(text)
	if not texture: return

	icon_preview.texture = texture
	database.items[index].icon_path = text
	database.items[index].icon = texture

	ResourceSaver.save(DB_PATH, database)

func on_is_unique_changed(toggled):
	database.items[index].is_unique = toggled
	ResourceSaver.save(DB_PATH, database)

func on_description_changed():
	database.items[index].description = description.text
	ResourceSaver.save(DB_PATH, database)

func on_min_damage_changed(dmg):
	database.items[index].min_damage = dmg
	ResourceSaver.save(DB_PATH, database)

func on_max_damage_changed(dmg):
	database.items[index].max_damage = dmg
	ResourceSaver.save(DB_PATH, database)

func on_min_defense_changed(def):
	database.items[index].min_defense = def
	ResourceSaver.save(DB_PATH, database)

func on_max_defense_changed(def):
	database.items[index].max_defense = def
	ResourceSaver.save(DB_PATH, database)

func on_min_healing_changed(heal):
	database.items[index].min_healing = heal
	ResourceSaver.save(DB_PATH, database)

func on_max_healing_changed(heal):
	database.items[index].max_healing = heal
	ResourceSaver.save(DB_PATH, database)

func on_min_custom_changed(custom):
	database.items[index].min_custom = custom
	ResourceSaver.save(DB_PATH, database)

func on_max_custom_changed(custom):
	database.items[index].max_custom = custom
	ResourceSaver.save(DB_PATH, database)

func on_original_price_changed(price):
	database.items[index].original_price = price
	ResourceSaver.save(DB_PATH, database)

func on_selling_price_changed(price):
	database.items[index].sell_price = price
	ResourceSaver.save(DB_PATH, database)
	
func on_purchase_price_changed(price):
	database.items[index].purchase_price = price
	ResourceSaver.save(DB_PATH, database)


func setup(id):

	var data = database.get_item(id)
	index = database.get_item_index(id)

	display_name.text = data.display_name
	icon_path.text = data.icon_path
	icon_preview.texture = load(data.icon_path)
	is_unique.pressed = data.is_unique
	description.text = data.description
	min_damage.value = data.min_damage
	max_damage.value = data.max_damage
	min_defense.value = data.min_defense
	max_defense.value = data.max_defense
	min_healing.value = data.min_healing
	max_healing.value = data.max_healing
	min_custom.value = data.min_custom
	max_custom.value = data.max_custom
	original_price.value = data.original_price
	selling_price.value = data.sell_price
	purchase_price.value = data.purchase_price
