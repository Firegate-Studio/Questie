tool
extends Tree
class_name VariablesTree

export(Texture) var boolean_icon
export(Texture) var integer_icon
export(Texture) var decimal_icon
export(Texture) var deletion_icon

func _enter_tree():

    var root = create_item()

    set_column_title(0, "variable")
    set_column_title(1, "type")
    set_column_title(2, "value")

func create_boolean_item(name: String):
    var item = create_item()
    item.set_text(0, name)
    item.set_text_align(0, 1)
    item.set_editable(0, true)
    item.set_custom_as_button(0, true)
    item.add_button(3, deletion_icon)

    item.set_text(1, "boolean")
    item.set_text_align(1, 1)
    item.set_text(2, "false")
    item.set_text_align(2, 1)
    item.set_editable(2, true)

func create_integer_item(name: String):
    var item = create_item()
    item.set_text(0, name)
    item.set_text_align(0, 1)
    item.set_editable(0, true)
    item.set_custom_as_button(0, true)
    item.add_button(3, deletion_icon)

    item.set_text(1, "integer")
    item.set_text_align(1, 1)
    item.set_text(2, "0")
    item.set_text_align(2, 1)
    item.set_editable(2, true)

func create_decimal_item(name: String):
    var item = create_item()
    item.set_text(0, name)
    item.set_text_align(0, 1)
    item.set_editable(0, true)
    item.set_custom_as_button(0, true)
    item.add_button(3, deletion_icon)

    item.set_text(1, "decimal")
    item.set_text_align(1, 1)
    item.set_text(2, "0.0")
    item.set_text_align(2, 1)
    item.set_editable(2, true)
