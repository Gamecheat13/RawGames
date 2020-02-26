#include maps\_anim;
#include maps\_utility;
#include maps\ber1_util;
#include maps\pel2_util;
#include common_scripts\utility;
#include maps\_music;
#include maps\_busing;

#using_animtree("generic_human");

main()
{
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 10 );
	
	wait( 0.05 );
	
	level thread tank_1_outro();
	level thread tank_2_outro();
	level thread tank_3_outro();
	level thread turn_off_tank_hud();
	
	level thread tankride_achievement();
	
	tank_riders_ignored();	
	
	outro_push();
	
}



///////////////////
//
// so the tank's 2d hudelem isn't shown when using the t34 mounted mg
//
///////////////////////////////

turn_off_tank_hud()
{

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] SetClientDvar( "vehInfoHide", "1" );
	}
	
}



///////////////////
//
// achievement awarded for killing 15 guys while on tank mg
//
///////////////////////////////

tankride_achievement()
{
	tankride_spawners = getspawnerarray();
	
	if(numremoteclients())
	{
		trigs = getentarray("axis_drone", "targetname");
		
		for(i = 0; i < trigs.size; i++)
		{
			trigs[i].script_drones_min = int(trigs[i].script_drones_min / 2);
			trigs[i].script_drones_max = int(trigs[i].script_drones_max / 2);
			trigs[i].script_delay = trigs[i].script_delay * 1.2;
		}
	}
	
	for( i  = 0; i < tankride_spawners.size; i++ )
	{
		
		if( isdefined( tankride_spawners[i].targetname ) && issubstr( tankride_spawners[i].targetname, "outro_retreaters_" ) )
		{
			tankride_spawners[i] add_spawn_function( ::tankride_deathwatch );
		}
		
	}
	
	level.drone_spawnFunction["axis"] = ::tankride_drone_spawnfunction;
	
}



tankride_drone_spawnfunction()
{

	self character\char_ger_wrmcht_k98::main();
//	self thread tankride_achievement_drone_deathwatch();
	self thread tankride_deathwatch();
}



tankride_achievement_drone_deathwatch()
{

	self waittill( "death" );
	
}



///////////////////
//
// keeps track of ai killed while player is using tank mg
//
///////////////////////////////

tankride_deathwatch()
{
	
	self waittill( "death", attacker );

	// check if the guy that killed this ai is a player
	if( isplayer( attacker ) )
	{
		
		tank_1 = getent( "street_tank_1", "targetname" );
		tank_2 = getent( "street_tank_2", "targetname" );
		
		// check if he was using the tank mg
		
		tank_occupants_1 = tank_1 getvehoccupants();
		tank_occupants_2 = tank_2 getvehoccupants();
		
		if( is_in_array( tank_occupants_1, attacker ) || is_in_array( tank_occupants_2, attacker ) )
		{
			
			if( !isdefined( attacker.ber1_achieve_kills ) )
			{
				attacker.ber1_achieve_kills = 1;
			}
			else
			{
				attacker.ber1_achieve_kills++;
			}
			
			if( attacker.ber1_achieve_kills == 15 )
			{
				attacker giveachievement_wrapper( "BER1_ACHIEVEMENT_KILL15" ); 
			}
			
		}
		
	}
	
}



///////////////////
//
// handles the general action for this event: russians advance up the street to push the germans back
//
///////////////////////////////

