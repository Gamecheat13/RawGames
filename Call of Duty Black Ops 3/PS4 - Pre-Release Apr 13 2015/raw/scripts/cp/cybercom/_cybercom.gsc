    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                      	                       	     	                                                                     

#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_tactical_rig_emergencyreserve;
#using scripts\cp\cybercom\_cybercom_util;

//Gadget List
#using scripts\cp\cybercom\_cybercom_gadget_firefly;	//gadget init
#using scripts\cp\cybercom\_cybercom_gadget_iff_override;	//gadget init
#using scripts\cp\cybercom\_cybercom_gadget_security_breach;	//gadget init



#namespace cybercom;

#precache( "menu", "AbilityWheel" );

function autoexec __init__sytem__() {     system::register("cybercom",&init,&main,undefined);    }

function init()
{
	clientfield::register( "world", "cybercom_disabled", 1, 1, "int" );
	clientfield::register( "toplayer", "cybercom_disabled", 1, 1, "int" );
	clientfield::register( "vehicle", "cybercom_setiffname", 1, 3, "int" );
	
	clientfield::register( "toplayer", "cyber_arm_pulse", 1, 2, "counter" );
	clientfield::register( "actor", "cyber_arm_pulse", 1, 2, "counter" );
	clientfield::register( "scriptmover", "cyber_arm_pulse", 1, 2, "counter" );
	
	cybercom_gadget::init();
	cybercom_tacrig::init();
}

function ability_on( slot, weapon )
{
	self GadgetSetActivateTime( slot, GetTime() );
}


function ability_off( slot, weapon )
{
	// when any cybercom ability turns off
}

function initialize()
{
	level.cybercom	= spawnstruct();
	level.cybercom.abilities = [];
	level.cybercom.swarms_released = 0;
	level.cybercom._ability_turn_on = &ability_on;
	level.cybercom._ability_turn_off = &ability_off;
	//init cybercom for vehicles
	level.vehicle_initializer_cb = &vehicle_init_cybercom;
	//set the defence system updates for vehicles
	level.vehicle_defense_cb = &vehicle_update_cybercom_defence;
}

function main()
{
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );

	if(!isDefined(level.cybercom))
	{
		initialize();
	}

	cybercom_gadget::main();
	cybercom_tacrig::main();

	level thread wait_to_load();
	
	level thread _cybercom_notify_toggle();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function on_player_connect()
{	
	self.cybercom 		= spawnstruct();
	self.cybercom.flags 		= spawnstruct();
	self getCybercomFlags();
	self.pers["cybercom_flags"] = self.cybercom.flags;
	self thread on_menu_response();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function on_player_spawned()
{	
	self.cybercom.lock_targets	= [];
	self setAbilitiesByFlags(self.pers["cybercom_flags"]);
	self flagsys::set( "cybercom_init" );
	self.cybercom.given_first_ability = false;

	avail = cybercom_gadget::getAvailableAbilities();
	if(avail.size)
	{
		self setcybercomactivetype(avail[0].type);
		
		switch( avail[0].type )
		{
			case 0:
	 			self cybercom_gadget::equipAbility("cybercom_systemoverload");
				self cybercom_gadget::meleeAbilityGiven(cybercom_gadget::getAbilityByName("cybercom_ravagecore"));
				break;
			case 1:
				self cybercom_gadget::equipAbility("cybercom_overdrive");
				self cybercom_gadget::meleeAbilityGiven(cybercom_gadget::getAbilityByName("cybercom_rapidstrike"));
				break;
			case 2:
				self cybercom_gadget::equipAbility("cybercom_sensoryoverload");
				self cybercom_gadget::meleeAbilityGiven(cybercom_gadget::getAbilityByName("cybercom_es_strike"));
				break;
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function on_menu_response()
{
    self endon("disconnect");
    self notify("start_ccom_menu_response");
    self endon("start_ccom_menu_response");
    
    for(;;)
    {
        self waittill( "menuresponse", menu, response );
        
        if( isDefined(self.cybercom.menu) && menu == self.cybercom.menu )
        {
 			ability = self cybercom_gadget::equipAbility(response);
 			
 			
 			//based on the menu response, give the unselectable melee ability if available
 			if(isDefined(ability))
 			{
 				switch (ability.type)
 				{
 					case 0:
 						self cybercom_gadget::meleeAbilityGiven(cybercom_gadget::getAbilityByName("cybercom_ravagecore"));
						break;
 					case 1:
 						self cybercom_gadget::meleeAbilityGiven(cybercom_gadget::getAbilityByName("cybercom_rapidstrike"));
 						break;
 					case 2:
 						self cybercom_gadget::meleeAbilityGiven(cybercom_gadget::getAbilityByName("cybercom_es_strike"));
 						break;
 				}
 			}
		}
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function disableCybercom()
{
	assert(isPlayer(self));
	self setcybercomactivetype(0);
	self setcybercomrigsflags(0);
	for( i = 0; i <= 2; i++ )
	{
		self setcybercomabilityflags( 0, i );
		self setcybercomupgradeflags( 0, i );
	}
	self.cybercom.noFlagSet = true;
	self clientfield::set_to_player( "cybercom_disabled", 1 );
	allowCybercom(false);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function enableCybercom()
{
	assert(isPlayer(self));
	self setCybercomFlags();
	self.cybercom.noFlagSet = undefined;
	self clientfield::set_to_player( "cybercom_disabled", 0 );
	allowCybercom(true);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function allowCybercom(state)
{
	if( ( isdefined( state ) && state ) )
	{
		if(isDefined(self.cybercom.lastEquipped))
		{
			self cybercom_gadget::equipAbility(self.cybercom.lastEquipped.name);
		}
	}
	else
	{
		if( IsDefined( self.cybercom.activeCybercomWeapon ) )
	    {
			self TakeWeapon( self.cybercom.activeCybercomWeapon );
			self notify("weapon_taken",self.cybercom.activeCybercomWeapon);
			self.cybercom.activeCybercomWeapon = undefined;
	    }
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function _cybercom_notify_toggle()
{
	level thread _cybercom_notify_toggle_on();
	level thread _cybercom_notify_toggle_off();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function _cybercom_notify_toggle_on()
{
	while(1)
	{
		level waittill( "enable_cybercom" );
		level clientfield::set( "cybercom_disabled", 0 );
		SetDvar("cybercom_enabled",true);
		foreach(player in GetPlayers())
		{
			player allowCybercom( true );
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function _cybercom_notify_toggle_off()
{
	while(1)
	{
		level waittill( "disable_cybercom" );
		level clientfield::set( "cybercom_disabled", 1 );
		SetDvar("cybercom_enabled",false);
		foreach(player in GetPlayers())
		{
			player allowCybercom(false);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function cybercom_GetAdjustedDamage(player, eAttacker, eInflictor, iDamage, weapon, sHitLoc, sMeansOfDamage)
{
	//move to code?
	if ( iDamage >= player.health && player hascybercomrig("cybercom_emergencyreserve") != 0 )
	{
		if( isDefined(eAttacker) &&  eAttacker.classname != "trigger_hurt" && eAttacker.classname != "worldspawn" && player cybercom_tacrig_emergencyreserve::ValidDeathTypesForEmergencyReserve(sMeansOfDamage) )
		{
			iDamage = 1;
			player.health = (player.health<10?10:player.health);
			player cybercom_tacrig::turn_rig_ability_on("cybercom_emergencyreserve");
		}
	}
	
	return iDamage;
}
