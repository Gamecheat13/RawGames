#include common_scripts\utility;
#include maps\_utility;

////////////////////////// UTILS //////////////////////////

delete_spawners(noteworthies)
{
	if(!IsArray(noteworthies)) noteworthies = [noteworthies];
	
	foreach(noteworthy in noteworthies)
	{
		foreach(spawner in GetEntArray(noteworthy, "script_noteworthy"))
		{
			if(IsSpawner(spawner))
			{
				spawner Delete();
			}
		}
	}
}

spawn_metrics_init_for_noteworthy(noteworthy)
{
	if(!IsDefined(level.spawn_metrics_spawn_count))
		level.spawn_metrics_spawn_count = [];
	
	if(!IsDefined(level.spawn_metrics_death_count))
		level.spawn_metrics_death_count = [];
	
	/#
		if(!IsDefined(level.spawn_metrics_initted_noteworthies))
			level.spawn_metrics_initted_noteworthies = [];
	
		AssertEx(!IsDefined(level.spawn_metrics_initted_noteworthies[noteworthy]), "spawn_metrics_init_noteworthy() called twice for noteworthy " + noteworthy);
	
		level.spawn_metrics_initted_noteworthies[noteworthy] = true;
	#/
	
	array_spawn_function_noteworthy(noteworthy, ::spawn_metrics_spawn_func);
	
	// account for guys already created (not spawners)
	foreach(guy in GetEntArray(noteworthy, "script_noteworthy"))
	{
		if(!IsSpawner(guy) && IsAlive(guy))
		{
			guy spawn_metrics_spawn_func();	
		}
	}
}

spawn_metrics_spawn_func()
{
	Assert(IsDefined(self));
	Assert(IsAlive(self));
	Assert(!IsSpawner(self));
	Assert(IsDefined(self.health)); //make sure it is something that can die.  This fixes an issue with IsAI and drones.
	
	if(IsDefined(self.script_noteworthy))
	{
		if(IsDefined(level.spawn_metrics_spawn_count[self.script_noteworthy]))
		{
			level.spawn_metrics_spawn_count[self.script_noteworthy] += 1;
		}
		else
		{
			level.spawn_metrics_spawn_count[self.script_noteworthy] = 1;
		}
		
		self thread spawn_metrics_death_watcher();
	}
}

spawn_metrics_death_watcher()
{
	Assert(IsDefined(self));
	Assert(IsDefined(self.script_noteworthy));
	
	orig_script_noteworthy = self.script_noteworthy;
	
	self waittill("death");
		
	if(IsDefined(level.spawn_metrics_death_count[orig_script_noteworthy]))
	{
		level.spawn_metrics_death_count[orig_script_noteworthy] += 1;
	}	
	else
	{
		level.spawn_metrics_death_count[orig_script_noteworthy] = 1;
	}
}

spawn_metrics_number_spawned(script_noteworthy)
{
	AssertEx(IsDefined(level.spawn_metrics_initted_noteworthies) && IsDefined(level.spawn_metrics_initted_noteworthies[script_noteworthy]), "Must call spawn_metrics_init_for_noteworthy(\"" + script_noteworthy + "\") before calling other spawn_metrics functions");
	
	if(IsArray(script_noteworthy))
	{
		sum = 0;
		foreach(nw in script_noteworthy)
			sum += spawn_metrics_number_spawned(nw);
		return sum;
	}
	
	if(IsDefined(level.spawn_metrics_spawn_count[script_noteworthy]))
		return level.spawn_metrics_spawn_count[script_noteworthy];
	else
		return 0;
}

spawn_metrics_number_died(script_noteworthy)
{
	AssertEx(IsDefined(level.spawn_metrics_initted_noteworthies) && IsDefined(level.spawn_metrics_initted_noteworthies[script_noteworthy]), "Must call spawn_metrics_init_for_noteworthy(\"" + script_noteworthy + "\") before calling other spawn_metrics functions");

	if(IsArray(script_noteworthy))
	{
		sum = 0;
		foreach(nw in script_noteworthy)
			sum += spawn_metrics_number_died(nw);
		return sum;
	}
	
	if(IsDefined(level.spawn_metrics_death_count[script_noteworthy]))
		return level.spawn_metrics_death_count[script_noteworthy];
	else
		return 0;
}

