extends AnimatableBody2D

@export var stay_in_ground : bool

var velocity
var damage : float
var life_time : float
var current_life_time : float = 0.0
var torque


func _process(delta):
	if transform.basis_xform(Vector2.RIGHT).x < 0:
		rotate(-torque * delta)
	else:
		rotate(torque * delta)
	var col = move_and_collide(global_transform.basis_xform(velocity))
	if col:
		var collider = col.get_collider()
		if stay_in_ground:
			velocity = Vector2.ZERO
			torque = 0
		else:
			queue_free()
		if collider.has_method("damage"):
			collider.damage(damage)
			queue_free()
	else:
		current_life_time += delta
		if current_life_time > life_time:
			queue_free()


func push(vel, torq):
	velocity = vel
	torque = torq
