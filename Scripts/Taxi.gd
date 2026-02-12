class_name Taxi
extends KinematicBody2D


var _zoom=false

var _borrant=false

var _tenda=false
var _ambulancia=false
var _recollir=true
var _direccio:="dreta"
var _n_passetgers:=0
var _max_passetgers:=1
var _velocitat = Vector2.ZERO
var _max_vel1 =450
var _max_vel2 =900
var _acceleracio=5
var _acceleracio2=0.5

var _direccio_entrada:="dreta"

var _vec_reposicionar=Vector2.ZERO
var _reposicionar=false
var _ultima_interseccio=Vector2.ZERO
var _distancia_reposicionament=70

var _bloq_dreta=false
var _bloq_esquerra=false
var _bloq_amunt=false
var _bloq_avall=false

var _clients=[]
var _passetgers=[]


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("Dreta")
	$Store.get_child(0).hide()


func _physics_process(delta):
	
	if _tenda:
		if Input.is_action_pressed("ui_e"):
			$Store.get_child(0).show()
			$Store._obrir_tenda(_max_vel2,_acceleracio2)
			get_tree().paused=true
	
	
	
	
	if Input.is_action_pressed("ui_clic_dret"):
		_zoom=true
		if $Camera2D.zoom<Vector2(9,9):
			$Camera2D.zoom+=Vector2(0.1,0.1)
		else:
			$CanvasLayer/Hud.modulate.a-=0.05
	else:
		if _zoom:
			if $CanvasLayer/Hud.modulate.a<1:
				$CanvasLayer/Hud.modulate.a=1
			if $Camera2D.zoom>Vector2(2,2):
				$Camera2D.zoom-=Vector2(0.05,0.05)
			else:
				_zoom=false
	
	if _velocitat.length()>_max_vel2 or _velocitat.length()<_max_vel2*(-1):
		_velocitat= _velocitat.clamped(_max_vel2)

	if _reposicionar and position.distance_to(_ultima_interseccio)>_distancia_reposicionament:
		_reposicionar=false
		if _direccio=="dreta":
			_velocitat=Vector2(1,0.5).normalized() *_velocitat.length()
		elif _direccio=="esquerra":
			_velocitat=Vector2(-1,-0.5).normalized() *_velocitat.length()
		elif _direccio=="amunt":
			_velocitat=Vector2(1,-0.5).normalized() *_velocitat.length()
		elif _direccio=="avall":
			_velocitat=Vector2(-1,0.5).normalized() *_velocitat.length()

	if _reposicionar:
		_velocitat=_vec_reposicionar*(_velocitat.length()+_acceleracio2)
	else:
		if Input.is_action_pressed("ui_shift"):
			_velocitat=_velocitat.linear_interpolate(Vector2(0,0),0.1)
		elif Input.is_action_pressed("ui_right") and !_bloq_dreta:
			if _direccio=="esquerra" or _direccio=="dreta":
				if _velocitat.length()<_max_vel1:
					_velocitat+=Vector2(1,0.5).normalized()*_acceleracio
				else:
					_velocitat+=Vector2(1,0.5).normalized()*_acceleracio2
			else:
				_velocitat=Vector2(1,0.5).normalized() *_velocitat.length()
			if _velocitat.normalized().is_equal_approx(Vector2(-1,-0.5).normalized()):
				$AnimatedSprite.play("Esquerra")
				_direccio="esquerra"
			else:
				$AnimatedSprite.play("Dreta")
				_direccio="dreta"
		elif Input.is_action_pressed("ui_left") and !_bloq_esquerra:
			if _direccio=="dreta" or _direccio=="esquerra":
				if _velocitat.length()<_max_vel1:
					_velocitat+=Vector2(-1,-0.5).normalized()*_acceleracio
				else:
					_velocitat+=Vector2(-1,-0.5).normalized()*_acceleracio2
			else:
				_velocitat=Vector2(-1,-0.5).normalized() *_velocitat.length()
			if _velocitat.normalized().is_equal_approx(Vector2(1,0.5).normalized()):
				$AnimatedSprite.play("Dreta")
				_direccio="dreta"
			else:
				$AnimatedSprite.play("Esquerra")
				_direccio="esquerra"
		elif Input.is_action_pressed("ui_up") and !_bloq_amunt:
			if _direccio=="avall" or _direccio=="amunt":
				if _velocitat.length()<_max_vel1:
					_velocitat+=Vector2(1,-0.5).normalized()*_acceleracio
				else:
					_velocitat+=Vector2(1,-0.5).normalized()*_acceleracio2
			else:
				_velocitat=Vector2(1,-0.5).normalized() *_velocitat.length()
			if _velocitat.normalized().is_equal_approx(Vector2(-1,0.5).normalized()):
				$AnimatedSprite.play("Avall")
				_direccio="avall"
			else:
				$AnimatedSprite.play("Amunt")
				_direccio="amunt"
		elif Input.is_action_pressed("ui_down") and !_bloq_avall:
			if _direccio=="avall" or _direccio=="amunt":
				if _velocitat.length()<_max_vel1:
					_velocitat+=Vector2(-1,0.5).normalized()*_acceleracio
				else:
					_velocitat+=Vector2(-1,0.5).normalized()*_acceleracio2
			else:
				_velocitat=Vector2(-1,0.5).normalized() *_velocitat.length()
			if _velocitat.normalized().is_equal_approx(Vector2(1,-0.5).normalized()):
				_direccio="amunt"
				$AnimatedSprite.play("Amunt")
			else:
				$AnimatedSprite.play("Avall")
				_direccio="avall"
		else:
			_velocitat-=_velocitat.normalized()*_acceleracio2*1.8 #perque vagi perdent una mica de velocitat si no es presiona res

	_velocitat = move_and_slide(_velocitat)
	
	$Velocitat.pitch_scale=0.4+_velocitat.length()/1600

	if Input.is_action_just_pressed("ui_space") and !_ambulancia:
		if _recollir:
			$Llum.pitch_scale=1.5
		else:
			$Llum.pitch_scale=2
		$Llum.play()
		_recollir=!_recollir
		$CanvasLayer/Hud._actualitzar_llum(_recollir)


