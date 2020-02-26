#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\scoutsniper;
#include common_scripts\utility;

initRadiation()
{
	precacheString( &"SCOUTSNIPER_MRHR" );
	precacheShellShock( "radiation_low" );
	precacheShellShock( "radiation_med" );
	precacheShellShock( "radiation_high" );
	
	triggers = getentarray( "radiation", "targetname" );
	for( i = 0 ; i < triggers.size ; i++ )
		triggers[ i ] thread updateRadiationTriggers();
		
	thread updateRadiationDosage();
	thread updateRadiationDosimeter();
	thread updateRadiationShock();
	thread updateRadiationBlackOut();
	thread updateRadiationSound();
	thread updateRadiationRatePercent();
}

updateRadiationTriggers()
{
	for( ;; )
	{
		self waittill( "trigger" );

		level.radiation_triggers[ level.radiation_triggers.size ] = self;

		while( level.player isTouching( self ) )
			wait 0.05;

		level.radiation_triggers = array_remove( level.radiation_triggers, self );
	}
}

updateRadiationDosage()
{
	level.radiation_triggers = [];
	level.radiation_rate = 0;
	level.radiation_ratepercent = 0;
	level.radiation_total = 0;
	level.radiation_totalpercent = 0;
	
	update_frequency = 1;
	min_rate = 0;
	max_rate = 1100000 /( 60 * update_frequency );	// 60 REM/PH
	max_total = 200000;	// 200 REM
	
	range = max_rate - min_rate;
	
	for( ;; )
	{
		rates = [];
		for( i = 0 ; i < level.radiation_triggers.size ; i++ )
		{
			trigger = level.radiation_triggers[ i ];
			
			dist =( distance( level.player.origin , trigger.origin ) - 15 );
			rates[ i ] = max_rate -( max_rate / trigger.radius ) * dist;
		}
		
		rate = 0;
		for( i = 0 ; i < rates.size ; i++ )
			rate = rate + rates[ i ];

		if( rate < min_rate )
			rate = min_rate;

		if( rate > max_rate )
			rate = max_rate;
			
		level.radiation_rate = rate;
		level.radiation_ratepercent =( rate - min_rate ) / range * 100;

		if( level.radiation_ratepercent > 25 )
		{
			level.radiation_total += rate;
			level.radiation_totalpercent = level.radiation_total / max_total * 100;
		}
	
		wait update_frequency;
	}
}

updateRadiationShock()
{
	update_frequency = 1;
	
	for( ;; )
	{
		if( level.radiation_ratepercent >= 75 )
			level.player shellshock( "radiation_high", 5 );
		else if( level.radiation_ratepercent >= 50 )
			level.player shellshock( "radiation_med", 5 );
		else if( level.radiation_ratepercent > 25 )
			level.player shellshock( "radiation_low", 5 );

		wait update_frequency;
	}
}

updateRadiationSound()
{
	level.player thread playRadiationSound();
	
	for( ;; )
	{
		if( level.radiation_ratepercent >= 75 )
			level.player.radiation_sound = "item_geigercouner_level4";
		else if( level.radiation_ratepercent >= 50 )
			level.player.radiation_sound = "item_geigercouner_level3";
		else if( level.radiation_ratepercent >= 25 )
			level.player.radiation_sound = "item_geigercouner_level2";
		else if( level.radiation_ratepercent > 0 )
			level.player.radiation_sound = "item_geigercouner_level1";
		else
			level.player.radiation_sound = "none";

		wait 0.05;
	}
}

playRadiationSound()
{
	wait .05;
	
	orgin = spawn( "script_origin", ( 0, 0, 0 ) );
	orgin.origin = self.origin;
	orgin.angles = self.angles;
	orgin linkto( self );

	temp = self.radiation_sound;
	
	for( ;; )
	{
		if( temp != self.radiation_sound )
		{
			orgin stoploopsound();
			
			if( isdefined( self.radiation_sound ) && self.radiation_sound != "none" )
				orgin playloopsound( self.radiation_sound );
		}

		temp = self.radiation_sound;
		
		wait 0.05;
	}
}

