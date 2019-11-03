extends Camera2D

var zoom_step = 1.1
var maximum_zoom_in = 0.15
var minimum_zoom_out = 4
var trackpad_zoom_sensitivity = 0.05
var mouse_captured = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	handle_regular_mouse(event)
	
	# Can't handle trackpad in InputMap, handle manually
	if event is InputEventPanGesture:
		var zoom_amount = event.delta.y * trackpad_zoom_sensitivity
		var new_zoom = zoom.y + zoom_amount
		if (new_zoom < maximum_zoom_in):
			new_zoom = maximum_zoom_in
		elif (new_zoom > minimum_zoom_out):
			new_zoom = minimum_zoom_out
		zoom = Vector2(new_zoom, new_zoom)
	
func handle_regular_mouse(event):
	if event.is_action_pressed("view_zoom_in"):
		zoom /= zoom_step
		_snap_zoom_limits()
	if event.is_action_pressed("view_zoom_out"):
		zoom *= zoom_step
		_snap_zoom_limits()
	
	if event.is_action_pressed("view_pan_mouse"):
		mouse_captured = true
	elif event.is_action_released("view_pan_mouse"):
		mouse_captured = false

	if mouse_captured && event is InputEventMouseMotion:
		offset -= event.relative * zoom #like we're grabbing the map

func _snap_zoom_limits():
	zoom.x = clamp(zoom.x, maximum_zoom_in, minimum_zoom_out)
	zoom.y = clamp(zoom.y, maximum_zoom_in, minimum_zoom_out)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
