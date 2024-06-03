extends Node

signal o2_changed(delta: int, depleted: bool)

enum NPCs {COUPLE,FAMOUS,HOLOGRAM,RADIO,OLD,VAX}
const DX_01 = preload("res://Sound/SFX/Alien Dialogue/Dx_01.ogg")
const DX_02 = preload("res://Sound/SFX/Alien Dialogue/Dx_02.ogg")
const DX_03 = preload("res://Sound/SFX/Alien Dialogue/Dx_03.ogg")
const DX_04 = preload("res://Sound/SFX/Alien Dialogue/Dx_04.ogg")

var player: Player
var active_conversation: ConversationScreen

var won_npcs = {}
var npc_portraits_textures = {}
#var npc_voices_audio_streams = []

func _ready():
	var fetch_p = func():
		player = get_tree().get_first_node_in_group("Player")
	fetch_p.call_deferred()
	
	for npc_name in NPCs.keys():
		npc_name = npc_name.to_lower()
		npc_portraits_textures[npc_name] = load("res://Portraits/%s.png" % [npc_name])
		npc_portraits_textures[npc_name+"_bad"] = load("res://Portraits/%s_bad.png" % [npc_name])
		npc_portraits_textures[npc_name+"_happy"] = load("res://Portraits/%s_happy.png" % [npc_name])
	#Vorkus = Type 1
#Gorama = Type 4
#Vanila = Type 3
#Chimi = Type 2
#Vax = Type 1
#Radio(?) = Type 2
#Zarusha = Type 3

func increase_oxygen(o2):
	if player:
		player.increase_oxygen(o2)	
func decrease_oxygen(o2):
	if player:
		player.decrease_oxygen(o2)


func win_over():
	won_npcs[active_conversation.npc] = ""


func emote(emotion: String = ""):
	var npc_string = NPCs.keys()[active_conversation.npc].to_lower()
	if emotion:
		npc_string = npc_string + "_"+emotion
	var npc_texture = npc_portraits_textures[npc_string]
	active_conversation.change_texture(npc_texture,false)
