; =================================================================================================
; *** AMBIENCES ***
; =================================================================================================
/*
script static void f_trigger_ambience(trigger_volume tv, looping_sound amb_tag, string debug_text)
	sleep_until(volume_test_players(tv), 1);
	sound_looping_start(amb_tag, NONE, 1.0);
	sleep_until(volume_test_players(tv) == 0, 1);
	sound_looping_stop(amb_tag);
end

script continuous f_amb_wraparound_01()
	f_trigger_ambience(tv_amb_wraparound_01, 
  	"sound\environments\multiplayer\wraparound\ambience\amb_wraparound_paseair_area_01", 
  	"tv_amb_wraparound_01 - amb_wraparound_paseair_area_01");
end

script continuous f_amb_wraparound_02()
	f_trigger_ambience(tv_amb_wraparound_02, 
  	"sound\environments\multiplayer\wraparound\ambience\amb_wraparound_paseair_area_02", 
  	"tv_amb_wraparound_02 - amb_wraparound_paseair_area_02");
end

script continuous f_amb_wraparound_03()
	f_trigger_ambience(tv_amb_wraparound_03, 
  	"sound\environments\multiplayer\wraparound\ambience\amb_wraparound_paseair_area_03", 
  	"tv_amb_wraparound_03 - amb_wraparound_paseair_area_03");
end

script continuous f_amb_wraparound_04_a()
	f_trigger_ambience(tv_amb_wraparound_04_a, 
  	"sound\environments\multiplayer\wraparound\ambience\amb_wraparound_paseair_area_04", 
  	"tv_amb_wraparound_04_a - amb_wraparound_paseair_area_04");
end

script continuous f_amb_wraparound_04_b()
	f_trigger_ambience(tv_amb_wraparound_04_b, 
  	"sound\environments\multiplayer\wraparound\ambience\amb_wraparound_paseair_area_04", 
  	"tv_amb_wraparound_04_a - amb_wraparound_paseair_area_04");
end

script continuous f_amb_wraparound_05_upper()
	f_trigger_ambience(tv_amb_wraparound_05_upper, 
  	"sound\environments\multiplayer\wraparound\ambience\amb_wraparound_paseair_area_05", 
  	"tv_amb_wraparound_05_upper - amb_wraparound_paseair_area_05");
end

script continuous f_amb_wraparound_05_lower()
	f_trigger_ambience(tv_amb_wraparound_05_lower, 
  	"sound\environments\multiplayer\wraparound\ambience\amb_wraparound_paseair_area_05", 
  	"tv_amb_wraparound_05_lower - amb_wraparound_paseair_area_05");
end

script continuous f_amb_wraparound_06_upper()
	f_trigger_ambience(tv_amb_wraparound_06_upper, 
  	"sound\environments\multiplayer\wraparound\ambience\amb_wraparound_paseair_area_06", 
  	"tv_amb_wraparound_06_upper - amb_wraparound_paseair_area_06");
end

script continuous f_amb_wraparound_06_lower()
	f_trigger_ambience(tv_amb_wraparound_06_lower, 
  	"sound\environments\multiplayer\wraparound\ambience\amb_wraparound_paseair_area_06", 
  	"tv_amb_wraparound_06_lower - amb_wraparound_paseair_area_06");
end

script continuous f_amb_wraparound_07()
	f_trigger_ambience(tv_amb_wraparound_07, 
  	"sound\environments\multiplayer\wraparound\ambience\amb_wraparound_paseair_area_07", 
  	"tv_amb_wraparound_07 - amb_wraparound_paseair_area_07");
end

script continuous f_amb_wraparound_wind_01() 
	f_trigger_ambience(tv_amb_wraparound_wind_01, 
  	"sound\environments\multiplayer\wraparound\ambience\amb_wraparound_baseair_wind", 
  	"tv_amb_wraparound_wind_01 - amb_wraparound_baseair_wind");
end

script continuous f_amb_wraparound_wind_02() 
	f_trigger_ambience(tv_amb_wraparound_wind_02, 
  	"sound\environments\multiplayer\wraparound\ambience\amb_wraparound_baseair_wind", 
  	"tv_amb_wraparound_wind_02 - amb_wraparound_baseair_wind");
end
*/