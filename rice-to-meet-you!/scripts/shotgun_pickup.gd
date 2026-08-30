extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		WeaponManager.unlock_weapon("Shotgun")
		
		if body.has_method("refresh_unlocked_weapons"):
			body.refresh_unlocked_weapons()
		
		queue_free()
