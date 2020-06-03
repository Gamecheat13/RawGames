// Ambients Level File
#include maps\_utility;
#include common_scripts\utility;
#include maps\_ambientpackage;
#include maps\_music;

main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	//***************
	//See1_Outdoors
	//*************** 

		declareAmbientPackage( "see1_outdoors_pkg" );
			
			//addAmbientElement( "see1_outdoors_pkg", "amb_stone_small", 10, 20, 100, 500);
			addAmbientElement( "see1_outdoors_pkg", "wind_gust_3d", 5, 20, 80,100);
			addAmbientElement( "see1_outdoors_pkg", "bomb_far", 2, 15, 10, 200 );

	//***************
	//See1_Trench_Interrior
	//*************** 

		declareAmbientPackage( "see1_trench_pkg" );
		
			//addAmbientElement( "see1_trench_pkg", "amb_stone_small", 10, 20, 100, 200);
			addAmbientElement( "see1_trench_pkg", "bomb_far", 2, 15, 10, 200 );
			addAmbientElement( "see1_trench_pkg", "bomb_medium", 15, 30, 100, 500 );
	
		declareAmbientPackage( "see1_tunnel_pkg" );
	
			addAmbientElement( "see1_tunnel_pkg", "amb_wood_small", 10, 20, 100, 200);
			addAmbientElement( "see1_tunnel_pkg", "amb_wood_boards", 20, 40, 100, 500);
			addAmbientElement( "see1_tunnel_pkg", "amb_wood_creak", 20, 40, 100, 500);
			addAmbientElement( "see1_tunnel_pkg", "bomb_far", 2, 15, 10, 200 );
			addAmbientElement( "see1_tunnel_pkg", "bomb_medium", 15, 30, 100, 500 );
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	
	
	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	//***************
	//See1_Outdoors
	//*************** 

		declareAmbientRoom( "see1_outdoors_room" );
	
			setAmbientRoomTone( "see1_outdoors_room", "outdoor_wind" );
			setAmbientRoomReverb( "see1_outdoors_room", "Ber1",  1, 1 );
	//***************
	//See1_Trench_Interrior
	//*************** 

		declareAmbientRoom( "see1_trench_room" );
	
			setAmbientRoomTone( "see1_trench_room", "trench_wind" );
			
	//***************
	//See1_Subway
	//***************

		declareAmbientRoom( "small_tunnel" );
	
			setAmbientRoomTone( "small_tunnel", "bgt_small_tunnel" );
	
		declareAmbientRoom( "large_tunnel" );
			
			setAmbientRoomTone( "large_tunnel", "bgt_large_tunnel" );

	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************
		activateAmbientPackage( "see1_outdoors_pkg", 0 );
		activateAmbientRoom( "see1_outdoors_room", 0 );
		
	//************************************************************************************************
	//                                      START SCRIPTS
	//************************************************************************************************

		
		level thread start_chant();
		level thread klaxxon_audio_notify();
		level thread walla_audio_notify();
		//level thread pa_audio_notify();
		//level thread pa_explode_notify();
		//level thread pa_guy_shot_notify();
		//level thread pa_takeover_notify();
	//	level thread event_1_music();
		//setmusicstate("INTRO");
	

}


	//************************************************************************************************
	//                                      OTHER AUDIO FUNCTIONS
	//************************************************************************************************

