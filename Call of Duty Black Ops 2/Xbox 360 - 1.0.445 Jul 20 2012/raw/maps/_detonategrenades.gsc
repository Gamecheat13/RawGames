#include common_scripts\utility;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

init()
{
	// MikeD (12/14/07): This is where we put specical fx or something for the grenades/projectiles which would be part of the spawned weapon.
	//level._effect[ "c4_light_blink" ] = loadfx( "misc/fx_light_c4_blink" );
	level._effect[ "claymore_laser" ] = loadfx( "weapon/claymore/fx_claymore_laser" );
}

watchGrenadeUsage()
{
	level.satchelexplodethisframe = false;
	self endon( "death" );
	self.satchelarray = [];
	self.claymore_array = [];
	self.throwingGrenade = false;
	self.gotPullbackNotify = false;
	
	self thread watch_concussion();
	
	thread watch_satchel();
	thread watch_satchel_detonation();
	//thread watchBouncingBetty();
	thread watch_claymores();
	self thread watch_for_throwbacks();

	for ( ;; )
	{
		self waittill ( "grenade_pullback", weaponName );
		self.throwingGrenade = true;
		self.gotPullbackNotify = true;
		
		switch( weaponName )
		{
		case "willy_pete_sp":
			break;
		default:
			self begin_grenade_tracking();
			break;
		}
		//// SRS 11/28/07: updated to satchel_charge
		//if ( weaponName == "satchel_charge_mp" )
		//	self beginSatchelTracking();
		//if ( weaponName == "satchel_charge" )
		//	self beginSatchelTracking();
		//if ( weaponName == "satchel_charge_new" )
		//	self beginSatchelTracking();
		//else if( weaponName == "smoke_grenade_american" )
		//	self beginsmokegrenadetracking();
		//// CPierro - 07.25.08: updated for throwable mortars 
		//else if( weaponName == "mortar_round")
		//	self beginMortarTracking();
		//else
		//	self beginGrenadeTracking();
	}
}


begin_smoke_grenade_tracking()
{
	self waittill ( "grenade_fire", grenade, weaponName );
	if(!isdefined( level.smokegrenades ) )
		level.smokegrenades = 0;
	if( level.smokegrenades > 2 && GetDvar( "player_sustainAmmo") != "0" )
		grenade delete();
	else
		grenade thread smoke_grenade_death();
}

begin_mortar_tracking()
{
	self endon("death");
	self endon("disconnect");
	self waittill ( "grenade_fire", mortar, weaponName );
	if(weaponName == "mortar_round")
	{
		mortar thread mortar_death();	
	}
}

mortar_death()
{
	self waittill_not_moving();
	earthquake(.55 ,3,self.origin,1500);
	//add rumble
	PlayRumbleOnPosition( "explosion_generic",self.origin );
}

smoke_grenade_death()
{
	level.smokegrenades ++;
	wait 50;
	level.smokegrenades --;
}

begin_grenade_tracking()
{
	self endon ( "death" );
	
	self waittill ( "grenade_fire", grenade, weaponName );

	self maps\_dds::dds_notify_grenade( weaponName, ( self.team == "allies" ), false );

	self.throwingGrenade = false;
}

watch_for_throwbacks()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	for ( ;; )
	{
		self waittill ( "grenade_fire", grenade, weapname );
		if ( self.gotPullbackNotify )
		{
			self.gotPullbackNotify = false;
			continue;
		}
		if ( !isSubStr( weapname, "frag" ) )
			continue;
		
		// no grenade_pullback notify! we must have picked it up off the ground.
		grenade.threwBack = true;

		self maps\_dds::dds_notify_grenade( weapname, ( self.team == "allies" ), true );
	}
}

begin_satchel_tracking()
{
	self endon ( "death" );
	
	self waittill_any ( "grenade_fire", "weapon_change" );
	self.throwingGrenade = false;
}

watch_satchel()
{
	//maxSatchels = 2;

	while(1)
	{
		self waittill( "grenade_fire", satchel, weapname );
		if ( weapname == "satchel_charge_mp" || weapname == "satchel_charge_new" || weapname == "satchel_charge_sp")
		{
			/*if ( self.satchelarray.size >= maxSatchels )
			{
				newarray = [];
				for ( i = 0; i < self.satchelarray.size; i++ )
				{
					if ( isdefined(self.satchelarray[i]) )
						newarray[newarray.size] = self.satchelarray[i];
				}
				self.satchelarray = newarray;
				for ( i = 0; i < self.satchelarray.size - maxSatchels + 1; i++ )
				{
					self.satchelarray[i] delete();
				}
				newarray = [];
				for ( i = 0; i < maxSatchels - 1; i++ )
				{
					newarray[i] = self.satchelarray[self.satchelarray.size - maxSatchels + 1 + i];
				}
				self.satchelarray = newarray;
			}*/
			self.satchelarray[self.satchelarray.size] = satchel;
			satchel.owner = self;
//			satchel thread maps\mp\gametypes\_shellshock::satchel_earthQuake();
			satchel thread satchel_damage();
		}
	}
}


