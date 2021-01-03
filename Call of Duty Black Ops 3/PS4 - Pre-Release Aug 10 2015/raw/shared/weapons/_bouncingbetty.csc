#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "weapon/fx_betty_exp" );
#precache( "client_fx", "weapon/fx_betty_exp_death" );
#precache( "client_fx", "weapon/fx_betty_launch_dust" );

#using_animtree ( "bouncing_betty" );

#namespace bouncingbetty;

function init_shared( localClientNum )
{
	level._effect["fx_betty_friendly_light"] = "weapon/fx_betty_light_blue";
	level._effect["fx_betty_enemy_light"] = "weapon/fx_betty_light_orng";
	level._effect["fx_betty_exp"] = "weapon/fx_betty_exp";
	level._effect["fx_betty_exp_death"] = "weapon/fx_betty_exp_death";
	level._effect["fx_betty_launch_dust"] = "weapon/fx_betty_launch_dust";

	clientfield::register( "missile", "bouncingbetty_state", 1, 2, "int",&bouncingbetty_state_change, !true, !true );
	clientfield::register( "scriptmover", "bouncingbetty_state", 1, 2, "int",&bouncingbetty_state_change, !true, !true );
}

function bouncingbetty_state_change( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon("entityshutdown");

	self util::waittill_dobj( localClientNum );

	if ( !isdefined(self) )
		return;
		
	switch( newVal )
	{
		case 1:
		{
			self thread bouncingbetty_detonating( localClientNum );
			break;
		}
		case 2:
		{
			self thread bouncingbetty_deploying( localClientNum );
			break;
		}
	}
}


function bouncingbetty_deploying( localClientNum )
{
	self endon("entityshutdown");
	
	self UseAnimTree( #animtree );
	self SetAnim( %o_spider_mine_deploy, 1.0, 0.0, 1.0 );
}

function bouncingbetty_detonating( localClientNum )
{
	self endon("entityshutdown");
	
	up = anglesToUp(self.angles);
	forward = anglesToForward(self.angles);
	playfx( localClientNum, level._effect["fx_betty_launch_dust"], self.origin, up, forward );
	self playsound( localClientNum, "wpn_betty_jump" );
	
	self UseAnimTree( #animtree );
	self SetAnim( %o_spider_mine_detonate, 1.0, 0.0, 1.0 );
	self thread watchForExplosionNotetracks( localClientNum, up, forward );
}


function watchForExplosionNotetracks( localClientNum, up, forward )
{
	self endon("entityshutdown");
	
	while( 1 )
	{
		notetrack = self util::waittill_any_return( "explode_1st", "explode_2nd", "explode_main" );
		
		switch( noteTrack )
		{
			case "explode_1st":
				{
					playfx( localClientNum, level._effect["fx_betty_exp"], self.origin + ( up * 55 ), up, forward );
				}
				break;
			case "explode_2nd":
				{
					playfx( localClientNum, level._effect["fx_betty_exp"], self.origin + ( up * 95 ), up, forward );
				}
				break;
			case "explode_main":
				{
					playfx( localClientNum, level._effect["fx_betty_exp"], self.origin + ( up * 140 ), up, forward );
					playfx( localClientNum, level._effect["fx_betty_exp_death"], self.origin, up, forward );
				}
				break;
			default:
			break;
		}	
	}
}

