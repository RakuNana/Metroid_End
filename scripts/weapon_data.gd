extends Node

@onready var loadin_bullets = preload("res://scenes/bullets.tscn")
@onready var loadin_missles = preload("res://scenes/Fire_Missles.tscn")

func fire_weapon(current_direction,bullet_direction,is_aiming_up,is_aiming_down):
	
	if !Input.is_action_pressed("ready_missles"):
		
		var get_bullets = loadin_bullets.instantiate()
		
		if current_direction == "Left":
			
			get_bullets.check_direction(bullet_direction.x)
			
		if current_direction == "Right":
			
			get_bullets.check_direction(bullet_direction.x)
			
		#removed get_parent()
		add_child(get_bullets)
		get_bullets.is_currently_aiming_up(is_aiming_up)
		get_bullets.is_currently_aiming_down(is_aiming_down)
		
		#added get_parent(), changed global_postion to position
		get_bullets.position = get_parent().bullet_marker.global_position
		
		
func fire_missles(current_direction,bullet_direction,is_aiming_up,is_aiming_down):
	
	if Input.is_action_pressed("ready_missles") and PlayerInventory.inventory["Missile"].has("Missile"):
		
		var get_missles = loadin_missles.instantiate()
		
		PlayerInventory.inventory["Missile"].pop_front()
		
		get_missles.add_to_group("Missiles_group")
		
		if current_direction == "Left":
			
			get_missles.check_direction(bullet_direction.x)
			
		if current_direction == "Right":
			
			get_missles.check_direction(bullet_direction.x)
			
		#removed get_parent()
		add_child(get_missles)
		get_missles.is_currently_aiming_up(is_aiming_up)
		get_missles.is_currently_aiming_down(is_aiming_down)
		
		#added get_parent(), changed global_postion to position
		get_missles.position = get_parent().bullet_marker.global_position
		
		
func morph_bombs():
	
	#can add limits or timer
	var get_bomb = loadin_bullets.instantiate()
	
	add_child(get_bomb)
	get_bomb.add_to_group("Player")
	
	get_bomb.bullet_speed = 0
	get_bomb.power = 5
	get_bomb.position = get_parent().get_node("set_bomb").global_position
