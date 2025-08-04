extends CheckButton

var audio_on = AudioServer.get_bus_index("Master")

func _on_pressed() -> void:
	AudioServer.set_bus_mute(audio_on, not AudioServer.is_bus_mute(audio_on))
