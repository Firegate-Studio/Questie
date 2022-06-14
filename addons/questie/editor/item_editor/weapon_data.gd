tool
extends "res://addons/questie/editor/item_editor/item_data.gd"

# the minimum damage dealt from this item
export(float) var min_damage

# the maximum damage dealt from this item
export(float) var max_damage

enum DamageType{
    PHYSIC,         # Base damage for each white-weapon such as swords, mace, ..., etc.
    FIRE,           # magic damage based on fire
    WATER,          # magic damage based on water
    NATURE,         # magic damage based on nature (i.e. poison, nature, ..., etc.)
    AIR,            # magic damage based on air
    LIGHT,          
    DARKNESS,
    SPIRIT          # magic damage based on spirit (i.e. conjuring, necromancy)
}

# the kind of damaged dealt from this weapon
export(int) var damage_type = DamageType.PHYSIC
