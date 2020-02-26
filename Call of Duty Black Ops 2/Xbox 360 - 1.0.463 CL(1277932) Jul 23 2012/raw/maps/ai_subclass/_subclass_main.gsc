#include maps\_utility; 
#include common_scripts\utility; 
#include animscripts\combat_utility; 
#include animscripts\utility; 

#include animscripts\ai_subclass\anims_table_militia;
#include maps\ai_subclass\_subclass_militia; 
#include animscripts\ai_subclass\anims_table_dualwield; 
#include maps\ai_subclass\_subclass_dualwield; 
#include animscripts\ai_subclass\anims_table_elite; 
#include maps\ai_subclass\_subclass_elite; 

subclass_setup_spawn_functions()
{
	// setup subclasses
	if ( !isdefined( level.subclass_spawn_functions ) )
		level.subclass_spawn_functions = [];

	// add more genric subclasses as we proceed in the game
	level.subclass_spawn_functions[ "regular" ] 	= ::subclass_regular;
	level.subclass_spawn_functions[ "militia" ] 	= ::subclass_militia;
	level.subclass_spawn_functions[ "dualwield" ] 	= ::subclass_dualwield;
	level.subclass_spawn_functions[ "elite" ] 	= ::subclass_elite;
}

run_subclass_spawn_function()
{
	// special function for this AI's subclass, militia, elite, etc
	assert( isdefined( level.subclass_spawn_functions[ self.subclass ] ), "subclass spawn function not defined for '" + self.subclass + "'" );

	[[ level.subclass_spawn_functions[ self.subclass ] ]]();

}

subclass_regular()
{
	if( self.team == "allies" )
		subclass_regular_allies();
	else
		subclass_regular_axis();
}

subclass_regular_allies()
{
	self.a.disableWoundedSet 	    = true;
	self.a.neverSprintForVariation  = true;
	self.a.favor_lean 			    = true;
	self.maxfaceenemydist 		    = 350;
	//self.ignoresuppression		    = 1;
	//self.a.fake_suppressedBehavior = true;
}

subclass_regular_axis()
{
	
}
