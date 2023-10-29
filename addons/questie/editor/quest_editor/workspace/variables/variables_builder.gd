tool
extends Object
class_name VariableBuilder

static func boolean()->BooleanData:
    var data = BooleanData.new()
    if not data:
        print("[Questie]: can't build boolean variable")
        return null

    data.id = UUID.generate()
    data.name = "NewBoolean"
    return data

static func integer()->IntegerData:
    var data = IntegerData.new()
    if not data:
        print("[Questie]: can't build integer variable")
        return null

    data.id = UUID.generate()
    data.name = "NewInteger"
    return data

static func decimal()->DecimalData:
    var data = DecimalData.new()
    if not data:
        print("[Questie]: can't build decimal variable")
        return null

    data.id = UUID.generate()
    data.name = "NewDecimal"
    return data
