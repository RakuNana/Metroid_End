extends CharacterBody2D

@onready var get_menu = preload("res://scenes/menu.tscn")

var movement = Vector2()
var bullet_direction = Vector2()
var speed = 100 
var jump_ht = 600
var fall_vel = 5
var current_direction = "Idle"
var is_aiming_up = false 
var is_aiming_down = false
var morphball = false
var can_save = false

var menu_opened = false

@onready var  anim = $Samus_anim

@onready var stand_col = $Standing_col
@onready var jump_col = $Jump_col
@onready var has_a_landing1 = $Check_landing
@onready var has_a_landing2 = $Check_landing2
@onready var morphball_col = $Morphball_col
@onready var bullet_marker = $Bullet_exit_pos

var knock_back = Vector2()
#var been_hit = false

func _ready():
	
	add_to_group("Player")
	position = SaveFunction.players_current_pos
	
func _physics_process(delta):
	
	current_gravity()
	Player_movement()
	check_current_aim()
	open_menu()
	#remember to add your methods here
	Check_morphball_state()
	check_bullet_direction()
	call_save_function()
	
	if has_a_landing1.is_colliding() or has_a_landing2.is_colliding():
		
		stand_col.disabled = false
		jump_col.disabled = true
		
		
	knock_back = lerp(knock_back, Vector2.ZERO, 0.2)
	
	movement = movement.normalized() * speed * delta
	move_and_slide()
		
#added, calls the health node
func call_health_node(amount):
	
	get_node("health_data").get_damage(amount)
	#get_node("health_data").connect("been_hit",trigger_hit)
		
func call_save_function():
	
	if Input.is_action_just_pressed("load_game") and can_save:
		
		#sends data to global script
		data_to_send_and_save()
		SaveFunction.game_save()
		
	if Input.is_action_just_pressed("load_game") and !can_save:
		
		SaveFunction.load_game()
		
func data_to_send_and_save():
	
	#added
	SaveFunction.parent_saved = get_parent().get_scene_file_path()
	SaveFunction.players_current_pos = position
		
func open_menu():
	
	if Input.is_action_just_pressed("m_key") and !menu_opened:
		
		menu_opened = true
		
		var load_menu = get_menu.instantiate()
	
		load_menu.connect("menu_closed", toggle_menu)
		get_tree().paused = true
		add_child(load_menu)
		
func toggle_menu():
	
	menu_opened = false
	get_tree().paused = false
		
func Player_movement():
	
	var LEFT =Input.is_action_pressed("ui_left")
	var RIGHT =Input.is_action_pressed("ui_right")
	var JUMP =Input.is_action_just_pressed("ui_accept")
	
	var DOWN = Input.is_action_just_pressed("down")
	var UP = Input.is_action_just_pressed("ui_up")
	
	movement.x = -int(LEFT) + int(RIGHT)
	movement.y = -int(JUMP)
	
	if movement.x != 0:
		
		#added
		velocity.y += knock_back.y
		velocity.x = movement.x * speed + knock_back.x 
		
	else:
		
		velocity.x = 0
		
		
	if LEFT:
		
		current_direction = "Left"
		
	if RIGHT:
		
		current_direction = "Right"
		
		
	elif LEFT and RIGHT:
		
		current_direction = "Idle"
		movement = Vector2.ZERO
		
		
	if JUMP and is_on_floor():
		
		fall_vel -= jump_ht
		
	if DOWN:
		
		morphball = true
		
	if UP:
		
		anim.flip_h = false
		#Added: the morphball_col needs to disable when we aren't in the morphball
		morphball_col.disabled = true
		morphball = false
		
	if Input.is_action_just_pressed("fire_weapon") and get_node("Samus_anim").current_direction != "Idle" and !morphball:
		
		#added
		get_node("weapon_data").fire_missles(current_direction,bullet_direction,is_aiming_up,is_aiming_down)
		get_node("weapon_data").fire_weapon(current_direction,bullet_direction,is_aiming_up,is_aiming_down)
		
	if Input.is_action_just_pressed("fire_weapon") and morphball:
		
		get_node("weapon_data").morph_bombs()
		
func check_current_aim():
	
	if Input.is_action_pressed("ui_page_up"):
		
		is_aiming_up = true
		
	if Input.is_action_pressed("ui_page_down"):
		
		is_aiming_down = true
		
	if Input.is_action_just_released("ui_page_up") or Input.is_action_just_released("ui_page_down"):
		
		is_aiming_up = false 
		is_aiming_down = false
		
func check_bullet_direction():
	
	if current_direction == "Left":
		
		bullet_marker.position = Vector2(-13,-8)
		bullet_direction.x = -1
		
	if current_direction == "Right":
		
		bullet_marker.position = Vector2(20,-8)
		bullet_direction.x = 1
		
	if current_direction == "Left" and is_aiming_up:
		bullet_marker.position = Vector2(-10,-18)
		
	if current_direction == "Left" and is_aiming_down:
		bullet_marker.position = Vector2(-8,6)
		
	if current_direction == "Right" and is_aiming_up:
		bullet_marker.position = Vector2(16,-18)
		
	if current_direction == "Right" and is_aiming_down:
		bullet_marker.position = Vector2(15,6)
		
func Check_morphball_state():
	
	if morphball:
		
		stand_col.disabled = true
		jump_col.disabled = true
		morphball_col.disabled = false
		has_a_landing1.enabled = false
		has_a_landing2.enabled = false
		
	else:
		
		has_a_landing1.enabled = true
		has_a_landing2.enabled = true
		
func current_gravity():
	
	var new_gravity = gravity_force.new()
	
	velocity.y = fall_vel
	
	if !is_on_floor():
		
		fall_vel += new_gravity.gravity_str
		
	if is_on_floor() and fall_vel > 5:
		
		fall_vel = 5
		
	if fall_vel >= new_gravity.terminal_vel:
		
		fall_vel = new_gravity.terminal_vel
		
	#print(fall_vel)
		