klaxxon_audio_notify()
{
	level waittill("klaxxon_start");
	klaxxon = getent("klaxxon","targetname");
	
	klaxxon playloopsound("klaxxon");
	
	level waittill("tower01_force_blow_up");
	
	klaxxon stoploopsound();

}
pa_audio_notify()
{
	level waittill("pa_start");

	pa_speaker = getent("pa_speaker","targetname");
	feedback3 = getent("feedback3","targetname");
	
	pa_speaker playloopsound("pa_speaker");
	wait(.1);
	feedback3 playloopsound("pa_speaker");
}
pa_explode_notify()
{	
	level endon( "both_halftracks_eliminated" );
	level waittill("tower2_blows_up");
	pa_speaker = getent("pa_speaker","targetname");
	feedback1 = getent("feedback1","targetname");
	feedback2 = getent("feedback2","targetname");
	feedback3 = getent("feedback3","targetname");
	
	feedback3 stoploopsound();
	pa_speaker stoploopsound();
	
	feedback1 playsound("feedback1");
	feedback2 playsound("feedback2");
	feedback3 playsound("feedback3");

}
pa_guy_shot_notify()
{
	//level waittill("guy_shot");
	level endon( "both_halftracks_eliminated" );
	level waittill("tower2_blows_up");

	pa_speaker = getent("pa_speaker","targetname");
	
	feedback1 = getent("feedback1","targetname");
	//feedback2 = getent("feedback2","targetname");
	feedback3 = getent("feedback3","targetname");
	
	pa_speaker stoploopsound(.5);
	feedback3 stoploopsound();
	
	feedback1 playsound("feedback1");
	//feedback2 playsound("feedback2");
	//feedback3 playsound("feedback3");

}
pa_takeover_notify()
{
	level waittill("both_halftracks_eliminated");

	pa_speaker = getent("pa_speaker","targetname");
	pa_speaker2 = getent("pa_speaker2","targetname");
	echo = getent("klaxxon","targetname");
	
	feedback1 = getent("feedback1","targetname");
	feedback2 = getent("feedback2","targetname");
	feedback3 = getent("feedback3","targetname");
	battle_cry2 = getent("battle_cry2","targetname");
	
	pa_speaker stoploopsound(.5);
	feedback3 stoploopsound();
	wait(2);
	
	feedback1 playsound("feedback1");
	feedback2 playsound("feedback2");
	feedback3 playsound("feedback3");
	wait(1);
	
	pa_speaker2 playsound("See1_IGD_200A_REZN2");
	wait(.2);
	feedback1 playsound("See1_IGD_200A_REZN");
	wait(27);
	feedback3 playsound("See1_IGD_700A_RURS");
	battle_cry2 playsound("See1_IGD_701A_RURS");
	

}
start_chant()
{
	level waittill("start_chant");
	wait(40);
	chant = getent("chant","targetname");
	charge1 = getent("charge1","targetname");
	charge2 = getent("charge2","targetname");
	
	chant playsound("See1_IGD_702A_RURS");
	//playsoundatposition("See1_IGD_702A_RURS",chant.origin);
	
	wait(13);
	
	charge1 playsound("See1_IGD_700A_RURS");
	charge2 playsound("See1_IGD_701A_RURS");
	
	//playsoundatposition("See1_IGD_700A_RURS",charge1.origin);
	//playsoundatposition("See1_IGD_701A_RURS",charge2.origin);
	

}
walla_audio_notify()
{
	
	regroup_trigger = getent( "final_regroup", "targetname" );
	regroup_trigger waittill( "trigger" );
	//level waittill("walla");
	//walla1 = getent("walla1","targetname");
	walla1 = Spawn( "script_origin", (-4904, 14680, 8) ); 
	//walla2 = getent("walla2","targetname");
	walla2 = Spawn( "script_origin", (-4440, 15240, 8) );
	
	walla1 playloopsound("See1_IGD_703A_RURS",2);
	wait(5);
	walla2 playloopsound("See1_IGD_703A_RURS",2);
	
	level waittill("reznov_on_tank");
	
	wait(10);
	walla1 playsound("See1_IGD_700A_RURS");
	walla2 playsound("See1_IGD_701A_RURS");
	
	walla1 stoploopsound(4);
	walla2 stoploopsound(4);

}
event_1_music()
{
	//level waittill("intro_release_player");
	//wait(5);
	setmusicstate("FIELDS_OF_FIRE");

}



//********************************************************************************************************
//********************************************************************************************************

