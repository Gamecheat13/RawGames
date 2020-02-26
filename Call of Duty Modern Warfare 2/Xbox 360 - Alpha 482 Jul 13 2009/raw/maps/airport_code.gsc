#include maps\_utility;
#include common_scripts\utility;
#include maps\_riotshield;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_hud_util;

CONST_FF_DECREMENT_TIME	= 25;
CONST_FF_AGGRISSIVE_NUM	= 2;
CONST_FF_AUTOKILL_TIME	= 20;
CONST_FF_FIRE_TIME		= 25;
CONST_FF_WANDER_TIME	= 25;
CONST_FF_WANDER_DIST	= 600;

CONST_ELEV_CABLE_HEIGHT = 94;
CONST_ELEV_CABLE_CLOSE = 2;

/************************************************************************************************************/
/*												INTRO ELEVATOR												*/
/************************************************************************************************************/
elevator_setup( doors )
{
	doors[ "left" ].close_pos 	= doors[ "left" ].origin;
	doors[ "right" ].close_pos 	= doors[ "right" ].origin;
	
	dist = (-38,0,0);
		
	doors[ "left" ].open_pos 	= doors[ "left" ].origin - dist;
	doors[ "right" ].open_pos 	= doors[ "right" ].origin + dist;
}

elevator_close_doors( doors, snd, speed )
{
	snd playsound( "elev_door_close" );
	
	doors[ "left" ] disconnectpaths();
	doors[ "right" ] disconnectpaths();
	
	if( !isdefined( speed ) )
		speed = 14;			
	
	closed_pos = doors[ "left" ].close_pos;			
	dist = abs( distance( doors[ "left" ].open_pos, closed_pos ) );		
	moveTime = dist / speed;										

	doors[ "left" ] moveTo( closed_pos, moveTime, moveTime * 0.1, moveTime * 0.25 );
	doors[ "right" ] moveTo( closed_pos, moveTime, moveTime * 0.1, moveTime * 0.25 );
	
	doors[ "left" ] waittill( "movedone" );
}

elevator_open_doors( doors, snd )
{
	snd playsound( "elev_door_open" );
	
	doors[ "left" ] connectpaths();
	doors[ "right" ] connectpaths();
	
	speed = 14;									// scaler
	closed_pos = doors[ "left" ].close_pos;	
	dist = abs( distance( doors[ "left" ].open_pos, closed_pos ) );
	moveTime = ( dist / speed ) * 0.5;										// scaler

	doors[ "left" ] moveTo( doors[ "left" ].open_pos, moveTime, moveTime * 0.1, moveTime * 0.25 );
	doors[ "right" ] moveTo( doors[ "right" ].open_pos, moveTime, moveTime * 0.1, moveTime * 0.25 );
	
	doors[ "left" ] waittill( "movedone" );
}

/************************************************************************************************************/
/*													INTRO													*/
/************************************************************************************************************/
blend_movespeedscale_custom( percent, time )
{
	player = self;
	if( !isplayer( player ) )
		player = level.player;
	
	player notify( "blend_movespeedscale_custom" );
	player endon( "blend_movespeedscale_custom" );
		
	if( !isdefined( player.baseline_speed ) )
		player.baseline_speed = 1.0;
	
	goalspeed = percent * .01;
	currspeed = player.baseline_speed;

	if ( isdefined( time ) )
	{
		range = goalspeed - currspeed;
		interval = .05;
		numcycles = time / interval;
		fraction = range / numcycles;

		while ( abs( goalspeed - currspeed ) > abs( fraction * 1.1 ) )
		{
			currspeed += fraction;
			player.baseline_speed = currspeed;
			if( !flag( "player_dynamic_move_speed" ) )
				level.player SetMoveSpeedScale( player.baseline_speed );
			wait interval;
		}
	}

	player.baseline_speed = goalspeed;
	if( !flag( "player_dynamic_move_speed" ) )
		level.player SetMoveSpeedScale( player.baseline_speed );
}

player_dynamic_move_speed()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	flag_set( "player_dynamic_move_speed" );
	
	current = 1;
	actor = undefined;
	
	foreach( member in level.team )
		member.plane_origin = spawnstruct();
		
	SetDvarIfUninitialized( "debug_playerDMS", 0 );
	
		
	while( flag( "player_dynamic_move_speed" ) )
	{		
		//if we're close enough to an actor to be significant - then just use him
		//otherwise go through a series of complicated steps to figure out where 
		//we are in relation to the whole team
		guy = getclosest( level.player.origin, level.team );		
		ahead = false;
		
		//we dont have distance2d SQUARED...so here's a hack
		origin1 = ( level.player.origin[0], level.player.origin[1], 0 );
		origin2 = ( guy.origin[0], guy.origin[1], 0 );
				
		if( distancesquared( origin1, origin2 ) < squared( 200 ) )
		{
			ahead = guy player_DMS_ahead_test();
			
			guy.plane_origin.origin = guy player_DMS_get_plane();
			
			actor = guy.plane_origin;
			
			/#
			if( GetDvarInt( "debug_playerDMS" ) )
				Line( actor.origin, level.player.origin, ( 1, 0, 0 ), 1 );
			#/
		}
		else
		{
			//calculate if we are ahead of anyone
			foreach( member in level.team )
			{
				//for this level, this function is so aggressive that we'll never get this far 
				//ahead of someone - so don't count it
				if( distancesquared( level.player.origin, member.origin ) > squared( 500 ) )
					continue;
				ahead = member player_DMS_ahead_test();
				if( ahead )
					break;
			}			
			//calculate a facing plane based on everyone's angles, then get the closest point on the closest
			//plane to us - and use that point to decide how close we are to the average of the group
			planes = [];
			foreach( member in level.team )
			{
				member.plane_origin.origin = member player_DMS_get_plane();

				planes[ planes.size ] = member.plane_origin;
			}
			
			actor = getclosest( level.player.origin, planes );
			
			/#
			if( GetDvarInt( "debug_playerDMS" ) )
				Line( actor.origin, level.player.origin, ( 0, 1, 0 ), 1 );
			#/
		}
		/#
		if( GetDvarInt( "debug_playerDMS" ) )
			print3d( actor.origin, "dist: " + distance( level.player.origin, actor.origin ), (1,1,1), 1 );
		#/				
		//if he's wait out in front - really slow him down
		if( distancesquared( level.player.origin, actor.origin ) > squared( 100 ) && ahead )
		{
			/#
			if( GetDvarInt( "debug_playerDMS" ) )
				println( "TOOO FAR AHEAD!!!!!!!!!!!" );
			#/
			if( current > .55 )
				current -= .015;	
		}		
		//if he's too close - take him as much as 20% under his baseline
		else
		if( distancesquared( level.player.origin, actor.origin ) < squared( 50 ) || ahead )
		{
			if( current < .78 )
				current += .015;
				
			if( current > .8 )
				current -= .015;	
		}
		//if he's REALLY far away - take him as much as 75% over his baseline ( as long as total speed doesn't reach 110%, capped below )
		else
		if( distancesquared( level.player.origin, actor.origin ) > squared( 300 ) )
		{
			if( current < 1.75 )
				current += .02;
		}
		//if he's far away - take him as much as 35% over his baseline
		else
		if( distancesquared( level.player.origin, actor.origin ) > squared( 100 ) )
		{
			if( current < 1.35 )
				current += .01;
		}
		//if he's in range - take him back to his baseline
		else
		if( distancesquared( level.player.origin, actor.origin ) < squared( 85 ) )
		{
			if( current > 1.0 )
				current -= .01;	
			if( current < 1.0 )
				current += .01;	
		}
		
		if( current > 1.65 )
			level.player allowsprint( true );
		else
			level.player allowsprint( false );
			
		//set his speed based on baseline and this ratio
		level.player.adjusted_baseline = level.player.baseline_speed * current;
		if( level.player.adjusted_baseline > 1.1 )
			level.player.adjusted_baseline = 1.1;
		
		/#
		if( GetDvarInt( "debug_playerDMS" ) )	
			println( "baseline: " + level.player.baseline_speed + ", 	adjusted: " + level.player.adjusted_baseline );
		#/
		
		level.player SetMoveSpeedScale( ( level.player.adjusted_baseline ) );
		wait .05;
	}
}

player_DMS_get_plane()
{
	P = level.player.origin;
	A = self.origin + vector_multiply( anglestoright( self.angles ), -5000 );
	B = self.origin + vector_multiply( anglestoright( self.angles ), 5000 );
	/#
	if( GetDvarInt( "debug_playerDMS" ) )
		Line( A, B, ( 0, 0, 1 ), 1 );
	#/
	return PointOnSegmentNearestToPoint( A, B, P );
}

player_DMS_ahead_test()
{
	ahead = false;
	//this is a test to see if we're closer to their goal than they are
	if ( isdefined( self.last_set_goalent ) )
		ahead = self [[ level.drs_ahead_test ]]( self.last_set_goalent, 50 );
	else if ( isdefined( self.last_set_goalnode ) )
		ahead = self [[ level.drs_ahead_test ]]( self.last_set_goalnode, 50 );
	
	return ahead;
}


lobby_sign()
{
	sign = getent( "intro_security_sign", "targetname" );
	
	time1 = 1;
	time2 = 1;
	time3 = .5;
	
	PlayFX( getfx( "sign_fx" ), sign.origin + (0,120,5) );
		
	sign rotatepitch( -135, time1, time1 * .65, time1 * .35 );
	wait time1;
	sign rotatepitch( 90, time2, time2 * .5, time2 * .5 );
	wait time2;
	sign rotatepitch( -45, time2, time2 * .5, time2 * .5 );
	wait time2 * .5;
	
	PlayFX( getfx( "sign_fx" ), sign.origin );			
				
	sign PhysicsLaunchClient( sign.origin + (0,5,-25), (1000,5000,.1) );
}

elevator_floor_indicator()
{
	//setup
	temp = getentarray( "elev_num", "targetname" );	
	lights = [];
	foreach( item in temp )
		lights[ item.script_noteworthy ] = item;
	
	lights[ "down" ] hide();
	lights[ "2" ] hide();
	lights[ "m" ] hide();
	lights[ "l1" ] hide();
	
	doors = [];
	doors[ "left" ] = getent( "intro_elevator_door_left", "targetname" );
	doors[ "right" ] = getent( "intro_elevator_door_right", "targetname" );		
	elevator_setup( doors );
	
	snd = spawn( "script_origin", doors[ "left" ].close_pos );
	snd2 = spawn( "script_origin", doors[ "left" ].close_pos );
	
	//sounds
	snd playsound( "elev_run_start" );
	snd2 playloopsound( "elev_run_loop" );
	thread play_sound_in_space( "scn_airport_elevator_opening_long", level.player.origin + (0,0,70) ); 
	
	wait 5.5;
					
	wait 4.5;	//5.5	-> M 	-> 1st before click
	snd playsound( "elevator_pass_floor_beep" );
	
	wait 6.5;	//11	-> L1	-> 2nd after click
	snd playsound( "elevator_pass_floor_beep" );
	
	wait 4.5;	//15.5	-> 1	-> 3rd after cough
	snd playsound( "elevator_pass_floor_beep" );
	
	wait 2;		//18
	level.team[ "shotgun" ] thread dialogue_queue( "airport_at1_nosurv" );
	
	wait 2;
	
	snd2 stoploopsound( "elev_run_loop" );
	thread play_sound_in_space( "elev_run_end", snd.origin ); 
	 	
	wait 1;		//21	-> 2
				
	level.makarov dialogue_queue( "airport_mkv_noruss" );
	snd playsound( "elev_bell_ding" );
		
	lights[ "1" ] hide();
	lights[ "2" ] show();
	lights[ "up" ] hide();
	wait .5;
	
	lights[ "down" ] delaycall( .5, ::show );
	
	flag_set( "elevator_up_done" );	
	elevator_open_doors( doors, snd );
	
	wait 1;
	snd delete();
	snd2 delete();
}

elevator_player()
{
	enablePlayerWeapons( false );	
	SetSavedDvar( "ammoCounterHide", "1" );
	
	wait 5;
	wait 5.5;
	
	wait 2.55;	
	enablePlayerWeapons( true );
	
	
	level.player takeweapon( "m4_grenadier" );
	level.player takeweapon( "m240" );
	level.player takeweapon( "fraggrenade" );
	level.player takeweapon( "flash_grenade" );	
	
	wait 3.5;
	
	level.player giveweapon( "saw_airport" );
	level.player switchToWeapon( "saw_airport" );
	
	wait 22;
	
	level.player takeweapon( "saw_airport" );
	
	enablePlayerWeapons( false );
	SetSavedDvar( "ammoCounterHide", "0" );
		
	level.player giveweapon( "m4_grenadier" );
	level.player giveweapon( "m240" );
	level.player giveWeapon( "fraggrenade" );
	level.player giveWeapon( "flash_grenade" );			
	level.player givemaxammo( "m240" );
	level.player SetWeaponAmmoClip( "m240", 100 );
	
	level.player switchToWeapon( "m240" );
					
	enablePlayerWeapons( true );	
}

lobby_people_create( data )
{
	group = data[ self.targetname ];
		
	foreach( actor in group )
	{	
		spawner = getent( actor[ "model" ], "targetname" );
		spawner.count = 1;
		
		if( actor[ "anime" ] == "airport_civ_in_line_6_C" )
		{
			spawner.target = "lobby_girl_run_node";
			spawner.script_moveoverride = 1;
		}
		else
		{
			spawner.target = undefined;
			spawner.script_moveoverride = undefined;
		}
		
		drone = dronespawn( spawner );
		
		drone.ref_node 		= self;
		drone.anime 		= actor[ "anime" ];
		drone.script_delay 	= actor[ "delay" ];
		drone._deathanim 	= actor[ "deathanim" ];
		drone.deathtime 	= actor[ "deathtime" ];
		if( isdefined( actor[ "deleteme" ] ) )
			drone.deleteme 		= actor[ "deleteme" ];
		
		drone.dontdonotetracks	= 1;
		drone.nocorpsedelete 	= 1;
						
		drone thread lobby_people_logic();
	}
}
#using_animtree( "generic_human" );
lobby_security_intro()
{
	self endon( "death" );
	self.ignoreall = true;
	self.ignoreme = true;
	self.team = "neutral";	
	
	self gun_remove();
	
	node = spawnstruct();
	node.angles = self.angles;
	node.origin = self.origin;
	
	node anim_generic_first_frame( self, self.animation );
	self.dontdonotetracks	= 1;
	self.nocorpsedelete 	= 1;
		
	flag_wait( "lobby_scene_pre_animate" );	
	
	if( self.animation == "airport_civ_in_line_13_C" )
	{
		self.deathanim = %exposed_death_falltoknees;
		wait .7;
	}
	else
		self.deathanim = %exposed_death_twist;
		
	self.health = 1;
	node thread anim_generic( self, self.animation );
	self set_allowdeath( true );
	self.noragdoll 	= 1;
//	self.a.nodeath 	= 1;
	
//	wait 1;

	flag_wait( "lobby_open_fire" );
	wait randomfloatrange( .15, .25 );
		
	self kill();
}

#using_animtree( "generic_human" );
lobby_people_logic()
{
	self endon( "death" );
	
	self thread lobby_people_cleanup();
	
	if( !isdefined( level.lobby_people_animating ) )
		level.lobby_people_animating = 0;
	level.lobby_people_animating++;
	
	node = self.ref_node;
	
	node thread anim_generic( self, self.anime );
	wait .05;
	self stopanimscripted();
	node anim_generic_first_frame( self, self.anime );
	
	self thread do_lobby_player_fire();
	
	flag_wait( "lobby_scene_animate" );	
	
	self script_delay();
	
	self thread do_blood_notetracks();
	self.health = 1000000;
	
	if( isdefined( self._deathanim ) )
	{
		node thread anim_generic( self, self.anime );
		
		wait self.deathtime;
		
		self stopanimscripted();
		self anim_generic( self, self._deathanim );
	}
	else
	if( self.anime == "airport_civ_in_line_6_C" )
	{
		
		node thread anim_generic( self, self.anime );
				
		length = getanimlength( self getgenericanim( self.anime ) );
		length -= .2;
		wait length;
		
		node = spawnstruct();
		node.origin = self.origin;
		node.angles = self.angles + (0,180,0);
		node anim_generic( self, "run_death3" );		
	}
	else
		node anim_generic( self, self.anime );
	
	self.noragdoll 		= 1;
	self.skipdeathanim	= 1;
	
	if( isdefined( self.deleteme ) )
		self delete(); 	
	else
		self kill();
}

lobby_people_cleanup()
{
	self waittill( "death" );
	
	level.lobby_people_animating--;
	if( !level.lobby_people_animating )
		flag_set( "lobby_to_stairs_go" );	
}

lobby_drone_logic()
{	
	self lobby_generic_logic();
	
	if( isdefined( self ) )
		self notify( "move" );
		
	while( !flag( "player_set_speed_stairs" ) )
	{		
		wait .2;
		
		if( !isdefined( self ) )
			break;
		/*-----------------------
		KEEP LOOPING IF ANY PLAYERS TOO CLOSE OR CAN BULLETTRACE
		-------------------------*/
		if ( distancesquared( self.origin, level.player.origin ) < squared( 2048 ) )
			continue;
		if ( player_looking_at( self.origin + ( 0, 0, 48 ) ) )
			continue;			
		/*-----------------------
		ALL TESTS PASSED, DELETE THE BASTARD
		-------------------------*/
		break;
	}
	
	if( isdefined( self ) )
		self delete();
}

lobby_generic_logic()
{	
	self endon( "death" );
			
	self.maxhealth = 1;
	self.health = 1;
	self.ignoreexplosionevents = true;	
	self.ignoreme = true;
	if( issentient( self ) )
		self.ignorerandombulletdamage = true;
	else
		self enable_ignorerandombulletdamage_drone();
	self.grenadeawareness = 0;
	self disable_surprise();
	
	anime = self.script_animation;
	
	if( !isdefined( anime ) )
		anime = "civilian_stand_idle";
	
	self set_allowdeath( true );
	self delaythread( randomfloatrange( 0, 3 ), ::anim_generic_loop, self, anime );
	
	if( isdefined( self.script_noteworthy ) && ( self.script_noteworthy == "crawler" || self.script_noteworthy == "crawler2" ) )
		self lobby_generic_logic_crawlers();
	else
		self lobby_generic_non_crawlers();
}

lobby_generic_non_crawlers()
{
	if( isai( self ) )
	{		
		self thread deletable_magic_bullet_shield();
		self.a.disablePain = 1;
	}
	
	flag_wait( "lobby_open_fire" );
		
	wait .5;
	
	self notify( "stop_loop" );
	self stopanimscripted();
}

lobby_generic_logic_crawlers()
{
	if( self.script_noteworthy == "crawler" )
	{
		self.oldcontents = self setcontents( 0 );
		self force_crawling_death( 180, 5 );
	}
	else
	if( self.script_noteworthy == "crawler2" )
		self force_crawling_death( 110, 3, level.scr_anim[ "crawl_death_1" ] );
	
	flag_wait( "lobby_open_fire" );
		
	wait .5;
	
	self notify( "stop_loop" );
	self stopanimscripted();
	
	if( self.script_noteworthy == "crawler2" )
		{
			self dodamage( 1, level.player.origin );
		}
		else
		if( self.script_noteworthy == "crawler" )
		{
			self dodamage( 1, level.player.origin );
			
			wait 8;
			//iprintlnbold( "canshoot" );
			self setcontents( self.oldcontents );	
			wait 11;
			//iprintlnbold( "can NOT shoot" );
			self setcontents( 0 ); 	
			wait 5;
			//iprintlnbold( "canshoot" );
			self setcontents( self.oldcontents );	
		}
}	
		
stair_top_terror()
{
	flag_wait( "lobby_to_stairs_flow" );
	flag_waitopen( "lobby_to_stairs_flow" );
	flag_wait( "lobby_to_stairs_flow" );
	
	wait 11;//"lobby_cleanup"
	
	org = getent( "upperdeck_terror", "targetname" );
	org playloopsound( "scn_airport_crowd_stairs_loop" );
		
	flag_wait_or_timeout( "stairs_top_open_fire", 9.5 );
	
	org stoploopsound();
	org playsound( "scn_airport_crowd_stairs_end" );
}

lobby_to_stairs_flow_spawner()
{
	self waittill( "spawned" );
	
	wait 1;
	
	flag_clear( "lobby_to_stairs_flow" );
	level.lobby_to_stairs_flow = undefined;
		
	wait 8;
	
	self.count = 1;
	self spawn_ai();
}

lobby_to_stairs_flow_snd_scape( snd )
{
	flag_wait( "lobby_to_stairs_flow" );
	wait .1;
		
	thread running_civ_soundscape( level.lobby_to_stairs_flow, snd );
}

lobby_to_stairs_flow()
{
	self endon( "death" );
	self.interval = 50;
	self.health = 1;
	
	if( !isdefined( level.lobby_to_stairs_flow ) )
		level.lobby_to_stairs_flow = [];
	
	level.lobby_to_stairs_flow[ level.lobby_to_stairs_flow.size ] = self;
		
	flag_set( "lobby_to_stairs_flow" );
		
	self thread lobby_to_stairs_flow_stairsanim();
	
	self add_wait( ::waittill_msg, "reached_path_end" );
	self add_call( ::delete );
	self thread do_wait();
					
	while( !flag( "stairs_top_open_fire" ) )
	{		
		wait .2;
		
		/*-----------------------
		KEEP LOOPING IF ANY PLAYERS TOO CLOSE OR CAN BULLETTRACE
		-------------------------*/
		if ( distancesquared( self.origin, level.player.origin ) < squared( 2048 ) )
			continue;
		if ( player_looking_at( self.origin + ( 0, 0, 48 ) ) )
			continue;
					
		/*-----------------------
		ALL TESTS PASSED, DELETE THE BASTARD
		-------------------------*/
		self delete();	
	}
	
	wait 1;
	self kill();
}

lobby_to_stairs_flow_stairsanim()
{
	self endon( "death" );
	
	self waittill( "goal" );
	wait .5;
	self set_generic_run_anim_array( "stairs_up", "stairs_up_weights" );
	
	self waittill( "goal" );	
	self set_generic_run_anim_array( "civ_run_array" );
}

running_civ_soundscape( array, alias )
{
	array = array_removedead( array );
	origin = get_average_origin( array );
	obj = spawn( "script_origin", origin + (0,0,64) );
	//obj setmodel( "weapon_us_smoke_grenade" );
	obj playsound( alias );
	
	time = .1;
	
	while( array.size )
	{
		origin = get_average_origin( array );
		obj moveto( origin + (0,0,64), time );
		
		wait time;
		
		array = array_removedead( array );	
	}
	
	obj stopsounds();
	wait .05;
	obj delete();
}

#using_animtree( "generic_human" );
intro_security_run_die()
{
	self endon( "death" );
	
	self setgoalpos( self.origin );
	self.goalradius = 16;
	self.ignoreme = true;
	self.ignoreall = true;
	self.ignoresuppression = 1;
	self disable_surprise();
	self.disableBulletWhizbyReaction = true;
	self.a.disablePain = true;
	self thread deletable_magic_bullet_shield();
	
	wait 1;			
				
	switch( self.script_animation )
	{
		case "airport_security_guard_2":
			innerdoor = getent( "security_door_early", "targetname" );
			innerdoor connectpaths();
			innerdoor notsolid();
			
			innerdoor delaycall( 3.35, ::rotateyaw, 80, .6, .05, .35 );	
			innerdoor delaycall( 6.5, ::rotateyaw, -80, 2 );
			innerdoor delaycall( 8, ::solid );
			
			self.deathanim = %airport_security_guard_2_reaction;
			break;
		case "airport_security_guard_4":			
			self.deathanim = %airport_security_guard_4_reaction;
			wait 1.5;
			break;	
		case "airport_security_guard_3":
			self.deathanim = %airport_security_guard_3_reaction;
			wait .5;
			break;
	}	
	
	//wait 3.25;
	wait 2.25;
	
	self gun_remove();
			
	node = getstruct( self.target, "targetname" );
	
	node anim_generic_reach( self, self.script_animation );
	
	if( self.script_animation == "airport_security_guard_4" )
		thread intro_security_run_explosion();
	
	self.a.nodeath 	= true;
	self.noragdoll = true;
		
	if( self.script_animation == "airport_security_guard_2" )
	{
		door = getent( "lobby_security_door", "targetname" );
		model = getent( "lobby_security_door_model", "targetname" );
		model linkto( door );
		
		door delaythread( .8, ::_rotateyaw, 60, .5, .05, .35 );	
	}
	if( self.script_animation == "airport_security_guard_4" )
		self forceuseweapon( self.sidearm, "primary" );
	
	if( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	self.a.nodeath 		= false;
	self.noragdoll 		= undefined;
	self.a.disablePain 	= false;
	self.health 		= 100000;
	
	self thread intro_security_run_wait_die();
	node anim_generic( self, self.script_animation );	
			
	self kill();
}

intro_security_run_explosion()
{
	wait .9;
		
	level.makarov.grenadeAmmo++ ;	
	vec = (0,0,-1);	
	timex = 1;
	level.makarov magicgrenademanual( (5902, 2208, 96), vec, timex );
}

intro_security_run_wait_die()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "damage", amt, attacker );
		if( isplayer( attacker ) )
			break;
	}
	
	self.allowdeath = true;
	self kill();	
}

lobby_ai_logic()
{
	self endon( "death" );
	
	self lobby_generic_logic();
	
	if( !isdefined( level.lobby_ai_peeps ) )
		level.lobby_ai_peeps = 0;
	level.lobby_ai_peeps++;
	
	self thread lobby_ai_logic_death();	
	
	if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "new_lobby_people" )
		self thread lobby_ai_new();
	else
		self thread lobby_ai_run();
}

lobby_ai_logic_death()
{
	self waittill( "death" );
	level.lobby_ai_peeps--;
	
	if( level.lobby_ai_peeps == 0 )
		flag_set( "lobby_ai_peeps_dead" );
}

lobby_ai_new()
{	
	flag_wait( "lobby_to_stairs_go" );
	
	wait .5;
	
	self endon( "death" );
	
	self.a.disablePain = false;
	self stop_magic_bullet_shield();
	
	switch( self.animation )
	{
		case "unarmed_cowercrouch_react_B":
			self thread anim_generic_loop( self, "unarmed_cowercrouch_idle" );
			break;
		case "airport_civ_cellphone_hide":
			self thread anim_generic_first_frame( self, self.animation );
			self.deathanim = %airport_civ_cellphone_death;
			break;
		case "coup_civilians_interrogated_civilian_v3":
			self thread instant_ragdoll();
		default:
			self thread anim_generic_loop( self, self.animation );
			break;
	}
	flag_wait( "lobby_cleanup" );
	
	switch( self.animation )
	{
		case "unarmed_cowercrouch_react_B":
			wait 1.5;
			self thread anim_generic( self, self.animation );
			break;
		case "airport_civ_cellphone_hide":
			wait .65;
			self anim_generic( self, self.animation );
			self bodyshot( "killshot" );
			self kill();
			break;
	}
	
	flag_wait( "lobby_cleanup_spray" );
	
	switch( self.animation )
	{
		case "cliffhanger_capture_Price_idle":
			wait .5;
			self notify( "stop_loop" );
			self stopanimscripted();
			self.health = 1;
			
			self.allowdeath = 1;
			self thread anim_generic( self, "stand_2_run_L" );
			self.deathanim = %run_death_facedown;
			
			time = getanimlength( getanim_generic( "stand_2_run_L" ) );
			wait time - .2;
			
			self stopanimscripted();
			self bodyshot( "bodyshot" );
			self thread anim_generic( self, "run_pain_fallonknee" );
			
			//self.deathanim = %coverstand_death_left;
			wait 1.25;
			self.noragdoll = 1;
			self bodyshot( "killshot" );
			self kill();
			break;
		
		case "unarmed_cowercrouch_react_B":
			wait 2.75;
			self bodyshot( "killshot" );
			self kill();	
			break;
			
		case "coup_civilians_interrogated_civilian_v3":
			wait .25;
			self bodyshot( "killshot" );
			self kill();
			break;
	}
}

instant_ragdoll()
{
	self.a.nodeath = true;
	self waittill( "damage" );
	self startragdoll();	
}

lobby_ai_run()
{	
	if( isdefined( self.script_noteworthy ) && ( self.script_noteworthy == "crawler" || self.script_noteworthy == "crawler2" ) )
		return;
		
	self endon( "death" );
	
	node = getstruct( self.target, "targetname" );
	
	self Set_Generic_Run_Anim_Array( "civ_run_array" );
	reach = node.script_animation + "_reach";
	
	node anim_generic_reach( self, reach );
	node thread anim_generic_loop( self, node.script_animation );
	
	flag_wait( "lobby_to_stairs_go" );
	
	wait .5;
	self.a.disablePain = false;
	self stop_magic_bullet_shield();
	self.allowdeath = true;
	
	flag_wait( "lobby_cleanup" );
	
	self.ignorerandombulletdamage = true;
	self.health = 1;
	
	if( node.script_animation == "unarmed_cowercrouch_idle" )
	{
		node notify( "stop_loop" );
		self anim_generic( self, "unarmed_cowercrouch_react_A" );
		self thread anim_generic_loop( self, "unarmed_cowerstand_pointidle" );
		wait .4;
	}
	
	flag_wait( "lobby_cleanup_spray" );
	
	switch( node.script_animation )
	{
		case "cliffhanger_capture_Price_idle":
			
			node notify( "stop_loop" );
			self notify( "stop_loop" );
			self stopanimscripted();
			self.health = 1;
			
			self.allowdeath = 1;
			self thread anim_generic( self, "stand_2_run_L" );
			wait 1;
			self.deathanim = %run_death_roll;
			self.noragdoll = 1;
			self bodyshot( "killshot" );
			self kill();
			break;
		
		case "exposed_squat_idle_grenade_F":
			wait .5;
			
			node notify( "stop_loop" );
			self notify( "stop_loop" );
			self stopanimscripted();
			self.health = 1;
			
			self.allowdeath = 1;
			self thread anim_generic( self, "crouch_2run_L" );
			wait 1;
			self.deathanim = %run_death_facedown;
			self.noragdoll = 1;
			self bodyshot( "killshot" );
			self kill();
			break;
		
		case "unarmed_cowercrouch_idle":
			node notify( "stop_loop" );
			self notify( "stop_loop" );
			self stopanimscripted();
			self.health = 1;
			
			node = getstruct( node.target, "targetname" );
			node anim_generic_reach( self, node.script_animation );			
			
			//self.a.nodeath 	= true;
			self.ignorerandombulletdamage = true;
			
			node thread anim_generic( self, node.script_animation );
			self thread instant_ragdoll();

			wait 1;
			self bodyshot( "killshot" );
			self kill();
			break;
			
		case "coup_civilians_interrogated_civilian_v1":
			
			node notify( "stop_loop" );
			self notify( "stop_loop" );
			self stopanimscripted();
			self.health = 1;
			
			self.allowdeath = true;
			self enable_exits();
						
			node = getstruct( node.target, "targetname" );
			node anim_generic_reach( self, node.script_animation );
			
			self.ignorerandombulletdamage = true;
			node thread anim_generic( self, node.script_animation );
			break;
	}
}

