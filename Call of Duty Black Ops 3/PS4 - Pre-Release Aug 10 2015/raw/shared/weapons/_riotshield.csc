#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "_t6/weapon/riotshield/fx_riotshield_depoly_lights" );
#precache( "client_fx", "_t6/weapon/riotshield/fx_riotshield_depoly_dust" );

#using_animtree ( "mp_riotshield" );

#namespace riotshield;

function init_shared()
{
	clientfield::register( "scriptmover", "riotshield_state", 1, 2, "int",&shield_state_change, !true, !true );

	level._effect["riotshield_light"] = "_t6/weapon/riotshield/fx_riotshield_depoly_lights";
	level._effect["riotshield_dust"] = "_t6/weapon/riotshield/fx_riotshield_depoly_dust";
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function shield_state_change( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon("entityshutdown");

	switch( newVal )
	{
		case 1:
		{
			instant = ( oldVal == 2 );
			self thread riotshield_deploy_anim( localClientNum, instant );
			break;
		}
		case 2:
		{
			self thread riotshield_destroy_anim( localClientNum );
			break;
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function riotshield_deploy_anim( localClientNum, instant )
{
	self endon("entityshutdown");

	self thread watch_riotshield_damage();

	self util::waittill_dobj( localClientNum );

	self UseAnimTree( #animtree );

	if ( instant )
	{
		self SetAnimTime( %o_riot_stand_deploy, 1.0 );
	}
	else
	{
		self SetAnim( %o_riot_stand_deploy, 1.0, 0.0, 1.0 );
		PlayFXOnTag( localClientNum, level._effect["riotshield_dust"], self, "tag_origin" );
	}	
	
	if ( !instant )
	{
		wait( 0.8 );
	}

	self.shieldLightFx = PlayFXOnTag( localClientNum, level._effect["riotshield_light"], self, "tag_fx" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watch_riotshield_damage()
{
	self endon("entityshutdown");

	while (1)
	{
		self waittill( "damage", damage_loc, damage_type );

		self UseAnimTree( #animtree );

		//println("CLIENT: Riotshield hit - " + damage_type + " " + damage_loc );

		if ( damage_type == "MOD_MELEE" || damage_type == "MOD_MELEE_WEAPON_BUTT" || damage_type == "MOD_MELEE_ASSASSINATE" )
		{
			self SetAnim( %o_riot_stand_melee_front, 1.0, 0.0, 1.0 );
		}
		else
		{
			self SetAnim( %o_riot_stand_shot, 1.0, 0.0, 1.0 );
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function riotshield_destroy_anim( localClientNum )
{
	self endon("entityshutdown");

	if ( isdefined( self.shieldLightFx ))
	{
		stopfx( localClientNum, self.shieldLightFx );
	}

	// tagTMR<NOTE>: Don't update the anim the same frame as the model swap
	wait (0.05);

	self PlaySound( localClientNum, "wpn_shield_destroy" );

	self UseAnimTree( #animtree );
	self SetAnim( %o_riot_stand_destroyed, 1.0, 0.0, 1.0 );

	wait( 1.0 );
	self SetForceNotSimple();
}