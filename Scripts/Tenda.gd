extends Zona_edifici


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Zona_recollida_body_entered(body):
	if body is Taxi:
		body._deixar_passetger(edifici)
		body._recollir_client(edifici)
		body._tenda=true

func _on_Zona_recollida_body_exited(body):
	if body is Taxi:
		body._tenda=false
