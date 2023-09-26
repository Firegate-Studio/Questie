extends Object
class_name RewardCallbacksHandler

var add_item_callbacks : RewardCallbacks_AddItem

func add_callbacks(block, data): 
    if block is RewardBlock_AddAlignment:
        pass
    if block is RewardBlock_AddItem:
        add_item_callbacks.add_listeners(block, data)

func remove_callbacks(block): 
    if block is RewardBlock_AddAlignment:
        pass
    if block is RewardBlock_AddItem:
        add_item_callbacks.remove_listeners(block)

func _init():
    add_item_callbacks = RewardCallbacks_AddItem.new()