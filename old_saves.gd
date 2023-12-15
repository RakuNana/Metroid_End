extends Node


func game_save():
	
	var data = {
		
		"filename" : get_parent().get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : self.position.x,
		"pos_y" : self.position.y,
		"max_missiles" : PlayerInventory.max_missiles,
		"current_ammo" : PlayerInventory.inventory["Missile"],
		"Items_collected" : PlayerInventory.item_tracker["Missiles_pickup"],
		"jar_pickles" : 12,
		"current_room" : PlayerInventory.current_room
		
	}
	
	var get_file = FileAccess.open(save_path,FileAccess.WRITE)
	get_file.store_var(data)
	get_file.close()
	
	
	
func load_game():
	
	var get_load = FileAccess.open(save_path,FileAccess.READ)
	
	if FileAccess.file_exists(save_path):
		
		FileAccess.open(save_path,FileAccess.READ)
		var player_data = get_load.get_var()
		
		get_tree().change_scene_to_file(player_data["filename"])
		
		PlayerInventory.players_current_pos.x = player_data["pos_x"]
		PlayerInventory.players_current_pos.y = player_data["pos_y"]
		
		PlayerInventory.inventory["Missile"] = player_data["current_ammo"]
		PlayerInventory.item_tracker["Missiles_pickup"] = player_data["Items_collected"]
		
		get_load.close()
