#using scripts\shared\killstreaks_shared;
#using scripts\shared\util_shared;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                    	   	  	

#namespace ability_util;


	
function gadget_is_type( slot, type )
{
	if ( !IsDefined( self._gadgets_player[slot] ) )
	{
		return false;
	}

	return self._gadgets_player[slot].gadget_type == type;
}

function gadget_is_using_type( type )
{
	slot = -1;

	for ( i = 0; i < 3; i++ )
	{
		if ( !self gadget_is_type( i, type ) )
		{
			continue;
		}

		if ( self ability_player::gadget_is_in_use( i ) )
		{
			slot = i;
			break;
		}
	}

	return slot;
}

function gadget_is_camo_suit_on()
{
	return self gadget_is_using_type( 2 );
}

function gadget_combat_efficiency_enabled()
{
	if ( isdefined( self._gadget_combat_efficiency ) )
	{
		return self._gadget_combat_efficiency;
	}

	return false;
}

function gadget_combat_efficiency_power_drain( score )
{
	powerChange = -1 * score * GetDvarFloat( "scr_combat_efficiency_power_loss_scalar", .1 );
	slot = gadget_is_using_type( 15 );
	if( slot != -1 )
	{
		self GadgetPowerChange( slot, powerChange );
	}
}

function gadget_is_camo_suit_flickering()
{
	slot = self gadget_is_camo_suit_on();

	if ( slot >= 0 && slot < 3 )
	{
		if ( self ability_player::gadget_is_flickering( slot ) )
		{
			return true;
		}
	}

	return false;
}

function gadget_is_escort_drone_on()
{
	return self gadget_is_using_type( 5 );
}

function is_weapon_gadget( weapon )
{
	foreach( gadget_key, gadget_val in level._gadgets_level )
	{
		if ( gadget_key == weapon )
			return true;
	}

	return false;
}

function gadget_power_reset( gadgetWeapon )
{			
	slot = self GadgetGetSlot( gadgetWeapon );

	if ( slot >= 0 && slot < 3 )
	{
		self GadgetPowerReset( slot );
		self GadgetCharging( slot, true );
	}
}

function gadget_reset( gadgetWeapon, changedClass, roundBased, firstRound )
{
	if ( GetDvarint( "gadgetEnabled") == 0 )
	{
		return;
	}
	
	slot = self GadgetGetSlot( gadgetWeapon );
	
	if ( slot >= 0 && slot < 3 )
	{
		if ( isdefined( self.pers["held_gadgets_power"] ) && isdefined( self.pers["held_gadgets_power"][gadgetWeapon] ) )
		{
			self GadgetPowerSet( slot, self.pers["held_gadgets_power"][gadgetWeapon] );
		}
	
		resetOnClassChange = changedClass && gadgetWeapon.gadget_power_reset_on_class_change;
		resetOnFirstRound = !isdefined( self.firstSpawn ) && ( !roundBased || firstRound );
		resetOnRoundSwitch = !isdefined( self.firstSpawn ) && roundBased && !firstRound && gadgetWeapon.gadget_power_reset_on_round_switch;
		resetOnTeamChanged = isdefined( self.firstSpawn ) && ( isdefined( self.switchedTeamsResetGadgets ) && self.switchedTeamsResetGadgets ) && gadgetWeapon.gadget_power_reset_on_team_change;
		
		if (  resetOnClassChange || resetOnFirstRound || resetOnRoundSwitch || resetOnTeamChanged )
		{
			self GadgetPowerReset( slot );
			self GadgetCharging( slot, true );
		}
	}	
}

function gadget_power_armor_on()
{
	slot = self gadget_is_using_type( 4 );

	if ( slot >= 0 && slot < 3 )
	{
		if ( self ability_player::gadget_is_in_use( slot ) )
		{
			return true;
		}
	}

	return false;
}


function gadget_is_active( gadgetType )
{
	slot = self gadget_is_using_type( gadgetType );

	if ( slot >= 0 && slot < 3 )
	{
		if ( self ability_player::gadget_is_in_use( slot ) )
		{
			return true;
		}
	}

	return false;
}

