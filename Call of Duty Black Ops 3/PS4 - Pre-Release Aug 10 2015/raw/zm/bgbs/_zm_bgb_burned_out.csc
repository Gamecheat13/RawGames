#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

                  

                                                                 
                                                                                                                               

#precache( "client_fx", "zombie/fx_bgb_burned_out_1p_zmb" );
#precache( "client_fx", "zombie/fx_bgb_burned_out_3p_zmb" );
#precache( "client_fx", "zombie/fx_bgb_burned_out_fire_torso_zmb" );

#namespace zm_bgb_burned_out;


function autoexec __init__sytem__() {     system::register("zm_bgb_burned_out",&__init__,undefined,undefined);    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( "zm_bgb_burned_out", "event" );

	clientfield::register( "toplayer", (("zm_bgb_burned_out" + "_1p") + "toplayer"), 1, 1, "counter", &zm_bgb_burned_out_1p_toplayer_cb, !true, !true ); 
	clientfield::register( "allplayers", (("zm_bgb_burned_out" + "_3p") + "_allplayers"), 1, 1, "counter", &zm_bgb_burned_out_3p_allplayers_cb, !true, !true ); 
	clientfield::register( "actor", (("zm_bgb_burned_out" + "_fire_torso") + "_actor"), 1, 1, "counter", &zm_bgb_burned_out_fire_torso_actor_cb, !true, !true ); 
	clientfield::register( "vehicle", (("zm_bgb_burned_out" + "_fire_torso") + "_vehicle"), 1, 1, "counter", &zm_bgb_burned_out_fire_torso_vehicle_cb, !true, !true ); 

	level._effect[("zm_bgb_burned_out" + "_1p")] = "zombie/fx_bgb_burned_out_1p_zmb";
	level._effect[("zm_bgb_burned_out" + "_3p")] = "zombie/fx_bgb_burned_out_3p_zmb";
	level._effect[("zm_bgb_burned_out" + "_fire_torso")] = "zombie/fx_bgb_burned_out_fire_torso_zmb";
}


function zm_bgb_burned_out_1p_toplayer_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !IsThirdPerson( localClientNum ) )
	{
		PlayFxOnTag( localClientNum, level._effect[("zm_bgb_burned_out" + "_1p")], self, "tag_origin" );
	}
}


function zm_bgb_burned_out_3p_allplayers_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !self IsLocalPlayer() || self GetLocalClientNumber() != localClientNum || IsThirdPerson( localClientNum ) )
	{
		PlayFxOnTag( localClientNum, level._effect[("zm_bgb_burned_out" + "_3p")], self, "tag_origin" );
	}
}


function zm_bgb_burned_out_fire_torso_actor_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	fire_torso_tag = "j_spinelower";

	if ( IsDefined( self GetTagOrigin( fire_torso_tag ) ) )
	{
		fire_torso_tag = "tag_origin";
	}

	PlayFxOnTag( localClientNum, level._effect[("zm_bgb_burned_out" + "_fire_torso")], self, fire_torso_tag );
}


function zm_bgb_burned_out_fire_torso_vehicle_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	fire_torso_tag = "tag_body";

	if ( IsDefined( self GetTagOrigin( fire_torso_tag ) ) )
	{
		fire_torso_tag = "tag_origin";
	}

	PlayFxOnTag( localClientNum, level._effect[("zm_bgb_burned_out" + "_fire_torso")], self, fire_torso_tag );
}
