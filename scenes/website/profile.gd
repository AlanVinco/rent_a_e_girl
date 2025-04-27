extends Control

@onready  var panelPlayerStats = $PanelStats
@onready var panel_bio: Panel = $PanelBio
@onready var orders_container = $ordersContainer
@onready var scroll_image: ScrollContainer = $ScrollImage
@onready var wish_container: GridContainer = $WishContainer

#cargables:
@onready var label_username: Label = $LabelUsername
@onready var avatar: TextureRect = $Avatar
@onready var e_girl_voice: AudioStreamPlayer = $"E-girl-voice"

@onready var voice_btn: Button = $VoiceBtn

var allResources = [
	{"username": "Dee", "avatar": "res://asset/icons/dee_icon_circle.png", "voice": ""},
	{"username": "Mekari", "avatar": "res://asset/icons/mekari_icon_circle.png", "voice": "res://audio/sound/mekari/audio_mekari_1.ogg"},
	{"username": "Mia", "avatar": "res://asset/icons/mia_icon_circle.png"},
]

@export var username = "Dee"

func _ready() -> void:
	GlobalText.text_end.connect(_end_text_scene)

func load_profile():
	var avatar_path = get_avatar_by_username(username, "username")
	if avatar_path:
		#load todo
		label_username.text = avatar_path
		avatar.texture = load(get_avatar_by_username(username, "avatar"))
		e_girl_voice.stream = load(get_avatar_by_username(username, "voice"))
		
	else:
		print("No se encontró el avatar para:", username)	
	visible = true

# Función que busca el avatar por username
func get_avatar_by_username(target_username: String, find) -> String:
	for resource in allResources:
		if resource["username"] == target_username:
			return resource[find]  # Devuelve la ruta del avatar
	return ""  # Si no encuentra coincidencia

func _on_btn_close_pressed() -> void:
	visible = false

func show_info(value:bool):
	panelPlayerStats.visible = value
	panel_bio.visible = value
	orders_container.visible = value

func show_album(value:bool):
	scroll_image.visible = value

func show_wish_list(value:bool):
	wish_container.visible = value

func _on_btn_album_pressed() -> void:
	show_info(false)
	show_album(true)
	show_wish_list(false)

func _on_btn_wishlist_pressed() -> void:
	show_info(false)
	show_album(false)
	show_wish_list(true)

func _on_btn_info_pressed() -> void:
	show_info(true)
	show_album(false)
	show_wish_list(false)

##DIALOGUE CHAT

func apply_effect(efecto: String):
	print("Efecto aplicado:", efecto)

func _on_voice_btn_pressed() -> void:
	voice_btn.disabled = true
	e_girl_voice.play()
	GlobalText.sceneName = "TEST1"
	GlobalText.sceneCodeTxt = "text_txt"
	GlobalText._on_all_texts_displayed()

func _end_text_scene():
	voice_btn.disabled = false
