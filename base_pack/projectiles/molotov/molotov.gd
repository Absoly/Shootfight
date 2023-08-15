extends RigidBody2D

var tilemap

func _ready():
	tilemap = get_tree().get_first_node_in_group("Tilemap")

func push(vel, torq):
	apply_central_force(vel.rotated(global_rotation))
	apply_torque(torq)


func _on_area_2d_body_entered(body):
	if body is TileMap:
		var tile_coords = tilemap.local_to_map(tilemap.to_local(global_position))
		var tile_data = tilemap.get_cell_tile_data(1, tile_coords)
