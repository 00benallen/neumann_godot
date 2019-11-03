extends Node

var state_dict: Dictionary = {}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_state_dict() -> Dictionary:
	return state_dict
	
func get_state_property(label: String) -> Object:
	if State.get_state_dict().has(label):
		return State.get_state_dict()[label]
	else:
		return null

func set_state_dict(new_dict: Dictionary):
	state_dict = new_dict

func set_state_propery(label: String, value):
	State.get_state_dict()[label] = value
	print("[State] State propery %s set to %s" % [label, value])
	

