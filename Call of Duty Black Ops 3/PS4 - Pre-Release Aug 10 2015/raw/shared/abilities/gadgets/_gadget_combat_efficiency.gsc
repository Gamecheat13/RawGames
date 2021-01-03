#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\spawner_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	

#using scripts\shared\system_shared;

function autoexec __init__sytem__() {     system::register("gadget_combat_efficiency",&__init__,undefined,undefined);    }

function __init__()
{
	ability_player::register_gadget_activation_callbacks( 15, &gadget_combat_efficiency_on_activate, &gadget_combat_efficiency_on_off );
	ability_player::register_gadget_possession_callbacks( 15, &gadget_combat_efficiency_on_give, &gadget_combat_efficiency_on_take );
	ability_player::register_gadget_flicker_callbacks( 15, &gadget_combat_efficiency_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 15, &gadget_combat_efficiency_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 15, &gadget_combat_efficiency_is_flickering );
	ability_player::register_gadget_ready_callbacks( 15, &gadget_combat_efficiency_ready );

	//callback::on_connect( &gadget_combat_efficiency_on_connect );
	//callback::on_spawned( &gadget_combat_efficiency_on_spawn );
}

function gadget_combat_efficiency_is_inuse( slot )
{
	// returns true when the gadget is on
	return self GadgetIsActive( slot );
}

function gadget_combat_efficiency_is_flickering( slot )
{
	// returns true when the gadget is flickering
	return self GadgetFlickering( slot );
}

function gadget_combat_efficiency_on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function gadget_combat_efficiency_on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
}

function gadget_combat_efficiency_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
}

//self is the player
function gadget_combat_efficiency_on_connect()
{	
	// setup up stuff on player connect	
}

//self is the player
function gadget_combat_efficiency_on_spawn()
{	
	// setup up stuff on player spawn	
	self.combatEfficiencyLastOnTime = 0;
}

function gadget_combat_efficiency_on_activate( slot, weapon )
{
	self._gadget_combat_efficiency = true;
	self._gadget_combat_efficiency_success = false;
	self.scoreStreaksEarnedPerUse = 0;
	self.combatEfficiencyLastOnTime = getTime();
}

function gadget_combat_efficiency_on_off( slot, weapon )
{
	self._gadget_combat_efficiency = false;
	self.combatEfficiencyLastOnTime = getTime();
	
	self addWeaponStat( self.heroAbility, "scorestreaks_earned_2", int( self.scoreStreaksEarnedPerUse / 2 ) );
	self addWeaponStat( self.heroAbility, "scorestreaks_earned_3", int( self.scoreStreaksEarnedPerUse / 3 ) );

	if ( IsAlive( self ) && isdefined( level.playHeroabilitySuccess ) )
    {
		self [[ level.playHeroabilitySuccess ]]();
    }
}

function gadget_combat_efficiency_ready( slot, weapon )
{
	// unused
}

function set_gadget_combat_efficiency_status( weapon, status, time )
{
	timeStr = "";

	if ( IsDefined( time ) )
	{
		timeStr = "^3" + ", time: " + time;
	}
	
	if ( GetDvarInt( "scr_cpower_debug_prints" ) > 0 )
		self IPrintlnBold( "Gadget Combat Efficiency " + weapon.name + ": " + status + timeStr );
}