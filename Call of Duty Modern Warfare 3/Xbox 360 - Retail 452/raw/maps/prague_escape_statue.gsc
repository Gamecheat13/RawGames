#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;
#include maps\_shg_common;
#include maps\_utility_chetan;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_statue()
{
	move_player_to_start( "start_statue" );
	
	maps\_compass::setupMiniMap( "compass_map_prague_escape_escort", "escort_minimap_corner" );
	
	if( !isdefined( level.player ) )
	{
		level.player = getentarray( "player", "classname" )[ 0 ];
	}
	
	setup_hero_for_start( "price", "statue" );
	setup_hero_for_start( "soap", "statue" );
	
	level.player EnableWeapons();
	
	level.price forceUseWeapon( "deserteagle", "primary" );
	level.soap forceUseWeapon( "p99", "primary" );
	
	level.n_obj_protect = prague_objective_add_on_ai( level.soap, &"PRAGUE_ESCAPE_PROTECT_SOAP", true, true, "active", &"PRAGUE_ESCAPE_PROTECT" );
	
	maps\prague_escape_sniper::prague_escape_skippast_cleanup();
}

// Main Functions	/////////////////////////////////////////////////////////////////////////////////////
statue_main()
{
	statue_to_tunnel();
}


#using_animtree( "generic_human" );
statue_to_tunnel()
{
	level thread spawn_tunnel_groups();
	//level thread monitor_tunnel_groups();
	level thread savegame_travel_office();
		
	s_align = getstruct( "anim_align_street_run", "targetname" );
	
	a_m_props = make_array( level.m_link_lamp, level.m_link_table );
	
	s_align anim_first_frame( a_m_props, "take_cover" );
	
	a_ai_actors = make_array( level.price, level.soap );
	
	level.price thread vo_statue();
	
	level.price delaythread(.05, ::play_sound_on_entity, "ch_pragueb_6_1_through_price" );
	s_align anim_single( a_ai_actors, "thru_building" );
	
	level thread order_playerto_office();
		
	level thread play_lamp_sparks();
		
	flag_set( "vo_yuritakepoint" );
		
	a_actors = make_array( level.price, level.soap, level.m_link_lamp, level.m_link_table );
	level.price delaythread( .05, ::play_sound_on_entity, "ch_pragueb_6_1_through_takecover_price" );
	s_align anim_single( a_actors, "take_cover" );
			
	m_clip_tablestart = GetEnt( "stand_table_clip", "targetname" );
	m_clip_tablestart Delete();
		
	m_clip_tableend = GetEnt( "table_animate_clip", "targetname" );
	m_clip_tableend trigger_on();
	
	level.price ClearAnim( %root, 0 );
	
	a_ai_actors = make_array( level.price, level.soap );
	s_align thread anim_loop( a_ai_actors, "idle_building" );
		
	//trig radius at building exit. Player is already outside if flag is set.
	if(!flag("spawn_tunnel"))
	{
		level thread order_playerto_office();
		wait_for_player( "player_left_statue");
	}	
		
	flag_wait_any( "spawn_tacticals", "goto_tunnel" );
	
	flag_set( "spawn_runner" );
	
	//chopper stops attacking from statue
	if( isDefined( level.cough_alley_chopper) )
	{
		level.cough_alley_chopper notify ("stop_attacking");
		level.cough_alley_chopper ent_flag_clear( "attacking" );
	}
	
	if(!flag( "player_left_statue" ) )
	{
		flag_set ("player_left_statue" );
	}	
			
	s_align notify( "stop_loop" );
	
	level.price delaythread(.05, ::play_sound_on_entity, "ch_pragueb_6_1_through_takecover_exit_price" );	
	s_align anim_single( a_ai_actors, "cover_exit" );
	
	level thread pricesoap_enter_street();
	
	//wait for price/soap to arrive in street before checking if tunnel is clear
	flag_wait("FLAG_street_soap_sitting_by_mailbox");
	
	//monitoring bad guys once Soap and Price enter street
	level thread monitor_tunnel_groups(); 
	
	flag_wait( "goto_bank" );
	
	level notify( "end_fail_monitor" );
}

wait_for_player( flag_to_set )
{
	while( Distance2D( level.player.origin, level.price.origin ) > 256 )
	{
		wait 0.1;
	}
	flag_set( flag_to_set );
	return;	
}	
savegame_travel_office()
{
	t_save = GetEnt( "trigger_travel_office", "script_noteworthy" );
	t_save waittill( "trigger" );
		
	autosave_by_name( "office" );
}


order_playerto_office()
{
	if ( Distance2D( level.player.origin, level.price.origin ) > 400 )
	{
		flag_set( "goto_tunnel" );
		level.price dialogue_queue( "presc_pri_yurigetoverhere2" );
	}
}


