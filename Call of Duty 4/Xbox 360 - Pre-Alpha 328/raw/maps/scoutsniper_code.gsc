#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\scoutsniper;
#include common_scripts\utility;
#include maps\_stealth_logic;



updateFog()
{
	trigger_fogdist3000 = getent( "trigger_fogdist3000", "targetname" );
	trigger_fogdist5000 = getent( "trigger_fogdist5000", "targetname" );

	for( ;; )
	{
		trigger_fogdist3000 waittill( "trigger" );
		setExpFog( 0, 3000, 0.33, 0.39, 0.545313, 1 );
		
		trigger_fogdist5000 waittill( "trigger" );
		setExpFog( 0, 8000, 0.33, 0.39, 0.545313, 1 );
	}
}

// detects player only, friendly AI not supported
execVehicleStealthDetection()
{
	self thread maps\_vehicle::mgoff();
	
	flag_wait( "_stealth_spotted" );
	self thread vehicle_turret_think();
}

stop_dynamic_run_speed()
{
	self endon( "start_dynamic_run_speed" ); 
	
	self stop_dynamic_run_speed_wait();
	
	self.moveplaybackrate = self.old_moveplaybackrate;
	self clear_run_anim();	
	
	self notify( "stop_dynamic_run_speed_stopped_loop" );
	self ent_flag_clear( "dynamic_run_speed_stopping" );
	self ent_flag_clear( "dynamic_run_speed_stopped" );
}

stop_dynamic_run_speed_wait()
{
	level endon( "_stealth_spotted" );
	self waittill( "stop_dynamic_run_speed" );
}

dynamic_run_speed( pushdist, sprintdist )
{
	self endon( "death" );
	self notify( "start_dynamic_run_speed" );
	self endon( "start_dynamic_run_speed" );
	self endon( "stop_dynamic_run_speed" );
	level endon( "_stealth_spotted" );
	
	self ent_flag_waitopen( "_stealth_custom_anim" );
	
	self thread stop_dynamic_run_speed();

	self.run_speed_state = "";
	self.old_moveplaybackrate = self.moveplaybackrate;
	
	if( !isdefined( self.ent_flag[ "dynamic_run_speed_stopped" ] ) )
	{
		self ent_flag_init( "dynamic_run_speed_stopped" );
		self ent_flag_init( "dynamic_run_speed_stopping" );
	}
	
	if( !isdefined(pushdist) )
		pushdist = 250;
		
	if( !isdefined(sprintdist) )
		sprintdist = pushdist * .5;
		
	while(1)
	{
		wait .05;
		
		//iprintlnbold( self.run_speed_state );
		
		vec = anglestoforward( self.angles );
		vec2 = vectornormalize( ( level.player.origin - self.origin ) );
		vecdot = vectordot(vec, vec2);
		
		//how far is the player
		dist = distance( self.origin, level.player.origin );
		
		if ( dist < sprintdist || vecdot > -.25 )
		{							
			dynamic_run_set( "sprint" );
			continue;
		}
		
		else if ( dist < pushdist || vecdot > -.25 )
		{
			dynamic_run_set( "run" );
			continue;
		}
		
		else if ( dist > pushdist * 2 )
		{
			dynamic_run_set( "stop" );
			continue;	
		}
			
		else if ( dist > pushdist * 1.25 )
		{
			dynamic_run_set( "jog" );
			continue;
		}
	}
}

dynamic_run_set( speed )
{
	if ( self.run_speed_state == speed )
		return;
		
	self.run_speed_state = speed;
	
	switch( speed )
	{
		case "sprint":
			//self.moveplaybackrate = 1.44;
			
			//self clear_run_anim();
			self.moveplaybackrate = 1;
			self set_generic_run_anim( "sprint" );
			
			self notify( "stop_dynamic_run_speed_stopped_loop" );
			self stopanimscripted();
			self ent_flag_clear( "dynamic_run_speed_stopped" );
			break;
		case "run":
			self.moveplaybackrate = 1;
			
			self clear_run_anim();
				
			self notify( "stop_dynamic_run_speed_stopped_loop" );
			self stopanimscripted();
			self ent_flag_clear( "dynamic_run_speed_stopped" );
			break;
		case "stop":
			self thread dynamic_run_speed_stopped();
			break;
		case "jog":
			self.moveplaybackrate = 1;
			
			self set_generic_run_anim( "combat_jog" );
			
			self notify( "stop_dynamic_run_speed_stopped_loop" );
			self stopanimscripted();
			self ent_flag_clear( "dynamic_run_speed_stopped" );
			break;
	}	
}

dynamic_run_speed_stopped()
{
	if( self ent_flag( "dynamic_run_speed_stopped" ) )
		return;
	if( self ent_flag( "dynamic_run_speed_stopping" ) )
		return;
	
	self endon( "stop_dynamic_run_speed" );
		
	self ent_flag_set( "dynamic_run_speed_stopping" );
	self ent_flag_set( "dynamic_run_speed_stopped" );
	
	self endon( "dynamic_run_speed_stopped" );
	
	stop = "run_2_stop";	
	self anim_generic_custom_animmode( self, "gravity", stop );
	self ent_flag_clear( "dynamic_run_speed_stopping" ); //this flag gets cleared if we endon
			
	while( self ent_flag( "dynamic_run_speed_stopped" ) )
	{
		idle = "combat_idle";
		self thread anim_generic_loop( self, idle, undefined, "stop_dynamic_run_speed_stopped_loop" );
		
		wait randomfloatrange(12, 20);
		
		self notify( "stop_dynamic_run_speed_stopped_loop" );
		
		if( !self ent_flag( "dynamic_run_speed_stopped" ) ) 
			return;
		
		switch( randomint( 6 ) )
		{
			case 0:
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo" );
				break;
			case 1:
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo2" );
				break;
			case 2:
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveup" );
				break;
			case 3:
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveout" );
				break;
			case 4:
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_followme2" );
				break;
			case 5:
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_onme" );
				break;
				
		}
		
		wave = "moveup_exposed";
		self anim_generic( self, wave ); 
	}
}

follow_path_get_node( name, type )
{
	return getnodearray( name, type );	
}

follow_path_get_ent( name, type )
{
	return getentarray( name, type );	
}

follow_path_set_node( node )
{
	self set_goal_node( node );
	self notify( "follow_path_new_goal" );
}

follow_path_set_ent( ent )
{
	self set_goal_pos( ent.origin );
	self notify( "follow_path_new_goal" );	
}

follow_path( start_node, require_player_dist )
{
	self endon( "death" );
	self endon( "stop_path" );
	
	self notify( "follow_path" );
	self endon( "follow_path" );

	wait 0.1;

	node = start_node;
	
	getfunc = undefined;
	gotofunc = undefined;
	
	if( !isdefined( require_player_dist ) )
		require_player_dist = 300;
	
	//only nodes dont have classnames - ents do
	if( !isdefined( node.classname ) )
	{
		getfunc = ::follow_path_get_node;
		gotofunc = ::follow_path_set_node;
	}
	else
	{
		getfunc = ::follow_path_get_ent;
		gotofunc = ::follow_path_set_ent;
	}
	
	while( isdefined( node ) )	
	{
		if( isdefined( node.radius ) && node.radius != 0 )
			self.goalradius = node.radius;
		if( isdefined( node.height ) && node.height != 0 )
			self.goalheight = node.height;

		self [[ gotofunc ]]( node );
		
		original_goalradius = self.goalradius;
		//actually see if we're at our goal..._stealth might be tricking us
		while(1)
		{
			self waittill( "goal" );
			if( distance( node.origin, self.origin ) < ( original_goalradius + 10 ) )
				break;
		}
		
		node notify( "trigger", self );

		if( isdefined( node.script_requires_player ) )
		{
			while( isalive( level.player ) )
			{
				if( self wait_for_player( node, getfunc, require_player_dist ) )
					break;
				wait 0.05;
			}
		}

		if( !isdefined( node.target ) )
			break;

		node script_delay();

		node = [[ getfunc ]]( node.target, "targetname" );
		node = node[ randomint( node.size ) ];
	}

	self notify( "path_end_reached" );
}

