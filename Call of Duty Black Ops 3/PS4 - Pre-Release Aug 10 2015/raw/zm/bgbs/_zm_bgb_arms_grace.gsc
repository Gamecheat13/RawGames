#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

  

                                                                 
                                                                                                                               

#namespace zm_bgb_arms_grace;


function autoexec __init__sytem__() {     system::register("zm_bgb_arms_grace",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( "zm_bgb_arms_grace", "event", &event, undefined, undefined, undefined );
}


function event()
{
	self endon( "disconnect" );
	self endon( "bgb_update" );
	
	// wait for the player to be about to lose the buff
	self waittill( "bgb_about_to_take_on_bled_out" );
	
	self bgb::do_one_shot_use();
	
	// thread so it doesn't get killed when the buff is taken
	level thread return_weapons_to_player( self );
}

function return_weapons_to_player( player )
{
	// save the weapons
	a_weapons = player GetWeaponsList();

	// wait for the player to respawn
	player waittill( "spawned_player" );

	// remove default weapon
	player waittill( "weapon_change_complete" );
	weapon = player getcurrentweapon();
	player TakeWeapon( weapon );
	
	// return the saved weapons
	foreach( weapon in a_weapons )
	{
		player zm_weapons::give_build_kit_weapon( weapon );
	}
}