event1()
{
	// mortars
	level thread event1_mortars();

	setmusicstate("FIELDS_OF_FIRE");
	
	// fake fire from train
	event1_fakefire();
	
	//fog
	// near plane, half plane, half hight, base height, r, g, b, time
	if( IsSplitScreen() )
	{
		cull_dist 		= 7000;
		set_splitscreen_fog( 250, 3100, 256, -300, 0.554688, 0.507813, 0.546875, 1, cull_dist );
	}
	else
	{
		setVolFog( 250, 3100, 256, -300, 0.554688, 0.507813, 0.546875, 1 );
	}
	//setExpFog( 250, 3073, 0.554688, 0.507813, 0.546875, 1 );
		
	// temp
	level thread battle_field_effects();
}

// temp FX on the battlefield, such as smoke and fire, using script structs (in see1_fx_placement.map) as markers
// Remove them after a full FX pass
battle_field_effects()
{
/*
	// light battle smoke
	battle_smoke_pos = getstructarray( "battle_smoke", "targetname" );
	for( i = 0; i < battle_smoke_pos.size; i++ )
	{
		playfx( level._effect["battle_smoke_light"], battle_smoke_pos[i].origin );
		wait( 0.01 ); // game doesn't seem to like playing too many fx on the same frame
	}
	
	// heavy battle smoke
	battle_smoke_heavy_pos = getstructarray( "battle_smoke_heavy", "targetname" );
	for( i = 0; i < battle_smoke_heavy_pos.size; i++ )
	{
		playfx( level._effect["battle_smoke_heavy"], battle_smoke_heavy_pos[i].origin );
		wait( 0.01 );
	}

	// fire engulfing trunk of a dead tree
	trunk_fire_pos = getstructarray( "fire_trunk", "targetname" );
	for( i = 0; i < trunk_fire_pos.size; i++ )
	{
		playfx( level._effect["tree_trunk_fire"], trunk_fire_pos[i].origin );
		wait( 0.01 );
	}
	
	// fire covering a brush
	brush_fire_pos = getstructarray( "brush_fire", "targetname" );
	for( i = 0; i < brush_fire_pos.size; i++ )
	{
		playfx( level._effect["tree_brush_fire"], brush_fire_pos[i].origin );
		wait( 0.01 );
	}
	*/
}
	
event1_mortars()
{
	// don't start till the initial charge starts
	level waittill( "charge_starts" );

	setmusicstate("FIELDS_OF_FIRE");	
	
// initial mortar (light)
	maps\_mortar::set_mortar_delays( "dirt_small", 0.5, 3, 0.1, 0.5 );
	maps\_mortar::set_mortar_range( "dirt_small", 300, 4000 );
	level thread maps\_mortar::mortar_loop( "dirt_small", 1 );
	
	maps\_mortar::set_mortar_delays( "dirt_medium", 2, 6, 0.1, 0.5 );
	maps\_mortar::set_mortar_range( "dirt_medium", 300, 1000 );
	level thread maps\_mortar::mortar_loop( "dirt_medium", 1 );

	maps\_mortar::set_mortar_delays( "mud_small", 0.5, 3, 0.1, 0.5 );
	maps\_mortar::set_mortar_range( "mud_small", 300, 4000 );
	level thread maps\_mortar::mortar_loop( "mud_small", 1 );
	
	maps\_mortar::set_mortar_delays( "mud_far", 1, 2, 2, 3 );
	maps\_mortar::set_mortar_range( "mud_far", 300, 4000 );
	level thread maps\_mortar::mortar_loop( "mud_far", 1 );
	
	maps\_mortar::set_mortar_delays( "mud_medium", 4, 6, 2, 3 );
	maps\_mortar::set_mortar_range( "mud_medium", 300, 1000 );
	level thread maps\_mortar::mortar_loop( "mud_medium", 1 );
}

event1_fakefire()
{		
	firepoints = getstructarray( "prerocket_muzzleflashes","script_noteworthy" );
	
	level thread event1_fakefire_think( firepoints );
	level thread event1_fakefire_think( firepoints );
	level thread event1_fakefire_think( firepoints );
	level thread event1_fakefire_think( firepoints );
	level thread event1_fakefire_think( firepoints );
	level thread event1_fakefire_think( firepoints );
	level thread event1_fakefire_think( firepoints );
}

