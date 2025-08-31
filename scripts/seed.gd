extends Node2D
@export_range(0, 10000000) var boid_count: int
@export var bounds: Rect2

@export_category("Boid Settings")
@export_range(0, 10000) var neighbor_distance: float = 40
@export_range(0, 10000) var avoid_distance: float = 80.0
@export_range(0, 1) var avoid_factor: float = 0.05
@export_range(0, 1) var matching_factor: float = 0.05
@export_range(0, 1) var centering_factor: float = 0.0005
@export_range(0, 1) var turn_speed: float = 0.2
@export_range(0, 10000) var margin: float = 50
@export_range(0, 100) var max_speed: float = 6
@export_range(0, 100) var min_speed: float = 3

func generate_boid(viewport: Viewport, script: Script, index: int):
	var child = Sprite2D.new()
	child.scale = Vector2(10, 10)
	child.texture = PlaceholderTexture2D.new()
	
	#var angle = (index * 2.0 * PI) / boid_count
	#var radius = 200.0 
	#child.position = Vector2(cos(angle) * radius, sin(angle) * radius)
	
	child.position = Vector2(randf_range(0, viewport.size.x), randf_range(0, viewport.size.y))
	
	child.set_script(script)
	child.set("id", index)
	child.set("neighbor_distance", neighbor_distance)
	child.set("avoid_distance", avoid_distance)
	child.set("avoid_factor", avoid_factor)
	child.set("matching_factor", matching_factor)
	child.set("centering_factor", centering_factor)
	child.set("turn_speed", turn_speed)
	child.set("margin", margin)
	child.set("max_speed", max_speed)
	child.set("min_speed", min_speed)
	
	return child
	
	
func _ready() -> void:
	var viewport = get_viewport()
	var boid_script = load("res://scripts/boid.gd")
	for i in range(boid_count):	
		add_child(generate_boid(viewport, boid_script, i))
		
	# For testing
	#print_tree_pretty()

func _process(delta: float) -> void:
	var viewport = get_viewport()
	var all_boids = []
	
	for child in get_children():
		if child.has_method("step"):
			all_boids.append(child)
	
	for boid in all_boids:
		boid.step(viewport, all_boids, bounds)
