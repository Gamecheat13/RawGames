#include maps\_utility;
#include maps\_anim;
#include maps\_civilian_idle;
#using_animtree( "civilian" );
main()
{
	if ( isdefined( level._loadStarted ) )
		assertMsg( "maps\_civilian::main() must be called before maps\_load::main(). Please fix this error!!" );
	
	if ( getdvar( "debug_civilians" ) == "" )
		setdvar( "debug_civilians", "0" );
	
	maps\_drone::init();
	
	//Animations for Civilians
	level.scr_animtree["civilian"] = #animtree;
	level.scr_anim["civilian"]["idle"][0]					= %unarmed_cowerstand_idle;
	level.scr_anim["civilian"]["pointidle"][0]				= %unarmed_cowerstand_pointidle;
	level.scr_anim["civilian"]["idle2point"]	 			= %unarmed_cowerstand_idle2point;
	level.scr_anim["civilian"]["point2idle"]			 	= %unarmed_cowerstand_point2idle;
	level.scr_anim["civilian"]["react"] 					= %unarmed_cowerstand_react_2_crouch;
	level.scr_anim["civilian"]["react2crouch"]				= %unarmed_cowerstand_react_2_crouch;
	
	//walks
	level.scr_anim["civilian"]["walk"][0]["anim"]			= %unarmed_walk_slow;
	level.scr_anim["civilian"]["walk"][0]["speed"]			= 55;
	level.scr_anim["civilian"]["walk_react"][0]["anim"]		= %unarmed_walk_slow;
	level.scr_anim["civilian"]["walk_react"][0]["speed"]	= 55;
	
	//jogs
	level.scr_anim["civilian"]["jog"][0]["anim"]			= %unarmed_scared_run;
	level.scr_anim["civilian"]["jog"][0]["speed"]			= 110;
	level.scr_anim["civilian"]["jog_react"][0]["anim"]		= %unarmed_scared_run;
	level.scr_anim["civilian"]["jog_react"][0]["speed"]		= 110;
	
	//runs
	level.scr_anim["civilian"]["run"][0]["anim"]			= %unarmed_scared_jog;
	level.scr_anim["civilian"]["run"][0]["speed"]			= 170;
	level.scr_anim["civilian"]["run_react"][0]["anim"]		= %unarmed_scared_jog_look;
	level.scr_anim["civilian"]["run_react"][0]["speed"]		= 80;
	level.scr_anim["civilian"]["run_react"][1]["anim"]		= %unarmed_scared_jog_duck;
	level.scr_anim["civilian"]["run_react"][1]["speed"]		= 140;
	
	//Setup Civilian triggers
	findAllTriggers();
	
	//Delete Civilian AI/Spawners now that they are stored in script to be drones
	deleteCivilianAI();
}

findAllTriggers()
{
	//List of all valid trigger types to spawn a civilian
	trigger_type = [];
	trigger_type[0] = "trigger_multiple";
	trigger_type[1] = "trigger_disk";
	trigger_type[2] = "trigger_radius";
	trigger_type[3] = "trigger_lookat";
	trigger_type[4] = "trigger_use";
	trigger_type[5] = "trigger_use_touch";
	
	triggers = [];
	for( i = 0 ; i < trigger_type.size ; i++ )
	{
		temp = getentarray( trigger_type[i], "classname" );
		for( j = 0 ; j < temp.size ; j++ )
			triggers[triggers.size] = temp[j];
	}
	
	array_thread(triggers, ::spawnCivilian_Trigger);
}

deleteCivilianAI()
{
	civilians = getentarray( "actor_civilian", "classname" );
	level.civilianSpawnerTargetnames = [];
	for( i = 0 ; i < civilians.size ; i++ )
	{
		if (isdefined(civilians[i].targetname))
			level.civilianSpawnerTargetnames[level.civilianSpawnerTargetnames.size] = civilians[i].targetname;
		civilians[i] delete();
	}
}

getNumberCivilianSpawnersByTargetname(target_name)
{
	//Returns the number of Civilian spawners with the specified targetname
	retValue = 0;
	assert(isdefined(level.civilianSpawnerTargetnames));
	for( i = 0 ; i < level.civilianSpawnerTargetnames.size ; i++ )
	{
		if (level.civilianSpawnerTargetnames[i] != target_name)
			continue;
		retValue++;
	}
	return retValue;
}

