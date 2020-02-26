//
// file: mp_zombie_temp_amb.csc
// description: clientside ambient script for mp_zombie_temp: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_music;
#include clientscripts\mp\_audio;

main()
{
	//****AMBIENT PACKAGES****\\
	declareAmbientRoom("outdoor" );
	declareambientpackage( "outdoor" );
		setAmbientRoomtone ("outdoor", "amb_bg_forest_loop", 3, 3);
		setAmbientRoomReverb( "outdoor", "socotra_outdoor", 1, 1 );
		setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
	
	//Station Room Standard: Room at the bus station, standard wood walls, medium size		
	declareAmbientRoom("station_room_standard" );
	declareambientpackage( "station_room_standard" );
		setAmbientRoomtone ("station_room_standard", "amb_bg_forest_loop", 3, 3);
		setAmbientRoomReverb( "station_room_standard", "socotra_mediumroom", 1, 1 );
		setAmbientRoomContext( "station_room_standard", "ringoff_plr", "indoor" );	
		setAmbientRoomSnapshot( "station_room_standard", "zmb_duck_ext_ambience" );
		
	//Station Bunker: Stone bunker beneath the bus station, small size	
	declareAmbientRoom("station_bunker" );
	declareambientpackage( "station_bunker" );
		setAmbientRoomtone ("station_bunker", "amb_bg_tunnel_loop", 3, 3);
		setAmbientRoomReverb( "station_bunker", "socotra_stoneroom", 1, 1 );
		setAmbientRoomContext( "station_bunker", "ringoff_plr", "indoor" );	
		
	//Tunnel: Large long stone tunnel, lots of cars strewn about, dark, scary
	declareAmbientRoom("tunnel" );
	declareambientpackage( "tunnel" );
		setAmbientRoomtone ("tunnel", "amb_bg_tunnel_loop", 3, 3);
		setAmbientRoomReverb( "tunnel", "socotra_stoneroom", 1, 1 );
		setAmbientRoomContext( "tunnel", "ringoff_plr", "outdoor" );

	//Diner: Medium Diner, some sheet metal walls, normal
	declareAmbientRoom("diner" );
	declareambientpackage( "diner" );
		setAmbientRoomtone ("diner", "amb_bg_forest_loop", 3, 3);
		setAmbientRoomReverb( "diner", "socotra_mediumroom", 1, 1 );
		setAmbientRoomContext( "diner", "ringoff_plr", "indoor" );	
		setAmbientRoomSnapshot( "diner", "zmb_duck_ext_ambience" );		
	
	//Gas Station Storefront: Medium sized, stone floors, counter and such in there
	declareAmbientRoom("gas_storefront" );
	declareambientpackage( "gas_storefront" );
		setAmbientRoomtone ("gas_storefront", "amb_bg_forest_loop", 3,3);
		setAmbientRoomReverb( "gas_storefront", "socotra_mediumroom", 1, 1 );
		setAmbientRoomContext( "gas_storefront", "ringoff_plr", "indoor" );	
		setAmbientRoomSnapshot( "gas_storefront", "zmb_duck_ext_ambience" );
		
	//Gas Station Garage: Medium sized, stone floors, garage for bodywork and such
	declareAmbientRoom("gas_garage" );
	declareambientpackage( "gas_garage" );
		setAmbientRoomtone ("gas_garage", "amb_bg_forest_loop", 3, 3);
		setAmbientRoomReverb( "gas_garage", "socotra_mediumroom", 1, 1 );
		setAmbientRoomContext( "gas_garage", "ringoff_plr", "indoor" );
		setAmbientRoomSnapshot( "gas_garage", "zmb_duck_ext_ambience" );

	//Farm House: Medium sized rooms, wooden
	declareAmbientRoom("farm_house" );
	declareambientpackage( "farm_house" );
		setAmbientRoomtone ("farm_house", "amb_bg_forest_loop", 3, 3);
		setAmbientRoomReverb( "farm_house", "socotra_mediumroom", 1, 1 );
		setAmbientRoomContext( "farm_house", "ringoff_plr", "indoor" );	
		setAmbientRoomSnapshot( "farm_house", "zmb_duck_ext_ambience" );

	//Farm Garage: Medium sized, standard garage
	declareAmbientRoom("farm_garage" );
	declareambientpackage( "farm_garage" );
		setAmbientRoomtone ("farm_garage", "amb_bg_forest_loop", 3, 3);
		setAmbientRoomReverb( "farm_garage", "socotra_mediumroom", 1, 1 );
		setAmbientRoomContext( "farm_garage", "ringoff_plr", "indoor" );
		setAmbientRoomSnapshot( "farm_garage", "zmb_duck_ext_ambience" );		

	//Farm Garage: Large, wooden, some concrete
	declareAmbientRoom("farm_barn" );
	declareambientpackage( "farm_barn" );
		setAmbientRoomtone ("farm_barn", "amb_bg_forest_loop", 3, 3);
		setAmbientRoomReverb( "farm_barn", "socotra_largeroom", 1, 1 );
		setAmbientRoomContext( "farm_barn", "ringoff_plr", "indoor" );
		setAmbientRoomSnapshot( "farm_barn", "zmb_duck_ext_ambience" );
		
	//Cornfield: Generic cornfield exterior, using this to switch out background track
	declareAmbientRoom("cornfield" );
	declareambientpackage( "cornfield" );
		setAmbientRoomtone ("cornfield", "amb_bg_cornfield_loop", 3, 3);
		setAmbientRoomReverb( "cornfield", "socotra_outdoor", 1, 1 );
		setAmbientRoomContext( "cornfield", "ringoff_plr", "outdoor" );	
		
	//industrial: Generic industrial exterior, using this to switch out background track
	declareAmbientRoom("industrial" );
	declareambientpackage( "industrial" );
		setAmbientRoomtone ("industrial", "amb_bg_industrial_loop", 3, 3);
		setAmbientRoomReverb( "industrial", "socotra_outdoor", 1, 1 );
		setAmbientRoomContext( "industrial", "ringoff_plr", "outdoor" );	

	//Industrial Garage: MEdium square stone room with metal door
	declareAmbientRoom("industrial_garage" );
	declareambientpackage( "industrial_garage" );
		setAmbientRoomtone ("industrial_garage", "amb_bg_industrial_loop", 3, 3);
		setAmbientRoomReverb( "industrial_garage", "socotra_smallroom", 1, 1 );
		setAmbientRoomContext( "industrial_garage", "ringoff_plr", "indoor" );
		setAmbientRoomSnapshot( "industrial_garage", "zmb_duck_ext_ambience" );		

	//Industrial Reactor: Large circular room with a nuclear(?) reactor thingy at the center
	declareAmbientRoom("industrial_reactor" );
	declareambientpackage( "industrial_reactor" );
		setAmbientRoomtone ("industrial_reactor", "amb_bg_industrial_loop", 3, 3);
		setAmbientRoomReverb( "industrial_reactor", "socotra_largeroom", 1, 1 );
		setAmbientRoomContext( "industrial_reactor", "ringoff_plr", "indoor" );
		setAmbientRoomSnapshot( "industrial_reactor", "zmb_duck_ext_ambience" );

	//Industrial Power Room: Room adjacent to reactor, stone-ish, has many computers and such
	declareAmbientRoom("industrial_powerroom" );
	declareambientpackage( "industrial_powerroom" );
		setAmbientRoomtone ("industrial_powerroom", "amb_bg_industrial_loop", 3, 3);
		setAmbientRoomReverb( "industrial_powerroom", "socotra_largeroom", 1, 1 );
		setAmbientRoomContext( "industrial_powerroom", "ringoff_plr", "indoor" );
		setAmbientRoomSnapshot( "industrial_powerroom", "zmb_duck_ext_ambience" );

	//Indsutrial Warehouse: Humongous stone warehouse
	declareAmbientRoom("industrial_warehouse" );
	declareambientpackage( "industrial_warehouse" );
		setAmbientRoomtone ("industrial_warehouse", "amb_bg_industrial_loop", 3, 3);
		setAmbientRoomReverb( "industrial_warehouse", "socotra_largeroom", 1, 1 );
		setAmbientRoomContext( "industrial_warehouse", "ringoff_plr", "indoor" );
		setAmbientRoomSnapshot( "industrial_warehouse", "zmb_duck_ext_ambience" );		
	
	//Town: Generic town exterior, using this to switch out background track
	declareAmbientRoom("town" );
	declareambientpackage( "town" );
		setAmbientRoomtone ("town", "", .55, 1);
		setAmbientRoomReverb( "town", "socotra_outdoor", 1, 1 );
		setAmbientRoomContext( "town", "ringoff_plr", "outdoor" );	
		
	//Town Bowling Alley: Bowling alley in the town
	declareAmbientRoom("town_bowlingalley" );
	declareambientpackage( "town_bowlingalley" );
		setAmbientRoomtone ("town_bowlingalley", "", .55, 1);
		setAmbientRoomReverb( "town_bowlingalley", "socotra_mediumroom", 1, 1 );
		setAmbientRoomContext( "town_bowlingalley", "ringoff_plr", "indoor" );
		setAmbientRoomSnapshot( "town_bowlingalley", "zmb_duck_ext_ambience" );

	//Town Bar: Bar with a pool table and such, two floors, mostly wood, medium size
	declareAmbientRoom("town_bar" );
	declareambientpackage( "town_bar" );
		setAmbientRoomtone ("town_bar", "", .55, 1);
		setAmbientRoomReverb( "town_bar", "socotra_mediumroom", 1, 1 );
		setAmbientRoomContext( "town_bar", "ringoff_plr", "indoor" );
		setAmbientRoomSnapshot( "town_bar", "zmb_duck_ext_ambience" );

	//Town Bank: Large room, glass front
	declareAmbientRoom("town_bank" );
	declareambientpackage( "town_bank" );
		setAmbientRoomtone ("town_bank", "", .55, 1);
		setAmbientRoomReverb( "town_bank", "socotra_largeroom", 1, 1 );
		setAmbientRoomContext( "town_bank", "ringoff_plr", "indoor" );	
		setAmbientRoomSnapshot( "town_bank", "zmb_duck_ext_ambience" );
		
	//DEFAULT AMBIENT ROOMS
	activateambientroom( 0, "outdoor", 0 );
	activateambientpackage( 0, "outdoor", 0 );
	
	
	
	//****MUSIC****\\
	declareMusicState("WAVE");
		musicAliasloop("mus_theatre_underscore", 4, 2);	
		
	declareMusicState("EGG");
		musicAlias("mus_egg", 1);
		
	declareMusicState( "SILENCE");
	    musicAlias("null", 1 );
	   
	declareMusicState("ENC_WAITING");
		musicAliasloop("mus_zmb_encounters_waiting", 0, 2.5);
		
	declareMusicState("ENC_ROUND_START");
		musicAlias("mus_zmb_encounters_rnd_start");
		musicAliasloop("mus_zmb_encounters_rnd_loop", 0, 0);
	
	declareMusicState("ENC_ROUND_END");
		musicAlias("mus_zmb_encounters_rnd_end");
	
	declareMusicState("ENC_HALFTIME");
		musicAliasloop("mus_zmb_encounters_halftime", 0, 2.5);
		
	declareMusicState("ENC_MATCH_OVER");	
		musicAlias("mus_zmb_encounters_match");
		
	declareMusicState("ENC_FINAL_STRETCH");
		musicAlias("mus_zmb_encounters_final_stretch");
		musicAliasloop("mus_zmb_encounters_rnd_loop_fast", 0, 0);  
	
	//****FUNCTIONS****\\
	
	level thread bus_interior_loop_start();
	level thread powerOn_audio();
	level thread snd_start_autofx_audio();
}


