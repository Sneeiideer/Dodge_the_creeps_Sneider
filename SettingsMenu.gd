extends Control
# Pantalla de configuració. Cada canvi s'aplica al moment i es guarda al fitxer.

onready var box = $Options


func _ready():
	box.get_node("DifficultyOption").add_item("Fàcil")
	box.get_node("DifficultyOption").add_item("Normal")
	box.get_node("DifficultyOption").add_item("Difícil")
	# Mostrem els valors que hi ha guardats.
	box.get_node("VolumeSlider").value = Settings.volume
	box.get_node("MuteCheck").pressed = Settings.muted
	box.get_node("FullscreenCheck").pressed = Settings.fullscreen
	box.get_node("DifficultyOption").select(Settings.difficulty)
	box.get_node("ZenCheck").pressed = Settings.zen
	_update_volume_label()
	box.get_node("VolumeSlider").grab_focus()


func _update_volume_label():
	box.get_node("VolumeLabel").text = "Volum: " + str(int(Settings.volume)) + "%"


func _changed():
	Settings.apply_settings()
	Settings.save_settings()


func _on_VolumeSlider_value_changed(value):
	Settings.volume = value
	_update_volume_label()
	_changed()


func _on_MuteCheck_toggled(pressed):
	Settings.muted = pressed
	_changed()


func _on_FullscreenCheck_toggled(pressed):
	Settings.fullscreen = pressed
	_changed()


func _on_DifficultyOption_item_selected(index):
	Settings.difficulty = index
	_changed()


func _on_ZenCheck_toggled(pressed):
	Settings.zen = pressed
	_changed()


func _on_BackButton_pressed():
	$ClickSound.play()
	yield(get_tree().create_timer(0.15), "timeout")
	get_tree().change_scene("res://Menu.tscn")


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://Menu.tscn")
