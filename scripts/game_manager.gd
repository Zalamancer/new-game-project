extends Node

# Spawns the coins, runs the countdown, and tracks win / lose.

@export var game_time := 45.0

const CoinScene := preload("res://scenes/coin.tscn")

# Coin drop spots: floor coins sit at y = 0.8, platform coins float above the platforms.
const COIN_SPOTS := [
	Vector3(0, 0.8, 3),
	Vector3(3, 0.8, -2),
	Vector3(-3, 0.8, 2),
	Vector3(8, 0.8, 8),
	Vector3(-9, 0.8, -9),
	Vector3(9, 0.8, -3),
	Vector3(-4, 0.8, 9),
	Vector3(2, 0.8, 9),
	Vector3(0, 0.8, -4),
	Vector3(5, 1.6, 5),
	Vector3(-6, 1.6, -5),
	Vector3(-7, 1.6, 6),
]

@onready var hud := get_node("../HUD")
@onready var score_label: Label = hud.get_node("ScoreLabel")
@onready var timer_label: Label = hud.get_node("TimerLabel")
@onready var message_label: Label = hud.get_node("MessageLabel")

var total := 0
var collected := 0
var time_left := 0.0
var playing := false

func _ready() -> void:
	time_left = game_time
	message_label.hide()
	_spawn_coins()
	_update_hud()
	playing = true

func _process(delta: float) -> void:
	if not playing:
		if Input.is_action_just_pressed("ui_accept") or Input.is_physical_key_pressed(KEY_R):
			get_tree().reload_current_scene()
		return

	time_left -= delta
	if time_left <= 0.0:
		time_left = 0.0
		_end(false)
	_update_hud()

func _spawn_coins() -> void:
	total = COIN_SPOTS.size()
	for spot in COIN_SPOTS:
		var coin := CoinScene.instantiate()
		coin.position = spot
		coin.collected.connect(_on_coin_collected)
		get_parent().add_child.call_deferred(coin)

func _on_coin_collected() -> void:
	collected += 1
	_update_hud()
	if collected >= total:
		_end(true)

func _end(win: bool) -> void:
	playing = false
	var player := get_tree().get_first_node_in_group("player")
	if player:
		player.set_physics_process(false)
	if win:
		message_label.text = "You Win!\nAll %d coins collected!\n\nPress R to play again" % total
	else:
		message_label.text = "Time's Up!\nYou got %d / %d coins\n\nPress R to try again" % [collected, total]
	message_label.show()

func _update_hud() -> void:
	score_label.text = "Coins: %d / %d" % [collected, total]
	timer_label.text = "Time: %d" % int(ceil(time_left))
