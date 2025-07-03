extends Node2D

@onready var player := $player as CharacterBody2D
@onready var camera := $camera as Camera2D
@onready var hud: CanvasLayer = $HUD
@onready var control: Control = $HUD/control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.follow_camera(camera)
	player.player_has_died.connect(game_over)
	control.time_is_up.connect(game_over)
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
func reload_game():
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
	add_child(player)
	control.reset_clock_timer()
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(game_over)
	
	
func game_over():
		get_tree().change_scene_to_file("res://menu/Cenas_Menu/game_over.tscn")


func _on_sprike_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