wait_for_player( node, getfunc, dist )
{
	vec = undefined;
	//is the player ahead of us?
	vec = anglestoforward( self.angles );
	vec2 = vectornormalize( ( level.player.origin - self.origin ) );
	
	if( isdefined( node.target ) )
	{
		temp = [[ getfunc ]]( node.target, "targetname" );
		
		if( temp.size == 1 )
			vec = vectornormalize( temp[0].origin - node.origin );
		else
			vec = anglestoforward( node.angles );
	}
	else
		vec = anglestoforward( node.angles );
		
	//i just created a vector which is in the direction i want to
	//go, lets see if the player is closer to our goal than we are				
	if( vectordot(vec, vec2) > 0 )
		return true;
	
	//ok so that just checked if he was a mile away but more towards the target
	//than us...but we dont want him to be right on top of us before we start moving
	//so lets also do a distance check to see if he's close behind
	
	if( distance( level.player.origin , self.origin ) < dist )
		return true;
	
	return false;
}

crawl_path( start_node, require_player_dist )
{
	self endon( "death" );
		
	node = start_node;
	
	if( !isdefined( require_player_dist ) )
		require_player_dist = 300;
		
	while( isdefined( node ) )	
	{
		radius = 48;
		if( isdefined( node.radius ) && node.radius != 0 )
			radius = node.radius;
				
		if( node == start_node )
		{
			self setgoalpos( node.origin );
			self.goalradius = 16;
			self waittill( "goal" );	
			
			self allowedstances( "prone" );
			
			goal = getent( node.target, "targetname" );
			vec = goal.origin - self.origin;
			angles =  vectortoangles( vec );
			self.ref_node.origin = self.origin;
			self.ref_node.angles = ( 0, angles[ 1 ], 0 );
			
			self.ref_node anim_generic( self, "stand2prone" );
			self.crawl_ref_node = goal;
			self thread crawl_anim();
		}
		else
		{
			while( distance( self.origin, node.origin ) > radius )
				wait .05;	
		}
						
		node notify( "trigger", self );

		if( !isdefined( node.target ) )
			break;
			
		node = getent( node.target, "targetname" );
		self.crawl_ref_node = node;
	}
		
	self notify( "stop_crawl_anim" );
	self notify( "stop_animmode" );
	self.ref_node notify( "stop_animmode" );
	self stopanimscripted();
	self notify( "path_end_reached" );
	
	self orientMode( "face angle", node.angles[1] + 30 );  
}

crawl_anim()
{
	self notify( "crawl_anim" );
	self endon( "crawl_anim" );
	self endon( "stop_crawl_anim" );
	
	self thread crawl_anim_stop();
	
	anime = "crawl_loop";
	
	while( 1 )
	{
		node = self.crawl_ref_node;
		vec = node.origin - self.origin;
		angles =  vectortoangles( vec );
		self.ref_node.origin = self.origin;
		self.ref_node.angles = ( 0, angles[ 1 ], 0 );
		//self orientMode( "face angle", angles[1] ); 
		//self anim_generic_custom_animmode( self, "gravity", anime ); 
		self.ref_node anim_generic( self, anime ); 	
	}
}

crawl_anim_stop()
{
	self endon( "crawl_anim" );
	
	self waittill( "stop_crawl_anim" );
	self setgoalpos( self.origin );
}

node_have_delay()
{
	if( !isdefined( self.target ) )
		return true;
	if( isdefined( self.script_delay ) && self.script_delay > 0 )
		return true;
	if( isdefined( self.script_delay_max ) && self.script_delay_max > 0 )
		return true;
	return false;
}

disablearrivals_delayed()
{
	self endon( "death" );
	self endon( "goal" );
	wait 0.5;
	self.disableArrivals = true;
}

delete_on_unloaded()
{
	// todo: see it there is a way to get away from the wait .5;
	self endon( "death" );
	self waittill( "jumpedout" );
	wait .5;
	self delete();
}

fly_path( path_struct )
{
	self notify( "stop_path" );
	self endon( "stop_path" );
	self endon( "death" );

	if( !isdefined( path_struct ) )
		path_struct = getstruct( self.target, "targetname" );

	self setNearGoalNotifyDist( 512 );

	if( !isdefined( path_struct.speed ) )
		self fly_path_set_speed( 30, true );

	while( true )
	{
		self fly_to( path_struct );

		if( !isdefined( path_struct.target ) )
			break;
		path_struct = getstruct( path_struct.target, "targetname" );
	}
}

fly_to( path_struct )
{
	self fly_path_set_speed( path_struct.speed );

	if( isdefined( path_struct.radius ) )
		self setNearGoalNotifyDist( path_struct.radius );
	else
		self setNearGoalNotifyDist( 512 );
		
	stop = false;
	if( isdefined( path_struct.script_delay ) || isdefined( path_struct.script_delay_min ) )
		stop = true;

	if( isdefined( path_struct.script_unload ) )
	{
		stop = true;
		path_struct = self unload_struct_adjustment( path_struct );
		self thread unload_helicopter();
	}

	if( isdefined( path_struct.angles ) )
	{
		if( stop )
			self setgoalyaw( path_struct.angles[ 1 ] );
		else
			self settargetyaw( path_struct.angles[ 1 ] );
	}
	else
		self cleartargetyaw();

	self setvehgoalpos( path_struct.origin +( 0, 0, self.originheightoffset ), stop );

	self waittill_any( "near_goal", "goal" );
	path_struct notify( "trigger", self );

	flag_waitopen( "helicopter_unloading" );	// wait if helicopter is unloading.

	if( stop )
		path_struct script_delay();

	if( isdefined( path_struct.script_noteworthy ) && path_struct.script_noteworthy == "delete_helicopter" ) 
		self delete();
}

fly_path_set_speed( new_speed, immediate )
{
	if( isdefined( new_speed ) )
	{
		accel = 20;
		if( accel < new_speed / 2.5 )
			accel =( new_speed / 2.5 );

		decel = accel;
		current_speed = self getspeedmph();
		if( current_speed > accel )
			decel = current_speed;

		if( isdefined( immediate ) )
			self setspeedimmediate( new_speed, accel, decel );
		else
			self setSpeed( new_speed, accel, decel );
	}
}

unload_helicopter()
{
		/*
		maps\_vehicle::waittill_stable();
		sethoverparams( 128, 10, 3 );
		*/

		self endon( "stop_path" );

		flag_set( "helicopter_unloading" );

		self sethoverparams( 0, 0, 0 );

		self waittill( "goal" );
		self notify( "unload", "both" );
		wait 12;	// todo: the time it takes to unload must exist somewhere.
		flag_clear( "helicopter_unloading" );

		self sethoverparams( 128, 10, 3 );
}

unload_struct_adjustment( path_struct )
{
	ground = physicstrace( path_struct.origin, path_struct.origin +( 0, 0, -10000 ) );
	path_struct.origin = ground +( 0, 0, self.fastropeoffset );
//	path_struct.origin = ground +( 0, 0, self.fastropeoffset + self.originheightoffset );
	return path_struct;
}

dialogprint( string, duration, delay )
{
	if( isdefined( delay ) && delay > 0 )
		wait delay;
	
	iprintln( string );
	
	if( isdefined( duration ) && duration > 0 )
		wait duration;
}

