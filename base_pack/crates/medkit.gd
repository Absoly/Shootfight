extends RigidBody2D

func interact(target: Object):
	if target.has_method("heal"):
		target.heal(50)
		queue_free()
