#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;
#include maps\_shg_common;
#include maps\_utility_chetan;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_store()
{
	flag_set( "door_breached" );
	flag_set( "breach_done" );
	
	move_player_to_start( "start_store" );
	
	maps\_compass::setupMiniMap( "compass_map_prague_escape_escort", "escort_minimap_corner" );
	
	if( !isdefined( level.player ) )
	{
		level.player = getentarray( "player", "classname" )[ 0 ];
	}
	
	level.player EnableWeapons();
	
	setup_hero_for_start( "price", "store" );
	setup_hero_for_start( "soap", "store" );
	
	level.price forceUseWeapon( "deserteagle", "primary" );
	level.soap forceUseWeapon( "p99", "primary" );
	
	m_dump_door = getent( "door_cafe", "targetname" );
	m_dump_door rotateyaw( -120, 0.1 );
	
	m_clip_door_store = getent( "clip_door_store", "targetname" );
	m_clip_door_store connectpaths();
	m_clip_door_store delete();
	
	level.n_obj_protect = prague_objective_add_on_ai( level.soap, &"PRAGUE_ESCAPE_PROTECT_SOAP", true, true, "active", &"PRAGUE_ESCAPE_PROTECT" );
	
	maps\prague_escape_sniper::prague_escape_skippast_cleanup();
	
	maps\prague_escape_dumpster::door_dumpster();
}


// Main Functions	/////////////////////////////////////////////////////////////////////////////////////
store_main()
{
	store_to_statue();
}


#using_animtree( "generic_human" );
store_to_statue()
{
	flag_wait( "door_breached" );
	
	m_ak47_drop = GetEnt( "price_ak47_drop", "targetname" );
	m_ak47_drop hide();
	
	level thread pricesoap_courtyard();
	level thread spawn_courtyard();
	
	flag_wait( "breach_done" );
	
	level thread monitor_player_distance( 900 );
	
	a_actors = make_array( level.price, level.soap );
	
	s_align = getstruct( "anim_align_courtyard", "targetname" );
	
	level.price thread vo_store();
	
	level.price delaythread(.05, ::play_sound_on_entity, "ch_pragueb_5_1_courtyard_price" );
	s_align anim_single( a_actors, "to_courtyard" );
	
	//TODO:  Get notetrack for this
	level thread price_pickup_weapon();
	
	level.price delaythread(.05, ::play_sound_on_entity, "ch_pragueb_5_2_statue_price" );
	s_align anim_single( a_actors, "statue" );
	
	level.price setgoalpos( level.price.origin );
	level.price.fixednode = false;
	
	vol = GetEnt( "vol_price_statue", "targetname" );
	level.price SetGoalVolumeAuto( vol );
	
	s_align thread anim_loop_solo( level.soap, "idle_statue" );
	
	flag_set( "FLAG_store_soap_sitting_at_statue" );
	flag_clear( "FLAG_soap_walk_blood_drip_hip" );
	thread statue_soap_play_blood_pool_fx();
	
	exploder( 501 );
	
	flag_wait( "courtyard_leave" );
	
	level.price ClearGoalVolume();
	
	s_align anim_reach_solo( level.price, "statue_leave" );
	
	s_align notify( "stop_loop" );
	
	flag_set( "FLAG_soap_walk_blood_drip_hip" );
	
	level.price delaythread(.05, ::play_sound_on_entity, "ch_pragueb_5_2_statueleave_price" );
	s_align anim_single( a_actors, "statue_leave" );
	
	level.price ClearAnim( %root, 0 );
	
	flag_set( "left_statue" );
	
	level.price.ignoreme = false;
	level.soap.ignoreme = false;
	
	level.price notify( "stop_phantom_kills" );
}

