# Represents a database for all in-game objects

tool
extends Resource
class_name ItemDatabase

# the unique identifier of the database
export(String) var uuid

# An array for all weapon items
export(Array, Resource) var weapons

# An array for all armor items
export(Array, Resource) var armors

# An array for all consumable items
export(Array, Resource) var consumables

# An array for all material items
export(Array, Resource) var materials

# An array for all special/unique items
export(Array, Resource) var specials

enum ItemCategory{
    NONE,
    WEAPON,             # An item that can deal physic or magic damage
    ARMOR,              # An item that provides physic and magic defence and resistances
    CONSUMABLE,         # An item used for dedicates uses (i.e., recover health, apply poison, ..., etc)
    MATERIAL,           # An item used for crafting and/or building recipes
    SPECIAL             # A unique object delegated from the story or other mansions
}

# @brief                        Add new item data to database
# @parameter category           the kind of item to add
# @return data as Resource
func push_item(var category : int):
    
    # The data to store
    var result
    match category:
        ItemCategory.WEAPON: 
            result = load("res://addons/questie/editor/item_editor/weapon_data.gd").new()
            result.uuid = UUID.generate()
            weapons.push_back(result)
            return result
        ItemCategory.ARMOR:
            result = load("res://addons/questie/editor/item_editor/item_data.gd").new()
            result.uuid = UUID.generate()
            armors.push_back(result)
            return result
        ItemCategory.CONSUMABLE:
            result = load("res://addons/questie/editor/item_editor/item_data.gd").new()
            result.uuid = UUID.generate()
            consumables.push_back(result)
            return result
        ItemCategory.MATERIAL:
            result = load("res://addons/questie/editor/item_editor/item_data.gd").new()
            result.uuid = UUID.generate()
            materials.push_back(result)
            return result
        ItemCategory.SPECIAL:
            result = load("res://addons/questie/editor/item_editor/item_data.gd").new()
            result.uuid = UUID.generate()
            specials.push_back(result)
            return result

# @brif                             Remove an item from DB
# @param uuid                       the uuid corrispondint to the item to remove
# @param category                   the category owning the item to remove. See [ItemCategory] for possibile values
func erase_item(var uuid, var category : int):
    match category:
        ItemCategory.WEAPON:

            # Search for any UUID valid in weapons array               
            for item in weapons:

                # Check if  not the correct item
                if not item.uuid == uuid: continue

                weapons.erase(item)
                print("[questie]: weapon removed from database")
                return
                
        ItemCategory.ARMOR:      

            # Search for any UUID valid in armors array               
            for item in armors:

                # Check if  not the correct item
                if not item.uuid == uuid: continue

                armors.erase(item)
                print("[questie]: armor removed from database")
                return

        ItemCategory.CONSUMABLE:            
            
            # Search for any UUID valid in weapons array               
            for item in consumables:

                # Check if  not the correct item
                if not item.uuid == uuid: continue

                consumables.erase(item)
                print("[questie]: consumable removed from database")
                return

        ItemCategory.MATERIAL:              
            
            # Search for any UUID valid in weapons array               
            for item in materials:

                # Check if  not the correct item
                if not item.uuid == uuid: continue

                materials.erase(item)
                print("[questie]: material removed from database")
                return

        ItemCategory.SPECIAL:               
            
            # Search for any UUID valid in weapons array               
            for item in specials:

                # Check if  not the correct item
                if not item.uuid == uuid: continue

                specials.erase(item)
                print("[questie]: special removed from database")
                return
