#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       


#precache( "client_fx", "weapon/fx_trophy_light_enemy" );

#using_animtree ( "mp_trophy_system" );

#namespace trophy_system;

function init_shared( localClientNum )
{
	clientfield::register( "missile", "trophy_system_state", 1, 2, "int",&trophy_state_change, !true, true );
	clientfield::register( "scriptmover", "trophy_system_state", 1, 2, "int",&trophy_state_change_recon, !true, !true );
}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function trophy_state_change( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon("entityshutdown");

	self util::waittill_dobj( localClientNum );

	if ( !isdefined(self) )
		return;
		
	switch( newVal )
	{
		case 1:
		{
			self thread trophy_rolling_anim( localClientNum );
			break;
		}
		case 2:
		{
			self thread trophy_stationary_anim( localClientNum );
			break;
		}
		case 3:
		{
			break;
		}
		case 0:
		{
			break;
		}
	}
}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function trophy_state_change_recon( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon("entityshutdown");

	self util::waittill_dobj( localClientNum );

	if ( !isdefined(self) )
		return;
		
	switch( newVal )
	{
		case 1:
		{
			self thread trophy_rolling_anim( localClientNum );
			break;
		}
		case 2:
		{
			self thread trophy_stationary_anim( localClientNum );
			break;
		}
		case 3:
		{
			break;
		}
		case 0:
		{
			break;
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function trophy_rolling_anim( localClientNum )
{
	self endon("entityshutdown");

	self UseAnimTree( #animtree );
	self SetAnim( %o_trophy_deploy, 1.0 );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function trophy_stationary_anim( localClientNum )
{
	self endon("entityshutdown");

	self UseAnimTree( #animtree );
	self SetAnim( %o_trophy_deploy, 0.0 );
	self SetAnim( %o_trophy_spin, 1.0 );
}
