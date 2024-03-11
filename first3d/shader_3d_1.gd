extends MeshInstance3D

var noise_tex: NoiseTexture2D

func _ready():
	var my = $"." as MeshInstance3D
	var noise_tex = preload("res://tex_shader_3d_1.tres")
	var normal_map = noise_tex.duplicate()
	
	normal_map.as_normal_map = true


	mesh.material.set_shader_parameter("normalmap", normal_map)
