extends Node2D
class_name Boost


@export var duration := 1.0


var duration_timer := 0.0
var target


func _process(delta):
	duration_timer += delta
	if duration_timer >= duration:
		if target:
			cancel_effect()
		queue_free()


func start(who):
	target = who
	apply_effect()


func apply_effect():
	pass


func cancel_effect():
	pass
