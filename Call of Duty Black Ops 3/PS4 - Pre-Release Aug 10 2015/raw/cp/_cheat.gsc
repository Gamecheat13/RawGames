#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace cheat;

function autoexec __init__sytem__() {     system::register("cheat",&__init__,undefined,undefined);    }

function __init__()
{
	level.cheatStates= [];
	level.cheatFuncs = [];
	level.cheatDvars = [];

	level flag::init("has_cheated");

	level thread death_monitor();
}

// MikeD (12/17/2007): player_init, called when the player spawns in.
function player_init()
{
	self thread specialFeaturesMenu();
}

function death_monitor()
{
	setDvars_based_on_varibles(); // do one on the first frame of the map too.
	
// t7todo - fix when saves work properly in MP
//	while ( 1 )
//	{
//		if ( issaverecentlyloaded() )
//			setDvars_based_on_varibles();
//		wait .1;
//	}
}

function setDvars_based_on_varibles()
{		
	/#
	for ( index = 0; index < level.cheatDvars.size; index++ )
		SetDvar( level.cheatDvars[ index ], level.cheatStates[ level.cheatDvars[ index ] ] );
	#/
}


function addCheat( toggleDvar, cheatFunc )
{
	/#SetDvar( toggleDvar, 0 );#/
	level.cheatStates[toggleDvar] = getDvarInt( toggleDvar );
	level.cheatFuncs[toggleDvar] = cheatFunc;

	if ( level.cheatStates[toggleDvar] )
		[[cheatFunc]]( level.cheatStates[toggleDvar] );
}


function checkCheatChanged( toggleDvar )
{
	cheatValue = getDvarInt( toggleDvar );
	if ( level.cheatStates[toggleDvar] == cheatValue )
		return;

	if( cheatValue )
		level flag::set("has_cheated");
			
	level.cheatStates[toggleDvar] = cheatValue;
	
	[[level.cheatFuncs[toggleDvar]]]( cheatValue );
}


function specialFeaturesMenu()
{
	level endon("unloaded");
	addCheat( "sf_use_ignoreammo",&ignore_ammoMode );

	level.cheatDvars = getArrayKeys( level.cheatStates );
			
	for ( ;; )
	{
		for ( index = 0; index < level.cheatDvars.size; index++ )
			checkCheatChanged( level.cheatDvars[index] );

		wait 0.5;
	}
}

function ignore_ammoMode( cheatValue )
{
	if ( cheatValue )
		setsaveddvar ( "player_sustainAmmo",  1 );
	else
		setsaveddvar ( "player_sustainAmmo", 0 );
}

function is_cheating()
{
	return level flag::get("has_cheated");
}
