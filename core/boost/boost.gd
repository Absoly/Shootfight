extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Character"):
		body.health *= 2
		body.get_node("HealthBar").size = Vector2(200, 27)
		body.get_node("HealthBar").position = Vector2(-100, -70)

func _on_body_exited(body):
	if body.is_in_group("Character"):
		body.health /= 2
		body.get_node("HealthBar").size = Vector2(100, 27)
		body.get_node("HealthBar").position = Vector2(-50, -70)
