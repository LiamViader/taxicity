class_name Zona_edifici
extends Area2D


export var edifici:=""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Zona_recollida_body_entered(body):
	if body is Taxi:
		body._deixar_passetger(edifici)
		body._recollir_client(edifici)


func _on_Zona_recollida_body_exited(body):
	pass # Replace with function body.
