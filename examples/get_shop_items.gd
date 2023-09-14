extends Node

onready var vendor : QuestieVendor

func _ready():
	
	if not get_parent() is QuestieVendor: return
	vendor = get_parent()
	
	# get items data
	var shop_items = vendor.get_shop_data() 
	
	if shop_items.size() == 0: return
	
	# iterate shop items
	var i : int = 0
	for data in shop_items:
		i += 1
		
		# print information
		print("item " + var2str(i) + 
		" name: " + data.name + 
		" | icon: " + var2str(data.icon) + 
		" | price: " + var2str(data.value) + 
		" | quantity: " + var2str(data.quantity))