/*
// monitor bouncing betties
watchBouncingBetty()
{

	while(1)
	{
		self waittill( "grenade_fire", bouncing_betty, weapname );
		if ( weapname == "bouncing_betty" )
		{
			self.bouncing_betty_array[self.bouncing_betty_array.size] = bouncing_betty;
			bouncing_betty.owner = self;
			bouncing_betty thread betty_setup_trigger();
			// should these be triggered by damage?
			//bouncing_betty thread bouncingBettyDamage();
		}
	}
	
}
*/

watch_claymores()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "grenade_fire", placed_explosive, weapname );
		if ( weapname == "claymore_sp"  )
		{
			placed_explosive.owner = self;
			placed_explosive thread satchel_damage();
			placed_explosive thread claymore_detonation();
			placed_explosive thread play_claymore_effects();
		}
		else if( weapname == "tc6_mine_sp" )
		{
			placed_explosive.owner = self;
			placed_explosive thread satchel_damage();
			placed_explosive thread tc6_mine_detonation();
		}
	}
}

#define MINE_ACTIVATION_TIME 5

tc6_mine_detonation()
{
	self endon("death");
	
	waittill_not_moving();
	
	should_detonate = false;
	
	const vehicle_spawnflag = 23; //-- so that vehicles and all AI will trigger this flag
	const ai_spawnflag = 3; //-- ai and player (this does not handle neutral AI setting it off)
	
	const detonateRadius = 25; //-- vehicles
	const ai_detonateRadius = 36;	//-- ai and player
	
	damagearea = spawn("trigger_radius", self.origin + (0,0,0-detonateRadius), vehicle_spawnflag, detonateRadius, detonateRadius*2);
	ai_damagearea = spawn( "trigger_radius", self.origin + (0,0,0-ai_detonateRadius), ai_spawnflag, ai_detonateRadius, ai_detonateRadius*2);
	
	//-- takes 5 seconds for the mine to activate
	wait(MINE_ACTIVATION_TIME);
	self playsound ("wpn_claymore_alert");
	wait(0.2);
	
	while(1)
	{
		damagearea waittill( "trigger", ent );
		
		if( IS_VEHICLE( ent ) )
		{
			should_detonate = true;
			
			//TODO - get vehicle speed to determine detonation delay
			wait 1;
		}
		
		else
		{
			//-- assume that it's an AI or the player
			while( ent IsTouching(damagearea) && !ent IsTouching(ai_damagearea) )
			{
				wait(0.05);
			}
			
			//-- if the ai/player touched the inside trigger then blowup
			if(ent IsTouching(ai_damagearea))
			{
				should_detonate = true;	
			}
		}
		
		if (should_detonate)
		{
			if ( IsDefined( self.owner ) )
			{
				self Detonate( self.owner );
			}
			else
			{
				self Detonate( undefined );
			}
			
			
			damagearea Delete();
			ai_damagearea Delete();
			
			return;
		}
	}

	
}

claymore_detonation()
{
	self endon("death");
	
	// wait until we settle
	self waittill_not_moving();
	
	const detonateRadius = 192;//matches MP
	
	spawnFlag = 1 + 16;// SF_TOUCH_AI_AXIS | SF_TOUCH_VEHICLE
	playerTeamToAllow = "axis";
	if( isDefined( self.owner ) && isDefined( self.owner.pers["team"] ) && self.owner.pers["team"] == "axis" )
	{
		spawnFlag = 2 + 16;// SF_TOUCH_AI_ALLIES | SF_TOUCH_VEHICLE
		playerTeamToAllow = "allies";
	}
	damagearea = spawn("trigger_radius", self.origin + (0,0,0-detonateRadius), spawnFlag, detonateRadius, detonateRadius*2);

	self thread delete_claymores_on_death( damagearea );
	
	if(!isdefined(level.claymores))
		level.claymores = [];
	ARRAY_ADD( level.claymores, self );
	
	if( level.claymores.size > 15 && GetDvar( "player_sustainAmmo") != "0" )
		level.claymores[0] delete();
	
	while(1)
	{
		damagearea waittill( "trigger", ent );
		
		if ( isdefined( self.owner ) && ent == self.owner )
			continue;
		
		if( ent IsVehicle() && ( IsDefined( ent GetTeam() ) && ( ent GetTeam() != playerTeamToAllow ) ) )
			continue;

		if( isDefined( ent.pers ) && isDefined( ent.pers["team"] ) && ent.pers["team"] != playerTeamToAllow )
			continue;
		
		if ( ent damageConeTrace(self.origin, self) > 0 )
		{
			self playsound ("wpn_claymore_alert");
			wait 0.4;
			if ( isdefined( self.owner ) )
				self detonate( self.owner );
			else
			self detonate( undefined );
				
			return;
		}
	}
}

