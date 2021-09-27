#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;
#include maps\_shg_common;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_bank()
{
	move_player_to_start( "start_bank" );
	
	maps\_compass::setupMiniMap( "compass_map_prague_escape_escort", "escort_minimap_corner" );
	
	if( !isdefined( level.player ) )
	{
		level.player = getentarray( "player", "classname" )[ 0 ];
	}
	
	setup_hero_for_start( "price", "bank" );
	setup_hero_for_start( "soap", "bank" );
	
	level.player EnableWeapons();
	
	level.price forceUseWeapon( "deserteagle", "primary" );
	level.soap forceUseWeapon( "p99", "primary" );
	
	level.n_obj_protect = prague_objective_add_on_ai( level.soap, &"PRAGUE_ESCAPE_PROTECT_SOAP", true, true, "active", &"PRAGUE_ESCAPE_PROTECT" );
	
	flag_set( "exit_street" );
	flag_set( "tunnel_cleared" );
	
	maps\prague_escape_sniper::prague_escape_skippast_cleanup();
}


// Main Functions	/////////////////////////////////////////////////////////////////////////////////////
bank_main()
{
	tunnel_to_bank();
	
	flag_wait( "head_to_court" );
}


#using_animtree( "generic_human" );
tunnel_to_bank()
{
	level endon( "lerp_price_soap" );
	
	level thread monitor_bank_group();
	level thread trigger_suv_street();
	level thread trigger_suv_bank();
	level thread monitor_bank_entrance();
	level thread mission_fail_bank();
	level thread lerp_price_soap();
	
	a_actors = make_array( level.price, level.soap );
	
	s_align = getstruct( "anim_align_bank", "targetname" );
	
	flag_wait( "exit_street" );
	
	level.price thread vo_bank();
	
	level.price delaythread(.05, ::play_sound_on_entity, "ch_pragueb_7_1_alleytunnel_price" );
	s_align anim_single( a_actors, "to_tunnel" );
	
	flag_set( "vo_bank_divert" );
	
	level.soap ClearAnim( %root, 0 );
	
	level.price delaythread(.05, ::play_sound_on_entity, "ch_pragueb_7_2_enemyarrive_price" );
	s_align anim_single( a_actors, "bank_divert" );
	
	flag_set( "nolerp" );
	
	level thread bank_entrance();
}


bank_entrance()
{
	s_align = getstruct( "anim_align_bank", "targetname" );
	a_actors = make_array( level.price, level.soap );
	
	level notify( "end_fail_monitor" );
	
	maps\_compass::setupMiniMap( "compass_map_prague_escape_standoff", "standoff_minimap_corner" );
	
	level.price delaythread (.05, ::play_sound_on_entity, "ch_pragueb_7_3_enterbank_price" );
	s_align anim_single( a_actors, "enter_bank" );
	
	if ( flag( "lerp_price_soap" ) )
	{
		Objective_OnEntity( level.n_obj_protect, level.soap, (0, 0, 70) );
	}
	
	s_align thread anim_loop( a_actors, "idle_bank_battle" );
	
	level thread fire_hydrant_fx();
	
	flag_wait( "bank_done" );
	
	s_align notify( "stop_loop" );
	/*
	defend_approach_chopper = spawn_vehicle_from_targetname_and_drive( "defend_approach_chopper" );
	wait(.10);
	defend_approach_chopper thread chopper_attack_logic();	
	defend_approach_chopper thread Maps\prague_escape_sniper::delete_on_flag( "in_safehouse" );
	defend_approach_chopper delaythread(8, ::play_sound_on_enity, "prague_escape_chopper_pa" );
	*/
	level.price delaythread( .05, ::play_sound_on_entity, "ch_pragueb_7_4_bankexit_price" );
	s_align anim_single( a_actors, "exit_bank" );
	
	flag_set( "head_to_court" );
}

chopper_attack_logic()
{
	self endon( "death" );
	while(1)
	{
		self waittillmatch("noteworthy", "start_attacking");//noteworthy on vehicle_node
		self thread chopper_attack_on();
		self waittillmatch("noteworthy", "stop_attacking");//noteworthy on vehicle_node
		self notify ("stop_attacking");
		self clearlookatent();
	}	
		
}	

