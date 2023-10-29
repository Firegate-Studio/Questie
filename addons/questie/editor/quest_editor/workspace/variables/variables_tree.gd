tool
extends Tree
class_name VariablesTree

export(Texture) var boolean_icon
export(Texture) var integer_icon
export(Texture) var decimal_icon
export(Texture) var deletion_icon

var variables_db : VariableDatabase = null

var all_booleans = []
var all_integers = []
var all_decimals = []

var variables_id_map = {}

func _enter_tree():

    var root = create_item()

    set_column_title(0, "variable")
    set_column_title(1, "type")
    set_column_title(2, "value")

    if variables_db: return

    variables_db = ResourceLoader.load("res://questie/variables.tres")
    if not variables_db:
        print("[Questie]: can't load the variables database!")
        return

    load_items()
    
    connect("button_pressed", self, "handle_button_pressed")
    connect("item_edited", self, "handle_item_edited")

func _exit_tree():
    disconnect("button_pressed", self, "handle_button_pressed")
    disconnect("item_edited", self, "handle_item_edited")

func handle_button_pressed(item : TreeItem, column : int, index : int):

    # NOTE: the index 0 is the deletion button - create item procedures type to add and recognize further procedures
    remove_item(item)

func handle_item_edited():
    var selected_item : TreeItem = get_selected()
    var item_id : String = variables_id_map[selected_item]

    if is_boolean(selected_item):
        var data : BooleanData = variables_db.get_boolean_data(item_id)
        data.name = selected_item.get_text(0)
        
        # parse text to value
        if selected_item.get_text(2) == "true":
            data.value = true
        elif selected_item.get_text(2) == "false":
            data.value = false
        else:
            data.value = false
            selected_item.set_text(2, "false")
        
        ResourceSaver.save("res://questie/variables.tres", variables_db)

    if is_integer(selected_item):
        var data : IntegerData = variables_db.get_integer_data(item_id)
        data.name = selected_item.get_text(0)
        data.value = str2var(selected_item.get_text(2))
        ResourceSaver.save("res://questie/variables.tres", variables_db)


    if is_decimal(selected_item):
        var data : DecimalData = variables_db.get_decimal_data(item_id)
        data.name = selected_item.get_text(0)
        data.value = str2var(selected_item.get_text(2))
        ResourceSaver.save("res://questie/variables.tres", variables_db)


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

    # Generate and save data
    var data = VariableBuilder.boolean()
    data.name = name
    variables_db.add_boolean_data(data)
    ResourceSaver.save("res://questie/variables.tres", variables_db)

    # record new variable
    all_booleans.append(item)
    variables_id_map[item] = data.id

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

    # Generate and save data
    var data = VariableBuilder.integer()
    data.name = name
    variables_db.add_integers(data)
    ResourceSaver.save("res://questie/variables.tres", variables_db)

    # record new variable
    all_integers.append(item)
    variables_id_map[item] = data.id

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

    # Generate and save data
    var data = VariableBuilder.decimal()
    data.name = name
    variables_db.add_decimal_data(data)
    ResourceSaver.save("res://questie/variables.tres", variables_db)
 
    # record new variable
    all_decimals.append(item)
    variables_id_map[item] = data.id

func remove_item(item : TreeItem):
    
    var item_id = variables_id_map[item]
    if item_id == "":
        print("[Questie]: can't find variable identifier!")
        return
    
    if is_boolean(item):
        # erase data from database
        variables_db.remove_boolean_data(item_id)
        ResourceSaver.save("res://questie/variables.tres", variables_db)

        # clear references
        all_booleans.erase(item)
        variables_id_map.erase(item)

    if is_integer(item):
        # erase data from database
        variables_db.remove_integers(item_id)
        ResourceSaver.save("res://questie/variables.tres", variables_db)
 
        # clear references
        all_integers.erase(item)
        variables_id_map.erase(item)

    if is_decimal(item):
        # erase data from database
        variables_db.remove_decimal_data(item_id)
        ResourceSaver.save("res://questie/variables.tres", variables_db)
 
        # clear references
        all_decimals.erase(item)
        variables_id_map.erase(item)
    
    item.free()


func load_items():

    # load all booleans 
    for data in variables_db.booleans:
        var item = create_item()
        item.set_text(0, data.name)
        item.set_text_align(0, 1)
        item.set_editable(0, true)
        item.set_custom_as_button(0, true)
        item.add_button(3, deletion_icon)

        item.set_text(1, "boolean")
        item.set_text_align(1, 1)
        item.set_text(2, var2str(data.value))
        item.set_text_align(2, 1)
        item.set_editable(2, true)

        all_booleans.append(item)
        variables_id_map[item] = data.id

    # load all integers
    for data in variables_db.integers:
        var item = create_item()
        item.set_text(0, data.name)
        item.set_text_align(0, 1)
        item.set_editable(0, true)
        item.set_custom_as_button(0, true)
        item.add_button(3, deletion_icon)

        item.set_text(1, "integer")
        item.set_text_align(1, 1)
        item.set_text(2, var2str(data.value))
        item.set_text_align(2, 1)
        item.set_editable(2, true)

        all_integers.append(item)
        variables_id_map[item] = data.id

    # load all decimals
    for data in variables_db.decimal:
        var item = create_item()
        item.set_text(0, data.name)
        item.set_text_align(0, 1)
        item.set_editable(0, true)
        item.set_custom_as_button(0, true)
        item.add_button(3, deletion_icon)

        item.set_text(1, "decimal")
        item.set_text_align(1, 1)
        item.set_text(2, var2str(data.value))
        item.set_text_align(2, 1)
        item.set_editable(2, true)

        all_decimals.append(item)
        variables_id_map[item] = data.id


func is_boolean(item : TreeItem)->bool: return all_booleans.has(item)
func is_integer(item : TreeItem)->bool: return all_integers.has(item)
func is_decimal(item : TreeItem)->bool: return all_decimals.has(item)