event1_fakefire_think( firepoints )
{
	level endon( "stop_event1_fakefire" );
	
	while( 1 )
	{
		// if is already firing find another one
		firepoint = firepoints[randomint(firepoints.size)];
		if( isdefined( firepoint.is_firing ) && firepoint.is_firing == true )
		{
			continue;
		}

		// were good to go
		firepoint.is_firing = true;

		
		// burst fire
		clipsize = randomintrange( 2, 7 );
		for( i = 0; i < clipsize; i++ )
		{
			// play fx with tracers
			playfx( level._effect["distant_muzzleflash"], firepoint.origin, anglestoforward( firepoint.angles ), anglestoup( firepoint.angles ) );
			
			// to reduce the pop-corn like sound if we do it all the time
			rand = randomint( 3 );
			if( !rand )
			{
				thread play_sound_in_space( "weap_mp40_fire", firepoint.origin );
			}
			
			bullettracer( firepoint.origin, firepoint.origin - ( randomintrange( 1, 100 ), 4000 + randomintrange( 1, 500 ), randomintrange( 1,40 ) ), false );
			wait( randomfloatrange( 0.1, 0.2 ) );
			
		}
		
		wait( 2 );
		
		// can be accessed again
		firepoint.is_firing = false;
		
		// to appease the while loop
		//wait (0.05);
	}
}


// for later
event1_katyusha_rocket_barrage( truck_name, trigger_name )
{
	truck = getent( truck_name, "targetname" );
	
	trigger = getent( trigger_name, "targetname" );
	trigger waittill( "trigger" );
	
	attack_range = ( 0, 10000, 0 ); 
	
	start_points = [];
	dest_points = [];
	
	// temp starting and ending points
	// presume 8 rockets side by side 10 units apart (all rockets point north)
	rocket_num = 8;
	rocket_separation = 10;
	rocket_center_point = truck.origin + ( 0, -50, 100 );
	rocket_left_most_point = rocket_center_point - ( rocket_num * rocket_separation * 0.5, 0, 0 );
	
	for( i = 0; i < rocket_num; i++ )
	{
		start_points[i] = rocket_left_most_point + ( i * rocket_separation, 0, 0 );
		dest_points[i]  = start_points[i] + attack_range;
	}
	
	for( i = 0; i < start_points.size; i++ )
	{
		rocket = spawn( "script_model", start_points[i]) ;
		rocket setmodel( "weapon_ger_panzershreck_rocket" );
		rocket.angles = ( 320, 90, 0 );
		playfxontag( level._effect[ "rocket_trail" ], rocket, "tag_origin" );
			
		// sound of rocket flying through the air
		rocket playsound("rocket_run");			
			
		rocket thread event1_katyusha_rocket_fly_think( dest_points[i] + ( randomint( 50 ), randomint( 50 ), randomint( 50 ) ) );
		wait( 0.7 );
	}
}


event1_katyusha_rocket_barrage_side( struct_name, trigger_name )
{
	trucks = getstructarray( struct_name, "targetname" );
	trigger = getent( trigger_name, "targetname" );
	
	for( i = 0; i < trucks.size; i++ )
	{
		event1_katyusha_rocket_barrage_side_single( trucks[i], trigger );
	}
}

event1_katyusha_rocket_barrage_side_single( start_struct, trigger )
{
	level endon( "event1_ends" );
	
	trigger waittill( "trigger" );
	
	attack_range = ( 0, 10000, 0 ); 
	
	start_points = [];
	dest_points = [];
	
	// temp starting and ending points
	// presume 8 rockets side by side 10 units apart (all rockets point north)
	rocket_num = 8;
	rocket_separation = 10;
	rocket_center_point = start_struct.origin + ( 0, -50, 100 );
	rocket_left_most_point = rocket_center_point - ( rocket_num * rocket_separation * 0.5, 0, 0 );
	
	for( i = 0; i < rocket_num; i++ )
	{
		start_points[i] = rocket_left_most_point + ( i * rocket_separation, 0, 0 );
		dest_points[i]  = start_points[i] + attack_range;
	}
	
	while( 1 )
	{
		wait( randomint( 2 ) );
		
		for( i = 0; i < start_points.size; i++ )
		{
			rocket = spawn( "script_model", start_points[i]) ;
			rocket setmodel( "weapon_ger_panzershreck_rocket" );
			rocket.angles = ( 320, 90, 0 );
			playfxontag( level._effect[ "rocket_trail" ], rocket, "tag_origin" );
				
			// sound of rocket flying through the air
			rocket playsound("rocket_run");			
				
			rocket thread event1_katyusha_rocket_fly_think( dest_points[i] + ( randomint( 50 ), randomint( 50 ), randomint( 50 ) ) );
			wait( 0.7 );
		}
		
		wait( randomint( 3 ) + 3 );
	}
}


