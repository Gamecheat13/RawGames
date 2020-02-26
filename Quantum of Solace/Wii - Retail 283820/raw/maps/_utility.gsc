#include common_scripts\utility;
#include maps\_utility_code;
flag_wait (msg)
{
	while (!level.flag[msg])
		level waittill (msg);
}

flag_wait_either( flag1, flag2 )
{
	for ( ;; )
	{
		if ( flag( flag1 ) )
			return;
		if ( flag( flag2 ) )
			return;
		
		level waittill_either( flag1, flag2 );
	}
}

flag_waitopen (msg)
{
	while (level.flag[msg])
		level waittill (msg);
}


flag_trigger_init( message, trigger, continuous )
{
	flag_init( message );

	if ( !isDefined( continuous ) )
		continuous = false;
	
	assert( isSubStr( trigger.classname, "trigger" ) );
	trigger thread _flag_wait_trigger( message, continuous );
	
	return trigger;
}


flag_triggers_init( message, triggers, all )
{
	flag_init( message );

	if ( !isDefined( all ) )
		all = false;
	
	for ( index = 0; index < triggers.size; index++ )
	{
		assert( isSubStr( triggers[index].classname, "trigger" ) );
		triggers[index] thread _flag_wait_trigger( message, false );
	}
	
	return triggers;
}


flag_init( message, trigger )
{
	if ( !isDefined( level.flag ) )
	{
		level.flag = [];
		level.flags_lock = [];
	}
	assertEx( !isDefined( level.flag[message] ), "Attempt to reinitialize existing message: " + message );
	level.flag[message] = false;
/#
	level.flags_lock[message] = false;
#/
}

flag_set_delayed( message, delay )
{
	wait( delay );
	flag_set( message );
}

flag_set( message )
{
/#
	assertEx( isDefined( level.flag[message] ), "Attempt to set a flag before calling flag_init: " + message );
	assert( level.flag[message] == level.flags_lock[message] );
	level.flags_lock[message] = true;
#/	
	level.flag[message] = true;
	level notify ( message );
}

flag_clear( message )
{
/#
	assertEx( isDefined( level.flag[message] ), "Attempt to set a flag before calling flag_init: " + message );
	assert( level.flag[message] == level.flags_lock[message] );
	level.flags_lock[message] = false;
#/	
	level.flag[message] = false;
	level notify ( message );
}

flag( message )
{
	assertEx( isdefined( message ), "Tried to check flag but the flag was not defined." );
	if ( !level.flag[message] )
		return false;

	return true;
}

_flag_wait_trigger( message, continuous )
{
	self endon ( "death" );
	
	for ( ;; )
	{
		self waittill( "trigger", other );
		flag_set( message );

		if ( !continuous )
			return;

		while ( other isTouching( self ) )
			wait ( 0.05 );
		
		flag_clear( messagE );
	}
}

trigger_off()
{
	if ( !isDefined( self.realOrigin ) )
		self.realOrigin = self.origin;

	if ( self.origin == self.realorigin )
		self.origin += (0, 0, -10000);
}

trigger_on()
{
	if ( isDefined( self.realOrigin ) )
		self.origin = self.realOrigin;
}

level_end_save()
{
	if ( level.missionfailed )
		return;

	if ( flag( "game_saving" ) )
		return;

	if ( !isAlive( level.player ) )
		return;
		
	flag_set( "game_saving" );
		
	imagename = "levelshots/autosave/autosave_" + level.script + "end";

	saveGame("levelend", &"AUTOSAVE_AUTOSAVE", imagename, true);
	
	flag_clear( "game_saving" );
}

error( message )
{
	println ("^c*ERROR* ", message);
	wait 0.05;

/#
	if ( getDebugDvar( "debug" ) != "1" )
		assertMsg( "This is a forced error - attach the log file" );
#/
}

array_thread( entities, process, var1, var2, var3, var4 )
{
	keys = getArrayKeys( entities );
	
	if ( isdefined( var4 ) )
	{
		for( i = 0 ; i < keys.size ; i++ )
			entities[ keys[ i ] ] thread [[process]]( var1, var2, var3, var4 );
			
		return;
	}
	
		if ( isdefined( var3 ) )
	{
		for( i = 0 ; i < keys.size ; i++ )
			entities[ keys[ i ] ] thread [[process]]( var1, var2, var3 );
			
		return;
	}

	if ( isdefined( var2 ) )
	{
		for( i = 0 ; i < keys.size ; i++ )
			entities[ keys[ i ] ] thread [[process]]( var1, var2 );
			
		return;
	}

	if ( isdefined( var1 ) )
	{
		for( i = 0 ; i < keys.size ; i++ )
			entities[ keys[ i ] ] thread [[process]]( var1 );
			
		return;
	}

	for( i = 0 ; i < keys.size ; i++ )
		entities[ keys[ i ] ] thread [[process]]();
}


array_levelthread( entities, process, var, exclusions )
{
	if ( !isDefined( exclusions ) )
		exclusions = [];
		
	for ( index = 0; index < entities.size; index++ )
	{
		exclude = false;
		for ( exIndex = 0; exIndex < exclusions.size; exIndex++ )
		{
			if ( entities[index] != exclusions[exIndex] )
				exclude = true;
		}
		
		if ( exclude )
			continue;
			
		if ( isDefined( var ) )
			level thread [[process]]( entities[index], var );
		else
			level thread [[process]]( entities[index] );
	}
}

debug_message( message, origin, duration )
{
	if ( !isDefined( duration ) )
		duration = 5;
		
	for ( time = 0; time < (duration * 20) ; time++)
	{
		print3d( (origin + (0,0,45)), message, (0.48,9.4,0.76), 0.85 );
		wait 0.05;
	}
}


debug_message_clear( message, origin, duration, extraEndon )
{
	if ( isDefined( extraEndon ) )
	{
		level notify ( message + extraEndon );
		level endon ( message + extraEndon );
	}
	else
	{
		level notify ( message );
		level endon ( message );
	}
	
	if ( !isDefined( duration ) )
		duration = 5;
		
	for ( time = 0; time < (duration * 20) ; time++)
	{
		print3d ( (origin + (0, 0, 45)), message, (0.48,9.4,0.76), 0.85 );
		wait 0.05;
	}
}


chain_off( chain )
{
	trigs = getentarray ("trigger_friendlychain","classname");
	for (i=0;i<trigs.size;i++)
	if ((isdefined (trigs[i].script_chain)) && (trigs[i].script_chain == chain))
	{
		if (isdefined (trigs[i].oldorigin))
			trigs[i].origin = trigs[i].oldorigin;
		else
			trigs[i].oldorigin = trigs[i].origin;

		trigs[i].origin = trigs[i].origin + (0,0,-5000);
	}
}


chain_on( chain )
{
	trigs = getentarray ("trigger_friendlychain","classname");
	for (i=0;i<trigs.size;i++)
	if ((isdefined (trigs[i].script_chain)) && (trigs[i].script_chain == chain))
	{
		if (isdefined (trigs[i].oldorigin))
			trigs[i].origin = trigs[i].oldorigin;
	}
}


precache (model)
{
	ent = spawn ("script_model",(0,0,0));
	ent.origin = level.player getorigin();
	ent setmodel (model);
	ent delete();
}

add_to_array ( array, ent )
{
	if (!isdefined (ent))
		return array;

	if (!isdefined (array))
		array[0] = ent;
	else
		array[array.size] = ent;

	return array;
}

closerFunc( dist1, dist2 )
{
	return dist1 >= dist2;
}

fartherFunc( dist1, dist2 )
{
	return dist1 <= dist2;
}

getClosest( org, array, dist )
{
	return compareSizes( org, array, dist, ::closerFunc);
}

getFarthest( org, array, dist )
{
	return compareSizes( org, array, dist, ::fartherFunc);
}

compareSizes(org, array, dist, compareFunc)
{
	if (!array.size)
		return undefined;
	if (isdefined(dist))
	{
		ent = undefined;
		keys = getArrayKeys( array );
		for ( i=0; i<keys.size; i++)
		{
			newdist = distance( array[ keys[i] ].origin, org);
			if ( [[ compareFunc ]]( newDist, dist ) )
				continue;
			dist = newdist;
			ent = array[ keys[i] ];
		}
		return ent;
	}

	keys = getArrayKeys( array );
	ent = array[ keys[0] ];
	dist = distance(ent.origin, org);
	for (i=1; i<keys.size; i++)
	{
		newdist = distance(array[ keys[i] ].origin, org);
		if ( [[ compareFunc ]]( newDist, dist ) )
			continue;
		dist = newdist;
		ent = array[ keys[i] ];
	}
	return ent;
}

get_closest_point( origin, points, maxDist )
{
	assert( points.size );
		
	closestPoint = points[0];
	dist = distance( origin, closestPoint );
	
	for ( index = 0; index < points.size; index++ )
	{
		testDist = distance( origin, points[index] );
		if ( testDist >= dist )
			continue;
			
		dist = testDist;
		closestPoint = points[index];
	}
	
	if ( !isDefined( maxDist ) || dist <= maxDist )
		return closestPoint;
		
	return undefined;		
}

