extends Node

var timer_started = false
var timer_count = 0

func _physics_process(_delta):
	
	timer_resetter()
	

func get_damage(amount):
	
	
	if !timer_started:
		
		#been_hit = true
		PlayerInventory.inventory["Health"] -= amount
		
	timer_started = true
	
	check_health()
	
func check_health():
	
	if PlayerInventory.inventory["Health"] <= 0:
		
		PlayerInventory.inventory["Health"]= clamp(PlayerInventory.inventory["Health"],0,PlayerInventory.max_health)
		print("Game Over")
		
		
#added, triggers on signal
func start_timer():
	
	timer_started = true
		
func timer_resetter():
	
	#resets damage timer
	if timer_started:
		
		timer_count += 1
		
	if timer_count >= 50:
		
		timer_started = false
		timer_count = 0
		
	#print(timer_started," ", timer_count)
