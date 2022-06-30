tool
extends Tree

#---Signals----------------------
# Called when the inventory item is selected
signal inventory_selected(tree_item)

# Called when selecting invalid item or area
signal invalid_selection()
#--------------------------------

# The very root node of the tree
var root : TreeItem

# All settings categories list
var categories : Array
#---Categories---------------------
var general : TreeItem = null
var items : TreeItem = null
#---Items--------------------------
var inventory : TreeItem = null

# @brief                    Create a tree subnode
# @param parent             The parent of the node 
# @param name               The node name
# @param icon_path          The path to the icon as [string]
# @param icon_size          The maximum width of the icon
# @param selectable         Set if the node is selectable from the user
# @result                   The node as [TreeItem]
func add_subnode(var parent : TreeItem, var name : String, var icon_path : String, var icon_size : float, var selectable : bool = false)->TreeItem:
     
    var result = create_item(parent)
    result.set_text(0, name)
    result.set_icon(0, load(icon_path))
    result.set_icon_max_width(0, icon_size)
    result.set_editable(0, false)
    result.set_selectable(0, selectable)
    result.set_custom_as_button(0, true)

    return result

func setup_categories()->void:

    # Create categories
    general = add_subnode(root, "General", "res://addons/questie/editor/icons/settings.png", 32)
    items = add_subnode(root, "Items", "res://addons/questie/editor/icons/package.png", 32)

    # Register categories
    categories.push_back(general)
    categories.push_back(items)

func setup_categories_args()->void:

    inventory = add_subnode(items, "Inventory", "res://addons/questie/editor/icons/inventory.png", 32, true)

# Called when an item is selected from tree-view
func item_selected():

    # Get selected item
    var selected = get_selected()

    if categories.has(selected):
        return

    dispatch_selection_signal(selected)

# Called when an invalid items is selected (i.e, empty area)
func nothing_selected():
    
    print("[questie]: invalid selection")
    emit_signal("invalid_selection")

# Call signal for item selection
func dispatch_selection_signal(var context : TreeItem):
    if context == inventory:
        print("[questie]: inventory setting selected")
        emit_signal("inventory_selected", inventory)
        return


func _enter_tree():

    # Initial setup
    root = create_item(null)
    setup_categories()
    setup_categories_args()

    connect("item_selected", self, "item_selected")
    connect("nothing_selected", self, "nothing_selected")

func _exit_tree():

    disconnect("item_selected", self, "item_selected")
    disconnect("nothing_selected", self, "nothing_selected")

