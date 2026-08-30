extends Node

# Tracks which weapons the player has unlocked
var unlocked_weapons: Dictionary = {
	"Gun": true,    # Starts unlocked
	"Shotgun": false,  # Unlocks after Level 1
}

func unlock_weapon(weapon_name: String) -> void:
	if unlocked_weapons.has(weapon_name):
		unlocked_weapons[weapon_name] = true
