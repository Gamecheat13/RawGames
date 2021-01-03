    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               

#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
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
#using scripts\cp\cybercom\_cybercom_tactical_rig_proximitydeterrent;
#using scripts\cp\cybercom\_cybercom_util;

//Gadget List
#using scripts\cp\cybercom\_cybercom_gadget_firefly;	//gadget init
#using scripts\cp\cybercom\_cybercom_gadget_iff_override;	//gadget init
#using scripts\cp\cybercom\_cybercom_gadget_security_breach;	//gadget init
#using scripts\cp\cybercom\_cybercom_gadget_system_overload;
#using scripts\cp\cybercom\_cybercom_gadget_servo_shortout;
#using scripts\cp\cybercom\_cybercom_gadget_exosuitbreakdown;
#using scripts\cp\cybercom\_cybercom_gadget_surge;
#using scripts\cp\cybercom\_cybercom_gadget_sensory_overload;
#using scripts\cp\cybercom\_cybercom_gadget_forced_malfunction;
#using scripts\cp\cybercom\_cybercom_gadget_immolation;
#using scripts\cp\cybercom\_cybercom_gadget_concussive_wave;
#using scripts\cp\cybercom\_cybercom_gadget_smokescreen;
#using scripts\cp\cybercom\_cybercom_gadget_electrostatic_strike;
#using scripts\cp\cybercom\_cybercom_gadget_mrpukey;

#namespace cybercom;

#precache( "menu", "AbilityWheel" );
#precache( "lui_menu", "HackingHUD" );
#precache( "lui_menu_data", "HackingProgress" );
#precache( "lui_menu_data", "HackingVisibleFPP" );

function autoexec __init__sytem__() {     system::register("cybercom",&init,&main,undefined);    }

function init()
{
	clientfield::register( "world", "cybercom_disabled", 1, 1, "int" );
	clientfield::register( "toplayer", "cybercom_disabled", 1, 1, "int" );
	clientfield::register( "vehicle", "cybercom_setiffname", 1, 3, "int" );
	clientfield::register( "actor", "cybercom_setiffname", 1, 3, "int" );
	
	clientfield::register( "toplayer", "cyber_arm_pulse", 1, 2, "counter" );
	clientfield::register( "actor", "cyber_arm_pulse", 1, 2, "counter" );
	clientfield::register( "scriptmover", "cyber_arm_pulse", 1, 2, "counter" );
	clientfield::register( "scriptmover", "makedecoy", 1, 1, "int" );
	
	clientfield::register( "toplayer", "hacking_progress", 1, 12, "int" );

	// clientuimodels are registered client-side in raw/ui/uieditor/clientfieldmodels.lua
	clientfield::register( "clientuimodel", "playerAbilities.inRange", 1, 1, "int" );
	
	clientfield::register( "toplayer", "resetAbilityWheel", 1, 1, "int" );

	cybercom_gadget::init();
	cybercom_tacrig::init();
}

function ability_on( slot, weapon )
{
	self GadgetSetActivateTime( slot, GetTime() );
	
	// Notify AI of the activation unless the player has just spawned
	if ( !isDefined( self.spawntime ) || ( GetTime() - self.spawntime > 200 ) )
	{
		// When AI awareness system is enabled (stealth mode) dont announce any hijack/security_breach events
		// This avoids calling in AI to investigate the now invisible player only to be surrounded by AI that immediately spot them
		//  as soon as they finish with their remote hijack operation
		if ( GetDvarInt( "ai_awarenessEnabled" ) && isDefined( weapon ) && isSubStr( weapon.name, "hijack" ) )
			return;
		
		self GenerateScriptEvent();
	}
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
	level.vehicle_defense_cb = &vehicle_update_cybercom_defense;
	
	level.cybercom.overrideActorDamage	= &cybercom_ActorDamage;
	level.cybercom.overrideVehicleDamage= &cybercom_VehicleDamage;
}