scripted_spawn2( value, key, stalingrad, spawner )
{
	if ( !isdefined( spawner ) )
		spawner = getent( value, key );

	assertEx( isdefined( spawner ), "Spawner with script_noteworthy " + value + " does not exist." );
	
	if ( isdefined( stalingrad ) )
		ai = spawner stalingradSpawn();
	else
		ai = spawner dospawn();
	spawn_failed( ai );
	assert( isDefined( ai ) );
	return ai;
}

scripted_array_spawn( value, key, stalingrad )
{
	spawner = getentarray( value, key );
	ai = [];

	for ( i=0; i<spawner.size; i++ )
		ai[i] = scripted_spawn2( value, key, stalingrad, spawner[i] );
	return ai;
}

vehicle_turret_think()
{
	self endon ("death");
	self endon ( "c4_detonation" );
	self thread maps\_vehicle::mgoff();
	self.turretFiring = false;
	eTarget = undefined;
	aExcluders = [];

	aExcluders[0] = level.price;

	currentTargetLoc = undefined;
	
	//if (getdvar("debug_bmp") == "1")
		//self thread vehicle_debug();

	while (true)
	{
		wait (0.05);
		/*-----------------------
		GET A NEW TARGET UNLESS CURRENT ONE IS PLAYER
		-------------------------*/		
		if ( (isdefined(eTarget)) && (eTarget == level.player) )
		{
			sightTracePassed = false;
			sightTracePassed = sighttracepassed( self.origin, level.player.origin + ( 0, 0, 150 ), false, self );
			if ( !sightTracePassed )
			{
				//self clearTurretTarget();
				eTarget = self vehicle_get_target(aExcluders);
			}
				
		}
		else
			eTarget = self vehicle_get_target(aExcluders);

		/*-----------------------
		ROTATE TURRET TO CURRENT TARGET
		-------------------------*/		
		if ( (isdefined(eTarget)) && (isalive(eTarget)) )
		{
			targetLoc = eTarget.origin + (0, 0, 32);
			self setTurretTargetVec(targetLoc);
			
			if (getdvar("debug_bmp") == "1")
				thread draw_line_until_notify(self.origin + (0, 0, 32), targetLoc, 1, 0, 0, self, "stop_drawing_line");
			
			fRand = ( randomfloatrange(1, 1.5));
			self waittill_notify_or_timeout( "turret_rotate_stopped", fRand );

			/*-----------------------
			FIRE MAIN CANNON OR MG
			-------------------------*/
			if ( (isdefined(eTarget)) && (isalive(eTarget)) )
			{
				if ( distancesquared(eTarget.origin,self.origin) <= level.bmpMGrangeSquared)
				{
					if (!self.mgturret[0] isfiringturret())
						self thread maps\_vehicle::mgon();
					
					wait(.25);
					if (!self.mgturret[0] isfiringturret())
					{
						self thread maps\_vehicle::mgoff();
						if (!self.turretFiring)
							self thread vehicle_fire_main_cannon();			
					}
	
				}
				else
				{
					self thread maps\_vehicle::mgoff();
					if (!self.turretFiring)
						self thread vehicle_fire_main_cannon();	
				}				
			}
		}
		
		//wait( randomfloatrange(2, 5));
	
		if (getdvar( "debug_bmp") == "1")
			self notify( "stop_drawing_line" );
	}
}

vehicle_get_target(aExcluders)
{
	eTarget = maps\_helicopter_globals::getEnemyTarget( level.bmpCannonRange, level.cosine[ "180" ], true, true, false, false,  aExcluders);
	return eTarget;
}

vehicle_fire_main_cannon()
{
	self endon ("death");
	self endon ( "c4_detonation" );
	//self notify ("firing_cannon");
	//self endon ("firing_cannon");
	
	iFireTime = weaponfiretime("bmp_turret");
	assert(isdefined(iFireTime));
	
	iBurstNumber = randomintrange(3, 8);
	
	self.turretFiring = true;
	i = 0;
	while (i < iBurstNumber)
	{
		i++;
		wait(iFireTime);
		self fireWeapon();
	}
	self.turretFiring = false;
}

music_play( musicalias )
{
	// TODO: make current music fade over delay
	musicStop();	
	musicPlay( musicalias ); 
}

teleport_actor( node )
{
	level.player setorigin( level.player.origin + ( 0, 0, -34341 ) );
	self teleport( node.origin, node.angles );
	self setgoalpos( node.origin );	
}

teleport_player( name )
{
	if( !isdefined( name ) )
		name = level.start_point;
	
	nodes = getentarray("start_point","targetname");
	
	for(i=0; i<nodes.size; i++)
	{
		if( nodes[i].script_noteworthy == name)
		{
			level.player setorigin( nodes[i].origin + (0,0,4) );
			level.player setplayerangles( nodes[i].angles );
			return;
		}
	}
}

clip_nosight_logic()
{
	self endon( "death" );
	
	flag_wait( self.script_flag );
	
	self thread clip_nosight_logic2();
	self setcandamage(true);
	
	self clip_nosight_wait();
	
	self delete();	
}

clip_nosight_wait()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	self waittill( "damage" );	
}

clip_nosight_logic2()
{
	self endon( "death" );	
	
	flag_wait_either( "_stealth_spotted", "_stealth_found_corpse" );
	
	self delete();
}

flashbang_from_corner( name, node, angle, magnitude )
{
	node thread anim_generic( self, name );
	
	self delayThread(3.5, ::flashbang_from_corner_nade, angle, magnitude );
	
	node waittill( name );
}

flashbang_from_corner_nade( angle, magnitude )
{
	oldGrenadeWeapon = self.grenadeWeapon;
	self.grenadeWeapon = "flash_grenade";
	self.grenadeAmmo++;
	
	start = self.origin + (30,25,30);
	vec = anglestoforward( angle );
	vec = vector_multiply( vec, magnitude );
	self magicgrenademanual( start, vec, 1.1 );
	
	self.grenadeWeapon = oldGrenadeWeapon;	
	self.grenadeAmmo = 0;
}

initDogs()
{
	dogs = getentarray("stealth_dogs", "targetname");
	array_thread( dogs, ::add_spawn_function, ::stealth_ai);
}

idle_anim_think()
{
	self endon("death");
	
	if( !isdefined( self.target ) )
		return;
	
	node = getent(self.target, "targetname");
	
	if( !isdefined( node.script_animation ) )
		return;
		
	anime = undefined;
	switch( node.script_animation )
	{
		case "coffee":
			anime = "coffee_"; 
			break;
		case "sleep":
			anime = "sleep_"; 
			break;
		case "phone":
			anime = "cellphone_";
			break;
		case "smoke":
			anime = "smoke_";
			break;
		case "lean_smoke":
			anime = "lean_smoke_";
			break;
		default:
			return;
	}
	
	self.allowdeath = true;
	
	node = getent(self.target, "targetname");
	self.ref_node = node;
	
	if( node.script_animation == "sleep" )
		node stealth_ai_idle_and_react( self, anime + "idle", anime + "react" );
	else
		node stealth_ai_reach_and_arrive_idle_and_react( self, anime + "reach", anime + "idle", anime + "react" );
}

dash_door_slow( mod )
{
	children = getentarray( self.targetname, "target" );
	for(i=0; i<children.size; i++)
		children[ i ] linkto( self );
		
	self.old_angles = self.angles;
	self rotateto( self.angles + (0, (70 * mod ),0), 2, .5, 0 );
	self connectpaths();
	self waittill( "rotatedone");	
}

