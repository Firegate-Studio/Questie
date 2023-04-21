tool
extends Resource
class_name LocationDatabase

# database identifier
var id 

# all location categories(i.e., village, town, ..., etc.)
export(Array) var categories = []

export(Array) var locations = []

func has_category(id):
	for item in categories:
		if item.id == id: return true

	return false

func add_category(category):
	categories.push_back(category)

func remove_category(id):
	for category in categories:
		if not category.id == id: continue

		categories.erase(category)
		print("[Questie]: removed category from location database for category with identifier: " + id)
		break;

func add_location(location_data):
	locations.push_back(location_data)

func remove_location(location_id):
	
	for item in locations:
		if not item.id == location_id: continue

		locations.erase(item)
		print("[Questie]: removed location with identifier: " + location_id)
		break

# remove all unwanted keys or 'old names' from dictionary 
func clenup_categories(categories):

	for item in categories:
		if not categories.has(item):

			print("[Questie]: removing " + item)
			remove_category(item)
