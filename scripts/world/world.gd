extends Node

@onready var wall_collision = $platforms/walls
@onready var wall = $platforms/walls/Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	wall.polygon = wall_collision.polygon
	startPlatforms()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func startPlatforms():
	for n in 1:
		var platform_collision = $platforms/platform
		var platform = $platforms/platform0/Polygon2D
		wall.polygon = wall_collision.polygon
