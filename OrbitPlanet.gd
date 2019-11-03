extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Ship_moved(ship_position):
#	print("Ship position", ship_position)
	if ship_position.distance_to($CentralPlanet.position) > 500:
		get_tree().change_scene("res://SolarSystem.tscn")
