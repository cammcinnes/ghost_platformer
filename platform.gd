extends StaticBody2D

@onready var collision_polygon_2d = $staticbody/platform0
@onready var polygon_2d = $staticbody/platform0/Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
a	polygon_2d.polygon = collision_polygon_2d.polygon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