dash_door_fast( mod )
{
	children = getentarray( self.targetname, "target" );
	for(i=0; i<children.size; i++)
		children[ i ] linkto( self );
		
	self rotateto( self.angles + (0,( 70 * mod ), 0), ( .3 * abs( mod ) ), ( .15 * abs( mod ) ), 0 );
	self connectpaths();
	self waittill( "rotatedone");
}

door_open_slow()
{
	self.old_angles = self.angles;
	self hunted_style_door_open();
}

door_open_kick()
{
	wait .6;

	self.old_angles = self.angles;
	self playsound ("wood_door_kick");
	self rotateto( self.angles + (0,130,0), .3, 0, .15 );
	self connectpaths();
	self waittill( "rotatedone");
}

door_close()
{
	if( !isdefined( self.old_angles ) )
		return;
	
	self rotateto( self.old_angles, .2);
}

church_lookout_stealth_behavior_alert_level_investigate( enemy )
{
	guy = get_living_ai( "church_smoker", "script_noteworthy" );

	pos = (-34245, -1550, 608);
	self setgoalpos( pos );
	self.goalradius = 4;
	
	self maps\_stealth_behavior::enemy_stop_current_behavior();	
	
	self thread maps\_stealth_behavior::enemy_announce_huh();	
	
	self church_lookout_goto_bestpos( enemy.origin );
	
	if( isdefined( guy ) && isalive( guy ) )
	{
	
		if( !isdefined( enemy._stealth.logic.spotted_list[ guy.ai_number ] ) )
			enemy._stealth.logic.spotted_list[ guy.ai_number ] = 1;
			
		self playsound("RU_0_reaction_casualty_generic");
		
		guy.favoriteenemy = enemy;
	
		guy endon("death");
		
		guy waittill( "enemy" );
	
		guy.favoriteenemy = undefined;
		
		guy waittill( "normal" );
	}
	else
		wait 3;
	
	self thread maps\_stealth_behavior::enemy_announce_hmph();
	self thread maps\_patrol::patrol();
}

church_lookout_goto_bestpos( pos )
{
	nodes = getentarray( "church_lookout_aware", "targetname" );
	nodes = get_array_of_closest( pos, nodes );
	
	self setgoalpos( nodes[0].origin );
	self.goalradius = 4;
	self waittill( "goal" );
}

church_lookout_stealth_behavior_alert_level_attack( enemy )
{
	self thread maps\_stealth_behavior::enemy_announce_huh();
	
	self church_lookout_goto_bestpos( enemy.origin );
	
	pos = ( -35040, -1632, 224 );
	self thread maps\_stealth_behavior::enemy_announce_spotted( pos );
}

church_lookout_stealth_behavior_saw_corpse()
{
	self thread maps\_stealth_behavior::enemy_announce_huh();
		
	if( isdefined( level.intro_last_patroller_corpse_name ) )
	{
		corpse = getent( level.intro_last_patroller_corpse_name, "script_noteworthy" );
		if( isdefined( corpse ) )
			level._stealth.logic.corpse.array = array_remove( level._stealth.logic.corpse.array, corpse );
	}
	
	corpse = self._stealth.logic.corpse.corpse_entity;
	
	self church_lookout_goto_bestpos( corpse.origin );
	
	wait 1;
		
	if( !ent_flag( "_stealth_found_corpse" ) )
		self ent_flag_set( "_stealth_found_corpse" );
	else
		self notify( "_stealth_found_corpse" );

	self thread maps\_stealth_logic::enemy_corpse_found( corpse );
}

church_lookout_stealth_behavior_found_corpse()
{
	flag_wait( "_stealth_found_corpse" );	
	self thread maps\_stealth_behavior::enemy_announce_corpse();
}

church_lookout_stealth_behavior_explosion( type )
{
	self endon("_stealth_enemy_alert_level_change");
	self endon("death");
	level endon("_stealth_spotted");
	
	origin = self._stealth.logic.event.awareness[ type ];
			
	self thread maps\_stealth_behavior::enemy_announce_wtf();
	
	self church_lookout_goto_bestpos( origin );
}

graveyard_hind_find_best_perimeter( resumepath )
{
	self endon( "death" );
	self notify( "graveyard_hind_find_best_perimeter" );
	self endon( "graveyard_hind_find_best_perimeter" );
	
	if( !isdefined( resumepath ) )
		resumepath = false;
	
	startold = undefined;
	startcurrent = undefined;
	
	self thread vehicle_detachfrompath();
	
	resumenode = self.currentnode;
	
	while( 1 )
	{
		starts = getstructarray( "graveyard_hind_circle_path", "targetname" );
		startcurrent = get_array_of_closest( level.player.origin, starts )[0];
		
		if( !isdefined( startold ) || startold != startcurrent )
		{
			if( resumepath )
			{
				self graveyard_hind_strafe_path( startcurrent, resumepath );
				break;	
			}
			else	
				self thread graveyard_hind_strafe_path( startcurrent, resumepath, level.player );
		}	
		
		startold = startcurrent;
		
		wait .05;
	}	
	
	self thread vehicle_detachfrompath();
	self.currentnode = resumenode;
	self setspeed( 70, 30, 30 );
	self thread vehicle_resumepath();
}

graveyard_hind_strafe_path( startnode, resumepath, ent )
{
	self endon( "death" );
	self notify( "graveyard_hind_strafe_path" );
	self endon( "graveyard_hind_strafe_path" );
	
	if( isdefined( ent ) )
		self setLookAtEnt( ent );
	
	nodearray = [];
	node = getstruct( startnode.target, "targetname" );
	
	while( isdefined( node ) )
	{
		nodearray[ nodearray.size ] = node;
		
		if( isdefined( node.target ) )
			node = getstruct( node.target, "targetname" );
		else
			node = undefined;
	}
	
	startnode = get_array_of_closest( self.origin, nodearray )[0];
	
	self setspeed( 30, 20, 20 );
	self thread vehicle_dynamicpath( startnode );
	
	if( !resumepath )
		return;
		
	//this is when it starts the loop
	startnode waittill( "trigger" );
	//this is when it ends the loop
	startnode waittill( "trigger" );	
}

graveyard_hind_stinger_logic()
{
	self endon( "death" );
	ent = spawn( "script_model", self.origin );
	ent linkto( self, "tag_origin", (0,0,0), (0,0,0) );
	
	target_set( ent, ( 0,0,-80 ) );
	target_setJavelinOnly( ent, true );

	level.player waittill( "stinger_fired" );
	flag_set( "_stealth_spotted" );

	self graveyard_hind_stinger_reaction_wait( 2 );

//	level.helicopter thread evasion_path( "evasion_pattern" );
//	wait 0.5;

	level thread graveyard_hind_stinger_flares_fire_burst( self, 8, 6, 5.0 );
	wait 0.5;
	
	ent unlink();
	vec = maps\_helicopter_globals::flares_get_vehicle_velocity( self );
	ent movegravity( vec, 8 );
	
	target_set( self, ( 0,0,-80 ) );
	target_setJavelinOnly( self, true );

	level.player waittill( "stinger_fired" );
	
	self graveyard_hind_stinger_reaction_wait( 3 );
	
	graveyard_hind_stinger_flares_fire_burst( self, 8, 1, 5.0 );
	
//	level.helicopter thread evasion_path( "evasion_pattern" );

}

graveyard_hind_stinger_reaction_wait( remainder )
{
	self endon( "death" );
	projectile_speed = 1100 ;
	dist = distance( level.player.origin, self.origin );
	travel_time = dist / projectile_speed - remainder;

	if ( travel_time > 0 )
		wait travel_time;
}