statue_soap_play_blood_pool_fx()
{
	spots 	= getstructarray( "blood_pool", "targetname" );
	spot 	= array_keep_values( spots, [ "script_noteworthy" ], [ "statue" ] )[ 0 ];
	deletestruct_ref( spot );
	
	PlayFX( getfx( "FX_soap_sit_blood_pool_small" ), spot.origin, AnglesToForward( spot.angles ), AnglesToUp( spot.angles ) );
}

pricesoap_courtyard()
{
	//flag_wait_any( "price_enter_courtyard", "enter_courtyard" );
	
	level thread fake_gunfire();
	//level thread objectives_store();
	
	sp_victim1 = GetEnt( "courtyard_group_victim1", "targetname" );
	level.ai_victim1 = sp_victim1 spawn_ai( true );
	level.ai_victim1 thread ignore_player();
	
	sp_victim2 = GetEnt( "courtyard_group_victim2", "targetname" );
	level.ai_victim2 = sp_victim2 spawn_ai( true );
	level.ai_victim2 thread ignore_player();
	
	level thread price_kills_victims();
}


spawn_courtyard()
{	
	level thread chopper_navigate_logic();
	
	a_sp_suppressor = getentarray( "suppressor", "targetname" );
	array_thread( a_sp_suppressor, ::spawn_ai );
	
	level thread player_safety_window();
	
	waittill_aigroupcount( "group_suppressor", 2 );
		
	a_sp_reinforcer = getentarray( "courtyard_reinforcement", "targetname" );
	array_thread( a_sp_reinforcer, ::spawn_ai );
	
	a_sp_flankers = getentarray( "courtyard_flanker", "targetname" );
	array_thread( a_sp_flankers, ::spawn_ai );
	
	sp_2nd_floor = getent( "courtyard_2nd_floor", "targetname" );
	level.upstairs_guy = sp_2nd_floor spawn_ai( true );
	
	waittill_enemy_count( 2 );
	
	flag_set( "courtyard_leave" );
	
	//level.soap dialogue_queue( "presc_pri_ontheroof" );// on the roof, right side!			
	
	roof_guys = getentarray( "china_roof_guys", "targetname" );
	//array_thread( roof_guys, ::spawn_ai );  
	wait(4);
	
	level thread stagger_spawn( roof_guys );
	
	flag_set( "statue_go" );
	
	wait(6);
	
	a_sp_chasers = getentarray( "china_chaser", "targetname" );
	array_thread( a_sp_chasers, ::spawn_ai );  //three more ai spawn
	
}

stagger_spawn( array )
{
	foreach( spawner in array )
	{
		spawner spawn_ai();
		wait(2);
	}	

}	

