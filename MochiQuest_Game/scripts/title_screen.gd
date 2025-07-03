extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/Sem alterações/world_01.tscn")


func _on_start_2_pressed() -> void:
	pass # Replace with function body.


func _on_start_3_pressed() -> void:
	get_tree().quit()
