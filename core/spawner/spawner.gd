extends Node2D

@export var player_scene : PackedScene
@export var spawn_delay : float = 5.0
@export var random_spawnpoint = true

var entity
var timer = 0.0


func _ready():
	timer = spawn_delay


func _process(delta):
	if not entity:
		if timer > spawn_delay:
			entity = player_scene.instantiate()
			get_tree().current_scene.add_child(entity)
			if random_spawnpoint:
				var spawnpoints = get_tree().get_nodes_in_group("Spawnpoint").filter(func(x): return not x.is_locked)
				
				if spawnpoints.size():
					var spawnpoint = spawnpoints.pick_random()
					spawnpoint.is_locked = true
					entity.global_transform = spawnpoint.global_transform
			else:
				entity.global_transform = global_transform
			timer = 0.0
		else:
			timer += delta
