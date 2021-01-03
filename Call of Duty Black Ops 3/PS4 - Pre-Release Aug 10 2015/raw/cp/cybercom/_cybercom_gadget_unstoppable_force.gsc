#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
	
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;

#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;

                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;

#namespace cybercom_gadget_unstoppable_force;




	
function init()
{

}

function main()
{
	cybercom_gadget::registerAbility( 1, 	(1<<5), true );

	level.cybercom.unstoppable_force 					= spawnstruct();
	level.cybercom.unstoppable_force._is_flickering 	= &_is_flickering;
	level.cybercom.unstoppable_force._on_flicker 		= &_on_flicker;
	level.cybercom.unstoppable_force._on_give 			= &_on_give;
	level.cybercom.unstoppable_force._on_take 			= &_on_take;
	level.cybercom.unstoppable_force._on_connect 		= &_on_connect;
	level.cybercom.unstoppable_force._on 				= &_on;
	level.cybercom.unstoppable_force._off		 		= &_off;
	level.cybercom.unstoppable_force._is_primed 		= &_is_primed;
	level.cybercom.unstoppable_force.warlord_weapon		= GetWeapon("gadget_concussive_wave");
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
	self.cybercom.targetLockCB = undefined;
	self.cybercom.targetLockRequirementCB = undefined;
	self thread cybercom::weapon_AdvertiseAbility(weapon);
}

function _on_take( slot, weapon )
{
	self.cybercom.is_primed = undefined;
	// executed when gadget is removed from the players inventory
}

//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	if ( isDefined(self.cybercom.activeCybercomMeleeWeapon) )
	{
		self takeweapon(self.cybercom.activeCybercomMeleeWeapon);
	}
	
	self.cybercom.is_primed = undefined;
	self notify(weapon.name+"_fired");
	level notify(weapon.name+"_fired");
	self thread watch_collisions(weapon);
	self thread fireUnstoppableForce();
	self clientfield::set_to_player( "unstoppableforce_state", 1);
	// excecutes when the gadget is turned on
}

function _off( slot, weapon )
{
	self notify( "unstoppable_watch_collisions" );

	if ( isDefined(self.cybercom.activeCybercomMeleeWeapon) )
	{
		self giveweapon(self.cybercom.activeCybercomMeleeWeapon);
	}
	self clientfield::set_to_player( "unstoppableforce_state", 0);
	// excecutes when the gadget is turned off`
}

