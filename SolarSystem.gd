extends Node2D

const StateLabels = {
	ASTEROIDS = "ASTEROIDS",
	PLANETS = "PLANETS",	
}
export var n_planets = 9
export var n_asteroids = 30
export var orbit_speed = 0.005
export var max_radius_planets = 400
export var radius_asteroids = 250

export (PackedScene) var Planet
export (PackedScene) var Asteroid

const Ship = preload("Ship.gd")

var planets = []
var asteroids = []

class BodyData:
	var position: Vector2
	
	func _init(position: Vector2):
		self.position = position

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var planets_data = State.get_state_property(StateLabels.PLANETS)
	var asteroids_data := State.get_state_property(StateLabels.ASTEROIDS)
	
	if (planets_data != null and asteroids_data != null):
		instantiate_bodies(planets_data, asteroids_data)
	else :
		generate_bodies()
		
	var last_orbited_planet_position = State.get_state_property(Ship.StateLabels["PLANET_ORBITED_POS"])
	if (last_orbited_planet_position != null):
		var ship_spawn_pos = last_orbited_planet_position - Vector2(-80, -80)
		$"../Ship".position = ship_spawn_pos
		$"../Ship".target = ship_spawn_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sun.rotation += orbit_speed * delta
		
	
func generate_bodies():
	for i in range(n_planets):
		var rand_comp_a = fmod(randf(),  2.0)
		var rand_comp_r = fmod(randf(),  2.0)
		var a = rand_comp_a * 2 * PI
		var r = max_radius_planets * sqrt(rand_comp_r)
		var planet_position = Vector2(r * cos(a), r * sin(a))
		create_planet(planet_position)
		
	for i in range(n_asteroids):
		var rand_angle = fmod(randf(), 2.0)*PI*2;
		var asteroid_position = Vector2(radius_asteroids * cos(rand_angle), radius_asteroids * sin(rand_angle))
		create_asteroid(asteroid_position)
		
	State.set_state_propery(StateLabels.PLANETS, nodes_to_body_data(planets))
	State.set_state_propery(StateLabels.ASTEROIDS, nodes_to_body_data(asteroids))
	
func nodes_to_body_data(nodes: Array) -> Array:
	var body_data = []
	for node in nodes:
		body_data.append(BodyData.new(node.position))
	return body_data
	
func instantiate_bodies(planets_data, asteroids_data):
	print("Restoring SolarSystem state from memory")
	for plan in planets_data:
		create_planet(plan.position)
	for ast in asteroids_data:
		create_asteroid(ast.position)

func create_planet(planet_position):
	var new_planet = Planet.instance()
	$Sun.add_child(new_planet)
	planets.append(new_planet)
	new_planet.position = planet_position
	new_planet.orbitable = true

func create_asteroid(asteroid_position):
	var new_asteroid = Asteroid.instance()
	$Sun.add_child(new_asteroid)
	asteroids.append(new_asteroid)
	new_asteroid.position = asteroid_position
