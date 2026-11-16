extends Node
# Autoload (script global): guarda, carrega i aplica la configuració del joc.
# Es carrega automàticament en obrir el joc.

const CONFIG_PATH = "user://settings.cfg"

var volume = 100       # Volum general (0-100 %).
var muted = false      # So silenciat.
var fullscreen = false # Pantalla completa.
var difficulty = 1     # 0 = Fàcil, 1 = Normal, 2 = Difícil.
var zen = false        # Mode Zen: no es mor i no hi ha puntuació.


func _ready():
	load_settings()
	apply_settings()


func load_settings():
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) != OK:
		return # Primera vegada: no hi ha fitxer, fem servir els valors per defecte.
	volume = config.get_value("audio", "volume", 100)
	muted = config.get_value("audio", "muted", false)
	fullscreen = config.get_value("video", "fullscreen", false)
	difficulty = config.get_value("game", "difficulty", 1)
	zen = config.get_value("game", "zen", false)


func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "volume", volume)
	config.set_value("audio", "muted", muted)
	config.set_value("video", "fullscreen", fullscreen)
	config.set_value("game", "difficulty", difficulty)
	config.set_value("game", "zen", zen)
	config.save(CONFIG_PATH)


func apply_settings():
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear2db(volume / 100.0))
	# Si està silenciat (o el volum és 0) el so es redueix completament.
	AudioServer.set_bus_mute(bus, muted or volume == 0)
	OS.window_fullscreen = fullscreen


# Ajustos de dificultat: velocitat dels Creeps i cada quant apareixen.
func mob_speed_multiplier():
	return [0.7, 1.0, 1.4][difficulty]


func mob_spawn_time():
	return [0.8, 0.5, 0.3][difficulty]
