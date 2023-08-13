extends Boost

@export var speed_boost = 100.0


func apply_effect():
	target.acceleration += speed_boost


func cancel_effect():
	target.acceleration -= speed_boost
