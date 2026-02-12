extends CanvasLayer


var _preu_vel=25
var _preu_acceleracio=20


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _obrir_tenda(vel,acceleracio):
	$Control/Acceleracio.set_text(str(acceleracio))
	$Control/Velocitat.set_text(str(vel/8))
	

func _on_Button_exit_button_down():
	$Control.hide()
	get_tree().paused=false



func _on_Button_velocitat_button_down():
	if get_parent().get_parent()._diners>=_preu_vel:
		get_parent().get_parent()._restar_diners(_preu_vel)
		$Control/Comprar.stop()
		$Control/Comprar.play()
		if get_parent()._max_vel2<1600:
			get_parent()._max_vel2+=100
			get_parent()._max_vel1+=50
			$Control/Velocitat.set_text(str(int($Control/Velocitat.get_text())+100/8))
			if get_parent()._max_vel2>=1600:
				$Control/Button_velocitat.queue_free()
				$Control/Preu_velocitat.set_text("Sold out")


func _on_Button_acceleracio_button_down():
	if get_parent().get_parent()._diners>=_preu_acceleracio:
		get_parent().get_parent()._restar_diners(_preu_acceleracio)
		$Control/Comprar.stop()
		$Control/Comprar.play()
		if get_parent()._acceleracio<15:
			get_parent()._acceleracio+=1
			get_parent()._acceleracio2+=0.5
			$Control/Acceleracio.set_text(str(float($Control/Acceleracio.get_text())+0.5))
			if  get_parent()._acceleracio>=15:
				$Control/Button_acceleracio.queue_free()
				$Control/Preu_acceleracio.set_text("Sold out")
