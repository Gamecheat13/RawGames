#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;

#using scripts\shared\ai\systems\init;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\weaponList;
#using scripts\shared\ai\systems\ai_interface;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                              	   	                             	  	                                      

#namespace ai;

/@
"Name: set_ignoreme( <val> )"
"Summary: Sets an actor's .ignoreme value. If 'true', other entities will ignore him."
"Module: AI"
"CallOn: an actor"
"Example: guy set_ignoreme( true );"
"MandatoryArg: <val> : Boolean"
"SPMP: singleplayer"
@/
function set_ignoreme( val )
{
	assert( IsSentient( self ), "Non ai tried to set ignoreme" );
	self.ignoreme = val;
}

/@
"Name: set_ignoreall( <val> )"
"Summary: Sets an actor's .ignoreall value"
"Module: AI"
"CallOn: an actor"
"Example: guy set_ignoreall( true );"
"MandatoryArg: <val> : Boolean"
"SPMP: singleplayer"
@/
function set_ignoreall( val )
{
	assert( isSentient( self ), "Non ai tried to set ignoraell" );
	self.ignoreall = val;
}

/@
"Name: set_pacifist( <val> )"
"Summary: Sets an actor's .pacifist value. If 'true', he'll only fire back if fired upon first."
"Module: AI"
"CallOn: an actor"
"Example: guy set_pacifist( true );"
"MandatoryArg: <val> : Boolean"
"SPMP: singleplayer"
@/
function set_pacifist( val )
{
	assert( IsSentient( self ), "Non ai tried to set pacifist" );
	self.pacifist = val;
}

/@
"Name: disable_pain()"
"Summary: Disables pain on the AI"
"Module: Utility"
"CallOn: An ai"
"Example: level.zakhaev disable_pain();"
"SPMP: singleplayer"
@/
function disable_pain()
{
	assert( isalive( self ), "Tried to disable pain on a non ai" );
	self.allowPain = false;
}

/@
"Name: enable_pain()"
"Summary: Enables pain on the AI"
"Module: Utility"
"CallOn: An ai"
"Example: level.zakhaev enable_pain();"
"SPMP: singleplayer"
@/
function enable_pain()
{
	assert( isalive( self ), "Tried to enable pain on a non ai" );
	self.allowPain = true;
}

/@
"Name: gun_remove()"
"Summary: Removed the gun from the given AI. Often used for scripted sequences where you dont want the AI to carry a weapon."
"Module: AI"
"CallOn: An AI"
"Example: level.price gun_remove();"
"SPMP: singleplayer"
@/
function gun_remove()
{
	self shared::placeWeaponOn( self.weapon, "none" );
	self.gun_removed = true;
}

/@
"Name: gun_switchto()"
"Summary: Switches the given AI's gun to the one specified."
"Module: AI"
"CallOn: An AI"
"MandatoryArg: <weaponName> : The weapontype name you want the AI to switch to."
"MandatoryArg: <whichHand> : Which hand to put the weapon in."
"Example: level.zeitzev gun_switchto( GetWeapon( "ppsh" ), "right" );"
"SPMP: singleplayer"
@/
function gun_switchto( weapon, whichHand )
{
	self shared::placeWeaponOn( weapon, whichHand );
}

/@
"Name: gun_recall()"
"Summary: Give the AI his gun back."
"Module: AI"
"CallOn: An AI"
"Example: level.price gun_recall();"
"SPMP: singleplayer"
@/
function gun_recall()
{
	self shared::placeWeaponOn( self.primaryweapon, "right" );
	self.gun_removed = undefined;
}

/@
"Name: set_behavior_attribute()"
"Summary: Call on an AI to change a behavior interface attribute." +
	"Available attributes are archetype specific and located in the archetype's interface gsc." +
	"For example, robot attributes are in archetype_robot_interface.gsc"
"Module: AI"
"CallOn: an actor"
"MandatoryArg: <attribute> : The interface attribute to modify."
"MandatoryArg: <value> : Value to set."
"Example: guy set_behavior_attribute( "sprint", true );"
@/
function set_behavior_attribute( attribute, value )
{
	if( GetDvarint("ai_spawn_only_zombies") == 1 )
	{
		if( has_behavior_attribute( attribute ) )
			SetAiAttribute( self, attribute, value );
	}
	else
	{
		SetAiAttribute( self, attribute, value );
	}
}


