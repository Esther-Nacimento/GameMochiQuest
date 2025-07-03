extends Area2D

@onready var transition_world: CanvasLayer = $"../transition_world"
@export var third_level : String = ""

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" and !third_level == "":
		transition_world.change_scene()
	else:
		print("No Scene Loaded")
