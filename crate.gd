extends RigidBody2D


@export var weapon_scene : Array[PackedScene]

func _on_area_2d_body_entered(body):
	if body.has_method("pick_weapon"):
		$Sprite2D.modulate = Color.RED
		var weapon = weapon_scene.pick_random().instantiate()
		body.call_deferred("pick_weapon", weapon)
		queue_free()