delete_claymores_on_death(ent)
{
	self waittill("death");
	// stupid getarraykeys in array_remove reversing the order - nate
	ArrayRemoveValue( level.claymores, self );
	wait .05;
	if ( isdefined( ent ) )
		ent delete();
}

watch_satchel_detonation()
{
	self endon("death");
	while(1)
	{
		self waittill( "detonate" );
		weap = self GetCurrentWeapon();
		//if ( weap == "satchel_charge_sp" || weap == "ied_sp" )
		{
			note = weap + "_detonated";
			self notify(note);
			for ( i = 0; i < self.satchelarray.size; i++ )
			{
				if ( isdefined(self.satchelarray[i]) )
					self.satchelarray[i] thread wait_and_detonate( 0.1 );
			}
			self.satchelarray = [];
		}
	}
}

wait_and_detonate( delay )
{
	self endon("death");
	wait delay;
	
	earthquake(.35 ,3,self.origin,1500);
	self detonate();
	self delete();
}


satchel_damage()
{
//	self endon( "death" );

	self.health = 100;
	self setcandamage(true);
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	attacker = undefined;
	
	while(1)
	{
		self waittill("damage", amount, attacker);
		if ( !isplayer(attacker) )
			continue;

		// don't allow people to destroy satchels on their team if FF is off
//		if ( !friendlyFireCheck(self.owner, attacker) )
//			continue;
		
		break;
	}
	
	if ( level.satchelexplodethisframe )
		wait .1 + randomfloat(.4);
	else
		wait .05;
	
	if (!isdefined(self))
		return;
	
	level.satchelexplodethisframe = true;
	
	thread reset_satchel_explode_this_frame();
	
	self detonate( attacker );
	// won't get here; got death notify.
}

/*
bouncingBettyDamage()
{

	self.health = 100;
	self setcandamage(true);
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	attacker = undefined;
	
	while(1)
	{
		self waittill( "damage", amount, attacker );
		if ( !isplayer( attacker ) )
		{
			continue;
		}

		break;
	}
	
	// is this needed for betties?
//	if ( level.satchelexplodethisframe )
//		wait .1 + randomfloat(.4);
//	else
//		wait .05;
	
	
	if (!isdefined(self))
	{
		return;
	}
	
	// is this needed for betties?
	//level.satchelexplodethisframe = true;
	//thread reset_satchel_explode_this_frame();
	
	self detonate( attacker );
	// won't get here; got death notify.	
	
}


// dpg 1/15/08 added for betties
betty_setup_trigger()
{

	betty_trig = Spawn( "trigger_radius", self.origin, 9, 80, 300 );
	
	self thread maps\_bouncing_betties::betty_think_no_wires( betty_trig );
	
}

*/


reset_satchel_explode_this_frame()
{
	wait .05;
	level.satchelexplodethisframe = false;
}
/#
saydamaged(orig, amount)
{
	for (i = 0; i < 60; i++)
	{
		print3d(orig, "damaged! " + amount);
		wait .05;
	}
}
#/
play_claymore_effects()
{
	self endon("death");
	
	self waittill_not_moving();
	
	PlayFXOnTag( level._effect[ "claymore_laser" ], self, "tag_fx" );
}

