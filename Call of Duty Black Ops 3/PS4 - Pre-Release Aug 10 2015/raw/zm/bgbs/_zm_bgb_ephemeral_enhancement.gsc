#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

       

                                                                 
                                                                                                                               

#namespace zm_bgb_ephemeral_enhancement;


function autoexec __init__sytem__() {     system::register("zm_bgb_ephemeral_enhancement",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( "zm_bgb_ephemeral_enhancement", "activated", 2, undefined, undefined, &validation, &activation );
}



function validation()
{
	// only allow one activation at a time, to avoid ui timer confusion
	if( ( isdefined( self bgb::get_active() ) && self bgb::get_active() ) )
	{
		return false;
	}
	
	// only allow activation if the current weapon can be upgraded
	weap = self getcurrentweapon();
	return zm_weapons::can_upgrade_weapon( weap );
}

function activation()
{
	self bgb::do_one_shot_use();

	// let the player finish blowing the bubble (return to previous weapon)
	self waittill( "weapon_change_complete" );

	// upgrade weapon
	if ( !self laststand::player_is_in_laststand() )
	{
		weap = self getcurrentweapon();
		weapon = zm_weapons::get_upgrade_weapon( weap );

		if ( ( isdefined( level.aat_in_use ) && level.aat_in_use ) )
		{
			self thread aat::acquire( weapon );
		}

		self TakeWeapon( weap );
		self zm_weapons::give_build_kit_weapon( weapon );
		self GiveStartAmmo( weapon );
		self SwitchToWeapon( weapon );
	}

	// downgrade after timer expires
	self downgrade_weapon_after_delay( weapon ); // need to wait, otherwise we get conflicting notifies with bgb timers (also only have one ui element for conveying timer)
}

// self = player
function downgrade_weapon_after_delay( upgraded_weapon )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "bled_out"); // if player bleeds out, they're losing the weapon anyway, so kill the thread
	self endon( "replaced_upgraded_weapon" ); // if player replaces the buffed weapon, kill the thread
	
	self thread kill_timer_on_bled_out();
	self thread watch_for_upgraded_weapon_lost( upgraded_weapon );
	self bgb::run_timer( 30 ); // block, show timer
	
	// downgrade weapon when player is up
	if( self laststand::player_is_in_laststand() )
	{
		self waittill( "player_revived");
	}

	// if the player doesn't have the upgraded weapon anymore, don't give back the un-upgraded version
	if( self zm_weapons::has_weapon_or_attachments( upgraded_weapon ) === false )
	{
		return;
	}
	
	current_weapon = self getcurrentweapon();
	base_weapon = zm_weapons::get_base_weapon( upgraded_weapon );

	self zm_weapons::give_build_kit_weapon( base_weapon );
	self TakeWeapon( upgraded_weapon );

	// if we're currently equipping the previously upgraded weapon, switch us back (otherwise, just change the weapon in inventory back)
	if( current_weapon === upgraded_weapon )
	{
		self SwitchToWeapon( base_weapon );
	}
}

// each time the player changes weapons, make sure we still have the buffed one (should cover all current and future cases where a weapon is replaced)
function watch_for_upgraded_weapon_lost( upgraded_weapon )
{
	while( true )
	{
		self waittill( "weapon_change_complete" );
		
		if( self zm_weapons::has_weapon_or_attachments( upgraded_weapon ) === false )
		{
			self notify( "replaced_upgraded_weapon" );
			return;
		}
	}
}

// kill timer if player dies
function kill_timer_on_bled_out()
{
	self endon( "bgb_update" );
	
	self waittill( "bled_out" );
	
	self bgb::take();
}