updateRadiationRatePercent()
{
	update_frequency = 0.05;
	
	ratepercent = newHudElem();
	ratepercent.fontScale = 1.2;
	ratepercent.x = 676;
	ratepercent.y = 350;
	ratepercent.alignX = "right";
	ratepercent.label = "";
	
	for( ;; )
	{
		ratepercent.label = level.radiation_ratepercent;

		wait update_frequency;
	}
}

// set an update rate
// add variance so it is never stuck at a single value
// add background radiation
// add a radiation icon
updateRadiationDosimeter()
{
	min_rate = 0.028;
	max_rate = 100;
	update_frequency = 1;

	range = max_rate - min_rate;
	last_origin = level.player.origin;

	dosimeter = newHudElem();
	dosimeter.fontScale = 1.2;
	dosimeter.x = 676;
	dosimeter.y = 360;
	dosimeter.alignX = "right";
	dosimeter.label = &"SCOUTSNIPER_MRHR";

	dosimeter thread updateRadiationDosimeterColor();

	for( ;; )
	{
		if( level.radiation_rate <= min_rate )
		{
			variance = randomfloatrange( -0.001, 0.001 );
			dosimeter setValue( min_rate + variance );
			//println( "min_rate: ", min_rate, "variance: ", variance );
		}
		else if( level.radiation_rate > max_rate )
		{
			dosimeter setValue( max_rate );
			// TODO: Display a warning icon that the meter is beyond it's range
		}
		else
			dosimeter setValue( level.radiation_rate );

		wait update_frequency;
	}
}

updateRadiationDosimeterColor()
{
	update_frequency = 0.05;
	
	for( ;; )
	{
		colorvalue = 1;
		stepamount = 0.13;
		
		while( level.radiation_rate >= 100 )
		{
			if( colorvalue <= 0 || colorvalue >= 1 )
				stepamount = stepamount * -1;

			colorvalue = colorvalue + stepamount;

			if( colorvalue <= 0 )
				colorvalue = 0;

			if( colorvalue >= 1 )
				colorvalue = 1;

			self.color =( 1, colorvalue, colorvalue );
			//println( "colorvalue: ", colorvalue );
			
			wait update_frequency;
		}
		
		self.color =( 1, 1, 1 );
		
		wait update_frequency;
	}
}

// this is to indicate you are near your limit of radiation and are about to pass out
// as you near the last 33%( maybe 50% or 75% ) of your max dosage this will be visible while taking more radiation above a TBD threshold
// doing blurring at the same time as darkening
// should pulse, pulses should get longer closer to death and more frequent
// ramp up intensity and frequency
// smooth out pulsing, sin/cos?
// ramp up the low end of alpha somehow
// change pulse to pulse in/out, check some new values to determine what level to pulse out to
updateRadiationBlackOut()
{
	level.player endon( "death" );

	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;

	min_length = 1;
	max_length = 4;
	min_alpha = .25;
	max_alpha = 1;

	min_percent = 25;
	max_percent = 100;
	
	fraction = 0;

	for( ;; )
	{
		while( level.radiation_totalpercent > 25 && level.radiation_ratepercent > 25 )
		{
			percent_range = max_percent - min_percent;
			fraction =( level.radiation_totalpercent - min_percent ) / percent_range;

			if( fraction < 0 )
				fraction = 0;
			else if( fraction > 1 )
				fraction = 1;

			length_range = max_length - min_length;
			length = min_length +( length_range *( 1 - fraction ) );
			
			alpha_range = max_alpha - min_alpha;
			alpha = min_alpha +( alpha_range * fraction );

			blur = 6 * alpha;
			end_alpha = fraction * 0.5;
			end_blur = 6 * end_alpha;

			println( "fraction: ", fraction, " length: ", length, " alpha: ", alpha, " blur: ", blur );
			
			if( fraction == 1 )
				break;
			
			duration = length / 2;

			overlay fadeinBlackOut( duration, alpha, blur );
			overlay fadeoutBlackOut( duration, end_alpha, end_blur );

			// wait a variable amount based on level.radiation_totalpercent, this is the space in between pulses
			//wait 1;
			wait( fraction * 0.5 );
		}

		if( fraction == 1 )
			break;
		
		if( overlay.alpha != 0 )
			overlay fadeoutBlackOut( 1, 0, 0 );
		
		wait 0.05;
	}

	overlay fadeinBlackOut( 2, 1, 6 );

	level.player.specialDamage = true;
	level.player.specialDeath = true;
	level.player.health = 1;
	level.player dodamage( level.player.health + 1, ( 0, 0, 0 ) );
}