spawn_metrics_number_alive(script_noteworthy)
{
	/#
	// also do a simple count as a sanity check
	
	if(IsArray(script_noteworthy))
		nw_array = script_noteworthy;
	else
		nw_array = [script_noteworthy];
	count = 0;
	foreach(nw in nw_array)
		foreach(guy in GetEntArray(nw, "script_noteworthy"))
			if(IsAlive(guy))
				count++;
	AssertEx(count == spawn_metrics_number_spawned(script_noteworthy) - spawn_metrics_number_died(script_noteworthy), "spawn_metrics count was wrong - potential progression blocker?  Some guys may not have had spawn functions run on them.");
	#/
	
	return spawn_metrics_number_spawned(script_noteworthy) - spawn_metrics_number_died(script_noteworthy);
}

spawn_metrics_waittill_count_reaches(count, noteworthies, debug)
{
	if(!IsArray(noteworthies)) noteworthies = [noteworthies];
	
	// sigh, give people a chance to spawn if they're spawned in threads
	waittillframeend;
	
	for(;; wait 1)
	{
		current = 0;
		foreach(noteworthy in noteworthies)
		{
			current += spawn_metrics_number_alive(noteworthy);
		}
		
		/#
		if(IsDefined(debug) && debug)
		{
			debug_print(current + " alive, waiting till " + count);
		}	
		#/
			
		if(current <= count)
		{
			break;
		}
	}	
}

spawn_metrics_waittill_deaths_reach(death_count, noteworthies, debug)
{
	if(!IsArray(noteworthies)) noteworthies = [noteworthies];
	
	for(;; wait 1)
	{
		deaths = 0;
		foreach(noteworthy in noteworthies)
		{
			deaths += spawn_metrics_number_died(noteworthy);
		}
		
		/#
		if(IsDefined(debug) && debug)
		{
			debug_print(deaths + " have died, waiting till " + death_count);
		}	
		#/
		
		if(deaths >= death_count)
		{
			break;
		}
	}
}

/#
// This is a wrapper for IPrintLn that turns off in exec demo mode.
debug_print(msg)
{
	// The goal here is to turn off IPrintLn() when exec demo mode is enabled.  Exec demo mode works
	// by executing demo.cfg, which just sets a bunch of dvars.  One of the dvars is developer_script.
	// That dvar should turn off code in /# #/ comments, but it is only read at map init time, so if you
	// run the map and choose exec demo, it's too late.
	
	// Another way we could stop the IPrintLn()s would be with cl_noprint, however, this also disables
	// checkpoint updated messages, which are important.
	
	// Since there is now an option to run "exec demo" but leave developer_script enabled, we'll instead use the
	// developer dvar instead.
	
	if(GetDebugDvarInt("developer") != 0)
	{
		IPrintLn(msg);	
	}	
}
#/

goto_node(node_or_script_noteworthy, bWait, radius)
{
	self endon("stop_goto_node");
	
	if(!IsDefined(radius)) radius = 16;
	
	self set_goal_radius(radius);

	if(IsString(node_or_script_noteworthy))
	{
		node = 	GetNode(node_or_script_noteworthy, "script_noteworthy");
	}
	else
	{
		node = node_or_script_noteworthy;
	}
	
	if(IsDefined(node))
	{
		self set_goal_node(node);
	}
	else	
	{	
		node = GetStruct(node_or_script_noteworthy, "script_noteworthy");	
		AssertEx(IsDefined(node), "Couldn't find node or struct with script_noteworthy " + node_or_script_noteworthy);
		
		self set_goal_pos(node.origin);
	}	

	if(bWait)
	{
		/#	
		AssertEx(!IsDefined(self.script_forcecolor), "Must disable_ai_color() before calling goto_node() with bWait == true");
		self childthread assert_on_color();
		#/
		
		self waittill("goal");
		
		/#
		self notify("stop_assert_on_color");
		
		if(Distance2D(self.origin, node.origin) > radius * 1.1)
		{
			AssertEx(false, "goto_node finished but wasn't close enough (see the green arrow)");	
			
			thread draw_arrow_time(self.origin, node.origin, (0, 1, 0), 10);
		}	
		#/	
	}
}

