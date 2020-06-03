#include maps\_ambientpackage;
#include maps\_busing;
#include maps\_utility;



main()
{
	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	declareAmbientPackage( "default" );
		addAmbientElement( "default", "bomb_far_falloff", 5, 20,100, 300 );
		addAmbientElement( "default", "amb_metal", 1, 10,50, 1200 );
		
	declareAmbientPackage( "at_sea" );
		addAmbientElement( "at_sea", "bomb_far_falloff", 5, 20,100, 300 );	
		addAmbientElement( "default", "amb_metal", 5, 15,50, 800 );
	
	declareAmbientRoom( "default" );
		setAmbientRoomTone( "default", "plane_interor" );
		setAmbientRoomReverb( "default", "plain", 1, 1);

	declareAmbientRoom( "at_sea" );
		setAmbientRoomTone( "at_sea", "at_sea" );
		setAmbientRoomReverb( "at_sea", "plain", 1, 1);
		
	activateAmbientRoom( "default", 0 );
	activateAmbientPackage( "default", 0 );
	
	//************************************
	// Start Scripts
	//************************************
	
	//level thread start_music_intro();
	//level thread start_merchant_ship_siren();
	//-- Edit by glocke::2/15
	//level thread start_plane_landed_sounds();

	setbusstate("SHHH_PROJECTILES");

	level.zeroflyby = [];
	level.zeroflyby[0]["sound"] = "intro_plane1";
	level.zeroflyby[0]["length"] = 5;

	level.zeroflyby[1]["sound"] = "intro_plane2";
	level.zeroflyby[1]["length"] = 3;

	level.zeroflyby[2]["sound"] = "intro_plane3";
	level.zeroflyby[2]["length"] = 4;

	level.zeroflyby[3]["sound"] = "intro_plane4";
	level.zeroflyby[3]["length"] = 3;

	level.zeroflyby[4]["sound"] = "intro_plane1";
	level.zeroflyby[4]["length"] = 5;

	level.zeroflyby[5]["sound"] = "intro_plane2";
	level.zeroflyby[5]["length"] = 3;

	level.zeroflyby[6]["sound"] = "intro_plane3";
	level.zeroflyby[6]["length"] = 4;

	level.zeroflyby[7]["sound"] = "intro_plane4";
	level.zeroflyby[7]["length"] = 3;

	level.zeroflyby[8]["sound"] = "intro_plane8";
	level.zeroflyby[8]["length"] = 5;

	
	level thread start_planes_sounds();



} 
start_planes_sounds()
{
	wait(5);
	players = get_players();
	for(i = 0; i < players.size; i++)
	{
		players[i] playsound("pby_engines_streamed");
	}


}
start_music_intro()
{
	level endon("start strafing music special");
	//wait(5.0);
	//start playing "In The Clouds" -- Sean Murray
	playsoundatposition("in_the_clouds",(21928, 42504, -32));
	wait(130);
	//start playing "Strafing Run" --- Sean Murray
	playsoundatposition("strafing_run",(21928, 42504, -32));
}

start_music_intro_m()
{
	level notify("start strafing music special");
	//start playing "Strafing Run" --- Sean Murray
	playsoundatposition("strafing_run",(21928, 42504, -32));
}

start_merchant_ship_siren()
{
	//-- this plays on the 2nd merchant ship
	//wait(3);
	level.alarm_struct = GetEnt("merch_ship_alarm", "targetname");
	level.alarm_struct playloopsound("merch_ship_alarm");
}

start_merchant_ship_klaxon()
{
	//-- play on ship 1
	level.klaxon_struct = GetEnt("merch_ship_klaxon", "targetname");
	level.klaxon_struct playloopsound("merch_ship_klaxon");
	level.bell_struct = GetEnt("merch_ship_bell", "targetname");
	level.bell_struct playloopsound("merch_ship_bell");
}

start_merchant_ship_coll()
{
	level.coll_struct = GetEnt("merch_ship_coll", "targetname");
	level.coll_struct playloopsound("merch_ship_collision");
}

start_merchant_ship_pa()
{
	level.pa_struct = GetEnt("merch_ship_pa", "targetname");
	PlaySoundAtPosition("merch_ship_pa", level.pa_struct.origin);
}

stop_merchant_ship_siren()
{
	level.alarm_struct StopLoopSound(2);
	wait(2.5);
	level.alarm_struct Delete();
}

stop_merchant_ship_klaxon()
{
	level.klaxon_struct StopLoopSound(2);
	level.bell_struct StopLoopSound(2);
	wait(2.5);
	level.klaxon_struct Delete();
	level.bell_struct Delete();
}

stop_merchant_ship_coll()
{
	level.coll_struct StopLoopSound(2);
	wait(2.5);
	level.coll_struct Delete();
}

