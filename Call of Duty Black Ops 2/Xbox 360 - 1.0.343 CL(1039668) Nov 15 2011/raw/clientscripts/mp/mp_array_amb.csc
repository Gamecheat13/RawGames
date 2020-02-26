//
// file: mp_array_amb.csc
// description: clientside ambient script for mp_array: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{
	declareAmbientRoom("outside" );
		setAmbientRoomTone ( "outside", "amb_wind_st", 1.2, 2);
		setAmbientRoomReverb( "outside", "array_outside", 1, 1 );
		setAmbientRoomContext( "outside", "ringoff_plr", "outdoor" );
		
 	declareAmbientPackage( "outside" );
    addAmbientElement( "outside", "amb_hawk", 25, 75, 600, 2000 );
    addAmbientElement( "outside", "amb_crow", 15, 60, 600, 2000 );
 

  declareAmbientRoom( "enclosure" );
		setAmbientRoomReverb( "enclosure", "array_metal_room", 1, 1);
		setAmbientRoomContext( "enclosure", "ringoff_plr", "indoor" );

	declareAmbientRoom("interior" );
		setAmbientRoomReverb( "interior", "array_metal_room", 1, 1 );
 		//setAmbientRoomSnapshot ("interior", "lab_room");
 		setAmbientRoomContext( "interior", "ringoff_plr", "indoor" );
 		
 	//OLD (keeping until reBSP) ************************
 	
 	declareAmbientRoom("interior_2" );
		setAmbientRoomReverb( "interior_2", "array_metal_room", 1, 1 );
		setAmbientRoomContext( "interior_2", "ringoff_plr", "indoor" );
		
		
	//*************  NEW (keeping old to avoid breaking until bsp - Eckert 8/20) *****************
	
  declareAmbientRoom( "corridor" );
  	setAmbientRoomTone ( "corridor", "amb_wind_st_qt", 2, 2);
		setAmbientRoomReverb( "corridor", "array_metal_room", 1, 1);
		setAmbientRoomContext( "corridor", "ringoff_plr", "indoor" );
	
		
	declareAmbientRoom("hangar_med" );
		setAmbientRoomReverb( "hangar_med", "array_hangar_med", 1, 1 );
		setAmbientRoomContext( "hangar_med", "ringoff_plr", "indoor" );
		
	
	declareAmbientRoom("metal_room" );
		setAmbientRoomReverb( "metal_room", "array_metal_room", 1, 1 );
		setAmbientRoomContext( "metal_room", "ringoff_plr", "indoor" );
		
		
		declareAmbientRoom("shipping_container" );
		setAmbientRoomReverb( "shipping_container", "array_container", 1, 1 );
		setAmbientRoomContext( "shipping_container", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("small_room" );
		setAmbientRoomReverb( "small_room", "array_small_room", 1, 1 );
		setAmbientRoomContext( "small_room", "ringoff_plr", "indoor" );	
	
	declareAmbientRoom("partial_room" );
		setAmbientRoomReverb( "partial_room", "array_partial_room", 1, 1 );
		setAmbientRoomContext( "partial_room", "ringoff_plr", "outdoor" );	
		
	
	declareAmbientRoom("sat_station" );
		setAmbientRoomReverb( "sat_station", "array_sat_station", 1, 1 );
		setAmbientRoomContext( "sat_station", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("sat_room_1" );
		setAmbientRoomReverb( "sat_room_1", "array_sat_room_1", 1, 1 );
		setAmbientRoomContext( "sat_room_1", "ringoff_plr", "indoor" );
		
		declareAmbientRoom("sat_room_2" );
		setAmbientRoomReverb( "sat_room_2", "array_sat_room_2", 1, 1 );
		setAmbientRoomContext( "sat_room_2", "ringoff_plr", "indoor" );				
		
	declareAmbientRoom("tunnel" );
		setAmbientRoomReverb( "tunnel", "array_tunnel", 1, 1 );
		setAmbientRoomContext( "tunnel", "ringoff_plr", "indoor" );			


  activateAmbientPackage( 0, "outside", 0 );
	activateAmbientRoom( 0, "outside", 0 );	
	
  thread snd_sat_sound();
  thread sound_loopers_start();
 	thread snd_fx_create(); 
}
sound_loopers_start()
{
	//gears inside main facility
	thread sound_playloop_sound ((-335,761,664),"amb_gear_loop");
	thread sound_playloop_sound ((-96,737,695),"amb_gear_loop");
	thread sound_playloop_sound ((42,932,686),"amb_gear_loop");	
	thread sound_playloop_sound ((-39,1163,667),"amb_gear_loop");
	thread sound_playloop_sound ((-278,1190,676),"amb_gear_loop");			
	thread sound_playloop_sound ((-437,1002,686),"amb_gear_loop");		
	/*Fourecent lights
	thread sound_playloop_sound ((-453,546,647),"amb_light_flourescent");		
	thread sound_playloop_sound ((-185,462,654),"amb_light_flourescent");			
	thread sound_playloop_sound ((-134,1474,649),"amb_light_flourescent");		
	thread sound_playloop_sound ((-383,1341,643),"amb_light_flourescent");		
	thread sound_playloop_sound ((-707,1652,635),"amb_light_flourescent");	
	thread sound_playloop_sound ((-849,-582,534),"amb_light_flourescent");		
	thread sound_playloop_sound ((-589,-383,528),"amb_light_flourescent");			
	thread sound_playloop_sound ((1749,-1179,455),"amb_hum_b");		
	thread sound_playloop_sound ((2416,123,775),"amb_hum_b");			
	thread sound_playloop_sound ((1651,2615,752),"amb_hum_a");			
	thread sound_playloop_sound ((1991,2584,775),"amb_hum_b");			
	
*/
}
snd_sat_sound()
{
	 satsound = spawn( 0, (-202,950,1335), "script_origin" );
	 satsound playloopsound ( "amb_radar_move_loop" );
}
sound_playloop_sound ( org, alias)
{
	 sound = spawn( 0, org, "script_origin" );
	 sound playloopsound ( alias );
}
snd_fx_create ()
{
	// TODO make the audio init happen after FX and put snd_play_auto_fx in _audio
	wait (1);
	
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_mp_distortion_wall_heater", "amb_space_heater");		
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_light_fluorescent_tube_bulb", "amb_light_flourescent");
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_light_floodlight_int_blue", "amb_light_flourescent");				
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_light_office_light_01", "amb_light_hum");			
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_light_office_light_03", "amb_light_hum");			
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_water_drip_light_short", "amb_water_drip");		
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_water_drip_light_long", "amb_water_drip");	
	//clientscripts\mp\_audio::snd_play_auto_fx( "fx_fire_detail_sm", "amb_fire_sml");	
		
}