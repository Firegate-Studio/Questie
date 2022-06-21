extends Node
class_name InventorySystem

const item_db = preload("res://questie/item-db.tres")

const weapons = {}
const armors = {}
const consumables = {}
const materials = {}
const specials = {}

# @brief                    Get the item data from database
# @param uuid               The item uuid
# @param category           The item category (i.e., Weapon, Armor, Consumable, Material, Special)
static func get_item_data(var uuid : String, var category : int): 

	# Get item database
	var db = load("res://questie/item-db.tres")

	# Check database validation
	if not db:

		# Log error
		print("[questie]: can't access to the item database")

		return null

	# Get item data
	var result = db.find_data(uuid, category)

	# Check data validation
	if not result:

		# Log error
		print("[questie]: invalid item data with [uuid]: " + uuid + " from [category]: " + var2str(category))

		return null

	return result

# @brief                    Get the weapon damage between the minimum and maximum damage
# @param uuid               The UUID of the weapon you want get the damage
static func get_weapon_damage(var uuid):

	# Get data
	var data = get_item_data(uuid, item_db.ItemCategory.WEAPON)
	if not data:
		print("[questie]: can't retrieve data from weapon with [uuid]: " + uuid)
		return

	return rand_range(data.min_damage, data.max_damage)
	

# TODO: not yet ported
func add_item(var inventory, var item, var is_player_inv : bool = false): pass

func _enter_tree():

	# Generate items map
	if not item_db:
		print("[questie]: item database not loaded!")
		return

	# Generate maps
	if item_db.weapons.size() > 0:
		for weapon in item_db.weapons:
			weapons[weapon.title] = weapon.uuid

	if item_db.armors.size() > 0:
		for armor in item_db.armors:
			armors[armor.title] = armor.uuid

	if item_db.consumables.size() > 0:
		for consumable in item_db.consumables:
			consumables[consumable.title] = consumable.uuid

	if item_db.materials.size() > 0:
		for material in item_db.materials:
			materials[material.title] = material.uuid

	if item_db.specials.size() > 0:
		for special in item_db.specials:
			specials[special.title] = special.uuid