graveyard_hind_stinger_flares_fire_burst( vehicle, fxCount, flareCount, flareTime )
{
	vehicle endon( "death" );
	
	flag_set( "graveyard_hind_flare" );
	
	assert( isdefined( level.flare_fx[vehicle.vehicletype] ) );
	
	assert( fxCount >= flareCount );
	
	for ( i = 0 ; i < fxCount ; i++ )
	{
		playfx ( level.flare_fx[vehicle.vehicletype], vehicle getTagOrigin( "tag_light_belly" ) );
		
		if ( vehicle == level.playervehicle )
		{
			level.stats["flares_used"]++;
			level.player playLocalSound( "weap_flares_fire" );
		}		
		wait 0.25;
	}
	
	delaythread(3, ::flag_clear, "graveyard_hind_flare" );
}

graveyard_church_breakable()
{
	self setcandamage( true );
	origin = self getorigin();
	
	while( 1 )
	{
		self waittill( "damage", damage, other, direction_vec, P, type );
		
		if( other.classname != "script_vehicle" )
			continue;
		
		if( type == "MOD_PROJECTILE" )
			break;
	}
	
	objs = getentarray( "field_church_tower_model", "targetname" );
	objs = get_array_of_closest( origin, objs, undefined, undefined, 512 );
	for(i=0; i<objs.size; i++)
		objs[i] delete();
	
	if( distance( origin, level.player.origin ) < 512 )
	{
		level.player setstance( "crouch" );
		level.player setvelocity( (0,1,0) );
		level.player shellshock( "radiation_high", 5 );
	}
		
	playfx ( level._effect["church_roof_exp"], origin, (0,1,0), (0,0,-1) );
	
	
	self delete();
		
	
	if( flag( "graveyard_church_ladder" ) )
		return;
	level endon( "graveyard_church_ladder" );
	
	breakladder = false;
	ladders = getentarray( "churchladder" , "script_noteworthy" );
	
	for( i=0; i<ladders.size; i++)
	{
		if( distance( origin, ladders[i].origin ) > 1024 ) 
			continue;
		breakladder = true;
		break;
	}
	
	if( !breakladder )
		return;
		
	for( i=0; i<ladders.size; i++)
		ladders[i] delete();//physicslaunch( ladders[i].origin, (10,20,500) );
	
	flag_set( "graveyard_church_ladder" );
}

chopper_ai_mode( eTarget )
{
	self endon( "death" );
	level endon( "air_support_over" );
	for(;;)
	{
		flag_waitopen( "graveyard_hind_flare" );
		wait randomfloatrange( 0.2, 1.0 );
		
		self setVehWeapon( "hind_turret" );
		
		vec1 = anglestoforward( self.angles );
		vec2 = vectornormalize( eTarget.origin - self.origin );
		if( vectordot( vec1, vec2 ) < .25 )
			continue;
		
		self maps\_helicopter_globals::shootEnemyTarget_Bullets( eTarget );
	}
}

chopper_ai_mode_missiles( eTarget )
{
	self endon( "death" );
	level endon( "air_support_over" );
	
	target = spawn ("script_origin", eTarget.origin );
	trig = getent( "graveyard_inside_church_trig", "targetname" );
	
	for(;;)
	{	
		flag_waitopen( "graveyard_hind_flare" );
		wait randomfloatrange( 0.5, 4.0 );
		
		vec1 = anglestoforward( self.angles );
		vec2 = vectornormalize( eTarget.origin - self.origin );
		if( vectordot( vec1, vec2 ) < .85 )
			continue;
			
		iShots = randomintrange( 4, 10 );
				
		trace = bullettrace(self.origin + (0,0,-150), eTarget.origin, true, level.price );
				
		if( !isdefined( trace[ "entity" ] ) || trace[ "entity" ] != level.player )
		{
			//can't see the player
			roof = getentarray( "church_breakable", "targetname" );
			
			//is there a roof?
			if( isdefined( roof ) && roof.size && eTarget istouching( trig ) )
			{
				roof = get_array_of_closest( eTarget.origin, roof );
				target.origin = roof[0] getorigin();	
			}
			else
				target.origin = eTarget.origin + ( 0,0,128 );		
		}
		else
			target.origin = eTarget.origin;
					
		self maps\_helicopter_globals::fire_missile( "ffar_hind", iShots, target );
	}
}

clean_previous_ai( _flag, name, type )
{
	flag_wait( _flag );
	
	ai = undefined;
	
	if( !isdefined( name ) )
		ai = getaispeciesarray( "axis", "all" );
	else
		ai = get_living_ai_array( name, type );
		
	for( i=0; i<ai.size; i++ )
		ai[i] delete();
}

field_bmp_quake()
{
	self endon( "death" );
	
	time = .1;
	while( 1 )
	{
		Earthquake( .15, time, self.origin, 512 );
		wait time;
	}
}

get_vehicle( name, type )
{
	array = getentarray( name, type );
	vehicle = undefined;
	
	for(i=0; i< array.size; i++)
	{
		if( array[i].classname != "script_vehicle" )
			continue;
		
		vehicle = array[i];
		break;
	}
	return vehicle;
}

fake_radiation()
{	
	while( 1 )
	{
		self waittill( "trigger" );
			
		while( level.player istouching( self ) )
		{
			if( level.radiation_ratepercent < 5 )
				level.radiation_ratepercent = 5;
			else
				level.radiation_ratepercent = 0;
			
			wait .1;
		}
		
		level.radiation_ratepercent = 0;
	}
}

pond_handle_backup()
{
	flag_wait( "pond_patrol_spawned" );
	
	pond_handle_backup_wait();
	
	wait 2;
	
	doorright = getent( "pond_door_right", "script_noteworthy" );
	model = getent( doorright.targetname, "target" );
	model linkto( doorright );
	doorleft = getent( "pond_door_left", "script_noteworthy" );	
	model = getent( doorleft.targetname, "target" );
	model linkto( doorleft );
	
	doorright rotateyaw( 130, .3, 0, .15 );
	doorright connectpaths();
	doorleft rotateyaw( -130, .4, 0, .2 );
	doorleft connectpaths();
}

pond_handle_backup_wait()
{
	level endon( "_stealth_spotted" );
	
	type = undefined;
	while(1)
	{
		level waittill( "event_awareness", type );
		
		if( type == "explode" )
			break;
		if( type == "heard_scream" )
			break;
		if( type == "heard_corpse" )
			break;
	}
}

pond_inposition_takeshot( node, msg )
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "pond_enemies_dead" ) )
		return;
	level endon( "pond_enemies_dead" );
		
	self endon( "follow_path_new_goal" );
	
	self ent_flag_clear( "_stealth_stance_handler" );
	
	self.goalradius = 4;
	self waittill( "goal" );
	
	wait .25;
	
	if( !isdefined( msg ) )
		msg = "scoutsniper_mcm_inposition";
		
	self enable_cqbwalk();
		
	ai = get_living_ai_array( "pond_throwers", "script_noteworthy" );
	self cqb_aim( ai[ 0 ] );
	
	level thread function_stack(::radio_dialogue, msg );
			
	self ent_flag_set( "pond_in_position" );
}

field_bmp_make_followme()
{
	vec = anglestoforward( self.angles );
	pos = self.origin + vector_multiply( vec, -128 );
	spot = spawn( "script_origin", pos );
	
	spot linkto( self );
	self.followme = spot;
}

field_creep_player_calc_movement()
{
	score_move = length( self getVelocity() );
	stance = self._stealth.logic.stance;
	check = (stance == "prone" && score_move == 0 );
	return check; 
}

field_handle_special_nodes()
{
	array_thread( getentarray( "field_jog", "script_noteworthy" ), ::field_handle_special_nodes_jog );	
}