lobby_moveout( node )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
					
	self enable_calm_combat();
	self.combatmode	= "cover";
	self.noreload = true;	
	
	self thread lobby_open_fire( node );
}

lobby_open_fire( node )
{	
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	flag_wait( "lobby_open_fire" );	
	
	self.goalradius = 8;
	self setgoalpos( self.origin );
	//self orientmode( "face angle", node.angles[1] );
		
	delay 	= undefined;
	speed 	= undefined;
	forward = undefined;
	time 	= 7.5;
		
	switch( self.script_noteworthy )
	{
		case "saw":
			speed = 1.25;
			forward = true;
			delay = .05;
			time += .5;
			break;
		case "shotgun":
			speed = .85;
			forward = false;
			delay = .5;
			time += .1;
			break;
		case "makarov":
			speed = 1.05;
			forward  = true;
			delay = .25;
			time += .15;
			break;
		case "m4":
			speed = 1.45;
			forward = false;
			delay = .3;
			time += .25;
			break;
	}	
	
	self stopanimscripted();
	self thread spray_and_pray( delay, speed, forward );
//	flag_wait( "lobby_to_stairs_go" );
	wait time;
	
	self notify( "stop_spray_and_pray" );
	
//	if( self.script_noteworthy == "saw" )
//		return;
	
//	self thread anim_single_run_solo( self, "stand_reload" );	
	
		
}

lobby_moveout_to_stairs_makarov( node )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	level.lobby_cleanup = 0;
		
	time = 16.5;	
	
	delaythread( time, ::set_generic_run_anim, "casual_killer_walk_R", true );
	delaythread( time, ::set_moveplaybackrate, 1.0 );
	delaythread( time + .75, ::fire_full_auto, .1, "stop_spray_and_pray" );
			
	wait 1.5;
	self stopanimscripted();
		
	self set_moveplaybackrate( 1.15 );
	self disable_arrivals();
	
	self follow_path( node );
	self notify( "stop_spray_and_pray" );			
	
	self lobby_moveout_to_stairs_post();
	if( flag( "player_set_speed_stairs" ) )
		return;
		
	level endon( "player_set_speed_stairs" );	
	
	self set_moveplaybackrate( 1.25 );
	delaythread( 5, ::set_moveplaybackrate, 1.0 );
	
	self set_generic_run_anim( "casual_killer_walk_R" ); 
	wait 1;
	self set_generic_run_anim( "casual_killer_walk_F" ); 
	
	self enable_arrivals();
	
	wait 4.5;	
	if( !flag( "lobby_ai_peeps_dead" ) )
	{	
		self set_generic_run_anim( "casual_killer_walk_L" );
		wait .5;
		thread fire_full_auto( .1, "stop_spray_and_pray" );
		delaythread( 2.0, ::send_notify, "stop_spray_and_pray" );
	}				
	flag_wait( "stairs_go_up" );
	self set_generic_run_anim( "casual_killer_jog_A" );	
	//Up the stairs. Go.
	self radio_dialogue( "airport_mkv_upstairs" );
	
	//thread lobby_player_allow_sprint();
}

lobby_player_allow_sprint()
{
	flag_clear( "player_dynamic_move_speed" );
	wait .05;
	level.player AllowSprint( true );

	flag_wait( "player_set_speed_upperstairs" );
	
	thread player_dynamic_move_speed();
}

lobby_moveout_to_stairs_saw( node )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	level.lobby_cleanup = 0;
		
	self set_moveplaybackrate( 1.2 );
	
	self disable_arrivals();
	self add_wait( ::waittill_msg, "goal" );
	self add_func( ::delaythread, 1, ::enable_arrivals );
	thread do_wait();
	
	time = 12;
	delaythread( time, ::fire_full_auto, .1, "stop_spray_and_pray" );
	delaythread( time + 2, ::send_notify, "stop_spray_and_pray" );
	time += 3;
	delaythread( time, ::fire_full_auto, .1, "stop_spray_and_pray" );
	delaythread( time + 4.5, ::send_notify, "stop_spray_and_pray" );
	
	self stopanimscripted();
	
	thread follow_path( node );
	
	node waittill( "trigger" );
		
	self waittill( "reached_path_end" );
	
	flag_wait( "lobby_cleanup_spray" );
	
	self set_moveplaybackrate( 1.0 );
	
	if( !flag( "lobby_ai_peeps_dead" ) )
	{	
		self thread spray_and_pray();
			
		wait 4;
		
		self notify( "stop_spray_and_pray" );
	}	 
	wait .5;		
			
	self lobby_moveout_to_stairs_post();
	if( flag( "player_set_speed_stairs" ) )
		return;
			 
	self set_generic_run_anim( "casual_killer_jog_A" );	 
}

lobby_moveout_to_stairs_m4( node )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	level.lobby_cleanup = 0;
					
	wait 1;
	
	self stopanimscripted();
	
	self disable_arrivals();
	self add_wait( ::waittill_msg, "goal" );
	self add_func( ::delaythread, 1, ::enable_arrivals );
	thread do_wait();
	
	self set_moveplaybackrate( 1.15 );
	self delaythread( 10, ::set_moveplaybackrate, 1.2 );
	follow_path( node );
	self set_moveplaybackrate( 1.0 );			
	wait .5;
	
	flag_wait( "lobby_cleanup_spray" );
	
	if( !flag( "lobby_ai_peeps_dead" ) )
	{	
		self thread spray_and_pray();
		
		wait 4;
		
		self notify( "stop_spray_and_pray" );
	}
				
	self lobby_moveout_to_stairs_post();
	if( flag( "player_set_speed_stairs" ) )
		return;
	
	self set_generic_run_anim( "casual_killer_jog_A" );	
}

lobby_moveout_to_stairs_shotgun( node )
{	
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	level.lobby_cleanup = 0;
		
	self disable_arrivals();
	self set_moveplaybackrate( 1.2 );								
	
	time = 8.5;
	delaythread( time, ::fire_full_auto, .3, "stop_spray_and_pray" );
	delaythread( time + 1, ::send_notify, "stop_spray_and_pray" );
	time += 5.5;
	delaythread( time, ::fire_full_auto, .3, "stop_spray_and_pray" );
	delaythread( time + 2, ::send_notify, "stop_spray_and_pray" );
	time += 3;
	delaythread( time, ::fire_full_auto, .3, "stop_spray_and_pray" );
	delaythread( time + 2, ::send_notify, "stop_spray_and_pray" );
	
	delaythread( time + 1, ::enable_arrivals );
	self stopanimscripted();
			
	follow_path( node );
	flag_set( "lobby_cleanup" );
	thread flag_set_delayed( "lobby_cleanup_spray", 2.5 );
	
	self set_moveplaybackrate( 1.0 );
									
	wait .5;
	
	flag_wait( "lobby_cleanup_spray" );
	
	if( !flag( "lobby_ai_peeps_dead" ) )
	{	
		self thread spray_and_pray( .1, .25, false );
		
		wait 4;
		
		self notify( "stop_spray_and_pray" );
	}
			
	self lobby_moveout_to_stairs_post();
	if( flag( "player_set_speed_stairs" ) )
		return;
	
	self set_generic_run_anim( "casual_killer_jog_A" );	
}

lobby_moveout_to_stairs_post()
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	self ent_flag_set( "prestairs_nodes" );	
	level.lobby_cleanup++;
	
	if( level.lobby_cleanup == 4 )
	{
		if( !flag( "player_set_speed_stairs" ) )
			thread flag_set_delayed( "stairs_go_up", 1 );
		else
			flag_set( "stairs_go_up" );
	}	
	if( flag( "player_set_speed_stairs" ) )
		self clear_run_anim();
}

lobby_moveout_to_stairs( node )
{	
	func = [];
	
	func[ "makarov" ] 	= ::lobby_moveout_to_stairs_makarov;
	func[ "shotgun" ] 	= ::lobby_moveout_to_stairs_shotgun;
	func[ "m4" ] 		= ::lobby_moveout_to_stairs_m4;
	func[ "saw" ] 		= ::lobby_moveout_to_stairs_saw;
	
	self [[ func[ self.script_noteworthy ] ]]( node );
}

lobby_prestairs_nodes_behavior( node )
{
	if( self != level.makarov )
		return;
		
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	level endon( "stairs_go_up" );
	
	self add_wait( ::ent_flag_wait, "prestairs_nodes" );
	do_wait_any();
	
	self setgoalnode( node );
	self.goalradius = 16;
}

/************************************************************************************************************/
/*												UPPERDECK													*/
/************************************************************************************************************/
stairs_team_at_top( node )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	flag_wait( "stairs_go_up" );
	
	self.ignoreall = false;
	self.ignoreme = false;
	self.moveplaybackrate = 1.0;
	self.noreload = true;
	
	switch( self.script_noteworthy )
	{
		case "saw":
			speed = 1;
			forward = true;
			delay = .05;
			break;
			
		case "shotgun":
			wait .1;
			speed = 1.2;
			forward = false;
			delay = .1;
			break;
			
		case "makarov":
			wait .25;
			speed = 0.8;
			forward  = true;
			delay = .5;
			
			id = getglass( "upperdeck_glass_roof_1" );
			self add_wait( ::waittill_msg, "reached_path_end" );
			add_func( ::noself_delayCall, 4, ::DestroyGlass, id, (0,0,-1) );
			thread do_wait();
			break;
		case "m4":
			wait .05;
			speed = 0.7;
			forward = false;
			delay = .05;
			break;
	}	
	
	self disable_arrivals();	
	self thread follow_path( node, 5000 );
	
	node waittill( "trigger" );
	
	self maps\_casual_killer::disable_casual_killer();
	self walkdist_zero();
	waittillframeend;
	
	self clear_run_anim();	
	
	self delaythread( 1, ::enable_arrivals );
	
	self waittill( "reached_path_end" );	
	
	delaythread( .5, ::activate_trigger, "upperdeck_civ", "target" );
	
	self maps\_casual_killer::enable_casual_killer();
	wait 1;
		
	flag_set( "stairs_top_open_fire" );
	self ent_flag_set( "stairs_at_top" );
	if( flag( "stairs_upperdeck_civs_dead" ) )
		return;
	speed 	= undefined;
	delay 	= undefined;
	forward = undefined;
		
	self stopanimscripted();
	node = getnode( node.target, "targetname" );
	self orientmode( "face angle", node.angles[1] );
	
	switch( self.script_noteworthy )
	{
		case "saw":
		case "shotgun":
			wait .25;
			break;
		default:
			wait .75;
			break;
	}
	
	self thread spray_and_pray( delay, speed, forward );
				
	flag_wait( "stairs_upperdeck_civs_dead" );
	self notify( "stop_spray_and_pray" );
}

upperdeck_team_moveup( node )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	self ent_flag_wait( "stairs_at_top" );
	self clear_run_anim();
	self disable_arrivals();
	
	self maps\_casual_killer::enable_casual_killer();
	
	switch( self.script_noteworthy )
	{
		case "makarov":
			self.moveplaybackrate = 1;
			self upperdeck_makarov_moveup( node );
			break;
		case "m4":
			self.moveplaybackrate = 1.45;
			break;
		case "shotgun":
			self.moveplaybackrate = 1.35;
			break;
		case "saw":
			self.moveplaybackrate = 1.34;
			break;
	}
	
	if( self.script_noteworthy == "makarov" )
		return;
			
	self follow_path( node, 5000 );
			
	self thread ent_flag_set_delayed( "massacre_ready", .15 );
}

upperdeck_makarov_moveup( node )
{	
	self thread follow_path( node, 5000 );
	
	wait 2.5;
	
	self disable_exits();
	self disable_dynamic_run_speed();	

	self anim_generic_run( self, "casual_killer_walk_wave" );	
	
	wait .2;
	
	self enable_exits();
	if( flag( "massacre_rentacop_stop" ) )
		return;
		
	self set_moveplaybackrate( .9, 2 );
		
	flag_wait( "upperdeck_mak_spray" );
	
	self disable_arrivals();	
	self set_moveplaybackrate( 1, .5 );
	self anim_generic( self, "casual_killer_walk_stop" );
	
	self notify( "_utility::follow_path" );
	self setgoalpos( self.origin );
	self.goalradius = 8;
	
	self.upperdeck_enemies++;	
	self thread spray_and_pray();
	
	self notify( "upperdeck_canned_deaths_execute_fire" );
	self maps\_casual_killer::set_casual_killer_run_n_gun( "straight" );
	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	
	wait 3;
	self notify( "stop_spray_and_pray" );
	self.upperdeck_enemies--;
			
	node = getstruct( "stairs_mak_point", "script_noteworthy" );
	self ent_flag_clear( "massacre_ready" );
	
	self add_wait( ::waittill_msg, "reached_path_end" );
	self add_func( ::ent_flag_set_delayed, "massacre_ready", .15 );
	thread do_wait();
	
	self thread follow_path( node );
	node waittill( "trigger" );
	
	if( flag( "massacre_rentacop_stop" ) )
		return;
		
	self disable_exits();
	self disable_dynamic_run_speed();	
	
	//thread radio_dialogue( "airport_mkv_runner" );	
	node anim_generic_run( self, "casual_killer_walk_point" );	
	
	self set_moveplaybackrate( 1.35 );
	
	wait .2;
	
	self enable_exits();
	self disable_arrivals();
}

upperdeck_turn_on_arrival()
{
	self waittill( "trigger", actor );
	
	if( actor == level.makarov )
		return;
	
	actor enable_arrivals();	
}

stairs_cop()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	time = 3;
	_flag = "upperdeck_flow1";
	
	self.ignorerandombulletdamage = true;
	self thread cop_function( _flag, time );
	
	flag_wait( _flag );
	wait time;
	wait 1.5;
	
	if( !isalive( self ) )
		return;
		
	self.ignorerandombulletdamage = false;	
	level.team[ "saw" ] clearentitytarget();
	level.team[ "shotgun" ] clearentitytarget();
	
	origin = self.origin + (0,0,40);
	vec = anglestoforward( self.angles );
	origin = origin + vector_multiply( vec, 20 );
	
//	target = spawn( "script_model", origin );
//	target setmodel( "weapon_us_smoke_grenade" );
	target = spawn( "script_origin", origin );
	target.health = 100;
//	target linkto( self );
	level.team[ "saw" ] setentitytarget( target );
	level.team[ "shotgun" ] setentitytarget( target );
		
	self waittill( "death" );
	
	wait 1;
	
	if( isdefined( level.team[ "saw" ].spraypray_target ) )
		level.team[ "saw" ] setentitytarget( level.team[ "saw" ].spraypray_target );
	
	if( isdefined( level.team[ "shotgun" ].spraypray_target ) )
		level.team[ "shotgun" ] setentitytarget( level.team[ "shotgun" ].spraypray_target );
	
	target delete();
}

upperdeck_crawler()
{
	self.health = 1;
	self.ignoreexplosionevents = true;	
	self.ignoreme = true;
	self.ignorerandombulletdamage = true;
	self.grenadeawareness = 0;
	self disable_surprise();
	self.a.pose = "prone";
	//self.dieQuietly = true;
	
	self endon( "death" );
		
	switch( self.script_noteworthy )
	{
		case "upperdeck_crawlers_1":	
			self anim_generic_first_frame( self, "civilian_crawl_1" );
			self force_crawling_death( self.angles[ 1 ], 5, level.scr_anim[ "crawl_death_1" ], 1 );
			break;
		
		case "upperdeck_crawlers_wait":
			self anim_generic_first_frame( self, "civilian_crawl_2" );
			self force_crawling_death( self.angles[ 1 ], 3, level.scr_anim[ "crawl_death_2" ], 1 );
			break;
		case "upperdeck_crawlers2":
			self anim_generic_first_frame( self, "civilian_crawl_2" );
			self force_crawling_death( self.angles[ 1 ], 5, level.scr_anim[ "crawl_death_2" ], 1 );
			break;
			
		default:
			self anim_generic_first_frame( self, "dying_crawl" );
			self force_crawling_death( self.angles[ 1 ], 5, undefined, 1 );	
			break;
	}	
	
	if( self.script_noteworthy == "upperdeck_crawlers_wait" )
	{
		self add_wait( ::waittill_entity_in_range, level.player, 550 );
		level add_wait( ::_wait, 16 );
		do_wait_any();
	}
	else
		wait randomfloat( 1.5 );
	
	self dodamage( 1, level.player.origin );
	
	self.noragdoll = 1;
	
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	flag_wait( "stairs_upperdeck_civs_dead" );
	
	//self.dieQuietly = false;
		
	if( isdefined( self.script_parameters ) )
	{	
		actor = level.team[ self.script_parameters ];	
		while( distance( self.origin, actor.origin ) > 250 )
			wait .1;
		self.script_delay = 1.5;
		actor thread upperdeck_canned_deaths_execute( self, "down" );
		
		wait .5;
		self.ignorerandombulletdamage = false;
		wait 1.5;
		magicbullet( actor.weapon, actor gettagorigin( "tag_flash" ), self geteye() );
	}
}

upperdeck_initial_runners()
{
	self endon( "death" );
	self upperdeck_runners_setup();
	
	flag_wait( "stairs_top_open_fire" );
	
	if( !flag( "player_set_speed_stairs" ) )
	{
		flag_wait_or_timeout( "player_set_speed_stairs", 5 );
		wait 1.5;
	}
			
	thread stairs_upperdeck_civs_dead();
	flag_set( "upperdeck_flow1" );
	upperdeck_runners_go();
}

stairs_upperdeck_civs_dead()
{
	wait 6.5;
	flag_wait( "stairs_cop_dead" );
	flag_set( "stairs_upperdeck_civs_dead" );
}

upperdeck_runners3()
{
	self endon( "death" );	
	flag_wait( "massacre_rentacop_stop_dead" );	
	wait 2.0;
	
	self.useChokePoints 				= false;
	flag_set( "upperdeck_flow3" );
	
	if( !isdefined( level.upperdeck_flow3 ) )
	{
		level.upperdeck_flow3 = [];
		level.upperdeck_flow3[ level.upperdeck_flow3.size ] = self;
		wait .1;
		thread running_civ_soundscape( level.upperdeck_flow3, "scn_airport_running_screams2" );
	}
	else
		level.upperdeck_flow3[ level.upperdeck_flow3.size ] = self;
	
	upperdeck_runners_go();
}

upperdeck_runners_more( _flag )
{
	self endon( "death" );
	self upperdeck_runners_setup();
	
	flag_set( _flag );
	
	wait 1;
	
	upperdeck_runners_go();
}

upperdeck_runners_setup()
{
	waittillframeend; //->because civilian subclass script isn't finished running...which is weak - subclass scripts should run before any spawnfuncs do
	self.allowdeath = true;
	self.health = 1;
	self.interval = 0;
	self.disableBulletWhizbyReaction = true;
	self.ignoreall = true;
	self disable_surprise();
	self set_generic_run_anim_array( "civ_run_array" );
	self notify( "killanimscript" );
	
	if( issubstr( self.classname, "female" ) )
		self.animname = "female_civ_" + randomintrange( 1,2 );
	else
		self.animname = "male_civ_" + randomintrange( 1,2 );
	
	if( self.script_animation == "airport_civ_cellphone_hide" )
		self thread anim_generic_first_frame( self, self.script_animation );
	else
		self thread anim_generic_loop( self, self.script_animation );
}

upperdeck_runners_go()
{
	self.health = 1;
	
	if( self.script_animation != "null" )
		wait randomfloat( 1 );
			
	self notify( "stop_loop" );
	self stopanimscripted();
	
	if( self.script_animation == "airport_civ_cellphone_hide" )
		self thread anim_generic_run( self, "crouch_2run_L" );
		
	node = getnode( "upperdeck_escape_node", "targetname" );
	
	if( isdefined( self.target ) )
		node = getnode( self.target, "targetname" );	
	
	self follow_path( node );
	
	wait randomfloat( 1.5 );
	
	self bodyshot( "killshot" );	
	self kill();	
}

upperdeck_canned_deaths_setup( _flag )
{
	if( isdefined( self.target ) )
	{
		mate = getent( self.target, "targetname" );
		mate thread upperdeck_canned_deaths_setup( _flag );
	}
	
	drone = undefined;
	
	flag_wait( _flag );
	
	if( isspawner( self ) )
		drone = spawn_ai( true );
	else
	{
		name = undefined;
		if( issubstr( self.model, "female" ) )
			name = "civilian_female_suit";
		else
			name = "civilian_male_suit";
		
		spawner = getent( name, "targetname" );
		spawner.count = 1;
		drone = dronespawn( spawner );
	}	
		
	drone upperdeck_canned_deaths_grab_info( self );
	
	drone thread upperdeck_canned_deaths();	
}

upperdeck_canned_deaths_grab_info( node )
{	
	waittillframeend;
	self.ignoreme 			= true;
	self.allowdeath 		= true;
	self.noragdoll 			= 1;
	self.nocorpsedelete 	= 1;
	self.dontdonotetracks	= 1;
	self.script_noteworthy 	= node.script_noteworthy;
	self.radius 			= node.radius;
	self.enode 				= node;
	self.targetname			= node.targetname + "_drone";
	self.animname			= "generic";
	self.script_soundalias	= node.script_soundalias;
	self.script_linkto		= node.script_linkto;
	self.script_parameters	= node.script_parameters;
	self.health 			= 1;
	
	if( issentient( self ) )
		self.ignorerandombulletdamage = true;
	else
		self enable_ignorerandombulletdamage_drone();
	
	if( isdefined( node.script_wait ) )
		self.script_wait		= node.script_wait;
	else
		self.script_wait 		= 0;
		
	if( isdefined( node.target ) )
		self.target				= node.target + "_drone";
	
	if( isdefined( node.script_delay ) )
		self.script_delay 		= node.script_delay;
	else
		self.script_delay = getanimlength( getgenericanim( node.animation ) ) - .5;
	
	if( isdefined( node.script_flag_set ) )
	{
		self.script_flag_set	= node.script_flag_set;
		flag_init( self.script_flag_set );
		
		self add_wait( ::waittill_msg, "death" );
		add_func( ::flag_set, self.script_flag_set );
		thread do_wait();
	}
}

upperdeck_canned_deaths()
{
	self endon( "death" );
	
	self thread upperdeck_canned_deaths_cleanup();
	self thread do_lobby_player_fire();
	
	waittillframeend;//->some of the following functions require a partner which might not be initilized yet
			
	switch( self.enode.animation )
	{
		case "airport_civ_dying_groupB_pull":
			self upperdeck_canned_deaths_groupB_pull();
			break;
		case "airport_civ_dying_groupA_kneel":
			self upperdeck_canned_deaths_groupA_kneel();
			break;
		case "airport_civ_cellphone_hide":
			self upperdeck_canned_deaths_cellphone();
			break;
		case "airport_civ_pillar_exit":
			self upperdeck_canned_deaths_pillar();
			break;
		case "dying_crawl_back":
			self upperdeck_canned_deaths_dying_crawl_back();
			break;
		case "bleedout_crawlB":
			self upperdeck_canned_deaths_dying_crawl_back();
			break;
		case "DC_Burning_bunker_stumble":
			self upperdeck_canned_deaths_bunker_stumble();
			break;
		case "unarmed_cowercrouch_react_B":	
			self upperdeck_canned_deaths_cowercrouch();
			break;
		case "airport_civ_dying_groupA_lean":
			if( self.enode.targetname == "upperdeck_canned_deaths" )
				self upperdeck_canned_deaths_groupA_lean();
			break;
		case "civilian_leaning_death":
			self upperdeck_canned_deaths_leaning();
			break;
	}
}

upperdeck_canned_deaths_groupB_pull()
{
	mate = getent( self.target, "targetname" );
	self.deathanim = %airport_civ_dying_groupB_pull_death;
	mate.deathanim = %airport_civ_dying_groupB_wounded_death;
	
	//kill the mate if self dies
	self add_wait( ::waittill_msg, "death" );
	mate add_abort( ::waittill_msg, "death" );
	mate add_func( ::_kill );
	thread do_wait();
	
	//kill self if mate dies
	mate add_wait( ::waittill_msg, "death" );
	self add_abort( ::waittill_msg, "death" );
	self add_func( ::_kill );
	thread do_wait();
	
	self upperdeck_canned_deaths_group( mate );//, "down" );
	self kill();
}

upperdeck_canned_deaths_groupA_kneel()
{
	mate = getent( self.target, "targetname" );
	mate.skipdeathanim = 1;
	mate.noragdoll = 1;
	self.deathanim = %coverstand_death_right;
			
	self upperdeck_canned_deaths_group( mate );	
}

upperdeck_canned_deaths_cellphone()
{
	self.deathanim = %airport_civ_cellphone_death;
	
	self upperdeck_canned_deaths_single( "down" );
}

upperdeck_canned_deaths_groupA_lean()
{
	self.skipdeathanim = 1;
	self.noragdoll = 1;
	
	self upperdeck_canned_deaths_player();
}

upperdeck_canned_deaths_leaning()
{
	self.deathanim = %civilian_leaning_death_shot;
	self.noragdoll = 1;
	
	self upperdeck_canned_deaths_player();
}

upperdeck_canned_deaths_pillar()
{
	self.deathanim = %airport_civ_pillar_exit_death;
	
	self upperdeck_canned_deaths_single();
}

upperdeck_canned_deaths_dying_crawl_back()
{
	self.deathanim = %dying_back_death_v1;
	
	self upperdeck_canned_deaths_single( "down" );
}	

upperdeck_canned_deaths_bunker_stumble()
{
	self.deathanim = %corner_standR_deathB;
	
	self upperdeck_canned_deaths_single();
}

upperdeck_canned_deaths_cowercrouch()
{
	self.deathanim = %exposed_death_blowback;
	
	self upperdeck_canned_deaths_single();
}

upperdeck_canned_deaths_group( mate, type )
{
	//set into first frame
	self thread upperdeck_canned_deaths_first_frame();
	mate upperdeck_canned_deaths_first_frame();
	
	wait .05;//need to wait sometimes cause firstframe will be called after the wait function below returns ( instant wait return )
	
	//wait to animate
	killers = self upperdeck_canned_deaths_wait_animate();
	if( killers.size )
		array_thread( killers, ::upperdeck_canned_deaths_execute, self, type );
	
	if( issentient( self ) )
		self.ignorerandombulletdamage = false;
	else
		self disable_ignorerandombulletdamage_drone();
	mate disable_ignorerandombulletdamage_drone();
	
	//animate
	if( isdefined( self.script_soundalias ) )
		self delaythread( self.script_wait, ::play_sound_on_tag_endon_death, self.script_soundalias );
	if( mate.health > 0 )
	{
		if( isdefined( mate.script_soundalias ) )
			mate delaythread( mate.script_wait, ::play_sound_on_tag_endon_death, mate.script_soundalias );	
		
		self.enode add_wait( ::anim_generic, mate, mate.enode.animation );
		mate add_abort( ::waittill_msg, "death" );
		mate add_func( ::_kill );
		thread do_wait();
	}
	
	if( self.enode.animation == "airport_civ_dying_groupA_kneel" )
		self delaythread( 3.25, ::set_deathanim, "airport_civ_dying_groupA_kneel_death" );
	self.enode anim_generic( self, self.enode.animation ); 
	
	if( issentient( self ) )
	{
		self notify( "stop_loop" );
		self stopanimscripted();
		
		self follow_path( getnode( "upperdeck_escape_node", "targetname" ) );
	}
	self kill();
}

set_skipdeathanim( value )
{
	self.skipdeathanim = value;	
}

upperdeck_canned_deaths_player()
{
	//set into first frame
	self upperdeck_canned_deaths_first_frame();
	
	//wait to animate
	self add_wait( ::upperdeck_canned_deaths_wait_player_close );
	self add_wait( ::upperdeck_canned_deaths_wait_player_see );
	do_wait_any();
		
	//animate
	self.enode anim_generic( self, self.enode.animation ); 
	
	self.skipdeathanim = 1;
	self notify( "nocleanup" );
	self kill();
	self.enode delete();
}

upperdeck_canned_deaths_single( type )
{
	//set into first frame
	self upperdeck_canned_deaths_first_frame();
	
	//wait to animate
	killers = self upperdeck_canned_deaths_wait_animate();
	if( killers.size )
		array_thread( killers, ::upperdeck_canned_deaths_execute, self, type );
	
	if( issentient( self ) )
		self.ignorerandombulletdamage = false;
	else
		self disable_ignorerandombulletdamage_drone();
	
	//animate
	if( isdefined( self.script_soundalias ) )
		self delaythread( self.script_wait, ::play_sound_on_tag_endon_death, self.script_soundalias );
	self.enode anim_generic( self, self.enode.animation ); 
	
	if( issentient( self ) )
	{
		self notify( "stop_loop" );
		self stopanimscripted();
		
		self follow_path( getnode( "upperdeck_escape_node", "targetname" ) );
	}
	self kill();
}

upperdeck_canned_deaths_first_frame()
{
	self.enode thread anim_generic( self, self.enode.animation );	
	wait .05;
	self stopanimscripted();	
	self.enode anim_generic_first_frame( self, self.enode.animation );		
}

