tool
extends Object
class_name QuestCompiler

const FILE_PATH = "res://questie/quest.generated.gd"

static func compile():

    var quest_database : QuestDatabase = ResourceLoader.load("res://questie/quest-db.tres")
    if not quest_database:
        print("[Questie]: the quest database was not found!")
        return

    var file = File.new()
    file.open(FILE_PATH, File.WRITE)

    print("[Questie]: quest compilation started...")
    file.store_string("tool\n")
    file.store_string("extends Object\n")
    file.store_string("class_name GameQuests\n\n")

    # generate quest enums
    file.store_string("enum Quests{\n")

    for quest_data in quest_database.quests:
        var fixed_quest_name : String = get_fixed_quest_name(quest_data.title)
        file.store_string(fixed_quest_name + ",\n")

    file.store_string("}\n\n")

    # generate quest map
    file.store_string("const quest_id_map = {\n")
    
    for quest_data in quest_database.quests:
        var fixed_name = get_fixed_quest_name(quest_data.title)
        var row = generate_map_row("Quests."+fixed_name, quest_data.id)
        file.store_string(row + ",\n")
    
    file.store_string("}\n\n")
    file.close()

    print("[Questie]: all quest compiled.")

static func get_fixed_quest_name(word : String)->String:
    var source = word
    var invalid_symbols = ["@", '-', '.']

    for symbol in invalid_symbols:
        source = source.replace(symbol, "")

    if " " in source:
        source = source.replace(" ", "_")

    return source

static func generate_map_row(key : String, value : String)->String:
    var template ="{KEY} : {VALUE}"
    return template.format({"KEY" : str2var(key), "VALUE": var2str(value)})

