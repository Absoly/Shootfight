extends RigidBody2D

@export var number := "1"
@export var acceleration := 2000.0
@export var floor_drag = 0.97
@export var jump_force := 600.0
@export var health := 100.0
@export var walkable_slope_angle := 50.0

@onready var sprite = $Sprite2D
@onready var healthbar = $HealthBar
@onready var arm = $Sprite2D/Arm

var tilemap : TileMap
var move_direction : Vector2
var rotate_direction : float
var weapon
var is_boosting = false
var target_point

# Physics related
var floor_normal = null
var jump_cooldown := 0.0
var fly_control_cooldown := 0.0
var arm_origin : Vector2


func _ready():
	tilemap = get_tree().get_first_node_in_group("Tilemap")
	arm_origin = arm.position


func _unhandled_input(event):
	move_direction = Input.get_vector("move_left_" + number, "move_right_" + number, "move_up_" + number, "move_down_" + number)
	rotate_direction = Input.get_axis("rotate_left_" + number, "rotate_right_" + number)


func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("Character") \
		.filter(func(e): return e != self)
	
	enemies.sort_custom(func(a, b):
		return a.global_position.distance_squared_to(global_position) > b.global_position.distance_squared_to(global_position))
	
	if enemies.size():
		return enemies[0]
	return null


func rotate_character(angle, delta):
	var aim_rate = 10.0
	
	if weapon:
		aim_rate = weapon.aim_rate
	
	sprite.rotation = move_toward(sprite.rotation, sprite.rotation + angle, delta * aim_rate)

func _process(delta):
	jump_cooldown = move_toward(jump_cooldown, 0.0, delta)
	fly_control_cooldown = move_toward(fly_control_cooldown, 0.0, delta)
	arm.rotation = move_toward(arm.rotation, 0, delta)
	arm.position.x = move_toward(arm.position.x, arm_origin.x, delta)
	arm.position.y = move_toward(arm.position.y, arm_origin.y, delta)
	
	healthbar.value = health
	
	var enemy = get_closest_enemy()
	
	if enemy and weapon and global_position.distance_to(enemy.global_position) < weapon.range:
		target_point = enemy.global_position
	elif move_direction != Vector2.ZERO:
		target_point = (global_position + move_direction * 1000)
	else:
		target_point = null
	
	if Vector2.RIGHT.rotated(sprite.rotation).x < 0:
		sprite.scale.y = -abs(sprite.scale.y)
	else:
		sprite.scale.y = abs(sprite.scale.y)
	
	if target_point != null:
		rotate_character(sprite.get_angle_to(target_point), delta)
	elif rotate_direction:
		rotate_character(rotate_direction, delta)
	
	if Input.is_action_pressed("action_" + number):
		if weapon:
			weapon.action()


func can_jump():
	return jump_cooldown <= 0


func can_climb():
	var tile_coords = tilemap.local_to_map(tilemap.to_local(global_position))
	
	var tile_data = tilemap.get_cell_tile_data(0, tile_coords)
	if tile_data and tile_data.get_custom_data("Climb"):
		return true
	
	var tile_data_up = tilemap.get_cell_tile_data(0, tile_coords + Vector2i(0, -1))
	if tile_data_up and tile_data_up.get_custom_data("Climb"):
		return true
	
	var tile_data_down = tilemap.get_cell_tile_data(0, tile_coords + Vector2i(0, 1))
	if tile_data_down and tile_data_down.get_custom_data("Climb"):
		return true
	
	return false


func can_control_fly():
	return fly_control_cooldown >= 0


func _integrate_forces(state):
	floor_normal = null
	var floor_angle = PI
	
	for i in state.get_contact_count():
		var normal = state.get_contact_local_normal(i)
		var gravity_angle = abs(normal.angle_to(-state.total_gravity))
		if gravity_angle <= deg_to_rad(walkable_slope_angle):
			if gravity_angle <= floor_angle:
				floor_normal = normal
				floor_angle = gravity_angle
	
	if floor_normal:
		var move_direction_x = move_direction.x
		if move_direction.x == 0:
			move_direction_x = -linear_velocity.x
		var movement = -floor_normal.orthogonal() * sign(move_direction_x) * acceleration
		linear_velocity *= floor_drag
		state.apply_central_force(movement)
		if move_direction.y < 0 and can_jump() and not can_climb():
			state.apply_central_impulse(Vector2(0, -jump_force))
			jump_cooldown = 0.2
			fly_control_cooldown = 0.75
	else:
		if can_control_fly():
			state.apply_central_force(state.total_gravity.normalized().orthogonal() * sign(move_direction.x) * acceleration * fly_control_cooldown)
	if can_climb():
		apply_force(-state.total_gravity - linear_velocity * 5 + move_direction * acceleration)
		fly_control_cooldown = 0.5


func damage(val):
	health -= val
	if health <= 0:
		queue_free()


func _on_weapon_hand_shake(offset, torque):
	arm.rotate(-torque)


func pick_weapon(new_weapon: Node2D):
	if weapon:
		weapon.queue_free()
		if weapon.has_signal("hand_shake"):
			weapon.hand_shake.disconnect(_on_weapon_hand_shake)
	weapon = new_weapon
	if weapon.get_parent():
		weapon.reparent($Sprite2D/Arm)
	else:
		$Sprite2D/Arm.add_child(weapon)
	weapon.position = Vector2.ZERO
	weapon.rotation = 0
	if weapon.has_signal("hand_shake"):
		weapon.hand_shake.connect(_on_weapon_hand_shake)
