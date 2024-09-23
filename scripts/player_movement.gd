extends CharacterBody2D

var SPEED = 180.0



@export var inv: Inv
@export var ghost_node : PackedScene
@onready var ghost_timer = $GhostTimer

func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	# Handle movement input test
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1.0
	if Input.is_action_pressed("move_down"):
		velocity.y += 1.0
	if Input.is_action_pressed("move_left"):
		# Flip the sprite horizontally moving to left
		$ElfMIdleAnimF0.flip_h = true
		velocity.x -= 1.0
		# Reset the sprite to face the right direction
	if Input.is_action_pressed("move_right"):
		$ElfMIdleAnimF0.flip_h = false
		velocity.x += 1.0
	
	if velocity == Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("idle")
	else:
		velocity = velocity.normalized() * SPEED
		$AnimationTree.get("parameters/playback").travel("walk")
		$AnimationTree.set("parameters/idle/blend_position", velocity)
		$AnimationTree.set("parameters/walk/blend_position", velocity)
		
	self.velocity = velocity
	
	
	
	
	# Apply movement
	move_and_slide()
	
	## Normalize the velocity and scale by SPEED
	#if velocity != Vector2.ZERO:
		#velocity = velocity.normalized() * SPEED
		#
		## Switch to walk animation
		#$AnimationTree.get("parameters/playback").travel("walk")
	#else:
		## Switch to idle animation when there is no movement
		#$AnimationTree.get("parameters/playback").travel("idle")
	#
	## Set the velocity of the CharacterBody2D
	#self.velocity = velocity
	#
	## Apply movement
	#move_and_slide()
	
func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.position = position
	get_tree().current_scene.add_child(ghost)
	 # Debugging: Print both positions
	print("Player position: ", position)
	print("Ghost position: ", ghost.position)

func _on_ghost_timer_timeout():
	add_ghost()

func dash():
	ghost_timer.start()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + velocity * 1.5, 0.45)
	await tween.finished
	ghost_timer.stop()
	
 
func _input(event):
	if event.is_action_pressed("dash"):
		dash()