/@
"Name: get_behavior_attribute()"
"Summary: Call on an AI to return the current value of a behavior interface attribute." +
	"Available attributes are archetype specific and located in the archetype's interface gsc." +
	"For example, robot attributes are in archetype_robot_interface.gsc"
"Module: AI"
"CallOn: an actor"
"MandatoryArg: <attribute> : The interface attribute to retrieve."
"Example: guy get_behavior_attribute( "sprint" );"
@/
function get_behavior_attribute( attribute )
{
	return GetAiAttribute( self, attribute );
}

/@
"Name: has_behavior_attribute()"
"Summary: Call on an AI to return whether the actor has a particular attribute defined."
"Module: AI"
"CallOn: an actor"
"MandatoryArg: <attribute> : The interface attribute to retrieve."
"Example: guy has_behavior_attribute( "sprint" );"
@/
function has_behavior_attribute( attribute )
{
	return HasAiAttribute( self, attribute );
}

/@
"Name: is_dead_sentient()"
"Summary: Checks to see if the AI is not defined, not sentient, and dead"
"CallOn: AI"
"MandatoryArg: <suspect> The AI you're checking to see is dead."
"Example: if ( is_dead_sentient( self ) )"
"SPMP: singleplayer"
@/
function is_dead_sentient()
{
	if ( IsSentient( self ) && !IsAlive( self ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

/@
"Name: waittill_dead( <guys> , <num> , <timeoutLength> )"
"Summary: Waits until all the AI in array < guys > are dead."
"Module: AI"
"CallOn: "
"MandatoryArg: <guys> : Array of actors to wait until dead"
"OptionalArg: <num> : Number of guys that must die for this function to continue"
"OptionalArg: <timeoutLength> : Number of seconds before this function times out and continues"
"Example: waittill_dead( GetAITeamArray( "axis" ) );"
"SPMP: singleplayer"
@/
function waittill_dead( guys, num, timeoutLength )
{
	// verify the living - ness of the ai
	allAlive = true;
	for( i = 0;i < guys.size;i++ )
	{
		if( isalive( guys[ i ] ) )
		{
			continue;
		}
		allAlive = false;
		break;
	}
	assert( allAlive, "Waittill_Dead was called with dead or removed AI in the array, meaning it will never pass." );
	if( !allAlive )
	{
		newArray = [];
		for( i = 0;i < guys.size;i++ )
		{
			if( isalive( guys[ i ] ) )
			{
				newArray[ newArray.size ] = guys[ i ];
			}
		}
		guys = newArray;
	}

	ent = SpawnStruct();
	if( isdefined( timeoutLength ) )
	{
		ent endon( "thread_timed_out" );
		ent thread waittill_dead_timeout( timeoutLength );
	}

	ent.count = guys.size;
	if( isdefined( num ) && num < ent.count )
	{
		ent.count = num;
	}
	array::thread_all( guys,&waittill_dead_thread, ent );

	while( ent.count > 0 )
	{
		ent waittill( "waittill_dead guy died" );
	}
}

/@
"Name: waittill_dead_or_dying( <guys> , <num> , <timeoutLength> )"
"Summary: Similar to waittill_dead(). Waits until all the AI in array < guys > are dead OR dying (long deaths)."
"Module: AI"
"CallOn: "
"MandatoryArg: <guys> : Array of actors to wait until dead or dying"
"OptionalArg: <num> : Number of guys that must die or be dying for this function to continue"
"OptionalArg: <timeoutLength> : Number of seconds before this function times out and continues"
"Example: waittill_dead_or_dying( GetAITeamArray( "axis" ) );"
"SPMP: singleplayer"
@/
function waittill_dead_or_dying( guys, num, timeoutLength )
{
	// verify the living - ness and healthy - ness of the ai
	newArray = [];
	for( i = 0;i < guys.size;i++ )
	{
		if( isalive( guys[ i ] ) && !guys[ i ].ignoreForFixedNodeSafeCheck )
		{
			newArray[ newArray.size ] = guys[ i ];
		}
	}
	guys = newArray;

	ent = spawnStruct();
	if( isdefined( timeoutLength ) )
	{
		ent endon( "thread_timed_out" );
		ent thread waittill_dead_timeout( timeoutLength );
	}

	ent.count = guys.size;

	// optional override on count
	if( isdefined( num ) && num < ent.count )
	{
		ent.count = num;
	}

	array::thread_all( guys,&waittill_dead_or_dying_thread, ent );

	while( ent.count > 0 )
	{
		ent waittill( "waittill_dead_guy_dead_or_dying" );
	}
}

function private waittill_dead_thread( ent )
{
	self waittill( "death" );
	ent.count-- ;
	ent notify( "waittill_dead guy died" );
}

function waittill_dead_or_dying_thread( ent )
{
	self util::waittill_either( "death", "pain_death" );
	ent.count-- ;
	ent notify( "waittill_dead_guy_dead_or_dying" );
}

function waittill_dead_timeout( timeoutLength )
{
	wait( timeoutLength );
	self notify( "thread_timed_out" );
}

//internal function called by shoot_at_target. This will ensure that we start computing the duration of shoot_at_target only after the first shot
function private wait_for_shoot()
{
	self endon( "stop_shoot_at_target" );
	if( IsVehicle( self ) )
	{
		self waittill( "weapon_fired" );
	}
	else
	{
		self waittill("shoot");
	}
	self.start_duration_comp = true;
}

/@
"Name: shoot_at_target(mode, target, tag, duration)"
"Summary: Force AI to aim and shoot at given target"
"Module: AI"
"CallOn: An AI"
"MandatoryArg: <mode> The mode of firing. The three modes are 'normal', 'shoot_until_target_dead', 'kill_within_time'"
"MandatoryArg: <target> The target entity to shoot at"
"OptionalArg:  <tag> The tag of the entity to shoot at"
"OptionalArg: <duration> The duraton of firing. Leave undefined for one shot only."
"OptionalArg: <setHealth> If defined, sets the health of the target."
"OptionalArg: <ignoreFirstShotWait> If true, will not wait before calculating the duration."
"Example: ai_friendly shoot_at_target("normal", enemy, undefined, 5); This fires at the enemy for 5 seconds." +
	"ai_friendly shoot_at_target("shoot_until_target_dead", enemy, "j_head"); This fires at the enemy till he dies. Also, the tag is set to aim for the head." +
	"ai_friendly shoot_at_target("kill_within_time", enemy, undefined, 3); This ensures that the ai will kill the target within 3 seconds."
"SPMP: singleplayer"
@/
function shoot_at_target( mode, target, tag, duration, setHealth, ignoreFirstShotWait )
{
	self endon("death");
	self endon("stop_shoot_at_target");

	Assert( IsDefined( target ), "shoot_at_target was passed an undefined target" );
	Assert( IsDefined( mode ), "Undefined mode. A mode must be passed to shoot_at_target" );
	mode_flag = ( mode === "normal" ) || ( mode === "shoot_until_target_dead" ) || ( mode === "kill_within_time" );
	Assert( mode_flag, "Unsupported mode. 'Mode must be normal', 'shoot_until_target_dead' or 'kill_within_time'" );
	
	if( IsDefined( duration ) )
	{
		Assert( duration >= 0, "Duration must be a zero or a positive quantity" );
	}
	else
	{
		duration = 0;
	}
	
	if ( isDefined(setHealth) && isDefined(target) )
	{
		target.health = setHealth;
	}
	
	if ( !IsDefined( target ) || ( ( ( mode === "shoot_until_target_dead" ) ) && ( target.health <= 0 ) ) )
	{
		return;	// undefined target or target already dead
	}
	
	if( IsDefined(tag) && tag != "" )
	{
		self SetEntityTarget( target, 1, tag );
	}
	else
	{
		self SetEntityTarget( target, 1 );
	}
	
	// make sure the AI shoots it, even if not visible
	self.cansee_override = true;
	self.start_duration_comp = false;
	
	switch( mode )
	{
		case "normal": 
			break;
		case "shoot_until_target_dead": 
			duration = -1;
			break;
		case "kill_within_time":
			target DamageMode( "next_shot_kills" );
			break;
	}
	
	if( IsVehicle( self ) )
	{
		// Reset vehicle firing cool downs so we can fire right away
		self vehicle_ai::ClearAllCooldowns();
	}
	
	// wait for first shot
	
	if(ignoreFirstShotWait === true)
	{
		self.start_duration_comp = true;
	}
	else
	{
		self thread wait_for_shoot();
	}

	// fire for duration
	if( IsDefined(duration) && IsDefined( target ) && target.health > 0 )
	{
		if( duration >= 0)
		{
			elapsed = 0;
			while( elapsed <= duration && target.health > 0 )
			{	
				elapsed += 0.05;
				if( !( isdefined( self.start_duration_comp ) && self.start_duration_comp ) )
					elapsed = 0;
				{wait(.05);};
			}
			if( mode == "kill_within_time" )
			{
				self.perfectaim = true;
				self.aim_set_by_shoot_at_target = true;
				target waittill( "death" );
			}
		}
		else if (duration == -1)
		{
			target waittill( "death" );
		}
	}
	
	stop_shoot_at_target();
}

/@
"Name: stop_shoot_at_target()"
"Summary: Give the AI his gun back."
"Module: AI"
"CallOn: An AI"
"Example: level.price stop_shoot_at_target();"
"SPMP: singleplayer"
@/
function stop_shoot_at_target()
{
	self ClearEntityTarget();
	
	if( ( isdefined( self.aim_set_by_shoot_at_target ) && self.aim_set_by_shoot_at_target ) )
	{
		self.perfectaim = false;
		self.aim_set_by_shoot_at_target = false;
	}
	
	self.cansee_override = false;

	self notify("stop_shoot_at_target");
}

function wait_until_done_speaking()
{
	self endon( "death" );
	while ( self.isSpeaking )
	{
		{wait(.05);};
	}
}

/@
"Name: set_goal( <value>, [key = "targetname"], [b_force] )"
"Summary: Set's the ai's goal based on KVP."
"Module: AI"
"CallOn: An AI"
"MandatoryArg: <value>: Either a vector, or a KVP value of a node, ent, struct to set the goal to"
"OptionalArg: [key]: If the value is a KVP, use this key"
"OptionalArg: [b_force]: force goal param passed to SetGoal()"
"Example: guy ai::set_goal( value, key );"
"SPMP: singleplayer"
@/
function set_goal( value, key = "targetname", b_force = false )
{
	goal = GetNode( value, key );
		
	if ( isdefined( goal ) )
	{
		self SetGoal( goal, b_force );
	}
	else
	{
		goal = GetEnt( value, key );
	
		if ( isdefined( goal ) )
		{
			self SetGoal( goal, b_force );
		}
		else
		{
			goal = struct::get( value, key );
	
			if ( isdefined( goal ) )
			{
				self SetGoal( goal.origin, b_force );
			}
		}
	}
	
	return goal;
}

/@
"Name: force_goal(<goto>, [n_radius], [b_shoot], [str_end_on], [b_keep_colors])"
"Summary: Force an AI to go to goal by temporarily disabling AI features."
"Module: AI"
"MandatoryArg: <pos>/<node>/<entity>/<volume> - position, node, entity or volume to go to"	
"OptionalArg: [n_radius] : Option goal radius. AI will be considered at goal within this distance from goal."
"OptionalArg: [b_shoot] : Enable/Disable shoot while moving (defaults to true)."
"OptionalArg: [str_end_on] : The endon string that will set this AI back to normal (defaults to 'goal')."
"OptionalArg: [b_keep_colors] : If colors will be enabled again after force goal (defaults to 'false')."	
"Example: self thread ai::force_goal( node, 20, true );"
"SPMP: singleplayer"
@/
function force_goal( goto, n_radius, b_shoot = true, str_end_on, b_keep_colors = false, b_should_sprint = false )
{
	self endon( "death" );
	s_tracker = SpawnStruct();
	self thread _force_goal( s_tracker, goto, n_radius, b_shoot, str_end_on, b_keep_colors, b_should_sprint );
	s_tracker waittill( "done" );
}

function _force_goal( s_tracker, goto, n_radius, b_shoot = true, str_end_on, b_keep_colors = false, b_should_sprint = false )
{
    self endon( "death" );
    
    self notify( "new_force_goal" );
    
    flagsys::wait_till_clear( "force_goal" ); // let any previous force goal thread cleanup first
    flagsys::set( "force_goal" );
       
    if ( isdefined( goto ) )
    {
    	if ( IsDefined( n_radius ) )
    	{
    		Assert( ( IsFloat( n_radius ) || IsInt( n_radius ) ), "ai_shared::force_goal expects n_radius to be an int or a float." );
    		self SetGoal( goto );
    	}
    	else
    	{
       		self SetGoal( goto, true );
    	}
    }

    goalradius = self.goalradius;
    if ( IsDefined( n_radius ) )
    {
    	Assert( ( IsFloat( n_radius ) || IsInt( n_radius ) ), "ai_shared::force_goal expects n_radius to be an int or a float." );
        self.goalradius = n_radius;
    }

    color_enabled = false;
    if ( !b_keep_colors )
    {
    	if ( IsDefined( colors::get_force_color() ) )
        {
            color_enabled = true;
            self colors::disable();
        }
    }

    allowpain           = self.allowpain;
    ignoreall           = self.ignoreall;
    ignoreme            = self.ignoreme;
    ignoresuppression   = self.ignoresuppression;
    grenadeawareness    = self.grenadeawareness;
    
    if ( !b_shoot )
    {
        self set_ignoreall( true );
    }    
    
    if( b_should_sprint )
    {
    	self set_behavior_attribute( "sprint", true );
    }
    
    self.ignoresuppression  = true;
    self.grenadeawareness	= 0;
    self set_ignoreme( true );
    self disable_pain();
    
    self PushPlayer( true );
    
    self util::waittill_any( "goal", "new_force_goal", str_end_on );
    
    if ( color_enabled && b_keep_colors )
    {
    	colors::enable();
    }

    self PushPlayer( false );    // assume we want this off once we have reached goal
    
    self ClearForcedGoal();
    
    self.goalradius = goalradius;
    self set_ignoreall( ignoreall );
    self set_ignoreme( ignoreme );

    if ( allowpain )
    {
        self enable_pain();
    }
    
    self set_behavior_attribute( "sprint", false );
    
    self.ignoresuppression       = ignoresuppression;
    self.grenadeawareness        = grenadeawareness;
    
    flagsys::clear( "force_goal" );
    s_tracker notify( "done" );
}

/@
"Name: stopPainWaitInterval()"
"Summary: Removes pain block"
"Module: AI"
"Example: self thread ai::allowPainWithMinimumInterval( 5000 );"
"SPMP: singleplayer"
@/
function stopPainWaitInterval()
{
	self notify("painWaitIntervalRemove");
}

function private _allowPainRestore()
{
	self endon("death");
	self util::waittill_any("painWaitIntervalRemove","painWaitInterval");
	self.allowPain = true;
}

/@
"Name: painWaitInterval(<mSec>)"
"Summary: Block pain reaction for mSec.  AI still takes damage but doesn't play pain animations"
"Module: AI"
"MandatoryArg: <mSec> - number of milliseconds to block pain"	
"Example: self thread ai::allowPainWithMinimumInterval( 5000 );"
"SPMP: singleplayer"
@/
function painWaitInterval(mSec)
{
	self endon("death");
	self notify("painWaitInterval");
	self endon("painWaitInterval");
	self endon("painWaitIntervalRemove");
	self thread _allowPainRestore();
	
	if(!isDefined(mSec) || mSec < 20 )
		mSec = 20;
		
	while(isAlive(self))
	{
		self waittill("pain");
		self.allowPain = false;
		wait (mSec/1000);
		self.allowPain = true;		
	}
}


/@
"Name: patrol( start_path_node )"
"Summary: Sets a human to patrol along the points of a path, stopping to play scenes or wait for a short period of time at each path node.  Behavior ends when actor gets a target, or hits the end of the path.  Be sure to set Alert on Spawn to false on the actor's spawner"
"Summary: Set self.should_stop_patrolling to true to end the patrol behavior early."
"Module: patrol_human"
"Mandatory Aarg: start_path_node - the first path node for the path the actor should follow"
"Example: guy patrol_human::patrol( begin_node)"
"SPMP: SP"
@/
function patrol( start_path_node )
{
	self endon( "death" );
	self endon( "stop_patrolling" );
	
	self notify( "go_to_spawner_target");
	self.target = undefined;
	
	assert( isDefined( start_path_node ), self.targetname + " has not been assigned a valid node or scene scriptbundle for his patrol path to start on" );
	assert( start_path_node.type == "Path" || isdefined( start_path_node.scriptbundlename ), "The starting point '" + start_path_node.targetname + "' for a patrol path is not a path node or scene script bundle"  );
	
	self.old_goal_radius = self.goalradius;
		
	self thread end_patrol_on_enemy_targetting();
	
	self.currentgoal = start_path_node;
	
	
	While( 1 )
	{
	
		if( isDefined( self.currentgoal.type) && self.currentgoal.type == "Path" )//handle case where current goal is a path node
		{
			self ai::set_behavior_attribute( "patrol", true );

			self setgoal( self.currentgoal, true );
		
			self waittill( "goal" );
			
			if( isDefined( self.currentgoal.script_notify ))
			{
				self notify ( self.currentgoal.script_notify );
				level notify (self.currentgoal.script_notify );
			}
			
			
			if (isDefined( self.currentgoal.script_flag_set ))
			{
				flag = self.currentgoal.script_flag_set;
				
				if ( !isdefined( level.flag[ flag ] ) )
				{
					level flag::init( flag );
				}
				
				level flag::set( flag );
			}
		
			
			if( !isDefined( self.currentgoal.script_wait_min ))
			{
				self.currentgoal.script_wait_min = 0;
			}
			
			if( !isDefined( self.currentgoal.script_wait_max ))
			{
				self.currentgoal.script_wait_max = 0;
			}
			
			assert( self.currentgoal.script_wait_min <= self.currentgoal.script_wait_max , "Patrol max wait is less than the min wait on " + self.currentgoal.targetname );
			
			if( !isdefined( self.currentgoal.scriptbundlename) )
			{
				wait_variability = self.currentgoal.script_wait_max - self.currentgoal.script_wait_min;
				wait_time = self.currentgoal.script_wait_min + randomfloat( wait_variability );
				self ai::set_behavior_attribute( "patrol", false );
				self notify( "patrol_goal", self.currentgoal );
				wait wait_time;
			}
			else
			{
				self scene::play( self.currentgoal.scriptbundlename , self );
			}
		}
		else //handle case where the current goal is a scene scriptbundle
		{
			self.currentgoal scene::play( self );
		}
		
		//once current goal handling is done, select a new goal from the targets of the current one
		self patrol_next_node();
	}
}

function patrol_next_node( )
{
	//get current goal targets in an array if we have a next target
	target_nodes = [];
	target_scenes = [];
	if ( isdefined( self.currentgoal.target ) )
	{
		target_nodes = getnodearray( self.currentgoal.target, "targetname" );
		target_scenes = struct::get_array( self.currentgoal.target , "targetname" );
	}
	
	if( target_nodes.size == 0 && target_scenes.size == 0 )
	{
		self end_and_clean_patrol_behaviors();
	}
	else
	{
		if( target_nodes.size != 0)
		{
			self.currentgoal = array::random( target_nodes );
		}
		else
		{
			self.currentgoal = array::random( target_scenes );
		}
	}
}

function end_patrol_on_enemy_targetting()
{
	
	self endon( "death" );
	self endon( "stop_patrolling" );
	
	While(1)
	{
		if( isdefined( self.enemy) || self.should_stop_patrolling === true )
		{
			self end_and_clean_patrol_behaviors();
		}
		
		wait 0.1;
	}
}

function end_and_clean_patrol_behaviors()
{
	if ( isdefined( self.currentgoal ) && isdefined( self.currentgoal.scriptbundlename ) && isDefined( self._o_scene ) )
		self._o_scene cscene::stop();
		
	self ai::set_behavior_attribute( "patrol", false );
	if ( isDefined( self.old_goal_radius ) )
		self.goalradius = self.old_goal_radius;
	self ClearForcedGoal();	
	self notify( "stop_patrolling" );
}