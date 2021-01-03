#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

                                                                                                                                                                                     	   	                                                                      	  	  	
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
#using scripts\shared\system_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\ai\systems\gib;

                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;






	

	
	
#precache( "fx", "weapon/fx_ability_concussive_wave_impact"	);
	
#namespace cybercom_gadget_concussive_wave;

function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(1, (1<<2), true);

	level.cybercom.concussive_wave = spawnstruct();
	level.cybercom.concussive_wave._is_flickering 	= &_is_flickering;
	level.cybercom.concussive_wave._on_flicker 		= &_on_flicker;
	level.cybercom.concussive_wave._on_give 		= &_on_give;
	level.cybercom.concussive_wave._on_take 		= &_on_take;
	level.cybercom.concussive_wave._on_connect 		= &_on_connect;
	level.cybercom.concussive_wave._on 				= &_on;
	level.cybercom.concussive_wave._off		 		= &_off;
	level.cybercom.concussive_wave._is_primed 		= &_is_primed;
}

function _is_flickering( slot )
{
	// returns true when the gadget is flickering
}

function _on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function _on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
	self.cybercom.concussive_wave_radius 		= GetDvarInt( "scr_concussive_wave_radius", 310 );
	self.cybercom.spikeWeapon	 = GetWeapon("hero_gravityspikes_cybercom");

	if(self hasCyberComAbility("cybercom_concussive")  == 2)
	{
		self.cybercom.concussive_wave_radius 		= GetDvarInt( "scr_concussive_wave_upg_radius", 310 );
		self.cybercom.spikeWeapon	 = GetWeapon("hero_gravityspikes_cybercom_upgraded");
	}
	
	// Enemies within this range will take damage from the blast.
	//self.cybercom.concussive_wave_dmg_radius 	= CONCUSSIVE_WAVE_DMG_RADIUS;
	
	// Damage taken just from being knocked down
	self.cybercom.concussive_wave_knockdown_damage	= 5*GetDvarFloat( "scr_concussive_wave_scale", 1 );
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
	self thread cybercom::weapon_AdvertiseAbility(weapon);
}



function _on_take( slot, weapon )
{
}
	
//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	// excecutes when the gadget is turned on
	if ( self getstance() == "prone")
	{
		self GadgetDeactivate( slot, weapon, 2 );
		return;		
	}
	if ( self IsSwitchingWeapons() )
	{
		self GadgetDeactivate( slot, weapon, 2 );
		return;		
	}
	if ( self isOnLadder() )
	{
		self GadgetDeactivate( slot, weapon, 2 );
		return;		
	}
/*	if ( self is_jumping() )
	{
		self GadgetDeactivate( slot, weapon, GADGET_OFF_PENALTY_TURN_OFF );
		return;		
	}
*/	
		
	
	cybercom::cybercomAbilityTurnedONNotify(weapon,true);
	self thread create_concussion_wave(self.cybercom.concussive_wave_damage,slot,weapon);
	level.gadgetOnTime = GetTime();
}

function _off( slot, weapon )
{
	level.gadgetOffTime = GetTime();
}

