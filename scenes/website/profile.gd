extends Control

@onready  var panelPlayerStats = $PanelStats
@onready var panel_bio: Panel = $PanelBio
@onready var orders_container = $ordersContainer
@onready var scroll_image: ScrollContainer = $ScrollImage
@onready var wish_container: GridContainer = $WishContainer

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
