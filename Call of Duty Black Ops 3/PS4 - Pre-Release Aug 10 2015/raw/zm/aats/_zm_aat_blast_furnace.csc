#using scripts\shared\aat_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                 	       	

                                                                                                                               

#precache( "client_fx", "zombie/fx_bgb_burned_out_3p_zmb" );
#precache( "client_fx", "zombie/fx_bgb_burned_out_fire_torso_zmb" );

#namespace zm_aat_blast_furnace;

function autoexec __init__sytem__() {     system::register("zm_aat_blast_furnace",&__init__,undefined,undefined);    }

function __init__()
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}

	aat::register( "zm_aat_blast_furnace", "zmui_zm_aat_blast_furnace" );
	
	clientfield::register( "actor", "zm_aat_blast_furnace" + "_explosion", 1, 1, "int", &zm_aat_blast_furnace_explosion, !true, !true );
	clientfield::register( "actor", "zm_aat_blast_furnace" + "_burn", 1, 1, "int", &zm_aat_blast_furnace_burn, !true, !true );
	
	level._effect[ "zm_aat_blast_furnace" ] = "zombie/fx_bgb_burned_out_3p_zmb";
}


function zm_aat_blast_furnace_explosion( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self PlaySound( localClientNum, "evt_nuke_flash" );
	
	PlayFX( localClientNum, "zombie/fx_bgb_burned_out_3p_zmb", self.origin );
}

function zm_aat_blast_furnace_burn( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	self.fx_burn = PlayFxOnTag( localClientNum, "zombie/fx_bgb_burned_out_fire_torso_zmb", self, "tag_origin" );
	level thread zm_aat_blast_furnace_burn_end( localClientNum, self );
}

function zm_aat_blast_furnace_burn_end( localClientNum, e_zombie )
{
	fx_burn = e_zombie.fx_burn;
	e_zombie waittill( "entityshutdown" );
	
	StopFX( localClientNum, fx_burn );
}