outro_push()
{

	flag_wait( "asylum_exit" );

	maps\_debug::set_event_printname( "Tankride" );

	autosave_by_name( "Ber1 tankride" );

	level thread tankride_vo();

	allies = getaiarray( "allies" );
	for( i  = 0; i < allies.size; i++ )
	{
		if( isdefined( allies[i].script_aigroup ) && ( allies[i].script_aigroup == "tank1_riders" || allies[i].script_aigroup == "tank2_riders" ) )
		{
			continue;	
		}
		
		if( i < 5 )
		{
			allies[i] set_force_color( "r" );
		}
		else
		{
			allies[i] set_force_color( "p" );
		}
		
	}
	
	if(NumRemoteClients())	// Kill friendly AI for bandwidth reasons.
	{
		allies = getaiarray( "allies" );
		
		for(i = 0; i < allies.size; i ++)
		{
			if(isdefined(allies[i].script_aigroup) && (allies[i].script_aigroup == "tank1_riders" || allies[i].script_aigroup == "tank2_riders"))
			{
				continue;
			}
			
			if(!is_in_array( level.heroes, allies[i] ))
			{
				allies[i] disable_replace_on_death();  
				allies[i] thread bloody_death( true, 5 + RandomFloat(15) );	// Poor red Squad, they never stood a chance in coop.
			}
		}		
	}
	
	set_color_chain( "chain_ride_start" );

	simple_spawn( "outro_retreaters_1" );
	
	if(!NumRemoteClients())
	{
		level thread ambient_planes();
	}
	level thread chain_outro_1();
	level thread objective_pos_update();
	level thread outro_retreaters_2_extra();
	level thread outro_retreaters_3_extra();
	level thread outro_retreaters_4_extra();
	level thread outro_retreaters_5_extra();
	level thread outro_retreaters_6_extra();
	level thread save_mid_tankride();
	level thread kill_glasshouse_ai();
	
	//TUEY Set Music State to FINAL PUSH
	setmusicstate("FINAL_PUSH");
	
}



kill_glasshouse_ai()
{

	trigger_wait( "trig_kill_glasshouse_ai", "script_noteworthy" );
	
	guys_to_kill = get_ai_group_ai( "outro_above_glasshouse_ai" );
	
	for( i  = 0; i < guys_to_kill.size; i++ )
	{
		guys_to_kill[i] thread bloody_death( true, 3 );
	}
	
}



///////////////////
//
// have t34 riders be ignored so they aren't killed before they can hop off
//
///////////////////////////////

tank_riders_ignored()
{

	riders = get_ai_group_ai( "tank1_riders" );
	
	for( i  = 0; i < riders.size; i++ )
	{
		riders[i].ignoreme = true;
		if( riders[i].script_startingposition == 4 )
		{
			riders[i].delay = randomfloatrange( 0.75, 1.25 );	
		}
	}
	
	riders = get_ai_group_ai( "tank2_riders" );
	
	for( i  = 0; i < riders.size; i++ )
	{
		riders[i].ignoreme = true;
		if( riders[i].script_startingposition == 4 )
		{
			riders[i].delay = randomfloatrange( 0.75, 1.25 );	
		}
	}	
	
}



tankride_vo()
{

	play_vo( level.reznov, "vo", "tanks_now_advancing" );
	
	//TUEY Custom Busing
	setbusstate("STREET");
	
	trigger_wait( "auto4299", "target" );

	//TUEY Custom Busing
	setbusstate("LEVEL_END");

	play_vo( level.commissar, "vo", "spread_the_word" );
	
	wait( 3 );
	
	play_vo( level.commissar, "vo", "citizens_of_berlin" );
	
	wait( 6.25 );
	
	play_vo( level.commissar, "vo", "we_will_crush" );
	
	wait( 5.9 );
	
	play_vo( level.commissar, "vo", "abandon_posts" );
	
	wait( 2.3 );
	
	play_vo( level.commissar, "vo", "abandon_homes" );	
	
	wait( 2.1 );
	
	play_vo( level.commissar, "vo", "abandon_hope" );	

	level thread end_of_level();

	wait( 1.25 );
	
	play_vo( level.commissar, "vo", "ura_1" );	

	wait( 2.25 );

	play_vo( level.commissar, "vo", "ura_2" );	

}



///////////////////
//
// russian fighters that are bombing the city
//
///////////////////////////////

