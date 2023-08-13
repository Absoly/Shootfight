extends RigidBody2D

@export var boosters : Array[PackedScene]


func interact(target: Object):
	if target.has_method("add_boost"):
		target.add_boost(boosters.pick_random().instantiate())
		queue_free()