chopper_attack_on()
{
	self endon( "death" );	
	self endon ("stop_attacking");
	self setlookatent( level.player );
	while(1)
	{
		offset = randomintrange(200, 250);	
		target = level.player.origin;			
		self setturrettargetvec( target +(offset, offset, 0) );	
		//
		chopper_fire_at_target();
		wait( randomfloatrange( 1.5, 2) );
	}	

}	

lerp_price_soap()
{
	level endon( "nolerp" );
	
	flag_wait( "suv_reinforce" );
	
	v_player_angles = level.player GetPlayerAngles();
	
	//make sure player can't see Price/Soap lerp
	if ( flag( "thru_bank" ) )
	{
		if ( !( ( v_player_angles[1] > -140  ) && ( v_player_angles[1] < -30 ) ) )
		{
			flag_set( "lerp_price_soap" );
			Objective_Position( level.n_obj_protect, ( 0, 0, 0 ) );
			level thread bank_entrance();
		}
	}
	
	if ( flag( "thru_street" ) )
	{
		if ( !( ( v_player_angles[1] > -147  ) && ( v_player_angles[1] < -50 ) ) )
		{
			flag_set( "lerp_price_soap" );
			Objective_Position( level.n_obj_protect, ( 0, 0, 0 ) );
			level thread bank_entrance();
		}
	}
}


price_kill_enemy( guy )
{
	a_ai_enemies = GetAIArray( "axis" );
	
	if ( a_ai_enemies.size )
	{
		a_ai_enemies = SortByDistance( a_ai_enemies, level.price.origin );
		enemy = a_ai_enemies[0];
	
		if ( isAlive( enemy ) )
		{
			if ( Distance2D( enemy.origin, level.price.origin ) < 300 )
			{
				if ( cointoss() )
				{
					v_price_gun = level.price GetTagOrigin( "tag_flash" );
					v_enemy_head = enemy GetTagOrigin( get_enemy_tag() );
					MagicBullet( "deserteagle", v_price_gun, v_enemy_head );	
				}
			}
		}
	}
}


soap_kill_enemy( guy )
{
	a_ai_enemies = GetAIArray( "axis" );
	
	if ( a_ai_enemies.size )
	{
		a_ai_enemies = SortByDistance( a_ai_enemies, level.soap.origin );
		enemy = a_ai_enemies[0];
	
		if ( isAlive( enemy ) )
		{
			if ( Distance2D( enemy.origin, level.soap.origin ) < 300 )
			{
				if ( cointoss() )
				{
					v_soap_gun = level.soap GetTagOrigin( "tag_flash" );
					v_enemy_head = enemy GetTagOrigin( get_enemy_tag() );
					
					if ( cointoss() )
					{
						MagicBullet( "p99", v_soap_gun, v_enemy_head );	
					}
				}
			}
		}
	}
}


price_shootat_enemy( guy )
{
	a_ai_enemies = GetAIArray( "axis" );
	
	if ( a_ai_enemies.size )
	{
		a_ai_enemies = SortByDistance( a_ai_enemies, level.price.origin );
		enemy = a_ai_enemies[0];
	
		if ( isAlive( enemy ) )
		{
			if ( cointoss() )
			{
				v_price_gun = level.price GetTagOrigin( "tag_flash" );
				v_enemy_head = enemy GetTagOrigin( get_enemy_tag() );
				MagicBullet( "deserteagle", v_price_gun, v_enemy_head );	
			}
		}
	}	
}


fire_hydrant_fx()
{
	level endon( "plug_hydrant_leak" );
	
	m_hydrant_tag = GetEnt( "tag_hydrant_fx", "targetname" );
	
	while( 1 )
	{
		PlayFXOnTag( level._effect[ "firehydrant_leak" ], m_hydrant_tag, "tag_origin" );
		
		wait 0.15;
	}
}


vo_bank()
{
	//self = price
	level endon( "chasers" );
	wait 4;
	
	self dialogue_queue( "presc_pri_keepmoving3" );
	wait(3);
	level.soap dialogue_queue( "presc_mct_damnright" );//theres more..on the street..
		
	flag_wait( "vo_enemyvehicleahead" );
	
	//level.soap dialogue_queue( "presc_pri_enemyvehicleahead" );//theres more of em!
	wait(1);
	self dialogue_queue( "presc_pri_findsomewhere"); //Take care of em yuri!
	
	flag_wait( "vo_bank_divert" );
	
	wait 2;
	
	self dialogue_queue( "presc_pri_thisway2" );
	
	flag_wait( "bank_done" );
	
	battlechatter_off( "allies" );
	
	wait 2;
	
	self dialogue_queue( "presc_pri_moreontheway" );
	
	wait 1;
	
	self dialogue_queue( "presc_pri_keepmoving" );//TODO change to "presc_pri_alrightson"
	wait(1);
	level.soap  dialogue_queue( "presc_mct_justleaveme" );
	wait(.8);
	self dialogue_queue( "presc_pri_gettingyouout" ); //No, Im getting you out of this!
	
}


