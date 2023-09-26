extends Object
class_name RewardCallbacksHandler

var add_alignment_callbacks : RewardCallbacks_AddAlignment
var add_item_callbacks : RewardCallbacks_AddItem

func add_callbacks(block, data): 
    if block is RewardBlock_AddAlignment:
        add_alignment_callbacks.add_listeners(block, data)
    if block is RewardBlock_AddItem:
        add_item_callbacks.add_listeners(block, data)

func remove_callbacks(block): 
    if block is RewardBlock_AddAlignment:
        add_alignment_callbacks.remove_listeners(block)
    if block is RewardBlock_AddItem:
        add_item_callbacks.remove_listeners(block)

func _init():
    add_alignment_callbacks = RewardCallbacks_AddAlignment.new()
    add_item_callbacks = RewardCallbacks_AddItem.new()