// and the rockets' red glaaaaaare
event1_katyusha_rocket_fly_think( destination_pos )
{ 
	//thread throw_object_with_gravity( self, destination_pos );
	
	playfx( level._effect["lci_rocket_launch"], self.origin, anglestoforward( ( 320, 90, 0 ) ), anglestoup( ( 320, 90, 0 ) ) );
	
	while( 1 )
	{
		if( self.origin[2] < -500 )
		{
			if( self.origin[1] > 8000)
			{
				playfx( level._effect["lci_rocket_impact"], self.origin );	
				// lci rocket impact sound
				thread play_sound_in_space( "rocket_dirt", self.origin );
			}
			//earthquake( 0.5, 3, self.origin, 2050 );	
			//self thread event1_rocket_impact_think();
			break;
		}
		wait (0.05);
	}
	level notify( "do aftermath" );
		
	// to get shit deleting again
	wait (2);
	self delete();	
}






event2()
{
}

event3()
{
	level thread event3_flak_flashes();

}

event3_flak_flashes()
{
	targets = getstructarray( "ev3_flash", "targetname" );
	
	for( i = 0; i < targets.size; i++ )
	{
		level thread event3_flak_flash_single( targets[i].origin );
	}
}

event3_flak_flash_single( position )
{
	while( 1 )
	{
		wait( randomfloat( 4 ) + 3 );
		playfx( level._effect["flak_flash"], position );
	}
}

