tool
extends Resource
class_name VariableDatabase

export(String) var id

export var booleans : Array
export var integers : Array
export var decimal : Array

func add_boolean_data(boolean_data : BooleanData):
    booleans.append(boolean_data)

func remove_boolean_data(boolean_id : String):
    for data in booleans:
        if not data.id == boolean_id: continue
        booleans.erase(data)

func get_boolean_data(boolean_id : String)->BooleanData:
    for data in booleans:
        if not data.id == boolean_id: continue

        return data

    return null

func add_integers(integer_data : IntegerData):
    integers.append(integer_data)

func remove_integers(integer_id : String):
    for data in integers:
        if not data.id == integer_id: continue
        
        integers.erase(data)

func get_integer_data(integer_id : String)-> IntegerData:
    for data in integers:
        if not data.id == integer_id: continue

        return data

    return null

func add_decimal_data(decmial_data : DecimalData):
    decimal.append(decmial_data)

func remove_decimal_data(decimal_id : String):
    for data in decimal:
        if not data.id == decimal_id: continue

        decimal.erase(data)

func get_decimal_data(decimal_id : String)->DecimalData:
    for data in decimal:
        if not data.id == decimal_id: continue
        return data

    return null   