ambient_planes()
{

	count = 0;

	while( !flag( "outro_tanks_fire_4" ) && count < 4 )
	{
		
		planes = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 500 );
		wait_network_frame();
		planes = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 501 );
		planes[0] playsound( "fly_by3" );
		
		count++;
		
		wait( RandomIntRange( 13, 16 ) );	
		
	}
	
	
	flag_wait( "outro_tanks_fire_4" );
	
	for( i  = 0; i < 10; i++ )
	{
	
		planes = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 502 );
		wait_network_frame();
		planes = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 503 );
		planes[0] playsound( "fly_by4" );
		
		wait( RandomIntRange( 13, 16 ) );	
		
	}
	
	
}



outro_retreaters_2_extra()
{

	trigger_wait( "trig_outro_retreaters_2", "targetname" );
	
	wait( RandomFloatRange( 2.65, 3.1 ) );
	
	simple_spawn( "outro_retreaters_2_extra", ::outro_retreaters_2_extra_strat );
	
}	
	
	
outro_retreaters_2_extra_strat()
{

	self endon( "death" );
	
	self.ignoreme = true;
	self setthreatbiasgroup( "outro_blue_targeters" );
	setthreatbias( "outro_blue_guys", "outro_blue_targeters", 200 );
	
	wait( RandomFloatRange( 2.0, 3.0 ) );
	
	self.ignoreme = false;
	
}	
	
	
outro_retreaters_3_extra()
{

	trigger_wait( "trig_outro_retreaters_3", "targetname" );
	
	wait( RandomFloatRange( 2.75, 4.0 ) );
	
	simple_spawn( "outro_retreaters_3_extra", ::end_rocket_strat );
	
}	


outro_retreaters_4_extra()
{

	trigger_wait( "trig_outro_retreaters_4", "targetname" );
	
	wait_network_frame();
	
	simple_spawn( "outro_retreaters_4_extra", ::end_rocket_strat );
	
	// Wii optimizations
	if( !level.wii )
	{
		simple_spawn( "outro_retreaters_4_extra_2" );
	}
	
}	



outro_retreaters_5_extra()
{

	trigger_wait( "trig_outro_retreaters_5", "targetname" );
	
	wait_network_frame();
	
	simple_spawn( "outro_retreaters_5_extra" );
	
}



outro_retreaters_6_extra()
{

	trigger_wait( "trig_outro_retreaters_6", "targetname" );
	
	wait_network_frame();
	
	simple_spawn( "outro_retreaters_6_extra" );
	
}	



end_rocket_strat()
{

	self setthreatbiasgroup( "panzershreck_threat" );
	// have rocket guys ignore players
	SetIgnoreMeGroup( "players", "panzershreck_threat" );
	
}
	


///////////////////
//
// trigger this chain manually if player hops on tank
//
///////////////////////////////

chain_outro_1()
{

	// notify from flag on trigger
	level endon( "outro_tank_move_1" );

	flag_wait( "player_mounted_on_tank" );
	
	chain_trig = getent( "outro_tank_move_1", "script_noteworthy" );
	if( isdefined( chain_trig ) )
	{
		chain_trig notify( "trigger" );	
	}
	
}



///////////////////
//
// russian tank 1 behavior
//
///////////////////////////////

tank_1_outro()
{

	tank = getent( "street_tank_1", "targetname" );

	tank makevehicleusable();

	tank maps\_vehicle::godon();

	tank thread unload_tank( "tank1_riders" );
	tank maps\_vehicle::mgoff();
	tank thread tank_1_shoot_strat();

	// some pathing to skip for the skipto
	if( !isdefined( level.startskip ) || ( isdefined( level.startskip ) && level.startskip != "tankride" ) )
	{
		
		tank veh_stop_at_node( "street_tank_1_wait_exit_0a" );
	
		flag_wait( "outro_tank_move_0a" );
		
		tank resumespeed( 5 );
		
		tank veh_stop_at_node( "street_tank_1_wait_exit_0b" );	
		
		flag_wait( "outro_tank_move_0b" );
	
		tank resumespeed( 5 );

	}


	tank veh_stop_at_node( "street_tank_1_wait_exit_1" );


	tank notify( "unload_tank_riders" );

	flag_wait_either( "outro_tank_move_1", "player_mounted_on_tank" );
	flag_wait( "outro_tank_riders_safe" );

	wait( 1.15 );
	
	tank resumespeed( 5 );

	tank veh_stop_at_node( "street_tank_1_wait_exit_2" );
	
	flag_wait( "outro_tank_move_2" );
	tank resumespeed( 5 );
	
	tank veh_stop_at_node( "street_tank_1_wait_exit_3" );

	flag_wait( "outro_tank_move_3" );
	tank resumespeed( 5 );

	tank veh_stop_at_node( "street_tank_1_wait_exit_4" );

	flag_wait( "outro_tank_move_4" );
	tank resumespeed( 5 );

	tank veh_stop_at_node( "street_tank_1_wait_exit_5" );

	flag_wait( "objective_end" );
	tank resumespeed( 5 );

}



