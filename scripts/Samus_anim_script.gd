extends AnimatedSprite2D

@onready var player_node = get_parent()
@onready var stand_col = get_parent().get_node("Standing_col")
@onready var jump_col = get_parent().get_node("Jump_col")
@onready var has_a_landing1 = get_parent().get_node('Check_landing')
@onready var has_a_landing2 = get_parent().get_node('Check_landing2')
@onready var morphball_col = get_parent().get_node('Morphball_col')

var current_direction = "Idle"

var morphball = false
var currently_aiming_up = false
var currently_aiming_down = false

var running_left = false
var running_right = false
var is_in_air = false


func _physics_process(_delta):
	
	player_inputs()
	animation_player()
	aim_animations()
	check_morphball_state()
	check_current_aim()
	
	#print(running_left," ", running_right)
	
func player_inputs():
	
	var LEFT =Input.is_action_pressed("ui_left")
	var RIGHT =Input.is_action_pressed("ui_right")
	
	var DOWN = Input.is_action_just_pressed("down")
	var UP = Input.is_action_just_pressed("ui_up")
	
	if LEFT:
		
		current_direction = "Left"
		running_left = true
		
	elif RIGHT:
		
		current_direction = "Right"
		running_right = true
		
		
	else:
		
		running_left = false
		running_right = false
		
		
	if has_a_landing1.is_colliding() or has_a_landing2.is_colliding():
		
		is_in_air = false
		
	if !has_a_landing1.is_colliding() and !has_a_landing2.is_colliding():
			
			is_in_air = true
			
	if DOWN:
		
		morphball = true
		
	if UP:
		
		flip_h = false
		morphball_col.disabled = true
		morphball = false
		
func check_morphball_state():
	
	if morphball:
		
		stand_col.disabled = true
		jump_col.disabled = true
		morphball_col.disabled = false
		has_a_landing1.enabled = false
		has_a_landing2.enabled = false
		
	else:
		
		has_a_landing1.enabled = true
		has_a_landing2.enabled = true
		
func animation_player():
	
	if player_node.movement.x == -1:
		
		#This is no longer needed as I've adjusted the sprite to fit perfectly
		#stand_col.position = Vector2(4,1)
		current_direction = "Left"
		
	if player_node.movement.x == 1:
		
		#This is no longer needed as I've adjusted the sprite to fit perfectly
		#stand_col.position = Vector2(-1,1)
		current_direction = "Right"
			
			
	if current_direction == "Left" and !morphball and running_left and is_in_air:
		
		jump_col.disabled = false
		stand_col.disabled = true
		play("SummerSault_Left")
		
	if current_direction == "Right" and !morphball and running_right and is_in_air:
		
		jump_col.disabled = false
		stand_col.disabled = true
		play("SummerSault_Right")
			
			
	check_direction()
		
func aim_animations():
	
	if current_direction == "Left" and currently_aiming_down and !morphball and !running_left:
		
		play("Aim_Down_L")
		
	if current_direction == "Right" and currently_aiming_down and !morphball and !running_right:
		
		play("Aim_Down_R")
		
		
	if current_direction == "Left" and currently_aiming_down and !morphball and running_left:
		
		play_backwards("RL_Aim_Down")
		
	if current_direction == "Right" and currently_aiming_down and !morphball and running_right:
		
		play("RR_Aim_Down")
		
		
	if current_direction == "Left" and currently_aiming_up and !morphball and running_left:
		
		play_backwards("RL_Aim_Up")
		
	if current_direction == "Right" and currently_aiming_up and !morphball and running_right:
		
		play("RR_Aim_Up")
		
		
	if current_direction == "Left" and currently_aiming_up and !morphball and !running_left:
		
		play_backwards("Aim_Up_L")
		
	if current_direction == "Right" and currently_aiming_up and !morphball and !running_right:
		
		play("Aim_Up_R")
		
func check_direction():
			
	if !morphball  and !is_in_air:
			
		if current_direction == "Left"  and !morphball and !currently_aiming_up and !currently_aiming_down:
			
			play_backwards("Run_L")
			
		if current_direction == "Right" and !morphball and !currently_aiming_up and !currently_aiming_down:
			
			play("Run_R")
			
		if player_node.movement == Vector2.ZERO:
			
			if current_direction == "Left":
				
				play("Idle_Left")
				
			if current_direction == "Right":
				
				play("Idle_Right")
				
				
		if morphball and current_direction == "Left":
			
			play("Morph_ball_L")
			
	else:
		
		if morphball and current_direction == "Left":
			
			flip_h = false
			play("Morph_ball_L")
			
		if morphball and current_direction == "Right":
			
			flip_h = true
			play("Morph_ball_L")
			
			
		if morphball and player_node.movement == Vector2.ZERO:
			
			play("Morph_ball_L")
			stop()
			
func check_current_aim():
	#DRY
	if Input.is_action_pressed("ui_page_up"):
		
		currently_aiming_up = true
		
	if Input.is_action_pressed("ui_page_down"):
		
		currently_aiming_down = true
		
	if Input.is_action_just_released("ui_page_up") or Input.is_action_just_released("ui_page_down"):
		
		currently_aiming_up = false 
		currently_aiming_down = false
			
