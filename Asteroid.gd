extends RigidBody2D

var percent_mined = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _on_Ship_mine():
	percent_mined += 25
	if (percent_mined >= 100):
		queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