spawnCivilian_Trigger()
{
	if (!isdefined(self.target))
		return;
	
	self.civilians = [];
	ents = getentarray( self.target, "targetname" );
	for( i = 0 ; i < ents.size ; i++ )
	{
		if (!isdefined(ents[i].classname))
			continue;
			
		if (!issubstr( ents[i].classname, "civilian" ) )
			continue;
		
		//trigger targets a civilian - copy the spawners data to script variables
		index = self.civilians.size;
		self.civilians[index] = spawnstruct();
		self.civilians[index].model = ents[i].model;
		self.civilians[index].origin = ents[i].origin;
		self.civilians[index].targetname = ents[i].targetname;
		self.civilians[index].script_noteworthy = ents[i].script_noteworthy;
		self.civilians[index].angles = ( 0, ents[i].angles[1], 0 );
		if (isdefined(ents[i].target))
			self.civilians[index].target = ents[i].target;
	}
	
	if (!isdefined(self.civilians))
		return;
	if (self.civilians.size <= 0)
		return;
	
	//wait until the trigger is triggered
	self waittill ( "trigger" );
	
	//spawn all civilians this trigger targets
	self spawnCivilians();
}

spawnCivilians()
{
	//spawns all civilians targeted by the trigger
	
	spawned = [];
	for( i = 0 ; i < self.civilians.size ; i++ )
	{
		index = spawned.size;
		
		if (level.drones["civilian"].lastindex > level.max_drones["civilian"])
			continue;
		
		spawned[index] = spawn( "script_model", self.civilians[i].origin );
		spawned[index].angles = self.civilians[i].angles;
		spawned[index] setmodel( self.civilians[i].model );
		spawned[index].targetname = self.civilians[i].targetname;
		spawned[index].script_noteworthy = self.civilians[i].script_noteworthy;
		
		level notify ( "civilianSpawned", spawned[index] );
		
		if (isdefined(self.civilians[i].target))
			spawned[index].target = self.civilians[i].target;
		if (isdefined(self.civilians[i].targetname))
			spawned[index].targetname = self.civilians[i].targetname;
		
		spawned[index] civilianInit();
		
		//chad - put move code here
		//if the civilian targets something then make it walk the path, otherwise do idle
		//if ( ( isdefined( self.target )) && ( isdefined( level.struct_targetname[self.target] )) )
		//{
			//assertMsg("Civilian is targeting a script_struct and this hasn't been implemented yet");
		//}
	}
	if (spawned.size > 0)
		level notify ( "civilianArraySpawned", spawned );
}

civilian_waittill_spawn_thread(target_name)
{
	//waits until a civilian with the specified targetname is spawned, and returns the spawned entity
	civilian = undefined;
	for (;;)
	{
		level waittill ( "civilianSpawned", civilian );
		if (!isdefined(civilian))
			continue;
		if (!isdefined(civilian.targetname))
			continue;
		if (civilian.targetname == target_name)
			break;
	}
	return civilian;
}

civilian_waittill_arrayspawn_thread(target_name)
{
	//waits until all civilians with the specified targetname are spawned, and returns an array of all the spawned entities
	returnableCivilians = [];
	for (;;)
	{
		level waittill ( "civilianArraySpawned", civilians );
		for( i = 0 ; i < civilians.size ; i++ )
		{
			if (!isdefined(civilians[i]))
				continue;
			if (!isdefined(civilians[i].targetname))
				continue;
			if (civilians[i].targetname == target_name)
				returnableCivilians[returnableCivilians.size] = civilians[i];
		}
		if (returnableCivilians.size > 0)
			break;
	}
	return returnableCivilians;
}

civilianInit()
{
	//civilian init thread
	//-------------------
	
	self makeFakeAI();
	
	structarray_add( level.drones["civilian"], self );
	
	self civilian_Reaction_Enable( 0 );
	self thread civilian_reaction_notification( "grenade danger" );		//grenade landed nearby
	self thread civilian_reaction_notification( "gunshot" );			//gun shot near by
	self thread civilian_reaction_notification( "bulletwhizby" );		//bullet flew by
	self thread civilian_reaction_notification( "projectile_impact" );	//projectile impacted nearby
	
	self.animname = "civilian";
	
	//make sure the player can't shoot/kill him
	self thread civilian_friendlyfire();
	
	//put him into idle
	self thread civilian_idle();
	
	//make him aware of gun fire in his area
	self thread civilian_react_gunfire();
}

civilian_Reaction_Enable( qEnable )
{
	self.doReaction = qEnable;
}