/#
assert_on_color()
{
	self endon("stop_assert_on_color");
	for(;; waitframe())
	{
		if(IsDefined(self.script_forcecolor))
		{
			AssertEx(false, "Color got enabled during goto_node().");
			break;
		}
	}
}
#/
	
/#
debug_magic()
{
	dvar_name = "debug_magic";
	SetDevDvar(dvar_name, "0");
	
	foreach(spawner in GetSpawnerArray())
	{
		spawner.spawner_targetname = spawner.targetname;
		spawner.orig_count = spawner.count;	
		spawner add_spawn_function(::debug_magic_spawn_func);
	}
	
	for(;;)
	{
		if(GetDebugDvar(dvar_name) != "0")
		{
			allies = GetAIArray("allies", "axis");
			foreach(ally in allies)
			{
				str = "";
				
				if(IsDefined(ally.script_noteworthy))
				{
					str += "nw: " + ally.script_noteworthy + "\n";
				}

				if(IsDefined(ally.spawner_targetname))
				{
					str += "stn: " + ally.spawner_targetname + "\n";
				}
				
				color = (1, 1, 1);
				if(IsDefined(ally.script_forcecolor))
				{
					color = get_script_palette()[ally.script_forcecolor];
					//str += "color: " + ally.script_forcecolor + "\n";
				}
				
				if(IsDefined(ally.magic_bullet_shield))
				{
					str += "magic\n";
				}
				
				if(IsDefined(ally.spawned_by_flood_spawner) && IsDefined(ally.orig_count) && IsDefined(ally.spawn_number) && ally.orig_count > 1)
				{
					str += ally.spawn_number + " of " + ally.orig_count;	
				}
				
				if(IsDefined(ally.script_parameters))
				{
					str += "params: " + ally.script_parameters + "\n";	
				}
				
				goalvolume = ally GetGoalVolume();
				if(IsDefined(goalvolume) && IsDefined(goalvolume.targetname))
				{
					str += "goalvolume: " + goalvolume.targetname + "\n";
				}
				
				if(IsDefined(ally.goalradius))
				{
					str += "radius: " + ally.goalradius;
				}
				
				lines = StrTok(str, "\n");
				line_height = 8;
				offset = 48 + line_height * lines.size;
				foreach(line in lines)
				{			
					Print3D(ally.origin + (0, 0, offset), line, color, 1, .5);			
					offset -= line_height;
				}
			}	
		}
		else
		{
			wait 1;
		}
		waitframe();	
	}	
}

debug_magic_spawn_func()
{
	if(IsDefined(self.spawner) && IsDefined(self.spawner.count) && IsDefined(self.spawner.orig_count))
	{
		self.spawn_number = self.spawner.orig_count - self.spawner.count;	
	}
}

#/	
	
// disables grenades for one NPC, saving his grenade ammo count
disable_grenades()
{
	Assert(IsAI(self), "disable_grenades() is for AI");
	if(IsDefined(self.grenadeammo) && !IsDefined(self.oldgrenadeammo))
		self.oldgrenadeammo = self.grenadeammo;			
	self.grenadeammo = 0;
}

// restores an NPCs grenade ammo count so he can fire again
enable_grenades()
{
	Assert(IsAI(self), "enable_grenades() is for AI");
	if(IsDefined(self.oldgrenadeammo))
	{
		self.grenadeammo = self.oldgrenadeammo;
		self.oldgrenadeammo = undefined;	
	}
}