setHeavyRain()
{
	deactivateAmbientRoom( 0, "default", 0 );
	activateAmbientRoom( 0, "heavy_rain", 0 );
}
setNormalRain()
{
	deactivateAmbientRoom( 0, "heavy_rain", 0 );
	activateAmbientRoom( 0, "default", 0 );
}

bus_interior_loop_start()
{
	while(1)
	{
		level waittill( "buslps" );
		ent = spawn( 0, (0,0,0), "script_origin" );
		ent playloopsound( "zmb_bus_interior_loop", 4 );
		ent thread bus_interior_loop_end();
	}
}
bus_interior_loop_end()
{
	level waittill( "buslpe" );
	self stoploopsound( 1 );
	wait(1);
	self delete();
}

powerOn_audio()
{
	level waittill( "pwr" );
	
	playsound( 0, "zmb_power_on_quad", (0,0,0) );
	
	array_thread( getstructarray( "airraid", "targetname" ), ::air_raid_alarm );
}

air_raid_alarm()
{
	level endon( "pwr" );
	
	while(1)
	{
		playsound( 0, "amb_alarm_airraid", self.origin );
		wait(11);
	}
}

//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofx_audio()
{
	//Smallish Fires
	snd_play_auto_fx( "fx_zmb_lava_detail", "zmb_lava_smallfire", 0, 0, 0, false );
	//Light rising from open lava fissures
	snd_play_auto_fx( "fx_zmb_lava_crevice_glow_50", "zmb_lava_crevice", 0, 0, 0, false );
	snd_play_auto_fx( "fx_zmb_lava_crevice_glow_100", "zmb_lava_crevice", 0, 0, 0, false );
	snd_play_auto_fx( "fx_zmb_lava_100x100", "zmb_lava_main", 0, 0, 0, false, 200, 3, "zmb_lava_main" );
	snd_play_auto_fx( "fx_zmb_lava_50x50_sm", "zmb_lava_main", 0, 0, 0, false, 350, 2, "zmb_lava_main" );
	//Fires at the edge of huge mounds of lava
    snd_play_auto_fx( "fx_zmb_lava_edge_100", "zmb_lava_edge_large", 0, 0, 0, true );
    //Flourescent lights
	snd_play_auto_fx( "fx_zmb_tranzit_flourescent_glow", "amb_flourescent_light", 0, 0, 0, true );
	snd_play_auto_fx( "fx_zmb_tranzit_flourescent_dbl_glow", "amb_flourescent_light", 0, 0, 0, false );
	//Safety Light
	snd_play_auto_fx( "fx_zmb_tranzit_light_safety", "zmb_safety_light", 0, 0, 0, false );	
}