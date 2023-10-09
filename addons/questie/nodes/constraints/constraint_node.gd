extends "res://addons/questie/nodes/questie_node.gd"
class_name Constraint

signal constraint_passed(constraint_id)
signal constraint_failed(constraint_id)

# define if the constraint rule has been bypassed or not
var bypassed : bool = false