// fake death
bloody_death( delay )
{
	self endon( "death" );

	if( !IsSentient( self ) || !IsAlive( self ) )
	{
		return;
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";

	for( i = 0; i < 3 + RandomInt( 5 ); i++ )
	{
		random = RandomIntRange( 0, tags.size );
		//vec = self GetTagOrigin( tags[random] );
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	self DoDamage( self.health + 50, self.origin );
}

bloody_death_fx( tag, fxName )
{
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}

	PlayFxOnTag( fxName, self, tag );
}

teleport_to_scriptstruct(name)
{
	scriptstruct = GetStruct(name, "script_noteworthy");
	level.player SetOrigin(scriptstruct.origin);
	if(IsDefined(scriptstruct.angles))
		level.player SetPlayerAngles(scriptstruct.angles);
                
                
	allies = GetEntArray("hero", "script_noteworthy");
    
    foreach(ally in allies)
    {
    	if(IsSpawner(ally)) allies = array_remove(allies, ally);	
    }
                
	ally_structs = GetStructArray(scriptstruct.target, "targetname");
                
	for(i = 0; i < allies.size; i++)
	{
		if(i < ally_structs.size)
		{
			allies[i] ForceTeleport(ally_structs[i].origin, ally_structs[i].angles);
			allies[i] SetGoalPos(ally_structs[i].origin);
		}
		else
		{
			allies[i] ForceTeleport(level.player.origin, level.player.angles);	
			allies[i] SetGoalPos(level.player.origin);
		}
	}
}

kill_path_on_death()
{
	// needed to fix what looks to be a bug in the vehicle code.
	//   vehicle_paths keeps running after a vehicle is killed, and if certain
	//   triggers/flags are hit, it will try to resume the vehicle after death
	
	// also kill path when driver is killed
	self wait_to_kill_path();
	self notify( "newpath" );
}

wait_to_kill_path()
{
	self endon( "death" );
	self endon( "driver dead" );
	level waittill( "eternity" );
}

disable_awareness()
{
	self.ignoreall = true;
	self.dontmelee = true;
	self.ignoresuppression = true;
	self.suppressionwait_old = self.suppressionwait;
	self.suppressionwait = 0;
	self disable_surprise();
	self.IgnoreRandomBulletDamage = true;
	self disable_bulletwhizbyreaction();
	self disable_pain();
	self.grenadeawareness = 0;
	self.ignoreme = 1;
	self enable_dontevershoot();
	self.disableFriendlyFireReaction = true;
	self.dodangerreact = false;
}

enable_awareness()
{
	self.ignoreall = false;
	self.dontmelee = undefined;
	self.ignoreSuppression = false;
	self.suppressionwait = self.suppressionwait_old;
	self.suppressionwait_old = undefined;
	self enable_surprise();
	self.IgnoreRandomBulletDamage = false;
	self enable_bulletwhizbyreaction();
	self enable_pain();
	self.grenadeawareness = 1;
	self.ignoreme = 0;
	self disable_dontevershoot();
	self.disableFriendlyFireReaction = undefined;
	self.dodangerreact = true;
}

hide_friendname_until_flag_or_notify( msg )
{
	if( !isDefined( self.name ) )
		return;
	
	AssertEx( IsDefined( msg ), "must specify an end message when hiding friendnames" );
	
	level.player endon( "death" );
	self endon( "death" );
	
	self.old_name = self.name;
	self.name = " ";
	
	level waittill( msg );
	
	self.name = self.old_name;
}

ignore_badplace( start_flag, end_flag )
{
	self endon( "death" );
	
	if( isDefined( start_flag ) )
	{
		Assert( flag_exist( start_flag ) );
		flag_wait( start_flag );
	}
	
	self.old_bp_awareness = self.badplaceawareness;
	self.badplaceawareness = 0;
	
	if( isDefined( end_flag ) )
	{
		Assert( flag_exist( end_flag ) );
		flag_wait( end_flag );
		self.badplaceawareness = self.old_bp_awareness;
	}
}

print3dUntilNotify( org, text, color, alpha, scale, msg )
{
	self endon( msg );
	while( 1 )
	{
		Print3d( org, text, color, alpha, scale, 1 );
		wait 0.05;
	}
}

printOrigin3dUntilNotify( offset, color, alpha, scale, msg )
{
	self endon( msg );
	while( 1 )
	{
		Print3d( self.origin + offset, self.origin, color, alpha, scale, 1 );
		wait 0.05;
	}
}

delete_on_notify( notification )
{
	level waittill( notification );
	self delete();
}