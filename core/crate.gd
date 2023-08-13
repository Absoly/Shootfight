extends Node2D
class_name Crate

@export var items : Array[PackedScene]


func interact(target: Object):
	if target.has_method("pick_item"):
		target.pick_item(items.pick_random().instantiate())
		queue_free()
