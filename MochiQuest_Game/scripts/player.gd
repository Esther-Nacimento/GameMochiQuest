extends CharacterBody2D


const SPEED = 200.0
const JUMP_FORCE = -350.0

# Get  the gravity from the project settings to be synced with rigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var is_hurted := false
var player_life := 7
var knockback_vector := Vector2.ZERO
var direction

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D

signal play

signal player_has_died()

func _ready(): 
		scale = Vector2(0.5, 0.5)
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true 
	elif is_on_floor():
		is_jumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
	_set_state()
	move_and_slide()

func _on_hurtbox_body_entered(body: Node2D) -> void:
#	if body.is_in_group("enemies"):
#		queue_free()
	if player_life < 0:
		queue_free()
	else:
		if $ray_right.is_colliding():
			take_damege(Vector2(-200, -200))
		elif $ray_left.is_colliding():
			take_damege(Vector2(200, -200))
		
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

# Arquivo: player.gd

func take_damege(knockback_force := Vector2.ZERO, duration := 0.25):
	# Garante que o código não rode se o nó não estiver na cena.
	if not is_node_ready():
		return

	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		# Lógica de morte
		queue_free() # Remove o jogador da cena
		emit_signal("player_has_died") # Emite o sinal de que morreu
		return # Adicione esta linha para sair da função aqui
		
	# O resto do código para o knockback...
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
	
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false
	
func _set_state():
	var state = "idle"
	
	if !is_on_floor(): # if is_on_floor == false
		state = "jump"
	elif direction != 0:
		state = "run"
		
	if is_hurted:
		state = "hurt"
		
	if animation.name != state: 
		animation.play(state)
