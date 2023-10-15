# The [QuestieModule] is responsable for manage the [QuestEditorTool] lifecycle and functionality.
# If your are looking for some tool functionality; the tool-chain shoudl be placed here

# If you notice a bug or you want let me know how I can improve this tool; write me at questie@firegateentertainment.com or open an issue at https://github.com/Firegate-Studio/Questie.git

tool
extends EditorPlugin
class_name QuestieModule

# The database that contains all quest of the game
var quest_database 

# the database who contains all quest chains
var quest_chain_database : ChainDatabase

# The database that contains all items of the game
var item_database

# the database that contains all locations of the game
var location_database

# the database that contains all characters of the game
var characters_database

# Stores tool settings data
var settings_data

var quest_editor = preload("res://addons/questie/editor/main.tscn")
var quest_editor_instance

func get_plugin_name(): return "Questie"

func get_plugin_icon(): 
	#return get_editor_interface().get_base_control().get_icon("Spatial", "EditorIcons")
	var icon = load("res://addons/questie/editor/icons/questie.png")
	return icon

func has_main_screen(): return true

func make_visible(visible):
	if quest_editor_instance:
		quest_editor_instance.visible = visible

func _enter_tree(): 
	print("[questie]: startup questie...")

	# If there is not a questie folder inside the project creates a new one.
	var dir = Directory.new()
	if !dir.dir_exists("res://questie"):
		print("[questie]: creating questie folder")
		dir.make_dir("res://questie")
		print("[questie]: questie folder created at path(res://questie)")
	
	# Creates the quest database and reference it if not exists anyone.
	var file = File.new()
	if not file.file_exists("res://questie/quest-db.tres"):
		print("[questie]: creating quest database...")
		quest_database = QuestDatabase.new()
		quest_database.uuid = UUID.generate()
		quest_database.purge()
		ResourceSaver.save("res://questie/quest-db.tres", quest_database)
		print("[questie]: quest database created at path res://questie/quest-db.tres")

	if not file.file_exists(QuestCompiler.FILE_PATH):
		print("[Questie]: generating quest file...")
		QuestCompiler.compile()
		print("[Questie]: quest file has been generated")

	if not file.file_exists("res://questie/chain-db.tres"):
		print("[Questie]: creating quest chain database...")
		quest_chain_database = ChainDatabase.new()
		quest_chain_database.id = UUID.generate()
		ResourceSaver.save("res://questie/chain-db.tres", quest_chain_database)
		print("[Questie]: chain database created at path res://questie/chain-db.tres")

	if not file.file_exists("res://questie/item-db.tres"):
		print("[questie]: creating item database...")
		item_database = ItemDatabase.new()
		item_database.id = UUID.generate()
		ResourceSaver.save("res://questie/item-db.tres", item_database)
		ItemsFileBuilder.generate_file()
		print("[questie]: item database created at path res://quesite/item-db.tres")

	if not file.file_exists("res://questie/location-db.tres"):
		print("[Questie]: creating locations database...")
		location_database = LocationDatabase.new()
		location_database.id = UUID.generate()
		ResourceSaver.save("res://questie/location-db.tres", location_database)
		LocationFileBuilder.create_file()
		print("[Questie]: location database created at path res://questie/location-db.tres")

	if not file.file_exists("res://questie/characters-db.tres"):
		print("[Questie]: creating characters database...")
		characters_database = CharacterDatabase.new()
		characters_database.id = UUID.generate()
		ResourceSaver.save("res://questie/characters-db.tres", characters_database)

	if not file.file_exists("res://questie/characters.generated.gd"):
		print("[Questie]: generating characters file...")
		CharactersFileGenerator.create()

	if not file.file_exists("res://questie/settings.tres"):
		print("[questie]: creating settings ...")
		settings_data = SettingsData.new()
		ResourceSaver.save("res://questie/settings.tres", settings_data)
		print("[questie]: settings saves created at path res://questie/settings.tres")


	# loading questie interface
	quest_editor_instance = quest_editor.instance()
	get_editor_interface().get_editor_viewport().add_child(quest_editor_instance)
	make_visible(false)

	print("[questie]: questie initialized successfully")

func _exit_tree(): 
	if quest_editor_instance:
		quest_editor_instance.queue_free()

