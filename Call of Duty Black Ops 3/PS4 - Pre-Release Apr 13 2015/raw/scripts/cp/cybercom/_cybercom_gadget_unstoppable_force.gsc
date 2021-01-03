#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                     
	
#using scripts\shared\system_shared;

#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;

                                                                                                      	                       	     	                                                                     
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;

#namespace cybercom_gadget_unstoppable_force;




function init()
{

}

function main()
{
	cybercom_gadget::registerAbility( 1, 	(1<<5) );

	level.cybercom.unstoppable_force 					= spawnstruct();
	level.cybercom.unstoppable_force._is_flickering 	= &_is_flickering;
	level.cybercom.unstoppable_force._on_flicker 		= &_on_flicker;
	level.cybercom.unstoppable_force._on_give 			= &_on_give;
	level.cybercom.unstoppable_force._on_take 			= &_on_take;
	level.cybercom.unstoppable_force._on_connect 		= &_on_connect;
	level.cybercom.unstoppable_force._on 				= &_on;
	level.cybercom.unstoppable_force._off		 		= &_off;
	level.cybercom.unstoppable_force._is_primed 		= &_is_primed;
}

function _is_flickering( slot )
{
	// returns true when the gadget is flickering
}

function _on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function _on_give( slot, weapon )
{
	self.cybercom.weapon = weapon;

}

function _on_take( slot, weapon )
{
	self.cybercom.is_primed = undefined;
	self.cybercom.weapon	= undefined;
	// executed when gadget is removed from the players inventory
}

//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	self.cybercom.is_primed = undefined;
	
	self thread watch_collisions();
	// excecutes when the gadget is turned on
}

function _off( slot, weapon )
{
	self notify( "unstoppable_watch_collisions" );
	// excecutes when the gadget is turned off`
}

function _is_primed( slot, weapon )
{

}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _is_good_target(target)
{
	if (!isDefined(target))
		return false;
		
	if ( !isAlive(target)) 
		return false;
		
	if (( isdefined( target.ignoreme ) && target.ignoreme ) )
		return false;
		
	if( target cybercom::cybercom_AICheckOptOut("cybercom_unstoppleforce")) 
		return false;

	if (!( isdefined( target.takedamage ) && target.takedamage ) )
		return false;

    if( IsActor( target ) && target IsInScriptedState() )
		return false;

	if(!( isdefined( target.allowdeath ) && target.allowdeath ))
		return false;

	if(( isdefined( target.blockingpain ) && target.blockingpain ))
		return false;
	
	if(isDefined(target.archetype) && target.archetype == "warlord")
		return false;
	
	if( IsActor( target ) && target.a.pose !="stand" && target.a.pose != "crouch" )
		return false;
		
return true;
}

function private _get_valid_targets()
{
	humans =  ArrayCombine(GetAISpeciesArray( "axis", "human" ),GetAISpeciesArray( "team3", "human" ),false,false);
	robots =  ArrayCombine(GetAISpeciesArray( "axis", "robot" ),GetAISpeciesArray( "team3", "robot" ),false,false);
	return ArrayCombine(humans,robots,false,false);
}


function watch_collisions()
{
	self notify( "unstoppable_watch_collisions" );
	self endon( "unstoppable_watch_collisions" );
	
	self endon( "death" );

	while( true )
	{
		enemies = _get_valid_targets();
		closeTargets = cybercom::getArrayItemsWithin(self.origin,enemies, GetDvarInt( "scr_immolation_radiusSQ", ( (45) * (45) ) ) );
		foreach( guy in closeTargets)
		{
			if ( _is_good_target(guy) )
			{
				guy kill( guy.origin, self, self );
			}
		}
		{wait(.05);};
	}
}
