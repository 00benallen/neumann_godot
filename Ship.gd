extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const StateLabels = {
	PLANET_ORBITED_POS = "PLANET_ORBITED_POS"
}

var target = Vector2()
var velocity = Vector2()
var asteroid_being_mined = null

var speed = 200
onready var texture = $TextureRect

signal moved
signal mining

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	target = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
   # Mouse in viewport coordinates
	if event is InputEventMouseButton and event.get_button_index() == BUTTON_LEFT:
#		print("Mouse Click/Unclick screen coords: ", event.position)
#		print("Mouse Click/Unclick world coords", get_global_mouse_position())
#		print("Viewport Resolution is: ", get_viewport_rect().size)
		target = get_global_mouse_position()
		texture.set_rotation(rotation + get_angle_to(target) + 1.5708)
	
	if event.is_action_pressed("ui_select"):
		emit_signal("mining")

	# Print the size of the viewport

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	velocity = calc_velocity_to_target()
	
	# If player is moving, basically
	if is_moving():
		velocity = velocity.normalized() * speed
#		print("Ship position", position, " and velocity", velocity)
	
	var collision = move_and_collide(velocity * delta)
	emit_signal("moved", position)
	if collision:
		var collider = collision.collider
#		print("Ship hit something", collider.name)
		
		if "Planet" in collider.name and collider.orbitable:
#			print("Found resources in system ", resources)
			get_tree().change_scene("res://OrbitPlanet.tscn")
			State.set_state_propery(StateLabels.PLANET_ORBITED_POS, collider.get_global_position())
		elif "Asteroid" in collider.name:
			if (asteroid_being_mined == null):
				connect("mining", collider, "_on_Ship_mine")
				print("Connected mining signal to collided asteroid")
				asteroid_being_mined = collider;
	else:
		if asteroid_being_mined != null:
			disconnect("mining", asteroid_being_mined, "_on_Ship_mine")
			asteroid_being_mined = null
			print("Disconnected asteroid from mining signal")

func calc_velocity_to_target():
	var velocity = Vector2()
	
#	var centroid = Vector2(position.x + width/2, position.y + height/2)
	
	if position.distance_to(target) > 3:
    	velocity = (target - position).normalized() * speed
	else:
		velocity = Vector2()
	return velocity
	
func is_moving():
	return velocity.length() > 0
