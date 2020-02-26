#include maps\_utility; 
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\combat_utility;
#include animscripts\Debug;

#using_animtree( "generic_human" );

init_civilians()
{
	// Grab all the civilian spawners from the level and start a spawn function thread on them.
	ai = GetSpawnerArray();

	civilians = [];

	for( i = 0; i< ai.size; i++ )
	{
		if( IsSubStr( ToLower( ai[i].classname ), "civilian" ) )
			civilians[civilians.size] = ai[i];
	}

	array_thread( civilians, ::add_spawn_function, ::civilian_spawn_init );
}

civilian_spawn_init()
{
	self.is_civilian 		  = true;		// for civilian specific overrides in animscripts.
	self.ignoreall 	 		  = true; 		// dont pick any enemy.
	self.ignoreme    		  = true;		// dont pick me as enemy.
	self.allowdeath  		  = true; 		// allows death during animscripted calls.
	self.gibbed      		  = false; 
	self.head_gibbed 		  = false;
	self.grenadeawareness     = 0;
	self.badplaceawareness    = 0;
	self.ignoreSuppression    = true; 	
	self.suppressionThreshold = 1; 
	self.dontShootWhileMoving = true;
	self.pathenemylookahead   = 0;
	self.badplaceawareness    = 0;
	self.chatInitialized      = false;
	self.dropweapon           = false; 
	self.goalradius 		  = 16;
	self.combatMode			  = "no_cover";
	self.disableExits		  = true;
	self.disableArrivals	  = true;
	self.specialReact		  = true;	// react doesnt happen if the AI is set to ignoreall
										// this is to override it		

	self.a.runOnlyReact		  = true;	// in this case prisoners will only react while running

	self disable_pain(); 				// civilians dont play pain, their health is really low.
	self PushPlayer( true ); 		    // should be pushable if comes in path
	
	self.alwaysRunForward		= true;


	animscripts\shared::placeWeaponOn( self.primaryweapon, "none" );
	self allowedStances( "stand" );       

	self setup_civilian_attributes();
	self thread handle_civilian_sounds();
}

// --------------------------------------------------------------------------------
// ---- Civilian sounds ----
// --------------------------------------------------------------------------------

handle_civilian_sounds()
{
	self endon( "death" );
	
	// now start waiting until this civilian moves to play screaming sounds
	while(1)
	{
		if( self.a.script != "move" || self.a.movement != "run" )
		{
			wait(0.5);
			continue;
		}

		if( self.civilianSex == "male" )
		    self playsound ("chr_civ_scream_male");
		else
		    self playsound ("chr_civ_scream_female");
			
		wait( RandomIntRange( 2, 5 ) );
	}
}

// --------------------------------------------------------------------------------
// ---- Civilian attributes - sex and nationality ----
// --------------------------------------------------------------------------------

setup_civilian_attributes()
{
	classname	= ToLower( self.classname );
	tokens		= StrTok( classname, "_" );

	// Decide sex
	self.civilianSex = "male";

	if( IsSubStr( classname, "female" ) )
		self.civilianSex = "female";

	self.nationality = "default";
}