extends Node2D

@export_range(0, 100) var boid_scale: float = 5
@export var view_distance: float = 40
@export var avoid_distance: float = 8
@export var avoid_factor: float = 0.05
@export var align_factor: float = 0.05
@export var cohesion_factor: float = 0.0005
@export var max_speed: float = 6
@export var min_speed: float = 3
@export var margin: float = 10
@export var turn_factor: float = 0.5

var velocity: Vector2 = Vector2.ZERO
var color: Color = Color.WHITE
var bounds: Rect2

func _ready():
	# Randomize the color for each boid
	var color_rng = randi_range(0, 2)
	match color_rng:
		0:
			color = Color.WHITE
		1:
			color = Color.PINK
		2:
			color = Color.LIGHT_BLUE
	
	# Randomize initial velocity
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * randf_range(min_speed, max_speed)

func _draw():
	draw_polyline(
		PackedVector2Array([
			Vector2(0, -boid_scale * 1.5),    # Top point
			Vector2(-boid_scale, boid_scale),   # Bottom left
			Vector2(boid_scale, boid_scale),    # Bottom right
			Vector2(0, -boid_scale * 1.5)     # Back to start to close the triangle
		]), color, 1.0
	)

func _process(_delta):
	# Boid movement logic
	var neighbor_count: int = 0
	var avoid_vector: Vector2 = Vector2.ZERO
	var average_velocity: Vector2 = Vector2.ZERO
	var average_position: Vector2 = Vector2.ZERO
	for boid in get_parent().get_children():
		var distance_to_boid = position.distance_to(boid.position)
		if boid == self or distance_to_boid > view_distance:
			continue
		# Separation behavior
		if distance_to_boid < avoid_distance:
			avoid_vector += position - boid.position
			continue # We dont want to align and group up with boids that are too close. Get away from me!
		
		# Getting the average velocity for alignment behavior
		average_velocity += boid.velocity
		# Getting the average position for cohesion behavior
		average_position += boid.position
		
		neighbor_count += 1
	
	# Applying separation vector
	velocity += avoid_vector * avoid_factor
	
	# Calculating and applying alignment and cohesion vectors if there are neighbors
	if neighbor_count > 0:
		average_velocity /= neighbor_count
		average_position /= neighbor_count
		
		# Applying alignment and cohesion vectors
		velocity += (average_velocity - velocity) * align_factor
		velocity += (average_position - position) * cohesion_factor
	
	
	# Rotate to face the direction of movement
	rotation = velocity.angle() + PI / 2
	
	# Slow those boids down! They are going too fast!
	var speed = sqrt(velocity.x * velocity.x + velocity.y * velocity.y)
	if speed > max_speed:
		velocity = (velocity / speed) * max_speed
	elif speed < min_speed:
		velocity = (velocity / speed) * min_speed
	
	# Avoid edges of the border
	if position.x < margin:
		velocity.x += turn_factor
	if position.x > get_viewport().size.x - margin:
		velocity.x -= turn_factor
	if position.y < margin:
		velocity.y += turn_factor
	if position.y > get_viewport().size.y - margin:
		velocity.y -= turn_factor
	
	position += velocity
	# Wrap around screen edges
# 	if position.x < margin:
# 		position.x += get_viewport().size.x
# 	elif position.x > get_viewport().size.x:
# 		position.x -= get_viewport().size.x
# 	if position.y < 0:
# 		position.y += get_viewport().size.y
# 	elif position.y > get_viewport().size.y:
# 		position.y -= get_viewport().size.y
	