upperdeck_canned_deaths_wait_animate()
{	
	actors = [];
	array = strtok( self.script_noteworthy, ", " );	
	foreach( key, token in array )
	{
		if( isalive( level.team[ token ] ) )
			actors[ actors.size ] = level.team[ token ];
	}
	
	if( !actors.size )	
		return actors;
		
	flag_wait( "upperdeck_flow1" );
	
	while( actors.size )
	{
		//the first guy in the list or the only guy is what we test against
		actor = actors[ 0 ];
		if( distance( actor.origin, self.origin ) < self.radius )
			return actors;		
				
		wait .1;
		
		actors = array_removedead( actors );
	}
	
	return actors;
}

upperdeck_canned_deaths_wait_player_close()
{
	level.player endon( "death" );
	
	while( 1 )
	{
		if( distance( level.player.origin, self.origin ) < 600 )
			return;	
							
		wait .1;
	}	
}

upperdeck_canned_deaths_wait_player_see()
{
	level.player endon( "death" );
	
	while( 1 )
	{
		self waittill_player_lookat( undefined, .25, undefined, undefined, self );
		
		if( distance( level.player.origin, self.origin ) < 800 )
			return;	
		
		wait .1;
	}
}

upperdeck_canned_deaths_execute_wait( enemy )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	if( flag( "massacre_rentacop_stop" ) )
		return;
	level endon( "massacre_rentacop_stop" );
	
	flag_wait_or_timeout( "stairs_upperdeck_civs_dead", 2 );		
	
	origin = enemy.origin;
	msg = "enemy at " + origin + "ready to execute";
	aimtime = enemy.script_delay - 2;
	if( aimtime < 0 )
		return;
	
	self endon( msg );
	self thread notify_delay( msg, aimtime );
		
	while( enemy.health > 0 )
	{
		if( distance( enemy.origin, self.origin ) < 200 )
			return;	
		wait .1;	
	}
}

upperdeck_canned_deaths_execute_fire( enemy )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	if( flag( "massacre_rentacop_stop" ) )
		return;
	level endon( "massacre_rentacop_stop" );
	
	self endon( "upperdeck_canned_deaths_execute_fire" );
	
	targets = enemy get_linked_structs();
	foreach( obj in targets )
		delaythread( randomfloat( .25 ), ::_radiusdamage, obj.origin, 8, 1000, 1000 );
	
	time = .1;
	
	if( self == level.team[ "shotgun" ] )
		time = .25;
	self fire_full_auto( time, "upperdeck_canned_deaths_execute_fire" );
}

fire_full_auto( interval, msg )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	self endon( msg );
	
	fireAnim = self.combatStandAnims[ "fire" ];
	self setAnimKnobRestart( fireAnim, 1, .2, 1.0 );
	
	self add_wait( ::waittill_msg, msg );
	self add_call( ::clearanim, fireAnim, .2 );
	self thread do_wait();
	
	while( 1 )
	{
		self shoot();
		wait interval;
	}	
}

upperdeck_canned_deaths_execute( enemy, type )
{	
	self endon( "death" );
	
	if( flag( "massacre_rentacop_stop" ) )
		return;
	level endon( "massacre_rentacop_stop" );	
	
	if( enemy.health <= 0 )
		return;
				
	//set dont ever shoot at the right time if enemy is alive	
	self add_wait( ::_wait, enemy.script_delay );
	enemy add_abort( ::waittill_msg, "death" );
	self add_func( ::upperdeck_canned_deaths_execute_fire, enemy );
	thread do_wait();
	
	//wait to start aiming
	self upperdeck_canned_deaths_execute_wait( enemy );
			
	self maps\_casual_killer::set_casual_killer_run_n_gun( type );	
	self.dontevershoot = true;
	self disable_dynamic_run_speed();
	self ent_flag_set( "aiming_at_civ" );
	if( isdefined( enemy.script_flag_set ) )
		flag_set( enemy.script_flag_set );
		
	self.upperdeck_enemies++;
		
	target = spawn( "script_origin", enemy gettagorigin( "tag_eye" ) );
//	target = spawn( "script_model", enemy gettagorigin( "tag_eye" ) );
//	target setmodel( "weapon_us_smoke_grenade" );
	target.health = 100;
		
		self thread upperdeck_canned_deaths_execute_fake_target( enemy, target );
	
	wait .5;
		
	if( isdefined( enemy ) && isdefined( enemy.health ) && enemy.health > 0 )
		enemy waittill( "death" );
	
	self.upperdeck_enemies--;
	
	wait .25;
	self notify( "upperdeck_canned_deaths_execute_fire" );
	wait .25;
		
	target delete();
	
	
	if( self.upperdeck_enemies )
		return;
	
	self clearentitytarget();
	
	self ent_flag_clear( "aiming_at_civ" );
	self maps\_casual_killer::set_casual_killer_run_n_gun( "straight" );
}

upperdeck_canned_deaths_execute_fake_target( enemy, target )
{
	self endon( "death" );
	enemy endon( "death" );
	target endon( "death" );
				
	self setentitytarget( target );
	
	while( 1 )
	{
		start = self gettagorigin( "j_elbow_ri" );
		end = enemy gettagorigin( "tag_eye" );
		vec = vectornormalize( end - start );
		vec = vector_multiply( vec, 80 );
		
		origin = ( start + vec );
		//target moveto( origin, .1 );
		target.origin = origin;
		
		wait .05;
	}
}	

upperdeck_canned_deaths_cleanup()
{	
	self endon( "nocleanup" );
	
	node = self.enode;
	self waittill( "death" );
	if( isdefined( self ) )//check for deletion not death
	{
		self bodyshot( "killshot" );
		self playsound( "generic_death_russian_" + randomintrange( 1, 8 ) );
	}
	
	node delete();
}

upperdeck_fakesound()
{
	self waittill( "trigger" );
	
	node = getent( self.target, "targetname" );
	
	forward = anglestoforward( node.angles );
	end = node.origin + vector_multiply( forward, 512 );
	time = 8;
	
	node playsound( self.script_soundalias );
	node moveto( end, time );
	
	wait time;
	node delete();
	self delete();		
}

/************************************************************************************************************/
/*													MASSACRE												*/
/************************************************************************************************************/
massacre_rentacop_stop()
{
	flag_set( "massacre_rentacop_stop" );
	
	self add_wait( ::waittill_msg, "death" );
	self add_func( ::flag_set, "massacre_rentacop_stop_dead" );
	thread do_wait();
	
	self delaythread( .25, ::set_ignoreme, false );
	array_thread( level.team, ::enable_dontevershoot );
	
	foreach( member in level.team )
	{
		level add_wait( ::_wait, 1.5 );
		member add_func( ::disable_dontevershoot );
		self add_abort( ::waittill_msg, "death" );
		thread do_wait();
	}

	self cop_function();
}

cop_function( _flag, time )
{
	self endon( "death" );
	self.allowdeath = true;
	self.health = 1;
	self.noragdoll	= 1;
	self.ignoreme = true;
	self gun_remove();
	animscripts\shared::placeWeaponOn( self.sidearm, "right" );
	
	if( isdefined( _flag ) || isdefined( time ) )
	{
		self anim_generic_first_frame( self, self.animation );
		if( isdefined( _flag ) )
			flag_wait( _flag );
		if( isdefined( time ) )
			wait time;
	}	
	if( self.animation == "airport_security_guard_pillar_react_L" )
		self.deathanim = %airport_security_guard_pillar_death_L;
	else
		self.deathanim = %airport_security_guard_pillar_death_R;
			
	self thread play_sound_on_tag_endon_death( "airport_rac_freeze" );
	self anim_generic( self, self.animation );
		
	self kill();
}

massacre_rentacop_rush_main()
{
	flag_wait( "massacre_rentacop_rush" );
	
	node = getstruct( level.massacre_rush[ "cop" ].target, "targetname" );
	
	level.massacre_rush[ "cop" ] gun_remove();
	level.massacre_rush[ "cop" ] animscripts\shared::placeWeaponOn( level.massacre_rush[ "cop" ].sidearm, "right" );
	level.massacre_rush[ "cop" ] delaythread( .5, ::set_ignoreme, false );
	level.massacre_rush[ "fem" ] delaythread( .5, ::play_sound_on_tag_endon_death, "airport_rfc1_scream4" );
	
	wait .1;
		
	node thread massacre_rentacop_rush_animate( level.massacre_rush[ "cop" ], "airport_security_civ_rush_guard" );
	node thread massacre_rentacop_rush_animate( level.massacre_rush[ "male1" ], "airport_security_civ_rush_civA" );
	node thread massacre_rentacop_rush_animate( level.massacre_rush[ "male2" ], "airport_security_civ_rush_civC" );
	node thread massacre_rentacop_rush_animate( level.massacre_rush[ "fem" ], "airport_security_civ_rush_civB" );
}

massacre_rentacop_rush_animate( guy, anime )
{
	guy endon( "death" );
	guy notify( "stop_loop" );
	guy stopanimscripted();
	wait .2;
	self anim_generic( guy, anime );
	
	switch( guy.script_noteworthy )
	{
		case "cop":
			guy.noragdoll = 1;
			guy.deathanim = %pistol_death_2;
			guy bodyshot( "headshot" );
			guy kill();
			break;
		case "fem":
			guy.deathanim = %run_death_roll;//exposed_death_falltoknees run_death_roll corner_standR_deathB
			guy bodyshot( "killshot" );
			guy kill();
			break;
		default:
			guy setgoalnode( getnode( "upperdeck_escape_node", "targetname" ) );
			guy.goalradius = 100;		
			guy waittill( "goal" );
			guy bodyshot( "killshot" );
			guy kill();
			break;
	}
}

massacre_rentacop_rush_guy()
{
	self endon( "death" );
	
	waittillframeend;//default civilian nonsense
	
	self.allowdeath = true;
	self.ignoreme = true;
	self.health = 1;
			
	if( !isdefined( level.massacre_rush ) )
		level.massacre_rush = [];
	level.massacre_rush[ self.script_noteworthy ] = self;
				
	if( level.massacre_rush.size == 4 )
		flag_set( "massacre_rentacop_rush" );
	
	node = getstruct( self.target, "targetname" );
		
	switch( self.script_noteworthy )
	{
		case "cop":
			node anim_generic_first_frame( self, "airport_security_civ_rush_guard" );
			break;
		case "male1":
			temp = spawnstruct();
			temp.origin = GetStartOrigin( node.origin, node.angles, getanim_generic( "airport_security_civ_rush_civA" ) );
			temp.angles = GetStartAngles( node.origin, node.angles, getanim_generic( "airport_security_civ_rush_civA" ) );
			temp thread anim_generic_loop( self, "CornerCrR_alert_idle" );
			break;	
		case "fem":
			temp = spawnstruct();
			temp.origin = GetStartOrigin( node.origin, node.angles, getanim_generic( "airport_security_civ_rush_civB" ) );
			temp.angles = GetStartAngles( node.origin, node.angles, getanim_generic( "airport_security_civ_rush_civB" ) );
			temp thread anim_generic_loop( self, "CornerCrR_alert_idle" );
			break;	
		case "male2":
			temp = spawnstruct();
			temp.origin = GetStartOrigin( node.origin, node.angles, getanim_generic( "airport_security_civ_rush_civC" ) );
			temp.angles = GetStartAngles( node.origin, node.angles, getanim_generic( "airport_security_civ_rush_civC" ) );
			temp thread anim_generic_loop( self, "CornerCrR_alert_idle" );
			break;	
	}
}

massacre_rentacop_runaway_guy()
{
	self endon( "death" );
	
	waittillframeend;//default civilian nonsense
	
	self.ignoreme = true;	
	self.health = 1;
	self.allowdeath = 1;
	
	node = getstruct( self.target, "targetname" );
	temp = spawnstruct();
	temp.origin = GetStartOrigin( node.origin, node.angles, getanim_generic( "airport_security_guard_4" ) );
	temp.angles = GetStartAngles( node.origin, node.angles, getanim_generic( "airport_security_guard_4" ) );
	
	temp thread anim_generic_loop( self, "covercrouch_hide_idle" );
	
	flag_wait( "massacre_rentacop_rush" );
	
	wait 6;
	
	temp notify( "stop_loop" );
	self stopanimscripted();
	
	self.deathanim = %airport_security_guard_4_reaction;
	self.noragdoll = 1;
	self.ignoreme = false;	
	self.oldprimary = self.primaryweapon;
	self forceuseweapon( self.sidearm, "primary" );
	
	flag_set( "massacre_rentacop_runaway_go" );
	node anim_generic( self, "airport_security_guard_4" );	
	self forceuseweapon( self.oldprimary, "primary" );
}

massacre_rentacop_row1_fighter()
{
	self endon( "death" );
	
	waittillframeend;//default civilian nonsense
	
	self.ignoreme = true;	
	self.health = 1;
	self.allowdeath = 1;
	self.ignorerandombulletdamage = true;
	self.pathrandompercent = 0;
	
	node = getstruct( self.target, "targetname" );	
	self thread anim_generic_loop( self, "CornerCrL_alert_idle" );
	
	flag_wait( "massacre_rentacop_rush" );
	
	wait 12;
	
	self notify( "stop_loop" );
	self stopanimscripted();
	self.oldprimary = self.primaryweapon;
	self forceuseweapon( self.sidearm, "primary" );
			
	flag_set( "massacre_rentacop_row1_fighter_go" );
	node thread anim_generic( self, "airport_security_guard_4" );
	
	node add_wait( ::waittill_msg, "airport_security_guard_4" );
	self add_abort( ::waittill_msg, "death" );
	level.makarov add_abort( ::waittill_msg, "m79_shot" );
	self add_func( ::forceuseweapon, self.oldprimary, "primary" );
	thread do_wait();
	
	level.makarov waittill( "m79_shot2" );
		
//	deathanim = "death_explosion_run_L_v1";
//	if( cointoss() )
		deathanim = "death_explosion_run_L_v2";
	
	node = spawnstruct();
	node.angles = self.angles + (0,0,15);
	node.origin = self.origin;
	self thread grenade_death_scripted( node, deathanim, .6 );
}

massacre_rentacop_row1_runner()
{
	self endon( "death" );
	
	waittillframeend;//default civilian nonsense
	
	self.ignorerandombulletdamage = true;
	self.ignoreme = true;	
	self.health = 1;
	self.allowdeath = 1;
	self.pathrandompercent = 0;
	
	//node = getstruct( self.target, "targetname" );
	node = getstruct( "massacre_rentacop_row1_defender_node", "targetname" );	
	self thread anim_generic_loop( self, "CornerCrR_alert_idle" );
	
	flag_wait( "massacre_rentacop_rush" );
	
	wait 8;
	
	self notify( "stop_loop" );
	self stopanimscripted();
	self.oldprimary = self.primaryweapon;
	self forceuseweapon( self.sidearm, "primary" );
		
	flag_set( "massacre_rentacop_row1_runner_go" );
	//node thread anim_generic( self, "airport_security_guard_4" );
	node thread anim_generic( self, "react_stand_2_run_180" );
	
	node add_wait( ::waittill_msg, "react_stand_2_run_180" );
	self add_abort( ::waittill_msg, "death" );
	level.makarov add_abort( ::waittill_msg, "m79_shot" );
	self add_func( ::forceuseweapon, self.oldprimary, "primary" );
	thread do_wait();

	level.makarov waittill( "m79_shot" );
		
	deathanim = "death_explosion_run_R_v1";
	if( cointoss() )
		deathanim = "death_explosion_run_R_v2";
	
	node = spawnstruct();
	node.angles = self.angles + (0,0,-20);
	node.origin = self.origin;
	self thread grenade_death_scripted( node, deathanim );
}

massacre_rentacop_row1_defender()
{
	self endon( "death" );
	
	waittillframeend;//default civilian nonsense
	
	self.ignoreme = true;	
	self.health = 1;
	self.allowdeath = 1;
	self.ignorerandombulletdamage = true;
	self.pathrandompercent = 0;
	
	node = getnode( self.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = 16;
	
	node thread anim_generic_loop( self, self.animation );
	
	flag_wait( "massacre_rentacop_rush" );
	
	wait 9.5;
	
	node notify( "stop_loop" );
	self stopanimscripted();
	self.favoriteenemy = level.team[ "saw" ];
	self.ignoresuppression = 1;
	self allowedstances( "stand" );
	self disable_surprise();
		
	node = getnode( node.target, "targetname" );
	self setgoalnode( node );
	
	wait 1;
	self allowedstances( "stand", "crouch" );
	
	wait 1.5;
	self.ignoreall = true;	
	
	level.makarov waittill( "m79_shot2" );
	
	origin = getstruct( "massacre_m79_impact_2", "targetname" );
	if( distancesquared( self.origin, origin.origin ) > squared( 100 ) )
		return;
	
	deathanim = "death_explosion_run_B_v1";
	if( cointoss() )
		deathanim = "death_explosion_run_B_v2";
	
	node = spawnstruct();
	node.angles = vectortoangles( origin.origin - self.origin ) + (5,0,0);
	node.origin = self.origin;
	self thread grenade_death_scripted( node, deathanim, getanimlength( level.scr_anim[ "generic" ][ deathanim ] ) - .75 );
}

massacre_rentacops_rambo()
{
	self endon( "death" );
	
	self add_wait( ::waittill_msg, "death" );
	self add_func( ::flag_set, "massacre_rentacop_rambo_dead" );
	self thread do_wait();
	self.pathrandompercent = 0;
	
	self.allowdeath = true;
	self.ignoreme = true;
	self.health = 1;
		
//	self thread play_sound_on_tag_endon_death( "airport_rac_freeze" );
	anime = undefined;
	
	if( cointoss() )
		anime = "corner_standL_rambo_jam";
	else
		anime = "corner_standL_rambo_set";
		
	self thread anim_generic( self, anime );
	
	wait 2;		
	flag_set( "massacre_rentacop_rambo" );
	self.goalradius = 80;
	self.ignoreme = false;
}

massacre_rentacops_rear()
{
	self endon ( "death" );
	self endon ( "long_death" );
	
	//self.health = 1;	
	self.goalradius = 8;
	self.accuracy = 1;
	self.baseaccuracy = 1;
	self.ignoreme = true;
	self.ignoreall = true;
	self.noGrenadeReturnThrow = true;
	self.allowdeath = true;
	self.ignorerandombulletdamage = true;
	self.noreload = true;
	self allowedstances( "crouch" );
	self.pathrandompercent = 0;
	
	wait 1;
	self thread anim_generic_loop( self, "covercrouch_hide_idle" );
	
	if( self.script_parameters == "center" )
	{
		self add_wait( ::flag_wait, "massacre_rentacop_stop" );	
		self add_abort( ::waittill_msg, "death" );
		self add_func( ::delaythread, 5.5, ::play_sound_on_tag_endon_death, "airport_rac_handsup" );
		self thread do_wait();
	}
		
	flag_wait( "massacre_nadethrow" );
	
	if( self.script_parameters != "center" )
	{
		self.ignoreall = false;
		self allowedstances( "stand" );
		self notify( "stop_loop" );
		self stopanimscripted();
		self.baseaccuracy = self.baseaccuracy * .3;
		self.accuracy = self.accuracy * .3;
	}
	wait 1;
			
	self thread notify_delay( "switch_to_nade_death", ( level.nadethrow_mak_time - .05 ) );
	wait randomfloatrange( 1, 1.5 );
	
	if( self.script_parameters == "center" )
	{
		self.ignoreall = false;
		self allowedstances( "stand" );
		self notify( "stop_loop" );
		self stopanimscripted();
		self.baseaccuracy = self.baseaccuracy * .3;
		self.accuracy = self.accuracy * .3;
	}
		
	anime = undefined;
	deathanim = undefined;
	angle = 0;
	angle2 = 0;
	angle0 = 0;
	
	switch( self.script_parameters )
	{
		case "center":
			anime 		= "exposed_backpedal";
			deathanim	= "death_explosion_stand_B_v1";
			angle0 		= 5;
			angle 		= 285;
			angle2		= 0;
			break;
		
		case "right":
			anime 		= "react_stand_2_run_180";
			deathanim	= "death_explosion_stand_R_v1";
			angle 		= 290;
			angle2		= -10;
			break;	
		
		case "left":
			anime 		= "walk_backward";
			deathanim	= "death_explosion_stand_L_v3";
			angle 		= 260;
			angle2		= 10;
			break;			
	}
	
	node = spawn( "script_origin", self.origin );
	node.angles = ( 0, angle, 0 );
	
	node thread anim_generic( self, anime );
	
	self waittill( "switch_to_nade_death" );
	
	node.angles = ( angle0, angle, angle2 );
	
	if( self.script_parameters == "center" )
	{
		time = getanimlength( getgenericanim( deathanim ) ) - .2;
		dettime = time - .4;
		time -= .45;
		ent = getstruct( "massacre_glass_shatter", "targetname" );
		
		level thread delaythread( dettime, ::_radiusdamage, ent.origin, 32, 2000, 2000 );
		self thread grenade_death_scripted( node, deathanim, time );
	}
	else
		self thread grenade_death_scripted( node, deathanim );
}

grenade_death_scripted( node, deathanim, ragtime )
{
	self.maxhealth = 100000;
	self.health = 100000;
		
	self.allowdeath = false;
	self.skipdeathanim	= 1;
	self.noragdoll = 1;
		
	wait .05;
	
	self stopanimscripted();
	node.origin = self.origin;
	node thread anim_generic( self, deathanim );
	
	self animscripts\shared::DropAllAIWeapons();
	self delaythread( .05, ::_kill );
	
	if( !isdefined( ragtime ) )
		ragtime = getanimlength( getgenericanim( deathanim ) ) - .2;	
	wait ragtime;
	self startragdoll();
}

massacre_rentacops_blindfire()
{
	self endon( "stop_blindfire" );
	self endon( "death" );
	
	while( 1 )
	{
		wait randomfloatrange( 1.5, 3 );
		
		self notify( "stop_loop" );	
		
		self stopanimscripted();
		
		//self thread spray_and_pray( 0, undefined, cointoss(), 75, 20 );
		
		self anim_generic( self, "covercrouch_blindfire_1" );
		
		self thread anim_generic_loop( self, "covercrouch_hide_idle" );
	}	
}

massacre_rentacops_stairs()
{	
	self endon( "death" );
		
	self.noGrenadeReturnThrow = true;
	self.grenadeawareness = 0;
	self setgoalpos( self.origin );
	self.goalradius = 16;
	self.ignoreme = true;
	self.ignoreall = true;
	self.ignoresuppression = 1;
	self disable_surprise();
	self.disableBulletWhizbyReaction = true;
	self.allowdeath = true;
	self.interval = 0;
					
	switch( self.script_noteworthy )
	{
		case "1":
			self massacre_rentacops_elevator_1();
			break;
		case "2":			
			self massacre_rentacops_elevator_2();
			break;	
		case "3":
			self massacre_rentacops_elevator_3();
			break;
	}			
}

massacre_rentacops_elevator_1()
{
	self endon( "death" );
	
	self thread anim_generic_loop( self, "corner_standL_alert_idle" );
	
	flag_wait( "massacre_elevator_down" );
	node = getnode( self.target, "targetname" );

	wait 1;

	self notify( "stop_loop" );
	self stopanimscripted();
	self setgoalnode( node );
	self waittill( "goal" );
	
	flag_wait( "massacre_elevator_up" );
	self.ignoreall = false;
			
	self linkto( level.massacre_elevator.e[ "housing" ][ "mainframe" ][ 0 ] );		

	flag_wait( "massacre_elevator_at_top" );
	self.goalradius = 100;
	
	wait .5;
	
	self unlink();
	
	node = getstruct( "massacre_elevator_jump_node", "targetname" );
	node.angles = (0,90,0);
	
	self.oldcontents = self setcontents( 0 );
	
	node anim_generic_reach( self, "corner_standL_alert_idle_reach" );
	node thread anim_generic_loop( self, "corner_standL_alert_idle" );	
	
	flag_wait( "massacre_elevator_grenade_throw" );
		
	node.angles = (0,0,0);
	
	self setcontents( self.oldcontents );	
	self.allowdeath = true;
	node notify( "stop_loop" );
	self stopanimscripted();
	self playsound( "airport_rmc2_scream1" );
	node thread anim_generic( self, "corner_standL_explosion_B" );
	
	wait 1;
	self.a.pose = "prone";	
	
	flag_wait( "massacre_elevator_grenade_exp" );
	wait 1;
	
	self.noGrenadeReturnThrow = false;
	self.grenadeawareness = 1;
	self.ignoreme = false;
	self.ignoreall = false;
	self.goalradius = 512;
	level.makarov.ignoreall = false;
	level.team["shotgun"].ignoreall = false;
	level.makarov.ignoreme = false;
	level.team["shotgun"].ignoreme = false;
}

massacre_rentacops_elevator_2()
{
	self allowedstances( "stand" );
		
	self thread anim_generic_loop( self, "corner_standR_alert_idle" );
	
	flag_wait( "massacre_elevator_down" );
	node = getnode( self.target, "targetname" );
	
	wait 2;
					
	self notify( "stop_loop" );
	self stopanimscripted();
	self setgoalnode( node );
	self waittill( "goal" );
		
	flag_wait( "massacre_elevator_up" );
	
	self.ignoreall = false;
	self.goalradius = 32;
			
	self linkto( level.massacre_elevator.e[ "housing" ][ "mainframe" ][ 0 ] );		
	
	self thread anim_generic_loop( self, "corner_standL_alert_idle" );
		
	flag_wait( "massacre_elevator_grenade_throw" );
	
	self unlink();
	self notify( "stop_loop" );
	self stopanimscripted();
	
	node = spawnstruct();
	node.origin = self.origin;
	node.angles = ( 0, 100, 0 );
	
	self gun_remove();
		
	node thread anim_generic( self, "unarmed_cowerstand_react" ); 
	self playsound( "airport_rmc2_scream3" );
	
	flag_wait( "massacre_elevator_grenade_exp" );
	
	node.origin = self.origin;
	
	self thread grenade_death_scripted( node, "death_explosion_stand_B_v1", getanimlength( getgenericanim( "death_explosion_stand_B_v1" ) ) - .5 );
	PlayFXOnTag( getFX( "glass_dust_trail" ), self, "J_SpineLower" );
}

massacre_rentacops_elevator_3()
{
	self allowedstances( "stand" );
		
	self thread anim_generic_loop( self, "corner_standL_alert_idle" );
	
	flag_wait( "massacre_elevator_down" );
	node = getnode( self.target, "targetname" );
	
	wait 3;
	
	self notify( "stop_loop" );
	self stopanimscripted();
	self setgoalnode( node );
	self waittill( "goal" );
	
	wait .5;
		
	flag_set( "massacre_elevator_guys_ready" );
	
	flag_wait( "massacre_elevator_up" );
	self.ignoreall = false;
					
	self linkto( level.massacre_elevator.e[ "housing" ][ "mainframe" ][ 0 ] );		
	
	self thread anim_generic_loop( self, "corner_standR_alert_idle" );
	flag_wait( "massacre_elevator_at_top" );
	
	self.goalradius = 100;
	self setgoalpos( self.origin );
	self unlink();
	self notify( "stop_loop" );
	self stopanimscripted();
	
	flag_wait( "massacre_elevator_grenade_throw" );
		
	node = spawnstruct();
	node.origin = self.origin;
	node.angles = ( 0, 90, 0 );
	
	node thread anim_generic( self, "exposed_backpedal" ); 
	
	wait 1.35;
	
	self stopanimscripted();
	self thread anim_generic( self, "stand_2_run_F_2" );
	
	flag_wait( "massacre_elevator_grenade_exp" );
	
	node.origin = self.origin;
	
	if( !isalive( self  ) )
		return;
		
	self set_allowdeath( false );
	self.noragdoll = true;
	self stopanimscripted();
	self thread anim_generic( self, "exposed_death_blowback" );
	
	wait 1.55;	
	
	if( !isalive( self  ) )
		return;
	
	self startragdoll();
	self kill();
}

massacre_elevator()
{	
	elevator = massacre_elevator_get();
	level.massacre_elevator = elevator;
			
	flag_wait( "massacre_elevator_start" );	
		
	elevator common_scripts\_elevator::call_elevator( 0 );
	elevator waittill( "elevator_moved" );
	
	left_door = elevator common_scripts\_elevator::get_outer_leftdoor( 0 );	
	right_door = elevator common_scripts\_elevator::get_outer_rightdoor( 0 );
	left_door connectpaths();	
	right_door connectpaths();
	flag_set( "massacre_elevator_down" );
	
	flag_wait( "massacre_elevator_guys_ready" );
	flag_wait( "massacre_eleveator_should_come_up" );
	elevator common_scripts\_elevator::call_elevator( 1 );
	elevator waittill( "closed_inner_doors" );
	flag_set( "massacre_elevator_up" );
	thread flag_set_delayed( "massacre_elevator_prepare_nade", 2.5 );
	elevator waittill( "elevator_moved" );
		
	left_door = elevator common_scripts\_elevator::get_outer_leftdoor( 1 );	
	right_door = elevator common_scripts\_elevator::get_outer_rightdoor( 1 );
	left_door connectpaths();	
	right_door connectpaths();
	flag_set( "massacre_elevator_at_top" );
		
	flag_wait( "massacre_elevator_grenade_exp" );
	elevator.e[ "housing" ][ "mainframe" ][ 0 ] playsound( "elevator_shake_groan" );
	
	wait .05;
	//array_thread( level.players, ::playLocalSoundWrapper, "_juggernaut_attack" );
	exploder( 1 );
	struct = getstruct( "elevator_pick", "targetname" );
	array = getentarray( "elevator_casing_glass", "targetname" );
	glass = getclosest( struct.origin, array );
	glass delete();
	array = getentarray( "elevator_housing_glass", "script_noteworthy" );
	glass = getclosest( struct.origin, array );
	glass delete();
	
	wait .5;
	//elevator.e[ "housing" ][ "mainframe" ][ 0 ] playsound( "elavator_rumble" );
	
	velF = (0,0,1000);
	velR = (0,0,-1000);
	
	elevator delaythread( .95, ::elevator_animated_down_fast, elevator.cable, elevator.e[ "housing" ][ "mainframe" ][ 0 ], 1.05, velF, velR );
	wait 1;
	
	left_door = elevator common_scripts\_elevator::get_outer_leftdoor( 0 );	
	right_door = elevator common_scripts\_elevator::get_outer_rightdoor( 0 );
	
	level.elevators = array_remove( level.elevators, elevator );
	
	delaythread( .1, ::massacre_set_elevator_const, 80 );
	delaythread( .6, ::massacre_set_elevator_const, 70 );
	delaythread( .75, ::massacre_set_elevator_const, 60 );
	
	elevator.e[ "housing" ][ "inside_trigger" ] delete();
	elevator.e[ "housing" ][ "mainframe" ][ 0 ] MoveGravity( (0,0,0), 1 );
		
	wait 1;
	elevator.e[ "housing" ][ "mainframe" ][ 0 ] playsound( "elevator_crash" );
	exploder( 2 );
	//temp
	left_door delete();
	right_door delete();
	wait .5;
	elevator notify( "elevator_moved" );
	
	level.ELEV_CABLE_HEIGHT = CONST_ELEV_CABLE_HEIGHT;
}

massacre_set_elevator_const( const )
{
	level.ELEV_CABLE_HEIGHT = const;	
}

massacre_elevator_get()
{
	struct = getstruct( "elevator_pick", "targetname" );
	
	elevator = level.elevators[ 0 ];
	dist = distance( elevator.e[ "housing" ][ "mainframe" ][ 0 ] getorigin(), struct.origin );
	
	foreach( obj in level.elevators )
	{	
		newdist = distance( obj.e[ "housing" ][ "mainframe" ][ 0 ] getorigin(), struct.origin );	
		if( newdist < dist )
		{
			elevator = obj;
			dist = newdist;	
		}
	}	
	
	return elevator;
}

massacre_runners1()
{
	self endon( "death" );	
	
	wait .05;
	
	self.allowdeath = 1;
	self thread anim_generic_loop( self, self.animation );
	self.ignorerandombulletdamage = true;
	
	flag_wait( "massacre_rentacop_rush" );
	
	wait 5;
	
	self notify( "stop_loop" );
	self stopanimscripted();
	self.ignorerandombulletdamage = false;			
	self.useChokePoints 				= false;
	
	if( !isdefined( level.massacre_runners1 ) )
	{
		level.massacre_runners1 = [];
		level.massacre_runners1[ level.massacre_runners1.size ] = self;
		wait .1;
		thread running_civ_soundscape( level.massacre_runners1, "scn_airport_running_screams3" );
	}
	else
		level.massacre_runners1[ level.massacre_runners1.size ] = self;
	
	thread massacre_runners_m79_death();
		
	if( isdefined( self.target ) )
	{
		if( self.target == "massacre_civ_runner_node" )
		{
			self thread anim_generic_loop( self, self.animation );
			self.ignorerandombulletdamage = true;
			
			wait 1;
			
			self notify( "stop_loop" );
			self stopanimscripted();
			node = getstruct( self.target, "targetname" );
			node anim_generic( self, "civilian_run_hunched_flinch" );
		}
		else
		{
			node = getnode( self.target, "targetname" );
			self.ignorerandombulletdamage = true;
			self follow_path( node );	
			self.ignorerandombulletdamage = false;
		}
	}
	self.target = undefined;	
	upperdeck_runners_go();
}

massacre_runners2( scream )
{
	self endon( "death" );	
	
	wait .05;
	
	self.allowdeath = 1;
	self thread anim_generic_loop( self, self.animation );
	self.ignorerandombulletdamage = true;
	
	if( !isdefined( level.massacre_runners2 ) )
	{
		level.massacre_runners2 = [];
		level.massacre_runners2[ level.massacre_runners2.size ] = self;
		wait .1;
		thread running_civ_soundscape( level.massacre_runners2, scream );
		wait .05;
		level.massacre_runners2 = undefined;
	}
	else
		level.massacre_runners2[ level.massacre_runners2.size ] = self;
	
	self notify( "stop_loop" );
	self stopanimscripted();
	self.ignorerandombulletdamage = false;			
	self.useChokePoints 				= false;
	
	if( isdefined( self.target ) )
	{
		node = getnode( self.target, "targetname" );
		self follow_path( node );
	}		
	self.target = undefined;
	upperdeck_runners_go();
}

massacre_runners_m79_death()
{
	self endon( "death" );
	
	level.makarov waittill( "m79_shot2" );
	
	origin = getstruct( "massacre_m79_impact_2", "targetname" );
	if( distancesquared( self.origin, origin.origin ) > squared( 100 ) )
		return;
	
	deathanim = undefined;
	vec = origin.origin - self.origin;
	dot = vectordot( vec, anglestoforward( self.angles ) );
	dot2 = vectordot( vec, anglestoright( self.angles ) );
	angles = (0,0,0);
	//in front
	if( dot > .5 )
	{
		deathanim = "death_explosion_run_B_v1";
		if( cointoss() )
			deathanim = "death_explosion_run_B_v2";
		
		angles = (10,0,0);
	}
	//in back
	else if( dot < -.5 )
	{
		deathanim = "death_explosion_run_F_v1";
		if( cointoss() )
			deathanim = "death_explosion_run_F_v2";
		
		angles = (-10,0,0);
	}
	//to the right
	else if( dot2 > .6 )
	{
		deathanim = "death_explosion_run_L_v1";
		if( cointoss() )
			deathanim = "death_explosion_run_L_v2";
		
		angles = (0,0,10);
	}
	else
	{
		deathanim = "death_explosion_run_R_v1";
		if( cointoss() )
			deathanim = "death_explosion_run_R_v2";
		
		angles = (0,0,-10);
	}
	
	node = spawnstruct();
	node.angles = self.angles;
	node.origin = self.origin;
	self thread grenade_death_scripted( node, deathanim, .5 );	
}

massacre_crawler()
{
	self endon( "death" );	
	
	wait .05;
	
	self.allowdeath = 1;
	self anim_generic_first_frame( self, "dying_crawl" );
	self.ignorerandombulletdamage = true;
	self force_crawling_death( self.angles[ 1 ], 2, undefined, 1 );
	
	flag_wait( "massacre_elevator_grenade_exp" );
	self stopanimscripted();
	
	self dodamage( 1, level.player.origin );
}

massacre_civ_setup()
{
	name = undefined;
	
	switch( self.script_noteworthy )
	{
		case "male":
			name = "civilian_male_suit_low_LOD";
			break;	
		case "female":
			name = "civilian_female_suit_low_LOD";
			break;
	}
	
	spawner = getent( name, "targetname" );
	spawner.count = 1;
	
	drone = dronespawn( spawner );
		
	drone.ref_node 		= self;
	drone.anime 		= self.animation;
	drone.script_delay 	= self.script_delay;
	
	drone.maxhealth = 1;
	drone.health = 1;
	drone.ignoreexplosionevents = true;	
	drone.ignoreme = true;
	drone enable_ignorerandombulletdamage_drone();
	drone.grenadeawareness = 0;
	drone disable_surprise();
	drone thread magic_bullet_shield( true );
	
	drone.dontdonotetracks	= 1;
	drone.nocorpsedelete 	= 1;
	
	drone thread massacre_civ_die();
	
	level.massacre_delete_or_die = 0;
}

massacre_civ_die()
{
	node = self.ref_node;
	waittillframeend;
	
	wait .5;
	
	node anim_generic_first_frame( self, self.anime );	
	self setanimtime( getanim_generic( self.anime ), .2 );
	
	self thread do_lobby_player_fire();
	
	flag_wait( "massacre_civ_animate" );
	
	if( isalive( level.team[ "m4" ] ) )
		level.team[ "m4" ] ent_flag_wait( "massacre_firing_into_crowd" );
	
	timing_node = getstruct( "massacre_random_timing", "targetname" );
	timing_node.origin = (2570, 3777, 144);
	group_node = getstruct( node.target, "targetname" );
	
	dist2rd = squared( timing_node.radius );	
	dist = distancesquared( timing_node.origin, group_node.origin );
	value = 1 - ( dist2rd - dist ) / dist2rd;
	
	time = .25 * ( value );
	if( distancesquared( timing_node.origin, group_node.origin ) < squared( 128 ) )
		time = .1 * ( value );
		
	wait ( time );
	
	self script_delay();
	self thread do_blood_notetracks();
	
	self stop_magic_bullet_shield();
	node thread anim_generic( self, self.anime );	
	self setanimtime( getanim_generic( self.anime ), .2 );
	
	node waittill( self.anime );
	
	if( node.animation != "airport_civ_in_line_6_C_reaction" )
	{
		self.noragdoll 		= 1;
		self.skipdeathanim	= 1;
	}
	
	node delete();
	
	level.massacre_delete_or_die++;
	if( level.massacre_delete_or_die > 2 )
		level.massacre_delete_or_die = 0;
		
	self kill(); 	
	
	if( !level.massacre_delete_or_die )
	{
		wait .1;
		self delete();
		return;	
	}
	
	flag_wait( "tarmac_moveout" );
	
	self delete();
}

massacre_team_dialogue()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	flag_wait( "massacre_rentacop_stop_dead" );
	wait .75;
	//Security detail up ahead!	
	//level.team[ "shotgun" ] radio_dialogue( "airport_at1_security" );
	//level.team[ "makarov" ] radio_dialogue( "airport_mkv_careofit" );
		
	//flag_wait( "massacre_rentacops_rear_dead" );
	//Movement at the elevators!
	//level.team[ "makarov" ] radio_dialogue( "airport_mkv_elevators" );
		
//	flag_wait( "massacre_elevator_grenade_ready" );
//	radio_dialogue( "airport_mkv_fragout" );
}