///////////////////
//
// russian tank 2 behavior
//
///////////////////////////////

tank_2_outro()
{

	tank = getent( "street_tank_2", "targetname" );
	
	tank makevehicleusable();
	
	tank maps\_vehicle::godon();
	
	tank thread unload_tank( "tank2_riders" );
	tank maps\_vehicle::mgoff();
	tank thread tank_2_shoot_strat();
	
	// some pathing to skip for the skipto
	if( !isdefined( level.startskip ) || ( isdefined( level.startskip ) && level.startskip != "tankride" ) )
	{	
	
		tank veh_stop_at_node( "street_tank_2_wait_exit_0a" );
	
		flag_wait( "outro_tank_move_0a" );
		
		tank resumespeed( 5 );
		
		tank veh_stop_at_node( "street_tank_2_wait_exit_0b" );	
		
		flag_wait( "outro_tank_move_0b" );
	
		tank resumespeed( 5 );	
	
	}
	
	tank veh_stop_at_node( "street_tank_2_wait_exit_1" );

	wait( randomfloatrange( 0.7, 1.3 ) );

	tank notify( "unload_tank_riders" );

	flag_wait_either( "outro_tank_move_1", "player_mounted_on_tank" );
	flag_wait( "outro_tank_riders_safe" );
	wait( 1.85 );
	tank resumespeed( 5 );

	tank veh_stop_at_node( "street_tank_2_wait_exit_2" );
	
	remove_tank_blocker( "blocker_tankride_1" );
	
	flag_wait( "outro_tank_move_2" );
	tank resumespeed( 5 );
	
	tank veh_stop_at_node( "street_tank_2_wait_exit_3" );

	remove_tank_blocker( "blocker_tankride_2" );

	flag_wait( "outro_tank_move_3" );
	tank resumespeed( 5 );

	tank veh_stop_at_node( "street_tank_2_wait_exit_4" );

	flag_wait( "outro_tank_move_4" );
	tank resumespeed( 5 );

	tank veh_stop_at_node( "street_tank_2_wait_exit_5" );

	flag_wait( "objective_end" );
	tank resumespeed( 5 );

}



///////////////////
//
// tank that emerges right near end of level
//
///////////////////////////////

tank_3_outro()
{

	trigger_wait( "trig_last_street_tank", "targetname" );
	
	simple_spawn( "outro_retreaters_7" );
	wait_network_frame();
	simple_spawn( "outro_retreaters_7_extra" );
	
	level thread chain_road_to_reichstag();
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 504 );
	
	wait( 0.05 );
	
	tank = getent( "street_tank_3", "targetname" );

	tank maps\_vehicle::godon();	
	tank maps\_vehicle::mgoff();	

	tank thread tank_3_shoot_strat();
	
	level thread retreat_away_from_tank_3();
	
	tank veh_stop_at_node( "street_tank_3_wait_exit_1" );
	
	flag_wait( "objective_end" );
	tank resumespeed( 5 );	
	
}



remove_tank_blocker( blocker_name )
{

	blocker = getent( blocker_name, "targetname" );
	blocker connectpaths();	
	blocker delete();;
	
}



chain_road_to_reichstag()
{
	wait( 2 );
	set_color_chain( "chain_road_to_reichstag" );
}



///////////////////
//
// axis in volume retreat away from t34
//
///////////////////////////////