//-- Edit by glocke::2/15
start_plane_landed_sound()
{
	playsoundatposition("plane_land", self.origin);
	
	//level waittill("audio_plane_landing");
	//wait(8);
	//playsoundatposition("plane_land", (21928, 42504, -32));
}

//-- START JUST THE PLANE PROP SOUNDS
start_plane_prop_sounds()
{

		
		self.audio_node_propl = Spawn("script_model", self.origin);
		self.audio_node_propl SetModel("tag_origin");
		self.audio_node_propl LinkTo(self, "prop_left_jnt", (0,0,0), (0,0,0));

	//	self.audio_node_prop1 PlayLoopSound("pby_engines_streamed");

		//self.audio_node_propl PlayLoopSound("pby_propeller");
		self.audio_node_propl playsound("pby_propeller_left");


		self.audio_node_propr = Spawn("script_model", self.origin);
		self.audio_node_propr SetModel("tag_origin");
		self.audio_node_propr LinkTo(self, "prop_right_jnt", (0,0,0), (0,0,0));
		//self.audio_node_propr PlayLoopSound("pby_propeller");

		self.audio_node_propr playsound("pby_propeller_right");
		
		self.audio_node_propl_ramp = Spawn("script_origin", self.audio_node_propl.origin);
		self.audio_node_propl_ramp SetModel("tag_origin");
		self.audio_node_propl_ramp LinkTo(self, "prop_left_jnt", (0,0,0), (0,0,0)); 
		self.audio_node_propl_ramp playsound ("pby_engine_ramp_up", "sound_done");
		
		self.audio_node_propr_ramp = Spawn("script_origin", self.audio_node_propr.origin);
		self.audio_node_propr_ramp SetModel("tag_origin");
		self.audio_node_propr_ramp LinkTo(self, "prop_right_jnt", (0,0,0), (0,0,0)); 
		self.audio_node_propr_ramp playsound ("pby_engine_ramp_up", "sound_done");
		
		self.audio_node_propl waittill("sound_done");
		self.audio_node_propr_ramp delete();
		self.audio_node_propl_ramp delete();
}

//-- STOP THE PROP ENGINE SOUNDS
stop_plane_prop_sounds()
{
	self thread stop_prop_sound_with_ramp(true);
	self thread stop_prop_sound_with_ramp(false);
}

stop_prop_sound_with_ramp(right)
{
	if(!right)
	{
		if(IsDefined(self.audio_node_propl))
		{
			self.audio_node_propl_ramp = Spawn("script_origin", self.audio_node_propl.origin);
			self.audio_node_propl_ramp SetModel("tag_origin");
			self.audio_node_propl_ramp LinkTo(self, "prop_left_jnt", (0,0,0), (0,0,0)); 
			self.audio_node_propl_ramp playsound ("pby_engine_ramp_down", "sound_done");
			self.audio_node_propl stoploopsound(2);
			self.audio_node_propl waittill("sound_done");
			self.audio_node_propl delete();
			self.audio_node_propl_ramp delete();
		}
		return;
	}
	
	if(right)
	{
		if(IsDefined(self.audio_node_propr))
		{
			self.audio_node_propr_ramp = Spawn("script_origin", self.audio_node_propr.origin);
			self.audio_node_propr_ramp SetModel("tag_origin");
			self.audio_node_propr_ramp LinkTo(self, "prop_right_jnt", (0,0,0), (0,0,0)); 
			self.audio_node_propr_ramp playsound ("pby_engine_ramp_down_other", "sound_done");
			self.audio_node_propr stoploopsound(2);
			self.audio_node_propr waittill("sound_done");
			self.audio_node_propr delete();
			self.audio_node_propr_ramp delete();
		}
		return;
	}

}


//-- STOP THE WIND SOUNDS PLAYED ON ALL 4 BARRELS
stop_plane_wind_sounds()
{
	if(IsDefined(self.audio_node_nose))
	{
		self.audio_node_nose stoploopsound();	
		self.audio_node_nose delete();
	}
	if(IsDefined(self.audio_node_left))
	{
		self.audio_node_left stoploopsound();	
		self.audio_node_left delete();
	}
	if(IsDefined(self.audio_node_right))
	{
		self.audio_node_right stoploopsound();	
		self.audio_node_right delete();
	}
	if(IsDefined(self.audio_node_ventral))
	{
		self.audio_node_ventral stoploopsound();	
		self.audio_node_ventral delete();
	}
}