massacre_killers( node )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	flag_wait( "massacre_rentacop_stop" );
	
	waittillframeend;
	
	self pushplayer( true );
	
	self clearentitytarget();
	self.ignoreall = false;
	self.a.disablePain = 1;
	
	self ent_flag_clear( "aiming_at_civ" );
	
	flag_wait( "massacre_rentacop_stop_dead" );
	self enable_dontevershoot();
	
	if( self.script_noteworthy == "m4" )
		self ent_flag_set( "massacre_ready" );
	else
	{
		foreach( member in level.team )
			member ent_flag_wait( "massacre_ready" );
		
		delaythread( 4, ::activate_trigger, "massacre_rentacop_rush_guy", "target" );
	}
		
	self thread follow_path( node );
	self disable_arrivals();
	self delaythread( 1, ::disable_exits );
	
	switch( self.script_noteworthy )
	{
		case "saw":
			self massacre_killers_saw( node );		
			self massacre_killers_saw2();
			break;
		case "m4":
			self massacre_killers_m4();
			break;
			
		case "shotgun":
			self massacre_killers_shotgun( node );
			break;
			
		case "makarov":
			self massacre_killers_makarov( node );
			self thread massacre_killers_makarov2();
			node = getnode( "massacre_elevator_nade_node", "targetname" );
			self massacre_killers_go_nader( node );
			break;
	}	
	
	self.a.disablePain 	= false;	
	wait 1;
	self ent_flag_set( "gate_ready_to_go" );
}

