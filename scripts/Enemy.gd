extends CharacterBody2D

export var patrol_speed: float = 100.0
export var max_health: int = 3
export var damage: int = 1
export var knockback_force: float = 150.0
export var patrol_distance: float = 200.0

var velocity: Vector2 = Vector2.ZERO
var health: int = 3
var patrol_direction: int = -1
var is_dead: bool = false

signal enemy_died
signal enemy_damaged


func _ready():
	health = max_health
	add_to_group("enemies")
	randomize_patrol_direction()


func _physics_process(delta: float):
	if is_dead:
		return
	
	apply_gravity(delta)
	handle_patrol(delta)
	velocity = move_and_slide(velocity, Vector2.UP)


func apply_gravity(delta: float):
	velocity.y += 800 * delta


func handle_patrol(delta: float):
	velocity.x = patrol_direction * patrol_speed


func randomize_patrol_direction():
	patrol_direction = [-1, 1][randi() % 2]


func take_damage(amount: int = 1, knockback_source: Vector2 = Vector2.ZERO):
	if is_dead:
		return
	
	health -= amount
	emit_signal("enemy_damaged")
	
	if knockback_source != Vector2.ZERO:
		var knockback_direction = (position - knockback_source).normalized()
		velocity.x = knockback_direction.x * knockback_force
	
	if health <= 0:
		die()


func die():
	is_dead = true
	emit_signal("enemy_died")
	GameManager.add_score(100)
	queue_free()


func get_health() -> int:
	return health


func is_alive() -> bool:
	return not is_dead
