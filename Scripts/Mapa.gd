class_name Partida
extends Node2D

const escena_client = preload("res://Scenes/Client.tscn")
const escena_persona=preload("res://Scenes/Persona.tscn")
const escena_score=preload("res://Scenes/Score.tscn")

const textura_edifici_verd=preload("res://Assets/Isometric City Pack/png/medium_building_green_right.png")
const textura_edifici_blau=preload("res://Assets/Isometric City Pack/png/medium_building_blue_right.png")
const textura_casa_groga=preload("res://Assets/Isometric City Pack/png/house_small_yellow_right.png")
const textura_edifici_blanc=preload("res://Assets/Isometric City Pack/png/medium_building_white_right.png")
const textura_casa_lila=preload("res://Assets/Isometric City Pack/png/house_small_purple_right.png")
const textura_casa_blava=preload("res://Assets/Isometric City Pack/png/house_small_blue_right.png")
const textura_edifici_taronja=preload("res://Assets/Isometric City Pack/png/tall_building_orange_left.png")
const textura_edifici_groc=preload("res://Assets/Isometric City Pack/png/tall_building_yellow_left.png")
const textura_edifici_blau2=preload("res://Assets/Isometric City Pack/png/tall_building_blue_right.png")
const textura_edifici_marro=preload("res://Assets/Isometric City Pack/png/small_building_brown_right.png")
const textura_edifici_gris=preload("res://Assets/Isometric City Pack/png/small_building_gray_left.png")
const textura_edifici_vermell=preload("res://Assets/Isometric City Pack/png/small_building_red_left.png")
const textura_estable_granate=preload("res://Assets/Isometric City Pack/png/warehouse_right.png")
const textura_estable_taronja=preload("res://Assets/Isometric City Pack/png/warehouse_orange_left.png")
const textura_torre_aigua=preload("res://Assets/Isometric City Pack/png/water_tower_left.png")
const textura_casa_mobil1=preload("res://Assets/Isometric City Pack/png/mobile_homes_1_left.png")
const textura_casa_mobil2=preload("res://Assets/Isometric City Pack/png/mobile_homes_2_left.png")
const textura_casa_mobil3=preload("res://Assets/Isometric City Pack/png/mobile_homes_3_left.png")
const textura_casa_llarga_marro=preload("res://Assets/Isometric City Pack/png/house_medium_brown_left.png")
const textura_casa_llarga_blava=preload("res://Assets/Isometric City Pack/png/house_medium_gray_left.png")
const textura_casa_llarga_blanca=preload("res://Assets/Isometric City Pack/png/house_medium_white_right.png")
const textura_casa_gran_vermella=preload("res://Assets/Isometric City Pack/png/house_large_brown_left.png")
const textura_casa_gran_verda=preload("res://Assets/Isometric City Pack/png/house_large_green_left.png")
const textura_casa_gran_blava=preload("res://Assets/Isometric City Pack/png/house_large_teal_left.png")
const textura_hospital=preload("res://Assets/Isometric City Pack/png/hospital_left.png")
const textura_tenda1=preload("res://Assets/Isometric City Pack/png/shopping_plaza_b_left.png")
const textura_tenda2=preload("res://Assets/Isometric City Pack/png/shopping_plaza_right.png")
const textura_tenda_armas=preload("res://Assets/Isometric City Pack/png/gun_shop_right.png")
const textura_esglesia=preload("res://Assets/Isometric City Pack/png/church_left.png")
const textura_granja=preload("res://Assets/Isometric City Pack/png/farm_right.png")
const textura_central_electrica=preload("res://Assets/Isometric City Pack/png/power_station_right.png")
const textura_barberia=preload("res://Assets/Isometric City Pack/png/barber_shop_left.png")
const textura_cafe=preload("res://Assets/Isometric City Pack/png/cafe_left.png")
const textura_policia=preload("res://Assets/Isometric City Pack/png/police_station_left.png")


var _edificis:={"edifici_verd": textura_edifici_verd, "edifici_blau": textura_edifici_blau, "casa_groga": textura_casa_groga, "casa_lila": textura_casa_lila, "edifici_taronja": textura_edifici_taronja, "edifici_groc": textura_edifici_groc, "edifici_blau2": textura_edifici_blau2, "edifici_marro": textura_edifici_marro, "edifici_gris": textura_edifici_gris, "edifici_vermell": textura_edifici_vermell, "estable_granate": textura_estable_granate, "estable_taronja": textura_estable_taronja, "torre_aigua": textura_torre_aigua, "casa_mobil1": textura_casa_mobil1, "casa_mobil2": textura_casa_mobil2, "casa_mobil3": textura_casa_mobil3, "casa_blava": textura_casa_blava, "casa_llarga_marro": textura_casa_llarga_marro, "casa_llarga_blava": textura_casa_llarga_blava, "casa_llarga_blanca": textura_casa_llarga_blanca, "casa_gran_vermella": textura_casa_gran_vermella, "casa_gran_verda": textura_casa_gran_verda, "casa_gran_blava": textura_casa_gran_blava, "hospital": textura_hospital, "tenda1": textura_tenda1, "tenda2": textura_tenda2, "tenda_armas": textura_tenda_armas, "esglesia": textura_esglesia, "granja": textura_granja, "central_electrica": textura_central_electrica, "edifici_blanc": textura_edifici_blanc, "cafe": textura_cafe, "barberia": textura_barberia, "policia": textura_policia}