chopper_navigate_logic()
{
	level.cough_alley_chopper ent_flag_init( "attacking" );
	level.cough_alley_chopper endon ("death" );	
	level thread kill_chopper_at_soap_death();
	
	if(level.start_point != "defend")
	{		
		//OVER STORE BY STATUE	
		flag_wait( "statue_go" );//
		battlechatter_off( "axis" );
		level.cough_alley_chopper delaythread( 2, ::chopper_loudspeaker);
		level.cough_alley_chopper  ent_flag_set( "attacking" );
		//chopper increases accuracy over time 
		wait(5);
		battlechatter_on( "axis" );
		level.cough_alley_chopper thread chopper_attack_player();
		level.cough_alley_chopper setlookatent( level.player );
		wait(5);
		level.cough_alley_chopper.target_offset = 100;
		
		flag_wait("courtyard_leave"); //Price leaves with soap 
		level.cough_alley_chopper.target_offset = 10;
		
		wait(15);
		
		//CHOPPER TRYING TO KILL PLAYER
		//iprintlnbold( "killing player" );
		level.cough_alley_chopper notify ("stop_attacking");	
		wait(.05);	
		level.cough_alley_chopper thread chopper_attack_player( 1 );
		
		//stop attacking when player leaves 
		flag_wait("player_left_statue");
		level.cough_alley_chopper notify ("stop_attacking");
		level.cough_alley_chopper clearlookatent();
	}
	//
	//DEFEND
	chopper_spots = getentarray("chopper_spot", "targetname");
	level.cough_alley_chopper.target_offset = undefined;
	
	guys = [];
	guys[0] = level.price;
	guys[1] = level.soap;
	guys[2] = level.player;
	guys = array_randomize( guys );
	
	flag_wait("btr_arrives");	
	level.cough_alley_chopper ent_flag_set( "attacking" );
	flag_set("defend_go"); //chopper waiting at node for this flag
	
	//waittill it reaches last node (clear of buildings)
	level.cough_alley_chopper waittillmatch("noteworthy", "clear_of_buildings" );	
	
	//fly to script_origins in a loop
	level.cough_alley_chopper thread defend_chopper_flying_pattern( chopper_spots );
	
	//attack any friendly or player until they pickup soap	
	while(!flag( "price_soap_leaving") )
	{			
		guy = random( guys );	
		level.cough_alley_chopper setlookatent( guy );
		level.cough_alley_chopper chopper_fire_at_target(undefined, guy );						
		wait( randomfloatrange( 1.5, 3 ) );
	}
	
	//price and soap leaving, shoot only at player			
	level.cough_alley_chopper setlookatent( level.player );
	level.cough_alley_chopper.target_offset = 80;
	level.cough_alley_chopper thread chopper_attack_player();	
	
	wait(10);
	
	// increase accuracy
	level.cough_alley_chopper.target_offset = 20;	
					
	wait(15);	
	//stop current attacking
	level.cough_alley_chopper notify ("stop_attacking");		
	wait(.05);
	//shoot to kill player
	level.cough_alley_chopper thread chopper_attack_player( 1 );
	
}	

kill_chopper_at_soap_death()
{
	flag_wait( "FLAG_soap_death_started" );
	if(isdefined( level.cough_alley_chopper ))
	{
		level.cough_alley_chopper notify ("stop_attacking");
		level.cough_alley_chopper delete();
	}
		
}	


defend_chopper_flying_pattern(spots)
{
	//self = chopper
	self endon("death");
	self sethoverparams( 100, 5, .5 );
	while(1)
	{
		foreach(spot in spots)
		{
			self setvehgoalpos( spot.origin );
			wait( randomintrange( 15, 20 ) );
		}
	}		

}	

chopper_attack_player( kill )
{
	self endon( "death" );	
	self endon ("stop_attacking");

	if(!isdefined( self.target_offset))
	{
		self.target_offset = randomintrange(200, 250);	
	}	
	if( isdefined (kill) )
	{
		target = level.player geteye();
		level.cough_alley_chopper.target_offset = 0;
	}
	else
	{		
		target = level.player.origin;	
	}			
	while(self ent_flag( "attacking" ) )
	{			
		if( isdefined (kill) )
		{
			chopper_fire_at_target( kill );
		}	
		else
		{		
			chopper_fire_at_target();	
		}			
		wait( randomfloatrange( 1.5, 3) );
	}	

}

price_shoots_someone( guy )
{
	vol = GetEnt( "vol_shotby_price", "targetname" );
	
	a_ai_enemies = GetAIArray( "axis" );
	
	a_ai_victims = [];
	i = 0;
	
	foreach( ai_victim in a_ai_enemies )
	{
		if ( ai_victim IsTouching( vol ) )
		{
			a_ai_victims[i] = ai_victim;
		}
	}
	
	if ( a_ai_victims.size )
	{
		a_ai_targets = SortByDistance( a_ai_victims, guy.origin );
		ai_enemy = a_ai_targets[0];
		
		if ( isAlive( ai_enemy ) )
		{
			v_gun = guy GetTagOrigin( "tag_flash" );
			v_enemy_head = ai_enemy GetTagOrigin( get_enemy_tag() );
			MagicBullet( "nosound_magicbullet", v_gun, v_enemy_head );
		}
	}
}


