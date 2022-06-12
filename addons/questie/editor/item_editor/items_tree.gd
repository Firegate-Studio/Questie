tool
extends Tree

# The root node is the very root of the tree
var root

# All weapon objects are built under this item
var weapons

# All armor objects are built under this item
var armors

# All consumable objects are built under this item
var consumables

# All material objects are built under this item
var materials

# All special objects are build under this item
var specials

# @brief                Creates a root [TreeItem]
# @param title          the item name that will be displayed inside the tree
# @param icon           the path to the icon to load as item icon (displyed on the left side of the item)
func create_root(var title, var icon):

    # Create tree item
    var result = create_item(root)
    result.set_text(0, title)
    result.set_selectable(0, true)
    result.set_editable(0, false)
    result.set_expand_right(0, true)

    # Create icon
    result.set_custom_as_button(0, true)
    result.set_icon(0, load(icon))
    result.set_icon_max_width(0, 32)

    return result

func _enter_tree(): 

    # Construct root
    root = create_item(null)

    # Construct folders
    weapons = create_root("Weapons", "res://addons/questie/editor/icons/folder.png")
    armors = create_root("Armors", "res://addons/questie/editor/icons/folder.png")
    consumables = create_root("Consumables", "res://addons/questie/editor/icons/folder.png")
    materials = create_root("Materials", "res://addons/questie/editor/icons/folder.png")
    specials = create_root("Specials", "res://addons/questie/editor/icons/folder.png")

    # TODO: items loding
    print("[questie]: items loading not yet ported")

func _exit_tree(): pass