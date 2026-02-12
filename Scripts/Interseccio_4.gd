extends Area2D


export var _dreta=true
export var _esquerra=true
export var _amunt=true
export var _avall=true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Interseccio_4_body_entered(body):
	if body is Taxi:
		body._desbloquejar(_dreta,_esquerra,_amunt,_avall)



func _on_Interseccio_4_body_exited(body):
	if body is Taxi:
		body._bloq_direccio(_dreta,_esquerra,_amunt,_avall,self)
