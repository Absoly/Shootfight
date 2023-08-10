extends Area2D

var last_health

func _on_body_entered(body):
	if body is CharacterBody2D:
		last_health = body.health
		body.health *= 2
		body.get_node("ProgressBar").size = Vector2(200, 27)
		body.get_node("ProgressBar").position = Vector2(-100, -70)

func _on_body_exited(body):
	if body is CharacterBody2D:
		body.health = last_health
		body.get_node("ProgressBar").size = Vector2(100, 27)
		body.get_node("ProgressBar").position = Vector2(-50, -70)