massacre_killers_kill_rush( interval )
{		
	flag_wait( "massacre_kill_rush" );	
	
	if( flag( "massacre_rentacop_rush_dead" ) )
		return;
		
	if( !isdefined( interval ) )
		interval = .1;
	
	ai = get_living_ai( "cop", "script_noteworthy" );
	if( isalive( ai ) )
	{
		ai.ignoreme = false;
		self.favoriteenemy = ai;
	}
		
	self thread fire_full_auto( interval, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", .5 );
}

massacre_killers_kill_runaway( interval )
{	
	flag_wait( "massacre_rentacop_runaway_go" );	
	
	wait 2;
	
	if( flag( "massacre_rentacop_runaway_dead" ) )
		return;
	
	if( !isdefined( interval ) )
		interval = .1;
	
	ai = get_living_ai( "massacre_rentacop_runaway_guy", "script_noteworthy" );
	if( isalive( ai ) )
	{
		ai.ignoreme = false;
		self.favoriteenemy = ai;
	}
	
	self thread fire_full_auto( interval, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", .5 );
}

massacre_killers_kill_rambo( interval )
{
	flag_wait_any( "massacre_rentacop_rambo_dead", "massacre_rentacop_rambo" );	
		
	if( flag( "massacre_rentacop_rambo_dead" ) )
		return;
	
	if( !isdefined( interval ) )
		interval = .1;
			
	self thread fire_full_auto( interval, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", .5 );
}

massacre_killers_m4()
{
	self.ignoreall = true;
	self.moveplaybackrate = 1.1;
	self enable_arrivals();
	
	self set_generic_run_anim( "casual_killer_jog_A" );
	
	self disable_dontevershoot();
	node = getnode( "massacre_nodes2", "targetname" );
	self follow_path( node );
	
	self clear_run_anim();
	self massacre_killers_attack_civs( node );
	
	self maps\_casual_killer::disable_casual_killer();
	waittillframeend;
	self maps\_casual_killer::enable_casual_killer();
	waittillframeend;
	
	self.combatmode = "cover";
	self.moveplaybackrate = .85;
	
	add_wait( ::flag_wait, "massacre_makarov_point_at_rambo" );
	self add_func( ::set_generic_run_anim, "casual_killer_jog_A" );	
	self add_abort( ::waittill_msg, "reached_path_end" );
	thread do_wait();
	
	self enable_exits();
	self enable_arrivals();
	
	node = getnode( "massacre_elevator_secondary_nodes_m4", "targetname" );
	self follow_path( node );
	
	self clear_run_anim();
	self.moveplaybackrate = 1.0;
	
	wait 1;
	
	while( abs( self.angles[ 1 ] - node.angles[1] ) > 5 )
	{
		//overzealous application ( because code/animscripts love to fuck with orientmode all the time and he may never turn to this angle )
		self orientmode( "face angle", node.angles[1] );
		wait .1;
	}		
	
	if( flag( "massacre_runners1_dead" ) && flag( "massacre_runners2_dead" ) && flag( "massacre_runners3_dead" ) )
		return;
	
	self thread spray_and_pray( 0, .25, true );	
		
	flag_wait( "massacre_runners1_dead" );
	flag_wait( "massacre_runners2_dead" );
	flag_wait( "massacre_runners3_dead" );
	wait 1;
		
	self notify( "stop_spray_and_pray" );
}

massacre_killers_saw( node )
{
	self thread massacre_killers_kill_rush();	
		
	self.moveplaybackrate = 1.35;
	wait 10;
	self.moveplaybackrate = 1.1;
	
	wait .1;
	
	self.ignoreall = true;
	//hack
	self clearanim( %run_n_gun, 0.2 );
	self.runNGunAnims[ "F" ] = %casual_killer_walk_shoot_F_aimdown;
	wait .5;
	
	self.aim_anime = %casual_killer_walk_shoot_L;
	self.aim_weight = .4;
	self.aim_time = .5;
	self AnimCustom( ::aim_dir );	
	
	wait 1;
	
	self.moveplaybackrate = 1.0;
	
	self.aim_anime = %casual_killer_walk_shoot_L;
	self.aim_weight = .4;
	self.aim_time = .2;
	self AnimCustom( ::aim_dir );	
	
	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", 2 );	
	wait .5;
	
	self.aim_anime = %casual_killer_walk_shoot_L;
	self.aim_weight = .4;
	self.aim_time = .2;
	self AnimCustom( ::aim_dir );	
	
	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", .5 );	
	wait .5;
	
	self.aim_anime = %casual_killer_walk_shoot_L;
	self.aim_weight = .4;
	self.aim_time = .2;
	self AnimCustom( ::aim_dir );	
	
	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", 1 );
	wait 1.0;
	
	self.ignoreall = false;
	self AnimCustom( ::aim_stop );	
	
	wait .2;
	self maps\_casual_killer::set_casual_killer_run_n_gun( "straight" );	
		
	level.makarov waittill( "m79_shot2" );
	
	wait .25;
	
	self thread anim_generic_run( self, "casual_killer_flinch" );
	self.moveplaybackrate = 1.3;
		
	self waittill( "reached_path_end" );	
}

massacre_killers_saw2()
{
	node = getnode( "massacre_elevator_secondary_nodes_saw", "targetname" );
	self thread follow_path( node );
	
	self.moveplaybackrate = 1.1;
	
	target = getent( "massacre_civ_aim_node", "targetname" );
	target.health = 100;
	
	wait 2;
	
	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", 1 );
		
	wait .5;
	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", .5 );
	
	self setentitytarget( target );
	self.ignoreall = false;
	
	self.moveplaybackrate = 1.0;
	
	wait 1;
	
	self.moveplaybackrate = .85;
	
	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", 1 );	
	wait .5;
	
	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", 1.5 );
	
	wait .25;
	
	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", 1.25 );
		
	self disable_arrivals();
	self disable_exits();
	
	wait .2;
	
	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", 1.75 );
		
	self disable_arrivals();
	self disable_exits();
	
	self massacre_reset_animscripts_to_goal();
	
	self orientmode( "face angle", node.origin[ 1 ] );
	wait .5;
		
	self.ignoreall = false;
	
	self clearentitytarget();
	self disable_dontevershoot();
	
	if( flag( "massacre_runners1_dead" ) && flag( "massacre_runners2_dead" ) && flag( "massacre_runners3_dead" ) )
		return;
	
	self thread spray_and_pray( 0, .5, true, undefined, 2 );	
		
	flag_wait( "massacre_runners1_dead" );
	flag_wait( "massacre_runners2_dead" );
	flag_wait( "massacre_runners3_dead" );
	wait 1.5;
		
	self notify( "stop_spray_and_pray" );	
}

massacre_killers_shotgun( node )
{	
	self thread massacre_killers_kill_runaway( .25 );
	self thread massacre_killers_kill_rambo( .25 );
	
	self.moveplaybackrate = 1.0;		
	wait 11;
	self.moveplaybackrate = 1.1;	
	
	level.makarov waittill( "m79_shot2" );
	
	self thread anim_generic_run( self, "casual_killer_flinch" );
	self.moveplaybackrate = 1.35;
		
	self waittill( "reached_path_end" );
	self enable_arrivals();
	flag_wait( "massacre_rentacop_rambo_dead" );
	self anim_generic( self, "casual_killer_walk_stop" );
	
	self.moveplaybackrate = .85;
	wait .5;
	
	self set_generic_run_anim( "casual_killer_jog_A" );	
	self enable_exits();
	self enable_arrivals();
	
	node = getnode( "massacre_elevator_support_node", "targetname" );
	self follow_path( node );
	
	self clear_run_anim();
	self.moveplaybackrate = 1.0;
	
	wait 1;
	
	trig = getent( "massacre_line_of_fire_trig", "targetname" );
	trig thread player_line_of_fire( "massacre_line_of_fire_done", level.team );
	
	add_wait( ::trigger_wait_targetname, "massacre_line_of_fire_trig_final" );
	add_abort( ::flag_wait, "massacre_line_of_fire_done" );
	level.player add_call( ::kill );
	thread do_wait();
	
	self.ignoreall = false;
	self disable_dontevershoot();
	self thread spray_and_pray( 0, .25, false, -1, 15 );	
								
	flag_wait( "massacre_runners1_dead" );
	flag_wait( "massacre_runners2_dead" );
	flag_wait( "massacre_runners3_dead" );
	wait .5;
		
	self notify( "stop_spray_and_pray" );
	
	flag_set( "massacre_line_of_fire_done" );
}

massacre_restaurant_destroy()
{
	roof = getent( "massacre_post_roof", "script_noteworthy" );
	
	poles = getentarray( "massacre_post_post_exp", "targetname" );
	foreach( pole in poles )
	{
		pieces = getentarray( pole.target, "targetname" );
		
		foreach( piece in pieces )
			piece hide();
			
		pole hide();
	}
	level.makarov waittill( "m79_shot2" );
	wait .05;
	
	//poles
	poles = getentarray( "massacre_post_post_exp", "targetname" );
	foreach( pole in poles )
	{
		pieces = getentarray( pole.target, "targetname" );
		
		foreach( piece in pieces )
		{
			piece show();
			piece linkto( pole );
		}
			
		pole show();
		
		angle = 10;
		if( isdefined( pole.script_noteworthy ) )
			angle = -10;
		
		time = .1;
		pole rotatepitch( angle, time, 0, time );
		//pole notsolid(); // --> FIX ME I'M SLOW
	}
		
	pole = getent( "massacre_post_pre_exp", "targetname" );
	pole delete();
	
	//glass
	vec = anglestoforward( (0,180,0) );
	vec = vec * 500;
	glass = getglassarray( "massacre_glass_exp_1" );
	array_levelcall( glass, ::destroyglass, vec );
	
	roof playsound( "storefront_glass_pane_blowout" );
	pole = getent( "massacre_post_top", "script_noteworthy" );
	pole playsound( "storefront_wood_break" );

	//sign
	sign = getent( "massacre_sign", "script_noteworthy" );
	sign PhysicsLaunchClient( sign.origin + (0,50,5), (50,500,-100) );
	
	wait 1;
	roof playsound( "storefront_wood_collapse" );	
	pole linkto( roof );
			
	//angles = (-2.912, 2.421, -2.40804);
	angles = ( 357.694 - 360, 3.01101, -13.3077 );
	time = .7;
		
	roof rotateto( angles, time, time );
			
	foreach( pole in poles )
	{
		if( isdefined( pole.script_noteworthy ) )
			continue;
		
		timex = .25;
		pole rotateroll( -4, timex, 0, timex );
	}
	
	wait time;
		
	time = .35;
	roof rotateto( angles * .7, time, 0, time );
	wait time - .05;
	
	roof rotateto( angles, time, time );
	
	wait time;
	time = .2;
	roof rotateto( angles * .9, time, 0, time );
	wait time;
	
	roof rotateto( angles, time, time );
}

massacre_killers_makarov( node )
{		
	self thread massacre_killers_kill_rush();	
		
	self.moveplaybackrate = 1.37;	
		
	wait 12;
	self forceuseweapon( self.secondaryweapon, "primary" );
	wait 2;
	
	height = (0,0,10);
	self thread notify_delay( "m79_shot", .15 );
	node = getstruct( "massacre_m79_target_1", "targetname" );
	self fire_thumper( node, height );
	
	wait 2.5;

	//hack
	self.ignoreall = true;
	self.aim_anime = %casual_killer_walk_shoot_R;
	self.aim_weight = 1.0;
	self.aim_time = .5;
	self AnimCustom( ::aim_dir );		
	wait 1;
	
	height = (0,0,15);
	self thread notify_delay( "m79_shot2", .15 );
	node = getstruct( "massacre_m79_target_2", "targetname" );
	self fire_thumper( node, height );
	
	wait .2;
	self AnimCustom( ::aim_stop );	
	
	self.moveplaybackrate = 1.15;
			
	wait 1.5;
	self.ignoreall = false;		
	flag_set( "massacre_nadethrow" );
	
	wait 2.5;
	
	self.ignoreall = true;
	self.aim_anime = %casual_killer_walk_shoot_R;
	self.aim_weight = .25;
	self.aim_time = .5;
	self AnimCustom( ::aim_dir );		
	wait 1.05;
	
		
	flag_set( "massacre_elevator_start" );	
	
	height = (0,0,8);
	self thread notify_delay( "m79_shot3", .2 );
	node = getstruct( "massacre_m79_target_3", "targetname" );
	self fire_thumper( node, height );
	
	self.moveplaybackrate = 1.1;
	
	wait .5;
	self AnimCustom( ::aim_stop );	
	self.ignoreall = false;							
	wait 2.75;
	
	flag_set( "massacre_makarov_point_at_rambo" );	
	self thread anim_generic_run( self, "casual_killer_walk_point" );
	
	wait .25;
	self.moveplaybackrate = 1.35;
	self.primaryweapon = "m4_grunt";
	self forceuseweapon( self.primaryweapon, "primary" );
	
	self waittill( "reached_path_end" );
	
	flag_set( "massacre_eleveator_should_come_up" );
}

fire_thumper( node, height )
{
	magicbullet( self.secondaryweapon, self gettagorigin( "tag_flash" ), node.origin + height );
	playFXontag( getfx( "m79_muzzleflash" ), self, "tag_flash" );	
	
	fireAnim = %pistol_stand_fire_A;
	self setAnimKnobRestart( fireAnim, 1, .2, 1.0 );
	self delaycall( getanimlength( fireAnim ), ::clearAnim, fireAnim, .2 );
}

massacre_killers_makarov2()
{
	wait 2;
	
	target = getent( "massacre_civ_aim_node", "targetname" );
	target.health = 100;
	
	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", .75 );	
	
	wait .5;
	
	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", .5 );	
	
	self setentitytarget( target );
	self.ignoreall = false;
	
	wait .5;
	
	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", .8 );
		
	wait .5;

	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", .5 );	
	
	wait .3;	

	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", .5 );	
	
	wait .25;	

	self thread fire_full_auto( .1, "stop_spray_and_pray" );
	self notify_delay( "stop_spray_and_pray", 1.5 );	

	wait .2;
	
	self massacre_reset_animscripts_to_goal();
	
	wait 1;
	
	self disable_dontevershoot();
	self clearentitytarget();
	self thread spray_and_pray( 0, .25, false );	
	
	add_wait( ::flag_wait_all, "massacre_runners1_dead", "massacre_runners2_dead", "massacre_runners3_dead" );
	add_wait( ::flag_wait, "massacre_elevator_prepare_nade" );
	do_wait_any();
			
	self notify( "stop_spray_and_pray" );
}

massacre_reset_animscripts_to_goal()
{	
	self enable_arrivals();
	self disable_exits();
	self.combatmode = "cover";
	self.moveplaybackrate = 1.0;
	
	self waittill( "reached_path_end" );
	
	self enable_exits();
}

aim_dir()
{
	self notify( "aim_stop" );
	self endon( "aim_stop" );
	
	anime = self.aim_anime;
	weight = self.aim_weight;
	time = self.aim_time;
	
	self.aim_weight = undefined;
	self.aim_time = undefined;
	
	self setAnimLimited( %casual_killer_walk_shoot_F, 1 - weight, time );
	self setAnimLimited( anime, weight, time );
	self setFlaggedAnimKnob( "runanim", %run_n_gun, 1, time );
		
	while( 1 )
		wait 1;
}

aim_stop()
{
	self notify( "aim_stop" );
	self endon( "aim_stop" ); 	
	
	anime = self.aim_anime;
	time = self.aim_time;
	
	if( !isdefined( time ) )
		time = .25;
	
	//self clearanim( %run_n_gun, 0.2 );	
	self setAnimLimited( %casual_killer_walk_shoot_F, 1, time );
	self setAnimLimited( anime, 0, time );
	self setFlaggedAnimKnob( "runanim", %run_n_gun, 1, time );
	
	wait time;
}


massacre_killers_go_nader( node )
{
	level.elevator_nader = self;
		
	self.goalradius = node.radius;
	self setgoalnode( node );
	self waittill( "goal" );
	
	flag_wait_either( "massacre_elevator_prepare_nade", "massacre_rentacops_stairs_dead" );
	
	flag_set( "massacre_elevator_grenade_ready" );
	
	if( flag( "massacre_rentacops_stairs_dead" ) )
		return;
			
	node anim_generic( self, "exposed_grenadeThrowB" );
}

massacre_killers_attack_civs( node )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	self.ignoreall = true;
	self enable_dontevershoot();
	self.noreload = true;
	self.ignoreall = false;
	
	waittillframeend;//because animscripts is going to set his angle on goal after this.
	animset_stand = anim.animsets.defaultStand;
	animset_crouch = anim.animsets.defaultCrouch;
		
	while(  abs( self.angles[ 1 ] - node.angles[1] ) > 5  )
	{
		//overzealous application ( because code/animscripts love to fuck with orientmode all the time and he may never turn to this angle )
		self orientmode( "face angle", 180 );
		wait .1;
	}	
		
	self thread massacre_lean_shoot_anims();	
	node = getstruct( "massacre_civ_lobby_aim_node", "targetname" );	
	
	self thread spray_and_pray_node( 0, 4, node );
	self delaythread( 1.5, ::massacre_killers_attack_civs_burst_fire );
	self ent_flag_set_delayed( "massacre_firing_into_crowd", 1 );
				
	flag_wait( "massacre_civ_animate" );
	
	wait 10.5;
	
	self notify( "stop_burst_fire" );
	self notify( "stop_fire_full_auto" );
	
	wait .25;
	
	self notify( "stop_spray_and_pray" );
		
	self disable_dontevershoot();
	self.coverCrouchLean_aimmode 	= undefined;
	self.customMoveAnimSet 			= undefined;		
	self.combatStandAnims 			= undefined;
	self.combatCrouchAnims 			= undefined;
	waittillframeend;
}

massacre_killers_attack_civs_burst_fire()
{
	self endon( "stop_spray_and_pray" );
	self endon( "stop_burst_fire" );
	
	while( 1 )
	{
		self thread fire_full_auto( .1, "stop_fire_full_auto" );
		wait randomfloatrange( 2, 3 );
		self notify( "stop_fire_full_auto" );
		wait randomfloatrange( .2, .4 );
	}	
}

massacre_lean_shoot_anims()
{
	self.coverCrouchLean_aimmode = 1;
	animset = anim.animsets.defaultStand;
			
	animset[ "add_aim_up" ] 	= %exposed_aim_8;
	animset[ "add_aim_down" ] 	= %exposed_aim_2;
	animset[ "add_aim_left" ] 	= %exposed_aim_4;
	animset[ "add_aim_right" ] 	= %exposed_aim_6;
	animset[ "straight_level" ] = %covercrouch_lean_aim5;
		
	self animscripts\animset::init_animset_complete_custom_stand( animset );
	self animscripts\animset::init_animset_complete_custom_crouch( animset );	
}

/************************************************************************************************************/
/*													GATE													*/
/************************************************************************************************************/
gate_moveout( node )
{
	self ent_flag_wait( "gate_ready_to_go" );
	waittillframeend;
	flag_wait( "gate_main" );
	flag_wait( "gate_player_ready" );
	
	self pushplayer( true );
	self disable_arrivals();
	self delaythread( 2, ::disable_exits );	
	
	self.noreload = undefined;
	self.moveplaybackrate = 1.15;
	self enable_calm_combat();
	self.interval = 50;
		
	switch( self.script_noteworthy )
	{
		case "saw":
			wait .75;
			self thread follow_path( node );
			
			self add_wait( ::flag_wait, "gate_heli_moveon" );
			self add_func( ::delaythread, 1.6, ::gate_do_jog, node );
			thread do_wait();
			self thread gate_do_jog2();
			
			break;
		case "makarov":
			wait .25;
			self thread follow_path( node );
			
			self add_wait( ::flag_wait, "gate_heli_moveon" );
			self add_func( ::delaythread, .1, ::gate_do_jog, node );
			thread do_wait();
			self thread gate_do_jog2();
			
			self gate_moveout_makarov( node );
			break;
		case "shotgun":
			wait .5;
			self thread follow_path( node );
			
			self add_wait( ::flag_wait, "gate_heli_moveon" );
			self add_func( ::delaythread, 1.5, ::gate_do_jog, node );
			thread do_wait();
			self thread gate_do_jog2();
			
			break;			
		case "m4":
			wait .15;
			self thread follow_path( node );
			
			self add_wait( ::flag_wait, "gate_heli_moveon" );
			self add_func( ::delaythread, 2.75, ::gate_do_jog, node );
			thread do_wait();
			self thread gate_do_jog2();
			
			self.moveplaybackrate = 1.25;
			wait 8;
			self.moveplaybackrate = 1.15;
			break;	
	}
}

gate_do_jog( node )
{	
	self.moveplaybackrate = .9;
	self set_generic_run_anim( "casual_killer_jog_A" );	
	
	node = getnode( node.target, "targetname" );
	node waittill( "trigger" );
	
	wait .5;
		
	self clear_run_anim();
	
	node = getnode( node.target, "targetname" );
	node waittill( "trigger" );
	
	wait .5;
	
	if( self.script_noteworthy != "m4" )
		self set_generic_run_anim( "casual_killer_jog_A" );	
	
	switch( self.script_noteworthy )
	{
		case "makarov":
			wait .75;
		case "shotgun":
			wait .5;
		case "saw":
			wait 1;
		case "m4":
			wait .15;		
			break;
	}
				
	self clear_run_anim();
	self.moveplaybackrate = 1.2;
}

gate_do_jog2()
{
	name = "basement_start_" + self.script_noteworthy;
	node = getnode( name, "targetname" );
	
	node waittill( "trigger" );
	
	self set_generic_run_anim( "casual_killer_jog_A" );	
	if( self.script_noteworthy == "saw" )
		self.moveplaybackrate = 1.1;
	else
		self.moveplaybackrate = 1.0;
		
	self.bulletsInClip = weaponClipSize( self.weapon );
	
	flag_set( "basement_near_entrance" );
}

gate_moveout_makarov( node )
{	
	self.moveplaybackrate = 1.35;
	
	wait 6;
	
	self.moveplaybackrate = 1.27;
	
	node waittill( "trigger" );
		
	//node anim_generic_run( self, "casual_killer_walk_point" );
		
	self.moveplaybackrate = 1.2;
	
	flag_set( "gate_heli_moveon" );
	
	thread radio_dialogue( "airport_mkv_letsgo2" );
	wait .5;
//	thread music_anticipation();
}

gate_canned_deaths_execute( enemy, type )
{	
	self endon( "death" );
	
	if( enemy.health <= 0 )
		return;
				
	//set dont ever shoot at the right time if enemy is alive	
	self add_wait( ::_wait, enemy.script_delay );
	enemy add_abort( ::waittill_msg, "death" );
	self add_func( ::upperdeck_canned_deaths_execute_fire, enemy );
	thread do_wait();
	
	//wait to start aiming
	self upperdeck_canned_deaths_execute_wait( enemy );
	
	self maps\_casual_killer::enable_casual_killer();			
	self maps\_casual_killer::set_casual_killer_run_n_gun( type );	
	self.dontevershoot = true;
	self disable_dynamic_run_speed();
	self ent_flag_set( "aiming_at_civ" );
	target = enemy;
	
	if( isai( enemy ) )
	{			
		target = spawn( "script_origin", enemy.origin + (0,0,35) );
		target.health = 100;
		//target = spawn( "script_model", enemy gettagorigin( "j_ankle_ri" ) + (0,0,10) );
		//target setmodel( "weapon_us_smoke_grenade" );
		target linkto( enemy );
	}
	
	self setentitytarget( target );
	
	wait .5;
		
	if( enemy.health > 0 )
		enemy waittill( "death" );

	wait .25;
	self notify( "upperdeck_canned_deaths_execute_fire" );
	wait .25;
	self clearentitytarget();
	
	if( target != enemy )
		target delete();
	self disable_dontevershoot();
	
	self enable_dynamic_run_speed( undefined, undefined, undefined, undefined, level.team, true );
	self ent_flag_clear( "aiming_at_civ" );
	self maps\_casual_killer::set_casual_killer_run_n_gun( "straight" );
	self maps\_casual_killer::disable_casual_killer();
	self walkdist_zero();
}

gate_drs_ahead_test( node, dist )
{
	foreach ( player in level.players )
	{
		if ( distancesquared( player.origin, self.origin ) < squared( dist ) )
			return true;
	}

	//ok guess he's not here yet	
	return false;	
}

gate_convoy_delete()
{
	flag_wait( "basement_moveout" );	
	
	self delete();
}

gate_crawler()
{
	self.health = 1;
	self.ignoreexplosionevents = true;	
	self.ignoreme = true;
	self.ignorerandombulletdamage = true;
	self.grenadeawareness = 0;
	self disable_surprise();
		
	self endon( "death" );
	
	switch( self.animation )
	{
		case "civilian_crawl_1":
			self anim_generic_first_frame( self, "civilian_crawl_1" );
			self force_crawling_death( self.angles[ 1 ], 3, level.scr_anim[ "crawl_death_1" ], 1 );
			break;
		case "civilian_crawl_2":
			self anim_generic_first_frame( self, "civilian_crawl_1" );
			self force_crawling_death( self.angles[ 1 ], 3, level.scr_anim[ "crawl_death_1" ], 1 );	
			break;
		case "dying_crawl":
			self anim_generic_first_frame( self, "dying_crawl" );
			self force_crawling_death( self.angles[ 1 ], 4, undefined, 1 );	
			break;
	}
	
	self dodamage( 1, level.player.origin );
	self.noragdoll = 1;
}

gate_runners_setup()
{	
	wait .05;
	
	self.allowdeath = 1;
	self thread anim_generic_loop( self, self.animation );
	
	self.useChokePoints = false;
	self.ignoreme 		= true;
	self.ignoreall 		= true;
	
	self.ignorerandombulletdamage = true;
	self.ignoreexplosionevents 		= true;	
	self.grenadeawareness 			= 0;
	self.ignoresuppression 			= 1;
	self.disableBulletWhizbyReaction = true;
	self disable_surprise();		
}

gate_runners1()
{
	self endon( "death" );
	
	gate_runners_setup();
	
	if( !isdefined( level.massacre_runners2 ) )
	{
		level.massacre_runners2 = [];
		level.massacre_runners2[ level.massacre_runners2.size ] = self;
		wait .1;
		thread running_civ_soundscape( level.massacre_runners2, "scn_airport_running_screams1" );
		wait .05;
		level.massacre_runners2 = undefined;
	}
	else
		level.massacre_runners2[ level.massacre_runners2.size ] = self;
			
	wait randomfloat( 1 );
	
	self notify( "stop_loop" );
	self stopanimscripted();
		
	self.interval = 50;
	self.ignorerandombulletdamage 	= false;		
		
	node = getnode( self.target, "targetname" );	
	
	self follow_path( node );
	wait .25;
	self delete();
}

gate_sliders()
{
	self endon( "death" );
	
	gate_runners_setup();
	node = getstruct( self.target, "targetname" );
	
	anime = undefined;
	runanim = undefined;
	switch( node.targetname )
	{
		case "gate_civ_slide":
			self.moveplaybackrate = 1.0;
			anime = "civilian_run_hunched_turnR90_slide";
			runanim = "civilian_run_hunched_A";
			wait .25;
			break;
		case "gate_civ_slide2":
			anime = "airport_civilian_run_turnR_90";
			runanim = "civilian_run_hunched_C";
			self.moveplaybackrate = 1.15;
			break;	
	}
	
	wait 6.5;
	
	self notify( "stop_loop" );
	self stopanimscripted();	
	self.interval = 50;
	self.ignorerandombulletdamage 	= false;		
	
	self set_generic_run_anim( runanim, true );		
	node anim_generic_reach( self, anime );
	node anim_generic_run( self, anime );
	
	self follow_path( getnode( "gate_civ_node", "targetname" ) );
	wait .25;
	self delete();
}

gate_departures_status()
{
	flag_wait( "gate_do_status" );
	
	wait 1;
	
	snds = getentarray( "snd_departure_board", "targetname" );
	foreach( member in snds )
		member playsound( member.script_soundalias );
	
	array = array_randomize( level.departure_status_array );
	foreach( index, value in array )
		value delaythread( ( index * .1 ), ::sign_departure_status_flip_to, "delayed" );	
}

gate_klaxon_rotate()
{
	wait randomfloat( .5 );
	time = randomfloatrange( 1, 1.15 );
	while( 1 )
	{
		self rotateyaw( 360, time );
		self waittill( "rotatedone" );
	}
}

gate_open_gate()
{
	dist = 85;
	gate1 = getent( "gate_gate_closing", "targetname" );
	gate2 = getent( "gate_gate_closing2", "targetname" );
	
	gate2 connectpaths();
	
	gate1 movez( dist, .25 );	
	gate2 movez( dist * 2, .25 );
}

gate_close_gate()
{	
	dist = 85;
	gate1 = getent( "gate_gate_closing", "targetname" );
	gate2 = getent( "gate_gate_closing2", "targetname" );
			
	time = 1.5;
	gate1 movez( dist * -1, time );	
	gate2 movez( dist * -2, time * 2 );	
	
	gate1 playsound( "scn_airport_sec_gate_close" );
	
	wait time * 2;
	gate2 disconnectpaths();
	
	time = .1;
	
	gate1 movez( 2 , time );	
	gate2 movez( 2 , time );	
	
	wait time;
	
	gate1 movez( -2 , time );	
	gate2 movez( -2 , time );	
}

gate_stairs_player_allow_sprint()
{
	flag_wait( "gate_heli_moveon" );
	flag_clear( "player_dynamic_move_speed" );
	wait .05;
	level.player AllowSprint( true );

	flag_wait( "gate_player_off_stairs" );
	
	thread player_dynamic_move_speed();
}

/************************************************************************************************************/
/*													BASEMENT												*/
/************************************************************************************************************/
basement_drop_chop_guys()
{
	self endon( "death" );
	
	self.ignoreall = true;
	self.ignoreme = true;
	
	self add_wait( ::waittill_msg, "damage" );
	self add_func( ::set_ignoreall, false );
	thread do_wait();
	
	self add_wait( ::waittill_msg, "goal" );
	add_wait( ::trigger_wait, "tarmac_security", "target" );
	do_wait_any();
	
	self delete();
}

basement_sec_runner()
{
	self endon( "death" );	
	
	self notify( "move" );
	
	trigger_wait( "tarmac_security", "target" );	
	
	self delete();
}

basement_door_kick( light, lightintensity )
{
	//2 guys down the stairs
	nodes = getnodearray( "basement_moveup1", "targetname" );	
	light setlightintensity( lightintensity );
	animnode = undefined;
	
	foreach( node in nodes )
	{
		switch( node.script_noteworthy )
		{
			case "saw":
				level.team[ node.script_noteworthy ] delaythread( .8, ::follow_path, node );
				level.team[ node.script_noteworthy ].moveplaybackrate = 1.0;
				break;
			default:
				level.team[ node.script_noteworthy ] enable_cqbwalk();
				level.team[ node.script_noteworthy ] thread follow_path( node );
				level.team[ node.script_noteworthy ].moveplaybackrate = 1.0;
				animnode = node;
				break;
		}
		
	}
	
	level.makarov waittill( "reached_path_end" );
	delaythread( 1,::radio_dialogue, "airport_mkv_thisway" );
	
	level.makarov disable_exits();	
	animnode thread anim_generic_run( level.makarov, "doorkick_basement" );
	level.makarov waittillmatch( "single anim", "kick" );
	level.makarov delaythread( 2, ::enable_exits );	
}

basement_makarov_speach()
{
	flag_wait( "basement_mak_speach" );
	node = level.makarov.last_set_goalnode;
	
	level.makarov delaythread( 2.25, ::dialogue_queue, "airport_mkv_forzakhaev" );
	node thread anim_generic_gravity( level.makarov, "bog_a_start_briefing" );	
	
	wait 3.75;
	level.makarov notify( "stop_animmode" );
	level.makarov stopanimscripted();
}

basement_pre_moveout()
{
	flag_wait( "gate_heli_moveon" );
	self waittill( "reached_path_end" );
	
	self disable_calm_combat();
	self enable_arrivals();
	self.moveplaybackrate = 1.0;
	self.combatmode = "cover";
	
	node = self.last_set_goalnode;
	self.goalradius = 4;
	self setgoalnode( node );
	self waittill( "goal" );
	
	wait 1;
		
	if( self.script_noteworthy == "makarov" )
		flag_set( "basement_mak_speach" );
	
	self enable_exits();
	self clear_run_anim();
}

basement_moveup()
{
	foreach( member in level.team )
		member enable_cqbwalk();		
		
	//4 to beginning of hallway
	nodes = getnodearray( "basement_moveup2", "targetname" );
	foreach( node in nodes )
	{
		name = node.script_noteworthy;
		if( name == "makarov" )
			level.team[ name ] thread follow_path( node );
		else if( name == "saw" )
		{
			level.team[ name ].noDodgeMove = true;
			level.team[ name ] delaythread( .75, ::follow_path, node );
		}
		else
			level.team[ name ] delaythread( 0.25, ::follow_path, node );
	}
	level.team[ "shotgun" ] pushplayer( false );
	level.team[ "m4" ] pushplayer( false );
		
	level.makarov waittill( "reached_path_end" );
	flag_set( "basement_mak_saw_riot" );
	level.makarov thread anim_generic( level.makarov, "CornerStndR_alert_signal_enemy_spotted" );	
}

basement_flicker_light()
{
	intensity = self getlightintensity();
	
	while( 1 )
	{
		self setlightintensity( intensity * randomfloatrange( .5, 1.25 ) );
		wait .1;	
	}
}

/************************************************************************************************************/
/*													TARMAC													*/
/************************************************************************************************************/
tarmac_difficulty_mod()
{
	if( isdefined( self.script_drone ) )	
		return;
		
	type = maps\_gameskill::get_skill_from_index( level.player.gameskill );
	
	switch( type )
	{
		case "easy":
			self.grenadeammo = 0;
			self.baseaccuracy *= .5;
			break;
		case "normal":
			self.grenadeammo = 0;
			self.baseaccuracy *= .5;
			break;
	}
}

tarmac_van_guys( _flag )
{
	flag_set( _flag );
	
	self endon( "death" );
	
	self.ignoreme = true;
	self.ignoreall = true;
	
	self waittill( "unload" );
	
	self.ignoreme = false;
	self.ignoreall = false;	
				
	if( isdefined( self.script_noteworthy ) && issubstr( self.script_noteworthy, "tarmac_van_riotshield_guys" ) )
		return;
	
	if( isdefined( self.target ) )
	{
		node = getnode( self.target, "targetname" );
		self setgoalnode( node );
		self.goalradius = node.radius;	
		
		trigger_wait_targetname( "tarmac_advance5" );
	}
	self set_force_color( "blue" );
}

tarmac_van_logic()
{	
	van = self;
	
	node = getvehiclenode( "tarmac_van_mid_path", "script_noteworthy" );
	node add_wait( ::waittill_msg, "trigger" );
	van add_func( ::delaythread, .1, ::play_sound_on_entity, "airport_tire_skid" );
	node add_func( ::flag_set, "tarmac_van_mid_path" );
	add_func( maps\airport::tarmac_bcs_van );
	thread do_wait();
	
	node = getvehiclenode( "tarmac_van_almost_end_path", "script_noteworthy" );
	node add_wait( ::waittill_msg, "trigger" );
	node add_func( ::flag_set_delayed, "tarmac_van_almost_end_path", 1 );
	thread do_wait();
	
	node = getvehiclenode( "tarmac_van_end_path", "targetname" );
	node add_wait( ::waittill_msg, "trigger" );
	node add_func( ::flag_set, "tarmac_van_end_path" );
	do_wait();
}

tarmac_riotshield_group_van( _flag, vanname, name )
{
	flag_wait( _flag );
	wait .1;
	
	team = get_living_ai_array( name, "script_noteworthy" );
	
	if( !team.size )
	{
		level notify( "tarmac_riotshield_group_van_ready" );
		return;
	}	
	node = getstruct( team[0].target, "targetname" );
	dir = anglestoForward( node.angles );
	
	group = group_create( team );
	group thread tarmac_riotshield_group_van_handle_break( team );
	group endon( "break_group" );	
	
	foreach( member in team )
		member disable_exits();
	group group_sprint_on();
	group group_lock_angles( dir );
	group group_initialize_formation( dir );
	group group_move( node.origin, dir );	
	
	group waittill( "goal" ); 
	
	group group_sprint_off();		
	foreach( member in team )
		member enable_exits();
	
	level notify( "tarmac_riotshield_group_van_ready" );
}

tarmac_riotshield_group_van_combine()
{
	level waittill( "tarmac_riotshield_group_van_ready" );

	level notify( "redoing_riot_groups" );
	level endon( "tarmac_riotshield_group_last_stand" );
	
	team = get_living_ai_array( "tarmac_van_riotshield_guys", "script_noteworthy" );
	team = array_combine( team, get_living_ai_array( "tarmac_van_riotshield_guys2", "script_noteworthy" ) );
	team = array_combine( team, get_living_ai_array( "riotshield_group_1", "script_noteworthy" ) );
	team = array_combine( team, get_living_ai_array( "riotshield_group_2", "script_noteworthy" ) );
	team = array_combine( team, get_living_ai_array( "riotshield_group_3", "script_noteworthy" ) );
		
	group = group_create( team );
	if( group.ai_array.size < 9 )
		group.fleethreshold = 2;
	else
		group.fleethreshold = floor( group.ai_array.size * .25 );
	group thread tarmac_riotshield_group_handle_break( team );
	group endon( "break_group" );
	
	group group_sprint_off();		
	foreach( member in team )
		member enable_exits();
	
	node = getstruct( "tarmac_riot_node_retreat1_group_van", "targetname" );
	dir = anglestoForward( node.angles );
	
	group group_lock_angles( dir );
	group group_initialize_formation( dir );
	group group_move( node.origin, dir );
	group thread tarmac_retreat_logic(); 	
	
	group waittill_notify_or_timeout( "goal", 5 );
	flag_set( "tarmac_van_guys_far_enough" );
}

tarmac_riotshield_group_last_stand()
{
	trigger_wait( "tarmac_advance6", "targetname" );

	actors = get_living_ai_array( "tarmac_van_riotshield_guys", "script_noteworthy" );
	actors = array_combine( actors, get_living_ai_array( "tarmac_van_riotshield_guys2", "script_noteworthy" ) );
	actors = array_combine( actors, get_living_ai_array( "riotshield_group_1", "script_noteworthy" ) );
	actors = array_combine( actors, get_living_ai_array( "riotshield_group_2", "script_noteworthy" ) );
	actors = array_combine( actors, get_living_ai_array( "riotshield_group_3", "script_noteworthy" ) );
	
	//nodes from left to right
	nodes = [];
	nodes[ "weak" ] 	= getstruct( "tarmac_riotshield_van2_retreat1", "targetname" );
	nodes[ "center" ]	= getstruct( "tarmac_riotshield_consolodate_node", "targetname" );
	nodes[ "strong" ] 	= getstruct( "tarmac_riotshield_van1_retreat1", "targetname" );
	
	tarmac_riotshield_group_last_stand_proc( actors, nodes );
	
	trigger_wait( "tarmac_retreat5", "targetname" );

	actors = array_removedead( actors );
	
	//nodes from right to left
	nodes = [];
	nodes[ "weak" ] 	= getstruct( "tarmac_riotshield_last_stand_right", "targetname" );
	nodes[ "center" ]	= getstruct( "tarmac_riotshield_last_stand_center", "targetname" );
	nodes[ "strong" ] 	= getstruct( "tarmac_riotshield_last_stand_left", "targetname" );
	
	groups = tarmac_riotshield_group_last_stand_proc( actors, nodes );
		
	trigger_wait( "tarmac_retreat6", "targetname" );
	
	if( !isdefined( groups ) )
		return;
	
	foreach( group in groups )
		group.fleethreshold = 10;
}

tarmac_riotshield_group_last_stand_proc( actors, nodes )
{
	level notify( "tarmac_riotshield_group_last_stand" );
	level notify( "redoing_riot_groups" );
			
	teams = [];
	
	newarray = [];
	foreach( member in actors )
	{
		if( member.combatMode != "no_cover"	)
			continue;//means they lost their shield or were never a riotshield guy
		newarray[ newarray.size ] = member;
	}
	
	actors = newarray;
	
	switch( actors.size )
	{
		case 0:
			return;	
		case 1:
		case 2:
		case 3:
		case 4:
			teams[ "center" ] = actors;
			break;
		case 5:// 0 3 2
		case 6:// 0 3 3
			teams[ "center" ] = get_array_of_farthest( nodes[ "strong" ].origin, actors, undefined, 3 );
			teams[ "strong" ] = array_remove_array( actors, teams[ "center" ] );
			break;
		default:
			magic_number = ( actors.size / 3 ) - .2;
			main = ceil( magic_number );
			diff = ceil( magic_number * 2 );
			
			teams[ "strong" ] = get_array_of_closest( nodes[ "strong" ].origin, actors, undefined, actors.size - diff );
			actors = array_remove_array( actors, teams[ "strong" ] );
			teams[ "weak" ] = get_array_of_closest( nodes[ "weak" ].origin, actors, undefined, actors.size - main );
			teams[ "center" ] = array_remove_array( actors, teams[ "weak" ] );
			break;
	}
	
	groups = [];
	foreach( key, team in teams )
	{
		foreach( member in team )
			member enable_exits();
		node = nodes[ key ];
		dir = anglestoForward( node.angles );	
		group = group_create( team );
		if( group.ai_array.size > 3 )
			group.fleethreshold = 2;
		group thread tarmac_riotshield_group_handle_break( team );
		group group_sprint_off();	
		group group_lock_angles( dir );
		group group_initialize_formation( dir );
		group group_move( node.origin, dir );
		group thread tarmac_retreat_logic();
		groups[ groups.size ] = group;
	}	
	
	return groups;
}

tarmac_riotshield_group_van_handle_break( team )
{
	level endon( "redoing_riot_groups" );
	
	self waittill( "break_group" );	
		
	team = array_removedead( team );
	foreach( member in team )
	{
		member riotshield_unlock_orientation();
		member riotshield_sprint_off();
		member.goalradius = 1024;
		member set_force_color( "blue" );
	}
}

tarmac_move_through_smoke()
{
	self endon( "death" );
	self setgoalpos( self.origin );
	self.goalradius = 16;
	self disable_exits();
	
	flag_wait( "tarmac_heat_fight" );
	wait 1.3;
	
	node = getnode( self.target, "targetname" );
	if( !isdefined( node ) )
		node = getstruct( self.target, "targetname" );
	
	goal_type = undefined;
	//only nodes and structs dont have classnames - ents do
	if ( !isdefined( node.classname ) )
	{
		//only structs don't have types, nodes do
		if ( !isdefined( node.type ) )
			goal_type = "struct";
		else
			goal_type = "node";
	}
	else
		goal_type = "origin";

	require_player_dist = 300;
	
	//calling this because i DO want the radius to explode	
	self thread maps\_spawner::go_to_node( node, goal_type, undefined, require_player_dist );
	
	wait 1;
	self enable_exits();
}	

tarmac_enemies_wave1()
{
	self endon( "death" );
	
	self.dontevershoot = true;
	self.targetname = "tarmac_enemies_wave1";
	thread enable_teamflashbangImmunity();
	self enable_teamflashbangImmunity();
	//self addAIEventListener( "grenade danger" );
	
	self add_wait( ::waittill_msg, "damage" );
	//self add_wait( ::_waittillmatch, "ai_event", "grenade danger" );
	self add_wait( ::waittill_msg, "bullet_hitshield" );
	level add_wait( ::flag_wait, "tarmac_open_fire" );
	do_wait_any();
	
	flag_set( "tarmac_open_fire" );
	
	wait randomfloatrange( .75, 1.25 );
	
	self.dontevershoot = undefined;
	
	if( !isdefined( self.script_noteworthy ) || !issubstr( self.script_noteworthy, "riotshield_group" ) )
		self.goalradius = 1500;
	else
		return;//dont want riotshield guys going blue just yet
		
	trigger_wait_targetname( "tarmac_retreat1" );
	self set_force_color( "blue" );
}

tarmac_enemies_wave2()
{
	self endon( "death" );
	self waittill( "goal" );
	wait .1;
	self.goalradius = 1024;
		
	flag_wait( "tarmac_advance4" );
	
	self set_force_color( "blue" );
}

tarmac_riotshield_group( name )
{
	flag_wait( "tarmac_heat_fight" );
	
	level endon( "tarmac_riotshield_group_van_ready" );
	level endon( "redoing_riot_groups" );
	
	wait .05;
	dir = anglestoForward( (0,360,0) );
	
	team = get_living_ai_array( name, "script_noteworthy" );
	foreach( member in team )
		member riotshield_lock_orientation( 360 );
	
	group = group_create( team );
	if( group.ai_array.size > 3 )
		group.fleethreshold = 2;
	group group_initialize_formation( dir );
	group endon( "break_group" );	
		
	group thread tarmac_riotshield_group_handle_break( team );
		
	node = undefined;
	nodename = undefined;
	
	switch( name )
	{
		case "riotshield_group_1":
			nodename = "group1";
			break;	
		case "riotshield_group_2":
			nodename = "group2";
			break;	
	}
	
	wait 10;//wait for certain time before even thinking of retreating.
	//iprintlnbold( "retreat" );
					
	flag_wait( "tarmac_retreat1" );
	
	node = getstruct( "tarmac_riot_node_retreat1_" + nodename, "targetname" );
	group group_move( node.origin, dir );
	group thread tarmac_retreat_logic();
	
	flag_wait( "tarmac_retreat2" );
	
	node = getstruct( "tarmac_riot_node_retreat2_" + nodename, "targetname" );
	group group_move( node.origin, dir );	
	group thread tarmac_retreat_logic();
	
	flag_wait( "tarmac_retreat3" );
		
	node = getstruct( "tarmac_riot_node_retreat3_" + nodename, "targetname" );
	group group_move( node.origin, dir );	
	group thread tarmac_retreat_logic();
}

tarmac_retreat_logic()
{
	
	team = array_removedead( self.ai_array );
	if( !team.size )
		return;
		
	self group_fastwalk_on();
	
	foreach( member in team )
	{
		member notify( "tarmac_retreat_logic" );
		
		member add_wait( ::waittill_msg, "goal" );		
		level add_endon( "redoing_riot_groups" );
		self add_endon( "break_group" );
		member add_endon( "damage" );
		member add_endon( "bad_path" );
		member add_abort( ::waittill_msg, "tarmac_retreat_logic" );
		member add_func( ::riotshield_fastwalk_off );
		thread do_wait();
	}
	
}

tarmac_riotshield_group_handle_break( team )
{
	level endon( "redoing_riot_groups" );
	self waittill( "break_group" );	
	
	team = array_removedead( team );
	foreach( member in team )
		member set_force_color( "blue" );
}

tarmac_riotshield_group_3()
{
	level endon( "tarmac_riotshield_group_van_ready" );
	
	trigger_wait( "tarmac_enemies_wave2", "target" );
		
	node = getstruct( "tarmac_riot_node_group3", "targetname" );
	
	wait .05;
	
	dir = anglestoForward( node.angles );
	
	team = get_living_ai_array( "riotshield_group_3", "script_noteworthy" );
		
	group = group_create( team );
	group.fleethreshold = 2;
	group group_lock_angles( anglestoforward( (0,360,0) ) );
	group group_initialize_formation( dir );
		
	group thread tarmac_riotshield_group3_handle_break( team );
		
	group group_move( node.origin, dir );		
	group group_sprint_on();
	
	group add_wait( ::waittill_msg, "goal" );
	group add_wait( ::waittill_msg, "break_group" );
	level add_wait( ::flag_wait, "tarmac_advance4" );
	do_wait_any();
	
	group group_sprint_off();
	
	level notify( "redoing_riot_groups" );
	
	team = get_living_ai_array( "riotshield_group_3", "script_noteworthy" );
	team = array_combine( team, get_living_ai_array( "riotshield_group_1", "script_noteworthy" ) );
	team = array_combine( team, get_living_ai_array( "riotshield_group_2", "script_noteworthy" ) );	
	group = group_create( team );
	group.fleethreshold = 2;
	group group_lock_angles( dir );
	group group_initialize_formation( dir );
	group thread tarmac_riotshield_group3_handle_break( team );
	group group_move( node.origin, dir );
	group thread tarmac_retreat_logic();
	
	flag_wait( "tarmac_advance4" );
	
	node = getstruct( "tarmac_riot_node_group3_retreat1", "targetname" );
	dir = anglestoForward( node.angles );
	group group_lock_angles( dir );
	group group_initialize_formation( dir );
	group group_move( node.origin, dir );	
	group thread tarmac_retreat_logic();
}

tarmac_riotshield_group3_handle_break( team )
{
	level endon( "redoing_riot_groups" );
	self waittill( "break_group" );	
	
	team = array_removedead( team );
	foreach( member in team )
	{
		member riotshield_sprint_off();
		member riotshield_unlock_orientation();
		member set_force_color( "blue" );
	}
}

tarmac_enemies_runners()
{
	self endon( "death" );
	self endon( "long_death" );
	
	self.ignoreme = true;
	self.interval = 0;
	self.disablearrivals = true;
	self disable_surprise();
	self.disableBulletWhizbyReaction = true;
	self set_generic_run_anim( "sprint_loop_distant" );
	
	self waittill( "reached_path_end" );	
	self delete();
}

tarmac_enemies_2ndfloor()
{
	self endon( "death" );
	self endon( "long_death" );
	
	flag_set( "tarmac_enemies_2ndfloor" );
	
	self.interval = 0;
	self setthreatbiasgroup( "2ndfloorenemies" );
	
	self disable_surprise();
//	self.disableBulletWhizbyReaction = true;
	
	self waittill( "goal" );	
	
	self.ignoreall = false;
	
	node = getnode( self.target, "targetname" );
	
	if( isdefined( node.script_noteworthy ) && node.script_noteworthy == "flash_throw" )
	{	
		waittillframeend;//so that the large goal radius will be set
		self.goalradius = 8;
		self.ignoreall = true;
			
		wait randomfloatrange( .5, 1 );
		
		self.allowdeath = true;	
		if( cointoss() )
			self anim_generic( self, "coverstand_grenadeA" );
		else
			self anim_generic( self, "coverstand_grenadeB" );
		
		self.goalradius	= 512;
		self.ignoreall = false;
	}
	
	flag_wait_either( "tarmac_advance6", "tarmac_2ndfloor_move_back" );
	
/*	
	node = getnode( "floor2_node2", "targetname" );
	self.radius = node.radius;
	self setgoalnode( node );
*/
	self.ignoreall = true;
	self.ignoreme = true;
	
	nodes = getnodearray( "floor2_covernodes2", "targetname" );
	foreach( node in nodes )
	{
		if( isdefined( node.taken ) )
			continue;
		
		self.goalradius = 8;
		node.taken = self;
		self setgoalnode( node );	
		break;
	}
	
	self waittill( "goal" );
	self.goalradius = 512;
	self.ignoreall = false;
	self.ignoreme = false;
	
	flag_wait( "tarmac_clear_out_2nd_floor" );
	
	self.ignoreall = true;
	self.ignoreme = true;
	self.goalradius = 64;
	node = getnode( "tarmac_2ndfloor_clearout", "targetname" );
	self setgoalpos( node.origin );
	
	self waittill( "goal" );
	self delete();
}

tarmac_van_stuff( snd, value )
{
	level notify( "spawned" + value );
	
	self playsound( snd );
}

tarmac_van_fake( value )
{
	model = spawn( "script_model", self.origin );
	model.angles = self.angles;
	
	model setmodel( self.model );
	
	level waittill( "spawned" + value );
	model delete();	
}

/************************************************************************************************************/
/*											TARMAC OUTTER EDGE												*/
/************************************************************************************************************/

tarmac_security_backup()
{
	self waittill( "drone_spawned", guy );	
	guy waittill( "death" );
	
	while( 1 )
	{	
		wait 8;
		
		self.count = 1;
		guy = self spawn_ai();
		guy waittill( "death" );
	}
}

tarmac_security()
{
	self endon( "death" );
				
	wait .1;
	
	self.allowdeath = true;
	self give_beretta();
	self ent_flag_init( "moving" );
							
	self add_wait( ::waittill_msg, "death" );
	self add_func( ::flag_set, "tarmac_killed_security" );
	thread do_wait();
	
	//self.target_obj = spawnstruct();
	//self.target_obj.origin = ( 512, 2592, -32 );
	self.target_obj = level.player;
	
	self.ref = spawn( "script_origin", self.origin );
	self add_wait( ::waittill_msg, "death" );
	self.ref add_call( ::delete );
	thread do_wait();
		
	if( isdefined( self.script_noteworthy ) )
		self thread tarmac_sec_node_behavior_loop();
	else
		self thread tarmac_sec_node_simple_loop();
	
	while( 1 )
	{
		self notify( "tarmac_police_fire" );	
		
		flag_wait_either( "tarmac_too_far", "tarmac_killed_security" );
		
		wait randomfloat( 1 );
		
		self thread tarmac_police_fire();
		
		flag_waitopen( "tarmac_too_far" );
		flag_waitopen( "tarmac_killed_security" );
	}
}

tarmac_sec_node_simple_loop()
{
	self endon( "death" );
	self.target_obj endon( "death" );
	
	self tarmac_sec_node_stand_idle();
	
	while( 1 )
	{
		tarmac_sec_node_stand_update();
				
		wait .1;
	}	
}

tarmac_sec_node_behavior_loop()
{
	self endon( "death" );
	self.target_obj endon( "death" );
		
	self.tarmac_sec_node_funcs[ "stand" ] 	= ::tarmac_sec_node_logic_stand;
	self.tarmac_sec_node_funcs[ "walk" ] 	= ::tarmac_sec_node_logic_walk;
	self.tarmac_sec_node_funcs[ "run" ] 	= ::tarmac_sec_node_logic_run;
		
	self.radius = 16;
	
	node = getstruct( self.target, "targetname" );	
	name = "walk";
		
	while( 1 )
	{
		//if the next node is stand - move there first with the last movement type
		if( node.script_noteworthy == "stand" )
			tarmac_sec_do_this_node( node, name );
		
		//otherwise do movement code to the next node
		name = node.script_noteworthy;
		tarmac_sec_do_this_node( node, name );
		
		node = getstruct( node.target, "targetname" );
	}
}	

tarmac_sec_node_logic_stand( node )
{	
	tarmac_sec_node_stand_idle();
	
	interval = .1;
	count = randomfloatrange( 5, 10 );
		
	while( count > 0 )
	{
		tarmac_sec_node_stand_update();
				
		wait interval;
		count -= interval;
	}	
		
	self.ref notify( "stop_loop" );
	self stopanimscripted();
	self unlink();
}

tarmac_sec_node_stand_idle()
{
	self.ref.origin = self.origin;
	self.ref.angles = self.angles;	
	self linkto( self.ref );
	
	
	self ClearAnim( %body, 0.2 );
	self StopAnimScripted();

	self SetFlaggedAnimKnobAllRestart( "drone_anim", %pistol_stand_aim_5, %body, 1, 0.2, 1 );
//	self.ref thread anim_generic_loop( self, "pistol_stand_aim_5" );
}
	
tarmac_sec_node_stand_update()
{
	origin = ( self.target_obj.origin[ 0 ], self.target_obj.origin[ 1 ], self.origin[ 2 ] );
	angles = vectortoangles( origin - self.origin );
	self.ref rotateto( angles, .05 );
}

tarmac_sec_node_logic_walk( node )
{	
	origin = ( self.target_obj.origin[ 0 ], self.target_obj.origin[ 1 ], self.origin[ 2 ] );		
	vec1 = ( origin - self.origin );
	vec2 = anglestoright( vectortoangles( vec1 ) );
	vec3 = ( node.origin - self.origin );
		
	//front
	if( vectordot( vec1, vec3 ) > .4 )
		self.run_anim = "pistol_walk";
	//right
	else if( vectordot( vec2, vec3 ) >= .6 )
		self.run_anim = "pistol_walk_left";
	//left
	else if( vectordot( vec2, vec3 ) <= .6 )
		self.run_anim = "pistol_walk_right";
	//back
	else
		self.run_anim = "pistol_walk_back";	
			
	self.run_rate = 1.0;
	
	self tarmac_sec_node_do_movement( node );
}

tarmac_sec_node_logic_run( node )
{		
	self.run_anim = "pistol_sprint";
	self.run_rate = .8;
	
	self tarmac_sec_node_do_movement( node );
}

//do movement code
tarmac_sec_node_do_movement( node )
{
	self thread tarmac_sec_run_cycle( node );
	
	self tarmac_sec_node_goal( node );
	
	self ClearAnim( %body, 0.2 );
	self StopAnimScripted();	
}

//play proper animations at proper angles
tarmac_sec_run_cycle( node )
{	
	self endon( "death" );
	self endon( "goal" );
	self.target_obj endon( "death" );	
	
	self ClearAnim( %body, 0.2 );
	self StopAnimScripted();

	self SetFlaggedAnimKnobAllRestart( "drone_anim", getanim_generic( self.run_anim ), %body, 1, 0.2, self.moveplaybackrate * self.run_rate );
			
	angles = tarmac_sec_find_move_angles( node );
	
	self rotateTo( angles, .2 );
	wait .2;
		
	while( 1 )
	{
		angles = tarmac_sec_find_move_angles( node );
		
		self rotateto( angles, .2 );
		wait .2;
	}
}

tarmac_sec_find_move_angles( node )
{
	angles = undefined;
	switch( self.run_anim )
	{
		case "pistol_walk_left":
			angles = vectortoangles( anglestoright( vectortoangles( ( self.origin - node.origin ) ) ) );
			break;
		case "pistol_walk_right":
			angles = vectortoangles( anglestoright( vectortoangles( ( node.origin - self.origin ) ) ) );
			break;
		case "pistol_walk":
			angles = vectortoangles( (  node.origin - self.origin ) );
			break;
		case "pistol_walk_back":
			angles = vectortoangles( ( self.origin - node.origin ) );
			break;
		case "pistol_sprint":
			angles = vectortoangles( vectornormalize( node.origin - self.origin ) );
			break;
	}
	return angles;
}

//wait till goal
tarmac_sec_node_goal( node )
{
	self ent_flag_set( "moving" );
	while( distancesquared( self.origin, node.origin ) > squared( self.radius ) )
		wait .05;
	self ent_flag_clear( "moving" );	
	self notify( "goal" );
}

//run the proper logic on this node
tarmac_sec_do_this_node( node, name )
{
/#
	//self thread tarmac_sec_debug_node( node );
#/
	func = self.tarmac_sec_node_funcs[ name ];
	self [[ func ]]( node );
}

//debug lines
tarmac_sec_debug_node( node )
{
	self notify( "debug_goal" );
	thread draw_line_from_ent_to_ent_until_notify( self, node, 1, 1, 1, self, "debug_goal" );
	thread draw_circle_until_notify( node.origin, self.radius, 1, 1, 1, self, "debug_goal" );
}

give_beretta()
{
	self gun_remove();
	self.weapon = "beretta";
	gun = getWeaponModel( self.weapon );
	self attach( gun, "tag_weapon_right" );	
	
	self HidePart( "TAG_SILENCER" );
}

tarmac_littlebird_sniper()
{
	self endon( "death" );
	
	self.ignoreme = true;
	self.favoriteenemy = level.player;
		
	while( 1 )
	{
		self.dontevershoot	= true;
		self notify( "tarmac_sniper_fire" );	
		
		flag_wait_either( "tarmac_too_far", "tarmac_killed_security" );
		thread flag_clear_delayed( "tarmac_killed_security", 6 );	
		
		self.dontevershoot = undefined;	
		self thread tarmac_sniper_fire();
		
		flag_waitopen( "tarmac_too_far" );
		flag_waitopen( "tarmac_killed_security" );		
	}
}

tarmac_heli_bc_off()
{
	self endon( "death" );
	
	flag_wait( "tarmac_open_fire" );
	
	wait .5;
	
	self set_battlechatter( false );
}

tarmac_sniper_fire()
{
	self endon( "death" );
	self endon( "tarmac_sniper_fire" );	
	
	while( 1 )
	{
		if( self cansee( level.player ) )
			self fake_fire();
		wait randomfloatrange( 1.4, 3 );	
	}
}

tarmac_police_fire()
{
	self endon( "tarmac_police_fire" );	
	self endon( "death" );
	
	while( 1 )
	{
		if( !self ent_flag( "moving" ) )
			self fake_fire();
		wait randomfloatrange( .3, .5 );	
	}
}

fake_fire()
{
	if ( isAi( self ) )		//regular AI
		self shoot();
	else					//DRONE
	{
		fireAnim = %pistol_stand_fire_A;
		self setAnimKnobRestart( fireAnim, 1, .2, 1.0 );
		self delaycall( .25, ::clearAnim, fireAnim, 0 );
		playFXontag( getfx( "pistol_muzzleflash" ), self, "tag_flash" );
	}	

	magicbullet( self.weapon, self gettagorigin( "tag_flash" ), level.player geteye() + ( randomfloat(64), randomfloat(64), randomfloat(64) ) );
}

tarmac_handle_player_too_far()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	trigger = getent( "tarmac_player_too_far", "targetname" );
	
	while( 1 )
	{
		trigger waittill( "trigger" );
		
		flag_set( "tarmac_too_far" );
		oldstring = level.fail_string;
		level.fail_string = &"AIRPORT_FAIL_POLICE_BARRICADE";
		thread tarmac_handle_player_too_far_death();
		
		while( level.player istouching( trigger ) )
			wait .1;
		
		flag_clear( "tarmac_too_far" );
		level.fail_string = oldstring;
	}
}

tarmac_handle_player_too_far_death()
{
	level endon( "friendly_fire_warning" );
	level endon( "tarmac_too_far" );
	
	level.player waittill( "death" );
	
	setdvar( "ui_deadquote", level.fail_string );
	missionFailedWrapper();	
}

/************************************************************************************************************/
/*										TARMAC FRIENDLY LOGIC												*/
/************************************************************************************************************/
tarmac_moveout( node )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	self.dontevershoot = true;
	self.ignoreall = false;
	self.ignoreme = false;
	self.moveplaybackrate = 1.0;
	self.combatmode = "cover";
	self.interval = 0;
	self.noDodgeMove = false;
	
	self enable_arrivals();
			
	switch( self.script_noteworthy )
	{
		case "saw":
			break;	
			
		case "makarov":
			delaythread( .5, ::radio_dialogue, "airport_mkv_go" );
			wait .75;
			break;
				
		case "m4":
			wait 2;
			break;
		
		case "shotgun":
			wait 1.5;
			break;
	}
	
	wait 1.25;
	
	self stopanimscripted();		
	self thread follow_path( node );
	
	node waittill( "trigger" );
	flag_set( "tarmac_pre_heat_fight" );
	self disable_cqbwalk();
	self clear_run_anim();	
	self pushplayer( false );
	
	flag_wait( "tarmac_heat_fight" );
	self enable_heat_behavior();
				
	self waittill( "reached_path_end" ); 
		
	flag_wait( "tarmac_open_fire" );
	self.dontevershoot = undefined;
	
	flag_wait( "tarmac_retreat1" );
	self set_force_color( "red" );
}