function _is_primed( slot, weapon )
{

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function private fireUnstoppableForce()
{
	self endon( "death" );
	self endon( "disconnect" );
		
	if (self isswitchingweapons())
	{
		self waittill( "weapon_change_complete" );
	}
	self QueueMeleeActionState();	
}

function private _is_good_target(target)
{
	if (!isDefined(target))
		return false;
		
	if ( !isAlive(target)) 
		return false;
		
	if( target cybercom::cybercom_AICheckOptOut("cybercom_unstoppableforce")) 
		return false;

	if (isVehicle(target))
		return false;
	
	if (!( isdefined( target.takedamage ) && target.takedamage ) )
		return false;

	if( IsActor( target ) )
	{	if( target IsInScriptedState() && !( isdefined( target.is_disabled ) && target.is_disabled ) )
		{
			if ( !target cybercom::isInstantKill() )
				return false;
		}
	}

	if(!( isdefined( target.allowdeath ) && target.allowdeath ))	
		return false;

	if(( isdefined( target.blockingpain ) && target.blockingpain ))
		return false;
	
	if(isActor(target) && target cybercom::getEntityPose() != "stand" && target cybercom::getEntityPose() !="crouch" )
		return false;
		
	return true;
}

function private _get_valid_targets()
{
	enemies 	= ArrayCombine(GetAITeamArray("axis"),GetAITeamArray("team3"),false,false);
	valid		= [];
	foreach	(mf in enemies)
	{
		if(!_is_good_target(mf))
			continue;
		valid[valid.size] = mf;
	}
	
	return valid;
}


function watch_collisions(weapon)
{
	self notify( "unstoppable_watch_collisions" );
	self endon( "unstoppable_watch_collisions" );
	
	self endon( "death" );
	self endon( "disconnect" );

	
	while( true )
	{
		enemies = unstoppableForce_get_enemies_in_range();
		hit 	= 0;
		foreach( guy in enemies)
		{
			hit++;
			if(guy cybercom::isLinked())
				guy unlink();
			
			guy notify("cybercom_action",weapon,self);
			if(guy.archetype == "warlord")
			{
				if( ( isdefined( guy.is_disabled ) && guy.is_disabled ))//already undersome cybercom
					guy DoDamage(guy.health, self.origin, self, self, "none", "MOD_MELEE", 512 /*DAMAGE_DISABLE_RAGDOLL_SKIP*/, level.cybercom.unstoppable_force.warlord_weapon,-1,true);
				else
					guy DoDamage(GetDvarInt( "scr_unstoppable_warlord_damage", 40 ), self.origin, self, self, "none", "MOD_MELEE", 512 /*DAMAGE_DISABLE_RAGDOLL_SKIP*/, level.cybercom.unstoppable_force.warlord_weapon,-1,true);
			}
			else	
				guy unstoppable_fling_enemy( self );
			
			if( guy.archetype == "robot" )
				self playsound( "gdt_unstoppable_hit_bot" );
			else
				self playsound( "gdt_unstoppable_hit_human" );
		}
		if(hit)
		{
			Earthquake( 1.0, 0.75, self.origin, 100 );
			self PlayRumbleOnEntity( "damage_heavy" );
		}
	
		{wait(.05);};
	}
}






function unstoppableForce_get_enemies_in_range()
{
	enemies 	 = _get_valid_targets();
	view_pos 	 = self.origin; // GetViewPos(); //GetWeaponMuzzlePoint();
	validTargets = array::get_all_closest( view_pos, enemies, undefined, undefined, (10 * 12) );
	if ( !isDefined( validTargets ) )
	{
		return;
	}

	forward = AnglesToForward(self GetPlayerAngles());
	up = AnglesToUp(self GetPlayerAngles());
	segment_start = view_pos + ((3 * 12) * forward);; 	
	segment_end = segment_start + (((10 * 12)-(3 * 12)) * forward);

	fling_force = GetDvarInt( "scr_unstoppable_fling_force", 175 ); 
	fling_force_vlo = fling_force * 0.5; 
	fling_force_vhi = fling_force * 0.6; 
	
	enemies = [];
	
	for ( i = 0; i < validTargets.size; i++ )
	{
		if ( !IsDefined( validTargets[i] ) || !IsAlive( validTargets[i] ) )
		{
			// guy died on us
			continue;
		}

		test_origin 	= validTargets[i] getcentroid();
		radial_origin 	= PointOnSegmentNearestToPoint( segment_start, segment_end, test_origin );
		lateral 		= test_origin - radial_origin;
		if ( abs(lateral[2]) > (6 * 12) )
		{
			continue;
		}
		lateral 		= (lateral[0],lateral[1],0);
		len 			= Length(lateral);
		if ( len > (3 * 12) )
		{
			continue;
		}
	
		lateral = (lateral[0],lateral[1],0); 
		validTargets[i].fling_vec = fling_force * forward + randomfloatrange(fling_force_vlo,fling_force_vhi) * up; // + randomfloatrange(0,50) * (len / RIOTSHIELD_JUKE_KILL_HALFWIDTH) *lateral;
		
		enemies[enemies.size] = validTargets[i];
	}
	
	return enemies; 
}

function unstoppable_fling_enemy( player )
{
	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}
	self DoDamage( self.health, player.origin, player, player, "", "MOD_IMPACT" );
	if(isDefined(self.fling_vec))
	{
		self StartRagdoll( true );
		self LaunchRagdoll( self.fling_vec );
	}
}