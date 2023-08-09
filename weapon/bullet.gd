extends AnimatableBody2D

var velocity
var damage : float
var life_time : float
var current_life_time : float = 0.0

func _process(delta):
	var col = move_and_collide(global_transform.basis_xform(velocity))
	if col:
		var collider = col.get_collider()
		if collider.has_method("damage"):
			collider.damage(damage)
		queue_free()
	else:
		current_life_time += delta
		if current_life_time > life_time:
			queue_free()


func push(vel):
	velocity = vel