pricesoap_enter_street()
{
	s_align = getstruct( "anim_align_street_run", "targetname" );
	a_ai_actors = make_array( level.price, level.soap );
	
	level.price delaythread( .05, ::play_sound_on_entity, "ch_pragueb_6_2_street_price" );
	s_align anim_single( a_ai_actors, "to_street" );
	
	s_align thread anim_loop( a_ai_actors, "idle_street" );
	
	flag_set( "FLAG_street_soap_sitting_by_mailbox" );
	flag_clear( "FLAG_soap_walk_blood_drip_hip" );
	delayThread( 1.0, ::street_soap_play_blood_pool_fx );
	
	exploder( 601 );
	
	flag_wait( "goto_bank" );
	flag_set( "FLAG_soap_walk_blood_drip_hip" );
	
	s_align notify( "stop_loop" );
	
	flag_set( "exit_street" );
}

street_soap_play_blood_pool_fx()
{
	spots 	= getstructarray( "blood_pool", "targetname" );
	spot 	= array_keep_values( spots, [ "script_noteworthy" ], [ "street" ] )[ 0 ];
	deletestruct_ref( spot );
	
	PlayFX( getfx( "FX_soap_sit_blood_pool_small" ), spot.origin, AnglesToForward( spot.angles ), AnglesToUp( spot.angles ) );
}

vo_statue()
{
	//wait 2;
	//through here lets go!
	flag_wait("vo_yuritakepoint");
	wait(3.5);
	level.price dialogue_queue( "presc_pri_cmonnow" );
	
	
	flag_wait( "spawn_tunnel" );
		
	battlechatter_on( "allies" );
	level.price set_ai_bcvoice( "taskforce" );
}


play_lamp_sparks()
{
	wait 3.6;
	
	PlayFX( level._effect[ "lamp_sparks" ], level.m_lean_lamp.origin );
}


spawn_tunnel_groups()
{
	flag_wait( "spawn_runner" );
	array_spawn_function_targetname( "flood_filler", ::flood_filler_logic );
	flood_filler_spawners = getentarray("flood_filler", "targetname");
	array_thread(flood_filler_spawners, Maps\prague_escape_sniper::delete_on_flag, "vo_enemyvehicleahead" );
	maps\_spawner::flood_spawner_scripted( flood_filler_spawners );
	
	sp_runner = GetEnt( "tunnel_runner", "targetname" );
	ai_runner = sp_runner spawn_ai( true );
	
	flag_wait( "spawn_tunnel" );
	
	a_tunnel_precursors = getentarray( "tunnel_precursor", "targetname" );
	array_thread( a_tunnel_precursors, ::spawn_ai );
	
	level thread monitor_tunnel_precursors();
	
	flag_wait( "spawn_tacticals" );
	
	level thread monitor_tunnel_tacticals();
	
	a_sp_tacticals = getentarray( "tunnel_tactical", "targetname" );
	array_thread( a_sp_tacticals, ::spawn_ai );
	
	level thread monitor_tunnel_enemies();
}

flood_filler_logic()
{
	self endon("death");
	self.goalradius = randomintrange(500, 800);
	self setgoalentity(level.player);
	//self thread print3d_on_me( "!!!!" );
}

//MikeD Steez
Print3d_on_me( msg ) 
 { 
 /# 
	self endon( "death" );  
	self notify( "stop_print3d_on_ent" );  
	self endon( "stop_print3d_on_ent" );  
	while( 1 ) 
	{ 
		print3d( self.origin + ( 0, 0, 0 ), msg );  
		wait( 0.05 );  
	} 
 #/ 
 }
 	
monitor_tunnel_groups()
{
	//waittill_aigroupcleared( "group_precursor" );
	//waittill_aigroupcleared( "group_tactical" );
	
	vol = getent( "vol_tunnel", "targetname" );
	
	while( vol get_ai_touching_volume( "axis" ).size > 1 )
	{
		wait(.1);
	}	

	flag_set( "goto_bank" );
}


monitor_tunnel_precursors()
{
	waittill_aigroupcount( "group_precursor", 1 );
	
	flag_set( "spawn_tacticals" );
}


monitor_tunnel_tacticals()
{
	waittill_aigroupcount( "group_tactical", 1 );
	
	flag_set( "tacticals_run" );
}


monitor_tunnel_enemies()
{
	level endon( "goto_bank" );
	
	while( 1 )
	{
		n_enemycount = ( get_ai_group_count( "group_precursor" ) + get_ai_group_count( "group_tactical" ) );
		
		if ( n_enemycount < 4 )
		{
			flag_set( "goto_bank" );
		}
		
		wait 0.1;
	}
}