fadeinBlackOut( duration, alpha, blur )
{
	//target_blur = 6 * alpha;
	
	self fadeOverTime( duration );
	self.alpha = alpha;
	setblur( blur, duration );
	wait duration;
}

fadeoutBlackOut( duration, alpha, blur )
{
	//target_blur = 6 * alpha;
	
	self fadeOverTime( duration );
	self.alpha = alpha;
	setblur( blur, duration );
	wait duration;
}

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

initStealthDetection()
{
	level.prone_detect_range = 2;
	level.crouch_detect_range = 500;
	level.stand_detect_range = 1000;
}

// factor in player movement speed?
execAIStealthDetection()
{
	while( isalive( self ) )
	{
		if( isPlayer( self ) )
			stance = level.player getstance();	
		else
			stance = self.a.pose;
		
		if( stance == "prone" )
			self.maxVisibleDist = level.prone_detect_range;
		else if( stance == "crouch" )
			self.maxVisibleDist = level.crouch_detect_range;
		else if( stance == "stand" )
			self.maxVisibleDist = level.stand_detect_range;
		
		wait 0.05;
	}
}

// detects player only, friendly AI not supported
execVehicleStealthDetection()
{
	self thread maps\_vehicle::mgoff();
	
	while( isalive( level.player ) )
	{
		stance = level.player getstance();	
		dist = distance( self.origin, level.player.origin );
		
		if( (stance == "prone" && dist <= level.prone_detect_range) || (stance == "crouch" && dist <= level.crouch_detect_range) || (stance == "stand" && dist <= level.stand_detect_range) )
		{	
			self thread vehicle_turret_think();
			break;
		}
		
		wait 0.05;
	}
}