var _segons=0
var _temps_spawn=15
var _n_clients=0
var _temps_espera_client_max=140
var _temps_espera_passetger_max=80
var _max_clients=1
var _capacitat_clients=10
var _dificultat:=0
var _punts:=0
var _diners:=0
var _punts_per_pujar_dificultat:=2
var _punts_nivell_dificultat:=0

var rng= RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	_spawnear_client()
	$Spawn_client.wait_time=_temps_spawn
	$Spawn_client.start()


func _process(delta):
	pass


func _random_edifici():
	var edifici = _edificis.keys()
	edifici=edifici[rng.randi() % edifici.size()]
	return edifici

func _spawnear_client():
	if _n_clients<_max_clients:
		var client=escena_client.instance()
		var edifici=_random_edifici()
		client._edifici=edifici
		client._canviar_textura(_edificis[edifici])
		client._temps_vida(_temps_espera_client_max)
		_n_clients+=1
		$Taxi._afegir_client(client)
		var fill=find_node(edifici)
		var persona=escena_persona.instance()
		fill.add_child(persona)
		persona.position.x+= rng.randi_range(-25,25)
		persona.position.y+=rng.randi_range(-25,25)
		$Aparicio_client.play()


func _borrar_persona(tipus):
	var a=find_node(tipus)
	var persona=a.get_child(a.get_child_count()-1)
	a.remove_child(persona)
	_n_clients-=1
	persona.queue_free()

func _on_Spawn_client_timeout():
	_spawnear_client()

func _passetger_random_diferent(tipus):
	var client=escena_client.instance()
	var num=rng.randi_range(0,100)
	if tipus!="hospital" and num<10: #per a donar una mica mes de probabilitat al hospital que als altres
		client._edifici="hospital"
		client._canviar_textura(_edificis["hospital"])
		client._temps_vida(_temps_espera_passetger_max)
	else:
		var edifici=_edificis.keys()
		var nou_tipus=edifici[rng.randi() % edifici.size()]
		while nou_tipus==tipus: #ferlo diferent del tipus
			nou_tipus=edifici[rng.randi() % edifici.size()]
		client._edifici=nou_tipus
		client._canviar_textura(_edificis[nou_tipus])
		client._temps_vida(_temps_espera_passetger_max)
	return client

func _sumar_punts(passetger):
	_punts+=1
	_punts_nivell_dificultat+=1
	if _punts_nivell_dificultat==_punts_per_pujar_dificultat:
		_punts_nivell_dificultat=0
		_dificultat+=1
		if _temps_spawn>7:
			_temps_spawn-=1 #baixo el temps de spawn fins a 7
			$Spawn_client.wait_time=_temps_spawn
			print($Spawn_client.wait_time)
			$Spawn_client.stop()
			$Spawn_client.start()
		if _max_clients<_capacitat_clients:
			_max_clients+=1 #augmento la quantitat de clients que hi poden haver al mateix temps
		if _dificultat>3:
			_temps_espera_client_max-=5
			_temps_espera_passetger_max-=3
		_punts_per_pujar_dificultat+=1
	if float(passetger.get_node("Progres").value)/passetger.get_node("Progres").max_value < 2.0/3.0:
		_diners+=passetger._diners_base
	elif float(passetger.get_node("Progres").value)/passetger.get_node("Progres").max_value < 5.0/6.0:
		_diners+=round(passetger._diners_base*1.5)
	else:
		_diners+=round(passetger._diners_base*2.5)
	yield(passetger.get_node("AnimationPlayer"), "animation_finished")
	$Taxi/CanvasLayer/Hud._actualitzar_punts(_punts,_diners)

func _restar_diners(diners):
	_diners-=diners
	$Taxi/CanvasLayer/Hud._actualitzar_punts(_punts,_diners)


func _acabar_partida():
	$Temps.stop()
	var score=escena_score.instance()
	$Taxi/CanvasLayer/Hud.remove_child($Taxi/CanvasLayer/Hud.get_node("Passetgers"))
	$Taxi/CanvasLayer/Hud.remove_child($Taxi/CanvasLayer/Hud.get_node("Clients"))
	$Taxi/CanvasLayer/Hud.remove_child($Taxi/CanvasLayer/Hud.get_node("Sprite"))
	$Taxi/CanvasLayer/Hud.remove_child($Taxi/CanvasLayer/Hud.get_node("Animacio_moneda"))
	$Taxi/CanvasLayer/Hud.remove_child($Taxi/CanvasLayer/Hud.get_node("Animacio_persona"))
	$Taxi/CanvasLayer/Hud.remove_child($Taxi/CanvasLayer/Hud.get_node("Diners"))
	$Taxi/CanvasLayer/Hud.remove_child($Taxi/CanvasLayer/Hud.get_node("Punts"))
	$Taxi/CanvasLayer/Hud/AnimationPlayer.play("Desapareixer")
	yield($Taxi/CanvasLayer/Hud.get_node("AnimationPlayer"),"animation_finished")
	add_child(score)
	score.get_node("Punts").set_text(str(_punts))
	score.get_node("Punts2").set_text(str(_punts))
	score.get_node("Diners").set_text(str(_diners))
	score.get_node("Diners2").set_text(str(_diners))
	var mins=str(_segons/60)
	if mins.length()<2:
		mins="0"+mins
	var secs=str(_segons%60)
	if secs.length()<2:
		secs="0"+secs
	score.get_node("Temps").set_text(mins + ":" + secs)
	score.get_node("Temps2").set_text(mins + ":" + secs)
	score.get_node("Button").connect("button_down",self,"_on_button_down_nova_partida")

func _parar_partida():
	get_tree().paused = true


func _on_Temps_timeout():
	_segons+=1

func _on_button_down_nova_partida():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/Mapa.tscn")
