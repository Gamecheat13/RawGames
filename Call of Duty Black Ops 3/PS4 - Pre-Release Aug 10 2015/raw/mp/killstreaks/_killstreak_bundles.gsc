#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\mp\_util;
#using scripts\mp\killstreaks\_killstreaks;

  
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace killstreak_bundles;

function register_killstreak_bundle( killstreakType )
{
	level.killstreakBundle[killstreakType] = struct::get_script_bundle( "killstreak",  "killstreak_" + killstreakType );
	level.killstreakBundle["inventory_" + killstreakType] = level.killstreakBundle[killstreakType];
	assert( isdefined( level.killstreakBundle[killstreakType] ) );
}

function get_hack_timeout()
{
	killstreak = self;
	bundle = level.killstreakBundle[killstreak.killstreakType];
	
	return bundle.ksHackTimeout;
}

function get_hack_protection()
{
	killstreak = self;
	hackedProtection = false;

	bundle = level.killstreakBundle[killstreak.killstreakType];
	if ( isdefined( bundle.ksHackProtection ) )
	{
		hackedProtection = bundle.ksHackProtection;
	}
	
	return hackedProtection;
}

function get_hack_tool_inner_time()
{
	killstreak = self;
	hackToolInnerTime = 10000;

	bundle = level.killstreakBundle[killstreak.killstreakType];
	if ( isdefined( bundle.ksHackToolInnerTime ) )
	{
		hackToolInnerTime = bundle.ksHackToolInnerTime;
	}
	
	return hackToolInnerTime;
}

function get_hack_tool_outer_time()
{
	killstreak = self;
	hackToolOuterTime = 10000;

	bundle = level.killstreakBundle[killstreak.killstreakType];
	if ( isdefined( bundle.ksHackToolOuterTime ) )
	{
		hackToolOuterTime = bundle.ksHackToolOuterTime;
	}
	
	return hackToolOuterTime;
}

function get_hack_tool_inner_radius()
{
	killstreak = self;
	hackedToolInnerRadius = 10000;

	bundle = level.killstreakBundle[killstreak.killstreakType];
	if ( isdefined( bundle.ksHackToolInnerRadius ) )
	{
		hackedToolInnerRadius = bundle.ksHackToolInnerRadius;
	}
	
	return hackedToolInnerRadius;
}


function get_hack_tool_outer_radius()
{
	killstreak = self;
	hackedToolOuterRadius = 10000;

	bundle = level.killstreakBundle[killstreak.killstreakType];
	if ( isdefined( bundle.ksHackToolOuterRadius ) )
	{
		hackedToolOuterRadius = bundle.ksHackToolOuterRadius;
	}
	
	return hackedToolOuterRadius;
}


function get_lost_line_of_sight_limit_msec()
{
	killstreak = self;
	hackedToolLostLineOfSightLimitMs = 1000;

	bundle = level.killstreakBundle[killstreak.killstreakType];
	if ( isdefined( bundle.ksHackToolLostLineOfSightLimitMs ) )
	{
		hackedToolLostLineOfSightLimitMs = bundle.ksHackToolLostLineOfSightLimitMs;
	}
	
	return hackedToolLostLineOfSightLimitMs;
}


function get_hack_scoreevent()
{
	killstreak = self;
	hackedScoreEvent = undefined; 
	bundle = level.killstreakBundle[killstreak.killstreakType];
	if ( isdefined( bundle.ksHackScoreEvent ) )
	{
		hackedScoreEvent = bundle.ksHackScoreEvent;
	}
	
	return hackedScoreEvent;	
}

function get_hack_fx()
{
	killstreak = self;
	hackFX = "";

	bundle = level.killstreakBundle[killstreak.killstreakType];
	if ( isdefined( bundle.ksHackFX ) )
	{
		hackFX = bundle.ksHackFX;
	}
	
	return hackFX;	
}

function get_hack_loop_fx()
{
	killstreak = self;
	hackLoopFX = "";

	bundle = level.killstreakBundle[killstreak.killstreakType];
	if ( isdefined( bundle.ksHackLoopFX ) )
	{
		hackLoopFX = bundle.ksHackLoopFX;
	}
	
	return hackLoopFX;	
} 

function get_max_health( killstreakType )
{
	bundle = level.killstreakBundle[killstreakType];
	
	return bundle.ksHealth;
}

function get_low_health( killstreakType )
{
	bundle = level.killstreakBundle[killstreakType];
	
	return bundle.ksLowHealth;
}

function get_hacked_health( killstreakType )
{
	bundle = level.killstreakBundle[killstreakType];
	
	return bundle.ksHackedHealth;
}

