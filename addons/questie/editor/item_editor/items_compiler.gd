extends Object
class_name ItemsFileBuilder

const TARGET_PATH = "res://questie/items.generated.gd"

static func generate_file():

	var database = load("res://questie/item-db.tres")

	var file = File.new()
	file.open(TARGET_PATH, File.WRITE)

	#generate file
	file.store_string("extends Object \n")
	file.store_string("class_name ItemsCollection\n")
	file.store_string("\n")

	# generate categories
	file.store_string("enum Categories { \n")
	file.store_string("}\n")

	# generate items
	file.store_string("enum Items {\n")
	file.store_string("}\n")

	# generate items-map
	file.store_string("const items_map = {\n")
	file.store_string("}\n")

	file.close()

static func compile():
	var database = load("res://questie/item-db.tres")

	var file = File.new()
	file.open(TARGET_PATH, File.WRITE)

	#generate file
	file.store_string("extends Object \n")
	file.store_string("class_name ItemsCollection\n")
	file.store_string("\n")

	# generate categories
	file.store_string("enum Categories { \n")
	for category in database.categories:
		file.store_string(category.name + ",\n")
	file.store_string("}\n")

	 # generate items
	file.store_string("enum Items {\n")
	for item in database.items:
		file.store_string(normalize_text(item.name) + ",\n")
	file.store_string("}\n")

	# generate items
	file.store_string("const items_map = {\n")
	for item in database.items:
		file.store_string(generate_map_argument(str2var("Items.") + normalize_text(item.name), item.id) + ",\n")
	file.store_string("}\n")
	
	file.close()

static func normalize_text(text : String):
	var symbols = [" ", "-"]
	
	var result = text.replace(" ", "_")
	result = result.replace("-", "_")
	return result
	
static func generate_map_argument(item, id):
	var template = "{0} : {1}"
	var source = template.format([item, var2str(id)])
	return source
