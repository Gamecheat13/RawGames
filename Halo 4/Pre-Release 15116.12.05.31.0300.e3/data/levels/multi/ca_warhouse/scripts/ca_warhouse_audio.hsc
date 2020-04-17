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

script continuous f_amb_spaceship_platform_area1()
	f_trigger_ambience(tv_amb_spaceship_platform_area1, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_area1_ledge", 
  	"tv_amb_spaceship_platform_area1 - sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_area1_ledge");
end

script continuous f_amb_mechroom_area2()
	f_trigger_ambience(tv_amb_mechroom_area2, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_area2", 
  	"tv_amb_mechroom_area2 - amb_warhouse_baseair_area2");
end

script continuous f_amb_spaceship_platform_area3()
	f_trigger_ambience(tv_amb_spaceship_platform_area3, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_area3", 
  	"tv_amb_spaceship_platform_area3 - amb_warhouse_baseair_area3");
end

script continuous f_amb_spaceship_platform_area4()
	f_trigger_ambience(tv_amb_spaceship_platform_area4, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_area4", 
  	"tv_amb_spaceship_platform_area4 - amb_warhouse_baseair_area4");
end

script continuous f_amb_spaceship_platform_area5()
	f_trigger_ambience(tv_amb_spaceship_platform_area5, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_area5", 
  	"tv_amb_spaceship_platform_area5 - amb_warhouse_baseair_area5");
end

script continuous f_amb_hallway_1()
	f_trigger_ambience(tv_amb_hallway_1, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_hallway1", 
  	"tv_amb_hallway_1 - amb_warhouse_baseair_hallway1");
end

script continuous f_amb_hallway_2()
	f_trigger_ambience(tv_amb_hallway_2, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_hallway2", 
  	"tv_amb_hallway_2 - amb_warhouse_baseair_hallway2");
end

script continuous f_amb_hallway_3()
	f_trigger_ambience(tv_amb_hallway_3, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_hallway3", 
  	"tv_amb_hallway_3 - amb_warhouse_baseair_hallway3");
end

script continuous f_amb_hallway_4()
	f_trigger_ambience(tv_amb_hallway_4, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_hallway4", 
  	"tv_amb_hallway_4 - amb_warhouse_baseair_hallway4");
end

script continuous f_amb_hallway_5()
	f_trigger_ambience(tv_amb_hallway_5, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_hallway5", 
  	"tv_amb_hallway_5 - amb_warhouse_baseair_hallway5");
end

script continuous f_amb_hallway_6()
	f_trigger_ambience(tv_amb_hallway_6, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_hallway6", 
  	"tv_amb_hallway_6 - amb_warhouse_baseair_hallway6");
end

script continuous f_amb_launcher_area_1()
	f_trigger_ambience(tv_amb_launcher_area_1, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_launcher_area_1", 
  	"launcher_area_1 - amb_warhouse_baseair_launcher_area_1");
end

script continuous f_amb_launcher_area_2()
	f_trigger_ambience(tv_amb_launcher_area_2, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_launcher_area_2", 
  	"launcher_area_2 - amb_warhouse_baseair_launcher_area_2");
end

script continuous f_amb_launcher_area_3()
	f_trigger_ambience(tv_amb_launcher_area_3, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_launcher_area_3", 
  	"launcher_area_3 - amb_warhouse_baseair_launcher_area_3");
end

script continuous f_amb_launcher_area_4()
	f_trigger_ambience(tv_amb_launcher_area_4, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_launcher_area_4", 
  	"launcher_area_4 - amb_warhouse_baseair_launcher_area_4");
end

script continuous f_amb_jump_pipe_1()
	f_trigger_ambience(tv_amb_jump_pipe_1, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_jump_pipe", 
  	"tv_amb_jump_pipe_1 - amb_warhouse_baseair_jump_pipe");
end

script continuous f_amb_jump_pipe_2()
	f_trigger_ambience(tv_amb_jump_pipe_2, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_jump_pipe", 
  	"tv_amb_jump_pipe_2 - amb_warhouse_baseair_jump_pipe");
end

script continuous f_amb_stairs_1()
	f_trigger_ambience(tv_amb_stairs_1, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_stairs", 
  	"tv_amb_stairs_1 - amb_warhouse_baseair_stairs");
end

script continuous f_amb_stairs_2()
	f_trigger_ambience(tv_amb_stairs_2, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_stairs", 
  	"tv_amb_stairs_2 - amb_warhouse_baseair_stairs");
end

script continuous f_amb_stairs_3()
	f_trigger_ambience(tv_amb_stairs_3, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_stairs", 
  	"tv_amb_stairs_3 - amb_warhouse_baseair_stairs");
end

script continuous f_amb_stairs_4()
	f_trigger_ambience(tv_amb_stairs_4, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_stairs", 
  	"tv_amb_stairs_4 - amb_warhouse_baseair_stairs");
end

script continuous f_amb_stairs_5()
	f_trigger_ambience(tv_amb_stairs_5, 
  	"sound\environments\multiplayer\warhouse\ambience\amb_warhouse_baseair_stairs", 
  	"tv_amb_stairs_5 - amb_warhouse_baseair_stairs");
end
*/