// spawn functions ////////////////////////////////////////////////////////////
spawnfunc_tunnel_runner()
{
	self endon( "death" );
	
	self thread pricesoap_tunnel_kill();
	
	self.a.disableLongDeath = true;
	
	vol = getent( "vol_tunnel", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	flag_wait( "goto_bank" );
	
	wait RandomFloatRange( 0.8, 2.0 );
	
	self ClearGoalVolume();
	
	vol = getent( "vol_street", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	flag_wait( "vo_enemyvehicleahead" );
	
	wait RandomFloatRange( 0.5, 1.0 );
	
	self ClearGoalVolume();
	
	vol = GetEnt( "vol_bank_entrance", "targetname" );
	self SetGoalVolumeAuto( vol );
}


spawnfunc_tunnel_precursor()
{
	self endon( "death" );
	
	self thread pricesoap_tunnel_kill();
	
	self.goalradius = 32;
	self.ignoresuppression = true;
	self.a.disableLongDeath = true;
	
	self waittill( "goal" );
	
	self.ignoresuppression = false;
	
	vol = getent( "vol_tunnel", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	flag_wait( "goto_bank" );
	
	wait RandomFloatRange( 0.8, 2.0 );
	
	self ClearGoalVolume();
	
	vol = getent( "vol_street", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	flag_wait( "vo_enemyvehicleahead" );
	
	wait RandomFloatRange( 0.5, 1.0 );
	
	self ClearGoalVolume();
	
	vol = GetEnt( "vol_bank_entrance", "targetname" );
	self SetGoalVolumeAuto( vol );
}


spawnfunc_tactical()
{
	self endon( "death" );
	
	self thread tactical_stop_cqb();
	self thread pricesoap_tunnel_kill();
	
	self.goalradius = 32;
	self.ignoresuppression = true;
	self.a.disableLongDeath = true;
	
	self waittill( "goal" );
	
	self.ignoresuppression = false;
	
	vol = getent( "vol_tunnel", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	flag_wait( "goto_bank" );
	
	wait RandomFloatRange( 0.8, 2.0 );
	
	self ClearGoalVolume();
	
	vol = getent( "vol_street", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	flag_wait( "vo_enemyvehicleahead" );
	
	wait RandomFloatRange( 0.5, 1.0 );
	
	self ClearGoalVolume();
	
	vol = GetEnt( "vol_bank_entrance", "targetname" );
	self SetGoalVolumeAuto( vol );
}


tactical_stop_cqb()
{
	self endon( "death" );
	
	flag_wait( "tacticals_run" );
	
	self disable_cqbwalk();
	self.ignoresuppression = false;
}


pricesoap_tunnel_kill()
{
	self endon( "death" );
	
	while( Distance2D( self.origin, level.price.origin ) > 256 )
	{
		wait 0.1;
	}
	
	v_price_gun = level.price GetTagOrigin( "tag_flash" );
	v_enemy_head = self GetTagOrigin( "J_Head" );
		
	MagicBullet( "deserteagle", v_price_gun, v_enemy_head );
}


flags_statue()
{
	flag_init( "tacticals_run" );
	flag_init( "vo_yuritakepoint" );
	flag_init( "goto_tunnel" );
	flag_init( "exit_street" );
}


tunnel_spawnfuncs()
{
	sp_runner = GetEnt( "tunnel_runner", "targetname" );
	sp_runner add_spawn_function( ::spawnfunc_tunnel_runner );
	
	a_tunnel_precursors = getentarray( "tunnel_precursor", "targetname" );
	array_thread( a_tunnel_precursors, ::add_spawn_function, ::spawnfunc_tunnel_precursor );
	
	a_sp_tacticals = getentarray( "tunnel_tactical", "targetname" );
	array_thread( a_sp_tacticals, ::add_spawn_function, ::spawnfunc_tactical );
}


setup_statue_ents()
{
	m_clip_street = getent( "clip_bank_street", "targetname" );
	m_clip_street disconnectpaths();
	
	level.m_lean_lamp = GetEnt( "soap_lean_lamp", "targetname" );
	level.m_lean_table = GetEnt( "soap_lean_table", "targetname" );
		
	level.m_link_lamp = Spawn( "script_model", level.m_lean_lamp.origin );
	level.m_link_lamp.angles = level.m_lean_lamp.angles;
	level.m_link_lamp SetModel( "tag_origin_animate" );
	level.m_link_lamp.animname = "lamp";
	level.m_link_lamp useanimtree( level.scr_animtree[ "lamp" ] );
				
	level.m_lean_lamp.origin = level.m_link_lamp GetTagOrigin( "origin_animate_jnt" );
	level.m_lean_lamp.angles = level.m_link_lamp GetTagAngles( "origin_animate_jnt" );
	level.m_lean_lamp linkto( level.m_link_lamp, "origin_animate_jnt" );
		
	level.m_link_table = Spawn( "script_model", level.m_lean_table.origin );
	level.m_link_table.angles = level.m_lean_table.angles;
	level.m_link_table SetModel( "tag_origin_animate" );
	level.m_link_table.animname = "table";
	level.m_link_table useanimtree( level.scr_animtree[ "table" ] );
				
	level.m_lean_table.origin = level.m_link_table GetTagOrigin( "origin_animate_jnt" );
	level.m_lean_table.angles = level.m_link_table GetTagAngles( "origin_animate_jnt" );
	level.m_lean_table linkto( level.m_link_table, "origin_animate_jnt" );
	
	m_clip_tableend = GetEnt( "table_animate_clip", "targetname" );
	m_clip_tableend trigger_off();
}