function _is_primed( slot, weapon )
{
	//self thread gadget_flashback_start( slot, weapon );
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );
function ai_activateConcussiveWave(damage,doCast=true)
{
	if(( isdefined( doCast ) && doCast ))
	{
		type =self cybercom::getAnimPrefixForPose();
		self OrientMode( "face default" );
		self AnimScripted( "ai_cybercom_anim", self.origin, self.angles, "ai_base_rifle_"+type+"_exposed_cybercom_activate" );		
		self waittillmatch( "ai_cybercom_anim", "fire" );
	}

	self create_concussion_wave(damage);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	humans 	= ArrayCombine(GetAISpeciesArray( "axis", "human" ),GetAISpeciesArray( "team3", "human" ),false,false);
	robots 	= ArrayCombine(GetAISpeciesArray( "axis", "robot" ),GetAISpeciesArray( "team3", "robot" ),false,false);
	zombies = ArrayCombine(GetAISpeciesArray( "axis", "zombie" ),GetAISpeciesArray( "team3", "zombie" ),false,false);
	return ArrayCombine(zombies,ArrayCombine(humans,robots,false,false),false,false);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_concussive"))
		return false;

	if ( ( isdefined( target.usingvehicle ) && target.usingvehicle ))
		return false;
		
	return true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function is_jumping()
{
	// checking PMF_JUMPING in code would give more accurate results
	ground_ent = self GetGroundEnt();
	return (!isdefined(ground_ent));
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
function create_damage_wave(damage,attacker)
{
	if(!isPlayer(attacker) )
	{
		playfx("weapon/fx_ability_concussive_wave_impact",attacker.origin);
	}
	
	
	assert(isDefined(attacker));
	enemies = _get_valid_targets();
	if(enemies.size == 0 )
		return;
	radius 			= (IsDefined(attacker.cybercom)?attacker.cybercom.concussive_wave_radius:GetDvarInt( "scr_concussive_wave_radius", 310 ));
	knockdownDmg	= (IsDefined(attacker.cybercom)?attacker.cybercom.concussive_wave_knockdown_damage:5);
	closeTargets = ArraySortClosest(enemies, attacker.origin,enemies.size, 0,radius);
	weapon = GetWeapon("gadget_concussive_wave");
	
	PhysicsExplosionSphere( attacker.origin, 512, 512, 1 );

	// Determine which enemies are close enough to knock down.
	// Also determine which enemies are close enough to do damage to.
	if (isDefineD(closeTargets) && closeTargets.size )
	{
		foreach (enemy in closeTargets)
		{
			if (!isDefined(enemy) || !isDefined(enemy.origin) )
			{
				continue;
			}
			
			// Ensure target validity.
			if ( !cybercom::targetIsValid(enemy) )
				continue;
			
			enemy notify("cybercom_action",weapon,attacker);
			attacker notify( "concussive_wave_enemy_hit" );
				// Is this enemy close enough to damage?
			if (enemy cybercom::isInstantKill() )
			{
				enemy Kill(enemy.origin, attacker);
				continue;
			}	
			// Knock over humans. Take the legs off robots.
			if(enemy.archetype=="human"|| enemy.archetype =="warlord" || enemy.archetype=="human_riotshield")
			{
				enemy DoDamage(knockdownDmg, attacker.origin, attacker,attacker, "none", "MOD_EXPLOSIVE", 0, weapon,-1, true);
				enemy playsound( "gdt_concussivewave_imp_human" );
				enemy notify( "bhtn_action_notify", "reactBodyBlow" );
				enemy thread sndDelayedNotify();
			}
			else
			if (enemy.archetype =="robot")
			{
				playfxontag(level._effect["servo_shortout"],enemy, "J_SpineLower");
				enemy ai::set_behavior_attribute( "force_crawler", "gib_legs" );
				enemy playsound( "gdt_concussivewave_imp_robot" );
			}
			else
			if(enemy.archetype == "zombie" )
			{
				enemy playsound( "gdt_concussivewave_imp_human" );
				enemy DoDamage(enemy.health + 1, enemy.origin, attacker,attacker, (RandomInt(100)>50?"right_leg_lower":"left_leg_lower"), "MOD_EXPLOSIVE", 0, GetWeapon( "frag_grenade" ),-1, true);				
				
				if( !IsAlive( enemy ) )
				{
					enemy StartRagdoll();
					launchDir = VectorNormalize( enemy.origin - attacker.origin );
					enemy LaunchRagdoll( ( launchDir[0] * 70, launchDir[1] * 70, 120 ) );
				}
			}
		}
	}	
}
function sndDelayedNotify()
{
	self endon( "death" );
	self endon( "sndEndConcussiveReact" );
	wait(1.75);
	
	self notify( "bhtn_action_notify", "concussiveReact" );
}
function create_concussion_wave(damage,slot,weapon)
{
	if(!isPlayer(self))
	{
		level thread create_damage_wave(damage,self);
		return;
	}
	self endon("disconnect");
	self.cybercom.is_menu_blocked = true;
	self clientfield::set_to_player( "cybercom_disabled", 1 );
	self.sprint_allowed = self AllowSprint( false );

	if(isDefined(self.cybercom) && isDefined(self.cybercom.spikeWeapon))
		spikeweapon = self.cybercom.spikeWeapon;
	else
		spikeweapon = GetWeapon("hero_gravityspikes_cybercom");
	assert(isDefined(spikeweapon));
	
	self.cybercom.block_juice = true;
	self GiveWeapon(spikeweapon);
	self SetWeaponAmmoClip( spikeweapon, 2 );
	
	if(self hasCyberComAbility("cybercom_concussive")  == 2)
	{
		failsafe = GetTime() + 800;
		while(self is_jumping()==false && self HasWeapon(spikeweapon) && GetTime()<failsafe )
			{wait(.05);};
		while(self is_jumping()==true && self HasWeapon(spikeweapon) && GetTime()<failsafe )
			{wait(.05);};
	}
	else
	{
		wait .6;
	}
	self playrumbleonentity( "grenade_rumble" );
	earthquake( 0.6, .5, self.origin, 256 );
	
	if(isDefined(spikeweapon) && self HasWeapon(spikeweapon))
		self TakeWeapon(spikeweapon);
	
	self.cybercom.block_juice = undefined;
	level thread create_damage_wave(damage,self);
	wait GetDvarInt( "scr_concussive_wave_no_sprint", 1 );
	self AllowSprint( self.sprint_allowed  );
	self.sprint_allowed  = undefined;
	self.cybercom.is_menu_blocked = undefined;
	self clientfield::set_to_player( "cybercom_disabled", 0 );
	wait .1;
}	
