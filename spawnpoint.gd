extends Area2D


var is_locked = false


func _process(delta):
	is_locked = has_overlapping_bodies()
