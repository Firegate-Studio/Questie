tool
extends GraphEdit
class_name QuestDesignerGraph

var root_block : Block_QuestEdit
var quest_database : QuestDatabase
var popup : QuestDesignerPopup

# the current quest data associeted with this block
var current_data : QuestData

# blocks
var constraint_blocks : Array
var trigger_blocks : Array
var task_blocks : Array
var reward_blocks : Array

func _enter_tree(): 

	quest_database = load("res://questie/quest-db.tres")
	init_quest_block()
	init_popup()

	add_valid_connection_type(1,1)

	connect("connection_to_empty", self, "on_connection_to_empty")
	connect("connection_from_empty", self, "on_connection_from_empty")
	connect("connection_request", self, "on_connection_request")
	connect("disconnection_request", self, "on_disconnection_request")
	connect("popup_request", self, "on_popup_request")


func _exit_tree(): 
	disconnect("connection_to_empty", self, "on_connection_to_empty")
	disconnect("connection_from_empty", self, "on_connection_from_empty")
	disconnect("connection_request", self, "on_connection_request")
	disconnect("disconnection_request", self, "on_disconnection_request")
	disconnect("popup_request", self, "on_popup_request")


func on_connection_to_empty(from : String, from_slot: int, release_position : Vector2): 
	print("[Questie]: called connection to empty")

func on_connection_from_empty(to : String, to_slot : int, release_position : Vector2):
	print("[Questie]: called connection from empty")

func on_connection_request(from : String, from_slot : int, to : String, to_slot : int):
	print("[Questie]: attempting connection " + from + "(" + var2str(from_slot) + ") to " + to + "(" + var2str(to_slot) + ")")

	if is_node_connected(from, from_slot, to, to_slot):
		print("[Questie]: already connected")
		return

	var block = get_node(from)
	if not block:
		print("[Questie]: can not identify block to attempt connection")
		return

	if not is_valid_block(block):
		print("[Questie]: the block [" + from + "] has not been identified")
		return
	
	# identify block type
	if block is ConstraintBlock_IsLocation:
		root_block.add_constraint(QuestData.ConstraintType.IS_LOCATION, block)

	# todo: connect listeners to quest block
	# todo: save quest database
	connect_node(from, from_slot, to, to_slot)
	print("[Questie]: connected!")

func on_disconnection_request(from : String, from_port : int, to : String, to_port : int):
	print("[Questie]: attempting disconnection " + from + "(" + var2str(from_port) + ") to " + to + "(" + var2str(to_port) + ")")

	var block = get_node(from)
	if not block:
		print("[Questie]: can not identify block to attempt disconnection")
		return

	if not is_valid_block(block):
		print("[Questie]: the block [" + from + "] has not been identified")
		return

	# identify block
	if block is ConstraintBlock_IsLocation:
		root_block.remove_constraint(QuestData.ConstraintType.IS_LOCATION, block)

	disconnect_node(from, from_port, to, to_port)
	print("[Questie]: disconnected!")

func on_popup_request(position : Vector2): 
	print("[Questie]: popup requested...")
	
	popup.set_global_position(position)
	popup.show()

func on_is_location_block_requested():
	var block = ConstraintBlockBuilder.is_location_constraint()
	add_child(block)
	constraint_blocks.append(block)

	block.set_global_position(get_global_mouse_position())

	block.connect("close_request", self, "on_block_deletion_requested", [block])

	popup.hide()

func on_block_deletion_requested(block):

	# check if the block is connected to the quest block and disconnect 
	var connections = get_connection_list()
	for connection in connections:
		if not connection["from"] == block.name: continue
		
		# store data
		var from  = connection["from"]
		var from_port = connection["from_port"]
		var to = connection["to"]
		var to_port = connection["to_port"]
		
		disconnect_node(from, from_port, to, to_port)
		root_block.remove_constraint(get_block_type(block), block)
		break

	if constraint_blocks.has(block): constraint_blocks.erase(block)
	if trigger_blocks.has(block): trigger_blocks.erase(block)
	if task_blocks.has(block): task_blocks.erase(block)
	if reward_blocks.has(block): reward_blocks.erase(block)	

	remove_child(block)
	block.queue_free()
	
	

func init_quest_block():
	root_block = load("res://addons/questie/editor/quest_editor/blocks/quest_edit_block.tscn").instance()
	if not root_block:
		print("[Questie]: can't initialize quest block!")
		return

	root_block.offset += Vector2(600,350)
	add_child(root_block)

func init_popup():
	popup = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/QuestDesignerPopup.tscn").instance()
	if not popup:
		print("[Questie]: can not load quest designer popup!")
		return
	
	add_child(popup)
	popup.hide()

	# subscribe events
	popup.constraint_blocks_container.connect("is_location_block_requested", self, "on_is_location_block_requested")

# @brief                    initialize blocks and connections inside the graph
# @param quest_id           the quest identifier 
func setup(quest_id : String):
	if not quest_database:
		print("[Questie]: invalid quest database for QuestBuilderGraph")
		return

	var data = quest_database.get_quest_data(quest_id)
	if not data:
		print("[Questie]: invalid quest data for quest " + quest_id)

	root_block.setup(data)

	# todo - load constraint blocks
	# todo - load trigger blocks
	# todo - load task blocks
	# todo - load reward blocks

	# todo build connections

func is_valid_block(block): 
	return constraint_blocks.has(block) or trigger_blocks.has(block) or task_blocks.has(block) or reward_blocks.has(block)

func get_block_type(block):
	if block is ConstraintBlock_IsLocation:
		return QuestData.ConstraintType.IS_LOCATION



