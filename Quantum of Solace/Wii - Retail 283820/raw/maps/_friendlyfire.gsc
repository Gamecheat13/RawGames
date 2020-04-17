




#include maps\_utility;
main()
{
	level.friendlyfire["min_participation"] = -200;	
	level.friendlyfire["max_participation"]	= 1000;	
	level.friendlyfire["enemy_kill_points"]	= 200;	
	level.friendlyfire["friend_kill_points"] = -700;
	level.friendlyfire["point_loss_interval"] = 0.4;
	
	level.player.participation = 0;
	
	if (getdvar("friendlyfire_enabled") == "")
		setdvar("friendlyfire_enabled", "1");
	
	thread debug_friendlyfire();
	thread participation_point_flattenOverTime();
}

debug_friendlyfire()
{
	if (getdvar("debug_friendlyfire") == "")
		setdvar("debug_friendlyfire", "0");
	
	friendly_fire = newHudElem();
	friendly_fire.alignX = "right";
	friendly_fire.alignY = "middle";
	friendly_fire.x = 620;
	friendly_fire.y = 100;
	friendly_fire.fontScale = 2;
	friendly_fire.alpha = 0;
	
	for (;;)
	{
		if (getdvar("debug_friendlyfire") == "1")
			friendly_fire.alpha = 1;
		else
			friendly_fire.alpha = 0;
		
		friendly_fire setValue( level.player.participation );
		wait 0.25;
	}
}


friendly_fire_think(entity)
{
	if (!isdefined(entity))
		return;
	if (!isdefined(entity.team))
		entity.team = "allies";
	
	
	level endon ("mission failed");
	
	
	level thread notifyDamage(entity);
	level thread notifyDeath(entity);
	
	for (;;)
	{
		if (!isdefined(entity))
			return;
		if (entity.health <= 0)
			return;
		
		entity waittill ( "friendlyfire_notify", damage, attacker, direction, point, method );
		
		
		if (!isdefined(attacker))
			continue;
		
		
		bPlayersDamage = false;
		if (attacker == level.player)
			bPlayersDamage = true;
		else if ( (isdefined(attacker.classname)) && (attacker.classname == "script_vehicle") )
		{
			owner = attacker getVehicleOwner();
			if ( (isdefined(owner)) && (owner == level.player) )
				bPlayersDamage = true;
		}
		
		
		if (!bPlayersDamage)
			continue;

		
			
		
		
		
		if( IsDefined( attacker.team ) && (level.player IsEnemy(entity)) )
		{
			if( damage == -1 )
			{
				
				attacker maps\_stats::set_enemy_kill( method, entity.damagelocation, entity.origin );
			}
			else
			{
				
				attacker maps\_stats::set_enemy_damage( method, entity.damagelocation );
			}
		}

		
		if ( (level.player IsEnemy(entity)) && (damage == -1) )
		{
			level.player.participation += level.friendlyfire["enemy_kill_points"];
			participation_point_cap();
			return;
		}
		
		
		if( !(level.player IsEnemy(entity)) )
		{
			if (damage == -1)
			{
				
				level.player.participation += level.friendlyfire["friend_kill_points"];
			}
			else
			{
				
				d = distance(attacker.origin, point);
				scaledDamage = damage;
				scaledDamage = int(damage * (d/120));
				if (scaledDamage < 0)
					scaledDamage = 0;
				level.player.participation -= scaledDamage;
			}
			
			participation_point_cap();
			
			
			if ( check_grenade(entity, method) && savecommit_afterGrenade() )
			{
				if (damage == -1)
					return;
				else
					continue;
			}
			
			
			friendly_fire_checkPoints();
		}
	}
}

friendly_fire_checkPoints()
{
	if ( level.player.participation <= (level.friendlyfire["min_participation"] + 5))
		level thread missionfail();
}

check_grenade(entity, method)
{
	if (!isdefined(entity))
		return false;
	
	
	wasGrenade = false;
	if ( (isdefined(entity.damageweapon)) && (entity.damageweapon == "none") )
		wasGrenade = true;
	if ( (isdefined(method)) && (method == "MOD_GRENADE_SPLASH") )
		wasGrenade = true;
	
	
	return wasGrenade;
}

savecommit_afterGrenade()
{
	currentTime = gettime();
	if (currentTime < 15000)
	{
		println("^3aborting friendly fire because the level just loaded and saved and could cause a autosave grenade loop");
		return true;
	}
	else
	if ((currentTime - level.lastAutoSaveTime) < 4500)
	{
		println("^3aborting friendly fire because it could be caused by an autosave grenade loop");
		return true;
	}
	return false;
}

participation_point_cap()
{
	if (level.player.participation > level.friendlyfire["max_participation"])
		level.player.participation = level.friendlyfire["max_participation"];
	if (level.player.participation < level.friendlyfire["min_participation"])
		level.player.participation = level.friendlyfire["min_participation"];
}

participation_point_flattenOverTime()
{
	level endon ("mission failed");
	for (;;)
	{
		if (level.player.participation > 0)
		{
			level.player.participation--;
		}
		else if (level.player.participation < 0)
		{
			level.player.participation++;
		}
		wait level.friendlyfire["point_loss_interval"];
	}
}

missionfail()
{
	if (getdvar("friendlyfire_enabled") != "1")
		return;
	
	level.player endon ("death");
	level endon ("mine death");
	level notify ("mission failed");
	
	if (level.campaign == "british")
		setdvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_BRITISH");
	else if (level.campaign == "russian")
		setdvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_RUSSIAN");
	else
		setdvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_AMERICAN");
	
	maps\_utility::missionFailedWrapper();
}

notifyDamage(entity)
{
	level endon ("mission failed");
	entity endon ("death");
	for (;;)
	{
		entity waittill ( "damage", damage, attacker, direction, point, method );
		entity notify ( "friendlyfire_notify", damage, attacker, direction, point, method );
	}
}

notifyDeath(entity)
{
	level endon ("mission failed");
	entity waittill ( "death" , attacker, method );
	entity notify ( "friendlyfire_notify", -1, attacker, undefined, undefined, method );
}

detectFriendlyFireOnEntity(entity)
{
	
}
