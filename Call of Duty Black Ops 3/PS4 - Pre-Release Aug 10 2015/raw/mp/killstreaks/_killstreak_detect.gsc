#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons\_proximity_grenade;
#using scripts\shared\util_shared;

#using scripts\mp\killstreaks\_killstreak_hacking;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace killstreak_detect;

function autoexec __init__sytem__() {     system::register("killstreak_detect",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "vehicle", "enemyvehicle", 1, 2, "int" );
	clientfield::register( "scriptmover", "enemyvehicle", 1, 2, "int" );
	clientfield::register( "helicopter", "enemyvehicle", 1, 2, "int" );
	clientfield::register( "missile", "enemyvehicle", 1, 2, "int" );
	clientfield::register( "actor", "enemyvehicle", 1, 2, "int" );
	clientfield::register( "vehicle", "vehicletransition", 1, 1, "int" );
}


function killstreakTargetSet( killstreakEntity, offset )
{
	if ( !isdefined( offset ) ) 
	{
		offset = ( 0, 0, 0 );
	}
	Target_Set( killstreakEntity, offset );
/#
	killstreakEntity thread killstreak_hacking::killstreak_switch_team( killstreakEntity.owner );
#/
}


function killstreakTargetClear( killstreakEntity )
{
	Target_Remove( killstreakEntity );
/#
	killstreakEntity thread killstreak_hacking::killstreak_switch_team_end();
#/
}
