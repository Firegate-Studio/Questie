tool
class_name LocationFileBuilder

static func build():

	# retrieve database info
	var database = load("res://questie/location-db.tres")
	if not database:
		print("[Questie]: location database not found for location file builder")
		return

	var file_path = "res://questie/locations.generated.gd"
	var index_map = {}

	var file = File.new()

	print("[Questie]: generating location file...")
	file.open(file_path, File.WRITE)
	file.store_string("# This is a generated file - do not try to modify it manually \n")
	file.store_string("class_name GameLocations \n\n")
	file.store_string("enum Locations {\n")

	# generating locations
	for item in database.locations:
		var category = database.get_category(item.category_id)
		if not category: continue

		var category_name = remove_invalid_characters(category.title)
		var location_name = remove_invalid_characters(item.name)

		file.store_string(category_name + "_" + location_name + "\n")
		index_map[category_name + "_" + location_name] = item.id

	file.store_string("}\n\n")

	# generating index map
	file.store_string("# a dictionary containing all locations id associated to a location enumaration \n")
	file.store_string("var location_map = " + var2str(index_map) + "\n")

	file.close()
	   

static func remove_invalid_characters(word : String)->String:
	word.capitalize()
	
	while(word.find(" ") > -1):
		var index = word.find(" ")
		word[index] = "_"

	while(word.find("'") > -1):
		var index = word.find("'")
		word[index] = ""

	word.to_upper()

	return word





	