setup_plane_sounds(player)
{
	if(!player)
	{
		//-- 3D sounds for ambient plane
		maps\_utility::ok_to_spawn(5.0);
		self.audio_node_nose3p = Spawn("script_model", self.origin);
		self.audio_node_nose3p SetModel("tag_origin");
		self.audio_node_nose3p LinkTo(self, "tag_gunner_barrel1", (0,0,0), (0,0,0));
		self.audio_node_nose3p PlayLoopSound("pby_3p");
		
	}
	else if(player)
	{
		//-- Sounds for player's plane
		
		//Plane interior is from the Ambient System
		//Propellers are using the tags below
		//  "prop_left_jnt"
		//  "prop_right_jnt"
		
		maps\pby_fly::pby_ok_to_spawn();
		self.audio_node_propl = Spawn("script_model", self.origin);
		self.audio_node_propl SetModel("tag_origin");
		self.audio_node_propl LinkTo(self, "prop_left_jnt", (0,0,0), (0,0,0));
		self.audio_node_propl PlayLoopSound("pby_propeller");
		
		self.audio_node_propl playloopsound("pby_propeller_left");		


		maps\pby_fly::pby_ok_to_spawn();
		self.audio_node_propr = Spawn("script_model", self.origin);
		self.audio_node_propr SetModel("tag_origin");
		self.audio_node_propr LinkTo(self, "prop_right_jnt", (0,0,0), (0,0,0));
		//self.audio_node_propr PlayLoopSound("pby_propeller");
		
		self.audio_node_propr playloopsound("pby_propeller_right");
		
		//-- Wind Sound (glocke)
		//"tag_gunner_barrel1" -- Nose
		//"tag_gunner_barrel2" -- Left Blister	
		//"tag_gunner_barrel3" -- Right Blister
		//"tag_gunner_barrel4" -- Ventral
		
		maps\pby_fly::pby_ok_to_spawn();
		self.audio_node_nose = Spawn("script_model", self.origin);
		self.audio_node_nose SetModel("tag_origin");
		self.audio_node_nose LinkTo(self, "tag_gunner_barrel1", (0,0,0), (0,0,0));
		self.audio_node_nose PlayLoopSound("wind_mono");
		
		maps\pby_fly::pby_ok_to_spawn();
		self.audio_node_left = Spawn("script_model", self.origin);
		self.audio_node_left SetModel("tag_origin");
		self.audio_node_left LinkTo(self, "tag_gunner_barrel2", (0,0,0), (0,0,0));
		self.audio_node_left PlayLoopSound("wind_mono");
		
		maps\pby_fly::pby_ok_to_spawn();
		self.audio_node_right = Spawn("script_model", self.origin);
		self.audio_node_right SetModel("tag_origin");
		self.audio_node_right LinkTo(self, "tag_gunner_barrel3", (0,0,0), (0,0,0));
		self.audio_node_right PlayLoopSound("wind_mono");
		
		maps\pby_fly::pby_ok_to_spawn();
		self.audio_node_ventral = Spawn("script_model", self.origin);
		self.audio_node_ventral SetModel("tag_origin");
		self.audio_node_ventral LinkTo(self, "tag_gunner_barrel4", (0,0,0), (0,0,0));
		self.audio_node_ventral PlayLoopSound("wind_mono");
		
	}
}

//-- Plays the Zero's engine and preps the passby sound
play_zero_sounds(target, target_b)
{
	self endon("death");

	wait(0.1);
	
	plane_dist_a = 0;
	plane_dist_b = 0;
	
	//--TODO: make this actually random
	rand_num = RandomInt(level.zeroflyby.size);
	random_sound = level.zeroflyby[rand_num];
	distance_to_play_sound = mph_to_ups( self GetSpeedMPH(), random_sound["length"] );


	while(distancesquared(self.origin, target.origin) > distance_to_play_sound * distance_to_play_sound)
	{
		wait( 0.1 );
	}
	
	self playsound(random_sound["sound"]);
	//self thread play_plane_passby(random_sound);
	
}

mph_to_ups(mph, seconds_before_plane_overhead)
{
	miles = mph;
	units = miles * 63360;
	seconds_per_hour = 3600;
	ups = units / seconds_per_hour;
	//seconds_before_plane_overhead = 6;
	distance_to_play_sound = ups * seconds_before_plane_overhead;
	
	return(distance_to_play_sound);
}

play_plane_passby( my_sound )
{
	//play random passby sound
	//self.audio_node_propzero playsound(sound_ids[RandomInt(sound_ids.size)]);
}		


destroyer1_alarm()
{

	level.destroyer1_alarm = GetEnt("destroyer1", "targetname");
	level.destroyer1_alarm playloopsound("fleet_alarm1");
	
}
	
	
destroyer2_alarm()
{

	level.destroyer2_alarm = GetEnt("destroyer2", "targetname");
	level.destroyer2_alarm playloopsound("fleet_alarm2");
	org = spawn("script_origin", level.destroyer2_alarm.origin);
	org playloopsound("fires_and_screams");

	
}
destroyer3_alarm()
{

	level.destroyer3_alarm = GetEnt("sinking_ship", "targetname");
	level.destroyer3_alarm playloopsound("fleet_gq");
	
}
play_zeros_track()
{
	players = get_players();

	for( i = 0; i < players.size; i++ )
	{
		players[i] playloopsound("zero_track_loop");
		level waittill("LANDING");
		players[i] stoploopsound(3);
	}
	 

}