retreat_away_from_tank_3()
{

	wait( 3 );

	guys = getAIarrayTouchingVolume( "axis", "vol_end_retreat" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i].ignoresuppression = true;
		guys[i] thread retreat_away_from_tank_3_delay( RandomInt( 4 ) );
		
	}		
	
}



retreat_away_from_tank_3_delay( delay )
{
	
	self endon( "death" );
	
	wait( delay );
	
	self setgoalpos( (-2454, 9703, -397.4) );
}



///////////////////
//
// handle tank 1's main turret shooting behavior
//
///////////////////////////////

tank_1_shoot_strat()
{
	
	flag_wait_all( "outro_tanks_fire_1", "asylum_exit" );
	
	
	targets = getstructarray( "tank_1_outro_targets_1", "script_noteworthy" );
	
	while( !flag( "outro_tanks_fire_2" ) )
	{
		self tank_fire_at_struct( targets[randomint(targets.size)] );
		wait( RandomIntRange( 5, 6 ) );
	}
	
		
	shots_counter = 0;
	
	targets = getstructarray( "tank_1_outro_targets_2", "script_noteworthy" );
	
	while( !flag( "outro_tank_move_3" ) )
	{
		
		// shoot out glass windows
		if( shots_counter == 1 )
		{
			
			struct_targ = getstruct( "orig_glass_blowout", "targetname" );
			self SetTurretTargetVec( struct_targ.origin );
			self waittill_notify_or_timeout( "turret_on_target", 3 ); 
			wait ( 1 );
			self ClearTurretTarget(); 
			self fireweapon();		
			
			playfx( level._effect["large_glass_blowout"], struct_targ.origin, anglestoforward(struct_targ.angles ) );		
//			exploder( 504 );
			
			wait( RandomIntRange( 5, 6 ) );
			
			if( flag( "outro_tank_move_3" ) )
			{
				break;	
			}
			
		}
		
		self tank_fire_at_struct( targets[randomint(targets.size)] );
		shots_counter++;
		wait( RandomIntRange( 5, 6 ) );
	}		
	

	targets = getstructarray( "tank_1_outro_targets_3", "script_noteworthy" );
	
	while( !flag( "outro_tanks_fire_4" ) )
	{
		self tank_fire_at_struct( targets[randomint(targets.size)] );
		wait( RandomIntRange( 5, 6 ) );
	}	



	targets = getstructarray( "tank_1_outro_targets_4", "script_noteworthy" );
	
	while( !flag( "outro_tanks_fire_5" ) )
	{
		self tank_fire_at_struct( targets[randomint(targets.size)] );
		wait( RandomIntRange( 5, 6 ) );
	}



	targets = getstructarray( "tank_1_outro_targets_5", "script_noteworthy" );
	
	while( 1 )
	{
		self tank_fire_at_struct( targets[randomint(targets.size)] );
		wait( RandomIntRange( 5, 6 ) );
	}

	
}



///////////////////
//
// handle tank 2's main turret shooting behavior
//
///////////////////////////////

tank_2_shoot_strat()
{
	
	flag_wait( "outro_tanks_fire_1" );
	
	
	targets = getstructarray( "tank_2_outro_targets_1", "script_noteworthy" );
	
	while( !flag( "outro_tanks_fire_2" ) )
	{
		self tank_fire_at_struct( targets[randomint(targets.size)] );
		wait( RandomIntRange( 5, 7 ) );
	}
	
	
	targets = getstructarray( "tank_2_outro_targets_2", "script_noteworthy" );
	
	while( !flag( "outro_tank_move_3" ) )
	{
		self tank_fire_at_struct( targets[randomint(targets.size)] );
		wait( RandomIntRange( 5, 6 ) );
	}	
	
	
	targets = getstructarray( "tank_2_outro_targets_3", "script_noteworthy" );
	
	while( !flag( "outro_tanks_fire_4" ) )
	{
		self tank_fire_at_struct( targets[randomint(targets.size)] );
		wait( RandomIntRange( 5, 7 ) );
	}		
	
	
	targets = getstructarray( "tank_2_outro_targets_4", "script_noteworthy" );
	
	while( !flag( "outro_tanks_fire_5" ) )
	{
		self tank_fire_at_struct( targets[randomint(targets.size)] );
		wait( RandomIntRange( 5, 7 ) );
	}		
		
	
	targets = getstructarray( "tank_2_outro_targets_5", "script_noteworthy" );
	
	while( 1 )
	{
		self tank_fire_at_struct( targets[randomint(targets.size)] );
		wait( RandomIntRange( 5, 7 ) );
	}		
	
}