func _desbloquejar(dreta,esquerra,amunt,avall):
	_direccio_entrada=_direccio
	_bloq_dreta=!dreta
	_bloq_esquerra=!esquerra
	_bloq_amunt=!amunt
	_bloq_avall=!avall

func _bloq_direccio(dreta,esquerra,amunt,avall,interseccio):
	if (_direccio=="dreta" and dreta) or (_direccio=="esquerra" and esquerra) or (_direccio=="avall" and avall) or (_direccio=="amunt" and amunt): #si la direccio està permesa
		if _direccio=="dreta" or _direccio=="esquerra":
			_bloq_amunt=true
			_bloq_avall=true
			_bloq_dreta=false
			_bloq_esquerra=false
			if _direccio_entrada !="dreta" and _direccio_entrada!="esquerra":
				if _direccio=="dreta":
					var punt_reposicionar=interseccio.position + Vector2(1,0.5) *_distancia_reposicionament #trasllado el punt de l'interseccio a 100 pixels en la direccio
					_vec_reposicionar=punt_reposicionar-position
				else:
					var punt_reposicionar=interseccio.position + Vector2(-1,-0.5) *_distancia_reposicionament
					_vec_reposicionar=punt_reposicionar-position
				_reposicionar=true
				_vec_reposicionar=_vec_reposicionar.normalized()
		elif _direccio=="amunt" or _direccio=="avall":
			_bloq_dreta=true
			_bloq_esquerra=true
			_bloq_amunt=false
			_bloq_avall=false
			if _direccio_entrada !="avall" and _direccio_entrada!="amunt":
				if _direccio=="amunt":
					var punt_reposicionar=interseccio.position + Vector2(1,-0.5) *_distancia_reposicionament #trasllado el punt de l'interseccio a 100 pixels en la direccio
					_vec_reposicionar=punt_reposicionar-position
				else:
					var punt_reposicionar=interseccio.position + Vector2(-1,0.5) *_distancia_reposicionament
					_vec_reposicionar=punt_reposicionar-position
				_reposicionar=true
				_vec_reposicionar=_vec_reposicionar.normalized()
		_ultima_interseccio=interseccio.position
	else: #si ha "xocat" (direccio incorrecte) 
		position=interseccio.position
		_velocitat=Vector2(0,0)


func _afegir_client(client):
	if !_borrant:
		_clients.append(client)
		$CanvasLayer/Hud._afegir_client(client,_clients.size()-1)
	
func _recollir_client(tipus):
	if !_ambulancia:
		if _recollir:
			if !_borrant:
				_borrant=true #com a l'hora de desplaçar faig servir el yield i tal, m'asseguro que no s'entri aqui si encara s'estan desplacant per evitar errors, i que com a molt no es pugui recollir en alguna ocasio molt concreta (si es va molt rapid i es passa per un altre punt de recollida mentres encara s'estan desplacant)
				var recollit=false
				var n=0
				var pos=0
				while n<_clients.size() and _n_passetgers<_max_passetgers:
					if _clients[n]._edifici==tipus:
						recollit=true
						_afegir_passetger(tipus)
						var client=$CanvasLayer/Hud._borrar_client(pos)
						get_parent()._borrar_persona(tipus)
						yield(client.get_node("AnimationPlayer"), "animation_finished") #espero a que acabi l'animacio de desapareixer
						_n_passetgers+=1
						_clients.remove(n)
					else:
						n+=1
					pos+=1
				if recollit:
					$CanvasLayer/Hud._desplacar_clients()
				else:
					_borrant=false

func _afegir_passetger(tipus):
	var passetger=get_parent()._passetger_random_diferent(tipus)
	if passetger._edifici=="hospital":
		_ambulancia=true
		$CanvasLayer/Hud._convertir_ambulancia()
		$Sirena.play()
	var n=0
	var inserit=false
	while n<_passetgers.size() and !inserit:
		if _passetgers[n] is String:
			_passetgers[n]=passetger
			inserit=true
		else:
			n+=1
	if !inserit:
		_passetgers.append(passetger)
	$CanvasLayer/Hud._afegir_passetger(passetger,n)

func _deixar_passetger(edifici):
	if edifici=="hospital":
		_ambulancia=false
		$CanvasLayer/Hud._convertir_taxi()
		$CanvasLayer/Hud._actualitzar_llum(_recollir)
		$Sirena.stop()
	if !_ambulancia:
		var pos=0
		for passetger in _passetgers:
			if !passetger is String:
				if passetger._edifici==edifici:
					get_parent()._sumar_punts(passetger)
					_passetgers[pos]="buit"
					$CanvasLayer/Hud._borrar_passetger(pos)
					_n_passetgers-=1
			pos+=1


func _on_Hud_restar_diners(diners):
	get_parent()._restar_diners(diners)