civilian_reaction_notification( strType )
{	
	//adds a generic notification to the civilian for an event so the civilian can react to that event
	self endon ( "civilian_death" );
	self addAIEventListener( strType );
	for (;;)
	{
		self waittill ( strType );
		assert( isdefined( self.doReaction ) );
		if ( !self.doReaction )
			continue;
		self notify ( "do_reaction", strType );
		wait 0.05;
	}
}

civilian_friendlyfire()
{
	//makes the player fail the mission if the player does any damage to a civilian
	self endon ( "override_friendlyfire" );
	self endon ( "civilian_death" );
	
	self setcandamage(true);
	for (;;)
	{
		self waittill ( "damage", damage, attacker );
		if (attacker == level.player)
			break;
	}
	thread maps\_friendlyfire::missionfail();
}

civilian_anim_single( anim_name )
{
	//use this to play a single animation on a civilian using anim_single_solo
	self civilian_prepare_for_animation();
	self anim_single_solo (self, anim_name);
}

civilian_anim_loop( anim_name, ender)
{
	//use this to play a looping animation on a civilian using anim_loop_solo
	self civilian_prepare_for_animation();
	self anim_loop_solo (self, anim_name, undefined, ender);
	
}

civilian_prepare_for_animation()
{
	//sets neccessary info on the civilian just before doing a civilian animation
	self stopAnimScripted();
	self useAnimTree(level.scr_animtree["civilian"]);
	self.animname = "civilian";
	self notify ( "stop_civilian_move_anim" );
}

civilian_MoveToNode( destinationPoint, movementType )
{
	self endon ( "civilian_death" );
	
	if ( checkMovementTypeError( movementType ) )
		return;
	
	self notify("move_override");
	
	self thread maps\_civilian_move::civilian_loop_moveAnims( movementType );
	self maps\_civilian_move::waittillSpeedSet();
	self maps\_civilian_move::MoveChain( destinationPoint );
}

civilian_MoveToVec( destinationVec, movementType )
{
	self endon ( "civilian_death" );
	
	if ( checkMovementTypeError( movementType ) )
		return;
	
	self notify("move_override");
	
	self civilian_MoveToVecArray( civilian_makeVecArray( destinationVec ), movementType );
}

civilian_MoveToVecArray( vecArray, movementType )
{
	self endon ( "civilian_death" );
	
	if ( checkMovementTypeError( movementType ) )
		return;
	
	self notify("move_override");
	
	if( vecArray.size == 0 )
	{
		assertMsg( "civilian_MoveToVecArray( vecArray ) used without passing in a valid array of coordinates" );
		return;
	}
	
	self thread maps\_civilian_move::civilian_loop_moveAnims( movementType );
	self maps\_civilian_move::waittillSpeedSet();
	self maps\_civilian_move::MoveChain( undefined, vecArray );
}

checkMovementTypeError( movementType )
{
	qError = false;
	if ( !isdefined( movementType ) )
		qError = true;
	else if ( movementType != "walk" && movementType != "jog" && movementType != "run" )
		qError = true;
	
	if ( qError )
		assertMsg ( "You must specify a movement type when moving a civilian or hostage. Valid types are walk, jog, or run" );
	
	return qError;
}

civilian_makeVecArray( destinationVec )
{
	assert( isdefined( destinationVec ) );
	assert( isdefined( destinationVec[0] ) );
	assert( isdefined( destinationVec[1] ) );
	assert( isdefined( destinationVec[2] ) );
	vecArray = [];
	vecArray[0] = destinationVec;
	return vecArray;
}

civilian_waittill_spawn( target_name )
{
	civCount = getNumberCivilianSpawnersByTargetname( target_name );
	if ( civCount == 0 )
	{
		assertMsg( "civilian_waittill_spawn( target_name ) found no civilian spawners with that targetname" );
		return;
	}
	if ( civCount > 1 )
	{
		assertMsg( "civilian_waittill_spawn( target_name ) used with more than one civilian with the same targetname" );
		return;
	}
	return civilian_waittill_spawn_thread( target_name );
}

civilian_waittill_arrayspawn( target_name )
{
	civCount = getNumberCivilianSpawnersByTargetname( target_name );
	if ( civCount == 0 )
	{
		assertMsg( "civilian_waittill_arrayspawn( target_name ) found no civilian spawners with that targetname" );
		return;
	}
	return civilian_waittill_arrayspawn_thread( target_name );
}

civilian_delete()
{
	assert( isdefined( self ) );
	structarray_remove( level.drones["civilian"], self );
	self notify ( "civilian_death" );
	self delete();
}