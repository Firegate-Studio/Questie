class_name Task_CollectItem
extends "res://addons/questie/editor/quest_editor/quest_task.gd"

export(String) var item_uuid                                    # The UUID of the item to track inside player inventory
export(ItemDatabase.ItemCategory) var category                  # Tha ItemCategory of the tracked item
export(int) var quantity = 1                                    # The amount needed to complete the task
