extends Node2D

@onready var poly = $Polygon2D
var arrastrando = false

# Radios independientes
var radio_influencia_x = 160.0
var radio_influencia_y = 60.0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			arrastrando = event.pressed

	if event is InputEventMouseMotion and arrastrando:
		var mouse_pos = to_local(event.position)

		var nuevo_poligono = [] # 📦 aquí guardaremos los nuevos puntos

		for i in poly.polygon.size():
			var punto = poly.polygon[i]
			
			var distancia_x = abs(mouse_pos.x - punto.x)
			var distancia_y = abs(mouse_pos.y - punto.y)
			
			if distancia_x < radio_influencia_x and distancia_y < radio_influencia_y:
				var fuerza_x = (radio_influencia_x - distancia_x) / radio_influencia_x
				var fuerza_y = (radio_influencia_y - distancia_y) / radio_influencia_y
				var fuerza = min(fuerza_x, fuerza_y)
				var nuevo_punto = punto.lerp(mouse_pos, fuerza * 0.5)
				nuevo_poligono.append(nuevo_punto)
			else:
				nuevo_poligono.append(punto) # si no, el punto queda igual

		poly.polygon = nuevo_poligono # ✅ Aplicamos todo al final
