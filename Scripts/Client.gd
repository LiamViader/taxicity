extends Control

const textura_taronja=preload("res://Assets/progres_fill_taronja.png")
const textura_vermella=preload("res://Assets/progres_fill_vermell.png")

var _edifici:=""
var _diners_base:=0
var _alarma_posada=false

var rng= RandomNumberGenerator.new()

signal acabar_partida
signal parar_partida

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	_diners_base=rng.randi_range(5,10)


func _canviar_textura(textura):
	$Ubicacio.texture=textura

func _temps_vida(temps):
	$Progres.max_value=temps
	$Progres.value=temps

func _on_Timer_timeout():
	$Progres.value-=1
	if $Progres.value==5:
		if !_alarma_posada:
			$Alarma.play()
			$AnimationPlayer.play("Poc_temps")
			_alarma_posada=true
	if float($Progres.value)/$Progres.max_value < 1.0/3.0:
		$Progres.texture_progress=textura_vermella
	elif float($Progres.value)/$Progres.max_value < 2.0/3.0:
		$Progres.texture_progress=textura_taronja
	if $Progres.value<=0:
		$Timer.stop()
		$Alarma.stop()
		var hud=get_parent().get_parent().get_parent()
		hud.get_parent().get_parent().get_parent().get_node("AnimationPlayer").play("pujar_musica")
		var pos=self.rect_global_position
		get_parent().remove_child(self)
		hud.add_child(self)#perque estigui a dalt de tot
		self.rect_global_position=pos
		pause_mode = 2
		hud.modulate.a=1
		connect("parar_partida",hud,"_on_parar_partida")
		emit_signal("parar_partida")
		$AnimationPlayer.play("Perdre_partida")
		yield(get_node("AnimationPlayer"), "animation_finished")
		connect("acabar_partida",hud,"_on_acabar_partida")
		emit_signal("acabar_partida")

func _borrar():
	$Alarma.stop()
	$Timer.stop()
	$AnimationPlayer.play("Desapareixer")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_parent().remove_child(self)
	queue_free()

func _animacio_afegir_client():
	$AnimationPlayer.play("Apareixer")

func _animacio_afegir_passetger():
	$Pujar_cotxe.play()
	$AnimationPlayer.play("Pujar_cotxe")

func _animacio_desapareixer_passetger():
	$Alarma.stop()
	$Timer.stop()
	if float($Progres.value)/$Progres.max_value < 2.0/3.0:
		$Preu.set_text("+ " + str(_diners_base))
	elif float($Progres.value)/$Progres.max_value < 5.0/6.0:
		$Preu.set_text("+ " + str(round(_diners_base*1.5)))
	else:
		$Preu.set_text("+ " + str(round(_diners_base*2.5)))
	$Guanyar_diners.play()
	$AnimationPlayer.play("Baixar_cotxe")
