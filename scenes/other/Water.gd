extends MeshInstance3D

var material: ShaderMaterial
var noise: Image

var noise_scale: float
var wave_speed: float
var height_scale: float

var time: float

# Параметры для синхронизации
@export var target_time: float
@export var target_noise_scale: float
@export var target_wave_speed: float
@export var target_height_scale: float

# Called when the node enters the scene tree for the first time.
func _ready():
	material = mesh.surface_get_material(0)
	noise = material.get_shader_parameter("wave").noise.get_seamless_image(512, 512)
	noise_scale = material.get_shader_parameter("noise_scale")
	wave_speed = material.get_shader_parameter("wave_speed")
	height_scale = material.get_shader_parameter("height_scale")
	
	# Инициализация синхронизируемых параметров
	target_time = time
	target_noise_scale = noise_scale
	target_wave_speed = wave_speed
	target_height_scale = height_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Синхронизация параметров
	sync_parameters(delta)

	time += delta
	material.set_shader_parameter("wave_time", time)

func sync_parameters(delta):
	if multiplayer.is_server():
		# Сохраняем текущие параметры для отправки на клиенты
		target_time = time
		target_noise_scale = noise_scale
		target_wave_speed = wave_speed
		target_height_scale = height_scale
	else:
		# Линейно интерполируем параметры для плавной синхронизации
		time = lerp(time, target_time, delta * 20)
		noise_scale = lerp(noise_scale, target_noise_scale, delta * 20)
		wave_speed = lerp(wave_speed, target_wave_speed, delta * 20)
		height_scale = lerp(height_scale, target_height_scale, delta * 20)
		
		# Применение синхронизированных параметров к материалу
		material.set_shader_parameter("noise_scale", noise_scale)
		material.set_shader_parameter("wave_speed", wave_speed)
		material.set_shader_parameter("height_scale", height_scale)

func get_height(world_position: Vector3) -> float:
	var uv_x = wrapf(world_position.x / noise_scale + time * wave_speed, 0, 1)
	var uv_y = wrapf(world_position.z / noise_scale + time * wave_speed, 0, 1)

	var pixel_pos = Vector2(uv_x * noise.get_width(), uv_y * noise.get_height())
	return global_position.y + noise.get_pixelv(pixel_pos).r * height_scale
