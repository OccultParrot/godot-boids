extends Sprite2D

@export var id: int
@export var neighbor_distance: float
@export var avoid_distance: float = 50.0
@export var avoid_factor: float
@export var matching_factor: float
@export var centering_factor: float
@export var turn_speed: float = 0.5
@export var margin: float = 50
@export var max_speed: float = 5
@export var min_speed: float = 1

var velocity: Vector2

func _ready() -> void:
	velocity = Vector2.ZERO

func step(viewport: Viewport, all_boids: Array, bounds: Rect2):
		
	var close_distance: Vector2 = Vector2.ZERO
	var average_velocity: Vector2 = Vector2.ZERO
	var average_position: Vector2 = Vector2.ZERO
	var neighbor_count: int = 0
	for boid in all_boids:
		# If the other boid is too far away from this boid, ignore it
		if position.distance_to(boid.position) > neighbor_distance:
			continue
		
		# If the other boid is too close to this boid, add it to the offset of positions too close but dont count it as a neighbor
		if position.distance_to(boid.position) < avoid_distance:
			close_distance += position - boid.position
			continue
		
		# Adding together the positions and velocities so we can calulate the average
		average_velocity += boid.velocity
		average_position += boid.position
		neighbor_count += 1

	# if there is atleast one neighbor, calculate the average
	if neighbor_count > 0:
		average_velocity = average_velocity / neighbor_count
		average_position = average_position / neighbor_count
	
	# Add the close boid offset, and the velocity and position averages to the boids velocity
	velocity += close_distance * avoid_factor
	velocity += (average_velocity - velocity) * matching_factor
	velocity += (average_position - position) * centering_factor
	
	# Get the speed so we can set limits
	var speed = sqrt(velocity.x * velocity.x + velocity.y * velocity.y)
	if speed > max_speed:
		velocity = (velocity/speed) * max_speed
	elif speed < min_speed:
		velocity = (velocity/speed) * min_speed
	
	# Make the boid avoid leaving the screen
	if position.x < 0 + margin:
		velocity.x = velocity.x + turn_speed
	if position.x > bounds.size.x - margin:
		velocity.x = velocity.x - turn_speed
	if position.y < 0 + margin:
		velocity.y = velocity.y + turn_speed
	if  position.y > bounds.size.y - margin:
		velocity.y = velocity.y - turn_speed
		
	# and finally actually move it
	position += velocity