get_closest_living(org, array, dist)
{
	if(!isdefined(dist))
		dist = 9999999;
	if (array.size < 1)
		return;
	ent = undefined;		
	for (i=0;i<array.size;i++)
	{
		if (!isalive(array[i]))
			continue;
		newdist = distance(array[i].origin, org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

get_highest_dot(start, end, array)
{
	if (!array.size)
		return;
	
	ent = undefined;		
	
	angles = vectorToAngles(end - start);
	dotforward = anglesToForward(angles);
	dot = -1;
	for (i=0;i<array.size;i++)
	{
		angles = vectorToAngles(array[i].origin - start);
		forward = anglesToForward(angles);
		
		newdot = vectordot(dotforward, forward);
		if (newdot < dot)
			continue;
		dot = newdot;
		ent = array[i];
	}
	return ent;
}


get_closest_index(org, array, dist)
{
	if(!isdefined(dist))
		dist = 9999999;
	if (array.size < 1)
		return;
	index = undefined;		
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i].origin, org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		index = i;
	}
	return index;
}


get_farthest(org, array)
{
	if (array.size < 1)
		return;
		
	dist = distance(array[0].origin, org);
	ent = array[0];
	for (i=1;i<array.size;i++)
	{
		newdist = distance(array[i].origin, org);
		if (newdist <= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}


get_closest_exclude (org, ents, excluders)
{
	if (!isdefined (ents))
		return undefined;

	range = 0;
	if (isdefined (excluders) && excluders.size)
	{
		exclude = [];
		for (i=0;i<ents.size;i++)
			exclude[i] = false;

		for (i=0;i<ents.size;i++)
		for (p=0;p<excluders.size;p++)
		if (ents[i] == excluders[p])
			exclude[i] = true;

		found_unexcluded = false;
		for (i=0;i<ents.size;i++)
		if ((!exclude[i]) && (isdefined (ents[i])))
		{
			found_unexcluded = true;
			range = distance (org, ents[i].origin);
			ent = i;
			i = ents.size + 1;
		}

		if (!found_unexcluded)
			return (undefined);
	}
	else
	{
		for (i=0;i<ents.size;i++)
		if (isdefined (ents[i]))
		{
			range = distance (org, ents[0].origin);
			ent = i;
			i = ents.size + 1;
		}
	}

	ent = undefined;

	for (i=0;i<ents.size;i++)
	if (isdefined (ents[i]))
	{
		exclude = false;
		if (isdefined (excluders))
		{
			for (p=0;p<excluders.size;p++)
			if (ents[i] == excluders[p])
				exclude = true;
		}

		if (!exclude)
		{
			newrange = distance (org, ents[i].origin);
			if (newrange <= range)
			{
				range = newrange;
				ent = i;
			}
		}
	}

	if (isdefined (ent))
		return ents[ent];
	else
		return undefined;
}

get_closest_ai (org, team)
{
	if (isdefined (team))
		ents = getaiarray (team);
	else
		ents = getaiarray ();

	if (ents.size == 0)
		return undefined;

	return getClosest (org, ents);
}

get_array_of_closest(org, array, excluders, max)
{
	
	
	if (!isdefined(max))
		max = array.size;
		
	
	dist = [];
	index = [];
	for (i=0;i<array.size;i++)
	{
		excluded = false;
		for (p=0;p<excluders.size;p++)
		{
			if (array[i] != excluders[p])
				continue;
			excluded = true;
			break;
		}
		if (excluded)
			continue;
		if( IsDefined(array[i]) )
		{
			dist[dist.size] = distance(org, array[i].origin);
		}
		else
		{
			dist[dist.size]= undefined;
		}

		index[index.size] = i;
	}
		
	for (;;)
	{
		change = false;
		for (i=0;i<dist.size-1;i++)
		{
			if(!IsDefined(dist[i]))
				continue;
			if (dist[i] <= dist[i+1])
				continue;
			change = true;
			temp = dist[i];
			dist[i] = dist[i+1];
			dist[i+1] = temp;
			temp = index[i];
			index[i] = index[i+1];
			index[i+1] = temp;
		}
		if (!change)
			break;
	}
	
	newArray = [];
	if (max > dist.size)
		max = dist.size;
	for (i=0;i<max;i++)
		newArray[i] = array[index[i]];
	return newArray;
}

get_closest_ai_exclude (org, team, excluders)
{
	if (isdefined (team))
		ents = getaiarray (team);
	else
		ents = getaiarray ();

	if (ents.size == 0)
		return undefined;

	return get_closest_exclude (org, ents, excluders);
}

stop_magic_bullet_shield()
{
	assertEx( isdefined( self.magic_bullet_shield ) && self.magic_bullet_shield, "Tried to stop magic bullet shield on a guy without magic bulletshield" );
	self notify( "stop magic bullet shield" );
}

magic_bullet_death_detection()
{
	self endon( "stop magic bullet shield" );
	export = self.export;
	self waittill( "death" );
	if ( isdefined( self ) )
		assertEx( 0, "Magic bullet shield guy with export " + export + " died some how." );
	else
		assertEx( 0, "Magic bullet shield guy with export " + export + " died, most likely deleted from spawning guys." );
	
}

magic_bullet_shield(health, time, oldhealth, maxhealth_modifier)
{
	
	self notify( "stop magic bullet shield" );
	waittillframeend;
		
	self endon( "stop magic bullet shield" );
	self endon( "death" );
	
	if (!isdefined (maxhealth_modifier))
		maxhealth_modifier = 1;
	
	if (!isdefined (oldhealth))
		oldhealth = self.health;

	self.a.disableLongDeath = true;

	anim_nextStandingHitDying = self.a.nextStandingHitDying;		
	self.a.nextStandingHitDying = false;
	
	/#
	thread magic_bullet_death_detection();
	#/

	self thread stop_magic_bullet_shield_on_notify( oldhealth, anim_nextStandingHitDying );
	self.magic_bullet_shield = true;
	if (!isdefined (time))
		time = 5;

	if (!isdefined (health))
		health = 100000000;
		
	assertEx(health >= 5000, "MagicBulletShield shouldnt be set with low health amounts like < 5000");
	
	while (1)
	{
		self.health = health;
		self.maxhealth = (self.health * maxhealth_modifier);
		oldHealth = self.health;
		self waittill ("pain");
		if (oldHealth == self.health ) 
			continue;
			
		assertEx(self.health > 1000, "Magic bullet shield guy got impossibly low health");
		self thread ignore_me_timer(time);
	}
}

get_ignoreme()
{
	return self.ignoreme;
}

set_ignoreme( val )
{
	assertEx( isSentient( self ), "Non ai tried to set ignoreme" );
	self.ignoreme = val;
}

get_pacifist()
{
	return self.pacifist;
}

set_pacifist( val )
{
	assertEx( isSentient( self ), "Non ai tried to set pacifist" );
	self.pacifist = val;
}

ignore_me_timer(time)
{
	ai = getaiarray( "axis" );
	
	for ( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if ( !isalive( guy.enemy ) )
			continue;
		if ( guy.enemy != self )
			continue;
		guy notify( "enemy" );
	}
	self endon( "death" );
	self endon( "pain" );
	self.ignoreme = true;
	wait( time );
	self.ignoreme = false;
}

array_randomize(array)
{
    for (i = 0; i < array.size; i++)
    {
        j = randomint(array.size);
        temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    return array;
}

exploder_damage ()
{
	if (isdefined(self.v["delay"]))
		delay = self.v["delay"];
	else
		delay = 0;
		
	if (isdefined (self.v["damage_radius"]))
		radius = self.v["damage_radius"];
	else
		radius = 128;

	damage = self.v["damage"];
	origin = self.v["origin"];
	
	wait (delay);
	
	self.model RadiusDamage(origin, radius, damage, damage/2);
}

exploder( num )
{
	[[level.exploderFunction]]( num );
}

exploder_before_load( num )
{
	
	
	waittillframeend;
	waittillframeend;
	activate_exploder( num );
}

exploder_after_load( num )
{
	activate_exploder( num );
}

activate_exploder (num)
{
	num = int(num);
	for (i=0;i<level.createFXent.size;i++)
	{
		ent = level.createFXent[i];
		if (!isdefined (ent))
			continue;
	
		if (ent.v["type"] != "exploder")
			continue;	
	
		
		if (!isdefined(ent.v["exploder"]))
			continue;

		if (ent.v["exploder"] != num)
			continue;

		if (isdefined (ent.v["firefx"]))
			ent thread fire_effect();

		if ( isdefined ( ent.v["fxid"] ) && ent.v["fxid"] != "No FX" )
			ent thread cannon_effect();
		else
		if (isdefined (ent.v["soundalias"]))
			ent thread sound_effect();

		if (isdefined (ent.v["damage"]))
			ent thread exploder_damage();

		if (isdefined (ent.v["earthquake"]))
		{
			eq = ent.v["earthquake"];
			earthquake(level.earthquake[eq]["magnitude"],
						level.earthquake[eq]["duration"],
						ent.v["origin"],
						level.earthquake[eq]["radius"]);
		}

		if (ent.v["exploder_type"] == "exploder")
			ent thread brush_show();
		else
		if ((ent.v["exploder_type"] == "exploderchunk") || (ent.v["exploder_type"] == "exploderchunk visible"))
			ent thread brush_throw();
		else
			ent thread brush_delete();
	}


}

sound_effect ()
{
	self effect_soundalias();
}

effect_soundalias ( )
{
	if (!isdefined (self.v["delay"]))
		self.v["delay"] = 0;
	
	
	origin = self.v["origin"];
	alias = self.v["soundalias"];
	wait (self.v["delay"]);
	play_sound_in_space ( alias, origin );
}

cannon_effect ()
{
	if ( !isdefined( self.v["delay"] ) )
		self.v["delay"] = 0;

	min_delay = self.v["delay"];
	max_delay = self.v["delay"] + 0.001; 
	if ( isdefined(self.v["delay_min"]) )
		min_delay = self.v["delay_min"];

	if ( isdefined(self.v["delay_max"]) )
		max_delay = self.v["delay_max"];

	if ( min_delay > 0 )
		wait ( randomfloatrange( min_delay, max_delay ) );

	if ( isdefined( self.v["repeat"] ) )
	{
		for (i=0;i<self.v["repeat"];i++)
		{
			playfx( level._effect[ self.v["fxid"] ], self.v["origin"], self.v["forward"], self.v["up"] );
			exploder_playSound();

			if ( min_delay > 0 )
				wait ( randomfloatrange ( min_delay, max_delay ) );
		}
		return;
	}

	if( IsDefined( level._effect[ self.v["fxid"] ] ) )
	{
		playfx( level._effect[ self.v["fxid"] ], self.v["origin"], self.v["forward"], self.v["up"] );
	}
	exploder_playSound();
}

exploder_playSound( )
{
	if (!isdefined (self.v["soundalias"]))
		return;
	
	play_sound_in_space ( self.v["soundalias"], self.v["origin"] );
}

fire_effect ( )
{
	if (!isdefined (self.v["delay"]))
		self.v["delay"] = 0;

	delay = self.v["delay"];
	if ((isdefined (self.v["delay_min"])) && (isdefined (self.v["delay_max"])))
		delay = self.v["delay_min"] + randomfloat (self.v["delay_max"] - self.v["delay_min"]);

	forward = self.v["forward"];
	up = self.v["up"];

	org = undefined;

	firefxSound = self.v["firefxsound"];
	origin = self.v["origin"];
	firefx = self.v["firefx"];
	ender = self.v["ender"];
	if (!isdefined (ender))
		ender = "createfx_effectStopper";
	timeout = self.v["firefxtimeout"];

	fireFxDelay = 0.5;
	if (isdefined (self.v["firefxdelay"]))
		fireFxDelay = self.v["firefxdelay"];

	wait (delay);

	if (isdefined (firefxSound))	
		level thread loop_fx_sound ( firefxSound, origin, ender, timeout );

	playfx ( level._effect[firefx], self.v["origin"], forward, up );



}

loop_sound_delete ( ender, ent )
{
	ent endon ("death");
	self waittill (ender);
	ent delete();
}

loop_fx_sound ( alias, origin, ender, timeout )
{
	org = spawn ("script_origin",(0,0,0));
	if ( isdefined( ender ) )
	{
		thread loop_sound_delete (ender, org);
		self endon( ender );
	}
	org.origin = origin;
	org playloopsound (alias);
	if (!isdefined (timeout))
		return;
		
	wait (timeout);

}

brush_delete()
{



	num = self.v["exploder"];
	if (isdefined (self.v["delay"]))
		wait (self.v["delay"]);
	else
		wait (.05); 

	if (!isdefined( self.model ))
		return;


	assert(isdefined(self.model));

	if (self.model.spawnflags & 1)
		self.model connectpaths();

	if (level.createFX_enabled)
	{
		if ( isdefined( self.exploded ) )
			return;
			
		self.exploded = true;
		self.model hide();
		self.model notsolid();
		
		wait (3);
		self.exploded = undefined;
		self.model show();
		self.model solid();
		return;
	}

	if (!isdefined( self.v["fxid"] ) || self.v["fxid"] == "No FX" )
		self.v["exploder"] = undefined;
		
	waittillframeend; 
	self.model delete();
}

brush_show()
{
	if (isdefined (self.v["delay"]))
		wait (self.v["delay"]);
	
	assert(isdefined(self.model));
	
	self.model show();
	self.model solid();
		
	if (self.model.spawnflags & 1)
	{
		if (!isdefined(self.model.disconnect_paths))
			
			self.model connectpaths();	
		else
			
			self.model disconnectpaths();
	}

	if (level.createFX_enabled)
	{
		if ( isdefined( self.exploded ) )
			return;

		self.exploded = true;
		wait (3);
		self.exploded = undefined;
		self.model hide();
		self.model notsolid();
	}
}

brush_throw()
{
	if (isdefined (self.v["delay"]))
		wait (self.v["delay"]);

	ent = undefined;
	if (isdefined (self.v["target"]))
		ent = getent (self.v["target"],"targetname");

	if (!isdefined (ent))
	{
		self.model delete();
		return;
	}

	self.model show();

	startorg = self.v["origin"];
	startang = self.v["angles"];
	org = ent.origin;


	temp_vec = ( org - self.v["origin"] );
	x = temp_vec[0];
	y = temp_vec[1];
	z = temp_vec[2];

	self.model rotateVelocity ((x,y,z), 12);

	self.model moveGravity ((x, y, z), 12);
	if (level.createFX_enabled)
	{
		if ( isdefined( self.exploded ) )
			return;

		self.exploded = true;
		wait (3);
		self.exploded = undefined;
		self.v["origin"] = startorg;
		self.v["angles"] = startang;
		self.model hide();
		return;
	}
	
	self.v["exploder"] = undefined;
	wait (6);
	self.model delete();

}

flood_spawn( spawners )
{
	maps\_spawner::flood_spawner_scripted( spawners );
}

vector_multiply (vec, dif)
{
	vec = (vec[0] * dif, vec[1] * dif, vec[2] * dif);
	return vec;
}

random (array)
{
	return array [randomint (array.size)];
}

get_friendly_chain_node (chainstring)
{
	chain = undefined;
	trigger = getentarray ("trigger_friendlychain","classname");
	for (i=0;i<trigger.size;i++)
	{
		if ((isdefined (trigger[i].script_chain)) && (trigger[i].script_chain == chainstring))
		{
			chain = trigger[i];
			break;
		}
	}

	if (!isdefined (chain))
	{
/#
		maps\_utility::error ("Tried to get chain " + chainstring + " which does not exist with script_chain on a trigger.");
#/
		return undefined;
	}

	node = getnode (chain.target,"targetname");
	return node;
}

shock_ondeath()
{
	precacheShellshock("death");
	self waittill ("death");
	if (getdvar ("r_texturebits") == "16")
		return;
	self shellshock("default", 3);

	
	
	SetSavedDVar( "ai_ChatEnable", "0" );
	self PlayLocalSound( "dia_mission_fail" );
	wait( 0.05 );
	SetSavedDVar( "ai_ChatEnable", "1" );
}

stinger_ondeath()
{
	self waittill ("death");
	self playsound("death_stinger");
}

delete_on_death (ent)
{
	ent endon ("death");
	self waittill ("death");
	if (isdefined (ent))
		ent delete();
}

play_sound_on_tag (alias, tag)
{
	if ((isSentient (self)) && (!isalive (self)))
		return;

	org = spawn ("script_origin",(0,0,0));
	org endon ("death");

	thread delete_on_death (org);
	if (isdefined (tag))
		org linkto (self, tag, (0,0,0), (0,0,0));
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}

	org playsound (alias, "sounddone");
	org waittill ("sounddone");
	org delete();
}


play_sound_on_entity(alias)
{
	play_sound_on_tag (alias);
	
}


play_loop_sound_on_tag(alias, tag)
{
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	if (isdefined (tag))
		org linkto (self, tag, (0,0,0), (0,0,0));
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}

	org playloopsound (alias);

	self waittill ("stop sound" + alias);
	org stoploopsound (alias);
	org delete();
}

play_loop_sound_on_entity(alias, offset)
{
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	if (isdefined (offset))
	{
		org.origin = self.origin + offset;
		org.angles = self.angles;
		org linkto (self);
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}

	org playloopsound (alias);

	self waittill ("stop sound" + alias);
	org stoploopsound (alias);
	org delete();
}

play_sound_in_space (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias, "sounddone");
	else
		org playsound (alias, "sounddone");
	org waittill ("sounddone");
	org delete();
}

lookat (ent, timer)
{
	if (!isdefined (timer))
		timer = 10000;

	self animscripts\shared::lookatentity(ent, timer, "alert");
}

save_friendlies()
{
	ai = getaiarray ("allies");
	game_characters = 0;
	for (i=0;i<ai.size;i++)
	{
		if (isdefined (ai[i].script_friendname))
			continue;




		game["character" + game_characters] = ai[i] codescripts\character::save();
		game_characters++;
	}

	game["total characters"] = game_characters;
}

load_friendlies()
{
	if (isdefined (game["total characters"]))
	{
		game_characters = game["total characters"];
		println ("Loading Characters: ", game_characters);
	}
	else
	{
		println ("Loading Characters: None!");
		return;
	}

	ai = getaiarray ("allies");
	total_ai = ai.size;
	index_ai = 0;

	spawners = getspawnerteamarray ("allies");
	total_spawners = spawners.size;
	index_spawners = 0;

	while (1)
	{
		if (((total_ai <= 0) && (total_spawners <= 0)) || (game_characters <= 0))
			return;

		if (total_ai > 0)
		{
			if (isdefined (ai[index_ai].script_friendname))
			{
				total_ai--;
				index_ai++;
				continue;
			}

			println ("Loading character.. ", game_characters);
			ai[index_ai] codescripts\character::new();
			ai[index_ai] thread codescripts\character::load(game["character" + (game_characters-1)]);
			total_ai--;
			index_ai++;
			game_characters--;
			continue;
		}

		if (total_spawners > 0)
		{
			if (isdefined (spawners[index_spawners].script_friendname))
			{
				total_spawners--;
				index_spawners++;
				continue;
			}

			println ("Loading character.. ", game_characters);
			info = game["character" + (game_characters-1)];
			precache (info ["model"]);
			precache (info ["model"]);
			spawners[index_spawners] thread spawn_setcharacter (game["character" + (game_characters-1)]);
			total_spawners--;
			index_spawners++;
			game_characters--;
			continue;
		}
	}
}


spawn_failed (spawn)
{
	if (isalive (spawn))
	{
		if (!isdefined (spawn.finished_spawning))
			spawn waittill ("finished spawning");

		if (isalive (spawn))
			return false;
	}

	self notify("spawn_failed");
	return true;
}

spawn_setcharacter (data)
{
	codescripts\character::precache(data);

	self waittill ("spawned",spawn);
	if (maps\_utility::spawn_failed(spawn))
		return;

	println ("Size is ", data["attach"].size);
	spawn codescripts\character::new();
	spawn codescripts\character::load(data);
}

key_hint_print(message, binding)
{
	
	iprintlnbold(message, binding["key1"]);
}

view_tag( tag )
{
	self endon( "death" );
	for ( ;; )
	{
		maps\_debug::drawTag( tag );
		wait( 0.05 );
	}
}


assign_animtree()
{
	self UseAnimTree(level.scr_animtree[self.animname]);
}

assign_model()
{
	self setmodel(level.scr_model[ self.animname ]);
}

trigger_wait (strName, strKey)
{
	
	if( !IsDefined( strKey ) )
	{
		strKey = "targetname";
	}

	eTrigger = getent (strName, strKey);
	if (!isdefined (eTrigger))
	{
		assertmsg ("trigger not found: " + strName + " key: " + strKey);
		return;
	}
	eTrigger waittill ("trigger", eOther);
	level notify (strName, eOther);
	return eOther;
}

set_flag_on_trigger( eTrigger, strFlag )
{
	if (!level.flag[strFlag])
	{
		eTrigger waittill ("trigger", eOther);
		flag_set(strFlag);
		return eOther;
	}
}

set_flag_on_targetname_trigger( msg )
{
	assert( isdefined( level.flag[ msg ] ) );
	if ( flag( msg ) )
		return;
		
	trigger = getent( msg, "targetname" );
	trigger waittill( "trigger" );
	flag_set( msg );
}

is_in_array (aeCollection, eFindee)
{
	for (i = 0; i < aeCollection.size; i++)
	{
		if (aeCollection[i] == eFindee)
			return (true);
	}
	
	return (false);
}

waittill_dead(guys, num, timeoutLength)
{

	
	allAlive = true;
	for (i=0;i<guys.size;i++)
	{
		if (isalive(guys[i]))
			continue;
		allAlive = false;
		break;
	}
	assertEx (allAlive, "Waittill_Dead was called with dead or removed AI in the array, meaning it will never pass.");
	if (!allAlive)
	{	
		newArray = [];
		for (i=0;i<guys.size;i++)
		{
			if (isalive(guys[i]))
				newArray[newArray.size] = guys[i];
		}
		guys = newArray;
	}

	ent = spawnStruct();
	if (isdefined (timeoutLength))
	{
		ent endon ("thread timed out");
		ent thread waittill_dead_timeout(timeoutLength);
	}
	
	ent.count = guys.size;
	if (isdefined (num) && num < ent.count)
		ent.count = num;
	array_thread(guys, ::waittill_dead_thread, ent);
	
	while (ent.count > 0)
		ent waittill ("waittill_dead guy died");
}

waittill_dead_thread(ent)
{
	self waittill ("death");
	ent.count--;
	ent notify ("waittill_dead guy died");
}

waittill_dead_timeout(timeoutLength)
{
	wait (timeoutLength);
	self notify ("thread timed out");
}

waittill_aigroupcleared( aigroup )
{
	while( level._ai_group[aigroup].spawnercount || level._ai_group[aigroup].aicount )
		wait ( 2.5 );
}

get_ai_group_count( aigroup )
{
	return ( level._ai_group[aigroup].spawnercount + level._ai_group[aigroup].aicount );
}

get_ai_group_sentient_count( aigroup )
{
	return ( level._ai_group[aigroup].aicount );
}

get_ai_group_ai( aigroup )
{
	aiSet = [];
	for ( index = 0; index < level._ai_group[aigroup].ai.size; index++ )
	{
		if ( !isAlive( level._ai_group[aigroup].ai[index] ) )
			continue;
			
		aiSet[aiSet.size] = level._ai_group[aigroup].ai[index];
	}
	
	return ( aiSet );
}


gather_delay_proc(msg, delay)
{
	if (isdefined (level.gather_delay[msg]))
	{
		if (level.gather_delay[msg])
		{
			wait (0.05);
			if (isalive (self))
				self notify ("gather_delay_finished" + msg + delay);
			return;
		}
		
		level waittill (msg);
		if (isalive (self))
			self notify ("gather_delay_finished" + msg + delay);
		return;
	}
	
	level.gather_delay[msg] = false;
	wait (delay);
	level.gather_delay[msg] = true;
	level notify (msg);
	if (isalive (self))
		self notify ("gather_delay_finished" + msg + delay);
}

gather_delay(msg, delay)
{
	thread gather_delay_proc(msg, delay);
	self waittill ("gather_delay_finished" + msg + delay);
}

set_environment(env)
{
	animscripts\utility::setEnv(env);
}

death_waiter(notifyString)
{
	self waittill ("death");
	level notify (notifyString);
}

getchar(num)
{
	if (num == 0)
		return "0";
	if (num == 1)
		return "1";
	if (num == 2)
		return "2";
	if (num == 3)
		return "3";
	if (num == 4)
		return "4";
	if (num == 5)
		return "5";
	if (num == 6)
		return "6";
	if (num == 7)
		return "7";
	if (num == 8)
		return "8";
	if (num == 9)
		return "9";
}

waittill_either( msg1, msg2 )
{
	self endon( msg1 );
	self waittill( msg2 );
}



player_god_on()
{
	thread player_god_on_thread();
}

player_god_on_thread()
{
	level.player endon ("godoff");
	level.player.oldhealth = level.player.health;
	
	for (;;)
	{
		level.player waittill ("damage");
		level.player.health = 10000;
	}	
}

player_god_off()
{
	level.player notify ("godoff");
	assert(isdefined(level.player.oldhealth));
	level.player.health = level.player.oldhealth;
}


getlinks_array( array, linkMap )  
{
	ents = [];
	for ( j = 0; j < array.size; j++ )
	{
		node = array[j];
		script_linkname = node.script_linkname;
		if ( !isdefined( script_linkname ) )
			continue;
		if ( !isdefined( linkMap[script_linkname] ) )
			continue;
		ents[ents.size] = node;
	}
	return ents;
}



array_merge_links( array1, array2 )
{
	if ( !array1.size )
		return array2;
	if ( !array2.size )
		return array1;

	linkMap = [];

	for ( i = 0; i < array1.size; i++ )
	{
		node = array1[i];
		linkMap[node.script_linkname] = true;
	}

	for ( i = 0; i < array2.size; i++ )
	{
		node = array2[i];
		if ( isdefined( linkMap[node.script_linkname] ) )
			continue;
		linkMap[node.script_linkname] = true;
		array1[array1.size] = node;
	}

	return array1;
}

array_combine(array1,array2)
{
	if(!array1.size)
		return array2;
	for(i=0;i<array2.size;i++)
		array1[array1.size] = array2[i];
	return array1;
}

array_merge(array1,array2) 
{
	if(array1.size == 0)
		return array2;
	if(array2.size == 0)
		return array1;
	newarray = array1;
	for(i=0;i<array2.size;i++)
	{
		foundmatch = false;
		for(j=0;j<array1.size;j++)
			if(array2[i] == array1[j])
			{
				foundmatch = true;
				break;
			}
		if(foundmatch)
			continue;
		else
			newarray[newarray.size] = array2[i];
	}
	return newarray;
}

flat_angle(angle)
{
	rangle = (0,angle[1],0);
	return rangle;
}

flat_origin(org)
{
	rorg = (org[0],org[1],0);
	return rorg;

}

plot_points(plotpoints,r,g,b,timer)
{
	lastpoint = plotpoints[0];
	if(!isdefined(r))
		r = 1;
	if(!isdefined(g))
		g = 1;
	if(!isdefined(b))
		b = 1;
	if(!isdefined(timer))
		timer = 0.05;
	for(i=1;i<plotpoints.size;i++)
	{
		thread draw_line_for_time(lastpoint,plotpoints[i],r,g,b,timer);
		lastpoint = plotpoints[i];	
	}
}

draw_line_for_time(org1,org2,r,g,b,timer)
{
	timer = gettime()+(timer*1000);
	while(gettime()<timer)
	{
		line (org1,org2, (r,g,b), 1);
		wait .05;		
	}
	
}

draw_line_to_ent_for_time(org1,ent,r,g,b,timer)
{
	timer = gettime()+(timer*1000);
	while(gettime()<timer)
	{
		line (org1,ent.origin, (r,g,b), 1);
		wait .05;		
	}
	
}

draw_line_from_ent_for_time(ent,org,r,g,b,timer)
{
	timer = gettime()+(timer*1000);
	while(gettime()<timer)
	{
		line (ent.origin,org, (r,g,b), 1);
		wait .05;		
	}
	
}

draw_line_from_ent_to_ent_for_time(ent1,ent2,r,g,b,timer)
{
	timer = gettime()+(timer*1000);
	while(gettime()<timer)
	{
		line (ent1.origin,ent2.origin, (r,g,b), 1);
		wait .05;		
	}
	
}

draw_line_until_notify( org1, org2, r, g, b, notifyEnt, notifyString )
{
	assert( isdefined( notifyEnt ) );
	assert( isdefined( notifyString ) );
	
	notifyEnt endon( notifyString );
	
	while(1)
	{
		draw_line_for_time(org1,org2,r,g,b,0.05);	
	}
}

draw_arrow_time (start, end, color, duration)
{
	level endon ("newpath");
	pts = [];
	angles = vectortoangles(start - end);
	right = anglestoright(angles);
	forward = anglestoforward(angles);
	up = anglestoup(angles);

	dist = distance(start, end);
	arrow = [];
	range = 0.1;
		 	
	arrow[0] =  start;
	arrow[1] =  start + vectorScale(right, dist*(range)) + vectorScale(forward, dist*-0.1);
	arrow[2] =  end;
	arrow[3] =  start + vectorScale(right, dist*(-1 * range)) + vectorScale(forward, dist*-0.1);

	arrow[4] =  start;
	arrow[5] =  start + vectorScale(up, dist*(range)) + vectorScale(forward, dist*-0.1);
	arrow[6] =  end;
	arrow[7] =  start + vectorScale(up, dist*(-1 * range)) + vectorScale(forward, dist*-0.1);
	arrow[8] =  start;

	r = color[0];
	g = color[1];
	b = color[2];
	
	plot_points(arrow,r,g,b,duration);
}

draw_arrow (start, end, color)
{
	level endon ("newpath");
	pts = [];
	angles = vectortoangles(start - end);
	right = anglestoright(angles);
	forward = anglestoforward(angles);

	dist = distance(start, end);
	arrow = [];
	range = 0.05;
	arrow[0] =  start;
	arrow[1] =  start + vectorScale(right, dist*(range)) + vectorScale(forward, dist*-0.2);
	arrow[2] =  end;
	arrow[3] =  start + vectorScale(right, dist*(-1 * range)) + vectorScale(forward, dist*-0.2);

	for (p=0;p<4;p++)
	{
		nextpoint = p+1;
		if (nextpoint >= 4)
			nextpoint = 0;
		line(arrow[p], arrow[nextpoint], color, 1.0);
	}
}

clear_enemy_passthrough()
{
	self notify ("enemy");
	self clearEnemy();
}

battlechatter_off( team )
{
	if ( !isDefined( level.battlechatter ) )
	{
		level.battlechatter = [];
		level.battlechatter["axis"] = true;
		level.battlechatter["allies"] = true;
		level.battlechatter["neutral"] = true;
	}

	if ( isDefined( team ) )
	{
		level.battlechatter[team] = false;
		soldiers = getAIArray( team );
	}
	else
	{
		level.battlechatter["axis"] = false;
		level.battlechatter["allies"] = false;
		level.battlechatter["neutral"] = false;
		soldiers = getAIArray();
	}

	if (!isDefined(anim.chatInitialized) || !anim.chatInitialized)
		return;

	for ( index = 0; index < soldiers.size; index++ )
		soldiers[ index ].battlechatter = false;

	for ( index = 0; index < soldiers.size; index++ )
	{
		soldier = soldiers[ index ];
		if ( !isalive( soldier ) )
			continue;
			
		if ( !soldier.chatInitialized )
			continue;

		if ( !soldier.isSpeaking )
			continue;
			
		soldier wait_until_done_speaking();
	}
	
	speakDiff = getTime() - anim.lastTeamSpeakTime["allies"];

	if ( speakDiff < 1500 )
		wait ( speakDiff / 1000 );
		
	if ( isdefined( team ) )
		level notify ( team + " done speaking" );
	else
		level notify ( "done speaking" );
}

battlechatter_on( team )
{
	thread battlechatter_on_thread( team );
}

battlechatter_on_thread( team )
{
	if ( !isDefined( level.battlechatter ) )
	{
		level.battlechatter = [];
		level.battlechatter["axis"] = true;
		level.battlechatter["allies"] = true;
		level.battlechatter["neutral"] = true;
	}

	if (!anim.chatInitialized)
		return;

	
	wait ( 1.5 );
	
	if ( isDefined( team ) )
	{
		level.battlechatter[team] = true;
		soldiers = getAIArray( team );
	}
	else
	{
		level.battlechatter["axis"] = true;
		level.battlechatter["allies"] = true;
		level.battlechatter["neutral"] = true;
		soldiers = getAIArray();
	}

	for ( index = 0; index < soldiers.size; index++ )
		soldiers[index] set_battlechatter(true);
}

set_battlechatter( state )
{
	if (!anim.chatInitialized)
		return;

	if (state)
	{
		if(isdefined(self.script_bcdialog) && !self.script_bcdialog)
			self.battlechatter = false;
		else
			self.battlechatter = true;
	}
	else
	{
		self.battlechatter = false;
		
		if (isdefined(self.isSpeaking) && self.isSpeaking)
			self waittill ("done speaking");
	}
}






set_friendly_chain_wrapper(node)
{
	level.player setFriendlyChain(node);
	level notify ("newFriendlyChain", node.script_noteworthy);
}





get_obj_origin(msg)
{
	objOrigins = getentarray("objective","targetname");
	for (i=0;i<objOrigins.size;i++)
	{
		if (objOrigins[i].script_noteworthy == msg)
			return objOrigins[i].origin;
	}
}

get_obj_event(msg)
{
	objEvents = getentarray("objective_event","targetname");
	for (i=0;i<objEvents.size;i++)
	{
		if (objEvents[i].script_noteworthy == msg)
			return objEvents[i];
	}
}


waittill_objective_event()
{
	waittill_objective_event_proc(true);
}

waittill_objective_event_notrigger()
{
	waittill_objective_event_proc(false);
}


obj_set_chain_and_enemies()
{
	objChain = getnode(self.target,"targetname");
	objEnemies = getentarray(self.target,"targetname");
	flood_and_secure_scripted(objEnemies);

	level notify ("new_friendly_trigger");
	level.player set_friendly_chain_wrapper(objChain);
}

flood_begin()
{
	self notify ("flood_begin");
}

flood_and_secure_scripted(spawners, instantRespawn)
{
	

	if (!isdefined(instantRespawn))
		instantRespawn = false;

	if (!isdefined (level.spawnerWave))
		level.spawnerWave = [];
	array_thread (spawners, maps\_spawner::flood_and_secure_spawner, instantRespawn);

	for (i=0;i<spawners.size;i++)
	{
		spawners[i].playerTriggered = true;
		spawners[i] notify ("flood_begin");
	}
}


debugorigin()
{


	self notify ("Debug origin");
	self endon ("Debug origin");
	self endon ("death");
	for (;;)
	{
		forward = anglestoforward (self.angles);
		forwardFar = vectorScale(forward, 30);
		forwardClose = vectorScale(forward, 20);
		right = anglestoright (self.angles);
		left = vectorScale(right, -10);
		right = vectorScale(right, 10);
		line (self.origin, self.origin + forwardFar, (0.9, 0.7, 0.6), 0.9);
		line (self.origin + forwardFar, self.origin + forwardClose + right, (0.9, 0.7, 0.6), 0.9);
		line (self.origin + forwardFar, self.origin + forwardClose + left, (0.9, 0.7, 0.6), 0.9);
		wait (0.05);
	}
}


get_links()
{
	return strtok( self.script_linkTo, " " );
}


player_seek(timeout)
{
	goalent = spawn("script_origin",level.player.origin);
	goalent linkto (level.player);
	if(isdefined(timeout))
		self thread timeout(timeout);
	self setgoalentity(goalent);
	if(!isdefined(self.oldgoalradius))
		self.oldgoalradius = self.goalradius;
	self.goalradius = 300;
	self waittill_any("goal","timeout");
	if(isdefined(self.oldgoalradius))
	{
		self.goalradius = self.oldgoalradius;
		self.oldgoalradius = undefined;
	}
	goalent delete();
}

timeout(timeout)
{
	self endon ("death");
	wait(timeout);
	self notify ("timeout");
}

set_forcegoal()
{
	if(isdefined(self.set_forcedgoal))
		return;
	
	self.oldfightdist 	= self.pathenemyfightdist;
	self.oldmaxdist 	= self.pathenemylookahead;
	self.oldmaxsight 	= self.maxsightdistsqrd;
	
	self.pathenemyfightdist = 8;
	self.pathenemylookahead = 8;
	self.maxsightdistsqrd = 1;
	self.set_forcedgoal = true;
}

unset_forcegoal()
{
	if(!isdefined(self.set_forcedgoal))
		return;
	
	self.pathenemyfightdist = self.oldfightdist;
	self.pathenemylookahead = self.oldmaxdist;
	self.maxsightdistsqrd 	= self.oldmaxsight;
	self.set_forcedgoal = undefined;
}


array_add ( array, ent )
{
	array[array.size] = ent;
	return array;
}

array_removeDead (array)
{
	newArray = [];
	for(i = 0; i < array.size; i++)
	{
		if (!isalive(array[i]))
			continue;
		newArray[newArray.size] = array[i];
	}

	return newArray;
}

array_removeUndefined (array)
{
	newArray = [];
	for(i = 0; i < array.size; i++)
	{
		if (!isdefined(array[i]))
			continue;
		newArray[newArray.size] = array[i];
	}

	return newArray;
}

array_insert(array, object, index)
{
	if(index == array.size)
	{
		temp = array;
		temp[temp.size] = object;
		return temp;
	}
	temp = [];
	offset = 0;
	for(i=0; i<array.size; i++)
	{
		if(i==index)
		{
			temp[i] = object;
			offset = 1;
		}
		temp[i + offset] = array[i];
	}
	
	return temp;
}

array_remove (ents, remover)
{
	newents = [];
	keys = getArrayKeys( ents );
	for(i = 0; i < keys.size; i++)
	{
		if(ents[ keys[ i ] ] != remover)
			newents[newents.size] = ents[ keys[ i ] ];
	}

	return newents;
}

array_remove_index ( array, index )
{
	newArray = [];
	keys = getArrayKeys( array );
	for( i = 0 ; i < keys.size ; i++ )
	{
		if( keys[ i ] != index )
			newArray[ newArray.size ] = array[ keys[ i ] ];
	}

	return newArray;
}

array_notify (ents, notifier)
{
	for (i=0;i<ents.size;i++)
		ents[i] notify (notifier);
}






array_subtract(first, second)
{
	return_array = [];
	
  for(i = 0; i < first.size; i ++)
  {
   	found = false;
   	
		for(j = 0; j < second.size; j ++)
		{
      if(first[i] == second[j]) 
      {
        found = true;
        break;
      }
   	}
    if(!found)
    {
      return_array[return_array.size] = first[i]; 
    }
  }
  return return_array;
}






getstruct(name, type)
{
	if(!isdefined(level.struct_class_names))
		return undefined;
	
	array = level.struct_class_names[type][name];
	if(!isdefined(array))
		return undefined;
	if(array.size > 1)
	{
		assertMsg ("getstruct used for more than one struct of type " + type + " called " + name +".");
		return undefined;
	}
	return array[0];
}

getstructarray(name, type)
{
	if(!isdefined(level.struct_class_names))
		return undefined;
	
	array = level.struct_class_names[type][name];
	return array;
}

struct_arrayspawn()
{
	struct = spawnstruct();
	struct.array = [];
	struct.lastindex = 0;
	return struct;
}


structarray_add(struct,object)
{
	assert(!isdefined(object.struct_array_index));  
	struct.array[struct.lastindex] = object;
	object.struct_array_index = struct.lastindex;
	struct.lastindex++;
}

structarray_remove(struct,object)
{
	structarray_swaptolast(struct,object);
	struct.array[struct.lastindex-1] = undefined;
	struct.lastindex--;
}

structarray_swaptolast(struct,object)
{
	struct structarray_swap(struct.array[struct.lastindex-1],object);
}

structarray_shuffle(struct,shuffle)
{
	for(i=0;i<shuffle;i++)
		struct structarray_swap(struct.array[i],struct.array[randomint(struct.lastindex)]);
}



get_use_key()
{
	if (isdefined( getdvar("xenonGame") ) && getdvar("xenonGame") == "true" )
	 	return "+usereload";
 	else
 		return "+activate";
}


doom()
{
	
	self teleport((0,0,-15000));
	self dodamage(self.health + 1, (0,0,0));
}



custom_battlechatter( string )
{
	excluders = [];
	excluders[0] = self;
	buddy = get_closest_ai_exclude( self.origin, self.team, excluders );

	if ( isDefined( buddy ) && distance( buddy.origin, self.origin ) > 384 ) 
		buddy = undefined;

	self animscripts\battlechatter_ai::beginCustomEvent();

	tokens = strTok( string, "_" );

	if ( !tokens.size )
		return;
		
	if ( tokens[0] == "move" )
	{
		if ( tokens.size > 1 )
			modifier = tokens[1];
		else 
			modifier = "generic";
			
		self animscripts\battlechatter_ai::addGenericAliasEx( "order", "move", modifier );
			
	}
	else if ( tokens[0] == "infantry" )
	{
		self animscripts\battlechatter_ai::addGenericAliasEx( "threat", "infantry", tokens[1] );
		
		if ( tokens.size > 2 && tokens[2] != "inbound" )
			self animscripts\battlechatter_ai::addGenericAliasEx( "direction", "relative", tokens[2] );
		else if ( tokens.size > 2 )
			self animscripts\battlechatter_ai::addGenericAliasEx( "direction", "inbound", tokens[3] );
	}
	else if ( tokens[0] == "vehicle" )
	{
		self animscripts\battlechatter_ai::addGenericAliasEx( "threat", "vehicle", tokens[1] );
		
		if ( tokens.size > 2 && tokens[2] != "inbound" )
			self animscripts\battlechatter_ai::addGenericAliasEx( "direction", "relative", tokens[2] );
		else if ( tokens.size > 2 )
			self animscripts\battlechatter_ai::addGenericAliasEx( "direction", "inbound", tokens[3] );
	}
	
	self animscripts\battlechatter_ai::endCustomEvent( 2000 );
}


force_custom_battlechatter( string, targetAI )
{
	tokens = strTok( string, "_" );
	soundAliases = [];

	if ( !tokens.size )
		return;

	if ( isDefined( targetAI ) && (isDefined( targetAI.bcName) || isDefined( targetAI.bcRank)) )
	{
		if ( isDefined( targetAI.bcName ) )
			nameAlias = self buildBCAlias( "name", targetAI.bcName );
		else
			nameAlias = self buildBCAlias( "rank", targetAI.bcRank );
			
		if ( soundExists( nameAlias ) )
			soundAliases[soundAliases.size] = nameAlias;
	}	
		
	if ( tokens[0] == "move" )
	{
		if ( tokens.size > 1 )
			modifier = tokens[1];
		else 
			modifier = "generic";
			
		soundAliases[soundAliases.size] = self buildBCAlias( "order", "move", modifier );
	}
	else if ( tokens[0] == "infantry" )
	{
		soundAliases[soundAliases.size] = self buildBCAlias( "threat", "infantry", tokens[1] );
		
		if ( tokens.size > 2 && tokens[2] != "inbound" )
			soundAliases[soundAliases.size] = self buildBCAlias( "direction", "relative", tokens[2] );
		else if ( tokens.size > 2 )
			soundAliases[soundAliases.size] = self buildBCAlias( "direction", "inbound", tokens[3] );
	}
	else if ( tokens[0] == "vehicle" )
	{
		soundAliases[soundAliases.size] = self buildBCAlias( "threat", "vehicle", tokens[1] );
		
		if ( tokens.size > 2 && tokens[2] != "inbound" )
			soundAliases[soundAliases.size] = self buildBCAlias( "direction", "relative", tokens[2] );
		else if ( tokens.size > 2 )
			soundAliases[soundAliases.size] = self buildBCAlias( "direction", "inbound", tokens[3] );
	}
	else if ( tokens[0] == "order" )
	{
		if ( tokens.size > 1 )
			modifier = tokens[1];
		else 
			modifier = "generic";

		soundAliases[soundAliases.size] = self buildBCAlias( "order", "action", modifier );
	}
	else if ( tokens[0] == "cover" )
	{
		if ( tokens.size > 1 )
			modifier = tokens[1];
		else 
			modifier = "generic";

		soundAliases[soundAliases.size] = self buildBCAlias( "order", "cover", modifier );
	}
	
	for ( index = 0; index < soundAliases.size; index++)
	{
		self playSound( soundAliases[index], soundAliases[index], true);
		self waittill( soundAliases[index] );
	}
}


buildBCAlias( action, type, modifier )
{
	if ( isDefined( modifier ) )
		return ( self.countryID + "_" + self.npcID + "_" + action + "_" + type + "_" + modifier );
	else
		return ( self.countryID + "_" + self.npcID + "_" + action + "_" + type );
}

get_stop_watch(time,othertime)
{
	watch = newHudElem();
	 if (isdefined( getdvar("xenonGame") ) && getdvar("xenonGame") == "true" )
	{
		watch.x = 68;
		watch.y = 35;
	}
	else
	{
		watch.x = 58;
		watch.y = 95;
	}
	
	watch.alignx = "center";
	watch.aligny = "middle";
	watch.horzAlign = "left";
	watch.vertAlign = "middle";
	if(isdefined(othertime))
		timer = othertime;
	else
		timer = level.explosiveplanttime;
	watch setClock(timer, time, "hudStopwatch", 64, 64); 
	return watch;
}

objective_is_active(msg)
{
	active = false;
	
	for (i=0;i<level.active_objective.size;i++)
	{
		if (level.active_objective[i] != msg)
			continue;
		active = true;
		break;
	}
	return (active);
}

objective_is_inactive(msg)
{
	inactive = false;
	
	for (i=0;i<level.inactive_objective.size;i++)
	{
		if (level.inactive_objective[i] != msg)
			continue;
		inactive = true;
		break;
	}
	return (inactive);
}

set_objective_inactive(msg)
{
	
	array = [];
	for (i=0;i<level.active_objective.size;i++)
	{
		if (level.active_objective[i] == msg)
			continue;
		array[array.size] = level.active_objective[i];
	}
	level.active_objective = array;
	
	
	
	exists = false;
	for (i=0;i<level.inactive_objective.size;i++)
	{
		if (level.inactive_objective[i] != msg)
			continue;
		exists = true;
	}
	if (!exists)
		level.inactive_objective[level.inactive_objective.size] = msg;
		
	/#
	
	for (i=0;i<level.active_objective.size;i++)
	{
		for (p=0;p<level.inactive_objective.size;p++)
			assertEx(level.active_objective[i] != level.inactive_objective[p], "Objective is both inactive and active");
	}
	#/
}

set_objective_active(msg)
{
	
	array = [];
	for (i=0;i<level.inactive_objective.size;i++)
	{
		if (level.inactive_objective[i] == msg)
			continue;
		array[array.size] = level.inactive_objective[i];
	}
	level.inactive_objective = array;
		
	
	exists = false;
	for (i=0;i<level.active_objective.size;i++)
	{
		if (level.active_objective[i] != msg)
			continue;
		exists = true;
	}
	if (!exists)
		level.active_objective[level.active_objective.size] = msg;
		
	/#
	
	for (i=0;i<level.active_objective.size;i++)
	{
		for (p=0;p<level.inactive_objective.size;p++)
			assertEx(level.active_objective[i] != level.inactive_objective[p], "Objective is both inactive and active");
	}
	#/
}


detect_friendly_fire()
{
	level thread maps\_friendlyfire::detectFriendlyFireOnEntity(self);
}

missionFailedWrapper()
{
	if ( level.missionfailed )
		return;

	
	
	SetSavedDVar( "ai_ChatEnable", "0" );
	level.player PlayLocalSound( "dia_mission_fail_civ" );
	wait( 0.05 );
	SetSavedDVar( "ai_ChatEnable", "1" );

	level.missionfailed = true;	
	missionfailed();
}


script_delay()
{
	startTime = getTime();
	if ( isDefined( self.script_delay ) )
		wait ( self.script_delay );
	else if ( isDefined( self.script_delay_min ) && isDefined( self.script_delay_max ) )
		wait ( randomFloatRange( self.script_delay_min, self.script_delay_max ) );
		
	return ( getTime() - startTime );
}


script_wait()
{
	startTime = getTime();
	if ( isDefined( self.script_wait ) )
	{
		wait (self.script_wait);

		if ( isDefined( self.script_wait_add ) )
			self.script_wait += self.script_wait_add;
	}
	else if ( isDefined( self.script_wait_min ) && isDefined( self.script_wait_max ) )
	{
		wait (randomFloatRange( self.script_wait_min, self.script_wait_max ));

		if ( isDefined( self.script_wait_add ) )
		{
			self.script_wait_min += self.script_wait_add;
			self.script_wait_max += self.script_wait_add;
		}
	}

	return ( getTime() - startTime );
}

guy_enter_vehicle(guy,vehicle)
{
	maps\_vehicle_aianim::guy_enter(guy,vehicle);
}

guy_array_enter_vehicle(guy,vehicle)
{
	maps\_vehicle_aianim::guy_array_enter(guy,vehicle);
}

guy_runtovehicle_load(guy,vehicle)
{
	maps\_vehicle_aianim::guy_runtovehicle(guy,vehicle);
	
}

get_force_color_guys( team, color )
{
	ai = getaiarray( team );
	guys = [];
	for ( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if ( !isdefined( guy.script_forceColor ) )
			continue;
		
		if ( guy.script_forceColor != color )
			continue;
		guys[ guys.size ] = guy;
	}
	
	return guys;
}

get_all_force_color_friendlies()
{
	ai = getaiarray( "allies" );
	guys = [];
	for ( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if ( !isdefined( guy.script_forceColor ) )
			continue;
		guys[ guys.size ] = guy;
	}
	
	return guys;
}

enable_ai_color()
{




}

disable_ai_color()
{







}

clear_force_color()
{
	self disable_ai_color();
	self.script_force_color = undefined;
	/#
	update_debug_friendlycolor( self.ai_number );
	#/
}

check_force_color(_color)
{
	color = level.colorCheckList[tolower(_color)];
	if(isdefined(self.script_forcecolor) && color == self.script_forcecolor)
		return true;
	else
		return false;
}

get_force_color()
{
	color = self.script_forceColor;
	return color;
}

shortenColor( color )
{
	assertEx( isdefined( level.colorCheckList[ tolower( color ) ] ), "Tried to set force color on an undefined color: " + color );
	return level.colorCheckList[ tolower( color ) ];
}


set_force_color( _color )
{





































}

set_force_color_spawner( color )
{





















}

issue_color_orders(color_team, team)
{


























































}

setDifficultyBias( num )
{
	level.difficultyBias = num;
	maps\_gameskill::setCurrentDifficulty();
}


flashRumbleLoop( duration )
{
	goalTime = getTime() + duration * 1000;
	
	while ( getTime() < goalTime )
	{
		level.player PlayRumbleOnEntity( "damage_heavy" );
		wait( 0.05 );
	}
}


flashMonitor()
{
	self endon( "death" );
	
	for(;;)
	{
		level.player waittill( "flashbang", percent_distance, percent_angle, attacker );
	
		if ( "1" == getdvar( "noflash" ) )
			continue;
	
		if ( percent_angle < 0.0 )
			percent_angle = 0.0;
		else if ( percent_angle > 0.8 )
			percent_angle = 1;
	
		if ( (isdefined(attacker)) && (isdefined(attacker.team)) && (attacker.team == "axis") ) 
			seconds = percent_distance * percent_angle * 6.0;
		else
			seconds = percent_distance * percent_angle * 3.0;
	
		if ( seconds < 0.25 )
			continue;
	
		level.player shellshock( "flashbang", seconds );
		
		if ( seconds > 2 )
			thread flashRumbleLoop( 0.75 );
		else
			thread flashRumbleLoop( 0.25 );
	}
}

concMonitor()
{
	self endon( "death" );
	
	for(;;)
	{
		level.player waittill( "MOD_CONCUSSION_GRENADE", percent_distance );

		if ( "1" == getdvar( "noflash" ) )
			continue;
	
		seconds = 4.0 * percent_distance; 
	
		if ( seconds < 0.25 )
			continue;
	
		level.player shellshock( "concussion_grenade_mp", seconds );
		
		if ( seconds > 2 )
			thread flashRumbleLoop( 0.75 );
		else
			thread flashRumbleLoop( 0.25 );
	}
}




registerFXTargetName( targName )
{
	if (!isdefined (level._createFX_events))
		level._createFX_events = [];
		
	level._createFX_events[level._createFX_events.size] = targName;
}



pauseEffect()
{
	self maps\_createfx::update_fx_looper(false);
}

restartEffect()
{
	self maps\_createfx::update_fx_looper(true);
}

createLoopEffect( fxid )
{
	ent = maps\_createfx::createEffect( "loopfx", fxid );
	ent.v["delay"] = 0.5;
	return ent;
}

createOneshotEffect( fxid )
{
	ent = maps\_createfx::createEffect( "oneshotfx", fxid );
	ent.v["delay"] = -15;
	return ent;
}
 

createExploder( fxid )
{
	ent = maps\_createfx::createEffect( "exploder", fxid );
	ent.v["delay"] = 0;
	ent.v["exploder_type"] = "normal";
	return ent;
}

getfxarraybyID( fxid )
{
	array = [];
	for(i=0;i<level.createFXent.size;i++)
	{
		if(level.createFXent[i].v["fxid"] == fxid)
			array[array.size] = level.createFXent[i];
	}
	return array;
}

ignoreAllEnemies( qTrue )
{
	self notify( "ignoreAllEnemies_threaded" );
	self endon( "ignoreAllEnemies_threaded" );
	
	if ( qTrue )
	{
		
		
		
		self.old_threat_bias_group = self getthreatbiasgroup();
		
		num = undefined;
		/#
			num = self getentnum();
			println ( "entity: " + num + "ignoreAllEnemies TRUE" );
			println ( "entity: " + num + " threatbiasgroup is " + self.old_threat_bias_group );
		#/
		
		createthreatbiasgroup( "ignore_everybody" );
		/#
			println ( "entity: " + num + "ignoreAllEnemies TRUE" );
			println ( "entity: " + num + " setthreatbiasgroup( ignore_everybody )" );
		#/
		self setthreatbiasgroup( "ignore_everybody" );
		teams = [];
		teams["axis"] = "allies";
		teams["allies"] = "axis";
		
		assertEx( self.team != "neutral", "Why are you making a guy have team neutral? And also, why is he doing anim_reach?" );
		ai = getaiarray( teams[ self.team ] );
		groups = [];
		for ( i=0; i<ai.size; i++)
			groups[ ai[i] getthreatbiasgroup() ] = true;
	
		keys = getarraykeys( groups );
		for ( i=0; i<keys.size; i++ )
		{
			/#
				println ( "entity: " + num + "ignoreAllEnemies TRUE" );
				println ( "entity: " + num + " setthreatbias( " + keys[i] + ",ignore_everybody, 0 )" );
			#/
			setthreatbias( keys[i], "ignore_everybody", 0 );
		}
			
		
	}
	else
	{
		num = undefined;
		assertEx( isdefined( self.old_threat_bias_group ), "You can't use ignoreAllEnemies(false) on an AI that has never ran ignoreAllEnemies(true)" );
		/#
			num = self getentnum();
			println ( "entity: " + num + "ignoreAllEnemies FALSE" );
			println ( "entity: " + num + " self.old_threat_bias_group is " +  self.old_threat_bias_group );
		#/
		if ( self.old_threat_bias_group != "" )
		{
			/#
				println ( "entity: " + num + "ignoreAllEnemies FALSE" );
				println ( "entity: " + num + " setthreatbiasgroup( " + self.old_threat_bias_group + " )" );
			#/
			self setthreatbiasgroup( self.old_threat_bias_group );
		}
		self.old_threat_bias_group = undefined;
	}
}

vehicle_detachfrompath()
{
	maps\_vehicle::vehicle_pathdetach();
}

vehicle_resumepath()
{
	maps\_vehicle::vehicle_resumepathvehicle();
}

vehicle_land()
{
	maps\_vehicle::vehicle_landvehicle();
}

vehicle_liftoff(height)
{
	maps\_vehicle::vehicle_liftoffvehicle(height);
}

vehicle_dynamicpath(node,bwaitforstart)
{
	maps\_vehicle::vehicle_dynamicpathsvehicle(node,bwaitforstart);
}


groundpos(origin)
{
	return bullettrace(origin, (origin + (0,0,-100000)),0,self)["position"];
}

change_player_health_packets( num )
{
	level.player_health_packets += num;
	level notify( "update_health_packets" );

	if ( level.player_health_packets >= 3 )
		level.player_health_packets = 3;



}

getvehiclespawner(targetname)
{
	spawner = getent(targetname+"_vehiclespawner","targetname");
	return spawner;
}

getvehiclespawnerarray(targetname)
{
	spawner = getentarray(targetname+"_vehiclespawner","targetname");
	return spawner;
}

player_fudge_moveto ( dest,moverate )
{
	
	if(!isdefined(moverate))
		moverate = 200;
	
	
	org = spawn("script_origin",level.player.origin);
	org.origin = level.player.origin;
	level.player linkto (org);
	dist = distance(level.player.origin,dest);
	movetime = dist/moverate;
	org moveto (dest,dist/moverate, .05,.05);
	wait movetime;
	level.player unlink();
}


add_start( msg, func )
{
	assertEx( !isdefined( level._loadStarted ), "Can't create starts after _load" );
	if ( !isdefined( level.start_functions ) )
		level.start_functions = [];

	level.start_functions[ msg ] = func;
}

default_start( func )
{
	level.default_start = func;
}

linetime( start, end, color, timer )
{
	thread linetime_proc( start, end, color, timer );
}

within_fov( start_origin, start_angles, end_origin, fov )
{
	normal = vectorNormalize( end_origin - start_origin );
	forward = anglestoforward( start_angles );
	dot = vectorDot( forward, normal );

	return dot >= fov;
}

waitSpread( start, end )
{
	if ( !isdefined( end ) )
	{
		end = start;
		start = 0;
	}
	assertEx( isdefined( start ) && isdefined( end ), "Waitspread was called without defining amount of time" );
	
	personal_wait_index = undefined;
	
	if ( !isdefined( level.active_wait_spread ) )
	{
		
		
		level.active_wait_spread = true;
		level.wait_spreaders = 0;
		personal_wait_index = level.wait_spreaders;
		level.wait_spreaders++;
		thread waitSpread_code( start, end );
	}
	else
	{
		personal_wait_index = level.wait_spreaders;
		level.wait_spreaders++;
		waittillframeend; 
	}

	waittillframeend; 
	
	wait( level.wait_spreader_allotment[ personal_wait_index ] );	
	
}

radio_dialogue( msg )
{
	assertEX( isdefined( level.scr_radio[ msg ] ), "Tried to play radio dialogue " + msg + " that did not exist! Add it to level.scr_radio" );
	play_sound_in_space ( level.scr_radio[ msg ], level.player.origin );
}


hint_create(text, background)
{
	struct = spawnstruct();
	if(isdefined(background) && background == true)
		struct.bg = newHudElem();
	struct.elm = newHudElem();
	
	struct hint_position_internal();
	
	
	struct.elm settext(text);

	return struct;
}

hint_delete()
{
	self notify("death");
	
	if(isdefined(self.elm))
		self.elm destroy();
	if(isdefined(self.bg))
		self.bg destroy();
}

hint_position_internal()
{
	if(level.xenon)
		self.elm.fontScale = 2;
	else
		self.elm.fontScale = 1.6;
		
	self.elm.x 			= 0;
	self.elm.y		 	= -40;
	self.elm.alignX 	= "center";
	self.elm.alignY 	= "bottom";	
	self.elm.horzAlign 	= "center";
	self.elm.vertAlign 	= "middle";
	
	if(!isdefined(self.bg))
		return;
		
	self.bg.x 			= 0;
	self.bg.y 			= -40;
	self.bg.alignX 		= "center";
	self.bg.alignY 		= "middle";
	self.bg.horzAlign 	= "center";
	self.bg.vertAlign 	= "middle";
	
	if(level.xenon)
		self.bg setshader("popmenu_bg", 650, 52);
	else
		self.bg setshader("popmenu_bg", 650, 42);
	self.bg.alpha = .5;
}

string( num )
{
	return ( "" + num );
}

ignoreEachOther( group1, group2 )
{
	
	assertEx( threatbiasgroupexists( group1 ), "Tried to make threatbias group " + group1 + " ignore " + group2 + " but " + group1 + " does not exist!" );
	assertEx( threatbiasgroupexists( group2 ), "Tried to make threatbias group " + group2 + " ignore " + group1 + " but " + group2 + " does not exist!" );
	setIgnoreMeGroup( group1, group2 );
	setIgnoreMeGroup( group2, group1 );
}

add_spawn_function( function, param1, param2, param3 )
{
	assertEx( isdefined( self.spawn_functions ), "Tried to add_spawn_function before calling _load" );
	
	func = [];
	func[ "function" ] = function;
	func[ "param1" ] = param1;
	func[ "param2" ] = param2;
	func[ "param3" ] = param3;
	
	self.spawn_functions[ self.spawn_functions.size ] = func;
}

array_delete( array )
{
	for ( i=0; i < array.size; i++ )
	{
		array[ i ] delete();
	}
}


PlayerUnlimitedAmmoThread()
{
	while (1)
	{
		wait 5;

		currentWeapon = level.player getCurrentWeapon();
		if ( currentWeapon == "none" )
			continue;

		currentAmmo = level.player GetFractionMaxAmmo( currentWeapon );
		if ( currentAmmo < 0.2 )
			level.player GiveMaxAmmo( currentWeapon );
	}
}

PlayerUnlimitedGrenadesThread(grenadeType)
{
	while (1)
	{
		wait 5;

		if( level.player HasWeapon(grenadeType) )
		{
			currentAmmo = level.player GetFractionMaxAmmo(grenadeType);
			if ( currentAmmo < 0.2 )
				level.player GiveMaxAmmo(grenadeType);
		}
	}
}

ignore_triggers( timer )
{
	
	self endon( "death" );
	self.ignoreTriggers = true;
	if ( isdefined( timer ) )
	{
		wait( timer );
	}
	else
	{
		wait( 0.5 );
	}
	self.ignoreTriggers = false;
}

delayThread( func, timer, param1, param2, param3 )
{
	
	thread delayThread_proc( func, timer, param1, param2, param3 );
}

delayThread_proc( func, timer, param1, param2, param3 )
{
	self endon( "death" );
	wait( timer );
	if ( isdefined( param3 ) )
		thread [[ func ]]( param1, param2, param3 );
	else
	if ( isdefined( param2 ) )
		thread [[ func ]]( param1, param2 );
	else
	if ( isdefined( param1 ) )
		thread [[ func ]]( param1 );
	else
		thread [[ func ]]();
}

activate_trigger_with_targetname( msg )
{
	trigger = getent( msg, "targetname" );
	trigger notify( "trigger" );
}

is_hero()
{
	return isdefined( level.hero_list[ get_ai_number() ] );
}

get_ai_number()
{
	if ( !isdefined( self.ai_number ) )
	{
		set_ai_number();
	}
	return self.ai_number;
}

set_ai_number()
{
	self.ai_number = level.ai_number;
	level.ai_number++;
}

make_hero()
{
	level.hero_list[ self.ai_number ] = true;
}

unmake_hero()
{
	level.hero_list[ self.ai_number ] = undefined;
}

get_heroes()
{
	array = [];
	ai = getaiarray( "allies" );
	for ( i=0; i < ai.size; i++ )
	{
		if ( ai[ i ] is_hero() )
			array[ array.size ] = ai[ i ];
	}
	return array;
}

set_team_pacifist( team, val )
{
	ai = getaiarray( team );
	for ( i=0; i < ai.size; i++ )
	{
		ai[ i ].pacifist = val;
	}
}

replace_on_death()
{

}

spawn_reinforcement( classname )
{

}

clear_promotion_order()
{
	level.current_color_order = [];
}

set_promotion_order( deadguy, replacer )
{
	if ( !isdefined( level.current_color_order ) )
	{
		level.current_color_order = [];
	}

	deadguy = shortenColor( deadguy );
	replacer = shortenColor( replacer );
	
	level.current_color_order[ deadguy ] = replacer;
	
	
	
	
	if ( !isdefined( level.current_color_order[ replacer ] ) )
		set_empty_promotion_order( replacer );
}

set_empty_promotion_order( deadguy )
{
	if ( !isdefined( level.current_color_order ) )
	{
		level.current_color_order = [];
	}

	level.current_color_order[ deadguy ] = "none";
}

remove_dead_from_array( array )
{
	newarray = [];
	for ( i=0; i < array.size; i++ )
	{
		if ( !isalive( array[ i ] ) )
			continue;
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

remove_heroes_from_array( array )
{
	newarray = [];
	for ( i=0; i < array.size; i++ )
	{
		if ( array[ i ] is_hero() )
			continue;
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

get_closest_colored_friendly( color, origin )
{
	allies = get_force_color_guys( "allies", color );
	allies = remove_heroes_from_array( allies );

	if ( !isdefined( origin ) )
		friendly_origin = level.player.origin;
	else
		friendly_origin = origin;

	return getclosest( friendly_origin, allies );
}

remove_ai_without_classname( array, classname )
{
	newarray = [];
	for ( i=0; i < array.size; i++ )
	{
		if ( !issubstr( array[ i ].classname, classname ) )
			continue;
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

get_closest_colored_friendly_with_classname( color, classname, origin )
{
	allies = get_force_color_guys( "allies", color );
	allies = remove_heroes_from_array( allies );

	if ( !isdefined( origin ) )
		friendly_origin = level.player.origin;
	else
		friendly_origin = origin;
		
	allies = remove_ai_without_classname( allies, classname );

	return getclosest( friendly_origin, allies );
}



promote_nearest_friendly( colorFrom, colorTo )
{
	for ( ;; )
	{
		friendly = get_closest_colored_friendly( colorFrom );
		if ( !isalive( friendly ) )
		{
			wait( 1 );
			continue;
		}
		
		friendly set_force_color( colorTo );
		return;
	}
}

instantly_promote_nearest_friendly( colorFrom, colorTo )
{
	for ( ;; )
	{
		friendly = get_closest_colored_friendly( colorFrom );
		if ( !isalive( friendly ) )
		{
			assertEx( 0, "Instant promotion from " + colorFrom + " to " + colorTo + " failed!" );
			return;
		}
		
		friendly set_force_color( colorTo );
		return;
	}
}

instantly_promote_nearest_friendly_with_classname( colorFrom, colorTo, classname )
{
	for ( ;; )
	{
		friendly = get_closest_colored_friendly_with_classname( colorFrom, classname );
		if ( !isalive( friendly ) )
		{
			assertEx( 0, "Instant promotion from " + colorFrom + " to " + colorTo + " failed!" );
			return;
		}
		
		friendly set_force_color( colorTo );
		return;
	}
}

instantly_set_color_from_array_with_classname( array, color, classname )
{
	
	foundGuy = false;
	newArray = [];
	for ( i=0; i < array.size; i++ )
	{
		guy = array[ i ];
		if ( foundGuy || !isSubstr( guy.classname, classname ) )
		{
			newArray[ newArray.size ] = guy;
			continue;
		}

		foundGuy = true;
		guy set_force_color( color );
	}
	return newArray;
}

wait_for_script_noteworthy_trigger( msg )
{	
	wait_for_trigger( msg, "script_noteworthy" );
}

wait_for_targetname_trigger( msg )
{	
	wait_for_trigger( msg, "targetname" );
}

wait_for_flag_or_timeout( msg, timer )
{
	if ( flag( msg ) )
		return;
		
	ent = spawnStruct();
	ent thread ent_waits_for_level_notify( msg );
	ent thread ent_times_out( timer );
	ent waittill( "done" );
}

wait_for_trigger_or_timeout( timer )
{
	ent = spawnStruct();
	ent thread ent_waits_for_trigger( self );
	ent thread ent_times_out( timer );
	ent waittill( "done" );
}

wait_for_either_trigger( msg1, msg2 )
{	
	ent = spawnStruct();
	array = [];
	array = array_combine( array, getentarray( msg1, "targetname" ) );
	array = array_combine( array, getentarray( msg2, "targetname" ) );
	for ( i = 0; i < array.size; i++ )
	{
		ent thread ent_waits_for_trigger( array[ i ] );
	}

	ent waittill( "done" );
}

script_gen_dump_addline ( string,signature )
{
	if(!isdefined(level.script_gen_dump[signature]))
		level.script_gen_dump_reasons[level.script_gen_dump_reasons.size] = "Added: "+string; 
	level.script_gen_dump[signature] = string;
	level.script_gen_dump2[signature] = string; 
}

dronespawn ( spawner )
{
	spawner = maps\_spawner::spawner_dronespawn(spawner);
	assert(isdefined(spawner));
	return spawner;
}

makerealai ( drone )
{
	return maps\_spawner::spawner_makerealai(drone);
	
}


get_trigger_flag()
{
	if ( isdefined( self.script_flag ) )
	{
		return self.script_flag;
	}
	
	if ( isdefined( self.script_noteworthy ) )
	{
		return self.script_noteworthy;
	}
	
	assertEx( 0, "Flag trigger at " + self.origin + " has no script_flag set." );
}

isSpawner()
{
	spawners = getspawnerarray();
	for ( i=0; i < spawners.size; i++ )
	{
		if ( spawners[ i ] == self )
			return true;
	}
	return false;
}

set_default_pathenemy_settings()
{
	if ( self.team == "allies" )
	{
		self.pathEnemyLookAhead = 350;
		self.pathEnemyFightDist = 350;
		return;
	}
	if ( self.team == "axis" )
	{
		self.pathEnemyLookAhead = 350;
		self.pathEnemyFightDist = 350;
		return;
	}
}

cqb_walk( on_or_off ) 
{
	if( on_or_off == "on" )
	{
		self enable_cqbwalk();
	}
	else
	{
		assert( on_or_off == "off" );
		self disable_cqbwalk();
	}
}
enable_cqbwalk()
{
	self.cqbwalking = true;
	level thread animscripts\shared::findCQBPointsOfInterest();
	 /#
	self thread animscripts\shared::CQBDebug();
	#/ 
}
disable_cqbwalk()
{
	self.cqbwalking = false;
	self.cqb_point_of_interest = undefined;
}

cqb_aim( the_target )
{
	if( !isdefined( the_target ) )
	{
		self.cqb_target = undefined;
	}
	else
	{
		self.cqb_target = the_target;	
		
		if( !isdefined( the_target.origin ) )
			assertmsg( "target passed into cqb_aim does not have an origin!" );
	}
}


set_force_cover( val )
{
	assertEx( val == "hide" || val == "none" || val == "show", "invalid force cover set on guy" );
	assertEx( isalive( self ), "Tried to set force cover on a dead guy" );
	self.a.forced_cover = val;
}

waittill_notify_or_timeout( msg, timer )
{
	self endon( msg );
	wait( timer );
}

do_in_order( func1, param1, func2, param2 )
{
	[[ func1 ]]( param1 );
	[[ func2 ]]( param2 );
}

scrub()
{
	
	self maps\_spawner::scrub_guy();
}
send_notify( msg )
{
	
	self notify( msg );
}

deleteEnt( ent )
{
	
	ent delete();
}


getfx( fx )
{
	assertEx( isdefined( level._effect[ fx ] ), "Fx " + fx + " is not defined in level._effect." );
	return level._effect[ fx ];
}

getanim( anime )
{
	assertEx( isdefined( self.animname ), "Called getanim on a guy with no animname" );
	assertEx( isdefined( level.scr_anim[ self.animname ][ anime ] ), "Called getanim on an inexistent anim" );
	return level.scr_anim[ self.animname ][ anime ];
}

add_hint_string( name, string, optionalFunc )
{
	assertex( isdefined( level.trigger_hint_string ), "Tried to add a hint string before _load was called." );
	assertEx( isdefined( name ), "Set a name for the hint string. This should be the same as the script_hint on the trigger_hint." );
	assertEx( isdefined( string ), "Set a string for the hint string. This is the string you want to appear when the trigger is hit." );
		
	level.trigger_hint_string[ name ] = string;
	if ( isdefined( optionalFunc ) )
	{
		level.trigger_hint_func[ name ] = optionalFunc;
	}
}

fire_radius( origin, radius )
{
	/#
	if ( level.createFX_enabled )
		return;
	#/
	
	trigger = spawn( "trigger_radius", origin, 0, radius, 48 );

	for ( ;; )
	{
		trigger waittill( "trigger", other );
		assertEx( other == level.player, "Tried to burn a non player in a fire" );
		level.player dodamage( 5, origin );
	}
}

clearThreatBias( group1, group2 )
{
	setThreatBias( group1, group2, 0 );
	setThreatBias( group2, group1, 0 );
}







set_goal_node(node)
{
	self SetGoalNode(node);
	if (IsDefined(node.script_noteworthy))
	{
		self thread trigger_node(node);
	}
}

trigger_node(node)
{
	self endon("death");
	self waittill("goal");
	node notify("trigger", self);
}



#using_animtree("generic_human");




player_can_see(e, dot_override)
{
	eye = level.player GetEye();	

	
	
	

	dot = VectorDot(AnglesToForward(level.player GetViewAngles()), VectorNormalize(e.origin - eye));

	dot_compare = .6;
	if (IsDefined(dot_override))
	{
		dot_compare = dot_override;
	}

	if ((dot > dot_compare) && SightTracePassed(eye, e.origin, false, e))		
	{
		return true;
	}

	return false;
}












player_anim_doorbash( sAnim, entOrigin, fDelay )
{


	
	if( IsDefined( entOrigin ) )
	{
		level.player FreezeControls( true );
		level.player SetOrigin( entOrigin.origin );
		level.player SetPlayerAngles( entOrigin.angles );
		wait( 0.05 );
		level.player FreezeControls( false );

		level.player playerAnimScriptEvent( sAnim );
	}
	else
	{
		level.player playerAnimScriptEvent( sAnim );
	}

	
	iCameraID = level.player CustomCamera_Push(
												"entity",     
												level.player,      
												level.player,     
												(-120, 0, 100),              
												(-25, 0, 0),            
												0.05,         
												0.05, 
												0.05 
											);

	
	
	
	
	
	
	
	
	
	

	
	level.player waittillmatch( "anim_notetrack", "door_impact" );

	
	level.player CustomCamera_Change(
										iCameraID,         
										"entity",     
										level.player,      
										level.player,     
										(120, 0, 100),              
										(-25, 0, 0),            
										0.05,         
										0.05, 
										0.05 
									);

	
	level.player waittillmatch( "anim_notetrack", "end" );
	level.player CustomCamera_Pop( 
									iCameraID,
									0.05,
									0.05,
									0.05
									);
}













health_regen_suspend()
{
	
	level._healthregen = false;
}

health_regen_resume()
{
	
	level._healthregen = true;
}









delete_over_time( fDelay )
{
	
	if( !IsDefined(fDelay) || ( fDelay <= 0.0 ) )
	{
		fDelay = 3;
	}

	
	if( IsDefined( self ) )
	{
		wait( fDelay );
	}
	else
	{
		return;
	}


	
	if( IsDefined( self ) )
	{
		self SetCanDamage( false );
		self MoveTo(self.origin - (0,0,100), 7);
	}
	else
	{
		return;
	}
	self waittill( "movedone" );

	
	if( IsDefined( self ) )
	{
		self Delete();
	}
	else
	{
		return;
	}
}













dodamage_overttime( iDmg, vPos, fTime, entAttacker, entInflictor )
{
	
	iTimeTick = int( fTime/0.15 ) + 1;
	iDmgTick = int( iDmg/iTimeTick ) +1;

	
	for( i = 0; i < iTimeTick; i++ )
	{
		
		if( !IsDefined( self ) )
		{
			return;
		}
		
		
		self DoDamage( iDmgTick, vPos, entAttacker, entInflictor );
		wait( 0.15 );
	}
}













radiusdamage_overtime( vPos, iRadius, iDmgMax, iDmgMin, fTime, entAttacker )
{
	
	iTimeTick = int( fTime/0.15 ) + 1;
	iDmgTickMax = int( iDmgMax/iTimeTick ) +1;
	iDmgTickMin = int( iDmgMin/iTimeTick ) +1;

	
	for( i = 0; i < iTimeTick; i++ )
	{
		
		if( IsDefined( vPos ) )
		{
			
			self RadiusDamage( vPos, iRadius, iDmgTickMax, iDmgTickMin, entAttacker );
		}
		else
		{
			
			self RadiusDamage( self.origin, iRadius, iDmgTickMax, iDmgTickMin, entAttacker );
		}
		wait( 0.15 );
	}
}












damagetouch_overtime( iDmg, vPos, fTime, entTrig, entAttacker, entInflictor )
{
	
	iTimeTick = int( fTime/0.15 ) + 1;
	iDmgTick = int( iDmg/iTimeTick ) +1;

	
	for( i = 0; i < iTimeTick; i++ )
	{
		
		if( !IsDefined( self ) || !IsDefined( entTrig ) )
		{
			return;
		}

		
		if( self IsTouching( entTrig ) )
		{
			self DoDamage( iDmgTick, vPos, entAttacker, entInflictor );
		}

		wait( 0.15 );
	}
}








vector_random( iX, iY, iZ )
{
	iTempX = RandomInt( iX );
	iTempY = RandomInt( iY );
	iTempZ = RandomInt( iZ );

	if( RandomInt(2) )
	{
		iTempX = iTempX * (-1);
	}
	if( RandomInt(2) )
	{
		iTempY = iTempY * (-1);
	}
	if( RandomInt(2) )
	{
		iTempZ = iTempZ * (-1);
	}

	vecTemp = ( iTempX, iTempY, iTempZ );

	return vecTemp;
}













disp_engagement_dist()
{
	
	level endon( "stop_disp_engagement_dist" );

	
	while( true )
	{
		
		if( GetDVarInt( "ai_showdist" ) == 1 )
		{		
			
			entaTemp = GetAIArray( "axis", "allies", "neutral" );

			
			for( i = 0; i < entaTemp.size; i++ )
			{
				entaTemp[i] thread disp_dist_txt();
			}
		}

		
		wait( 0.1 );
	}
}


disp_dist_txt()
{
	
	fDist = Distance( self.origin, level.player.origin );

	
	if( fDist < 601 )
	{
		Print3d( self.origin + (0, 0, 64), fDist, (0, 1, 0), 1, 1, 2 );
		return;
	}
	if( fDist < 901 )
	{
		Print3d( self.origin + (0, 0, 64), fDist, (1, 1, 0), 1, 1.4, 2 );
	}
	else
	{
		Print3d( self.origin + (0, 0, 64), fDist, (1, 0, 0), 1, 2, 2 );
	}
}


disp_engagement_dist_stop()
{
	
	level notify( "stop_match_speed" );
}



interaction_notetrack_sound_thread( notetrack, alias, repeating )
{
	self endon( "death" );
	
	for ( ;; )
	{
		self waittillmatch( "anim_notetrack", notetrack );
		
		self playsound( alias );
		
		if ( !repeating )
		{
			break;
		}
	}
}

interaction_add_notetrack_sound( notetrack, alias, ent )
{
	ent thread interaction_notetrack_sound_thread( notetrack, alias, false );
}

interaction_add_repeating_notetrack_sound( notetrack, alias, ent )
{
	ent thread interaction_notetrack_sound_thread( notetrack, alias, true );
}







fade_out_black( fTime, bFreeze, bFadeWait )
{
	
	if( !IsDefined( fTime ) )
	{
		fTime = 1.5;
	}
	if( !IsDefined( bFreeze ) )
	{
		bFreeze = false;
	}
	if( !IsDefined( bFadeWait ) )
	{
		bFadeWait = false;
	}

	
	hudBlack = newHudElem();
	hudBlack.x = 0;
	hudBlack.y = 0;
	hudBlack.horzAlign = "fullscreen";
	hudBlack.vertAlign = "fullscreen";
	
	hudBlack.sort = 0;
	hudBlack.alpha = 1;
	hudBlack setShader("black", 640, 480);

	if( bFadeWait )
	{
		wait( 0.05 );
	}
	
	
	hudBlack fadeOverTime(fTime); 
	hudBlack.alpha = 0;

	
	if( bFreeze )
	{
		level.player freezeControls(true);
	}

	
	wait( fTime );
	if( bFreeze )
	{
		level.player freezeControls(false);
	}
	hudBlack Destroy();
}

fade_in_black( fTime, bFreeze, bFadeWait )
{
	
	if( !IsDefined( fTime ) )
	{
		fTime = 1.5;
	}
	if( !IsDefined( bFreeze ) )
	{
		bFreeze = false;
	}
	if( !IsDefined( bFadeWait ) )
	{
		bFadeWait = false;
	}

	
	hudBlack = newHudElem();
	hudBlack.x = 0;
	hudBlack.y = 0;
	hudBlack.horzAlign = "fullscreen";
	hudBlack.vertAlign = "fullscreen";
	
	hudBlack.sort = 0;
	hudBlack.alpha = 0;
	hudBlack setShader("black", 640, 480);

	if( bFadeWait )
	{
		wait( 0.05 );
	}

	
	hudBlack fadeOverTime(fTime); 
	hudBlack.alpha = 1;

	
	if( bFreeze )
	{
		level.player freezeControls(true);
	}

	
	wait( fTime );
	if( bFreeze )
	{
		level.player freezeControls(false);
	}
	hudBlack Destroy();
}




call_function(func, ent, param1, param2, param3)
{
	if (!IsDefined(ent))
	{
		ent = self;
	}

	if (IsDefined(param3))
	{
		ent [[ func ]](param1, param2, param3);
	}
	else if (IsDefined(param2))
	{
		ent [[ func ]](param1, param2);
	}
	else if (IsDefined(param1))
	{
		ent [[ func ]](param1);
	}
	else
	{
		ent [[ func ]]();
	}
}









letterbox_on( take_weapons, allow_look, time, playerstick )
{
	
	
	setDvar("ui_hud_showstanceicon","0");
	setsaveddvar("ammocounterhide", "1");
	setdvar("ui_hud_showcompass", "0");

	if ( !IsDefined(take_weapons) )
	{
		
		if ( IsDefined(level.player.weapons_holstered) && level.player.weapons_holstered )
		{
			take_weapons = false;
		}
		else
		{
			take_weapons = true;
		}
	}
	if ( !IsDefined(allow_look) )
	{
		allow_look = true;
	}
	if ( !IsDefined(time) )
	{
		time = 1.0;
	}
	if( !IsDefined( playerstick ) )
	{
		playerstick = false;	
	}

	level.player SetCanDamage(false);

	




	




	if ( take_weapons )
	{
		level.player DisableWeapons();
		level.player._letterbox_took_weapons = true;
	}

	if( playerstick )
	{
		player_stick( allow_look );
	}

		
		SetDVar("r_pipMainMode", 1);	
		SetDVar("r_pip1Anchor", 4);		
	
		
		setdvar("cg_pipmain_border", 2);
		setdvar("cg_pipmain_border_color", "0 0 0.2 1");
	
		
		SetDVar("r_pip1Scale", "1 1 1 0");		
		
		level.player animatepip( 1000, 1, -1, -1, 1, 0.8, 1, 0);
		wait(1);

	level notify( "letterbox_on_done" );
}






letterbox_off( give_weapons, time )
{
	if ( !IsDefined(give_weapons) )
	{
		
		if ( IsDefined(level.player._letterbox_took_weapons) && level.player._letterbox_took_weapons )
		{
			give_weapons = true;
		}
		else
		{
			give_weapons = false;
		}
	}
	if ( !IsDefined(time) )
	{
		time = 1.0;
	}

	level.player SetCanDamage(true);








	level.player animatepip( 1000, 1, -1, -1, 1, 1, 1, 0);
	
	if ( give_weapons )
	{
		level.player EnableWeapons();
	}
	level notify( "restore_weapons" );	
	player_unstick();
	wait(0.05);
	level notify( "letterbox_off_done" );


	wait( time + 0.5 );
	
	setDvar("ui_hud_showstanceicon","1");
	setsaveddvar("ammocounterhide", "0");
	setdvar("ui_hud_showcompass", "1");

	SetDVar("r_pipMainMode", 0);	






}





letterbox_movement( on, time, thickness, width, draw2d )
{
	if( !IsDefined( level.letterbox1 ) || !IsDefined( level.letterbox2 ) )
	{
		return;
	}

	if( !IsDefined(draw2d) )
	{
		draw2d = true;
	}

	wait(0.05);

	if( draw2d )
	{
		SetSavedDVar( "cg_draw2d", "1" );
	}
	else
	{
		SetSavedDVar( "cg_draw2d", "0" );
	}

	if( IsDefined( time ) && time > 0 )
	{
		letterbox_size = 0;
		current_time = 0;
		if( on )
		{
			
			while( current_time < time )
			{
				current_time += 0.05;

				letterbox_size = int(current_time / time * thickness);
				if( letterbox_size > 0 )
				{
					if( IsDefined( level.letterbox1 ) )
						level.letterbox1 SetShader( "black", width, letterbox_size );
				}

				level.letterbox2.y = 480 - letterbox_size;

				wait(0.05);
			}
		}
		else
		{
			
			while( current_time < time )
			{
				current_time += 0.05;

				letterbox_size = int(( 1 - ( current_time / time ) ) * thickness);
				if( letterbox_size > 0 )
				{
					if( IsDefined( level.letterbox1 ) )
						level.letterbox1 SetShader( "black", width, letterbox_size );
				}

				level.letterbox2.y = 480 - letterbox_size;

				wait(0.05);
			}

			
			if( IsDefined( level.letterbox1 ) )
			{
				level.letterbox1 Destroy();
			}
			if( IsDefined( level.letterbox2 ) )
			{
				level.letterbox2 Destroy();
			}
		}
	}
}





player_stick( can_look )
{
	if ( IsDefined(level.sticky_origin) )
	{
/# 
		println( "Player is already stuck" );
#/
		return;
	}

	level.sticky_origin = Spawn("script_origin", level.player.origin);
	
	level.sticky_origin.angles = level.player.angles;

	if ( IsDefined(can_look) && can_look )
	{
		level.player PlayerLinkToDelta(level.sticky_origin);
	}
	else
	{
		level.player PlayerLinkToAbsolute(level.sticky_origin);
	}
}




player_unstick()
{
	if ( !IsDefined(level.sticky_origin) )
	{
/# 
		println( "Player has not been stuck yet" );
#/
		return;
	}

	level.player Unlink();
	level.sticky_origin delete();
	level.sitcky_origin = undefined;
}







holster_weapons()
{
	if(!isdefined(level.player.weapons_holstered))
	    level.player.weapons_holstered = false;

	if (level.player.weapons_holstered == true)
	    return;
		
	level.player.weapons_holstered = true;
	level notify("weapons_holstered");

	level.player disableweapons();
}

unholster_weapons()
{
	if(!isdefined(level.player.weapons_holstered))
	    level.player.weapons_holstered = false;

	if (level.player.weapons_holstered == false)
	    return;
	    
	level.player.weapons_holstered = false;
	level notify("weapons_unholstered");

	level.player enableweapons();
}





scrub_zone(zone_name, scrub_ai, scrub_spawners, string_value, string_key)
{
	if (IsDefined(scrub_ai))
	{
		scrub_ai = true;					
	}
	
	if (IsDefined(scrub_spawners))
	{
		scrub_spawners = true;				
	}
	
	zone = GetEnt(zone_name, "script_noteworthy");	
	if (IsDefined(zone))
	{
		if (scrub_ai)
		{
			ai = GetAIArray("axis", "allies", "neutral");
			for (i = 0; i < ai.size; i++)
			{
				if (IsAlive(ai[i]) && (ai[i] IsTouching(zone)))
				{
					ai[i] delete();
				}
			}
		}
		
		if (scrub_spawners)
		{
			spawners = GetSpawnerArray();
			for (i = 0; i < spawners.size; i++)
			{
				if (spawners[i] IsTouching(zone))
				{
					spawners[i] delete();
				}
			}
		}
		
		if (IsDefined(string_value))
		{
			if (!IsDefined(string_key))
			{
				string_key = "targetname";
			}
			
			ents = GetEntArray(string_value, string_key);
			for (i = 0; i < ents.size; i++)
			{
				if (ents[i] IsTouching(zone))
				{
					ents[i] delete();
				}
			}						
		}
	}
	else
	{
		assertmsg("Trying to scrub undefined zone: " + zone_name);
	}
}








 
gun_remove()
{
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );
	
	self.dropweapon = false; 
}

  
gun_recall()
{
	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}

 
beam_monitor()
{
	self endon("death");

	level.player.beam_active = 0;
	level.player.beam_fallen = 0;
	level.player.beam_holstered = 0;
	while(1)
	{
		self waittill("beam",notice);
		if(notice == "begin")
		{
			
			level.player.beam_active = 1;
			level.player.beam_fallen = 0;
			level.player.beam_holstered = 0;
		}
		if(notice == "fall")
		{
			
			level.player.beam_fallen = 1;
			if ( IsDefined(level.player.weapons_holstered) && !level.player.weapons_holstered )
			{
				holster_weapons();
				level.player.beam_holstered = 1;
			}
			self thread beam_timed_death();
		}
		if(notice == "abort")
		{
			
			if ( level.player.beam_fallen == 1 )
			{
				
				level.player.beam_fallen = 0;
				if ( level.player.beam_holstered == 1 )
				{
					unholster_weapons();
					level.player.beam_holstered = 0;
				}
			}
		}
		if(notice == "end")
		{
			
			if ( level.player.beam_active == 1 )
			{
				
				if ( level.player.beam_fallen == 1 )
				{
					
					beam_death();
				}

				level.player.beam_active = 0;
			}
		}
	}
}

beam_timed_death()
{
	self endon("death");

	
	wait( 0.5 );

	
	if ( level.player.beam_active == 1 )
	{
		
		if ( level.player.beam_fallen == 1 )
		{
			
			beam_death();
		}
	}
}

beam_death()
{
	level.player DoDamage( 500, ( 0, 0, 0 ) );
	level.player.beam_active = 0;
}

 
ledge_monitor()
{
	self endon("death");

	level.player.ledge_active = 0;
	level.player.ledge_fallen = 0;
	level.player.ledge_holstered = 0;
	while(1)
	{
		self waittill("ledge",notice);
		if(notice == "begin")
		{
			
			level.player.ledge_active = 1;
			level.player.ledge_fallen = 0;
			level.player.ledge_holstered = 0;
		}
		if(notice == "fall")
		{
			
			level.player.ledge_fallen = 1;
			if ( IsDefined(level.player.weapons_holstered) && !level.player.weapons_holstered )
			{
				holster_weapons();
				level.player.ledge_holstered = 1;
			}
			self thread ledge_timed_death();
		}
		if(notice == "abort")
		{
			
			if ( level.player.ledge_fallen == 1 )
			{
				
				level.player.ledge_fallen = 0;
				if ( level.player.ledge_holstered == 1 )
				{
					unholster_weapons();
					level.player.ledge_holstered = 0;
				}
			}
		}
		if(notice == "end")
		{
			
			if ( level.player.ledge_active == 1 )
			{
				
				if ( level.player.ledge_fallen == 1 )
				{
					
					ledge_death();
				}

				level.player.ledge_active = 0;
			}
		}
	}
}

ledge_timed_death()
{
	self endon("death");

	
	wait( 0.5 );

	
	if ( level.player.ledge_active == 1 )
	{
		
		if ( level.player.ledge_fallen == 1 )
		{
			
			ledge_death();
		}
	}
}

ledge_death()
{
	level.player DoDamage( 500, ( 0, 0, 0 ) );
	level.player.ledge_active = 0;
}




light_flicker(bool_flicker, intensity_min, intensity_max, sound_name, sound_length)
{
	if (!IsDefined(self.light_intensity_start))
	{
		self.light_intensity_start = self GetLightIntensity();
	}

	if (!IsDefined(intensity_min))
	{
		intensity_min = 0;
	}

	if (!IsDefined(intensity_max))
	{
		intensity_max = self.light_intensity_start;
	}

	if ((IsDefined(bool_flicker)) && (!bool_flicker))
	{
		self notify("stop_light_flicker");
		wait .05;
		self SetLightIntensity(intensity_min);
	}
	else
	{
		self endon("stop_light_flicker");

		if (!IsDefined(sound_length))
		{
			sound_length = 2.0;	
		}
		t = sound_length;

		while (true)
		{
			if (IsDefined(sound_name))
			{
				if (t >= sound_length)
				{
					self playsound(sound_name);
					t = 0;
				}
			}

			self SetLightIntensity(RandomFloatRange(intensity_min, intensity_max + 1));

			wait .05;
			t += .05;
		}
	}
}


play_dialogue( sound_alias, play_as_radio )
{
	self endon( "death" );

	if ( !IsDefined( play_as_radio ) )
	{
		play_as_radio = false;
	}

	if ( !play_as_radio && isAi(self) )
	{
		self playsound( sound_alias, sound_alias, true );
		self startFacialAnim("Speak");
		self waittill( sound_alias );

		self stopFacialAnim();
	}
	else	
	{
		if ( !IsDefined(self.radio_origin) )
		{
			self.radio_origin = Spawn( "script_origin", self.origin );
			self.radio_origin LinkTo( self );
		}
		self.radio_origin playsound( sound_alias, sound_alias, true );
		self.radio_origin waittill(  sound_alias );
	}
}



play_dialogue_nowait( sound_alias, play_as_radio )
{
	self thread play_dialogue( sound_alias, play_as_radio );
}



red_light(blink)
{
	if (IsDefined(self.light_fx_green))
	{
		self.light_fx_green delete();
	}

	if (IsDefined(self.model) && (self.model != ""))
	{
		if (ModelHasTag(self.model, "TAG_REDLIGHT") && !IsDefined(self.light_fx_red))
		{
			if (!IsDefined(blink) || blink)
			{
				self thread red_light_blink();
			}
			else
			{
				if (!IsDefined(self.light_fx_red))
				{
					self.light_fx_red = SpawnFx(level._effect["light_red"], self GetTagOrigin("TAG_REDLIGHT"));
					TriggerFx(self.light_fx_red);
				}
			}
		}
	}
}

red_light_blink()
{
	self endon("stop_red_light");
	if (!IsDefined(self.red_light_blink))
	{
		self.red_light_blink = 1;

		while (true)
		{
			if (!IsDefined(self.light_fx_red))
			{
				self.light_fx_red = SpawnFx(level._effect["light_red"], self GetTagOrigin("TAG_REDLIGHT"));
				TriggerFx(self.light_fx_red);
			}

			wait 1;
			self.light_fx_red delete();
			wait 1.5;
		}
	}
}

stop_red_light_blink()
{
	self notify("stop_red_light");
	self.red_light_blink = undefined;
}

green_light()
{
	self stop_red_light_blink();
	wait .05;
	if (IsDefined(self.light_fx_red))
	{
		self.light_fx_red delete();
	}

	if (IsDefined(self.model) && (self.model != ""))
	{
		if (ModelHasTag(self.model, "TAG_GREENLIGHT") && !IsDefined(self.light_fx_green))
		{
			self.light_fx_green = SpawnFx(level._effect["light_green"], self GetTagOrigin("TAG_GREENLIGHT"));
			TriggerFx(self.light_fx_green);
		}
	}
}

player_is_near_live_grenade()
{
	grenades = getentarray( "grenade", "classname" );
	for ( i = 0; i < grenades.size; i++ )
	{
		grenade = grenades[ i ];
		if ( grenade.model == "weapon_claymore" )
			continue;

		if ( distance( grenade.origin, level.player.origin ) < 250 )
		{
			/# maps\_autosave::AutoSavePrint( "autosave failed: live grenade too close to player" ); #/
				return true;
		}
	}
	return false;
}

init_level_clocks(hours, minutes, seconds)
{
	
	
	if(!isdefined(hours))
	{
		hours = 0;
	}

	if(!isdefined(minutes))
	{
		minutes = 0;
	}

	if(!IsDefined(seconds))
	{
		seconds = 0;
	}

	
	assertEx(hours >= 0, "The hours is a negative number");
	assertEx(minutes >= 0, "The minutes is a negative number");
	assertEx(seconds >= 0, "The seconds is a negative number");
	
	
	while(seconds > 60)
	{
		minutes++;
		seconds -= 60;
	}

	while(minutes > 60)
	{
		hours++;
		minutes -= 60;
	}

	while(hours > 12)
	{
		hours -= 12;
	}

	clocks = GetEntArray("clock","targetname");
	
	
	for(i = 0; i < clocks.size; i++)
	{
		clocks[i] setcandamage(true);
		clocks[i].health = 5;
		clocks[i] thread rotate_level_clock(hours, minutes, seconds);
	}
}

rotate_level_clock(hours, minutes, seconds)
{
	self endon("death");

	
	hour_hand = GetEnt(self.target,"targetname");
	minute_hand = GetEnt(hour_hand.target,"targetname");
	second_hand = GetEnt(minute_hand.target,"targetname");

	
	hours = hours + (minutes/60);
	h_convert = (hours * 360) / 12;
	hour_hand rotatepitch(h_convert, 0.05);

	minutes = minutes + (seconds/60);
	m_convert = (minutes * 360) / 60;
	minute_hand rotatepitch(m_convert, 0.05);

	if(IsDefined(second_hand))
	{
		s_convert = (seconds * 360) / 60;
		second_hand rotatepitch(s_convert, 0.05);
	}


	
	wait(.1);

	
	while(1)
	{
		hour_hand RotatePitch(0.008333, 1);
		minute_hand RotatePitch(0.1, 1);

		if(IsDefined(second_hand))
		{
			second_hand RotatePitch(6, 1);
		}

	
		wait(1);
	}
}

timer_init( )
{
	precacheShader( "phone_timer" );
}

timer_run_internal_restartable(iSeconds)
{
	level endon ( "kill_timer" );

			
	level.timer = get_countdown_hud();
	level.timer settimer( iSeconds );
	level.start_time = gettime();

			
	level.timerbg = get_countdown_hud_bg();

	level thread curtime( iSeconds );

	wait ( iSeconds );
	
		
	level notify ( "timer_ended" );
}

timer_restart( iSeconds )
{
	level notify("kill_timer");
	
	if(isdefined(level.timerbg))
		level.timerbg destroy();

	if(isdefined(level.timer))
		level.timer destroy();
	
	wait(1);
	level thread timer_run_internal_restartable( iSeconds );


}


timer_run_internal( iSeconds )
{
	level endon ( "kill_timer" );

			
	level.timer = get_countdown_hud();
	level.timer settimer( iSeconds );
	level.start_time = gettime();

			
	level.timerbg = get_countdown_hud_bg();

	level thread curtime( iSeconds );

	wait ( iSeconds );
	
		
	level notify ( "timer_ended" );
}

timer_start( iSeconds )
{
	timer_run_internal( iSeconds );

	level.timerbg destroy();
	level.timer destroy();
}

get_countdown_hud( )
{
	hudelem = newHudElem();
	hudelem.horzAlign = "right";
    hudelem.vertAlign = "top";
    hudelem.x = -51;
    hudelem.y = 39;
   	
	hudelem.sort = 1; 
	
  	hudelem.fontScale = 1.6;
	hudelem.glowAlpha = 1;
 	hudelem.foreground = 2;
 	hudelem.hidewheninmenu = true;
	return hudelem;	
}

get_countdown_hud_bg( )
{
	hudelem = newHudElem();
	hudelem.horzAlign = "right";
    hudelem.vertAlign = "top";
    hudelem.x = -90;
    hudelem.y = 28;
   
  	hudelem.fontScale = 1.6;
	hudelem.glowAlpha = 1;
 	hudelem.foreground = 1;
 	hudelem.hidewheninmenu = true;
	hudelem setShader( "phone_timer", 80, 40 );
	return hudelem;	
}

curtime( iSeconds )
{
	
	
	
	
	while(isDefined(level.timer))
	{
		level.current_time = iSeconds - ((gettime()-level.start_time)/1000);
		wait(.1);
	}
}


check_sight(peripheral_vision, vision_distance)
{
	self endon("death");

	while(isdefined(self))
	{
		
		if(level.player IsIgnoredByAi())
		{
			wait(0.05);
			continue;
		}

		
		if(	!sightTracePassed(level.player gettagorigin("head"), self gettagorigin("tag_eye"), false, undefined) ||
			distance(level.player.origin, self.origin) > vision_distance)
		{
			wait(0.05);	
			continue;
		}

		
		
		
		
		
		
		
		
		test_angles = calcanglearound(self.origin, level.player.origin, self geteyeangles());

		if(abs(test_angles[1]) <= peripheral_vision)
		{
			if(self getalertstate() != "alert_red")
				self setalertstatemin("alert_red");

			break;
		}

		wait(0.05);
	}
}

check_sight_vehicle(peripheral_vision, vision_distance)
{
	while(isdefined(self))
	{		
		
		if(level.player IsIgnoredByAi())
		{
			wait(0.05);		
			continue;
		}

		
		if(	!bullettracepassed(self.origin, level.player GetEye(), false, self) ||
			distance(level.player.origin, self.origin) > vision_distance)
		{
			wait(0.05);		
			continue;
		}

		
		
		
		
		
		
		
		test_angles = calcanglearound(self.origin, level.player.origin, self.angles);

		if(abs(test_angles[1]) <= peripheral_vision)
		{
			
			wait(0.05);
			level notify("seen_by_vehicle");
			break;
		}

		wait(0.05);
	}
}


find_closest_drone(origin)
{
	bestDrone = undefined;
	bestDistance = 999999;

	i = 0;
	drones = GetEntArray( "drone", "targetname" );
	while( i < drones.size )
	{
		drone = drones[i];

		dist = distanceSquared( drone.origin, origin );
		if( dist < bestDistance )
		{
			bestDistance = dist;
			bestDrone = drone;
		}

		i++;
	}










	return bestDrone;
}