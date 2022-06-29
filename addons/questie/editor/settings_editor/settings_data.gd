class_name SettingsData, "res://addons/questie/editor/icons/settings.png"
extends Resource


export(String) var uuid = UUID.generate()
export(Resource) var general_settings = null
export(Resource) var items_settings = preload("res://addons/questie/editor/settings_editor/items_settings_data.gd").new()


