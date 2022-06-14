# The [QuestieModule] is responsable for manage the [QuestEditorTool] lifecycle and functionality.
# If your are looking for some tool functionality; the tool-chain shoudl be placed here

# If you notice a bug or you want let me know how I can improve this tool; write me at questie@firegate-studio.com or open an issue at https://github.com/Firegate-Studio/Questie.git

tool
extends EditorPlugin
class_name QuestieModule

# The database that contains all quest of the game
var quest_database 

# The database that contains all items of the game
var item_database

var quest_editor = preload("res://addons/questie/editor/main.tscn")
var quest_editor_instance

func get_plugin_name(): return "Questie"

func get_plugin_icon(): return get_editor_interface().get_base_control().get_icon("Spatial", "EditorIcons")

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
	if !file.file_exists("res://questie/quest-db.tres"):
		print("[questie]: creating quest database...")
		quest_database = QuestDatabase.new()
		quest_database.uuid = UUID.generate()
		quest_database.purge()
		ResourceSaver.save("res://questie/quest-db.tres", quest_database)
		print("[questie]: quest database created at path res://questie/quest-db.tres")

	if not file.file_exists("res://questie/item-db.tres"):
		print("[questie]: creating item database...")
		item_database = ItemDatabase.new()
		item_database.uuid = UUID.generate()
		ResourceSaver.save("res://questie/item-db.tres", item_database)
		print("[questie]: item database created at path res://quesite/item-db.tres")


	# loading questie interface
	quest_editor_instance = quest_editor.instance()
	get_editor_interface().get_editor_viewport().add_child(quest_editor_instance)
	make_visible(false)

	print("[questie]: questie initialized successfully")

func _exit_tree(): 
	if quest_editor_instance:
		quest_editor_instance.queue_free()

