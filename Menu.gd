extends Control
# Menú principal del joc.


func _ready():
	$Info.hide()
	# Així es pot navegar pel menú amb el teclat (fletxes + Enter).
	$Buttons/SinglePlayer.grab_focus()


func _go_to(scene_path):
	$ClickSound.play()
	# Petita espera perquè se senti el so abans de canviar d'escena.
	yield(get_tree().create_timer(0.15), "timeout")
	get_tree().change_scene(scene_path)


func _show_coming_soon(option):
	$ClickSound.play()
	$Info.text = option + ": Pròximament!"
	$Info.show()
	yield(get_tree().create_timer(2), "timeout")
	$Info.hide()


func _on_SinglePlayer_pressed():
	_go_to("res://Main.tscn")


func _on_LocalMultiplayer_pressed():
	_go_to("res://MainMulti.tscn")


func _on_OnlineMultiplayer_pressed():
	_show_coming_soon("Online multiplayer")


func _on_Settings_pressed():
	_go_to("res://SettingsMenu.tscn")


func _on_Highscores_pressed():
	_show_coming_soon("Highscores")


func _on_About_pressed():
	_show_coming_soon("About")
