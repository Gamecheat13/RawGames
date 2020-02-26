// scripting by Bloodlust
// level design by BSouds

#include maps\pel2_util;
#include maps\_utility;
#include common_scripts\utility;


// kill off a group of AI
ber1_kill_group(group)
{
	guys = get_ai_group_ai(group);
	for(i = 0; i < guys.size; i++)
	{
		if(isDefined(guys[i]) && isAlive(guys[i]))
		{
			guys[i] dodamage(guys[i].health + 50, guys[i].origin);
		}
		
		wait randomfloatrange(.400, 1.2);
	}
}



// used to throw objects
// more catenary = loftier arc
// less catenary = straighter arc
throw_object(target, catenary)
{
	start_pos = self.origin;
	target_pos = target.origin;
	gravity = GetDvarInt("g_gravity") * -1;
	dist = Distance(start_pos, target_pos);
	time = dist / catenary;
	delta = target_pos - start_pos;
	drop = 0.5 * gravity * (time * time);
	velocity = ((delta[0] / time), (delta[1] / time), (delta[2] - drop) / time);
	
	self MoveGravity(velocity, time);
	wait(time);
	
	self notify("destination");
}



// wait till AI reaches their goal node
// then put them back on the current color chain
reenable_color_from_goalnode()
{
	self waittill("goal");
	self enable_ai_color();
}



// delete MGs for realism or to free up turret count
kill_mgs(value, key)
{
	mg = getEnt(value, key);
	
	if(isDefined(mg))
	{
		mg notify("stop_using_built_in_burst_fire");
		mg notify("stopfiring");	
		waittillframeend;	
		mg delete();
	}	
}



// used to shoot Panzershrecks at the players and tank in Event 1
fire_shrecks( spawn_point, target, offset, alias, time )
{
	
	shreck = spawn( "script_model", spawn_point.origin );
	shreck.angles = target.angles;
	shreck setmodel( "weapon_ger_panzershreck_rocket" );
	
	dest = target.origin;
	
	if( isdefined( offset ) )
	{
		dest = dest + offset;
	}
	
	shreck moveTo( dest, time );
	shreck playsound( "weap_pnzr_fire" );
	playFxOnTag( level._effect["shreck_trail"], shreck, "tag_fx" );
	shreck playloopsound( "weap_pnzr_fire_rocket" );
	wait( time );
	shreck stoploopsound();
	
	shreck hide();
	
	playfx( level._effect["shreck_explode"], shreck.origin );
	playSoundAtPosition( "rpg_impact_boom", shreck.origin );
	radiusdamage( shreck.origin, 180, 300, 35 );
	earthquake( 0.5, 1.5, shreck.origin, 512 );
	
	if( isdefined( alias ) )
	{
		playSoundAtPosition( alias, shreck.origin );
	}
	
	shreck delete();
	
}



// setup spawn functions for AI throughout the level
setup_spawn_functions()
{

	panzershreck_guys = getEntArray("panzershreck", "script_noteworthy");
	array_thread(panzershreck_guys, ::add_spawn_function, ::setup_panzershreck_guys);
	
	moab_gunners = getEntArray("moab_gunner", "targetname");
	array_thread(moab_gunners, ::add_spawn_function, ::setup_moab_gunners);
	
	gunners = getEntArray("ts_right_gunner", "targetname");
	array_thread(gunners, ::add_spawn_function, ::setup_trainyard_gunners);
	
	wavers = getEntArray("wavers", "targetname");
	array_thread(wavers, ::add_spawn_function, ::setup_trainyard_wavers);
	
	entrance_guards = getEntArray("entrance_guards", "script_noteworthy");
	array_thread(entrance_guards, ::add_spawn_function, ::radius_setup);	

}



rooftop_setup()
{
	
	self.goalradius = 16;
	self.health = 35;


}



radius_setup()
{
	self.goalradius = 16;
}



setup_panzershreck_guys()
{
	self.goalradius = 16;
	self setThreatBiasGroup("panzershreck_threat");
}



setup_moab_gunners()
{
	self setthreatbiasgroup("mg42_guys");
}



setup_trainyard_gunners()
{
	self.ignoreme = true;
	self.goalradius = 32;
	self.targetname = "ts_right_gunner";
	self setthreatbiasgroup("mg42_guys");
}



setup_trainyard_wavers()
{
	self.animname = "wavers";
	self.targetname = "wavers";
	self.ignoreall = true;
	self.ignoreme = true;
	self.goalradius = 32;
	self.allowdeath = true;
	self thread magic_bullet_shield();
}




// draws a line from point A to point B. thanks Mike!
drawline(pos1, vtag, vmodel, time, color)
{
	if(!isdefined(time))
	{
		time = 3;
	}
	
	if(!isdefined(color))
	{
		color = (1, 1, 1);
	}
	
	timer = gettime() + (time * 1000);
	
	while(getTime() < timer)
	{
		pos2 = vmodel getTagOrigin(vtag);
		line(pos1.origin, pos2, color);
		wait(0.05);
	}
}



// ******************************************************************************************************************



warp_players_underworld()
{

	// get the spot under the world for temp placement
	underworld = GetStruct( "underworld_start", "targetname" );
	
	if( !IsDefined( underworld ) )
	{
		ASSERTMSG( "warp_players_underworld(): can't find the underworld warp spot! aborting." );
		return;
	}
	
	players = get_players();
	
	for( i = 0; i < players.size; i++ )
	{
		players[i] SetOrigin( underworld.origin );
	}

}



// warp players to a given set of points
warp_players( startValue, startKey )
{
	// get start points
	
	starts = GetStructArray( startValue, startKey );
	ASSERT( starts.size == 4 );

	
	players = get_players();

	for( i = 0; i < players.size; i++ )
	{
	// Set the players' origin to each start point
	
		players[i] setOrigin( starts[i].origin );
	
	// Set the players' angles to face the right way.
	
		players[i] setPlayerAngles( starts[i].angles );
	}

}



// warp friendlies to a given set of points
warp_friendlies( startValue, startKey )
{
	
	//setup_friendlies();
	///////////////////////////////////////TEMP///////////////////////////////////////
	
	//ASSERTEX( flag( "friends_setup" ), "warp_friendlies(): level.friends needs to be set up before this runs." );
	
	///////////////////////////////////////TEMP///////////////////////////////////////

	friendly_squad = get_ai_group_ai( "start_guys" );
	friendly_squad = array_combine( friendly_squad, level.heroes );
	
	// get start points
	friendlyStarts = GetStructArray( startValue, startKey );

	ASSERTEX( friendlyStarts.size >= friendly_squad.size, "warp_friendlies(): not enough friendly start points for friendlies!" );
	
	for( i = 0; i < friendly_squad.size; i++ )
	{
		friendly_squad[i] Teleport( groundpos( friendlyStarts[i].origin ), friendlyStarts[i].angles );
	}

}



///////////////////
//
// For use with skiptos. Don't want to bring along guys that wouldn't have been respawning
//
///////////////////////////////

thin_out_friendlies( guys )
{

	for( i  = 0; i < guys.size; i++ )
	{
		if( isdefined( guys[i].script_no_respawn ) && guys[i].script_no_respawn )
		{
			guys[i] dodamage( guys[i].health + 1, (0,0,0 ) );
		}	
	}

}


