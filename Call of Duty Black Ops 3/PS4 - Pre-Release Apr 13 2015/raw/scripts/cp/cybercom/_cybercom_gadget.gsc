    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                      	                       	     	                                                                     

#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom_util;

//Gadget List
#using scripts\cp\cybercom\_cybercom_gadget_iff_override;	
#using scripts\cp\cybercom\_cybercom_gadget_security_breach;	
#using scripts\cp\cybercom\_cybercom_gadget_system_overload;	
#using scripts\cp\cybercom\_cybercom_gadget_servo_shortout;	
#using scripts\cp\cybercom\_cybercom_gadget_exosuitbreakdown;	
#using scripts\cp\cybercom\_cybercom_gadget_surge;	

#using scripts\cp\cybercom\_cybercom_gadget_unstoppable_force;

#using scripts\cp\cybercom\_cybercom_gadget_sensory_overload;	
#using scripts\cp\cybercom\_cybercom_gadget_forced_malfunction;	
#using scripts\cp\cybercom\_cybercom_gadget_firefly;	
#using scripts\cp\cybercom\_cybercom_gadget_immolation;	
#using scripts\cp\cybercom\_cybercom_gadget_concussive_wave;
#using scripts\cp\cybercom\_cybercom_gadget_smokescreen;
#using scripts\cp\cybercom\_cybercom_gadget_misdirection;
#using scripts\cp\cybercom\_cybercom_gadget_electrostatic_strike;
#using scripts\cp\cybercom\_cybercom_gadget_active_camo;


#namespace cybercom_gadget;


function init()
{
	//Control Branch
	cybercom_gadget_iff_override::init();
	cybercom_gadget_security_breach::init();
	cybercom_gadget_system_overload::init();
	cybercom_gadget_servo_shortout::init();
	cybercom_gadget_exosuitbreakdown::init();
	cybercom_gadget_surge::init();
	
	//Martial Branch
	cybercom_gadget_unstoppable_force::init();
	cybercom_gadget_concussive_wave::init();
	cybercom_gadget_active_camo::init();
	
	//Chaos Branch
	cybercom_gadget_immolation::init();
	cybercom_gadget_sensory_overload::init();
	cybercom_gadget_forced_malfunction::init();
	cybercom_gadget_firefly::init();
	cybercom_gadget_smokescreen::init();
	cybercom_gadget_misdirection::init();
	cybercom_gadget_electrostatic_strike::init();
}

