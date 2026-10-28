
extends Node

const SAMPLE_RATE: int = 44100
const DURATION: float = 0.16
const VOICE_COUNT: int = 6

var shot_stream: AudioStreamWAV
var voices: Array[AudioStreamPlayer] = []


func _ready() -> void:
	shot_stream = generate_shot()

	# Несколько голосов позволяют звукам перекрываться.
	for i in range(VOICE_COUNT):
		var player := AudioStreamPlayer.new()
		player.name = "ShotVoice%d" % i
		player.stream = shot_stream
		player.volume_db = -5.0
		add_child(player)
		voices.append(player)


func generate_shot() -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.mix_rate = SAMPLE_RATE
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false

	var count := int(SAMPLE_RATE * DURATION)
	var samples := PackedByteArray()
	samples.resize(count * 2)

	var rng := RandomNumberGenerator.new()
	rng.randomize()

	# Состояние сглаженного шума для низкого грохота.
	var low_noise: float = 0.0
	var previous_noise: float = 0.0

	for i in range(count):
		var t := float(i) / SAMPLE_RATE

		# Резкая атака и быстро затухающий пороховой удар.
		var crack_env := exp(-t * 100.0)
		var crack := rng.randf_range(-1.0, 1.0) * crack_env

		# Шумовой корпус выстрела.
		var body_env := exp(-t * 32.0)
		var noise := rng.randf_range(-1.0, 1.0)

		# Простейшая фильтрация шума.
		low_noise = lerpf(low_noise, noise, 0.22)
		var mid_noise := noise - low_noise

		# Низкий удар, который быстро затухает.
		var thump_env := exp(-t * 38.0)
		var thump := sin(TAU * 95.0 * t) * thump_env

		var sample_value := (
			crack * 0.75
			+ mid_noise * body_env * 0.48
			+ low_noise * body_env * 0.22
			+ thump * 0.45
		)

		# Короткий плавный спад в самом конце.
		var end_fade := minf(1.0, (DURATION - t) / 0.015)
		sample_value *= clampf(end_fade, 0.0, 1.0)

		sample_value = clampf(sample_value, -1.0, 1.0)

		samples.encode_s16(
			i * 2,
			int(sample_value * 32767.0)
		)

	stream.data = samples
	return stream


func play_shot() -> void:
	# Ищем свободный аудиоплеер.
	for player in voices:
		if not player.playing:
			player.pitch_scale = randf_range(0.96, 1.04)
			player.volume_db = randf_range(-6.0, -3.0)
			player.play()
			return

	# Если все голоса заняты, переиспользуем первый.
	var player := voices[0]
	player.pitch_scale = randf_range(0.96, 1.04)
	player.play()