///////////////////
//
// handle tank 3's main turret shooting behavior
//
///////////////////////////////

tank_3_shoot_strat()
{
	
	wait( 2 );
	
	targets = getstructarray( "tank_3_outro_targets_1", "script_noteworthy" );
		
	self tank_fire_at_struct( targets[randomint(targets.size)] );
	wait( RandomIntRange( 5, 6 ) );	
	
	targets = getstructarray( "tank_3_outro_targets_2", "script_noteworthy" );
		
	while( 1 )
	{
		self tank_fire_at_struct( targets[randomint(targets.size)] );
		wait( RandomIntRange( 5, 7 ) );
	}	
	
}


///////////////////
//
// have ai riding tank hop off
//
///////////////////////////////

unload_tank( tank_riders_name )
{

	self waittill( "unload_tank_riders" );

	flag_wait( "asylum_exit" );

	wait( 0.05 );

	self notify( "unload" );

	self waittill( "unloaded" );
	
	if( tank_riders_name == "tank2_riders" )
	{
		level thread delay_unload_message();	
	}

	tank_riders = get_ai_group_ai( tank_riders_name );
	for (i = 0; i < tank_riders.size; i++)
	{
		tank_riders[i].ignoreme = false;
		tank_riders[i].health = 10;
	}

	flag_wait( "outro_tank_move_1" );
	flag_wait( "outro_tank_riders_safe" );

	tank_riders = get_ai_group_ai( tank_riders_name );
	for (i = 0; i < tank_riders.size; i++)
	{
		tank_riders[i] set_force_color( "b" );
		tank_riders[i].baseAccuracy = 0.05;
		tank_riders[i] setthreatbiasgroup( "outro_blue_guys" );
	}

}



///////////////////
//
// set a flag after the guys have cleared the tank, so it doesn't start moving until they're fully off of it
//
///////////////////////////////

delay_unload_message()
{
	wait( 1 );
	quick_text( "outro_tank_riders_safe" );
	flag_set( "outro_tank_riders_safe" );
}



end_of_level()
{

	flag_set( "objective_end" );

	// Put players on god mode
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] EnableInvulnerability();
	}

	// To Be Continued...
	level.bg = NewHudElem(); 
	level.bg.x = 0; 
	level.bg.y = 0; 
	level.bg.horzAlign = "fullscreen"; 
	level.bg.vertAlign = "fullscreen"; 
	level.bg.foreground = false;
	level.bg.sort = 50;
	level.bg SetShader( "black", 640, 480 ); 
	level.bg.alpha = 0;
	level.bg FadeOverTime( 6.0 );
	level.bg.alpha = 1; 

	wait( 6 );

	nextmission();	
	
}



cleanupFadeoutHud()
{
	level.bg destroy();
}



// Tuey - Sets all of the players Shellshock
set_player_shock( var1, var2 )
{
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		players[i] Shellshock( var1, var2 ); 
	}
}



///////////////////
//
// update objective to new location when bend in road is reached
//
///////////////////////////////

objective_pos_update()
{

	trigger_wait( "trig_outro_retreaters_4", "targetname" );	
	objective_position( 6, ( -779, 8340, -343 ) );
	
}


///////////////////
//
// piggybacking autosaves onto other triggers, to save entities
//
///////////////////////////////	

save_mid_tankride()
{
	
	trigger_wait( "trig_save_mid_tankride", "script_noteworthy" );
	
	autosave_by_name( "Ber1 mid tankride" );
	
}