field_handle_special_nodes_jog()
{
	while( 1 )
	{
		self waittill( "trigger", other );
		
		if( isdefined( other.script_animation ) && other.script_animation == "jog" )
		{
			if( !flag( "_stealth_spotted" ) )
			{
				other set_generic_run_anim( "patrol_jog" );	
				other notify( "patrol_walk_twitch_loop" );
				wait 2;
				if( !flag( "_stealth_spotted" ) )
				{
					other set_generic_run_anim( "patrol_walk" );	
					other thread maps\_patrol::patrol_walk_twitch_loop();
				}
			}
		}
	}
}

field_enemy_walk_behind_bmp()
{
	self endon("death");
	level endon( "_stealth_spotted" );
	
	self set_generic_run_anim( "patrol_walk" );
	self.disableexits = true;
	self.disablearrivals = true;
	
	ent = getent( self.target, "targetname" );
	self setgoalentity( ent.followme );
	
	while( 1 )
	{
		wait .5;
		
		if( distance( self.origin, ent.followme.origin ) > 60 )	
			continue;
		
		self anim_generic_custom_animmode( self, "gravity", "patrol_stop" );
		self setgoalpos( self.origin );
				
		self anim_generic_custom_animmode( self, "gravity", "patrol_start" ); 
		self setgoalentity( ent.followme );
	}
}	

field_enemy_death()
{
	while( isalive( self ) )
	{
		self waittill( "damage", ammount, other );
		if( other == level.player ) 
		{
			flag_set( "_stealth_spotted" );
			break;
		}
	}
}

field_enemy_alert_level_1( enemy )
{
	self endon("_stealth_enemy_alert_level_change");
	level endon("_stealth_spotted");
	self endon( "death" );
	
	self thread maps\_stealth_behavior::enemy_announce_huh();
		
	wait 3.5;
	
	self ent_flag_clear( "_stealth_enemy_alert_level_action" );
	self flag_waitopen( "_stealth_found_corpse" );
	
	if( !isdefined( self._stealth.logic.corpse.corpse_entity ) )
		self thread maps\_stealth_behavior::enemy_announce_hmph();	
}

field_enemy_patrol_thread()
{
	self endon( "stop_patrol_thread" );
	self endon( "death" );
	self endon( "attack" );
	
	while( 1 )
	{
		self waittill( "enemy" );
		
		waittillframeend;
		//getting an enemy automatically kills patrol script
	
		if( !issubstr( self.target, "bmp" ) && self ent_flag( "field_walk" ) )
		{
			self.target = self.last_patrol_goal.targetname;
			self thread maps\_patrol::patrol();
		}
	}
}

field_enemy_alert_level_2( enemy )
{
	self endon("_stealth_enemy_alert_level_change");
	level endon("_stealth_spotted");
	self endon( "death" );
	self notify( "stop_patrol_thread" );
	
	self thread maps\_stealth_behavior::enemy_announce_huh();
	
	self clear_run_anim();
	self setgoalpos( enemy.origin );
}

cargo_enemy_attack( enemy )
{	
	self endon ( "death" );
	self endon( "pain_death" );
	
	self thread maps\_stealth_behavior::enemy_announce_spotted( self.origin );
			
	//might have to link this into enemy_animation_attack() at some point
	if ( !isdefined( self.script_stealth_dontseek ) )
		self setgoalpos( enemy.origin );
		
	self.goalradius = 512;
}

cargo_attack2v2( defender )
{
	self thread cargo_attack2v2_cleanup( defender );
	
	defender endon( "death" );
	defender endon( "_stealth_stop_stealth_logic" );
	
	defender waittill( "stealth_enemy_endon_alert" );	
	self.ignoreall = false;
	self.favoriteenemy = defender;	
}

cargo_attack2v2_cleanup( defender )
{
	defender waittill( "dead" );
	self.ignoreall = true;
	self.favoriteenemy = undefined;
}

cargo_sleeper_wait_wakeup()
{
	self endon( "death" );
	
	self thread stealth_enemy_endon_alert();
	self endon( "stealth_enemy_endon_alert" );
	
	dist = 32;
	distsqrd = dist * dist;
	
	while( distancesquared( self.origin, level.player.origin ) > distsqrd )
		wait .1;
}

cargo_handle_patroller()
{
	array_thread( getentarray( "cargo_patrol_flag_set", "script_noteworthy" ), ::cargo_handle_patroller_flag, true );
	array_thread( getentarray( "cargo_patrol_flag_clear", "script_noteworthy" ), ::cargo_handle_patroller_flag, false );
	trig = getent( "cargo_patrol_kill_flag", "script_noteworthy" );
	trig thread cargo_handle_patroller_kill_trig();
}

cargo_handle_patroller_flag( set )
{
	level endon( "dash" );
	
	while( 1 )
	{
		self waittill("trigger");
		if( set )
			flag_set( self.script_flag );
		else
			flag_clear( self.script_flag );
	}
}

cargo_handle_patroller_kill_trig()
{
	self trigger_off();	
	flag_wait( "cargo_price_ready_to_kill_patroller" );
	self trigger_on();	
	
	while( 1 )
	{
		self waittill( "trigger", other );
		
		while( isalive( other ) && other istouching( self ) )
			wait .1;
		
		wait .25;
		
		flag_clear( "cargo_patrol_kill" );
	}
}

cargo_insane_handle_use()
{
	self endon( "trigger" );
	self endon( "death" );
	
	while(1)
	{
		while( level.player._stealth.logic.stance != "prone" )
			wait .05; 
			
		self trigger_off();
		
		while( level.player._stealth.logic.stance == "prone" )
			wait .05;
		
		self trigger_on();
	}
}

cargo_slipby_part1( dist )
{	
	//we came here because the player is either with us or ahead of us
	
	//is he with us?
	if( distance( level.player.origin, self.origin ) <= dist && !flag( "cargo_patrol_dead" )  )
	{	
		//lets tell him to wait
		level function_stack(::radio_dialogue, "scoutsniper_mcm_holdup" );
		
		//is the patrol dead after our dialogue is done?
		if( flag( "cargo_patrol_dead" ) )
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo2" );	
		
		//is he too close for us to move?
		else
		if( flag( "cargo_patrol_danger" ) )
		{
			thread dialogprint( "Price - patrol coming this way, stay back", 3 );
			cargo_patrol_waitdead_or_flag_open( "cargo_patrol_danger" );
			if( !flag( "cargo_patrol_dead" ) )
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_waithere2" );
			else 
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo2" );		
		}
		//not too close...so we can go
		else
		{
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_waithere2" );
		}		
	}
	//then tell him to follow us
	else
	{
		//but we should still be smart and wait for the patroller if he's too close
		cargo_patrol_waitdead_or_flag_open( "cargo_patrol_danger" );
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_followme2" );
	}
}
cargo_slipby_part2( dist )
{
	//we came here because the player is either with us or ahead of us
	flag_set( "cargo_price_ready_to_kill_patroller" );
	
	wait .1;//we do this to give the game a chance to set the flag if the patrol is in the container	
	
	//is he dead?
	if( !flag( "cargo_patrol_dead" ) )
	{
		//ok he's not dead...where is he?
		
		//if this is true - he's either coming into the danger zone or just into the container
		if( !flag( "cargo_patrol_away"  ) && !flag( "cargo_patrol_danger" ) )
		{
			//check the container - if it's empty then he must be coming into the danger zone
			if( !flag( "cargo_patrol_kill" ) )
			{
				if( distance( level.player.origin, self.origin ) <= dist )
					thread dialogprint( "Price - we should wait a bit, see if the patroller makes another pass.", 3 );
			}		
			//wait for him to enter the danger zone, go far away, enter the container, or die
			flag_wait_any( "cargo_patrol_away", "cargo_patrol_danger", "cargo_patrol_dead", "cargo_patrol_kill" );
		}
			
		//danger zone?
		if( flag( "cargo_patrol_danger" ) && !flag( "cargo_patrol_dead" ) )
		{
			//is the player near for dialogue?	
			if( distance( level.player.origin, self.origin ) <= dist )
				thread dialogprint( "Price - patrol coming this way , stay back", 3 );
			//wait for him to leave
			cargo_patrol_waitdead_or_flag_open( "cargo_patrol_danger" );
		}		
		//container?
		if( flag( "cargo_patrol_kill" ) && !flag( "cargo_patrol_dead" ) )
		{
			//wait for him to leave or die
			cargo_slipby_kill_patrol();
		}		
	}
	
	//ok so at this point - he's either dead, or coming out of the container or far away
	//if the player is near do this
	if( distance( level.player.origin, self.origin ) <= dist )
	{	
		//whether dead or just gone - the forward area is clear and we're good to go
		level function_stack(::radio_dialogue, "scoutsniper_mcm_forwardclear" );	
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_go" );
		self.ref_node thread anim_generic( self, "moveout_cornerR" );
		self.ref_node waittill( "moveout_cornerR" );
	}
	//otherwise just let him know where we are
	else
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_onme" );
}