function cybercom_ActorDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, modelIndex, surfaceType, surfaceNormal )
{
	if (isSubStr(sMeansOfDeath,"MELEE") )
	{
		self notify("notify_melee_damage");
		if ( weapon == GetWeapon("gadget_es_strike") || weapon == GetWeapon("gadget_es_strike_upgraded") )
		{
			iDamage = 0;
			if(!isDefined(sHitLoc) || sHitLoc == "none" )
			{
				return iDamage;
			}
			level notify ("es_strike",self,eAttacker,iDamage,weapon,vPoint);
			drainPower = true;
		}
		if ( weapon == GetWeapon("gadget_ravage_core") || weapon == GetWeapon("gadget_ravage_core_upgraded") && isDefined(self.archetype) && self.archetype == "robot" )
		{
			self ai::set_behavior_attribute( "can_gib", false ); // Disable normal damage gibbing.
		
			level notify ("ravage_core",self,eAttacker,iDamage,weapon,vPoint);
			drainPower = true;
		}
		if ( weapon == GetWeapon("gadget_rapid_strike") || weapon == GetWeapon("gadget_rapid_strike_upgraded") )
		{
			level notify ("rapid_strike",self,eAttacker,iDamage,weapon,vPoint);
			drainPower = true;
		}
		/*
		if(IS_TRUE(drainPower) && isDefined(eAttacker) && isPlayer(eAttacker) )
		{
			eAttacker GadgetPowerSet( GADGET_HELD_0, 0 ); //design requesting that use of any of these melee weapons drain all power.
			eAttacker GadgetPowerSet( GADGET_HELD_1, 0 );
			eAttacker GadgetPowerSet( GADGET_HELD_2, 0 );
			eAttacker GadgetPowerReset(GADGET_HELD_0);
			eAttacker GadgetPowerReset(GADGET_HELD_1);
			eAttacker GadgetPowerReset(GADGET_HELD_2);
		}
		*/
	}
	else
	if ( sMeansOfDeath == "MOD_GRENADE_SPLASH" )
	{
		if (weapon.name == "ravage_core_emp_grenade")
		{
			if ( isDefined(self.archetype) && (self.archetype == "human"  || self.archetype == "zombie") )
				iDamage = 60;
		}
	}
	
	
	if( ( isdefined( self.TokubetsuKogekita ) && self.TokubetsuKogekita ) && 
	    isDefined(eAttacker) && 
	    !isPlayer(eAttacker) )
	{
		iDamage = 1;
	}
	
	if(iDamage > 30 )
		self notify("damage_pain");
	
	return iDamage;
}



function cybercom_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	if (sMeansOfDeath == "MOD_MELEE") 
	{
		self notify("notify_melee_damage");
		if ( weapon == GetWeapon("gadget_es_strike") || weapon == GetWeapon("gadget_es_strike_upgraded") )
		{
			iDamage = 0;
			level notify ("es_strike",self,eAttacker,iDamage,weapon,vPoint);
			drainPower = true;
		}
		
		/*
		if(IS_TRUE(drainPower) && isDefined(eAttacker) && isPlayer(eAttacker) )
		{
			eAttacker GadgetPowerSet( GADGET_HELD_0, 0 ); //design requesting that use of any of these melee weapons drain all power.
			eAttacker GadgetPowerSet( GADGET_HELD_1, 0 );
			eAttacker GadgetPowerSet( GADGET_HELD_2, 0 );
			eAttacker GadgetPowerReset(GADGET_HELD_0);
			eAttacker GadgetPowerReset(GADGET_HELD_1);
			eAttacker GadgetPowerReset(GADGET_HELD_2);
		}
		*/
	}
	
	return iDamage;
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
	self.cybercom.lastlockedTargets = [];
	self setAbilitiesByFlags(self.pers["cybercom_flags"]);
	self flagsys::set( "cybercom_init" );
	self.cybercom.given_first_ability = false;
	self.cybercom.allowedstate = true;
	self.cybercom.power0 = self gadgetpowerget(0);
	self.cybercom.power1 = self gadgetpowerget(1);
	self.cybercom.power2 = self gadgetpowerget(2);
	//self cybercom::cybercomEquipDefault();
	//self thread cybercom::cybercomClassChangeWatcher();
	

