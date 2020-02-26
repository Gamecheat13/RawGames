#include maps\_utility;

main()
{

	level._effect["firelp_med_pm"]					= loadfx ("fire/firelp_med_pm");
	level._effect["ground_fire_med_nosmoke"]		= loadfx ("fire/ground_fire_med_nosmoke"); 
	level._effect["c4_secondary_explosion_01"]		= loadfx ("explosions/exp_pack_hallway");  																																																																																																																																	
	level._effect["c4_secondary_explosion_02"]	 	= loadfx ("explosions/grenadeExp_metal");
	level._effect["c4_secondary_explosion_03"]	 	= loadfx ("explosions/grenadeExp_metal");
	level._effect["hind_explosion"]					= loadfx ("explosions/helicopter_explosion");
	level._effect["heli_aerial_explosion"]			= loadfx ("explosions/aerial_explosion");	
	level._effect["heli_aerial_explosion_large"]	= loadfx ("explosions/aerial_explosion_large");	
	level._effect["thin_black_smoke_M"]				= loadfx ("smoke/thin_black_smoke_M");
	level._effect["smoke_trail_heli"]				= loadfx ("fire/fire_smoke_trail_L");	
	level._effect["fire_trail_heli"]				= loadfx ("fire/fire_smoke_trail_M");
	level._effect["smoke_trail_bmp"]				= loadfx ("smoke/damaged_vehicle_smoke");
	level._effect["smoke_missile_launched_01"] 		= loadfx ("misc/smoke_launchtubes");
	level._effect["smoke_missile_launched_02"] 		= loadfx ("misc/smoke_launchtubes");
	level._effect["firelp_large_pm"]				= loadfx ("fire/firelp_large_pm");
	level._effect["abrams_exhaust"]					= loadfx ("distortion/abrams_exhaust");
	level._effect["steam_cs"]						= loadfx ("smoke/steam_cs");
	level._effect["cargo_steam"]					= loadfx ("smoke/cargo_steam");
	level._effect["fog_bog_a"]						= loadfx ("weather/fog_bog_a");
	level._effect["fog_bog_b"]						= loadfx ("weather/fog_bog_b");	
	level._effect["fog_hunted_a"]					= loadfx ("weather/fog_hunted_a");	
	
	/*-----------------------
	SOUND EFFECTS
	-------------------------*/
	level.scr_sound["launch_heli_dying_loop"]		= "launch_heli_dying_loop";
	level.scr_sound["launch_heli_alarm_loop"]		= "launch_heli_alarm_loop";
	level.scr_sound["launch_alarm_buzzer"]			= "launch_alarm_buzzer";
	level.scr_sound["launch_alarm_siren"]			= "launch_alarm_siren";
	level.scr_sound["launch_alarm_siren_fade"]		= "launch_alarm_siren_fade";
	level.scr_sound["launch_tube_prepare"]			= "launch_tube_prepare";
	level.scr_sound["launch_tube_open_start"]		= "launch_tube_open_start";
	level.scr_sound["launch_tube_open_loop"]		= "launch_tube_open_loop";
	level.scr_sound["launch_tube_open_end"]			= "launch_tube_open_end";
	
	maps\createfx\launchfacility_a_fx::main();
}
