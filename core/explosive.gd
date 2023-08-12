extends RigidBody2D

@export var damage : float
@export var timeout := 5.0
@export var explosion_area : NodePath
@export var explosion_radius := 400.0

var timeout_counter : float
var exploded := false
var who_shot
var life_time : float


func _ready():
	get_node(explosion_area)


func _process(delta):
	if timeout_counter >= timeout and not exploded:
		exploded = true
		$Sprite2D.hide()
		for body in get_node(explosion_area).get_overlapping_bodies():
			var distance_sq = global_position.distance_squared_to(body.global_position)
			var dist_damage = (1.0 - distance_sq / pow(explosion_radius, 2))
			if body.has_method("damage"):
				if dist_damage > 0:
					body.damage(damage * dist_damage)
			if body is RigidBody2D:
				body.apply_central_force((body.global_position - global_position) * dist_damage * 500)
		$GPUParticles2D.emitting = true
	else:
		timeout_counter += delta
	if exploded:
		if not $GPUParticles2D.emitting:
			queue_free()


func push(vel, torq):
	apply_central_force(vel.rotated(global_rotation))
	apply_torque(torq)
