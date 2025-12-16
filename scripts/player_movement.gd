extends CharacterBody2D

const SPEED: float = 100.0
const JUMP_VELOCITY: float = -200.0
const MAX_JUMPS: int = 2

@onready var player_animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var jump_audio: AudioStreamPlayer2D = $jump

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_jump_count: int = 0
var player_alive: bool = true

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	if player_alive:
		var direction: float = Input.get_axis("move_left", "move_right")
		# Add the gravity.
		if is_on_floor():
			player_jump_count = 0
			if direction == 0:
				player_animated_sprite.play("idle")
				velocity.x = 0
		
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			player_animated_sprite.play("jump")
			velocity.y = JUMP_VELOCITY
			player_jump_count+=1
			jump_audio.play()
		if Input.is_action_just_pressed("jump") and not is_on_floor() and (player_jump_count<MAX_JUMPS):
			player_animated_sprite.play("double_jump")
			velocity.y = JUMP_VELOCITY
			player_jump_count+=1
			jump_audio.play()
		
		if direction == 1.0:
			velocity.x = direction * SPEED
			player_animated_sprite.play("run")
			player_animated_sprite.flip_h = false
		if direction == -1.0:
			velocity.x = direction * SPEED
			player_animated_sprite.play("run")
			player_animated_sprite.flip_h = true

	move_and_slide()

func death() -> void:
	player_alive = false
	velocity.x = 0
	velocity.y = 100
	animation_player.play("death")
