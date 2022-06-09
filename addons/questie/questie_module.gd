# The [QuestieModule] is responsable for manage the [QuestEditorTool] lifecycle and functionality.
# If your are looking for some tool functionality; the tool-chain shoudl be placed here

# If you notice a bug or you want let me know how I can improve this tool; write me at questie@firegate-studio.com or open an issue at https://github.com/Firegate-Studio/Questie.git

tool
extends EditorPlugin
class_name QuestieModule

# The database that contains all quest of the game
var quest_database 
var quest_editor = preload("res://addons/questie/editor/quest_editor/quest_editor.tscn").instance()

func get_plugin_name(): return "Questie"

func get_plugin_icon(): return get_editor_interface().get_base_control().get_icon("Spatial", "EditorIcons")

func has_main_screen(): return true

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

	get_editor_interface().get_editor_viewport().add_child(quest_editor)

func _exit_tree(): 
	if quest_editor:
		quest_editor.queue_free()