//	self thread cybercom_dev::constantjuice();
	
	////////////////////////////////////////////////////////////
	//TEMP UI
	self.cybercom.hacking_menu = self OpenLUIMenu( "HackingHUD" );
	self SetLUIMenuData( self.cybercom.hacking_menu, "HackingVisibleFPP", 0.0 );
	self SetLUIMenuData( self.cybercom.hacking_menu, "HackingVisibleTPP", 0.0 );
	self SetLUIMenuData( self.cybercom.hacking_menu, "HackingProgress", 0 );
	////////////////////////////////////////////////////////////
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
        	if(	( isdefined( self.cybercom.is_primed ) && self.cybercom.is_primed ))
        		continue;
        	if(	( isdefined( self.cybercom.is_menu_blocked ) && self.cybercom.is_menu_blocked ))
        		continue;
        	
        	responseArray = strtok( response, "," );
        	
        	self.lastEquippedCybercomButton = Int( responseArray[1] );
        	ability = self cybercom_gadget::equipAbility(responseArray[0]);
 			
 			self clientfield::set_to_player( "resetAbilityWheel", 0 );
 			
 			self notify( "stop_shield" );
 			
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
function disableCybercom(restorePower)
{
	assert(isPlayer(self));
	self.cybercom.power0 = self gadgetpowerget(0);
	self.cybercom.power1 = self gadgetpowerget(1);
	self.cybercom.power2 = self gadgetpowerget(1);
	self.cybercom.restorePowerOnEnable = restorePower;
//	self setcybercomactivetype(0);
//	self setcybercomrigsflags(0);
	for( i = 0; i <= 2; i++ )
	{
//		self setcybercomabilityflags( 0, i );
//		self setcybercomupgradeflags( 0, i );
	}
	if( IsDefined( self.cybercom.activeCybercomWeapon ) )
    {
		self TakeWeapon( self.cybercom.activeCybercomWeapon );
		self notify("weapon_taken",self.cybercom.activeCybercomWeapon);
		self.cybercom.activeCybercomWeapon = undefined;
    }
	
	self clientfield::set_to_player( "cybercom_disabled", 1 );
	self.cybercom.allowedstate = false;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function enableCybercom()
{
	assert(isPlayer(self));
	self setCybercomFlags();
	self clientfield::set_to_player( "cybercom_disabled", 0 );
	if(isDefined(self.cybercom.lastEquipped))
	{
		self cybercom_gadget::equipAbility(self.cybercom.lastEquipped.name);
	}
	if(( isdefined( self.cybercom.restorePowerOnEnable ) && self.cybercom.restorePowerOnEnable ))
	{
		if(isDefined(self.cybercom.power0) ) self GadgetPowerSet( 0, self.cybercom.power0); 
		if(isDefined(self.cybercom.power1) ) self GadgetPowerSet( 1, self.cybercom.power1); 
		if(isDefined(self.cybercom.power2) ) self GadgetPowerSet( 2, self.cybercom.power2); 
		self.cybercom.power0 = undefined;
		self.cybercom.power1 = undefined;
		self.cybercom.power2 = undefined;
		self.cybercom.restorePowerOnEnable = undefined;
	}
	self.cybercom.allowedstate = true;
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
	level notify("_cybercom_notify_toggle_on");
	level endon("_cybercom_notify_toggle_on");
	
	while(1)
	{
		level waittill( "enable_cybercom" );
		level clientfield::set( "cybercom_disabled", 0 );
		SetDvar("cybercom_enabled",true);
		foreach(player in GetPlayers())
		{
			//player allowCybercom( true );
			player enableCybercom();
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function _cybercom_notify_toggle_off()
{
	level notify("_cybercom_notify_toggle_off");
	level endon("_cybercom_notify_toggle_off");
	
	while(1)
	{
		level waittill( "disable_cybercom", player, restorePower );
		if(isDefined(player))
		{
			player disableCybercom(restorePower);
		}
		else
		{
			level clientfield::set( "cybercom_disabled", 1 );
			SetDvar("cybercom_enabled",false);
			foreach(player in GetPlayers())
			{
				//player allowCybercom(false);
				player disableCybercom();
			}
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
	if ( player hascybercomrig("cybercom_proximitydeterrent") != 0 )
	{
		if( isDefined(eAttacker) &&  eAttacker.classname != "trigger_hurt" && eAttacker.classname != "worldspawn")
		{
			iDamage = player cybercom_tacrig_proximitydeterrent::GetAdjustedDamage(iDamage,sMeansOfDamage);
		}
	}

	
	return iDamage;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function cybercom_AIUsesCybercoreAbility( str_cybercore_ability, target, docast = true, upgraded = false )
{
	self endon( "death" );
	
	// Wait for the AI to finish playing any animations, because using a cybercore ability calls stopanimscripted()
	// GLocke 7/6/15 - do not hold for scripted animations if docast == false
	while ( docast && self IsPlayingAnimScripted() )
	{
		wait 0.1;
	}
	
	
	switch( str_cybercore_ability )
	{
		case "cybercom_iffoverride":
			cybercom_gadget_iff_override::ai_activateIFFOverride( target, docast );
			break;
		case "cybercom_systemoverload":
			cybercom_gadget_system_overload::ai_activateSystemOverload( target, docast );
			break;
		case "cybercom_servoshortout":
			cybercom_gadget_servo_shortout::ai_activateServoShortout( target, docast );
			break;
		case "cybercom_exosuitbreakdown":
			cybercom_gadget_exosuitbreakdown::ai_activateExoSuitBreakdown( target, docast );
			break;
		case "cybercom_surge":
			cybercom_gadget_surge::ai_activateSurge( target, docast,upgraded );
			break;
		case "cybercom_sensoryoverload":
			cybercom_gadget_sensory_overload::ai_activateSensoryOverload( target, docast );
			break;
		case "cybercom_forcedmalfunction":
			cybercom_gadget_forced_malfunction::ai_activateForcedMalfuncton( target, docast );
			break;
		case "cybercom_fireflyswarm":
			cybercom_gadget_firefly::ai_activateFireFlySwarm( target, docast, upgraded );
			break;	
		case "cybercom_immolation":
			cybercom_gadget_immolation::ai_activateImmolate( target, docast, upgraded );
			break;	
		case "cybercom_mrpukey":
			cybercom_gadget_mrpukey::ai_activateMrPukey( target, docast, upgraded );
			break;	
		case "cybercom_concussive":
			cybercom_gadget_concussive_wave::ai_activateConcussiveWave( target, docast );
			break;	
		case "cybercom_smokescreen":
			cybercom_gadget_smokescreen::ai_activateSmokescreen( docast, upgraded );
			break;	
		case "cybercom_es_strike":
			cybercom_gadget_electrostatic_strike::ai_activateElectroStaticStrike( upgraded );
			break;	
		default:
			assert(0,"AI cybercore not supported");
			break;
	}
	self playsound("gdt_cybercore_activate_ai");
}
