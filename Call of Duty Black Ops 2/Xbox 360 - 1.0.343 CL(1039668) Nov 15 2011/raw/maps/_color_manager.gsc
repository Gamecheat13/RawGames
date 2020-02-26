#include maps\_utility;
#include common_scripts\utility;

// ------------------------------------------------------------------------------------------
// ---- COLOR MANAGER -  Main think - should be called from level main, after flag inits ----
// ------------------------------------------------------------------------------------------

color_manager_think()
{
	// make sure that we dont have two instances of color manager thinks going on 
	if( IsDefined( level.color_manager_initialized ) )
		return;
	else
		level.color_manager_initialized = true;
	
	array_thread( GetEntArray( "color_manager", "targetname" ), ::color_manager_think_internal );
}

// -------------------------------------------------------------------------------------
// ---- COLOR MANAGER - Internal think -----
// -------------------------------------------------------------------------------------

color_manager_think_internal() // self = color manager trigger
{
	// current state is non-triggered for associated color trigger
	color_trigger = GetEnt( self.target, "targetname" );	
	color_trigger.triggered = false;

	// initialize the cm_flag if it wasn't initialized before
	if( IsDefined( self.cm_flag ) )
	{
		if( !level flag_exists( self.cm_flag ) )
		{
			flag_init( self.cm_flag );
		}
	}

	// start a thread that monitors if all the ai in associated in group are dead
	if( IsDefined( self.script_aigroup ) )
	{
		self thread color_manager_track_ai_group();	
	}
	
	// now wait for it to trigger or ai group to die
	if( IsDefined( self.cm_flag ) )
	{
		self thread color_manager_track_flag();
		self waittill_any( "trigger", "ai_group_died", self.cm_flag );
	}
	else
	{
		self waittill_any( "trigger", "ai_group_died" );
	}

	// wait for that flag before advancing colors, as it might not be set yet
	if( IsDefined( self.cm_flag ) )
	{
		flag_wait( self.cm_flag );
	}
	
	// if script_aigroup is defined then wait for it to die or kill if told
	if( IsDefined( self.script_aigroup ) )
	{	
		// set cm_dont_kill to 1 if the you dont want color manager to kill the ai
		if( !IsDefined( self.cm_dont_kill ) )
		{
/#
			self thread color_manager_debug_aigroup();
#/
			// wait before killing if mentioned
			if( IsDefined( self.cm_kill_delay ) )
			{
/#
				self thread color_manager_debug_kill_delay();
#/
				wait( self.cm_kill_delay );
			}

			self color_manager_kill_spawners();
			array_thread( get_ai_group_ai( self.script_aigroup ), ::kill_ai );
		}
/#
		self thread color_manager_debug_wait_aigroup();
#/
		// waittill ai group is cleared
		waittill_ai_group_cleared( self.script_aigroup );
	}

/#
	self thread color_manager_debug_color_triggered();
#/	
	
	// if there is a next color trigger and that is triggered then dont trigger current associated trigger
	next_color_trigger_triggered = self color_manager_get_next_color_trigger_state( color_trigger );

	if( !next_color_trigger_triggered )
	{
		// trigger the associated color trigger, this shouldnt do anything if next color trigger is triggered
		trigger_use( self.target, "targetname", get_players()[0] );
		color_trigger.triggered = true;
	}
	else
	{
		// if there is a flag associated with this color trigger, then even if we dont trigger this 
		// color trigger we need to set that flag
		if( IsDefined( self.script_flag_set ) )
		{
			flag_set( self.script_flag_set );
		}
	}

	// delete the color manager trigger if set to be deleted
	if( IsDefined( self.cm_delete ) )
	{
		self Delete();
	}
}

// returns the state of the next color trigger if there is one
color_manager_get_next_color_trigger_state( color_trigger ) // self = color manager trigger
{
	if( IsDefined( color_trigger.target ) )
	{
		next_color_trigger = GetEnt( color_trigger.target, "targetname" );
		
		if( next_color_trigger.triggered )
		{
			return true;
		}
	}

	return false;
}

color_manager_track_ai_group() // self = color manager trigger
{
	self endon("trigger"); // dont need to wait if the color manager is already triggered
	
	// waittill ai group is cleared
	waittill_ai_group_cleared( self.script_aigroup );

	// notify the main think thread
	self notify("ai_group_died");
}

color_manager_track_flag() // self = color manager trigger
{
	self endon("trigger"); // dont need to wait if the color manager is already triggered

	flag_wait( self.cm_flag );
	self notify( self.cm_flag );
}


// -------------------------------------------------------------------------------------
// ---- COLOR MANAGER - Kill spawners and AI -----
// -------------------------------------------------------------------------------------

color_manager_kill_spawners() // self = color manager trigger
{
	// find all the spawners related to script_aigroup and delete them
	// this will automatically kill the spawn manager associated with these spawners
	spawners = GetSpawnerArray(); 

	for( i = 0; i < spawners.size; i++ )
	{
		if( IsDefined( spawners[i].script_aigroup ) && spawners[i].script_aigroup == self.script_aigroup )
		{
			spawners[i] Delete();
		}
	}
}


kill_ai() // self = ai
{
	// SUMEET_TODO - replace this with bloody death
	self DoDamage( self.health + 100, self.origin );
}


// -------------------------------------------------------------------------------------
// ---- COLOR MANAGER DEBUG -----
// -------------------------------------------------------------------------------------
/#

color_manager_debug_aigroup() // self = color manager trigger
{
	if( getdvar( "debug_color_manager" ) != "1" )
	{
		return;
	}	

	IPrintLn( "Killing Script AI group " + self.script_aigroup );
}


color_manager_debug_wait_aigroup() // self = color manager trigger
{
	if( getdvar( "debug_color_manager" ) != "1" )
	{
		return;
	}

	IPrintLn( "Waiting for Script AI group to die " + self.script_aigroup );
}


color_manager_debug_color_triggered() // self = color manager trigger
{
	if( getdvar( "debug_color_manager" ) != "1" )
	{
		return;
	}
	
	trigger = GetEnt( self.target, "targetname" );
	
	if( IsDefined( trigger ) )
	{
		if(	IsDefined( trigger.script_color_allies ) )
		{
			IPrintLn( "Triggering color trigger " + trigger.script_color_allies );
		}
		else	
		{
			IPrintLn( "Triggering color trigger " + trigger.targetname );
		}
	}
		
}


color_manager_debug_kill_delay() // self = color manager trigger
{
	if( getdvar( "debug_color_manager" ) != "1" )
	{
		return;
	}

	IPrintLn( "Waiting before clearing " + self.script_aigroup + " for " + self.cm_kill_delay + " seconds ");
}

#/