price_pickup_weapon()
{
	wait 5;
	
	level.price animscripts\shared::placeweaponon( level.price.primaryweapon, "none" );
	
	wait 1;

	level.price forceUseWeapon( "ak47", "primary" );
	
	m_ak47 = GetEnt( "price_ak47", "targetname" );
	m_ak47 hide();
}


price_statue_gundrop( guy )
{
	level.price animscripts\shared::placeweaponon( level.price.primaryweapon, "none" );
	
	m_ak47_drop = GetEnt( "price_ak47_drop", "targetname" );
	m_ak47_drop Show();
}


price_statue_drawpistol( guy )
{
	level.price forceUseWeapon( "deserteagle", "primary" );
	
	level.price thread price_soap_kill( 400 );
}


vo_store()
{
	wait 5;
	
	self dialogue_queue( "presc_pri_getbehindstatue" );
	
	battlechatter_on( "allies" );
	level.price set_ai_bcvoice( "taskforce" );
	
	waittill_aigroupcount( "group_suppressor", 2 );
	
	wait 2;
	
	self dialogue_queue( "presc_pri_stayonemyuri" );
	
	flag_wait( "courtyard_leave" );
	
	battlechatter_off( "allies" );
	
	// on the roof, right side!
	level.soap dialogue_queue( "presc_pri_ontheroof" );	
	//we cant stay here, cmon this way
	self dialogue_queue( "presc_pri_reinforcementsright" );
	
	//wait 0.5;
	
	//self dialogue_queue( "presc_pri_cantwait" );//we cant wait!
}


player_safety_window()
{
	level.player.ignoreme = true;
	
	wait 1.5;
	
	level.player.ignoreme = false;
}


// spawn functions ////////////////////////////////////////////////////////////
spawnfunc_group_victim()
{
	self endon( "death" );
	
	self.ignoreall = true;
	self.goalradius = 32;
	self.a.disableLongDeath = true;
	
	self enable_cqbwalk();
	
	flag_wait( "enter_courtyard" );
	
	self.ignoreall = false;
}


spawnfunc_2ndfloor()
{
	self endon( "death" );
	
	self thread window_floor_death();
	self thread window_select();
	
	self.animname = "enemy";
	self.health = 10000;
	self.a.disableLongDeath = true;
	self.goalradius = 32;
	
	flag_wait( "spawn_runner" );
	
	self delete();
}


window_select()
{
	self endon( "death" );
	
	nd_statue_side = GetNode( "window_statue_side", "targetname" );
	nd_store_side = GetNode( "window_store_side", "targetname" );
	
	vol_statue = GetEnt( "vol_statue_side", "targetname" );
	vol_store = GetEnt( "vol_store_side", "targetname" );
	
	while( 1 )
	{
		if ( level.player IsTouching( vol_statue ) )
		{
			self SetGoalNode( nd_statue_side );
		}
		
		wait 2;
		
		if ( level.player IsTouching( vol_store ) )
		{
			self SetGoalNode( nd_store_side );
		}
		
		wait 2;
	}
}


window_floor_death()
{
	self endon( "death" );
	
	vol_statue = GetEnt( "vol_statue_side", "targetname" );
	vol_store = GetEnt( "vol_store_side", "targetname" );
	s_align = getstruct( "anim_align_courtyard", "targetname" );
		
	self waittill( "damage" );
	
	if ( level.player IsTouching( vol_statue ) )
	{
		s_align anim_single_solo( self, "balcony_death" );
	}
	
	self dodamage( self.health, self.origin );
	
	wait( 0.05 );
	
	exploder( 607 );
}


spawnfunc_suppressor()
{
	self endon( "death" );
	
	self.goalradius = 32;
	self.a.disableLongDeath = true;
	
	self cqb_walk( "on" );
	
	self waittill( "goal" );
	
	vol_advance = getent( "vol_statue_advance", "targetname" );
	self SetGoalVolumeAuto( vol_advance );
	
	waittill_aigroupcount( "group_suppressor", 3 );
	
	self cqb_walk( "off" );
}