// these functions are used with scripted weapons (like satchels, claymores, artillery)
// returns an array of objects representing damageable entities (including players) within a given sphere.
// each object has the property damageCenter, which represents its center (the location from which it can be damaged).
// each object also has the property entity, which contains the entity that it represents.
// to damage it, call damageEnt() on it.
getDamageableEnts(pos, radius, doLOS, startRadius)
{
	ents = [];
	
	if (!isdefined(doLOS))
		doLOS = false;
		
	if ( !isdefined( startRadius ) )
		startRadius = 0;
	
	// players
	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		if (!isalive(players[i]) || players[i].sessionstate != "playing")
			continue;
		
		playerpos = players[i].origin + (0,0,32);
		distsq = distancesquared(pos, playerpos);
		if (distsq < radius*radius && (!doLOS || weaponDamageTracePassed(pos, playerpos, startRadius, undefined)))
		{
			newent = spawnstruct();
			newent.isPlayer = true;
			newent.isADestructable = false;
			newent.entity = players[i];
			newent.damageCenter = playerpos;
			ents[ents.size] = newent;
		}
	}
	
	// grenades
	grenades = getentarray("grenade", "classname");
	for (i = 0; i < grenades.size; i++)
	{
		entpos = grenades[i].origin;
		distsq = distancesquared(pos, entpos);
		if (distsq < radius*radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, grenades[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.entity = grenades[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}
	
	destructables = getentarray("destructable", "targetname");
	for (i = 0; i < destructables.size; i++)
	{
		entpos = destructables[i].origin;
		distsq = distancesquared(pos, entpos);
		if (distsq < radius*radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, destructables[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = true;
			newent.entity = destructables[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}
	
	return ents;
}

weaponDamageTracePassed(from, to, startRadius, ignore)
{
	midpos = undefined;
	
	diff = to - from;
	if ( lengthsquared( diff ) < startRadius*startRadius )
		midpos = to;
	dir = vectornormalize( diff );
	midpos = from + (dir[0]*startRadius, dir[1]*startRadius, dir[2]*startRadius);

	trace = bullettrace(midpos, to, false, ignore);
	/#
	if ( GetDvarint( "scr_damage_debug") != 0 )
	{
		if (trace["fraction"] == 1)
		{
			thread debugline(midpos, to, (1,1,1));
		}
		else
		{
			thread debugline(midpos, trace["position"], (1,.9,.8));
			thread debugline(trace["position"], to, (1,.4,.3));
		}
	}
	#/
	return (trace["fraction"] == 1);
}

// eInflictor = the entity that causes the damage (e.g. a claymore)
// eAttacker = the player that is attacking
// iDamage = the amount of damage to do
// sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
// sWeapon = string specifying the weapon used (e.g. "claymore_mp")
// damagepos = the position damage is coming from
// damagedir = the direction damage is moving in
damageEnt(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, damagepos, damagedir)
{
	if (self.isPlayer)
	{
		self.damageOrigin = damagepos;
		self.entity thread [[level.callbackPlayerDamage]](
			eInflictor, // eInflictor The entity that causes the damage.(e.g. a turret)
			eAttacker, // eAttacker The entity that is attacking.
			iDamage, // iDamage Integer specifying the amount of damage done
			0, // iDFlags Integer specifying flags that are to be applied to the damage
			sMeansOfDeath, // sMeansOfDeath Integer specifying the method of death
			sWeapon, // sWeapon The weapon number of the weapon used to inflict the damage
			damagepos, // vPoint The point the damage is from?
			damagedir, // vDir The direction of the damage
			"none", // sHitLoc The location of the hit
			0 // psOffsetTime The time offset for the damage
		);
	}
	else
	{
		// destructable walls and such can only be damaged in certain ways.
		if (self.isADestructable && (sWeapon == "artillery_mp" || sWeapon == "claymore_mp"))
			return;
		
		self.entity damage_notify_wrapper( iDamage, eAttacker );
	}
}

/#
debugline(a, b, color)
{
	for (i = 0; i < 30*20; i++)
	{
		line(a,b, color);
		wait .05;
	}
}
#/

watch_concussion()
{
	self endon ( "death" );
	
	while( 1 )
	{
		self waittill ( "grenade_fire", grenade, weapname );
		/* // moved to _callbackglobal
		switch( weapname )
		{
			case "concussion_grenade_sp":
			case "concussion_grenade_future_sp":
				// should match weapon settings in gdt
				const radius = 512;
				dist = distance( self.origin, grenade.origin );
				scale = 1 - dist / radius;
				
				time = 1 + (4 * scale);
				
				grenade waittill( "death" );
				
				wait ( 0.05 );
				
				self shellShock( "concussion_grenade_mp", time );
				
			break;
			default:
				// shellshock will only be done if meansofdeath is an appropriate type and if there is enough damage.
	//			maps\mp\gametypes\_shellshock::shellshockOnDamage( meansOfDeath, damage );
			break;
		}
		*/
	}
	
}