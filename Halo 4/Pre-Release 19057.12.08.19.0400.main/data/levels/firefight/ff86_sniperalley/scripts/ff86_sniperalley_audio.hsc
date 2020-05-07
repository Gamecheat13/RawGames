; =================================================================================================
; *** AMBIENCE ***
; =================================================================================================

global boolean b_audio_debug = false;

script static void audio_print(string s)
	if b_audio_debug then
		print (s);
	end
end

script static void f_trigger_ambience(trigger_volume tv, looping_sound amb_tag, string debug_text)
	sleep_until(volume_test_players(tv), 1);
	sound_looping_start(amb_tag, NONE, 1.0);
	audio_print(debug_text);
	sleep_until(volume_test_players(tv) == false, 1);
	sound_looping_stop(amb_tag);
	audio_print(debug_text);
end

script continuous f_amb_sniperalley_01()
  f_trigger_ambience(tv_amb_sniperalley_01, 
  	"sound\environments\multiplayer\sniperalley\ambience\amb_sniperalley_baseairs_01", 
  	"[amb] tv_amb_sniperalley_01 - amb_sniperalley_baseairs_01");
end

script continuous f_amb_sniperalley_02()
  f_trigger_ambience(tv_amb_sniperalley_02, 
  	"sound\environments\multiplayer\sniperalley\ambience\amb_sniperalley_baseairs_02", 
  	"[amb] tv_amb_sniperalley_02 - amb_sniperalley_baseairs_02");
end

script continuous f_amb_sniperalley_03()
  f_trigger_ambience(tv_amb_sniperalley_03, 
  	"sound\environments\multiplayer\sniperalley\ambience\amb_sniperalley_baseairs_03", 
  	"[amb] tv_amb_sniperalley_03 - amb_sniperalley_baseairs_03");
end