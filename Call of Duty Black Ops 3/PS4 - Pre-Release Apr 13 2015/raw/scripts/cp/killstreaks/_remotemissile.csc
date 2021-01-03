#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\util_shared;


                                                                       

#namespace remotemissile;

function autoexec __init__sytem__() {     system::register("remotemissile",&__init__,undefined,undefined);    }
	
function __init__()
{
	clientfield::register( "missile", "remote_missile_bomblet_fired", 1, 1, "int",&bomblets_deployed, !true, !true );
	clientfield::register( "missile", "remote_missile_fired", 1, 2, "int",&missile_fired, !true, !true );
}

function missile_fired( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( bNewEnt && oldVal == newVal )
	{
		return;
	}

	if( newVal == 1 )
	{
		player = getlocalplayer( localClientNum );
		owner = self GetOwner( localClientNum );

		clientObjID = util::getNextObjID( localClientNum );

		objective_add( localClientNum, clientObjID, "invisible", self.origin, self.team, owner );
		Objective_OnEntity( localClientNum, clientObjID, self, true, false, true );
		self.hellfireObjId = clientObjID;
		self thread destruction_watcher( localClientNum, clientObjID );


		objective_state( localClientNum, clientObjID, "active" );
		objective_SetIcon( localClientNum, clientObjID, "remotemissile_target" );
		objective_SetIconSize( localClientNum, clientObjID, 50 );
	}
	else if ( newVal == 2 )
	{
		if( isdefined( self.hellfireObjId ) )
		{
			self notify( "hellfire_detonated" );
			objective_delete( localClientNum, self.hellfireObjId );
			util::releaseObjID( localClientNum, self.hellfireObjId );
		}
	}
}

function bomblets_deployed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( bNewEnt && oldVal == newVal )
	{
		return;
	}

	if( newVal == 1 )
	{
		player = getlocalplayer( localClientNum );
		owner = self GetOwner( localClientNum );

		clientObjID = util::getNextObjID( localClientNum );

		objective_add( localClientNum, clientObjID, "invisible", self.origin, self.team, owner );
		Objective_OnEntity( localClientNum, clientObjID, self, true, false, true );
		self thread destruction_watcher( localClientNum, clientObjID );


		objective_state( localClientNum, clientObjID, "active" );
		objective_SetIcon( localClientNum, clientObjID, "remotemissile_target" );
	}
}

function destruction_watcher( localClientNum, clientObjID )
{
	self endon( "hellfire_detonated" );
	self util::waittill_any ("death", "entityshutdown");

	wait( 0.4 );
	if( isdefined( clientObjID ) )
	{
		objective_delete( localClientNum, clientObjID );
		util::releaseObjID( localClientNum, clientObjID );
	}
}
