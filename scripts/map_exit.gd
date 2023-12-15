extends Button

func _input(event):
	
	if event.is_action_pressed("m_key"):
		
		get_tree().paused = false
		
func _on_pressed():
	
	get_parent().queue_free()
