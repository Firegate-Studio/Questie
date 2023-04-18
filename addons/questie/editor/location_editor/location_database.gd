tool
extends Resource
class_name LocationDatabase

# database identifier
var id 

# all location categories(i.e., village, town, ..., etc.)
export(Dictionary) var data = {}

func add_category(category):
	data[category] = []

func remove_category(category):
	data.erase(category)

func add_location(category, location_data):
	if not data.has(category):
		print("[Questie]: category for " + var2str(location_data) + " was not found!")
		return

	var all_locations = data[category]
	all_locations.add(location_data)

# remove all unwanted keys or 'old names' from dictionary 
func clenup_categories(categories):

	for item in data:
		if not categories.has(item):

			print("[Questie]: removing " + item)
			remove_category(item)
