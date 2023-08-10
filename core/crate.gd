extends RigidBody2D


@export var weapon_scene : Array[PackedScene]

func _on_body_entered(body):
	if body.has_method("pick_weapon"):
		var weapon = weapon_scene.pick_random().instantiate()
		body.call_deferred("pick_weapon", weapon)
		queue_free()
