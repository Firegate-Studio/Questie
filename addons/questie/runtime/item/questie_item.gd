extends Node
class_name QuestieItem, "res://addons/questie/editor/icons/boxes_16x16.png"

export(ItemsCollection.Items) var item

func get_item_id():
	var id = ItemsCollection.items_map[item]
	if id == "": return "INVALID"
	
	return id
	
func get_data():
	var db = load("res://questie/item-db.tres")
	if not db: 
		print("[Questie]: can not load item database")
		return null
		
	var item_id = ItemsCollection.items_map[item]
	if item_id == "":
		print("[Questie]: item_id is not valid")
		return null
		
	var data = db.get_item(item_id)
	if not data:
		print("[Questie]: item data is not valid!")
		return null	
		
	return data

func get_display_name(): return get_data().display_name
func get_icon(): return get_data().icon
func get_icon_path(): return get_data().icon_path
func get_description(): return get_data().description
func get_weight(): return get_data().weight
func get_is_unique(): return get_data().is_unique
func get_min_damage(): return get_data().min_damage
func get_max_damage(): return get_data().max_damage
func get_min_defense(): return get_data().min_defense
func get_max_defense(): return get_data().max_defense
func get_min_healing(): return get_data().min_healing
func get_max_healing(): return get_data().max_healing
func get_min_custom(): return get_data().min_custom
func get_max_custom(): return get_data().max_custom
func get_sell_price(): return get_data().sell_price
func get_purchase_price(): return get_data().purchase_price
