extends Node

var player_health: int = 3
var max_player_health: int = 3
var score: int = 0
var is_paused: bool = false

signal health_changed(new_health)
signal score_changed(new_score)
signal game_paused
signal game_resumed


func _ready():
	add_to_group("gamemanager")


func _process(delta: float):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()


func add_score(amount: int):
	score += amount
	emit_signal("score_changed", score)


func reset_score():
	score = 0
	emit_signal("score_changed", score)


func set_player_health(new_health: int):
	player_health = new_health
	player_health = clamp(player_health, 0, max_player_health)
	emit_signal("health_changed", player_health)


func heal_player(amount: int = 1):
	set_player_health(player_health + amount)


func damage_player(amount: int = 1):
	set_player_health(player_health - amount)


func reset_player_health():
	set_player_health(max_player_health)


func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	
	if is_paused:
		emit_signal("game_paused")
	else:
		emit_signal("game_resumed")


func pause_game():
	if not is_paused:
		toggle_pause()


func resume_game():
	if is_paused:
		toggle_pause()


func reset_game():
	reset_score()
	reset_player_health()
	is_paused = false
	get_tree().paused = false


func get_score() -> int:
	return score


func get_player_health() -> int:
	return player_health


func get_max_health() -> int:
	return max_player_health


func is_game_paused() -> bool:
	return is_paused