cargo_slipby_part3( dist )
{
	if( distance( level.player.origin, self.origin ) <= dist )
	{	
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_shhh" );
		self.ref_node thread anim_generic( self, "stop_cqb" );
		self.ref_node waittill( "stop_cqb" );
		
		if( !flag( "cargo_patrol_away" ) && !flag( "cargo_patrol_dead" ) )
		{
			thread dialogprint( "Price - patrol coming this way, stay back", 3 );
			
			flag_wait_any( "cargo_patrol_dead", "cargo_patrol_away", "cargo_patrol_kill" );
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveup" );	
		}
			
		else
		{
			self.ref_node thread anim_generic( self, "moveup_cqb" );
			level function_stack(::radio_dialogue, "scoutsniper_mcm_stayhidden" );
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveup" );	
		}
	}	
	else
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo" );
}

cargo_slipby_kill_patrol()
{
	if( flag( "cargo_patrol_kill" ) )
	{
		self.ignoreall = false;
		self.favoriteenemy = get_living_ai( "cargo_patrol", "script_noteworthy" );//its ok if we set him to undefined
		cargo_patrol_waitdead_or_flag_open( "cargo_patrol_kill" );
		self.ignoreall = true;
		self.favoriteenemy = undefined;
		return true;
	}	
	return false;
}

cargo_patrol_waitdead_or_flag_set( _flag )
{
	if( flag( "cargo_patrol_dead" ) )
		return;
	level endon( "cargo_patrol_dead" );
	
	flag_wait( _flag );
}	

cargo_patrol_waitdead_or_flag_open( _flag )
{
	if( flag( "cargo_patrol_dead" ) )
		return;
	level endon( "cargo_patrol_dead" );
	
	flag_waitopen( _flag );
}

dash_ai()
{
	self endon( "death" );
	self.ignoreall = true;
	
	flag_wait( "dash_start" );	
	
	self.ignoreall = false;
	if( !isdefined( self.script_moveoverride ) )
		return;
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	self endon( "death" );
	
	self waittill( "jumpedout" );
	
	ent = getent( self.target, "targetname" );
	
	if( isdefined( ent.target ) )
		self thread maps\_patrol::patrol();	
	else
		self thread dash_idler();
}

dash_intro_runner()
{
	self endon( "death" );
	self thread dash_intro_common();	
}

dash_intro_patrol()
{
	self endon( "death" );
	self thread dash_intro_common();
	
	self.disableexits = true;
	self set_generic_run_anim( "patrol_walk", true );
}

dash_intro_common()
{
	self endon( "death" );
//	self.ignoreall = true;
	self.fixednode = false;
	self.goalradius = 4;
	
	flag_wait( "dash_start" );
	
	ent = getent( self.target, "targetname" );
	
	self thread follow_path( ent );
	self thread deleteOntruegoal();
}

dash_idler()
{
	self.disableexits = true;
	self set_generic_run_anim( "patrol_walk", true );
	self.fixednode = false;
	self.goalradius = 64;	
	
	ent = getent( self.target, "targetname" );
	
	self thread follow_path( ent );
	
	node = getent( self.target, "targetname" );
	
	while( 1 )
	{		
		self set_goal_pos( node.origin );
		self waitOntruegoal( node );
		
		if( !isdefined( node.target ) )
			break;
						
		node = getent( node.target, "targetname" );
	}
	
	self.target = node.targetname;	
	self thread idle_anim_think();		
}

dash_fake_easy_mode()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
		
	if( flag( "dash_sniper" ) )
		return;
	level endon( "dash_sniper" );
	
	level.player endon( "death" );
	
	move = [];
	move[ "stand" ] = 0;
	move[ "crouch" ] = 0;
	move[ "prone" ] = 2;
	
	hidden = [];
	hidden[ "prone" ]	= 70;
	hidden[ "crouch" ]	= 400;
	hidden[ "stand" ]	= 600;
	
	alert = [];
	alert[ "prone" ]	= 90;
	alert[ "crouch" ]	= 600;
	alert[ "stand" ]	= 900;
	
	dist = 160;
	distsqrd = dist * dist;
	
	while( isalive( level.player ) )
	{
		level.player stealth_friendly_movespeed_scale_set( move, move );
		stealth_detect_ranges_set( hidden, alert );
		
		while( distancesquared( level.player.origin, level.price.origin ) <= distsqrd )
			wait .1;
		
		level.player stealth_friendly_movespeed_scale_default();
		stealth_detect_ranges_default();
		
		while( distancesquared( level.player.origin, level.price.origin ) > distsqrd )
			wait .1;
	}
}

dash_run_check()
{
	self waittill( "trigger" );
	flag_set( self.script_flag );
}

dash_handle_nosight_clip()
{
	trig = getent( "dash_intro_guy", "target" );
	trig waittill( "trigger" );
	
	flag_wait_either( "_stealth_spotted", "dash_start" );
	
	if( !flag( "_stealth_spotted" ) )
		flag_wait_or_timeout( "_stealth_spotted", 5 );
	
	clip = getent( "dash_nosight_clip", "targetname" );
	clip delete();	
}

dash_crawl_patrol()
{
	model = spawn( "script_model", (-21828, 3997, 249) );
	model.angles = (0.17992, 214.91, 1.77098);
	model setmodel( "vehicle_bm21_mobile_cover" );
	model hide();
	
	self linkto( model, "tag_detach" );
	self.allowdeath = true;
	
	anime = undefined;
	if( self.script_startingposition == 9 )
		anime = "bm21_unload2";
	else
		anime = "bm21_unload1";
		
	model anim_generic( self, anime, "tag_detach" );
	
	model delete();
}

dash_state_hidden()
{
	level endon("_stealth_detection_level_change");
	
	self.fovcosine = .86;//30 degrees to either side...60 cone. //DEFAULT is 60 degrees and 120 cone
	self.favoriteenemy = undefined;
	
	if( self._stealth.logic.dog )
		return;
		
	self.dieQuietly = true;
	if( !isdefined( self.old_baseAccuracy ) )
		self.old_baseAccuracy = self.baseaccuracy;
	if( !isdefined( self.old_Accuracy ) )
		self.old_Accuracy = self.accuracy;
		
	self.baseAccuracy 	= self.old_baseAccuracy;
	self.Accuracy 		= self.old_Accuracy;
	self.fixednode		= true;
	self clearenemy();
}

