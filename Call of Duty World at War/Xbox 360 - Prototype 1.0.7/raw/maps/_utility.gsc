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

	if ( level.isSaving )
		return;

	if ( !isAlive( level.player ) )
		return;
		
	level.isSaving = true;
		
	imagename = "levelshots/autosave/autosave_" + level.script + "end";

	saveGame("levelend", &"AUTOSAVE_AUTOSAVE", imagename);
	
	level.isSaving = false;
}


autosave_by_name( name )
{
	thread autosave_by_name_thread( name );
}

autosave_by_name_thread( name )
{
	if ( !isDefined( level.curAutoSave ) )
		level.curAutoSave = 1;
		
	imageName = "levelshots/autosave/autosave_" + level.script + level.curAutoSave;
	result = level maps\_autosave::tryAutoSave(level.curAutoSave, "autosave", imagename);
	if ( isDefined( result ) && result )
		level.curAutoSave++;
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

array_thread( entities, process, var1, var2, var3 )
{
	keys = getArrayKeys( entities );
	
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
	// pass an array of entities to this function and it will return them in the order of closest
	// to the origin you pass, you can also set max to limit how many ents get returned
	if (!isdefined(max))
		max = array.size;
		
	// return the array, reordered from closest to farthest
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
			
		dist[dist.size] = distance(org, array[i].origin);
		index[index.size] = i;
	}
		
	for (;;)
	{
		change = false;
		for (i=0;i<dist.size-1;i++)
		{
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
	// clear out any existing shields and then wait for them to clear
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
		if (oldHealth == self.health ) // the game spams pain notify every frame while a guy is in pain script
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
	// force my enemy to acquire a new enemy
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
	// Range, max damage, min damage
	radiusDamage (origin, radius, damage, damage);
}

exploder( num )
{
	[[level.exploderFunction]]( num );
}

exploder_before_load( num )
{
	// gotta wait twice because the createfx_init function waits once then inits all exploders. This guarentees
	// that if an exploder is run on the first frame, it happens after the fx are init.
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
	
		// make the exploder actually removed the array instead?
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

/*
	for (i=0;i<level.createFXent.size;i++)
	{
		ent = level.createFXent[i];
		if (!isdefined (ent))
			continue;
		if (ent.v["exploder"] != num)
			continue;
		ent thread brush_delete();
	}
*/
}

sound_effect ()
{
	self effect_soundalias();
}

effect_soundalias ( )
{
	if (!isdefined (self.v["delay"]))
		self.v["delay"] = 0;
	
	// save off this info in case we delete the effect
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
	max_delay = self.v["delay"] + 0.001; // cant randomfloatrange on the same #
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

	playfx( level._effect[ self.v["fxid"] ], self.v["origin"], self.v["forward"], self.v["up"] );
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

//	loopfx(				fxId,	fxPos, 	waittime,	fxPos2,	fxStart,	fxStop,	timeout)
//	maps\_fx::loopfx(	firefx,	origin,	delay,		org,	undefined,	ender,	timeout);
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
//	org delete();
}

brush_delete()
{
//		if (ent.v["exploder_type"] != "normal" && !isdefined (ent.v["fxid"]) && !isdefined (ent.v["soundalias"]))
//		if (!isdefined (ent.script_fxid))

	num = self.v["exploder"];
	if (isdefined (self.v["delay"]))
		wait (self.v["delay"]);
	else
		wait (.05); // so it disappears after the replacement appears

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
		
	waittillframeend; // so it hides stuff after it shows the new stuff
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
			self connectpaths();
		else
			self disconnectpaths();
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
//	self delete();
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

set_ambient (track)
{
	level.ambient = track;
	if ((isdefined (level.ambient_track)) && (isdefined (level.ambient_track[track])))
	{
		ambientPlay (level.ambient_track[track], 2);
		println ("playing ambient track ", track);
	}
}

waittill_string (msg, ent)
{
	if (msg != "death")
		self endon ("death");
	ent endon ("die");
	self waittill (msg);
	ent notify ("returned", msg);
}

waittill_multiple (string1, string2, string3, string4, string5)
{
	self endon ("death");
	ent = spawnstruct();
	ent.threads = 0;

	if (isdefined (string1))
	{
		self thread waittill_string (string1, ent);
		ent.threads++;
	}
	if (isdefined (string2))
	{
		self thread waittill_string (string2, ent);
		ent.threads++;
	}
	if (isdefined (string3))
	{
		self thread waittill_string (string3, ent);
		ent.threads++;
	}
	if (isdefined (string4))
	{
		self thread waittill_string (string4, ent);
		ent.threads++;
	}
	if (isdefined (string5))
	{
		self thread waittill_string (string5, ent);
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
	}

	ent notify ("die");
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

waittill_any (string1, string2, string3, string4, string5)
{
	if ((!isdefined (string1) || string1 != "death") &&
	    (!isdefined (string2) || string2 != "death") &&
	    (!isdefined (string3) || string3 != "death") &&
	    (!isdefined (string4) || string4 != "death") &&
	    (!isdefined (string5) || string5 != "death"))
		self endon ("death");
		
	ent = spawnstruct();

	if (isdefined (string1))
		self thread waittill_string (string1, ent);

	if (isdefined (string2))
		self thread waittill_string (string2, ent);

	if (isdefined (string3))
		self thread waittill_string (string3, ent);

	if (isdefined (string4))
		self thread waittill_string (string4, ent);

	if (isdefined (string5))
		self thread waittill_string (string5, ent);

	ent waittill ("returned", msg);
	ent notify ("die");
	return msg;
}

shock_ondeath()
{
	precacheShellshock("default");
	self waittill ("death");
	if (getdvar ("r_texturebits") == "16")
		return;
	self shellshock("default", 3);
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
	/*
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	org.origin = self.origin;
	org.angles = self.angles;
	org linkto (self);
	org playloopsound (alias, "sounddone");
	org waittill ("sounddone");
	org delete();
	*/
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
//	org endon ("death");
	org playloopsound (alias);
//	println ("playing loop sound ", alias," on entity at origin ", self.origin, " at ORIGIN ", org.origin);
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
//	org endon ("death");
	org playloopsound (alias);
//	println ("playing loop sound ", alias," on entity at origin ", self.origin, " at ORIGIN ", org.origin);
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

//		attachsize =
//		println ("attachSize = ", self getAttachSize());

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
	if (!isalive (spawn))
		return true;
	if (!isdefined (spawn.finished_spawning))
		spawn waittill ("finished spawning");

	if (isalive (spawn))
		return false;

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
	// Note that this will insert only the first bound key for the action
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

	// verify the living-ness of the ai
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

// Creates an event based on this message if none exists, and sets it to true after the delay.
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


getlinks_array( array, linkMap )  //don't pass stuff through as an array of struct.linkname[] but only linkMap[]
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

// Adds only things that are new to the array.
// Requires the arrays to be of node with script_linkname defined.
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

array_merge(array1,array2) // adds only things that are new to the array
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

	// buffer time
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

//
// This is for scripted sequence guys that the LD has setup to not 
// get interrupted in route.
//

set_friendly_chain_wrapper(node)
{
	level.player setFriendlyChain(node);
	level notify ("newFriendlyChain", node.script_noteworthy);
}


// Newvillers objective management
/*
	level.currentObjective = "obj1"; // disables non obj1 friendly chains if you're using newvillers style friendlychains
	objEvent = get_obj_event("center_house"); // a trigger with targetname objective_event and a script_deathchain value
	
	objEvent waittill_objectiveEvent(); // this waits until the AI with the event's script_deathchain are dead,
											then waits for trigger from the player. If it targets a friendly chain then it'll
											make the friendlies go to the chain.
*/

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
//	array_thread (, ::flood_begin);
	level notify ("new_friendly_trigger");
	level.player set_friendly_chain_wrapper(objChain);
}

flood_begin()
{
	self notify ("flood_begin");
}

flood_and_secure_scripted(spawners, instantRespawn)
{
	/*
		The "scripted" version acts as if it had been player triggered.
		
		Spawns AI that run to a spot then get a big goal radius. They stop spawning when auto delete kicks in, then start
		again when they are retriggered or the player gets close.
	
		trigger targetname flood_and_secure
		ai spawn and run to goal with small goalradius then get large goalradius
		spawner starts with a notify from any flood_and_secure trigger that triggers it
		spawner stops when an AI from it is deleted to make space for a new AI or when count is depleted
		spawners with count of 1 only make 1 guy.
		Spawners with count of more than 1 only deplete in count when the player kills the AI.
		spawner can target another spawner. When first spawner's ai dies from death (not deletion), second spawner activates.
	*/

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
//	self endon ("killanimscript");
//	self endon (anim.scriptChange);
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


// fancy quicker struct array handling, assumes array elements are objects with which an index can be asigned to (IE: can't do 5.struct_array_index) 
// also have to be sure that objects can't be a part of another structarray setup as the index position is asigned to the object



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

/*
structarray_add(struct,object)
{
	struct.array[struct.lastindex] = spawnstruct();
	struct.array[struct.lastindex].object = object;
	struct.array[struct.lastindex].struct_array_index = struct.lastindex;
	struct.lastindex++;
}
*/
structarray_add(struct,object)
{
	assert(!isdefined(object.struct_array_index));  //can't have elements of two structarrays on these. can add that later if it's needed
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



// starts this ambient track
set_ambient_alias(ambient, alias)
{
	// change the meaning of this ambience so that the ambience can change over the course of the level
	level.ambient_modifier[ambient] = alias;
	// if the ambient being aliased is the current ambience then restart it so it gets the new track
	if ( level.ambient == ambient )
		maps\_ambient::activateAmbient( ambient );
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
	// send somebody far away then delete them
	self teleport((0,0,-15000));
	self dodamage(self.health + 1, (0,0,0));
}

/*
	move_generic		"Go! Go! Go!"
	move_flank			"Find a way to flank them! Go!"
	move_flankleft		"Take their left flank! Go!"
	move_flankright		"Move in on their left flank! Go!"
	move_follow			"Follow me!"
	move_forward		"Keep moving forward!"
	move_back			"Fall back!"
	
	infantry_generic	"Enemy Infantry!"
	infantry_exposed	"Infatry in the open!"
	infantry_many		"We got a load of german troops out there!"
	infantry_sniper		"Get your heads down! Sniper!"
	infantry_panzer		"Panzerschreck!"
	
	vehicle_halftrack	"Halftrack!"
	vehicle_panther		"Panther heavy tank!"
	vehicle_panzer		"Panzer tank!"
	vehicle_tank		"Look out! Enemy armor!"
	vehicle_truck		"Troop truck!"

	action_smoke		"Get some smoke out there!"

	The following can be appended to any infantry or vehicle dialog line:	
	_left				"On our left!"
	_right				"To the right!"
	_front				"Up front!"
	_rear				"Behind us!"
	_north				"To the north!"
	_south				"South!"
	_east				"To the east!"
	_west				"To the west!"
	_northwest			"To the northwest!"
	_southwest			"To the southwest!"
	_northeast			"To the northeast!"
	_southwest			"To the southeast!"
	_inbound_left		"Incoming
	_inbound_right		"Closing on our right flank!"
	_inbound_front		"Inbound dead ahead!"
	_inbound_rear		"Approaching from the rear!"
	_inbound_north		"Coming in from the north!"
	_inbound_south		"Coming in from the south!"
	_inbound_east		"Approaching from the east!"
	_inbound_west		"Pushing in from the west!"
*/

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
	watch setClock(timer, time, "hudStopwatch", 64, 64); // count down for level.explosiveplanttime of 60 seconds, size is 64x64
	return watch;
}

objective_is_active(msg)
{
	active = false;
	// objective must be active for this trigger to hit
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
	// objective must be active for this trigger to hit
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
	// remove the objective from the active list
	array = [];
	for (i=0;i<level.active_objective.size;i++)
	{
		if (level.active_objective[i] == msg)
			continue;
		array[array.size] = level.active_objective[i];
	}
	level.active_objective = array;
	
	
	// add it to the inactive list
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
	// assert that each objective is only on one list
	for (i=0;i<level.active_objective.size;i++)
	{
		for (p=0;p<level.inactive_objective.size;p++)
			assertEx(level.active_objective[i] != level.inactive_objective[p], "Objective is both inactive and active");
	}
	#/
}

set_objective_active(msg)
{
	// remove the objective from the inactive list
	array = [];
	for (i=0;i<level.inactive_objective.size;i++)
	{
		if (level.inactive_objective[i] == msg)
			continue;
		array[array.size] = level.inactive_objective[i];
	}
	level.inactive_objective = array;
		
	// add it to the active list
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
	// assert that each objective is only on one list
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
	if (isdefined(self.script_forcecolor))
		self set_force_color(self.script_forcecolor);
	else
		self maps\_colors::ai_picks_destination(self.currentColorCode);
}

disable_ai_color()
{
	if (isdefined(self.script_forcecolor))
	{
		// first remove the guy from the force color array he used to belong to
		level.arrays_of_colorForced_ai[self.team][self.script_forcecolor] = array_remove(level.arrays_of_colorForced_ai[self.team][self.script_forcecolor], self);
	}
	self maps\_colors::removeAIFromColorNumberArray();
	self notify("stop_color_move");
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
	// shorten and lowercase the ai's forcecolor to a single letter
	color = shortenColor( _color );
	
	assertEx( maps\_colors::colorIsLegit( color ), "Tried to set force color on an undefined color: " + color );
	
	if ( !isAI( self ) )
	{
		set_force_color_spawner( color );
		return;
	}
		
	assertEx( isalive( self ), "Tried to set force color on a dead/undefined entity." );
	/#
	thread insure_player_does_not_set_forcecolor_twice_in_one_frame();
	#/

	if ( isdefined( self.script_forcecolor ) )
	{
		// first remove the guy from the force color array he used to belong to
		level.arrays_of_colorForced_ai[self.team][self.script_forcecolor] = array_remove(level.arrays_of_colorForced_ai[self.team][self.script_forcecolor], self);
	}

	maps\_colors::removeAIFromColorNumberArray();	
	
	self.script_forceColor = color;
	self.script_color_axis = undefined;
	self.script_color_allies = undefined;
	// get added to the new array of AI that are forced to this color
	level.arrays_of_colorForced_ai[self.team][self.script_forceColor] = array_add(level.arrays_of_colorForced_ai[self.team][self.script_forceColor], self);
	
	// grab the current colorCode that AI of this color are forced to, if there is one
	self.currentColorCode = level.currentColorForced[self.team][self.script_forceColor];
	self thread maps\_colors::goto_current_ColorIndex();
	
	/#
	update_debug_friendlycolor( self.ai_number );
	#/
}

set_force_color_spawner( color )
{
	team = undefined;
	colorTeam = undefined;
	if (issubstr(self.classname,"axis"))
	{
		colorTeam = self.script_color_axis;
		team = "axis";
	}
	
	if (issubstr(self.classname,"ally"))
	{
		colorTeam = self.script_color_allies;
		team = "allies";
	}

	maps\_colors::removeSpawnerFromColorNumberArray();	
	
	self notify ("new_color_code");
	self.script_forceColor = color;
	self.script_color_axis = undefined;
	self.script_color_allies = undefined;
	thread maps\_colors::spawner_processes_colorCoded_ai();
}

issue_color_orders(color_team, team)
{
	colorCodes = strtok( color_team, " " );
	colors = [];
	colorCodesByColorIndex = [];
	
	for (i=0;i<colorCodes.size;i++)
	{
		color = undefined;
		if (issubstr(colorCodes[i], "r"))
			color = "r";
		else
		if (issubstr(colorCodes[i], "b"))
			color = "b";
		else
		if (issubstr(colorCodes[i], "y"))
			color = "y";
		else
		if (issubstr(colorCodes[i], "c"))
			color = "c";
		else
		if (issubstr(colorCodes[i], "g"))
			color = "g";
		else
		if (issubstr(colorCodes[i], "p"))
			color = "p";
		else
		if (issubstr(colorCodes[i], "o"))
			color = "o";
		else
			assertEx(0, "Trigger at origin " + self getorigin() + " had strange color index " + colorCodes[i]);
		
		colorCodesByColorIndex[color] = colorCodes[i];
		colors[colors.size] = color;
	}
	
	assert(colors.size == colorCodes.size);
	
	for (i=0;i<colorCodes.size;i++)
	{
		// remove deleted spawners
		level.arrays_of_colorCoded_spawners[team][colorCodes[i]] = array_removeUndefined(level.arrays_of_colorCoded_spawners[team][colorCodes[i]]);

		assertex( isdefined(level.arrays_of_colorCoded_spawners[team][colorCodes[i]]), "Trigger refer to a color# that does not exist in any node for this team." );
		// set the .currentColorCode on each appropriate spawner
		for (p=0;p<level.arrays_of_colorCoded_spawners[team][colorCodes[i]].size;p++)
			level.arrays_of_colorCoded_spawners[team][colorCodes[i]][p].currentColorCode = colorCodes[i];
	}

	for (i=0;i<colors.size;i++)
	{
		// remove the dead from the color forced ai
		level.arrays_of_colorForced_ai[team][colors[i]] = array_removeDead(level.arrays_of_colorForced_ai[team][colors[i]]);
			
		// set the destination of the color forced spawners
		level.currentColorForced[team][colors[i]] = colorCodesByColorIndex[colors[i]];
	}
		
	for (i=0;i<colorCodes.size;i++)
		self thread maps\_colors::issue_color_order_to_ai(colorCodes[i], colors[i], team);
}

setDifficultyBias( num )
{
	level.difficultyBias = num;
	maps\_gameskill::setCurrentDifficulty();
}

//TODO: Non-hacky rumble.
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
	
		if ( percent_angle < 0.5 )
			percent_angle = 0.5;
		else if ( percent_angle > 0.8 )
			percent_angle = 1;
	
		if ( (isdefined(attacker.team)) && (attacker.team == "axis") ) 
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
		// put the ai in a threat bias group that ignores all the other groups so he
		// doesnt get distracted and go into exposed while his goal radius is too small
		
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
			
		// should now be impossible for this guy to attack anybody on the other team
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

//	if ( level.player_health_packets <= 0 )
//		level.player dodamage( level.player.health + 1623453, ( 0,0,0 ) );
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
	//moverate = units/persecond
	if(!isdefined(moverate))
		moverate = 200;
	//this function is to fudge move the player. I'm using this as a placeholder for an actual animation
	
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
		// the first guy sets it up and runs the master logic. Thread it off in case he dies
		
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
		waittillframeend; // give every other waitspreader in this frame a chance to increment wait_spreaders
	}

	waittillframeend; // wait for the logic to setup the waits
	
	wait( level.wait_spreader_allotment[ personal_wait_index ] );	
	
}

radio_dialogue( msg )
{
	assertEX( isdefined( level.scr_radio[ msg ] ), "Tried to play radio dialogue " + msg + " that did not exist! Add it to level.scr_radio" );
	play_sound_in_space ( level.scr_radio[ msg ], level.player.origin );
}

//HUD ELEMENT STUFF
hint_create(text, background)
{
	struct = spawnstruct();
	if(isdefined(background) && background == true)
		struct.bg = newHudElem();
	struct.elm = newHudElem();
	
	struct hint_position_internal();
	//elm.label 		= struct.text;
	//elm.debugtext 	= struct.text;
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
	// these threatbias groups ignore each other
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

ignore_triggers( timer )
{
	// ignore triggers for awhile so others can trigger the trigger we're in.
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
	// to thread it off
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
	maps\_colors::colorNode_replace_on_death();
}

spawn_reinforcement( classname )
{
	maps\_colors::colorNode_spawn_reinforcement( classname );
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
	
	// if there is no color order for the replacing color than
	// let script assume that it is meant to be replaced by
	// respawning guys
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
	// the guy is removed from the array so the function can be run on the array again
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
		level.script_gen_dump_reasons[level.script_gen_dump_reasons.size] = "Added: "+string; //console print as well as triggering the dump
	level.script_gen_dump[signature] = string;
	level.script_gen_dump2[signature] = string; // second array gets compared later with saved array. When something is missing dump is generated
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
	// sets an AI to default settings, ignoring the .script_ values on him.
	self maps\_spawner::scrub_guy();
}
send_notify( msg )
{
	// functionalized so it can be function pointer'd
	self notify( msg );
}

deleteEnt( ent )
{
	// created so entities can be deleted using array_thread
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
