extends RigidBody2D

var boosters = ["speed", "hp", "damage"]

func _on_body_entered(body):
	if body.has_method("boost"):
		body.boost(boosters[randi() % boosters.size()])