spawnfunc_reinforcer()
{
	self endon( "death" );
	
	self.goalradius = 32;
	self.ignoresuppression = true;
	self.a.disableLongDeath = true;
	
	self waittill( "goal" );
	
	self.ignoresuppression = false;
	
	vol_advance = getent( "vol_statue_advance", "targetname" );
	self SetGoalVolumeAuto( vol_advance );
}


spawnfunc_flanker()
{
	self endon( "death" );
	
	self.goalradius = 32;
	self.ignoresuppression = true;
	self.a.disableLongDeath = true;
	//self.ignoreall = true; //wtf
	
	self waittill( "goal" );
	
	wait RandomFloatRange( 1.5, 3.0 );
	
	vol_statue = getent( "vol_statue", "targetname" );
	self SetGoalVolumeAuto( vol_statue );
	
	self waittill( "goal" );
	
	self.ignoresuppression = false;
	
	flag_wait( "courtyard_leave" );
	
	wait RandomFloatRange( 0.3, 1.0 );
	
	self ClearGoalVolume();
	
	vol_statue = getent( "vol_statue_advance", "targetname" );
	self SetGoalVolumeAuto( vol_statue );
}


spawnfunc_chaser()
{
	self endon( "death" );
	self.grenadeammo = 0;
	self.goalradius = 32;
	self.a.disableLongDeath = true;
	//self cqb_walk( "on" );
	//vol_china_shop
	vol = getent( "vol_china_chaser", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	flag_wait( "left_statue" );
	
	wait RandomFloatRange( 0.3, 1.0 );
	
	self ClearGoalVolume();
	self.baseaccuracy = .2;
	self.goalradius = 32;
	//self cqb_walk( "off" );
	
	vol_statue = getent( "vol_statue_advance", "targetname" );
	self SetGoalVolumeAuto( vol_statue );
	
	flag_wait("exit_street");
	while( player_can_see_ai( self) )
	{
		wait(.15);
	}	
	self delete();
	
}

china_roof_guys_logic()
{
	self endon ("death");
	self disable_long_death();
	self.grenadeammo = 0;
	self.baseaccuracy = .2;
	home = self.origin;
	self.goalradius = 32;
	if(randomint( 100 ) < 40 )
	{
		self laserforceon();	
	}	
	
	//player goes inside
	flag_wait("player_left_statue");
	
	self setgoalpos ( home );
	self.ignoreall = 1;
	while( player_can_see_ai( self) )
	{
		wait(.15);
	}	
	self delete();
}	

// utility functions ////////////////////////////////////////////////////////////
fake_gunfire()
{
	flag_wait_any( "price_enter_courtyard", "enter_courtyard" );
	
	s_gunfire1 = getstruct( "struct_statue_gunfire1", "targetname" );
	s_gunfire2 = getstruct( "struct_statue_gunfire2", "targetname" );
	s_gunfire3 = getstruct( "struct_statue_gunfire3", "targetname" );
	s_gunfire4 = getstruct( "struct_statue_gunfire4", "targetname" );
	
	wait 1;
	
	s_gunfire1 thread hail_of_bullets();
	s_gunfire2 thread hail_of_bullets();
	s_gunfire3 thread hail_of_bullets();
		
	wait 1;
	
	s_gunfire4 thread bullet_impacts_ground();
	
	wait 2;
	
	level notify( "stop_gunfire" );
}


price_kills_victims()
{
	flag_wait( "price_enter_courtyard" );
	
	wait 1;
	
	if ( isAlive( level.ai_victim1 ) )
	{
		level.ai_victim1 DoDamage( level.ai_victim1.health, level.price.origin );
	}
	
	wait 1.5;
	
	if ( isAlive( level.ai_victim2 ) )
	{
		level.ai_victim2 DoDamage( level.ai_victim2.health, level.price.origin );
	}
}


hail_of_bullets()
{
	level endon( "stop_gunfire" );
	
	end = getstruct( self.target, "targetname" );
	
	while( 1 )
	{
		n_delta_x = RandomFloatRange( -8.0, 8.0 );
		n_delta_y = RandomFloatRange( -16.0, 16.0 );
		n_delta_z = RandomFloatRange( -16.0, 16.0 );
		
		MagicBullet( "ak47", self.origin, ( end.origin + ( n_delta_x, n_delta_y, n_delta_z ) ) );
		BulletTracer( self.origin, ( end.origin + ( n_delta_x, n_delta_y, n_delta_z ) ), true );
		
		wait RandomFloatRange( 0.2, 0.6 );
	}
}


bullet_impacts_ground()
{
	end = getstruct( self.target, "targetname" );
	
	n_delta_y = 0;
	
	for ( i = 0; i < 16; i++ )
	{
		MagicBullet( "ak47", self.origin, ( end.origin + ( 0, n_delta_y, 0 ) ) );
			
		n_delta_y += 24;
		
		wait 0.1;
	}
}


courtyard_doors( guy )
{
	m_door_left = getent( "courtyard_door_left", "targetname" );
	m_door_right = getent( "courtyard_door_right", "targetname" );
	
	m_clip_door_courtyard = getent( "clip_door_courtyard", "targetname" );
	
	exploder( 610 );
	
	m_door_left rotateyaw( 120, 0.1 );
	m_door_right rotateyaw( -120, 0.1 );
	
	m_clip_door_courtyard connectpaths();
	m_clip_door_courtyard delete();
}


ignore_player()
{
	createthreatbiasgroup( "enemies" );
	createthreatbiasgroup( "player" );
	
	setignoremegroup( "player" , "enemies" ); //ignored group, ignoring group
	
	level.player setthreatbiasgroup( "player" );
	self setthreatbiasgroup( "enemies" );
}


flags_store()
{
	flag_init( "courtyard_leave" );
	flag_init( "left_statue" );
}


objectives_store()
{
	n_obj_clearcourt = prague_objective_add( &"PRAGUE_ESCAPE_CLEAR_COURTYARD" );
	
	flag_wait( "courtyard_leave" );
	
	prague_objective_complete( n_obj_clearcourt );
	
	objective_delete( n_obj_clearcourt );
	
	// protect Soap objective from prague_escape_dumpster.gsc
	objective_current( level.n_obj_protect );
}


courtyard_spawnfuncs()
{
	sp_victim1 = GetEnt( "courtyard_group_victim1", "targetname" );
	sp_victim1 add_spawn_function( ::spawnfunc_group_victim );
	
	sp_victim2 = GetEnt( "courtyard_group_victim2", "targetname" );
	sp_victim2 add_spawn_function( ::spawnfunc_group_victim );
	
	sp_2nd_floor = getent( "courtyard_2nd_floor", "targetname" );
	sp_2nd_floor add_spawn_function( ::spawnfunc_2ndfloor );
			
	a_sp_suppressors = getentarray( "suppressor", "targetname" );
	array_thread( a_sp_suppressors, ::add_spawn_function, ::spawnfunc_suppressor );
	
	a_sp_reinforcers = getentarray( "courtyard_reinforcement", "targetname" );
	array_thread( a_sp_reinforcers, ::add_spawn_function, ::spawnfunc_reinforcer );
	
	a_sp_flankers = getentarray( "courtyard_flanker", "targetname" );
	array_thread( a_sp_flankers, ::add_spawn_function, ::spawnfunc_flanker );
	
	a_sp_chasers = getentarray( "china_chaser", "targetname" );
	array_thread( a_sp_chasers, ::add_spawn_function, ::spawnfunc_chaser );
	
	china_roof_guys = getentarray( "china_roof_guys", "targetname" );
	array_thread( china_roof_guys, ::add_spawn_function, ::china_roof_guys_logic );
}