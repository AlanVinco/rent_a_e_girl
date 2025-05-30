extends Control

@onready  var panelPlayerStats = $PanelStats
@onready var panel_bio: Panel = $PanelBio
@onready var orders_container = $ordersContainer
@onready var scroll_image: ScrollContainer = $ScrollImage
@onready var wish_container: GridContainer = $WishContainer
@onready var audio_alert: AudioStreamPlayer = $AudioAlert

#cargables:
@onready var label_username: Label = $LabelUsername
@onready var avatar: TextureRect = $Avatar
@onready var e_girl_voice: AudioStreamPlayer = $"E-girl-voice"
@onready var e_chat_cost_label: Label = $"ordersContainer/Panel/E-chat_cost_label"

@onready var voice_btn: Button = $VoiceBtn
@onready var btn_chat_start: Button = $ordersContainer/Panel/btn_chat_start

@onready var e_girl_progress_bar: ProgressBar = $"PanelStats/E-girlProgressBar"

@onready var btn_videocall_start: Button = $ordersContainer/Panel4/btn_videocall_start
@onready var lbl_call_info: Label = $lbl_call_info

var allResources = [
	{"username": "Dee", "avatar": "res://asset/icons/dee_icon_circle.png", "voice": "", "chat": "10", "selfie": "5", "videocall":"10"},
	{"username": "Mekari", "avatar": "res://asset/icons/mekari_icon_circle.png", "voice": "res://audio/sound/mekari/audio_mekari_1.ogg", "chat": "5", "videocall":"10"},
	{"username": "Mia", "avatar": "res://asset/icons/mia_icon_circle.png", "voice": "res://audio/sound/mekari/audio_mekari_1.ogg", "chat": "50", "videocall":"10"},
]

@export var username = "Dee"

signal start_echat(username)
signal send_selfie(username)

func _ready() -> void:
	GlobalText.text_end.connect(_end_text_scene)
	GlobalStats.stats_changed.connect(update_stats)

func load_profile():
	print(GlobalStats.deePoints)
	var avatar_path = get_avatar_by_username(username, "username")
	if avatar_path:
		#load todo
		label_username.text = avatar_path
		avatar.texture = load(get_avatar_by_username(username, "avatar"))
		e_girl_voice.stream = load(get_avatar_by_username(username, "voice"))
		e_chat_cost_label.text = "$ " + get_avatar_by_username(username, "chat")
		update_stats()
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

func _on_btn_chat_start_pressed() -> void:
	var e_chat_cost = int(get_avatar_by_username(username, "chat"))
	
	if GlobalStats.money >= e_chat_cost:
		
		if username == "Dee":
			if GlobalStats.dee_chating == false:
				GlobalStats.money -= e_chat_cost
				start_echat.emit(username)
				GlobalStats.dee_chating = true
				btn_chat_start.disabled = true
		elif username == "Mekari":
			if GlobalStats.mekari_chating == false:
				GlobalStats.money -= e_chat_cost
				start_echat.emit(username)
				GlobalStats.mekari_chating = true
				btn_chat_start.disabled = true
		elif username == "Mia":
			if GlobalStats.mia_chating == false:
				GlobalStats.money -= e_chat_cost
				start_echat.emit(username)
				GlobalStats.mia_chating = true
				btn_chat_start.disabled = true
		
		
	else:
		audio_alert.stream = load("res://audio/sound/robar_sonido.mp3")
		audio_alert.play()
		
func update_stats():
	if username == "Dee":
		e_girl_progress_bar.value = GlobalStats.deePoints
		if GlobalStats.deePoints <100:
			btn_videocall_start.disabled = true
		else:
			btn_videocall_start.disabled = false
			
	elif username == "Mekari":
		e_girl_progress_bar.value = GlobalStats.mekariPoints
		if GlobalStats.mekariPoints <100:
			btn_videocall_start.disabled = true
		else:
			btn_videocall_start.disabled = false
	elif username == "Mia":
		e_girl_progress_bar.value = GlobalStats.miaPoints
		if GlobalStats.miaPoints <100:
			btn_videocall_start.disabled = true
		else:
			btn_videocall_start.disabled = false

## WISH LIST
func _on_wish_btn_1_pressed() -> void:
	GlobalStats.money -= 5
	GlobalStats.deePoints += 10

func _on_btn_selfie_start_pressed() -> void:
	var e_chat_cost = int(get_avatar_by_username(username, "selfie"))
	
	if GlobalStats.money >= e_chat_cost:
		
		if username == "Dee":
			GlobalStats.money -= e_chat_cost
			send_selfie.emit(username)
			GlobalStats.dee_chating = true
			btn_chat_start.disabled = true
		elif username == "Mekari":
			GlobalStats.money -= e_chat_cost
			send_selfie.emit(username)
			GlobalStats.mekari_chating = true
			btn_chat_start.disabled = true
		elif username == "Mia":
			GlobalStats.money -= e_chat_cost
			send_selfie.emit(username)
			GlobalStats.mia_chating = true
			btn_chat_start.disabled = true

func _on_btn_videocall_start_pressed() -> void:
	var video_call_cost = int(get_avatar_by_username(username, "videocall"))
	GlobalStats.money -= video_call_cost
	GlobalStats.egirl = username
	GlobalStats.visualNovel == "DEEVISUAL1"
	GlobalStats.change_scene_async("res://scenes/videocall/call_intro.tscn")

func _on_btn_videocall_start_mouse_entered() -> void:
	lbl_call_info.visible = true

func _on_btn_videocall_start_mouse_exited() -> void:
	lbl_call_info.visible = false