trigger_suv_street()
{
	level.trigger_street = getent( "trigger_vehicle_street", "targetname" );
	level.trigger_street waittill( "trigger" );
	
	flag_set( "thru_street" );
	flag_set( "suv_reinforce" );
	
	level.trigger_bank trigger_off();
}
		
trigger_suv_bank()
{
	level.trigger_bank = getent( "trigger_vehicle_bank", "targetname" );
	level.trigger_bank waittill( "trigger" );
	
	flag_set( "thru_bank" );
	flag_set( "suv_reinforce" );
	
	level.trigger_street trigger_off();
}


monitor_bank_group()
{
	waittill_aigroupcleared( "group_suv" );
	
	flag_wait( "suv_reinforce" );
	
	if ( flag( "thru_street" ) )
	{
		waittill_aigroupcleared( "group_street" );
	}
	
	else if ( flag( "thru_bank" ) )
	{
		waittill_aigroupcleared( "group_bank" );
	}
	
	level thread monitor_tunnel_groups();
	
	flag_wait( "tunnel_cleared" );
	
	flag_set( "bank_done" );
	
	a_ai_enemies = GetAIArray( "axis" );
	
	foreach( ai_enemy in a_ai_enemies )
	{
		ai_enemy Delete();
	}
	
	autosave_by_name( "bank" );
}


monitor_tunnel_groups()
{
	waittill_aigroupcleared( "group_precursor" );
	waittill_aigroupcleared( "group_tactical" );

	flag_set( "tunnel_cleared" );
}


monitor_bank_entrance()
{
	flag_wait( "suv_reinforce" );
	
	if ( flag( "thru_street" ) )
	{
		waittill_aigroupcount( "group_street", 1 );
	}
	
	else if ( flag( "thru_bank" ) )
	{
		waittill_aigroupcount( "group_bank", 1 );
	}
	
	waittill_aigroupcount( "group_suv", 1 );
	
	flag_set( "enter_bank" );	
}



// spawn functions ////////////////////////////////////////////////////////////
spawnfunc_suv_bank()
{
	self endon( "death" );
	
	self thread monitor_suv_damage();
	
	self SetCanDamage( false );
	
	self waittill( "unloaded" );
	
	self SetCanDamage( true );
	
	flag_set( "suv_bank_unloaded" );	
}


spawnfunc_suv_street()
{
	self endon( "death" );
	
	self SetCanDamage( false );
	
	self thread monitor_suv_damage();
	
	self waittill( "reached_end_node" );
	
	self SetCanDamage( true );
}


spawn_func_suv1()
{
	self endon( "death" );
	
	self thread monitor_suv_damage();
	
	self SetCanDamage( false );
	
	self waittill( "reached_end_node" );
	
	self SetCanDamage( true );
	
	//self thread fire_hydrant_damage();
	
	flag_set( "vo_enemyvehicleahead" );
	
	wait 1;
	
	self vehicle_unload();
	
	self waittill( "unloaded" );
	
	flag_set( "suv1_unloaded" );	
}


spawn_func_suv2()
{
	self endon( "death" );
	
	self thread monitor_suv_damage();
	self thread suv_hits_stuff();
	
	self SetCanDamage( false );
	
	self waittill( "reached_end_node" );
	
	self SetCanDamage( true );
	
	wait 0.5;
	
	self vehicle_unload();
	
	self waittill( "unloaded" );
	
	flag_set( "suv2_unloaded" );
}


