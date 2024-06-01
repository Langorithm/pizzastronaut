extends Node

enum {CH__MASTER__,CH_MUSIC,CH_SFX,CH_UI}
enum {T_NODE, T_NODE2D}

var root: Node

#func _ready():

func _play(sound_stream: AudioStream, channel:int, audioplayer_type: int) -> Node:
	var sound
	match audioplayer_type:
		T_NODE: sound = AudioStreamPlayer.new()
		T_NODE2D: sound = AudioStreamPlayer2D.new()
		_: assert(false, "Unknown audioplayer type %s" % [audioplayer_type])

	sound.bus = AudioServer.get_bus_name(channel)
	sound.stream = sound_stream
	sound.autoplay = true
	sound.finished.connect(sound.queue_free)
	add_child(sound)
	return sound


func play(sound_stream: AudioStream, channel:int) -> AudioStreamPlayer:
	#pass
	return _play(sound_stream,channel,T_NODE)


func play2d(sound_stream: AudioStream, channel:int, follow: Node2D):
	var sound = _play(sound_stream,channel,T_NODE2D) as AudioStreamPlayer2D
	var remote_transform = RemoteTransform2D.new()

	#var sprite = Sprite2D.new()
	#sprite.texture = PlaceholderTexture2D.new()
	#sprite.scale *= 25
	#sound.add_child(sprite)

	sound.attenuation = 0.8
	sound.panning_strength = 3

	remote_transform.remote_path = sound.get_path()
	remote_transform.update_position = true
	remote_transform.update_rotation = false
	remote_transform.update_scale = false

	follow.add_child(remote_transform)
