//
// file: mp_mountain_amb.csc

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{
DeclareAmbientRoom ("outside"); 
	SetAmbientRoomtone ("outside", "amb_wind_room_out", 1.5, 1.1);
 	SetAmbientRoomreverb ("outside", "mountain_outside", 1, 1);
 	setAmbientRoomContext( "outside", "ringoff_plr", "outdoor" );
	
DeclareAmbientRoom ("helipad"); 
	SetAmbientRoomtone ("helipad", "amb_wind_room_out", 1.5, 1.5);
	SetAmbientRoomreverb ("helipad", "mountain_outside", 1, 1);
	setAmbientRoomContext( "helipad", "ringoff_plr", "outdoor" );
	
DeclareAmbientRoom ("inside"); 
	SetAmbientRoomreverb ("inside", "mountain_inside", 1, 1);
	setAmbientRoomContext( "inside", "ringoff_plr", "indoor" );
	
DeclareAmbientRoom ("utility_room"); 
	SetAmbientRoomreverb ("utility_room", "mountain_utility_room", 1, 1);
	setAmbientRoomContext( "utility_room", "ringoff_plr", "indoor" );
	
DeclareAmbientRoom ("floor_2"); 
	SetAmbientRoomreverb ("floor_2", "mountain_floor_2", 1, 1);
	setAmbientRoomContext( "floor_2", "ringoff_plr", "indoor" );
	
DeclareAmbientRoom ("small_room"); 
	SetAmbientRoomreverb ("small_room", "mountain_small_room", 1, 1);
	setAmbientRoomContext( "small_room", "ringoff_plr", "indoor" );
	
DeclareAmbientRoom ("open_room"); 
	SetAmbientRoomreverb ("open_room", "mountain_open_room", 1, 1);
	setAmbientRoomContext( "open_room", "ringoff_plr", "indoor" );
	
DeclareAmbientRoom ("partial"); 
	SetAmbientRoomtone ("partial", "amb_wind_room_in", 1.5, 1.5);
	SetAmbientRoomreverb ("partial", "mountain_partial_room", 1, 1);
	setAmbientRoomContext( "partial", "ringoff_plr", "indoor" );
	
DeclareAmbientRoom ("container"); 
	SetAmbientRoomreverb ("container", "mountain_container", 1, 1);
	setAmbientRoomContext( "container", "ringoff_plr", "indoor" );


activateAmbientRoom( 0, "outside", 0 );		

thread vox_comp_radio();	
thread vox_comp_radio_mainframe();
thread snd_fx_create();

}

vox_comp_radio ()
{
	while (1)
	{
		wait(randomintrange(12, 30));	
		playsound(0,"vox_comp_radio", (2635,1596,406));
	}	
}
vox_comp_radio_mainframe ()
{
	while (1)
	{
		wait(randomintrange(12, 30));	
		playsound(0,"vox_comp_radio", (2734,-842,379));
	}	
}	
snd_random (min, max, position, alias)
{
	while (1)
	{
		wait(randomintrange(min, max));	
		playsound(0, alias, (position));
	}	
}	
snd_fx_create ()
{
	// TODO make the audio init happen after FX and put snd_play_auto_fx in _audio
	wait (1);
	
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_mp_distortion_wall_heater", "amb_space_heater");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "fx_light_fluorescent_tube_bulb", "amb_light_flourescent");
	//clientscripts\mp\_audio::snd_play_auto_fx( "fx_light_floodlight_int_blue", "amb_light_flourescent");				
	//clientscripts\mp\_audio::snd_play_auto_fx( "fx_light_office_light_01", "amb_light_hum");			
	//clientscripts\mp\_audio::snd_play_auto_fx( "fx_light_office_light_03", "amb_light_hum");			
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_water_drip_light_short", "amb_water_drip");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "fx_water_drip_light_long", "amb_water_drip");	
	//clientscripts\mp\_audio::snd_play_auto_fx( "fx_fire_detail_sm", "amb_fire_sml");	
		
}