tarmac_kill_friendly()
{
	self endon( "death" );
	
	self thread tarmac_kill_friendly_bsc();
			
	self unmake_hero();
	if( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	
	self.maxhealth = 250;
	self.health = 250;
	self.grenadeawareness = 0;
	self.noGrenadeReturnThrow = true;
	
	trigger_wait_targetname( "tarmac_advance8" );
	
	self thread tarmac_kill_friendly_kill();
}

tarmac_kill_friendly_bsc()
{	
	self waittill( "death" );
		
	flag_waitopen( "tarmac_bcs" );
	
	makarov = level.makarov;
	victor = level.team[ "m4" ];
	
	wait randomfloat( .1 );
	
	if( flag( "tarmac_kill_friendly_bsc" ) )
		return;
	flag_set( "tarmac_kill_friendly_bsc" );	
		
	flag_set( "tarmac_bcs" );
		victor dialogue_queue( "man_down" );
		makarov dialogue_queue( "man_down" );
	flag_clear( "tarmac_bcs" );	
}

tarmac_kill_friendly_kill()
{	
	if( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
		
	self kill();
}

handle_tarmac_threat_bias()
{
	while( 1 )
	{
		self waittill( "trigger", guy );
		
		guy setthreatbiasgroup( "underpass_guys" );
		guy thread handle_tarmac_threat_bias_guy( self );
	}	
}

handle_tarmac_threat_bias_guy( trigger )
{
	self endon( "death" );
	
	if( isdefined( self.handle_tarmac_threat_bias_guy ) )
		return;
	self.handle_tarmac_threat_bias_guy = true;
	
	while( self istouching( trigger ) )
		wait .1;
	
	self.handle_tarmac_threat_bias_guy = undefined;
	self setthreatbiasgroup();
}

handle_threat_bias_stuff()
{
	createthreatbiasgroup( "2ndfloorenemies" );
	createthreatbiasgroup( "underpass_guys" );
	SetIgnoreMeGroup( "2ndfloorenemies", "underpass_guys" );
	SetIgnoreMeGroup( "underpass_guys", "2ndfloorenemies" );
	
	getent( "tarmac_threatbias_group", "targetname" ) thread handle_tarmac_threat_bias();
}

tarmac_autosaves_wait()
{
	add_wait( ::flag_wait, "tarmac_enemies_wave1_dead" );
	add_wait( ::flag_wait, "tarmac_enemies_wave2_dead" );
	add_wait( ::flag_wait, "tarmac_van_guys_dead" );
	add_wait( ::flag_wait, "tarmac_van_guys2_dead" );
	add_abort( ::flag_wait, "do_not_save" );
	add_func( ::autosave_or_timeout, "tarmac_left_underpass", 4 );
	thread do_wait();
	
	if( !flag( "do_not_save" ) )
		thread autosave_by_name( "tarmac_heat_fight" );
		
	trigger_wait( "tarmac_enemies_wave2", "target" );
	if( !flag( "do_not_save" ) )
		thread autosave_or_timeout( "tarmac_wave2launch", 4 );
	
	trigger_wait( "tarmac_advance5", "targetname" );	
	if( !flag( "do_not_save" ) )
		thread autosave_or_timeout( "tarmac_at_underpass", 4 );
	
	trigger_wait( "tarmac_advance8", "targetname" );	
	if( !flag( "do_not_save" ) )
		thread autosave_or_timeout( "tarmac_left_underpass", 4 );
}

tarmac_escape_music()
{
	trigger_wait( "tarmac_advance8", "targetname" );
	
	ai = getaiarray( "axis" );
	remove = get_living_ai_array( "tarmac_enemies_2ndfloor", "script_noteworthy" );
	remove = array_combine( remove, get_living_ai_array( "tarmac_littlebird_sniper", "script_noteworthy" ) );
	remove = array_combine( remove, get_living_ai_array( "tarmac_littlebird_sniper2", "script_noteworthy" ) );
	ai = array_remove_array( ai, remove );
	
	if( ai.size > 4 )
		waittill_dead_or_dying( ai, ai.size - 4 );
	
	flag_set( "tarmac_clear_out_2nd_floor" );
//	music_escape();
}

tarmac_makarov_last_node()
{
	node = getnode( "tarmac_makarov_last_node", "targetname" );
	
	trigger_wait( "tarmac_advance8", "targetname" );
	
	ai = getaiarray( "axis" );
	remove = get_living_ai_array( "tarmac_enemies_2ndfloor", "script_noteworthy" );
	remove = array_combine( remove, get_living_ai_array( "tarmac_littlebird_sniper", "script_noteworthy" ) );
	remove = array_combine( remove, get_living_ai_array( "tarmac_littlebird_sniper2", "script_noteworthy" ) );
	ai = array_remove_array( ai, remove );	
	
	if( ai.size > 3 )
		waittill_dead_or_dying( ai, ai.size - 3 );
	
	level.makarov disable_ai_color();
	level.makarov setgoalnode( node );
	level.makarov.radius = node.radius;
}

tarmac_hide_elevator()
{
	elevator_house = getentarray( "elevator_housing", "targetname" );
	foreach( member in elevator_house )
	{
		member hide();
		member notsolid();
	}	
}

tarmac_get_enemies()
{
	ai = getaiarray( "axis" );
	remove = get_living_ai_array( "tarmac_enemies_2ndfloor", "script_noteworthy" );
	remove = array_combine( remove, get_living_ai_array( "tarmac_littlebird_sniper", "script_noteworthy" ) );
	remove = array_combine( remove, get_living_ai_array( "tarmac_littlebird_sniper2", "script_noteworthy" ) );
	ai = array_remove_array( ai, remove );
	
	return ai;	
}

/************************************************************************************************************/
/*											TARMAC VAN LOGIC												*/
/************************************************************************************************************/
tarmac_van_setup( name )
{
	van_hack = getent( name, "targetname" );
		
	tarmac_van_create();
	array_thread( getentarray( van_hack.target, "targetname" ), ::add_spawn_function, ::tarmac_van_attach_guy, self );	
	
	van_hack delete();
		
	self waittill_any( "reached_end_node", "death" );
		
	wait 1;

	self notify( "hack_unload" );
}

tarmac_van_attach_guy( van )
{
	if( isdefined( self.script_startingposition ) && van.seats[ self.script_startingposition ][ "free" ] )
		self tarmac_van_guy_take_seat( van, self.script_startingposition );
	else
	{
		foreach( index, seat in van.seats )
		{
			if( !seat[ "free" ] )	
				continue;
			
			self tarmac_van_guy_take_seat( van, index );
			return;
		}
	}
}

tarmac_van_guy_take_seat( van, index )
{	
	van.seats[ index ][ "free" ] = false;
	self linkto( van.seats[ index ][ "node" ] );
	
	if( index == 0 )
		van.seats[ index ][ "node" ] thread anim_generic_loop( self, "bm21_driver_idle" );
	else
		van.seats[ index ][ "node" ] thread anim_generic_loop( self, "riotshield_idle" );
	van.seats[ index ][ "guy" ] = self;
	self.van_seat = van.seats[ index ][ "node" ];
}

tarmac_van_wait_unload()
{
	self waittill( "hack_unload" );
	
	foreach( index, seat in self.seats )
	{
		if( isalive( seat[ "guy" ] ) )
			self thread tarmac_van_unload_guy( index, seat );
	}	
}

tarmac_van_unload_guy( index, seat )
{
	guy = seat[ "guy" ];
	
	self thread tarmac_van_unload_check( index, guy );
	
	guy endon( "death" );
	
	if( isdefined( guy.nounload ) )
	{
		wait .1;
		guy notify( "hack_unloaded" );
		return;
	}
		
	node = undefined;
	movenode = undefined;
	animation = undefined;
	time = 0;
	interval = 0;

	switch( index )
	{
		case 0:
			interval = 0;
			node = self.seats[ 0 ][ "node" ];
			animation = "bm21_driver_climbout";
			break;
		case 1:
		case 3:
		case 5:
		case 7:
			interval = index - 1;
			node = self.seats[ 1 ][ "node" ];
			animation = "traverse_jumpdown_40";
			break;
		case 2:
		case 4:
		case 6:
		case 8:
			interval = index - 2;
			node = self.seats[ 2 ][ "node" ];
			animation = "traverse_jumpdown_40";
			wait randomfloatrange( .1, .4 );
			break;
	}
	
	wait interval * .5;
	
	self.seats[ index ][ "node" ] notify( "stop_loop" );
	guy stopanimscripted();
	guy.allowdeath = true;
	
	length = getanimlength( getgenericanim( animation ) );
	
	if( index == 0 )
	{
		movenode = spawn( "script_origin", node.origin );
		movenode.angles = self.angles;
		guy linkto( movenode );
		
		movenode thread anim_generic( guy, animation );
		wait .25;
		movenode movez( 8, .25 );
	}
	else
	{	
		forward = anglestoforward( node.angles );
			
		movenode = spawn( "script_origin", node.origin + vector_multiply( forward, 16 ) );
		movenode.angles = self.angles;
		guy linkto( movenode );
			
		guy.moveplaybackrate = randomfloatrange( .9, 1.1 );
		movenode thread anim_generic( guy, animation );
		
		guy delaythread( length - .2, ::anim_stopanimscripted );
		wait .25;
		movenode movez( 12, .25 );
		wait .25;
		guy unlink();
	}
	
	guy waittill( "single anim" );
	guy.moveplaybackrate = 1;
	//guy unlink();
	movenode delete();
	
	guy notify( "hack_unloaded" );
	
	
}

tarmac_van_unload_check( index, guy )
{
	guy waittill_either( "death", "hack_unloaded" );
	
	self.seats[ index ][ "free" ] = true;
	
	foreach( seat in self.seats )
	{
		if( !self.seats[ index ][ "free" ] )
			return;
	}
	
	self notify( "finished_unloading" );
}

tarmac_van_create()
{
	van = self;
	forward = anglestoforward( van.angles );
	right = anglestoright( van.angles );
	angles = vectortoangles( vector_multiply( forward, -1 ) );
	height = (0,0,28);
	van.seats = [];
	van.guys = [];
	
	i = 0;
	origin = van.origin + vector_multiply( forward, 44 ) + vector_multiply( right, -24 ) + (0,0,48);
	van.seats[ i ] = [];
	van.seats[ i ][ "node" ] = spawn( "script_origin", origin );
	van.seats[ i ][ "node" ].angles = van.angles;
	van.seats[ i ][ "node" ] linkto( van );
	van.seats[ i ][ "free" ] = true;
	
	i = 1;
	origin = van.origin + vector_multiply( forward, -88 ) + vector_multiply( right, -16 ) + height;
	van.seats[ i ] = [];
	van.seats[ i ][ "node" ] = spawn( "script_origin", origin );
	van.seats[ i ][ "node" ].angles = angles;
	van.seats[ i ][ "node" ] linkto( van );
	van.seats[ i ][ "free" ] = true;
	
	i = 2;
	origin = van.origin + vector_multiply( forward, -88 ) + vector_multiply( right, 16 ) + height;
	van.seats[ i ] = [];
	van.seats[ i ][ "node" ] = spawn( "script_origin", origin );
	van.seats[ i ][ "node" ].angles = angles;
	van.seats[ i ][ "node" ] linkto( van );
	van.seats[ i ][ "free" ] = true;
	
	i = 3;
	origin = van.origin + vector_multiply( forward, -56 ) + vector_multiply( right, -16 ) + height;
	van.seats[ i ] = [];
	van.seats[ i ][ "node" ] = spawn( "script_origin", origin );
	van.seats[ i ][ "node" ].angles = angles;
	van.seats[ i ][ "node" ] linkto( van );
	van.seats[ i ][ "free" ] = true;
	
	i = 4;
	origin = van.origin + vector_multiply( forward, -56 ) + vector_multiply( right, 16 ) + height;
	van.seats[ i ] = [];
	van.seats[ i ][ "node" ] = spawn( "script_origin", origin );
	van.seats[ i ][ "node" ].angles = angles;
	van.seats[ i ][ "node" ] linkto( van );
	van.seats[ i ][ "free" ] = true;
	
	i = 5;
	origin = van.origin + vector_multiply( forward, -24 ) + vector_multiply( right, -16 ) + height;
	van.seats[ i ] = [];
	van.seats[ i ][ "node" ] = spawn( "script_origin", origin );
	van.seats[ i ][ "node" ].angles = angles;
	van.seats[ i ][ "node" ] linkto( van );
	van.seats[ i ][ "free" ] = true;
	
	i = 6;
	origin = van.origin + vector_multiply( forward, -24 ) + vector_multiply( right, 16 ) + height;
	van.seats[ i ] = [];
	van.seats[ i ][ "node" ] = spawn( "script_origin", origin );
	van.seats[ i ][ "node" ].angles = angles;
	van.seats[ i ][ "node" ] linkto( van );
	van.seats[ i ][ "free" ] = true;
	
	i = 7;
	origin = van.origin + vector_multiply( forward, 8 ) + vector_multiply( right, -16 ) + height;
	van.seats[ i ] = [];
	van.seats[ i ][ "node" ] = spawn( "script_origin", origin );
	van.seats[ i ][ "node" ].angles = angles;
	van.seats[ i ][ "node" ] linkto( van );
	van.seats[ i ][ "free" ] = true;
	
	i = 8;
	origin = van.origin + vector_multiply( forward, 8 ) + vector_multiply( right, 16 ) + height;
	van.seats[ i ] = [];
	van.seats[ i ][ "node" ] = spawn( "script_origin", origin );
	van.seats[ i ][ "node" ].angles = angles;
	van.seats[ i ][ "node" ] linkto( van );
	van.seats[ i ][ "free" ] = true;
	
	van thread tarmac_van_wait_unload();
}

tarmac_smoke_nodes()
{	
	MagicGrenadeManual( "smoke_grenade_american", self.origin, (0,0,-1), randomfloat( 1 ) );
}

tarmac_bcs_enemy()
{
	if( !flag_exist( "tarmac_bcs_enemy" ) )
		flag_init( "tarmac_bcs_enemy" );
	
	if( !flag_exist( "bsc_nade" ) )
		flag_init( "bsc_nade" );
	
	level endon( "escape_main" );
	
	flag_wait( "tarmac_open_fire" );
	wait 2;
		
	while( 1 )
	{
		self waittill( "trigger", other );
		
		if( flag( "tarmac_bcs_enemy" ) )
			continue;	
		if( flag( "tarmac_bcs" ) )
			continue;
		if( flag( "bsc_nade" ) )
			continue;
		if( distancesquared( other.origin, level.player.origin ) > squared( 1024 ) )
			continue;
			
		flag_set( "tarmac_bcs_enemy" );
		flag_set( "tarmac_bcs" );
			
		if( ( cointoss() && self.script_soundalias != "enemy_bus" ) || self.script_soundalias == "enemy_underplane" )
			level.makarov dialogue_queue( self.script_soundalias );
		else
			level.team[ "m4" ] dialogue_queue( self.script_soundalias );
		
		flag_clear( "tarmac_bcs" );
		
		wait 5;
		
		flag_clear( "tarmac_bcs_enemy" );
		
		wait 15;	
	}	
}

/************************************************************************************************************/
/*													ESCAPE													*/
/************************************************************************************************************/
escape_van_driver()
{
	self.nounload = true;
	self thread friendly_fire_watch_player();
}

escape_van_mate()
{
	self endon( "death" );
	
	self thread friendly_fire_watch_player();		
		
	self.animname = "van_mate";
	self.allowdeath = true;
	self.health = 1;
	self.maxhealth = 1;
		
	self setgoalpos( self.origin );
	self.goalradius = 16;
	
	level.vanmate = self;	
	
	flag_wait( "escape_van_ready" );
	
	wait .05;
		
	van = level.escape_van_dummy;
	self.van_seat notify( "stop_loop" );
	self linkto( van, "tag_body" );
	van thread anim_loop_solo( self, "end_ride_in", "stop_loop", "tag_body" );
}

escape_van_setup( name )
{
	van_hack = getent( name, "targetname" );
		
	self tarmac_van_create();
	array_thread( getentarray( van_hack.target, "targetname" ), ::add_spawn_function, ::tarmac_van_attach_guy, self );	
	
	van_hack delete();
		
	level.escape_van_dummy = self;
		
	flag_set( "escape_van_ready" );	
}

escape_relax()
{	
	self endon( "escape_enter_van" );
	self endon( "death" );
	
	if( flag( "escape_sequence_go" ) )
		return;
	level endon( "escape_sequence_go" );
	
	self waittill( "anim_reach_complete" );
	
	if( self == level.makarov )
		self waittill( "stand_exposed_wave_halt_v2" );
		
	anime = undefined;
	loop = undefined;
	switch( self.a.pose )
	{
		case "crouch":
			self anim_generic( self, "exposed_crouch_2_stand" );
		case "stand":
			self anim_generic( self, "casual_stand_idle_trans_in" );	
			self thread anim_generic_loop( self, "casual_stand_idle" );
			break;
	}	
}

escape_setup_variables()
{
	//NORMAL DYNAMIC RUN SPEED	
	level.scr_anim[ "generic" ][ "DRS_sprint" ]				= %heat_run_loop;
	level.scr_anim[ "generic" ][ "DRS_combat_jog" ]			= %combat_jog;
	level.scr_anim[ "generic" ][ "DRS_run_2_stop" ]			= %run_2_stand_F_6;
	level.scr_anim[ "generic" ][ "DRS_stop_idle" ][ 0 ]		= %exposed_aim_5;
	level.scr_anim[ "generic" ][ "signal_go" ]				= undefined;
	level.scr_anim[ "generic" ][ "DRS_run" ]				= undefined;
	
	level notify( "friendly_fire_stop_checking_for_player_fire" );
	
	doorR = GetEnt( "ambulance_door_right", "targetname" );
	doorL = GetEnt( "ambulance_door_left", "targetname" );
	doorL connectpaths();
	doorR connectpaths();
	
	wait 2;
	
	doorL delete();
	doorR delete();
	
	flag_clear( "friendly_fire_pause_flash" );
	flag_clear( "friendly_fire_pause_fire" );
	level.player.participation = 0;	
}

escape_survivors_follow_path( nodes, dist )
{
	foreach( node in nodes )
	{
		if( !isalive( level.survivors[ node.script_noteworthy ] ) )
			continue;
		
		time = int( node.script_noteworthy );	
		level.survivors[ node.script_noteworthy ] delaythread( time, ::follow_path, node, dist );
	}
}

escape_create_survivors()
{
	level.survivors = [];
	
	index = 0;
	foreach( member in level.team )
	{
		if( member == level.makarov )
			continue;
		index++;	
		level.survivors[ string( index ) ] = member;
	}
	level.survivors[ "makarov" ] = level.makarov;
}

escape_player_disable_jump_n_weapon()
{
	level endon( "escape_player_is_in" );
	while( 1 )
	{
		self waittill( "trigger" );
		
		level.player allowjump( false );
		weapon = level.player get_correct_weapon();
		store_current_weapon( weapon );
		level.player enablePlayerWeapons( false );
		
		while( level.player istouching( self ) )
			wait .05;
		
		level.player allowjump( true );
		level.player enablePlayerWeapons( true );	
	}
}	

store_current_weapon( weapon )
{	
	level.escape_weapon_taglist =  GetWeaponHideTags( weapon );
	level.escape_weapon_model = getWeaponModel( weapon );	
}

get_correct_weapon()
{
	weapon = undefined;
	
	if( weaponclass( self getcurrentweapon() ) == "pistol" )
	{
		list = self GetWeaponsListPrimaries();
		foreach( gun in list )
		{
			if( weaponclass( gun ) == "pistol" )
				continue;
			weapon = gun;			
		}	
	}
	else
		weapon = self getcurrentweapon();
	
	if( !isdefined( weapon ) || weapon == "riotshield" )
		weapon = "m4_grenadier";
	
	return weapon;	
}

escape_end_waitforplayer( dist, view, time )
{
	van = level.escape_van_dummy;
	
	model = spawn_anim_model( "player_ending" );
	model hide();
	van anim_first_frame_solo( model, "end_player_shot", "origin_animate_jnt" );
	
	origin = model gettagorigin( "tag_player" );
	model delete();
	
	interval = .05;
	
	if( isdefined( view ) )
	{
		while( distance( origin, level.player.origin ) > dist || !end_mantle_angle() )
		{
			wait interval;
			time -= interval;
			if( time <= 0 )
				return false;	
		}
	}
	else
	{
		while( distance( origin, level.player.origin ) > dist )
			wait interval;
	}
	
	if( isdefined( time ) )
	{
		level.player freezecontrols( true );
		wait time;
	}
	return true;
}

escape_animate_player_death()
{	
	flag_set( "escape_player_realdeath" );
	level.player TakeAllWeapons();
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "hud_showStance", 0 );
	
	level.player freezecontrols( true );
	van = level.escape_van_dummy;
	
	// this is the model the player will attach to for the ride sequence
	model = spawn_anim_model( "player_ending" );
	model hide();
	level.playermodel = model;
	
	van anim_first_frame_solo( model, "end_player_shot", "origin_animate_jnt" );
	
	time = 1;
	level.player PlayerLinkToBlend( model, "tag_player", time, time * .5, time *.5 );;
	wait time;
	
	model show();
	model notsolid();
		
	team = [];
	team[ team.size ] = model;
	team[ team.size ] = level.vanmate;
	
	level.makarov thread escape_mak_dialogue();
	van thread anim_single( team, "end_player_shot", "origin_animate_jnt" );
		
	model thread escape_draw_blood();
	
	level.makarov waittillmatch( "single anim", "end" );
}

escape_mak_dialogue()
{
	self waittillmatch( "single anim", "dialog" );
	self playsound( "airport_mkv_nomessage" );
	self waittillmatch( "single anim", "dialog" );
	self playsound( "airport_mkv_thiswill" );
}

escape_animate_player_death2()
{
	van = level.escape_van_dummy;
	
	team = [];
	team[ team.size ] = level.vanmate;
	
	flag_wait( "end_makarov_in_place" );
		
	van notify( "stop_loop" );
	van thread anim_single( team, "end_player_shot", "origin_animate_jnt" );
	level.makarov stopanimscripted();
	van thread anim_single_solo( level.makarov, "end_alt" );
	
	flag_wait( "escape_player_shot" );
	
	level.player TakeAllWeapons();
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "hud_showStance", 0 );
	
	level.player freezecontrols( true );
	
	ent = getstruct( "escape_ending_node", "targetname" );
	origin = ( level.player.origin[0], level.player.origin[1], ent.origin[2] ) + (0,0,4.5);
	node = spawn( "script_origin",  origin  );
	node.angles = level.player.angles;
	
	// this is the model the player will attach to for the ride sequence
	model = spawn_anim_model( "player_ending" );
	level.playermodel = model;
	model linkto( node );
	model notsolid();

	angles = vectortoangles( level.makarov.origin - level.player.origin );

	node rotateto( ( 0, angles[1], 0 ), 1.5 );
	time = .1;
	level.player PlayerLinkToBlend( model, "tag_player", time, time * .5, time *.5 );;
	node thread anim_single_solo( model, "end_player_shot_alt" );
	model thread escape_draw_blood();
	
	PhysicsExplosionCylinder( node.origin, 96, 2, 3 );
	
	level.makarov waittillmatch( "single anim", "end" );
}