dash_sniper_death()
{
	flag_set( "dash_sniper" );
	
	self ent_flag_init( "death_anim" );
	
	self thread dash_sniper_anim();
	
	range = [];
	range[ "prone" ]	= 1300;
	range[ "crouch" ]	= 1600;
	range[ "stand" ]	= 1800;
	stealth_detect_ranges_set( range, range );
	move = [];
	move[ "stand" ] = 0;
	move[ "crouch" ] = 0;
	move[ "prone" ] = 2;
	level.player stealth_friendly_movespeed_scale_set( move, move );
	
	self.health = 10000;
	self waittill( "damage", ammount, other );
	self notify ( "_stealth_stop_stealth_logic" );
	
	node = getnode( self.target, "targetname" );
	
	if( self ent_flag( "death_anim" ) )
	{
		node thread anim_generic( self, "balcony_death" );
		delaythread( 1.2, ::rag_doll, self );
	}
	else
		self dodamage( self.health + 100, other.origin );
		
	flag_set( "dash_sniper_dead" );	
	
	if( !flag( "_stealth_spotted" ) )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_toppedhim" );
}

#using_animtree("generic_human");
dash_sniper_anim()
{
	self endon( "death" );
	
	self waittill( "goal" );
	self ent_flag_set( "death_anim" );
	
	self waittill( "_stealth_enemy_alert_level_change" );
	self ent_flag_clear( "death_anim" );
}

dash_sniper_alert( enemy )
{
	node = getnode( "dash_sniper_node", "targetname" );
	
	self thread maps\_stealth_behavior::enemy_announce_huh();
	
	self setgoalnode( node );
	self.goalradius = 4;
}

dash_sniper_attack( enemy )
{
	node = getnode( "dash_sniper_node", "targetname" );
	
	self thread maps\_stealth_behavior::enemy_announce_spotted( enemy.origin );
			
	self setgoalnode( node );
	self.goalradius = 4;
}

dash_handle_heli()
{
	node = getent( "dash_heli_land", "script_noteworthy" );
	node waittill( "trigger", heli );
	
	heli vehicle_land();
}

dash_stander()
{
	if( !isdefined( self.target ) )
		return;
		
	node = getent( self.target, "targetname" );
	wait .05;
	
	self.goalradius = 4;
	self orientMode( "face angle", node.angles[1] + 35); 
}

dash_handle_stealth_unsure()
{
	level endon( "town_no_turning_back" );
	
	level waittill("_stealth_enemy_alert_level_change");	
	
	flag_set( "dash_stealth_unsure" );
}

dogs_eater_eat()
{
	self endon( "death" );
	self endon( "dog_mode" );

	if( self.mode == "eat" )
		return;
	self.mode = "eat";
	
	self notify( "stop_loop" );
	self.ref_node notify( "stop_loop" );
	
	self.ref_node thread anim_generic_loop( self, "dog_idle" );
	wait randomfloatrange( 1, 3 );
	self.ref_node notify( "stop_loop" );
	
	self.ref_node rotateto( self.ref_angles, .25 );
		
	self.ref_node thread anim_generic_loop( self, "dog_eating" );
	self playloopsound( "anml_dog_eating_body" );
}

dogs_eater_growl()
{
	self endon( "death" );
	self notify( "dog_mode" );
	
	if( self.mode == "growl" )
		return;
	self.mode = "growl";
	
	self notify( "stop_loop" );
	self.ref_node notify( "stop_loop" );
	self stopanimscripted();
	
	self.ref_node thread anim_generic_loop( self, "dog_growling" );
	
	self stoploopsound();
	
	while( self.mode == "growl" )
	{
		vec = vectornormalize( level.player.origin - self.origin );
		angles = vectortoangles( vec );
		//self orientMode( "face angle", angles[1] );  
		
		self.ref_node rotateto( angles, .25 );
		
		wait .25;
	}
}

dogs_eater_bark()
{
	self endon( "death" );
	self notify( "dog_mode" );
	
	if( self.mode == "bark" )
		return;
	self.mode = "bark";
	
	self notify( "stop_loop" );
	self.ref_node notify( "stop_loop" );
	self stopanimscripted();
	
	self.ref_node thread anim_generic_loop( self, "dog_barking" );
	
	self stoploopsound();
	
	while( self.mode == "bark" )
	{
		vec = vectornormalize( level.player.origin - self.origin );
		angles = vectortoangles( vec );
		//self orientMode( "face angle", angles[1] );  
		
		self.ref_node rotateto( angles, .25 );
		
		wait .25;
	}
}

break_glass()
{
	wait randomfloat( .5 );
	
	origin = self getorigin();
	
	direction_vec = (0,-1,0);
				
	thread play_sound_in_space( "veh_glass_break_small" , origin);
	playfx( level._effect["glass_break"], origin, direction_vec);
	
	self delete();
}

center_heli_quake( msg )
{
	level endon( msg );
	
	while( 1 )
	{
		wait .1;
		earthquake(0.25, .1, self.origin, 2000);
	}
}









price_death()
{
	level endon( "missionfailed" );
		
	self waittill( "death", other );
	
	quote = undefined;
	
	if( isplayer( other ) )
		quote = "friendly fire will not be tolerated";
	else
		quote = "your actions got Cpt. Macmillian killed.";
			 
	setDvar("ui_deadquote", quote );
	thread maps\_utility::missionFailedWrapper();	
}

deleteOnPathEnd()
{
	self endon( "death" );
	self waittill( "reached_path_end" );
	self delete();
}

deleteOntruegoal()
{
	self endon( "death" );
		
	node = getnodearray( self.target, "targetname" );
	getfunc = undefined;
	
	if( node.size )
		getfunc = ::follow_path_get_node;
	else
	{
		node = getentarray( self.target, "targetname" );
		getfunc = ::follow_path_get_ent;	
	}	
	
	while( isdefined( node[0].target ) )
		node = [[ getfunc ]]( node[0].target, "targetname" );
		
	self waitOntruegoal( node[0] );	
	
	self delete();
}

waitOntruegoal( node )
{	
	radius = 16;
	if( isdefined( node.radius ) && node.radius != 0 )
		radius = node.radius;
	while( 1 )
	{
		self waittill( "goal" );
		if( distance( self.origin, node.origin ) < radius + 10 )
			break;
	}		
}

kill_self( guy )
{
	guy endon( "death" );
	
	wait .1;//for no death to be sent
	guy.allowdeath = true;
	guy dodamage( guy.health + 200, guy.origin );
}

melee_kill( guy )
{
	guy playsound( "melee_swing_large" );
	
	alias = "generic_pain_russian_" + guy.favoriteenemy._stealth.behavior.sndnum;
	
	guy.favoriteenemy playsound( alias );
	guy.favoriteenemy playsound( "melee_hit" );
	guy.favoriteenemy.allowdeath = false;
	guy.favoriteenemy notify( "anim_death" );
	
	thread kill_self( guy.favoriteenemy );
}

rag_doll_death( guy )
{		
	guy thread killed_by_player( true );	
}

killed_by_player( ragdoll )
{
	self endon( "anim_death" );
	
	self notify( "killed_by_player_func" );
	self endon( "killed_by_player_func" );
	
	while( 1 )
	{
		self waittill( "death", other );
		if( isdefined( other ) && other == level.player )
			break;
	}
	self notify( "killed_by_player" );	
	if( isdefined( ragdoll ) )
	{
		self animscripts\shared::DropAllAIWeapons();
		self startragdoll();	
	}
}

rag_doll( guy )
{
	guy playsound( "generic_pain_russian_1" );
	guy thread animscripts\shared::DropAllAIWeapons();
	guy.a.nodeath = true;
	guy dodamage( guy.health + 100, level.player.origin );
	guy startragdoll();	
}

empty_function( var )
{
	
}