function get_shots_to_kill( weapon, bundle )
{
	shotsToKill = undefined;
	
	switch( weapon.rootweapon.name )
	{
		case "remote_missile_missile":
			shotsToKill = bundle.ksRemote_missile_missile;
			break;
		case "hero_annihilator":
			shotsToKill = bundle.ksHero_annihilator;
			break;
		case "hero_armblade":
			shotsToKill = bundle.ksHero_armblade;
			break;
		case "hero_bowlauncher":
			shotsToKill = bundle.ksHero_bowlauncher;
			break;
		case "hero_gravityspikes":
			shotsToKill = bundle.ksHero_gravityspikes;
			break;
		case "hero_lightninggun":
			shotsToKill = bundle.ksHero_lightninggun;
			break;
		case "hero_minigun":
			shotsToKill = bundle.ksHero_minigun;
			break;
		case "hero_pineapplegun":
			shotsToKill = bundle.ksHero_pineapplegun;
			break;
		case "dart_blade":
		case "dart_turret":
			shotsToKill = bundle.ksDartsToKill;
			break;			
	}
	
	return (isdefined(shotsToKill)?shotsToKill:0);
}

function get_emp_grenade_damage( killstreakType, maxhealth )
{
	// weapon_damage returns as undefined if it is not handled here

	emp_weapon_damage = undefined;

	if ( isdefined( level.killstreakBundle[killstreakType] ) )
    {
		bundle = level.killstreakBundle[killstreakType];
		
		empGrenadesToKill = (isdefined(bundle.ksEmpGrenadesToKill)?bundle.ksEmpGrenadesToKill:0);
		
		if ( empGrenadesToKill == 0 )
		{
			// not handled here
		}
		else if ( empGrenadesToKill > 0 )
		{
			emp_weapon_damage = maxhealth / empGrenadesToKill + 1;
		}
		else
		{
			// immune
			emp_weapon_damage = 0;
		}
	}
	
	return emp_weapon_damage;
}

function get_weapon_damage( killstreakType, maxhealth, attacker, weapon, type, damage, flags, chargeShotLevel )
{
	// weapon_damage returns as undefined if it is not handled here

	weapon_damage = undefined;

	if ( isdefined( level.killstreakBundle[killstreakType] ) )
    {
		bundle = level.killstreakBundle[killstreakType];
		
		if ( isdefined( weapon ) )
		{
			shotsToKill = get_shots_to_kill( weapon, bundle );
					
			if ( shotsToKill == 0 )
			{
				// not handled here
			}
			else if ( shotsToKill > 0 )
			{
				if ( isdefined( chargeShotLevel ) && chargeShotLevel > 0 )
				{
					// chargeShotLevel should be between 0 and 1.
					// 1 = full charge
					// > 0 = fraction of charge
					shotsToKill = shotsToKill / chargeShotLevel;
				}
				
				weapon_damage = maxhealth / shotsToKill + 1;
			}
			else
			{
				// immune
				weapon_damage = 0;
			}
		}		
		
		if ( !isdefined( weapon_damage ) )
		{
			if ( type == "MOD_RIFLE_BULLET" || type == "MOD_PISTOL_BULLET" || type == "MOD_HEAD_SHOT" )
			{
				hasFMJ =  isdefined( attacker ) && isPlayer( attacker ) && attacker HasPerk( "specialty_armorpiercing" );

				if ( hasFMJ )
				{
					clipsToKill = (isdefined(bundle.ksClipsToKillFMJ)?bundle.ksClipsToKillFMJ:0);
				}
				else
				{
					clipsToKill = (isdefined(bundle.ksClipsToKill)?bundle.ksClipsToKill:0);
				}
				
				if ( clipsToKill == 0 )
				{
					// not handled here
				}
				else if ( clipsToKill > 0 )
				{
					clipSize = 10;
					
					if ( isdefined( weapon ) )
					{
						clipSize = weapon.rootweapon.clipSize;							
					}						
					
					weapon_damage = maxhealth / clipSize / clipsToKill + 1;
				}
				else
				{
					// immune
					weapon_damage = 0;
				}
				
				if ( isdefined( weapon ) && weapon.weapClass == "spread" && isdefined( weapon.shotCount ) && weapon.shotCount > 0 )
				{
					if(!isdefined(weapon_damage))weapon_damage=damage;
					weapon_damage *= ( 1 / weapon.shotCount );
				}
			}
			else if (( type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" || type == "MOD_EXPLOSIVE" ) && ( !isdefined( weapon.isEmpKillstreak ) || !weapon.isEmpKillstreak ) )
			{
				rocketsToKill = (isdefined(bundle.ksRocketsToKill)?bundle.ksRocketsToKill:0);
				
				if ( rocketsToKill == 0 )
				{
					// not handled here
				}
				else if ( rocketsToKill > 0 )
				{
					weapon_damage = maxhealth / rocketsToKill + 1;
				}
				else
				{
					// immune
					weapon_damage = 0;
				}
			}
			else if (( type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" ) && ( !isdefined( weapon.isEmpKillstreak ) || !weapon.isEmpKillstreak ) )
			{
				grenadeDamageMultiplier = (isdefined(bundle.ksGrenadeDamageMultiplier)?bundle.ksGrenadeDamageMultiplier:0);
				
				if ( grenadeDamageMultiplier == 0 )
				{
					// not handled here
				}
				else if ( grenadeDamageMultiplier > 0 )
				{
					weapon_damage = damage * grenadeDamageMultiplier;
				}
				else
				{
					// immune
					weapon_damage = 0;
				}
			}
			else
			{
				// not handled here
			}
		}
    }

	return weapon_damage;
}