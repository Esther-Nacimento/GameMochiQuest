extends Control
@onready var coins_counter: 	Label = $container/coins_container/coins_counter
@onready var time_counter: Label = $container/time_container/time_counter
@onready var score_counter: Label = $container/score_container/score_counter
@onready var life_counter: Label = $container/life_container/life_counter
@onready var clock_timer = $clock_timer as Timer

var minutes = 0
var seconds = 0
@export_range(0, 5) var default_minutes := 1
@export_range(0, 59) var default_seconds := 0

signal time_is_up()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)
	time_counter.text =  str("%02d" % default_minutes) + ":" + str("%02d" % default_seconds)
	reset_clock_timer()
	
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)
	
	if minutes == 0 and seconds == 0:
		emit_signal("time_is_up")


func _on_clock_timer_timeout() -> void:
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 60
	seconds -= 1
	
	time_counter.text =  str("%02d" % minutes) + ":" + str("%02d" % seconds)
	
func reset_clock_timer():
	minutes = default_minutes
	seconds = default_seconds
	
	
	
func reload_game():
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()

	
	
func game_over():
		get_tree().change_scene_to_file("res://menu/Cenas_Menu/game_over.tscn")