spawnfunc_alley_cover()
{
	self endon( "death" );
	
	self.disableLongDeath = true;
	
	self thread enter_bank();
	
	flag_wait( "suv2_unloaded" );
	
	vol = GetEnt( "vol_alley_entrance", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	flag_wait( "suv_reinforce" );
	
	self ClearGoalVolume();
	
	vol = GetEnt( "vol_bank_entrance", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	flag_wait( "bank_done" );
	
	self ClearGoalVolume();
}


spawnfunc_bank_assault()
{
	self endon( "death" );
	
	self thread enter_bank();
	
	self.goalradius = 32;
	self.disableLongDeath = true;
	
	flag_wait( "suv1_unloaded" );
	
	self waittill( "goal" );
	
	vol = GetEnt( "vol_bank_interior", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	flag_wait( "bank_done" );
	
	self ClearGoalVolume();
}


spawnfunc_bank_breach1()
{
	self endon( "death" );
	
	self.animname = "enemy";
	self.allowdeath = true;
	self.goalradius = 32;
	self.disableLongDeath = true;
	
	flag_wait( "suv1_unloaded" );
	
	s_align = getstruct( "anim_align_bank", "targetname" );
	
	s_align anim_reach_solo( self, "bank_entry_door1" );
	s_align anim_single_solo( self, "bank_entry_door1" );
}


spawnfunc_bank_breach2()
{
	self endon( "death" );
	
	self.animname = "enemy";
	self.allowdeath = true;
	self.goalradius = 32;
	self.disableLongDeath = true;
	
	flag_wait( "suv1_unloaded" );
	
	s_align = getstruct( "anim_align_bank", "targetname" );
		
	s_align anim_reach_solo( self, "bank_entry_door2" );
	s_align anim_single_solo( self, "bank_entry_door2" );
}


spawnfunc_bank_entry1()
{
	self endon( "death" );
	
	self.animname = "enemy";
	self.disableLongDeath = true;
	
	s_align = getstruct( "anim_align_bank", "targetname" );
	
	flag_wait( "suv_bank_unloaded" );	
	
	s_align anim_reach_solo( self, "bank_entry_dive" );
	s_align anim_single_solo( self, "bank_entry_dive" );
	
	vol = GetEnt( "vol_bank_interior", "targetname" );
	self SetGoalVolumeAuto( vol );
}


spawnfunc_bank_entry2()
{
	self endon( "death" );
	
	self.animname = "enemy";
	self.disableLongDeath = true;
	
	s_align = getstruct( "anim_align_bank", "targetname" );
	
	flag_wait( "suv_bank_unloaded" );	
	
	s_align anim_reach_solo( self, "bank_entry_left" );
	s_align anim_single_solo( self, "bank_entry_left" );
	
	vol = GetEnt( "vol_bank_interior", "targetname" );
	self SetGoalVolumeAuto( vol );
}


spawnfunc_bank_entry3()
{
	self endon( "death" );
	
	self.animname = "enemy";
	self.disableLongDeath = true;
	
	s_align = getstruct( "anim_align_bank", "targetname" );
	
	flag_wait( "suv_bank_unloaded" );	
	
	s_align anim_reach_solo( self, "bank_entry_right" );
	s_align anim_single_solo( self, "bank_entry_right" );
	
	vol = GetEnt( "vol_bank_interior", "targetname" );
	self SetGoalVolumeAuto( vol );
}


spawnfunc_bank_entry4()
{
	self endon( "death" );
	
	self.animname = "enemy";
	self.disableLongDeath = true;
	
	s_align = getstruct( "anim_align_bank", "targetname" );
	
	flag_wait( "suv_bank_unloaded" );	
	
	s_align anim_reach_solo( self, "bank_entry_jump" );
	s_align anim_single_solo( self, "bank_entry_jump" );
	
	vol = GetEnt( "vol_bank_interior", "targetname" );
	self SetGoalVolumeAuto( vol );
}


// utility functions ////////////////////////////////////////////////////////////
suv_hits_stuff()
{
	self endon( "death" );
	
	t_suv = GetEnt( "trigger_suv_boxes", "targetname" );
	t_suv waittill( "trigger" );
	
	s_jolt = getstruct( "struct_suv_box", "targetname" );
	
	PhysicsExplosionCylinder( s_jolt.origin, 80, 20, 1.3 );
	RadiusDamage( s_jolt.origin, 40, 100, 80 );
}


fire_hydrant_damage()
{
	m_hydrant = GetEnt( "fire_hydrant_dmg", "targetname" );
	
	wait 0.5;
	
	RadiusDamage( m_hydrant.origin, 35, 450, 350 );
}


pricesoap_proximity()
{
	self endon( "death" );
	
	// enemy who gets closer than this to Price/Soap dies
	n_death_radius = 300;
	
	flag_wait( "suv_reinforce" );
	
	while( Distance2D( self.origin, level.price.origin ) > n_death_radius )
	{
		wait 0.1;
	}
	
	self killed_by_pricesoap();
}


killed_by_pricesoap()
{
	self endon( "death" );
	
	n_kill = 0;
	
	while( n_kill < 25 )
	{
		n_kill = RandomIntRange( 0, 50 );
		
		wait 1.0;
	}
	
	self die();
}


enter_bank()
{
	self endon( "death" );
	
	flag_wait( "enter_bank" );
	
	self ClearGoalVolume();
	
	self.goalradius = 32;
	self.ignoresuppression = true;
	
	vol = GetEnt( "vol_bank_interior", "targetname" );
	self SetGoalVolumeAuto( vol );
}


mission_fail_bank()
{
	level endon( "bank_done" );
	
	t_chasers = GetEnt( "trigger_chasers", "script_noteworthy" );
	t_chasers waittill( "trigger" );
	
	SetDvar( "ui_deadquote", &"PRAGUE_ESCAPE_PROTECT_FAIL" );
	
	level thread missionFailedWrapper();
}


window_break_jump( guy )
{
	GlassRadiusDamage( ( 22898, 17305, -20 ), 200, 500, 500 );
}


window_break_dive( guy )
{
	GlassRadiusDamage( ( 23264, 17162, -20 ), 64, 500, 500 );
}


flags_bank()
{
	flag_init( "thru_bank" );
	flag_init( "thru_street" );
	flag_init( "suv1_unloaded" );	
	flag_init( "suv2_unloaded" );
	flag_init( "suv_reinforce" );
	flag_init( "suv_bank_unloaded" );
	flag_init( "enter_bank" );
	flag_init( "tunnel_cleared" );
	flag_init( "bank_done" );
	flag_init( "lerp_price_soap" );
	flag_init( "nolerp" );
	flag_init( "head_to_court" );
	
	//vo flags
	flag_init( "vo_enemyvehicleahead" );
	flag_init( "vo_bank_divert" );
}


bank_spawnfuncs()
{
	vh_suv1 = GetEnt( "suv_blocker1", "targetname" );
	vh_suv1 add_spawn_function( ::spawn_func_suv1 );
	
	vh_suv2 = GetEnt( "suv_blocker2", "targetname" );
	vh_suv2 add_spawn_function( ::spawn_func_suv2 );
	
	a_sp_cover = GetEntArray( "alley_cover", "script_noteworthy" );
	array_thread( a_sp_cover, ::add_spawn_function, ::spawnfunc_alley_cover );
	 
	sp_breacher1 = GetEnt( "bank_breach1", "script_noteworthy" );
	sp_breacher1 add_spawn_function( ::spawnfunc_bank_breach1 );
	
	sp_breacher2 = GetEnt( "bank_breach2", "script_noteworthy" );
	sp_breacher2 add_spawn_function( ::spawnfunc_bank_breach2 );
	
	a_sp_assault = getentarray( "bank_assault", "script_noteworthy" );
	array_thread( a_sp_assault, ::add_spawn_function, ::spawnfunc_bank_assault );
	
	sp_assault1 = getentarray( "assault_1", "script_noteworthy" );
	array_thread( sp_assault1, ::add_spawn_function, ::spawnfunc_bank_entry1 );
	
	sp_assault2 = getentarray( "assault_2", "script_noteworthy" );
	array_thread( sp_assault2, ::add_spawn_function, ::spawnfunc_bank_entry2 );
	
	sp_assault3 = getentarray( "assault_3", "script_noteworthy" );
	array_thread( sp_assault3, ::add_spawn_function, ::spawnfunc_bank_entry3 );
	
	sp_assault4 = getentarray( "assault_4", "script_noteworthy" );
	array_thread( sp_assault4, ::add_spawn_function, ::spawnfunc_bank_entry4 );
	
	vh_suv_bank = GetEnt( "suv_bank", "targetname" );
	vh_suv_bank thread add_spawn_function( ::spawnfunc_suv_bank );
	
	a_vh_street = GetEntArray( "suv_street", "targetname" );
	array_thread( a_vh_street, ::add_spawn_function, ::spawnfunc_suv_street );
}