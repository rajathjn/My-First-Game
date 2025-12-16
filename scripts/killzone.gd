extends Area2D

@onready var killzone_timer: Timer = $killzone_timer

func _on_body_entered(body: Node2D) -> void:
	# try to see if the body has a death animation
	if body.has_node("AnimationPlayer"):
		body.death()
	Engine.time_scale = 0.5
	killzone_timer.start()

func _on_killzone_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene() # Replace with function body.
