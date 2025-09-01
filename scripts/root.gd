extends Node2D

@export var boid_count: int = 100

var boid_scene: PackedScene = preload("res://scenes/boid.tscn")
var bounds: Rect2
@export var margin: float = 200

func instantiate_boids(viewport: Viewport) -> void:
	# Instantiate a boid and set its position randomly within the viewport
	var boid_instance: Node2D = boid_scene.instantiate() as Node2D
	boid_instance.position = Vector2(
		randf_range(0, viewport.size.x),
		randf_range(0, viewport.size.y)
	)
	boid_instance.set("bounds", bounds)
	boid_instance.set("margin", margin)
	# Append the boid to the scene tree
	add_child(boid_instance)

func _ready() -> void:
	bounds = get_viewport_rect()
	var viewport = get_viewport()
	for i in range(boid_count):
		instantiate_boids(viewport)
	
	print(get_viewport().size)
	
func _draw() -> void:
	var margined_bounds = bounds.grow(-margin)
	draw_rect(margined_bounds, Color.from_string("5c5c5c", Color.RED), false, 2.0)
		
func _process(_delta: float) -> void:
	# Exit the application when Esc is pressed
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	print(get_local_mouse_position())
	queue_redraw()