follow_path( start_node )
{
	self endon( "death" );
	self endon( "stop_path" );

	self.path_halt = false;

	node = start_node;
	while( isdefined( node ) )	
	{
		if( node.radius != 0 )
			self.goalradius = node.radius;
		if( isdefined( node.height ) && node.height != 0 )
			self.goalheight = node.height;

		self setgoalnode( node );

		if( node node_have_delay() )
			self.disableArrivals = false;
		else
			self disablearrivals_delayed();

		self waittill( "goal" );
		node notify( "trigger", self );

		if( isdefined( node.script_requires_player ) )
		{
			while( isalive( level.player ) )
			{
				if( distance( level.player.origin , self.origin ) < 256 )
					break;
				
				wait 0.05;
			}
		}

		if( !isdefined( node.target ) )
			return;

		node script_delay();
		//if( self.path_halt )
		//	self waittill( "path_resume" );

		node = getnodearray( node.target, "targetname" );
		node = node[ randomint( node.size ) ];
	}

	self notify( "path_end_reached" );
	self.path_halt = undefined;
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

dynamic_run_speed( pushdist )
{
	self endon( "stop_dynamic_run_speed" );
	self.oldwalkdist = self.walkdist;
	self.old_animplaybackrate = self.animplaybackrate;
	self.run_speed_state = "";

	while( true )
	{
		wait 0.05;

		dist = distance( self.origin, level.player.origin );

//		ahead broken for now.
//		ai_ahead = self ahead_of_player();
//		if( !ai_ahead || dist < pushdist / 2 )

		if( dist < pushdist / 2 )
		{
			// sprint when player is inside half push dist or ai is not ahead of player.
			if( self.run_speed_state == "sprint" )
				continue;
			self.run_speed_state = "sprint";
//			self set_run_anim( "sprint" );
			self clear_run_anim();
//			self.animplaybackrate = 1.4;
			self waittill( "goal" );
		}
		else if( dist < pushdist )
		{
			// run when player is inside push dist.
			if( self.run_speed_state == "run" )
				continue;
			self.run_speed_state = "run";
			self clear_run_anim();
//			self.animplaybackrate = 1.2;
//			self waittill( "goal" );
		}
		else if( dist < pushdist * 3 )
		{
			// walk if player is outside.
			if( self.run_speed_state == "walk" )
				continue;
			self set_run_anim( "path_slow" );
			self.animplaybackrate = 1;
			self.run_speed_state = "walk";
		}
		else
		{
			// start moving again at twice the push dist.
			self.disableArrivals = false;
			self.path_halt = true;
//			ahead broken for now.
//			while( self ahead_of_player() && distance( self.origin, level.player.origin ) > pushdist * 2 )
			while( distance( self.origin, level.player.origin ) > pushdist * 2 )
				wait 0.05;
			self.path_halt = false;
			self notify( "path_resume" );
			self.run_speed_state = "";
		}
	}
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

	/*if( isdefined( path_struct.script_noteworthy ) && path_struct.script_noteworthy == "small_arms_fire" )
		flag_set( "heli_small_arms_fire" );
	else
		flag_clear( "heli_small_arms_fire" );*/

	/*if( isdefined( path_struct.script_noteworthy ) && path_struct.script_noteworthy == "spot_target" )
	{
		path_start = getent( path_struct.target, "targetname" );
		self thread spot_target_path( path_start );
	}*/

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

dialogprint( string, delay )
{
	iprintln( string );
	
	if( isdefined( delay ) && delay > 0 )
		wait delay;
}

waitForPlayer()
{

}

#using_animtree("generic_human");
patrol()
{
	if (isdefined(self.enemy))
		return;
	self.old_walkdist = self.walkdist;
	self.walkdist = 9999;
	self thread waittill_combat();
	assert(!isdefined(self.enemy));
	self endon("enemy");
	self.goalradius = 0;
	self allowedStances("stand");

	//patrolwalk[0] = %patrolwalk_bounce;
	patrolwalk[0] = %patrolwalk_tired;
	//patrolwalk[2] = %patrolwalk_swagger;
	
	self.walk_noncombatanim = maps\_utility::random(patrolwalk);
	self.walk_noncombatanim2 = maps\_utility::random(patrolwalk);
	
	//NOTE add combat call back and force patroller to walk

	targetnode = getnode(self.target, "targetname");
	if(!isdefined(targetnode))
	{
		println("patroller ", self.origin, " has no target or target is not a node");
	}
	else
	{
		while(isalive(self))
		{
			self setgoalnode(targetnode);
			self waittill("goal");

			if(isdefined(targetnode.script_animation))
			{
				assert( targetnode.script_animation == "pause" || targetnode.script_animation == "turn180" );

				if(targetnode.script_animation == "pause")
					self.nodeanim = %active_patrolwalk_pause;
				else if(targetnode.script_animation == "turn180")
					self.nodeanim = %active_patrolwalk_turn_180;

				self animscripted("scripted_animdone", self.origin, self.angles, self.nodeanim);
				self waittill("scripted_animdone");
			}

			if(isdefined(targetnode.target))
				targetnode = getnode(targetnode.target, "targetname");
			else
				break;
		}
	}
}

waittill_combat()
{
	assert(!isdefined(self.enemy));
	self waittill("enemy");
	self.walkdist = self.old_walkdist;
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

vehicle_think()
{
	// while player is in x stancedistance and 
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
			
			fRand = ( randomfloatrange(2, 3));
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
					
					wait(.5);
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