escape_draw_blood()
{
	self waittillmatch( "single anim", "end" );
	
	level.player setcontents( 0 );
	
	wait 1;
	tagPos = self gettagorigin( "tag_torso" );	// rough tag to play fx on
	
	model = spawn( "script_model", tagPos + (-15,10,-7.5) );
	model.angles = ( -90, 225 - 90, 0 );
	model setmodel( "tag_origin" );
	model hide();
		
	PlayFXOnTag( getfx( "deathfx_bloodpool" ), model, "tag_origin" );	
}

end_mantle_angle()
{
	van = level.escape_van_dummy;
	
	angles = level.player getplayerangles();
	angles = ( 0, angles[1], 0 );
	
	og1 = ( van.origin[0], van.origin[1], 0 );  
	og2 = ( level.player.origin[0], level.player.origin[1], 0 );
	
	vec1 = anglestoforward( angles );
	vec2 = vectornormalize( og1 - og2 );
		
	if ( vectordot( vec1, vec2 ) > .75 )
		return true;
	else
		return false;
}

escape_final_guys()
{
	self endon( "death" );
		
	self.favoriteenemy = level.player;
	self.dontevershoot = true;
	
	node = getnode( self.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = node.radius;	
}

escape_final_guys2()
{
	self endon( "death" );
	self endon( "long_death" );
	
	self.ignoreall = true;
	self.ignoreme = true;
	self.dontevershoot = true;
	
	node = getstruct( self.target, "targetname" );
	
	self set_generic_run_anim( "patrol_jog" );
	
	node anim_generic_reach( self, self.animation );
	node anim_generic_run( self, self.animation );
	
	node = getstruct( node.target, "targetname" );
	
	self clear_run_anim();
	self thread follow_path( node );
			
	if( self.animation != "patrol_jog_orders_once" )
		return;	
	
	self playsound( "airport_fsbr_servicetunnels" );
	
	self disable_exits();
	self disable_arrivals();
	
	if( flag( "escape_player_realdeath" ) )
	{	
		node = getstruct( "find_body", "script_noteworthy" );
		node waittill( "trigger" );
		node thread anim_generic( self, "patrol_boredrun_find" );
	}
	else
	{
		self notify( "_utility::follow_path" );
		self setgoalpos( level.player.origin + (0,0,64) );
		
		while( distancesquared( self.origin, level.player.origin ) > squared( 145 ) )
			wait .05;
		node = spawnstruct();
		node.origin = self.origin;
		node.angles = vectortoangles( level.player.origin - self.origin );
		node thread anim_generic_gravity( self, "patrol_boredrun_find" );
	}	
	
	self SetLookAtEntity( level.player );
	
	
	wait 2;
	self setLookAtEntity();
}

escape_police_car_guys()
{
	self endon( "death" );
	
	self.ignoreall = true;
	self.ignoreme = true;
	
	self waittill( "goal" );
	
	self delete();	
}

/************************************************************************************************************/
/*												INITIALIZATIONS												*/
/************************************************************************************************************/
player_init()
{
	blend_movespeedscale_custom( 15 );
	level.player allowsprint( false );
	level.player allowjump( false );
}

team_init()
{
	self thread magic_bullet_shield();
	self thread make_hero();
	self ent_flag_init( "massacre_ready" );
	self ent_flag_init( "massacre_firing_into_crowd" );
	self ent_flag_init( "massacre_at_node" );
	self ent_flag_init( "massacre_throw_nade" );	
	self ent_flag_init( "gate_ready_to_go" );
	self ent_flag_init( "prestairs_nodes" );
	self ent_flag_init( "aiming_at_civ" );
	self ent_flag_init( "stairs_at_top" );
		
	self.ignorerandombulletdamage = true;
	self.ignoreall = true;
	self pushplayer( true );
	self pathrandompercent_zero();
	self walkdist_zero();
	
	node = spawn( "script_origin", self.origin );
	node.angles = self.angles;
	self.ref_node = node;
	self.upperdeck_enemies = 0;
	
	if( !isdefined( level.team ) )
		level.team = [];
	level.team[ self.script_noteworthy ] = self;

	self.animname = self.script_noteworthy;
	self.targetname = self.script_noteworthy;
	
	if( self.script_noteworthy == "makarov" )
		level.makarov = self;		
	
	self waittill( "death" );
	
	level.team = array_removedead_keepkeys( level.team );
}

/************************************************************************************************************/
/*											DEPARTURES SIGN													*/
/************************************************************************************************************/
sign_departure_status_init()
{
	array = sign_departure_status_system_setup();
	array_thread( array, ::sign_departure_status_tab_setup );	
	
	level.departure_status_array = array;
}

sign_departure_status_system_setup()
{
	pieces = getentarray( "sign_departure_status", "targetname" );
	array = [];
		
	foreach( tab in pieces )
	{
		makenew = true;
		origin = tab.origin;
		
		foreach( member in array )
		{
			if( member.origin != origin )	
				continue;
			
			makenew = false;
			member.tabs[ tab.script_noteworthy ] = tab;
			break;
		}
		
		if( !makenew )
			continue;
		
		newtab = spawnstruct();
		newtab.origin = origin;
		newtab.tabs = [];
		newtab.tabs[ tab.script_noteworthy ] = tab;
		
		array[ array.size ] = newtab;
	}
	
	return array;
}

sign_departure_status_tab_setup()
{
	self.status[ "angles" ] 				= [];
	self.status[ "angles" ][ "bottom" ] 	= self.tabs[ "ontime" ].angles;
	self.status[ "angles" ][ "top" ] 		= self.tabs[ "boarding" ].angles;
	self.status[ "angles" ][ "waiting" ] 	= self.tabs[ "delayed" ].angles;
	
	self.status[ "order" ] 					= [];
	self.status[ "order" ][ "ontime" ] 		= "arriving";
	self.status[ "order" ][ "arriving" ] 	= "boarding";
	self.status[ "order" ][ "boarding" ] 	= "delayed";
	self.status[ "order" ][ "delayed" ] 	= "ontime";
	
	self.status[ "ontime" ] 				= [];
	self.status[ "ontime" ][ "bottom" ]		= "ontime";
	self.status[ "ontime" ][ "top" ] 		= "arriving";
	
	self.status[ "arriving" ] 				= [];
	self.status[ "arriving" ][ "bottom" ]	= "arriving";
	self.status[ "arriving" ][ "top" ]		= "boarding";
	
	self.status[ "boarding" ] 				= [];
	self.status[ "boarding" ][ "bottom" ]	= "boarding";
	self.status[ "boarding" ][ "top" ] 		= "delayed";
	
	self.status[ "delayed" ] 				= [];
	self.status[ "delayed" ][ "bottom" ] 	= "delayed";
	self.status[ "delayed" ][ "top" ] 		= "ontime";
	
	self.current_state							= "ontime";
		
	self.tabs[ "arriving" ].angles = self.status[ "angles" ][ "top" ];
	self.tabs[ "boarding" ].angles = self.status[ "angles" ][ "waiting" ];
	self.tabs[ "boarding" ] hide();
	self.tabs[ "delayed" ] hide();
}

sign_departure_status_flip_to( state )
{
	time = .20; 
	while( self.current_state != state )
	{
		next_state 	= self.status[ "order"][ self.current_state ];
		topname 	= self.status[ self.current_state ][ "top" ];
		bottomname 	= self.status[ self.current_state ][ "bottom" ];
		newname		= self.status[ next_state ][ "top" ];
		
		toptab		= self.tabs[ topname ];
		bottomtab   = self.tabs[ bottomname ];
		newtab		= self.tabs[ newname ];
		
		//move top to bottom position
		toptab rotatepitch( 180, time );
		newtab.angles = self.status[ "angles" ][ "top" ];
		//bring new to top position
		wait .05;
		newtab show();
		//bring bottom to wait position
		wait ( time - .1 );
		bottomtab hide();
		bottomtab.angles = self.status[ "angles" ][ "waiting" ];
		wait .05;		
		self.current_state = next_state;
	}	
}

/************************************************************************************************************/
/*													MISC													*/
/************************************************************************************************************/

delete_glass()
{
	name = self.target;
	glass = GetGlass( name );
	level waittillmatch( "glass_destroyed", glass );//glass_destroyed
	
	self delete();
}

do_lobby_player_fire()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "damage", amt, attacker, vec, point, type );
		
		if( !isplayer( attacker ) )
			continue;
		
		PlayFX( getfx( "killshot" ), point );
	}		
}

do_blood_notetracks()
{
	self endon( "death" );
	
	notetrack = "empty";
	
	while( notetrack != "end" )
	{		
		self waittill( "single anim", notetrack );
				
		switch( notetrack )
		{				
			case "bodyshot":
				self bodyshot( "bodyshot" );
				break;
			
			case "killshot":
				self bodyshot( "killshot" );
				break;
				
			case "headshot":
				origin = self gettagorigin( "tag_eye" );
				enemy = random( level.team );  
				vec = vectornormalize( origin - enemy.origin );
				
				PlayFX( getfx( "headshot" ), origin, vec );	
				break;	
		}
	}
}

bodyshot( fx )
{
	origin = self gettagorigin( "J_SpineUpper" );
	enemy = random( level.team );  
	vec = vectornormalize( enemy.origin - origin );
	vec = vector_multiply( vec, 10 );
	 
	PlayFX( getfx( fx ), origin + vec );
}

scream_track( node, alias, speed )
{
	obj = spawn( "script_origin", node.origin );
	//obj setmodel( "projectile_us_smoke_grenade" );
	obj playsound( alias );
	
	while( isdefined( node.target ) )
	{
		next = getstruct( node.target, "targetname" );
		dist = distance( node.origin, next.origin );
		time = dist / speed;
		
		obj moveto( next.origin, time );
		wait time;
		node = next;	
	}
	
	wait 4;
	
	obj delete();
}

explode_targets( targets, radius, rangemin, rangemax )
{
	level endon( "stop_explode_targets" );
	
	targets = array_randomize( targets );
	if( !isdefined( radius ) )
		radius = 4;
	if( !isdefined( rangemin ) )
		rangemin = .75;
	if( !isdefined( rangemax ) )
		rangemax = rangemin + .75;
	
	foreach( target in targets )
	{
		radiusdamage( target.origin, radius, 500, 500 );
		wait randomfloatrange( rangemin, rangemax );
	}
}

spray_and_pray_node( delay, speed_scaler, node )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	msg = "stop_spray_and_pray";
	self endon( msg );
	
	array = self spray_and_pray_get_target_node( delay, speed_scaler, node );
	
	self thread stop_spray_and_pray_cleanup( array["target"], msg );
	
	self.spraypray_target = array["target"];
	self SetEntityTarget( self.spraypray_target );
	
	self.old_pistol_switch = self.no_pistol_switch;
	self.no_pistol_switch = true;
			
	self spray_and_pray_move_target_node( array );
}

spray_and_pray( delay, speed_scaler, forward, height, angle, dist )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	msg = "stop_spray_and_pray";
	self endon( msg );
	
	array = self spray_and_pray_get_target( delay, speed_scaler, forward, height, angle, dist );
	
	self thread stop_spray_and_pray_cleanup( array["target"], msg );
	
	self.spraypray_target = array["target"];
	self SetEntityTarget( self.spraypray_target );
	
	self.old_pistol_switch = self.no_pistol_switch;
	self.no_pistol_switch = true;
			
	self spray_and_pray_move_target( array );
	
}

spray_and_pray_move_target( array )
{
	while( 1 )
	{
		dist = distance( array[ "node_origin" ], array[ "target" ].origin );
		time = dist / array[ "speed" ];
		
		array[ "target" ] moveto( array[ "node_origin" ], time, time * .1, time * .1 );
		wait time;
			
		if( array[ "node_origin" ] == array[ "start_origin" ] )
			array[ "node_origin" ] = array[ "end_origin" ];
		else		
			array[ "node_origin" ] = array[ "start_origin" ];
	}
}

spray_and_pray_move_target_node( array )
{
	node = array[ "node" ];
	
	while( 1 )
	{
		node = getstruct( node.target, "targetname" );
		
		dist = distance( node.origin, array[ "target" ].origin );
		time = dist / array[ "speed" ];
		
		array[ "target" ] moveto( node.origin, time, time * .1, time * .1 );
		wait time;
	}
}

spray_and_pray_get_target_node( delay, speed_scaler, node )
{
	array = [];
	
	if( !isdefined( delay ) )
		delay = .05;
	if( !isdefined( speed_scaler ) )
		speed_scaler = 1;
		
	wait delay;	
	
	array[ "speed" ] 	= 50 * speed_scaler;	
	array[ "node" ]		= node;
	
	array[ "target" ] = spawn( "script_origin", node.origin );
//	array[ "target" ] = spawn( "script_model", node.origin );
//	array[ "target" ] setmodel( "weapon_us_smoke_grenade" );
	return array;
}

spray_and_pray_get_target( delay, speed_scaler, forward, height, angle, dist )
{
	array = [];
	
	if( !isdefined( delay ) )
		delay = .05;
	if( !isdefined( speed_scaler ) )
		speed_scaler = 1;
	if( !isdefined( forward ) )
		forward = true;
	if( !isdefined( height ) )
		height = 0;
	if( !isdefined( angle ) )
		angle = 38;
	if( !isdefined( dist ) )
		dist = 64;
	
	wait delay;	
	
	muzzle 				= self gettagorigin( "tag_flash" );
	array[ "speed" ] 	= 50 * speed_scaler;
	start				= ( self.origin[0] ,self.origin[1], muzzle[2] );
	
	origin 					= start + ( vector_multiply( anglestoforward( self.angles ), dist ) ) + (0,0,height);
	array[ "start_origin" ] = start + ( vector_multiply( anglestoforward( self.angles + (0,angle,0) ), dist ) ) + (0,0,height);
	array[ "end_origin" ]	= start + ( vector_multiply( anglestoforward( self.angles + (0,( angle * -1 ),0) ), dist ) ) + (0,0,height);
		
	if( forward )
		array[ "node_origin" ] = array[ "end_origin" ];	
	else
		array[ "node_origin" ] = array[ "start_origin" ];
	
	array[ "target" ] = spawn( "script_origin", origin );
//	array[ "target" ] = spawn( "script_model", origin );
//	array[ "target" ] setmodel( "weapon_us_smoke_grenade" );
	return array;
}

stop_spray_and_pray_cleanup( target, msg )
{
	self waittill( msg );
	
	self.no_pistol_switch = self.old_pistol_switch;
	self ClearEntityTarget();
	target 	delete();
}

ap_teleport_player( name )
{
	if ( !isdefined( name ) )
		name = level.start_point;

	array = getstructarray( "start_point", "targetname" );

	nodes = [];
	foreach ( ent in array )
	{
		if ( ent.script_noteworthy != name )
			continue;

		nodes[ nodes.size ] = ent;
	}

	teleport_players( nodes );
}

ap_teleport_team( nodes )
{
	flag_wait( "team_initialized" );
	
	foreach( node in nodes )
	{
		if( !isalive( level.team[ node.script_noteworthy ] ) )
			continue;
			
		actor = level.team[ node.script_noteworthy ];
		actor thread teleport_actor( node );
	}
}

teleport_actor( node )
{
	link = spawn( "script_origin", self.origin );
	link.angles = self.angles;
	self linkto( link );
	
	link moveto( node.origin, .05 );
	if( isdefined( node.angles ) )
		link rotateto( node.angles, .05 );
	
	link waittill( "movedone" );
	wait .05;
	
	self setgoalpos( node.origin );
	self unlink();
	link delete();
	self orientmode( "face angle", node.angles[ 1 ] );
}

music_HZ_airport()
{
	music_loop( "airport_alternate", 443 );
}

music_stalk()
{		
	music_loop( "airport_stalk", 164 );
}

music_anticipation()
{
	music_loop( "airport_anticipation", 45.3 );
}

music_escape()
{
	music_loop( "airport_escape", 65 );
}

music_doublecross()
{
	music_play( "airport_doublecross" );
}

side_step( anime, angles )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	
	if( !( self ent_flag_exist( "side_step" ) ) )
		self ent_flag_init( "side_step" );
	
	self ent_flag_set( "side_step" );
	self.sidestep = true;
	
	while( self.sidestep )
	{
		self.ref_node.origin = self.origin;
		self.ref_node.angles = angles;
		self.ref_node anim_generic( self, anime );	
	}
	
	self ent_flag_clear( "side_step" );
}

side_step_stop()
{
	self.sidestep = false;
	self stopanimscripted();
}

kill_player()
{
	trigger_wait( "kill_player", "targetname" );
	level.player EnableDeathShield( false );
	level.player EnableHealthShield( false );
	level.player kill();
}

good_save_handler()
{
	while( 1 )
	{
		flag_wait_any( "friendly_fire_dist_check", "friendly_fire_kill_check", "friendly_fire_warning" );
		
		flag_set( "do_not_save" );
		
		while( flag( "do_not_save" ) )
		{
			flag_waitopen( "friendly_fire_dist_check" );
			flag_waitopen( "friendly_fire_kill_check" );
			flag_waitopen( "friendly_fire_warning" );
					
			if( flag( "friendly_fire_dist_check" ) || flag( "friendly_fire_kill_check" ) || flag( "friendly_fire_warning" ) )
				continue;
			
			flag_clear( "do_not_save" );
		}
	}
}

intro_phys_push()
{
	switch( int( self.script_noteworthy ) )
	{
		case 2:
			wait 2.25;
			break;
		case 3:
			wait 1.75;
			break;
		case 6:
			wait 1.5;
			break;
		case 7:
			wait 1.7;
			break;
		case 5:
			wait 1.6;
			break;
		default:
			wait 1;
			break;
	}	
	
	self PhysicsLaunchClient( self.origin + (0,0,32), vector_multiply( anglestoforward( self.angles ), 1000 ) );
}

player_line_of_fire( _flag, team )
{
	min = .8 / team.size;
	max = 1.6 / team.size;
	while( !flag( _flag ) )
	{
		if( distance( self.origin, level.player.origin ) < self.radius )
		{
			guy = random( team );
			foreach( member in team )
			{
				vec1a = anglestoforward( guy gettagangles( "tag_flash" ) );
				vec2a = anglestoforward( member gettagangles( "tag_flash" ) );
				vec1b = vectornormalize( level.player.origin - guy.origin );
				vec2b = vectornormalize( level.player.origin - member.origin );
				
				if( vectordot( vec1a, vec1b ) < vectordot( vec2a, vec2b ) )
					guy = member;	
			}
			magicbullet( guy.weapon, guy gettagorigin( "tag_flash" ), level.player.origin + (0,0,12) );
		}
		wait randomfloatrange( min, max );
	}
}

#using_animtree( "generic_human" );
enable_calm_combat()
{	
	if( isdefined( self.calm_combat ) )
		return;
			
	self.calm_combat = 1;
	self.oldinterval = self.interval;
	self.interval = 1;
			
	setsaveddvar( "ai_friendlyFireBlockDuration", 0 );
	
	self.oldaccuracy 		= self.accuracy;
	self.oldbaseaccuracy	= self.baseAccuracy;
	self.accuracy 			= 1000;
	self.baseAccuracy 		= 1000;
	self.fixednode 			= false;
	
	self setFlashBangImmunity( true );	
	
	self maps\_casual_killer::enable_casual_killer();
}

disable_calm_combat()
{
	if( !isdefined( self.calm_combat ) )
		return;
	self.calm_combat = undefined;
	
	self.accuracy = self.oldaccuracy;
	self.baseAccuracy = self.oldbaseaccuracy;
	self.interval = self.oldinterval;
	
	self maps\_casual_killer::disable_casual_killer();
	self.no_pistol_switch 	= undefined;;
}

/************************************************************************************************************/
/*											FRIENDLY FIRE													*/
/************************************************************************************************************/
friendly_fire()
{
	level.player endon( "death" );
		
	precacheString( &"AIRPORT_FAIL_BLEW_COVER_FIRE" );
	precacheString( &"AIRPORT_FAIL_BLEW_COVER_WANDER" );
		
	level.friendly_fire_aggressive_num = 0;
	
	level.ff_data = [];
	level.ff_data[ "no_kill_line_num" ] = 0;
	level.ff_data[ "no_kill_line" ] 	= [];
	
	level.ff_data[ "no_kill_line" ][0] 	= "airport_mkv_thesesheep";
	level.ff_data[ "no_kill_line" ][1] 	= "airport_mkv_doubtyou";
	level.ff_data[ "no_kill_line" ][2] 	= "airport_mkv_openfire";
	level.ff_data[ "no_kill_line" ][3] 	= "airport_mkv_cowards";
	
	level.ff_data[ "no_dist_line_num" ] = 0;
	level.ff_data[ "no_dist_line" ] 	= [];
	level.ff_data[ "no_dist_line" ][0] 	= "airport_mkv_letsmoveup";
	level.ff_data[ "no_dist_line" ][1] 	= "airport_mkv_letsgo2";
	level.ff_data[ "no_dist_line" ][2] 	= "airport_mkv_keepmoving";
	level.ff_data[ "no_dist_line" ][3] 	= "airport_mkv_cowards";
	
	level.ff_data[ "ff_line" ] 			= "airport_mkv_checkfire";
	
	wait .05;
	
	thread friendly_fire_update_team_origin();
	
	array_thread( level.team, ::friendly_fire_watch_player );
	
	if( is_default_start() )
	{
		wait 41 - CONST_FF_FIRE_TIME;
		//level.player thread friendly_fire_notpartofteam();
		level.player thread friendly_fire_nade_throw();
		add_wait( ::flag_wait, "lobby_open_fire" );
		level.player add_func( ::friendly_fire_wander_away );
		thread do_wait();
	}
	else
	{
		wait .05;
		//level.player thread friendly_fire_notpartofteam();
		level.player thread friendly_fire_wander_away();
		level.player thread friendly_fire_nade_throw();
	}
	
	flag_wait( "friendly_fire_warning" );
	thread friendly_fire_player_death();
	level thread notify_delay( "friendly_fire_watch_player", .1 );
		
	level.player EnableDeathShield( false );
	level.player EnableHealthShield( false );
	
	array_thread( level.team, ::friendly_fire_kill_player );
	
	numdead = 0;
	switch( level.team.size )
	{
		case 4:
			numdead = 2;
			break;
		case 3 :
			numdead = 1;
			break;
		case 2:
			numdead = 2;
			break;
		case 1:
			numdead = 1;
			break;
	}
	waittill_dead_or_dying( level.team, numdead, CONST_FF_AUTOKILL_TIME );
	
	member = level.makarov;
		
	magicbullet( member.weapon, member gettagorigin( "tag_flash" ), level.player.origin + (0,0,64) );
	wait .2;
	magicbullet( member.weapon, member gettagorigin( "tag_flash" ), level.player.origin + (0,0,64) );
	wait .2;
	magicbullet( member.weapon, member gettagorigin( "tag_flash" ), level.player.origin + (0,0,64) );
	wait .2;
	magicbullet( member.weapon, member gettagorigin( "tag_flash" ), level.player.origin + (0,0,64) );
	level.player kill();
}