/*
event1_large_explosions( min_range, max_delay, min_delay )
{
	level endon( "event1_ends" );
	
	targets = maps\_utility::getstructarray( "fx_ev1_explosion_1", "targetname" );
	players = maps\_utility::get_players();
	
	while( 1 )
	{
		// periodically set off an explosion near a player, followed by one further away
		delay_time = randomfloat( max_delay - min_delay ) + min_delay;
		wait( delay_time );
		
		valid_target = false;
		index = 0;
		while( valid_target == false )
		{
			index = randomint( targets.size );
		
			// make sure the explosion is not next to any players
			players_okayed = 0;
			for( i = 0; i < players.size; i++ )
			{
				if( distance( targets[index].origin, players[i].origin ) > min_range )
				{
					players_okayed++;
				}
			}
			if( players_okayed == players.size )
			{
				valid_target = true;
			}
		}
		
		// now blow it up
		radiusdamage( targets[index].origin, 200, 1000, 100 );
		fx = playfx( level.fx_large_explosion, targets[index].origin );
	}	
}

event1_small_explosions( max_delay, min_delay )
{
	level endon( "event1_ends" );
	
	targets = maps\_utility::getstructarray( "fx_ev1_explosion_sm", "targetname" );

	while( 1 )
	{
		// periodically set off an explosion near a player, followed by one further away
		delay_time = randomfloat( max_delay - min_delay ) + min_delay;
		wait( delay_time );
		index = randomint( targets.size );
		radiusdamage( targets[index].origin, 200, 1000, 100 );
		fx = playfx( level.fx_small_explosion, targets[index].origin );
	}	
}

event1_player_view_explosions()
{
	// periodically set off an explosion in front of the player
	// end this just as player reaches mg, and the tracers go off
	level endon( "event1_mg_tracer_ends" );
	
	players = maps\_utility::get_players();
	
	while( 1 )
	{
		wait( randomint( 5 ) + 10 );
		
		index = randomint( players.size );
		
		forward_vec = anglestoforward( players[index].angles );
		destination_pos = players[index].origin + forward_vec * 200 + ( 0, -15, 0 );
		
		radiusdamage( destination_pos, 250, 100, 10 );
		
		explosion = randomint( 10 );
		if( explosion % 2 == 0 )
		{
			fx = playfx( level.fx_large_explosion, destination_pos );
		}
		else
		{
			fx = playfx( level.fx_small_explosion, destination_pos );
		}
	}
}


event1_mg_tracer( stop_trigger_name )
{
	starts = maps\_utility::getstructarray( "ev1_mg_start", "targetname" );
	ends = maps\_utility::getstructarray( "ev1_mg_target", "targetname" );
	
	for( i = 0; i < starts.size; i++ )
	{
		thread event1_tracer_burst( starts[i], ends );
		thread event1_tracer_burst( starts[i], ends );
		thread event1_tracer_burst( starts[i], ends );
		thread event1_tracer_burst( starts[i], ends );
	}
	
	stop_trigger = getent( stop_trigger_name, "targetname" );
	stop_trigger waittill( "trigger" );
	level notify( "event1_mg_tracer_ends" );
}

event1_tracer_burst( start, targets )
{
	level endon( "event1_mg_tracer_ends" );
	
	while( 1 )
	{
		// find a random target
		index = randomint( targets.size );
		x_off = randomint( 250 ) - 125; // offset x by +/- 125 units
		target_pos = targets[index].origin + ( x_off, -30, 0 );
		start_pos = start.origin;
		
		// burst 
		burst_num = randomint( 7 ) + 10;
		for( i = 0; i < burst_num; i++ )
		{
			bullettracer( start_pos, target_pos );
			wait( 0.2 );
		}
		
		wait( randomint( 1 ) + 1 );
	}
}

event1_planes()
{
	level thread plane_flyby_special( "ev1_plane1_trigger", "ev1_plane_sp1", "ev1_plane_sp1_end" );
	
	level thread plane_flyby( "ev1_plane_l1", "ev1_plane_l1_end" );
	level thread plane_flyby( "ev1_plane_l2", "ev1_plane_l2_end" );
	level thread plane_flyby( "ev1_plane_l3", "ev1_plane_l3_end" );
	level thread plane_flyby( "ev1_plane_m1", "ev1_plane_m1_end" );
	level thread plane_flyby( "ev1_plane_m2", "ev1_plane_m2_end" );
	level thread plane_flyby( "ev1_plane_m3", "ev1_plane_m3_end" );
	level thread plane_flyby( "ev1_plane_r1", "ev1_plane_r1_end" );
	level thread plane_flyby( "ev1_plane_r2", "ev1_plane_r2_end" );
}

plane_flyby( starting_node_name, ending_node_name )
{
	//level endon( "event1_ends" );
	
	start = getvehiclenode( starting_node_name, "targetname" );
	end = getvehiclenode( ending_node_name, "targetname" );
	
	while( 1 )
	{
		wait( randomfloat( 5 ) + 2 );
		
		plane = spawnvehicle( "vehicle_stuka_flying", "plane1", "stuka", start.origin, start.angles );
		plane attachPath( start );
		plane startpath();
		
		//end waittill( "trigger" );
		wait( 8 );
		plane delete();
	}
}

plane_flyby_special( trigger_name, starting_node_name, ending_node_name )
{
	level endon( "event1_ends" );
		
	trigger = getent( trigger_name, "targetname" );
	start = getvehiclenode( starting_node_name, "targetname" );
	end = getvehiclenode( ending_node_name, "targetname" );
	
	trigger waittill( "trigger" );
		
	plane = spawnvehicle( "vehicle_stuka_flying", "plane1", "stuka", start.origin, start.angles );
	plane attachPath( start );
	plane startpath();
		
	//end waittill( "trigger" );
	wait( 6 );
	plane delete();
}
*/
