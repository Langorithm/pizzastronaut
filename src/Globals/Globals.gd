extends Node

signal o2_changed(delta: int, depleted: bool)

enum NPCs {COUPLE,FAMOUS,HOLOGRAM,RADIO,OLD,VAX}
const DX_01 = preload("res://Sound/SFX/Alien Dialogue/Dx_01.ogg")
const DX_02 = preload("res://Sound/SFX/Alien Dialogue/Dx_02.ogg")
const DX_03 = preload("res://Sound/SFX/Alien Dialogue/Dx_03.ogg")
const DX_04 = preload("res://Sound/SFX/Alien Dialogue/Dx_04.ogg")
const DIALOGUE_GAIN_O2 = preload("res://Sound/SFX/Player Emotes/Player_SighRelief_GainO2.ogg")
const DIALOGUE_LOSE_O2 = preload("res://Sound/SFX/Player Emotes/Player_Groan_LoseO2.ogg")
const PLAYER_GAIN_O2 = preload("res://Portraits/player_large_gain_o2.png")
const PLAYER_LOST_O2 = preload("res://Portraits/player_large_lost_o2.png")
const PLAYER_O2_HIGH = preload("res://Portraits/player_large_high_o2.png")
const PLAYER_O2_LOW = preload("res://Portraits/player_large_low_o2.png")
const PLAYER_O2_MID = preload("res://Portraits/player_large_mid_o2.png")
const PLAYER_O2_CRITICAL = preload("res://Portraits/player_large_o2_critical.png")
const PLAYER_O2_EMPTY = preload("res://Portraits/player_large_o2_empty.png")

var player: Player
var player_active_portrait: Texture2D
var active_conversation: ConversationScreen

var won_npcs = {}
var completed_npc_qty = 0
var npc_portraits_textures = {}
#var npc_voices_audio_streams = []
var max_o2

func _ready():
	var fetch_p = func():
		player = get_tree().get_first_node_in_group("Player")
		max_o2 = (player as Player).max_oxygen
	fetch_p.call_deferred()
	player_active_portrait = PLAYER_O2_HIGH
	
	for npc_name in NPCs.keys():
		npc_name = npc_name.to_lower()
		npc_portraits_textures[npc_name] = load("res://Portraits/%s.png" % [npc_name])
		npc_portraits_textures[npc_name+"_bad"] = load("res://Portraits/%s_bad.png" % [npc_name])
		npc_portraits_textures[npc_name+"_happy"] = load("res://Portraits/%s_happy.png" % [npc_name])



enum Thresholds {EMPTY,CRITICAL,LOW,MID,HIGH}
var thresholds = {
	0.3:Thresholds.CRITICAL,
	0.5:Thresholds.LOW,
	0.75:Thresholds.MID
}
var oxygen_portraits = {
	Thresholds.EMPTY:PLAYER_O2_EMPTY,
	Thresholds.CRITICAL:PLAYER_O2_CRITICAL,
	Thresholds.LOW:PLAYER_O2_LOW,
	Thresholds.MID:PLAYER_O2_MID,
	Thresholds.HIGH:PLAYER_O2_HIGH
}
func get_oxygen_threshold(o2):
	if o2 == 0:
		return Thresholds.EMPTY
	for key in thresholds.keys():
		if o2 < key*max_o2:
			return thresholds[key]
	return Thresholds.HIGH


func increase_oxygen(o2):
	if player:
		#if player.oxygen == 0:
			#pass
		player.increase_oxygen(o2)
		var thr = get_oxygen_threshold(player.oxygen)
		player_active_portrait = oxygen_portraits[thr]
		SM.play(DIALOGUE_GAIN_O2,SM.CH_SFX)
		active_conversation.change_texture(PLAYER_GAIN_O2,true)
		await get_tree().create_timer(0.75).timeout
		active_conversation.change_texture(player_active_portrait,true)
func decrease_oxygen(o2):
	if player:
		SM.play(DIALOGUE_LOSE_O2,SM.CH_SFX)
		active_conversation.change_texture(PLAYER_LOST_O2,true)
		await get_tree().create_timer(0.75).timeout
		if player.oxygen == 0:
				player.pass_out()
		else:
			player.decrease_oxygen(o2)
			if player.oxygen == 0:
				player_active_portrait = PLAYER_O2_EMPTY
			else:
				player_active_portrait = oxygen_portraits[get_oxygen_threshold(player.oxygen)]
		active_conversation.change_texture(player_active_portrait,true)


func win_over():
	won_npcs[active_conversation.npc] = ""


func emote(emotion: String = ""):
	var npc_string = NPCs.keys()[active_conversation.npc].to_lower()
	if emotion:
		npc_string = npc_string + "_"+emotion
	var npc_texture = npc_portraits_textures[npc_string]
	active_conversation.change_texture(npc_texture,false)
