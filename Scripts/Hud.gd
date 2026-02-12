extends Control


const llum_verda=preload("res://Assets/llum_verda.png")
const llum_vermella=preload("res://Assets/llum_vermella.png")
const llum_ambulancia=preload("res://Assets/llum_ambulancia.png")

const taxi=preload("res://Assets/Hud_passetgers.png")
const ambulancia=preload("res://Assets/Hud_passetgers_ambulancia.png")

var _max_clients=8
var _pos_primer_client=0
var _pos_primer_passetger=2


signal restar_diners(diners)

func _ready():
	$Animacio_persona.play("default")
	$Animacio_moneda.play("default")


func _process(delta):
	$Velocitat.set_text(str(round(get_parent().get_parent()._velocitat.length()/8)))


func _actualitzar_llum(recollir):
	if recollir:
		$Passetgers/Llum.texture=llum_verda
	else:
		$Passetgers/Llum.texture=llum_vermella

func _afegir_client(client,pos):
	var pare=$Clients.get_child(_pos_primer_client+pos)
	client._animacio_afegir_client()
	pare.add_child(client)
	
			
func _borrar_client(pos):
	var pare=$Clients.get_child(_pos_primer_client+pos)
	pare.get_child(0)._borrar()
	return pare.get_child(0)

func _desplacar_clients():
	var n=_pos_primer_client
	var desplacament=0
	while n<_max_clients+_pos_primer_client and desplacament<5:
		var pare=$Clients.get_child(n)
		var n_fills=pare.get_child_count()
		if n_fills>0:
			var client=pare.get_child(0)
			if desplacament>0:
				if desplacament==1:
					client.get_node("AnimationPlayer").play("Desplacar1")
					yield(client.get_node("AnimationPlayer"), "animation_finished")
				elif desplacament==2:
					client.get_node("AnimationPlayer").play("Desplacar2")
					yield(client.get_node("AnimationPlayer"), "animation_finished")
				elif desplacament==3:
					client.get_node("AnimationPlayer").play("Desplacar3")
					yield(client.get_node("AnimationPlayer"), "animation_finished")
				else:
					client.get_node("AnimationPlayer").play("Desplacar4")
					yield(client.get_node("AnimationPlayer"), "animation_finished")
				pare.remove_child(client)
				$Clients.get_child(n-desplacament).add_child(client)
				client.rect_position.x=0
		else:
			desplacament+=1
		n+=1
	get_parent().get_parent()._borrant=false

func _afegir_passetger(passetger,pos):
	passetger._animacio_afegir_passetger()
	var pare=$Passetgers.get_child(pos+_pos_primer_passetger)
	pare.add_child(passetger)
	pare.move_child(passetger,0)


func _borrar_passetger(pos):
	var pare=$Passetgers.get_child(pos+_pos_primer_passetger)
	var passetger=pare.get_child(0) 
	passetger._animacio_desapareixer_passetger()
	yield(passetger.get_node("AnimationPlayer"), "animation_finished")
	pare.remove_child(passetger)
	passetger.queue_free()


func _actualitzar_punts(_punts,_diners):
	$Punts.set_text(str(_punts))
	$Diners.set_text(str(_diners))


func _on_Lock1_button_down():
	if get_parent().get_parent()._max_passetgers==1:
		if int($Diners.get_text())>=int($Passetgers.get_child(_pos_primer_passetger+1).get_node("Preu").get_text()):
			var preu=$Passetgers.get_child(_pos_primer_passetger+1).get_node("Preu")
			var buto=$Passetgers.get_child(_pos_primer_passetger+1).get_node("Lock1")
			emit_signal("restar_diners", int(preu.get_text()))
			$Passetgers.get_child(_pos_primer_passetger+1).remove_child(preu)
			preu.queue_free()
			$Passetgers.get_child(_pos_primer_passetger+1).remove_child(buto)
			buto.queue_free()
			get_parent().get_parent()._max_passetgers+=1


func _on_Lock2_button_down():
	if get_parent().get_parent()._max_passetgers==2:#perque no es pugui comprar abans q els mes baratos
		if int($Diners.get_text())>=int($Passetgers.get_child(_pos_primer_passetger+2).get_node("Preu").get_text()):
			var preu=$Passetgers.get_child(_pos_primer_passetger+2).get_node("Preu")
			var buto=$Passetgers.get_child(_pos_primer_passetger+2).get_node("Lock2")
			emit_signal("restar_diners", int(preu.get_text()))
			$Passetgers.get_child(_pos_primer_passetger+2).remove_child(preu)
			preu.queue_free()
			$Passetgers.get_child(_pos_primer_passetger+2).remove_child(buto)
			buto.queue_free()
			get_parent().get_parent()._max_passetgers+=1


func _on_Lock3_button_down():
	if get_parent().get_parent()._max_passetgers==3:
		if int($Diners.get_text())>=int($Passetgers.get_child(_pos_primer_passetger+3).get_node("Preu").get_text()):
			var preu=$Passetgers.get_child(_pos_primer_passetger+3).get_node("Preu")
			var buto=$Passetgers.get_child(_pos_primer_passetger+3).get_node("Lock3")
			emit_signal("restar_diners", int(preu.get_text()))
			$Passetgers.get_child(_pos_primer_passetger+3).remove_child(preu)
			preu.queue_free()
			$Passetgers.get_child(_pos_primer_passetger+3).remove_child(buto)
			buto.queue_free()
			get_parent().get_parent()._max_passetgers+=1

func _on_acabar_partida():
	get_parent().get_parent().get_parent()._acabar_partida()

func _on_parar_partida():
	get_parent().get_parent().get_parent()._parar_partida()


func _convertir_taxi():
	$Passetgers/Sprite.texture=taxi

func _convertir_ambulancia():
	$Passetgers/Sprite.texture=ambulancia
	$Passetgers/Llum.texture=llum_ambulancia