function main()
{
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );

		//Control Branch
	cybercom_gadget_iff_override::main();
	cybercom_gadget_security_breach::main();
	cybercom_gadget_system_overload::main();
	cybercom_gadget_servo_shortout::main();
	cybercom_gadget_exosuitbreakdown::main();
	cybercom_gadget_surge::main();
	cybercom_gadget::registerAbility(0,		(1<<4));
	
	//Martial Branch
	cybercom_gadget_unstoppable_force::main();
	cybercom_gadget_concussive_wave::main();
	cybercom_gadget_forced_malfunction::main();
	cybercom_gadget_active_camo::main();
	cybercom_gadget::registerAbility(1,		(1<<0));
	cybercom_gadget::registerAbility(1,		(1<<4));
	cybercom_gadget::registerAbility(1, 	(1<<6));
	
	//Chaos Branch
	cybercom_gadget_immolation::main();
	cybercom_gadget_sensory_overload::main();
	cybercom_gadget_firefly::main();
	cybercom_gadget_smokescreen::main();
	cybercom_gadget_misdirection::main();
	cybercom_gadget_electrostatic_strike::main();
	cybercom_gadget::registerAbility(2, 		(1<<6)); //cut?
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function on_player_connect()
{	
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function on_player_spawned()
{	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function registerAbility(type,flag)
{
	if(!isDefined(level.cybercom))
	{
		cybercom::initialize();
	}

	if ( getAbilityByFlag(type, flag) == undefined )
	{
		ability =	spawnstruct();
		ability.type = type;
		ability.flag = flag;
		
		ability.name = GetCybercomAbilityName( type, flag );
		ability.weapon = GetCybercomWeapon( type, flag, false );
		ability.weaponUpgraded = GetCybercomWeapon( type, flag, true );

		level.cybercom.abilities[level.cybercom.abilities.size] = ability;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function isMeleeAbility( ability )
{
	if( IsDefined( ability ) )
	{
		if( ability.type == 1 && (ability.flag == (1<<0) || ability.flag == (1<<6)) )
		{
			return true;
		}
		if( ability.type == 2 && ability.flag == (1<<1) )
		{
			return true;
		}
		if( ability.type == 0 && ability.flag == (1<<4) )
		{
			return true;
		}
	}
	return false;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function meleeAbilityGiven(ability,upgrade)//this is called either via giveAbility through level script or on player spawn via the setAbilitiesByFlags
{
	if (!isDefined(ability))
		return;
	
	//melee weapons are NOT selected via the DPAD down wheel, so given not when selected by menu but when bit is set.
	if(!isMeleeAbility( ability ))  
		return;
	
	if(!isDefined(upgrade))
	{
		status = self HasCyberComAbility(ability.name);
		if(status == 0 )
			return;
		upgrade = (status==2);
	}
	
	//when gadget is actually given via the dial menu(dpad down), the gadget specific possession callbacks will be called.

	//this is an opportunity for script to do something specific when the cybercom BIT is set
	//:

	//melee weapons are NOT selected via the DPAD down wheel, so given not when selected by menu but when bit is set.
	if( upgrade)
	{
		weapon = ability.weaponUpgraded;
	}
	else
	{
		weapon = ability.weapon;
	}

	if( IsDefined( self.cybercom.activeCybercomMeleeWeapon ) && self.cybercom.activeCybercomMeleeWeapon != weapon )
    {
    	//if there was already an activeCybercomMeleeWeapon, what to do? you can only have one melee weapon, but design expects contextual prompts for all abilities

		self TakeWeapon( self.cybercom.activeCybercomMeleeWeapon );
		self notify("weapon_taken",self.cybercom.activeCybercomMeleeWeapon);
		self.cybercom.activeCybercomMeleeWeapon = undefined;
    }
    
	if(!self HasWeapon(weapon))
	{
  		self GiveWeapon( weapon );	
		self notify("weapon_given",weapon);
	}
	self.cybercom.activeCybercomMeleeWeapon = weapon;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function abilityTaken(ability) 
{
	//when gadget is actually taken via the dial menu(dpad down), the gadget specific possession callbacks will be called.

	//this is an opportunity for script to do something specific when the cybercom BIT is UNset
	//:
	
	//this is an opportunity for script to do something specific when the cybercom BIT is set
	//:
	if (!isDefined(ability))
		return;

	if ( self HasWeapon(ability.weapon) )
	{
		self TakeWeapon( ability.weapon );
		self notify("weapon_taken",ability.weapon);
	}
	if( IsDefined( self.cybercom.activeCybercomMeleeWeapon ) && self.cybercom.activeCybercomMeleeWeapon == ability.weapon )
		self.cybercom.activeCybercomMeleeWeapon = undefined;
	
	if( IsDefined( self.cybercom.activeCybercomWeapon ) && self.cybercom.activeCybercomWeapon == ability.weapon )
		self.cybercom.activeCybercomWeapon = undefined;
	
	if ( self HasWeapon(ability.weaponUpgraded) )
	{
		self TakeWeapon( ability.weaponUpgraded );
		self notify("weapon_taken",ability.weaponUpgraded);
	}
	
	if( IsDefined( self.cybercom.activeCybercomMeleeWeapon ) && self.cybercom.activeCybercomMeleeWeapon == ability.weaponUpgraded )
		self.cybercom.activeCybercomMeleeWeapon = undefined;
	
	if( IsDefined( self.cybercom.activeCybercomWeapon ) && self.cybercom.activeCybercomWeapon == ability.weaponUpgraded )
		self.cybercom.activeCybercomWeapon = undefined;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function giveAbility(name,upgrade)  
{
	ability = getAbilityByName(name);
	if(!isDefined(ability))
		return;

	self SetCyberComAbility(name, upgrade );
	self cybercom::updateCybercomFlags();
	self meleeAbilityGiven(ability,upgrade);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function equipAbility(name,selectable=true)
{
	abilityStatus = self hasCyberComAbility(name);
	if ( abilityStatus == 0 )
		return;

	ability = cybercom_gadget::getAbilityByName(name);
	if (!isDefined(ability))
		return;

	if(selectable)
	{
		self.cybercom.flags.type = ability.type;
		self setcybercomactivetype( ability.type );
		self.cybercom.lastEquipped= ability;
	}
		
	if( abilityStatus == 2 )
	{
		weapon = ability.weaponUpgraded;
	}
	else
	{
		weapon = ability.weapon;
	}

	if(!cybercom_gadget::isMeleeAbility( ability )) //player already given weapon when bit is set and not when selected by the menu
	{
		if( IsDefined( self.cybercom.activeCybercomWeapon ) && weapon != self.cybercom.activeCybercomWeapon )
	    {
			self TakeWeapon( self.cybercom.activeCybercomWeapon );
			self notify("weapon_taken",self.cybercom.activeCybercomWeapon);
	    }
		//giving the gadget weapon to player will make callbacks into the gadget specific script logic.  These are registered elsewhere via ability_player::register_gadget_possession_callbacks
  		if(!self HasWeapon(weapon))
  		{
	  		self GiveWeapon( weapon );	
			self notify("weapon_given",weapon);
		}
  		
		self.cybercom.activeCybercomWeapon = weapon;
		
		if( !( isdefined( self.cybercom.given_first_ability ) && self.cybercom.given_first_ability ))
		{
  			{wait(.05);};
  			self GadgetPowerSet( 0, 100 ); // Melee weapon takes up one gadget slot and the ability the other, be safe and set both of their power usage up
  			self GadgetPowerSet( 1, 100 );
  			self.cybercom.given_first_ability = true;
		}
	}
	return ability;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function takeAllAbilities()
{
	abilities = self getAvailableAbilities();
	foreach(ability in abilities )
	{
		self ClearCyberComAbility(ability.name);
		self abilityTaken(ability);
	}

	//abilityTaken should have cleared this out
	assert(!isDefined(self.cybercom.activeCybercomWeapon));
	assert(!isDefined(self.cybercom.activeCybercomMeleeWeapon));

	self cybercom::updateCybercomFlags();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function getAbilityByName(name)
{
	foreach(ability in level.cybercom.abilities)
	{
		if ( ability.name == name )
			return ability;
	}
	return undefined;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function getAbilityByWeaponName(name)
{
	weapon = GetWeapon(name);
	foreach(ability in level.cybercom.abilities)
	{
		if ( isDefined(ability.weapon) && weapon.name == ability.weapon.name )
			return ability;
	}
	return undefined;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function getAbilityByFlag(type,flag)
{
	foreach(ability in level.cybercom.abilities)
	{
		if ( ability.type == type && ability.flag==flag )
			return ability;
	}
	return undefined;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function getAvailableAbilities()
{
	abilities = [];
	
	if(!isDefined(self.cybercom) || !isDefined(self.cybercom.flags) || !isDefined(self.cybercom.flags.type))
		return abilities;
		
	foreach(ability in level.cybercom.abilities)
	{
		ccomAbilityStatus = self hasCyberComAbility(ability.name);
		if ( ccomAbilityStatus != 0 )
		{
			abilities[abilities.size] = ability;
		}
	}
	
	return abilities;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function getAbilitiesForType(type)
{
	abilities = [];
		
	foreach(ability in level.cybercom.abilities)
	{
		if ( ability.type == type )
		{
			abilities[abilities.size] = ability;
		}
	}
	
	return abilities;
}