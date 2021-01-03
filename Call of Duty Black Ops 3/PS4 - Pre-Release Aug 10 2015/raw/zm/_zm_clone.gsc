#using scripts\codescripts\struct;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                                                                                               

#namespace zm_clone;

// For the cymbal monkey weapon

//================================================
// spawn an actor that looks like a particular player

function spawn_player_clone( player, origin, forceweapon, forcemodel )
{
	if (!isdefined(origin))
	{
		origin = player.origin;
	}
	
	primaryWeapons = player GetWeaponsListPrimaries(); 
	if (isdefined(forceweapon))
	{
		weapon = forceweapon;
	}
	else if (primaryWeapons.size)
	{
		weapon = primaryWeapons[0];
	}
	else
	{
		weapon = player GetCurrentWeapon();
	}

	weaponmodel = weapon.worldModel;
	
	spawner = GetEnt( "fake_player_spawner", "targetname" );
	if (isdefined(spawner))
	{
		clone = spawner SpawnFromSpawner();
		clone.origin = origin;
		clone.isActor = true;
	}
	else
	{
		clone = spawn( "script_model", origin );
		clone.isActor = false;
	}

	if( IsDefined(forcemodel) )
	{
		clone SetModel( forcemodel );
	}
	else
	{
		clone SetModel( self.model );
		if (isdefined(player.headModel))
		{
			clone.headModel = player.headModel;
			clone attach(clone.headModel, "", true);
		}
	}

	if (weaponmodel != "" && weaponmodel != "none" )
	{
		clone Attach( weaponmodel, "tag_weapon_right" ); 
	}
	clone.team = player.team;
	// a couple things to get the zombie AI to ignore this actor
	clone.is_inert=true;
	clone.zombie_move_speed="walk";
	clone.script_noteworthy = "corpse_clone";

	// Don't allow players (or anything to damage the clone player)
	clone.actor_damage_func = &clone_damage_func;

	return clone;
}


//*****************************************************************************
// Don't allow players (or anything to damage the clone player)
// - We may want to change this in the future for grief exploits etc...
//	 by testing the attackers team
//*****************************************************************************

function clone_damage_func( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex )
{	
	iDamage = 0;
	if( weapon.isBallisticKnife && zm_weapons::is_weapon_upgraded( weapon ) )
	{
		self notify( "player_revived", eAttacker );
	}
	
	return iDamage;
}


//================================================
// give a clone a weapon

function clone_give_weapon( weapon )
{
	weaponmodel = weapon.worldModel;
	if (weaponmodel != "" && weaponmodel != "none" )
	{
		self Attach( weaponmodel, "tag_weapon_right" ); 
	}
}

//================================================
// play an animation

function clone_animate( animtype )
{
	if (self.isActor)
	{
		self thread clone_actor_animate( animtype );
	}
	else
	{
		self thread clone_mover_animate( animtype );
	}
}

//================================================
// internal

function clone_actor_animate( animtype )
{
	wait 0.1;
	switch( animtype )
	{
		case "laststand":
			self SetAnimStateFromASD( "laststand" );
			break;
		case "idle":
		default:
			self SetAnimStateFromASD( "idle" );
			break;
	}
}

//========================================
// Script mover style animation
//
// OLD and largely obsolete 
// Only used when there is no "fake_player_spawner" spawner to generate actors. WHich is pretty much never. 
//

#using_animtree( "zm_ally" );

function clone_mover_animate( animtype )
{
	self UseAnimTree( #animtree );
	//self SetAnim( %pb_stand_alert );
	switch( animtype )
	{
		case "laststand":
			self SetAnim( %pb_laststand_idle );
			break;
		case "afterlife":
			self SetAnim( %pb_afterlife_laststand_idle );
			break;
		case "chair":
			self SetAnim( %ai_actor_elec_chair_idle );
			break;
		case "falling":
			self SetAnim( %pb_falling_loop );
			break;
		case "idle":
		default:
			self SetAnim( %pb_stand_alert );
			break;
	}
}

