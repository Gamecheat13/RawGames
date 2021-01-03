    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\shared\system_shared;
	
#namespace zm_zod_sword;

#precache( "client_fx", "zombie/fx_egg_ready_zod_zmb" );
#precache( "client_fx", "zombie/fx_trail_blood_soul_zmb" );

function autoexec __init__sytem__() {     system::register("zm_zod_sword",&__init__,undefined,undefined);    }

function __init__()
{
	level._effect[ "egg_glow" ]	= "zombie/fx_egg_ready_zod_zmb";
	level._effect[ "blood_soul" ] = "zombie/fx_trail_blood_soul_zmb";
	clientfield::register( "scriptmover", "zod_egg_glow", 1, 1, "int", &sword_egg_glow, !true, !true );
	clientfield::register( "scriptmover", "zod_egg_soul", 1, 1, "int", &blood_soul_fx, !true, !true );
}

function play_fx( localClientNum, str_fx, str_tag )
{
	fx = undefined;
	if ( isdefined( str_tag ) )
	{
		fx = PlayFxOnTag( localClientNum, level._effect[ str_fx ], self, str_tag );
	}
	else
	{
		fx = PlayFX( localClientNum, level._effect[ str_fx ], self.origin );
	}
	
	self waittill( "remove_" + str_fx );
	StopFX( localClientNum, fx );
}

function sword_egg_glow( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		self thread play_fx( localClientNum, "egg_glow" );
	}
	else
	{
		self notify( "remove_egg_glow" );
	}
}

function blood_soul_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		self thread play_fx( localClientNum, "blood_soul", "tag_origin" );
	}
	else
	{
		self notify( "remove_blood_soul" );
	}
}