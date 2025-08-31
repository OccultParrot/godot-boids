@tool
extends Node2D

func _draw() -> void:
	var parent = get_parent()
	draw_rect(Rect2(
		parent.margin, 
		parent.margin, 
		parent.bounds.size.x - (2 * parent.margin), 
		parent.bounds.size.y - (2 * parent.margin)
	), Color.WHITE, false)

func _process(delta: float) -> void:
	# If you need the rectangle to update based on parent changes
	queue_redraw()