friendly_fire_wander_away()
{
	level endon( "friendly_fire_warning" );
	self endon( "death" );
	level endon( "friendly_fire_stop_checking_for_player_dist" );
	
	_flag = "friendly_fire_not_in_range";
	flag_init( _flag );
	self thread friendly_fire_distance_check( _flag );	
	
	while( level.ff_data[ "no_dist_line_num" ] < 4 )
	{
		flag_wait( _flag );
					
		while( level.ff_data[ "no_dist_line_num" ] < 4 )
		{
			flag_waitopen_or_timeout( _flag, CONST_FF_WANDER_TIME );
			
			if( flag( _flag ) )
			{	
				num = level.ff_data[ "no_dist_line_num" ];
				level.makarov thread radio_dialogue( level.ff_data[ "no_dist_line" ][ num ] );
				level.ff_data[ "no_dist_line_num" ]++;
				
				if( level.ff_data[ "no_dist_line_num" ] == 3 )
					flag_set( "friendly_fire_dist_check" );
			}
			else
				break;
		}		
		
		flag_clear( "friendly_fire_dist_check" );
		if( level.ff_data[ "no_dist_line_num" ] == 3 )
			level.ff_data[ "no_dist_line_num" ] = 2;	
	}	
	
	level.fail_string = &"AIRPORT_FAIL_BLEW_COVER_WANDER";
	flag_set( "friendly_fire_warning" );
}

friendly_fire_distance_check( _flag )
{
	while( 1 )
	{
		if( distance( level.team_origin, self.origin ) > CONST_FF_WANDER_DIST )
		{
			if( !flag( _flag ) )
				flag_set( _flag );
		}
		else
		{
			if( flag( _flag ) )
				flag_clear( _flag );	
		}
		wait .25;
	}		
}

friendly_fire_notpartofteam()
{
	level endon( "friendly_fire_warning" );
	level endon( "friendly_fire_stop_checking_for_player_fire" );
	self endon( "death" );
		
	_flag = "friendly_fire_is_attacking";
	flag_init( _flag );
	self thread friendly_fire_is_attacking_check( _flag );
		
	while( level.ff_data[ "no_kill_line_num" ] < 4 )
	{
		flag_wait_or_timeout( _flag, CONST_FF_FIRE_TIME );
		
		if( flag( "gate_main" ) )
		{
			flag_wait( "tarmac_open_fire" );
			flag_clear( "gate_main" );
			continue;	
		}
		
		if( flag( _flag ) )
		{
			if( level.ff_data[ "no_kill_line_num" ] == 3 )
				level.ff_data[ "no_kill_line_num" ] = 2;
			flag_clear( _flag );
			flag_clear( "friendly_fire_kill_check" );
			thread flag_clear_delayed( "friendly_fire_no_kill_line", 5 );
		}
		else
		{
			num = level.ff_data[ "no_kill_line_num" ];
			level.makarov thread radio_dialogue( level.ff_data[ "no_kill_line" ][ num ] );
			level.ff_data[ "no_kill_line_num" ]++;
			flag_set( "friendly_fire_no_kill_line" );
			
			if( level.ff_data[ "no_kill_line_num" ] == 3 )
				flag_set( "friendly_fire_kill_check" );
		}
	}
	
	level.fail_string = &"AIRPORT_FAIL_BLEW_COVER_WANDER";
	flag_set( "friendly_fire_warning" );
}

friendly_fire_is_attacking_check( _flag )
{
	self endon( "death" );
	level endon( "friendly_fire_warning" );
//	"+melee"
//	"+melee_breath"
//	"-smoke"
//	"+smoke"
	notifyOnCommand( "attack", "+frag" );
	notifyOnCommand( "attack", "+attack" );
	
	while( 1 )
	{
		self waittill( "attack" );
		flag_set( _flag );
		flag_waitopen( _flag );
	}
}

friendly_fire_nade_throw()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "grenade_fire", grenade );
		grenade.owener = self;
	}
}

friendly_fire_player_death()
{
	level.player waittill( "death" );
	
	if( isdefined( level.fail_string ) )
		setdvar( "ui_deadquote", level.fail_string );
	missionFailedWrapper();
}

friendly_fire_decrement_aggressive_num()
{
	wait CONST_FF_DECREMENT_TIME;
	level.friendly_fire_aggressive_num--;
}

friendly_fire_handle_aggrissive_num()
{
	level.friendly_fire_aggressive_num++;
	if( level.friendly_fire_aggressive_num >= CONST_FF_AGGRISSIVE_NUM )
		flag_set( "friendly_fire_warning" );
	else
		thread friendly_fire_decrement_aggressive_num();	
}

friendly_fire_watch_player_nade()
{
	level endon( "friendly_fire_watch_player" );
	self endon( "friendly_fire_new_watch_cycle" );
	
	while( 1 )
	{
		self waittill( "ai_event", type, nade );
		waittillframeend;
				
		if( flag( "friendly_fire_pause_flash" ) )
			continue;
		
		if( type != "grenade danger" )
			continue;
		
		if( !isdefined( nade.owener ) )
			continue;
		
		if( !isdefined( self.grenade ) )
			continue;
			
		self.ff_attacker = nade.owener;
			
		if( !isplayer( self.ff_attacker ) )	
			continue;
			
		flag_set( "friendly_fire_warning" );
		level.fail_string = &"AIRPORT_FAIL_BLEW_COVER_FIRE";
		break;
	}
}


friendly_fire_watch_player_flash()
{
	level endon( "friendly_fire_watch_player" );
	self endon( "friendly_fire_new_watch_cycle" );
	
	while( 1 )
	{
		self waittill( "flashbang", origin, amount_distance, amount_angle, attacker, attackerteam );
		waittillframeend;
		
		if( flag( "friendly_fire_pause_flash" ) )
			continue;
		
		self.ff_attacker = attacker;
			
		if( !isplayer( self.ff_attacker ) )	
			continue;
			
		friendly_fire_handle_aggrissive_num();
		if( flag( "friendly_fire_warning" ) )
			level.fail_string = &"AIRPORT_FAIL_BLEW_COVER_FIRE";
		break;
	}
}

friendly_fire_watch_player_fire()
{
	level endon( "friendly_fire_watch_player" );
	self endon( "friendly_fire_new_watch_cycle" );
	
	self waittill( "damage", amt, attacker, vec, point, type );			
	waittillframeend;
	
	self.ff_attacker = attacker;
	
	if( isplayer( self.ff_attacker ) && !flag( "friendly_fire_pause_fire" ) )
	{
		friendly_fire_handle_aggrissive_num();	
		
		if( flag( "friendly_fire_warning" ) )
			level.fail_string = &"AIRPORT_FAIL_BLEW_COVER_FIRE";
	}
}
	
friendly_fire_watch_player()
{
	level endon( "friendly_fire_watch_player" );
	
	self endon( "death" );
		
	amt = 0;
	self addAIEventListener( "grenade danger" );
	
	while( 1 )
	{
		self notify( "friendly_fire_new_watch_cycle" );
		self add_wait( ::friendly_fire_watch_player_fire );
		self add_wait( ::friendly_fire_watch_player_flash );
		self add_wait( ::friendly_fire_watch_player_nade );
		self do_wait_any();
				
		if( isplayer( self.ff_attacker ) && flag( "friendly_fire_warning" ) )
		{
			radio_dialogue_stop();
			level.makarov thread radio_dialogue( "airport_mkv_youtraitor" );
			break;
		}
		else
		if( isplayer( self.ff_attacker ) && !flag( "friendly_fire_checkfire_line" ) )
		{
			flag_set( "friendly_fire_checkfire_line" );
			thread flag_clear_delayed( "friendly_fire_checkfire_line", 2.5 );
			
			if( !flag( "friendly_fire_pause_fire" ) )
			{
				radio_dialogue_stop();
				level.makarov thread radio_dialogue( level.ff_data[ "ff_line" ] );
			}
			else
			{
				if( cointoss() )
				{
					level.makarov stopsounds();
					if( cointoss() )
						level.makarov thread dialogue_queue( "check_fire1" );
					else
						level.makarov thread dialogue_queue( "check_fire2" );
				}
				else
				{
					level.team[ "m4" ] stopsounds();
					if( cointoss() )
						level.team[ "m4" ] thread dialogue_queue( "check_fire1" );
					else	
						level.team[ "m4" ] thread dialogue_queue( "check_fire2" );
				}
			}
		}
	}	
		
	if( amt < 80 || self.script_noteworthy == "makarov" )
		return;
		
	if( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	self kill();
}

friendly_fire_kill_player()
{
	self endon( "death" );
	
	wait .05;
	
	self disable_dynamic_run_speed();
	waittillframeend;
	self maps\_casual_killer::disable_casual_killer();
	self clear_run_anim();
			
	self.ignoreme = true;
	self.ignoreall = false;
	self.dontevershoot = undefined;
	self.team = "axis";
	self.favoriteenemy = level.player;
	self.baseaccuracy = 1000;
	self.accuracy = 1000;
	self.combatmode = "cover";
	self.moveplaybackrate = 1.1;
	self notify( "stop_spray_and_pray" );
	self notify( "stop_loop" );
	self stopanimscripted();
	self pushplayer( false );
	
	self setFlashBangImmunity( true );	
	
	if( self.script_noteworthy != "makarov" )
	{
		if( isdefined( self.magic_bullet_shield ) )
			self stop_magic_bullet_shield();
		self.maxhealth = 300;
	
		if( self.health > 300 )
			self.health = 300;
	}
	else
	{
		self.a.disablePain = 1;	
		self.primaryweapon = "m4_grunt";
		self forceuseweapon( self.primaryweapon, "primary" );
	}
	
	self.goalradius = 400;
	while( 1 )
	{
		self setgoalentity( level.player );
		
		wait 1;
	}
}

friendly_fire_good_kill()
{
	if( flag( "friendly_fire_warning" ) )
		return;
	level endon( "friendly_fire_warning" );
	
	if( flag( "tarmac_moveout" ) )
		return;
	level endon( "tarmac_moveout" );
	
	self waittill( "death", attacker );
	
	if( !isplayer( attacker ) )
		return;
		
	if( flag( "friendly_fire_no_kill_line" ) && !flag( "friendly_fire_good_kill_line" )  )
	{
		flag_set( "friendly_fire_good_kill_line" );
		thread flag_clear_delayed( "friendly_fire_good_kill_line", 20 );
		
		if( !flag( "friendly_fire_good_kill_line2" ) )
		{
			flag_set( "friendly_fire_good_kill_line2" );
			thread flag_clear_delayed( "friendly_fire_good_kill_line2", 20 );
		}
		level.makarov radio_dialogue( "airport_mkv_welldone" );
	}
	else if( !flag( "friendly_fire_good_kill_line2" ) && flag( "stairs_upperdeck_civs_dead" ) )
	{
		flag_set( "friendly_fire_good_kill_line2" );
		level.makarov radio_dialogue( "airport_mkv_nice" );
	}
}

friendly_fire_update_team_origin()
{
	while( !flag( "escape_player_get_in" ) )
	{
		origin = (0,0,0);
		num = 0;
		
		foreach( member in level.team )
		{
			if( !isalive( member ) )
				continue;
			num++;
			origin += member.origin;				
		}
		
		level.team_origin = vector_multiply( origin, ( 1.0 / num ) );	
		
		wait .1;
	}
}

/************************************************************************************************************/
/*												VISION SETS													*/
/************************************************************************************************************/

airport_vision_intro( dontwait )
{
	if( !isdefined( dontwait ) )
		trigger_wait( "intro_vision_set", "targetname" );
		
	time = 6;
	maps\_utility::set_vision_set( "airport_intro", time );
	setExpFog( 619.914, 2540.24, 0.357315, 0.371612, 0.314966, 0.75818, time, 0.862745, 0.807843, 0.596078, (-0.834131, 0.375308, -0.404189), 18.8429, 49.858, 1.22086 );	
}

airport_vision_stairs( dontwait )
{
	if( !isdefined( dontwait ) )
		flag_wait( "player_set_speed_stairs" );
		
	time = 2;
	maps\_utility::set_vision_set( "airport_stairs", time );
	setExpFog( 619.914, 2540.24, 0.356863, 0.372549, 0.313726, 0.629246, time, 0.862745, 0.807843, 0.596078, (-0.894864, 0.44208, -0.0615121), 0, 20.1783, 1.22086 );
}

airport_vision_exterior( dontwait )
{
	if( !isdefined( dontwait ) )
		flag_wait( "tarmac_hear_fsb" );
		
	time = 12;
//	maps\_utility::set_vision_set( "airport_exterior", time );
	setExpFog( 619.914, 3914.89, 0.584314, 0.623529, 0.635294, 0.710723, time );
}

airport_vision_basement( dontwait )
{	
	if( !isdefined( dontwait ) )
		flag_wait( "basement_set_vision" );
		
	time = 5;
	maps\_utility::set_vision_set( "airport", time );
	setExpFog( 619.914, 3914.89, 0.584314, 0.623529, 0.635294, 0.710723, time );
}
	
airport_vision_escape( dontwait )
{
	if( !isdefined( dontwait ) )
		trigger_wait( "escape_vision_set", "targetname" );
		
	time = 3.0;
	maps\_utility::set_vision_set( "airport_intro", time );
	setExpFog( 521.672, 2540.24, 0.441339, 0.532734, 0.533566, 0.629246, time, 0.862745, 0.807843, 0.596078, (-0.700556, -0.712205, -0.0445665), 0, 23.7759, 0.644149 );
}

airport_vision_makarov( dontwait )
{
	if( !isdefined( dontwait ) )
		flag_wait( "escape_mak_grab_hand" );
		
	time = 1.0;
	maps\_utility::set_vision_set( "airport_intro", time );
}

/************************************************************************************************************/
/*												JET ENGINES													*/
/************************************************************************************************************/

jet_engine()
{
	self endon( "death" );
	
	self jet_engine_setup();
	
	self jet_engine_state_check();
	
	self thread jet_engine_bcs();
		
	while( 1 )
	{
		self waittill( "took_damage", amount );
		
		self.script_health -= amount;
		
		self jet_engine_state_check();
		
		//this makes sure we take only one damage amount every server frame
		wait .05;
	}
}

jet_engine_state_check()
{
	state = "idle";
	if( self.script_health < 0 )
		state = "death";
	else 
	if( self.script_health < self.max_health * .8 )
		state = "burning";
	else
	if( self.script_health < self.max_health )
		state = "damaged";
	
	if( state == self.state )
		return;
	self.state = state;
	
	self thread jet_engine_do_state();	
}

jet_engine_bcs()
{
	self endon( "death" );
	
	while( distancesquared( level.player.origin, self.origin ) > squared( 500 ) || self.script_health > self.max_health * .5 )
		wait .1;
		
	flag_waitopen( "tarmac_bcs" );
				
	flag_set( "tarmac_bcs" );
		level.makarov dialogue_queue( "engine_warn" );
	flag_clear( "tarmac_bcs" );	
}

jet_engine_do_state()
{
	self notify( self.state );
	self endon( "death" );
	
	switch( self.state )
	{
		case "idle":
			self jet_engine_fx_idle();
			self playloopsound( "dst_jet_engine_close" );
			break;
		case "burning":
			self.idle_org delete();
			self jet_engine_fx_burn();
			self jet_engine_suck_setup();
			self stoploopsound();
			self playloopsound( "dst_jet_engine_burn" );
			self thread jet_engine_health_drain();
			break;
				
		case "death":
			self jet_engine_fx_explode();
			range = 300;
			RadiusDamage( self.fx.origin + (0,0,-40), range, 300, 20, self.des );//similar to destructibles
			PhysicsExplosionSphere( self.fx.origin, range, 0, range * .01 );//similar to destructibles
			self stoploopsound();
			self stopsounds();
			self playsound( "dst_jet_engine_explosion" );
			self.burn_org delete();
			self.new delete();
			self.des show();
			self.des solid();	
			self delaycall( .5, ::delete );		
			break;	
	}
}

jet_engine_fx_idle()
{
	self.idle_org = spawn( "script_model", self.fx.origin );
	
	vec = anglestoforward( self.fx.angles );
	vec = vector_multiply( vec, 135.5 );
	self.idle_org.origin += vec;
	
	self.idle_org setmodel( "tag_origin" );
	self.idle_org hide();
	self.idle_org.angles = self.fx.angles;
	PlayFXOnTag( getfx( "jet_engine_737" ), self.idle_org, "tag_origin" );	
}

jet_engine_fx_burn()
{
	self.burn_org = spawn( "script_model", self.fx.origin );
	
	vec = anglestoforward( self.fx.angles );
	vec = vector_multiply( vec, 31 );
	self.burn_org.origin += vec;
	
	self.burn_org setmodel( "tag_origin" );
	self.burn_org hide();
	self.burn_org.angles = self.fx.angles;
	PlayFXOnTag( getfx( "jet_fire" ), self.burn_org, "tag_origin" );
}

jet_engine_fx_explode()
{
	self.exp_org = spawn( "script_model", self.fx.origin );
	
	vec = anglestoforward( self.fx.angles );
	vec = vector_multiply( vec, 31 );
	self.exp_org.origin += vec;
	
	self.exp_org setmodel( "tag_origin" );
	self.exp_org hide();
	self.exp_org.angles = self.fx.angles;
	PlayFXOnTag( getfx( "jet_explosion" ), self.exp_org, "tag_origin" );	
	self.exp_org delaycall( 1, ::delete );
}

jet_engine_suck_setup()
{	
	self.suck_org = spawnstruct();
	
	vec = anglestoforward( self.fx.angles );
	vec = vector_multiply( vec, -31 );
	self.suck_org.origin = self.fx.origin + vec;
	self.suck_org.angles = self.fx.angles + (0,180,0);
	
	array_thread( getentarray( "jet_engine_debri", "targetname" ), ::jet_engine_suck_debris, self );
}

jet_engine_suck_debris( engine )
{
	engine endon( "death" );
	
	minrange = 64;
	maxrange = 386;
	pullrange = 150;
	effectrange = 96;
	min = squared( minrange );
	max = squared( maxrange );
	
	pull = squared( pullrange );
	
	org1 = engine.suck_org.origin - (0,0,76);
	org2 = ( self.origin[0], self.origin[1], org1[2] );
	
	vec = vectornormalize( self.origin - engine.suck_org.origin );
	if( vectordot( vec, anglestoforward( engine.suck_org.angles ) ) < .4 )
		return;
	
	if( distancesquared( engine.suck_org.origin, self.origin ) < min )
		return; 
	
	if( distancesquared( engine.suck_org.origin, self.origin ) > max )
		return; 
		
	while( distancesquared( engine.suck_org.origin, self.origin ) > squared( effectrange ) )
	{
		effectrange += 3;
		wait .1;
	}
	
	dir = vectornormalize( org1 - org2 );
	scale = 1;
	while( distancesquared( engine.suck_org.origin, self.origin ) > pull )
	{
		scale *= 1.5;
		if( scale > 40 )
			scale = 40;
			
		vec = vector_multiply( dir, scale );
		self Moveto( ( self.origin + vec ), .1 );
		self RotateVelocity( (0,300,0), .1 );
		wait .05;
	}

	self thread jet_engine_suck_debris_final( engine );
}

jet_engine_suck_debris_final( engine )	
{
	speed = 400;
	time = distance( engine.suck_org.origin, self.origin ) / speed;
	self moveto( engine.suck_org.origin + ( randomfloatrange( -10,10), randomfloatrange( -10,10 ), randomfloat( 10 ) ), time );
	self RotateVelocity( ( randomintrange( -650, -550 ) , randomintrange( 350, 450 ) , randomintrange( 50, 150 ) ), time );
	
	wait time;
	
	playfx( getfx( "jet_engine_fire_debris" ), self.origin, anglestoforward( engine.suck_org.angles ), anglestoup( engine.suck_org.angles ) );
	
	self delete();
}	

jet_engine_health_drain()
{
	self endon( "death" );
	
	dmg = int( self.script_health / 60 ); //this will make it blow up in 60 seconds
	
	while( 1 )
	{
		self notify( "damage", dmg );
		BadPlace_Cylinder( "jet_engine_burn" + self.fx.targetname, 1, self.fx.origin + (0,0,-76), 250, 150, "allies", "axis", "neutral" );
		wait 1;
	}
}

jet_engine_take_damage( parent )
{
	parent endon( "death" );
	
	while( 1 )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		if( isdefined( type ) && type == "MOD_CRUSH" )
		{
			wait .1;
			continue;
		}
		if( isdefined( attacker ) && !isplayer( attacker ) && distancesquared( level.player.origin, self getorigin() ) < 1500 )
		{
			wait .1;
			continue;	
		}
		parent notify( "took_damage", amount, attacker, direction_vec, point, type );
	}	
}

jet_engine_setup()
{
	self.max_health = 1300;
	self.script_health = self.max_health;
	
	self.state = "new";
	
	//setup the parts
	self.new = getent( self.target, "targetname" );
	self.new setcandamage( true );
	
	self.des = getent( self.new.target, "targetname" );
	self.des.destructible_type = "jet_engine";
	self.des hide();
	self.des notsolid();
	
	self.fx = getstruct( self.des.target, "targetname" );
		
	self thread jet_engine_take_damage( self );	
	self.new thread jet_engine_take_damage( self );	
}

jet_engine_death_print()
{
	precacheString( &"AIRPORT_EXPLODING_JET_ENGINE_DEATH" );
	precacheshader( "hud_burningjetengineicon" );
	
	level.player waittill( "death", attacker, cause, weaponName );
	
	if ( cause != "MOD_EXPLOSIVE" )
		return;
	
	if( !isdefined( attacker ) )
		return;
	
	if( !isdefined( attacker.destructible_type ) )
		return;
	
	if( attacker.destructible_type != "jet_engine" )
		return;
			
	thread maps\_load::special_death_indicator_hudelement( "hud_burningjetengineicon", 64, 64 );	
	
	wait .05;
	setdvar( "ui_deadquote", "@AIRPORT_EXPLODING_JET_ENGINE_DEATH" );
}

glass_elevator_setup()
{
	elevator_glass 		= getentarray( "elevator_housing_glass", "script_noteworthy" );
	elevator_model 		= getentarray( "airport_glass_elevator", "script_noteworthy" );
	elevator_door_models = getentarray( "airport_glass_elevator_door", "script_noteworthy" );
	
	elevator_doors = getentarray( "elevator_doors", "script_noteworthy" );
	elevator_house = getentarray( "elevator_housing", "targetname" );
	
	elevator_cables = getentarray( "elevator_cable", "targetname" );
	
	elevator_wheels = getentarray( "elevator_wheels", "targetname" );
	
	foreach( piece in elevator_glass )
	{
		house = getclosest( piece getorigin(), elevator_house );
		piece linkto( house );		
	}
	foreach( piece in elevator_model )
	{
		house = getclosest( piece.origin, elevator_house );
		piece linkto( house );		
	}
	foreach( piece in elevator_door_models )
	{
		door = getclosest( piece.origin, elevator_doors );
		piece linkto( door );	
	}	
	
	wait .05;
		
	foreach( obj in level.elevators )
	{	
		housing = obj.e[ "housing" ][ "mainframe" ][ 0 ];
		cable = getclosest( housing getorigin(), elevator_cables );
		cable.elevator_model = housing;
		cable.elevator = obj;
		
		wheels = get_array_of_closest( housing getorigin(), elevator_wheels, undefined, 2 );
		cable.wheels = [];
		foreach( item in wheels )
		{
			anchor = spawn( "script_origin", item.origin );
			item linkto( anchor );
			cable.wheels[ item.script_noteworthy ] = anchor;
		}
	}	
	
	array_thread( elevator_cables, ::glass_elevator_cable );
}

glass_elevator_cable()
{	
	cable = self;
	
	while( isdefined( cable.target ) )
	{
		cable = getent( cable.target, "targetname" );
		cable hide();
	}
	
	elevator 	= self.elevator;
	elevator.cable = self;
	cable 		= self;
	housing 	= self.elevator_model;
	cable.wheels 	= self.wheels;
		
	level.velF = (0,0,200);
	level.velR = (0,0,-200);
	level.ELEV_CABLE_HEIGHT = CONST_ELEV_CABLE_HEIGHT;
	
	floor_num = 0;
	mainframe = elevator common_scripts\_elevator::get_housing_mainframe();
	delta_vec = elevator.e[ "floor" + floor_num + "_pos" ] - mainframe.origin;

	speed = level.elevator_speed;
	dist = abs( distance( elevator.e[ "floor" + floor_num + "_pos" ], mainframe.origin ) );
	moveTime = dist / speed;
		
	while( 1 )
	{
		//start at the top
		//moving down
		elevator waittill( "elevator_moving" );
			elevator elevator_animated_down( cable, housing, moveTime );
		//stopped	
		elevator waittill( "elevator_moved" );
		//moving back up
		elevator waittill( "elevator_moving" );
			elevator elevator_animated_up( cable, housing, moveTime );
		//stopped	
		elevator waittill( "elevator_moved" );
	}
}

elevator_animated_down( cable, housing, moveTime )
{
	wheels = cable.wheels;
	cable thread glass_elevator_cable_down( housing, self );	
	wheels[ "top" ] rotatevelocity( level.velF, moveTime, 1, 1 );
	wheels[ "bottom" ] rotatevelocity( level.velR, moveTime, 1, 1 );
}

elevator_animated_down_fast( cable, housing, moveTime, velF, velR )
{
	wheels = cable.wheels;
	cable thread glass_elevator_cable_down( housing, self );	
	wheels[ "top" ] rotatevelocity( velF, moveTime, moveTime );
	wheels[ "bottom" ] rotatevelocity( velR, moveTime, moveTime );
}

elevator_animated_up( cable, housing, moveTime )
{
	wheels = cable.wheels;
	housing.last_cable thread glass_elevator_cable_up( housing, self );	
	wheels[ "top" ] rotatevelocity( level.velR, moveTime, 1, 1 );
	wheels[ "bottom" ] rotatevelocity( level.velF, moveTime, 1, 1 );
}

glass_elevator_cable_down( housing, elevator )
{
	self attach_housing( housing );
	
	elevator endon( "elevator_moved" );
	
	while( distancesquared( self.og, self getorigin() ) < squared( level.ELEV_CABLE_HEIGHT ) )
		wait .05;
	
	if( !isdefined( self.target ) )
		return;
		
	next_cable = getent( self.target, "targetname" );	
	next_cable thread glass_elevator_cable_down( housing, elevator );
}

attach_housing( housing )
{
	self.og = self getorigin();
	self linkto( housing );
	housing.last_cable = self;
	
	if( !isdefined( self.target ) )
		return;
		
	next_cable = getent( self.target, "targetname" );	
	next_cable show();
}

glass_elevator_cable_up( housing, elevator )
{
	elevator endon( "elevator_moved" );
	
	while( distancesquared( self.og, self getorigin() ) > squared( CONST_ELEV_CABLE_CLOSE ) )
		wait .05;
	
	self thread detach_housing( housing );
	
	if( self.targetname == "elevator_cable" )
		return;
	
	prev_cable = getent( self.targetname, "target" );
	prev_cable thread glass_elevator_cable_up( housing, elevator );
}

detach_housing( housing )
{
	if( self.targetname == "elevator_cable" )
		return;
	self unlink();	
	time = .5;
	self moveto( self.og, time );
	wait time;
	self hide();
}

GrenadeDangerbsc()
{
	if( !flag_exist( "bsc_nade" ) )
		flag_init( "bsc_nade" );
	
	level endon( "escape_main" );
		
	while ( 1 )
	{
		self waittill( "grenade danger", grenade );

		if( flag( "bsc_nade" ) )
			continue;
			
		if ( !isdefined( grenade ) || grenade.model != "projectile_m67fraggrenade" )
			continue;

		if ( distance( grenade.origin, level.player.origin ) < 512 )// grenade radius is 220
		{
			flag_set( "bsc_nade" );
			
			guy = level.makarov;
			if( cointoss() )
				guy = level.team[ "m4" ];
			
			guy stopsounds();
			if( cointoss() )
				guy dialogue_queue( "grenade1" );
			else	
				guy dialogue_queue( "grenade2" );
			
			wait 4;
			
			flag_clear( "bsc_nade" );
		}
	}
}

m203_hint()
{
	interval = .1;
	time = 5;
	
	while( time > 0 )
	{
		if ( should_break_m203_hint() )
			return;
		
		time -= interval;
		wait interval;
	}	
	
	display_hint_timeout( "grenade_launcher", 5 );
}

should_break_m203_hint( nothing )
{
	player = get_player_from_self();
	assert( isplayer( player ) );

	// am I using my m203 weapon?
	weapon = player getcurrentweapon();
	prefix = getsubstr( weapon, 0, 4 );
	if ( prefix == "m203" )
		return true;

	// do I have any m203 ammo to switch to?
	heldweapons = player GetWeaponsListAll();
	foreach ( weapon in heldweapons )
	{
		ammo = player getWeaponAmmoClip( weapon );
		if ( !issubstr( weapon, "m203" ) )
			continue;
		if ( ammo > 0 )
			return false;
	}
	
	return true;
}

#using_animtree( "vehicles" );
van_opendoors()
{
	self useanimtree( #animtree );
	self setanim( %airport_ending_open_doors );	
	sndent = GetEnt( "escape_amb_door_snd", "targetname" );
	sndent PlaySound( "scn_ambulance_doors_open" );
}
van_closedoors()
{
	self useanimtree( #animtree );
	self clearAnim( %airport_ending_open_doors, .2 );
	self setanim( %airport_ending_close_doors );	
	sndent = GetEnt( "escape_amb_door_snd", "targetname" );
	sndent PlaySound( "scn_ambulance_doors_close" );
}