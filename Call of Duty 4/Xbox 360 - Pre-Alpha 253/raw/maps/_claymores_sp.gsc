#include maps\_hud_util;
#include maps\_utility;

main()
{
	level.claymoremodel = "weapon_claymore";
	precacheModel(level.claymoremodel);

	level.claymoremodelcenteroffset = (0,0,6); // offset of the center of the damage point from the origin

	level.claymoreDamageConeOuterAngle = 80; // damage is 0 at outer angle, full at inner angle (angle is from the claymore's "forward" direction)
	level.claymoreDamageConeInnerAngle = 60;
	
	level.claymoreDamageRadius = 400;
	level.claymoreMaxDamage = 100 * level.claymoreDamageRadius/60; // lerps to 0 at edge of radius (providing 50 "buffer" units at edge of radius)
	level.claymorePlantTime = 2;
	level.claymorePlantGracePeriod = 1;
	
	level.claymoreDetectionConeAngle = 40;
	level.claymoreDetectionRadius = 350;
	
	level.claymoreDetectionGracePeriod = .75;
	
	level.claymoreexplodefx = loadfx("explosions/grenadeExp_dirt");
	level.claymoreexplodesound = "grenade_explode_default";


	// should be moved to _hud.gsc
	// secondary progress bars are for less important, faster things, like planting claymores
	level.secondaryProgressBarY = 75;
	level.secondaryProgressBarHeight = 14;
	level.secondaryProgressBarWidth = 152;
	level.secondaryProgressBarTextY = 45;
	level.secondaryProgressBarFontSize = 2;


	// copy these strings to sp
	//precacheString(&"CLAYMORE_CLAYMORE_HOLDING_DETONATOR");
	precacheString(&"CLAYMORE_CLAYMORE_HOLDING_CLAYMORE");
	precacheString(&"CLAYMORE_CLAYMORE_PRESS_TO_SWITCH_TO_CLAYMORE");
	//precacheString(&"CLAYMORE_CLAYMORE_PRESS_TO_SWITCH_TO_DETONATOR");
	
	precacheString(&"CLAYMORE_PLANTING_CLAYMORE");
	precacheString(&"CLAYMORE_CANNOT_PLANT_CLAYMORE");
	
	precacheItem("claymore");
	//precacheItem("claymore_detonator");

	precacheShader("white");
	precacheShader("black");


	level.player thread monitorClaymoreUsage();
}

/*startMonitoringClaymoreUsage()
{
	self deleteAllClaymores(false);
	self thread monitorClaymoreUsage();
}
*/
/*
stopMonitoringClaymoreUsage(disconnected)
{
	self notify("stop_monitoring_claymore_usage");
	if (!disconnected && self.holdingClaymores) {
		self.holdingClaymores = false;
		self destroyClaymoreHudElements();
	}
	if (disconnected) {
		self deleteAllClaymores(true);
	}
	else {
		// make sure if they change teams, their claymores are deleted
		self thread monitorTeam();
		self thread monitorSpectating();
	}
}
*/

monitorClaymoreUsage()
{
//	self endon("stop_monitoring_claymore_usage");
	
	// hopefully we can unhardcode claymore ammo later
	if (!isdefined(level.initclaymoreammo))
		level.initclaymoreammo = 3;
	self.claymoreammo = level.initclaymoreammo;
	self.claymoreholdingdetonator = false;
	self.placingClaymore = false;
	
	self.holdingClaymores = false;

	wait randomfloat(.3);
	while(1)
	{
		if (self isClaymoreWeaponSelected())
		{
			self.holdingClaymores = true;
			
			self createClaymoreHudElements();
			self holdingClaymores(); // purposely not threaded
			self destroyClaymoreHudElements();
		}
		wait .2;
	}
}

/*
monitorTeam()
{
	self endon("stop_monitoring_claymore_usage");
	self endon("disconnect"); // (probably redundant)
	self endon("deleting_all_claymores");
	
	self waittill("joined_team");
	
	self thread deleteAllClaymores(false);
}

monitorSpectating()
{
	self endon("stop_monitoring_claymore_usage");
	self endon("disconnect"); // (probably redundant)
	self endon("deleting_all_claymores");
	
	self waittill("joined_spectators");
	
	self thread deleteAllClaymores(false);
}
*/

isClaymoreWeaponSelected()
{
	return self getCurrentWeapon() == "claymore" || self getCurrentWeapon() == "claymore_detonator";
}

changeToCorrectClaymoreWeapon()
{
	// if should be using the detonator, set weapon to claymore detonator. else, set weapon to claymore.
	if (self.claymoreholdingdetonator && self getCurrentWeapon() != "claymore_detonator") {
		self takeWeapon( "claymore" );
		self giveWeapon( "claymore_detonator" );
		self switchToWeapon( "claymore_detonator" );
	}
	else if (!self.claymoreholdingdetonator && self getCurrentWeapon() != "claymore") {
		self takeWeapon( "claymore_detonator" );
		self giveWeapon( "claymore" );
		self switchToWeapon("claymore");
	}
}

holdingClaymores()
{
	while(1)
	{
		if (!self.holdingClaymores || !(self isClaymoreWeaponSelected())) {
			self.holdingClaymores = false;
			return;
		}

		self changeToCorrectClaymoreWeapon();
		
		self controlClaymoreAmmo();
		
		if (self attackButtonPressed()) {
			if (self.claymoreholdingdetonator) {
				self detonateAllClaymores();
				while(self attackButtonPressed()) {
					wait .05;
					self controlClaymoreAmmo();
				}
			}
			else if (self.claymoreammo > 0) {
				self thread placeClaymore();
				while(self.placingClaymore) {
					wait .05;
					self controlClaymoreAmmo();
				}
				while(self attackButtonPressed()) {
					wait .05;
					self controlClaymoreAmmo();
				}
			}
		}
		else if (self useButtonPressed()) { // should be the reload button
			self setHoldingDetonator(!self.claymoreholdingdetonator);
			while(self useButtonPressed()) {
				wait .05;
				self controlClaymoreAmmo();
			}
		}
		
		wait .05;
	}
}

controlClaymoreAmmo()
{
	if (!isClaymoreWeaponSelected())
		return;

	if ( self getCurrentWeapon() == "claymore_detonator" )
		weapon = "claymore_detonator";
	else
		weapon = "claymore";

	self SetWeaponAmmoStock( weapon, self.claymoreammo );  // this should be 0 but setting it to ammo displays the number of claymores in the ammo section of the hud
	self SetWeaponAmmoClip( weapon, self.claymoreammo );
}

setClaymoreAmmo(ammo)
{
	self.claymoreammo = ammo;
	
	self SetWeaponAmmoStock( "claymore", self.claymoreammo );
	self SetWeaponAmmoClip( "claymore", self.claymoreammo );

	//self SetWeaponAmmoStock( "claymore_detonator", self.claymoreammo );
	//self SetWeaponAmmoClip( "claymore_detonator", self.claymoreammo );
}


placeClaymore()
{
	self endon("death");
	
	interval = .05;
	timesofar = 0;
	planttime = level.claymorePlantTime;
	
	if (!self isOnGround())
		return;

	origin = Spawn( "script_origin", self.origin );
	origin.angles = ( 0, 0, 0 );
	
	self PlayerLinkToDelta( origin );

	origin thread deleteOnEvent(self, "death", "canceldelete");
	self thread funcOnEvent(self, "death", "claymore_progress_bar_ended", ::endProgressBar);
	
	self.placingClaymore = true;
	
	self startProgressBar(planttime);
	plant = tryPlantClaymore(self.origin, self.angles);
	if (plant["success"])
		self.claymoreprogresstext settext(&"CLAYMORE_PLANTING_CLAYMORE");
	else
		self.claymoreprogresstext settext(&"CLAYMORE_CANNOT_PLANT_CLAYMORE");
	
	plant = undefined;
	while(1)
	{
		if (!self attackButtonPressed())
			break;
		
		wait interval;
		
		plant = tryPlantClaymore(self.origin, self.angles);
		if (plant["success"]) {
			timesofar += interval;
			self setProgressBarProgress(timesofar / planttime);
			self.claymoreprogresstext settext(&"CLAYMORE_PLANTING_CLAYMORE");

			if (timesofar >= planttime)
				break;
		}
		else
			self.claymoreprogresstext settext(&"CLAYMORE_CANNOT_PLANT_CLAYMORE");
	}
	
	self.placingClaymore = false;
	self unlink();
	origin notify("canceldelete");
	origin delete();
	
	self endProgressBar();
	
	if (timesofar >= planttime) {
		setClaymoreAmmo(self.claymoreammo - 1);
		claymore = self createClaymore(plant["position"], plant["dir"]);
		
		if (!isdefined(self.claymores))
			self.claymores = [];
		self.claymores[self.claymores.size] = claymore;
		
		// switch to detonator
		//self setHoldingDetonator(true);
		
		if (self.claymoreammo == 0)
		{
			weaponsList = self GetWeaponsList();
			for( idx = 0; idx < weaponsList.size; idx++ )
			{
				weapon = weaponsList[idx];
				if ( weapon == "none" )
					continue;
				if ( weapon == "claymore" )
					continue;
				if ( weapon == "claymore_detonator" )
					continue;
					
				self switchToWeapon( weapon );
				break;
			}
		}
	}
}

deleteOnEvent(obj, event, cancelevent)
{
	self endon("death");
	self endon(cancelevent);
	
	obj waittill(event);
	
	if (isdefined(self)) {
		self thread waitAndDelete();
		self notify(cancelevent); // kill other deleteOnEvent threads
	}
}

waitAndDelete()
{
	wait .05;
	if (isdefined(self))
		self delete();
}

funcOnEvent(obj, event, cancelevent, func, param1, param2, param3)
{
	if (isdefined(cancelevent))
		self endon(cancelevent);
	
	obj waittill(event);
	
	// func is threaded in case it notifies our cancelevent.
	if (isdefined(param1)) {
		if (isdefined(param2)) {
			if (isdefined(param3)) {
				self thread [[func]](param1, param2, param3);
			}
			else
				self thread [[func]](param1, param2);
		}
		else
			self thread [[func]](param1);
	}
	else
		self thread [[func]]();
}

startProgressBar(planttime)
{
	// show hud elements
	self.claymoreprogresstext = createSecondaryProgressBarText();
	self.claymoreprogressbar = createSecondaryProgressBar();
}

setProgressBarProgress(amount)
{
	if (amount > 1)
		amount = 1;
	
	self.claymoreprogressbar updateBar(amount);
}

endProgressBar()
{
	self notify("claymore_progress_bar_ended");
	self.claymoreprogresstext destroyElem();
	self.claymoreprogressbar destroyElem();
}

// should be moved to _hud.gsc
createSecondaryProgressBar()
{
	bar = createBar( "white", "black", level.secondaryProgressBarWidth, level.secondaryProgressBarHeight );
	bar setPoint("CENTER", undefined, 0, level.secondaryProgressBarY);
	return bar;
}

// should be moved to _hud.gsc
createSecondaryProgressBarText()
{
	text = createFontString("default", level.secondaryProgressBarFontSize);
	text setPoint("CENTER", undefined, 0, level.secondaryProgressBarTextY);
	return text;
}


tryPlantClaymore(pos, angles)
{
	dir = anglestoforward(self.angles);
	dir = vectornormalize((dir[0],dir[1],0));

	tracedir = dir + (0,0,-1);
	trace = bullettrace(self.origin + (0,0,20), self.origin + (0,0,20) + vecscale(tracedir,40), false, undefined);
	
	result = [];
	
	if (trace["fraction"] > .999 || trace["normal"][2] < .3) {
		result["success"] = false;
	}
	else {
		result["success"] = true;
		result["position"] = trace["position"];
		result["dir"] = dir;
	}
	
	return result;
}

vecscale(vec, scalar)
{
	return (vec[0]*scalar, vec[1]*scalar, vec[2]*scalar);
}

createClaymore(pos, dir)
{
	claymore = spawn("script_model", pos);
	claymore.angles = vectortoangles(dir);
	claymore setmodel(level.claymoremodel);
	//claymore thread claymorefly(vecscale(anglesToForward(self.angles), 350));
	//level.allclaymore[level.allclaymore.size] = claymore;
	claymore.owner = self;
	claymore.team = self.team; assert(isdefined(claymore.team));
//	claymore.team = self.pers["team"]; assert(isdefined(claymore.team));
	claymore.targetname = "claymore";
	
	claymore thread claymore_think();
	claymore thread claymore_damage_think();
	
//	Don't think we'll have an icon in SP
//	claymore maps\mp\_entityheadicons::setEntityHeadIcon(self.pers["team"], (0,0,20));
	
	return claymore;
}

claymore_think()
{
	self endon("claymore destroyed");
	
	detectionradius = level.claymoreDetectionRadius;
	detectionangle = level.claymoreDetectionConeAngle;
	
	pos = self.origin + level.claymoremodelcenteroffset;
	forward = anglestoforward(self.angles);
	
	wait level.claymorePlantGracePeriod; // no immediate detonation
	
	//self playsound("claymore_armed");
	
	//wait .5;
	
//	flags = 2;	// will detonate on allies and player
//	if (self.team == "allies")
//		flags = 1;	// will detonate on opfor
 	flags = 9;  // not player yes ai possibly temp
 	
	radius_trigger = spawn("trigger_radius", self.origin, flags, detectionradius, 64);

	while(1)
	{
		// look for enemies within damage cone
		detonate = false;

		radius_trigger waittill("trigger", enemy);

		if ( !isalive(enemy) )
			continue;

		enemypos = enemy.origin + (0,0,32);
		dist = distance(pos, enemypos);
			
		if (dist < detectionradius && bullettracepassed(pos, enemypos, false, self))
		{
			enemydir = vectornormalize(enemypos - pos);
			angle = acos(vectordot(enemydir, forward));
			if (angle < detectionangle) {
				detonate = true;
				break;
			}
		}

		if (detonate)
			break;
	}

	radius_trigger delete();

	self playsound ("claymore_activated");
	
	wait level.claymoreDetectionGracePeriod;
	
	self detonateSingleClaymore();
	
	wait .1;
}

claymore_damage_think()
{
	self endon("claymore destroyed");

	self.maxhealth = 100000;
	self.health = self.maxhealth;
	self setCanDamage(true);

	while(1)
	{
		self waittill("damage", amount, other);
		self.health = self.maxhealth;
		
/*
		if (level.teambased && isplayer(other) && isdefined(other.pers["team"]) && isdefined(self.owner.pers["team"]) && other.pers["team"] == self.owner.pers["team"])
		{
			// check friendly fire settings
			if (level.friendlyfire == "0" || level.friendlyfire == "2") // friendly fire set to off or reflect => no effect
				continue;
		}
*/
		
		if (amount > 20)
			break;
	}

	self setCanDamage(false);
	
	wait(.1 + randomfloat(.3));
	
	if (!isplayer(other))
		other = undefined;

	self detonateSingleClaymore(other);
}

setHoldingDetonator(holding)
{
	self.claymoreholdingdetonator = holding;
	updateClaymoreHudElements();
	self changeToCorrectClaymoreWeapon();
}

/*
deleteAllClaymores(disconnected)
{
	self notify("deleting_all_claymores");
	if (isdefined(self.claymores))
	{
		claymorearray = self.claymores;
		if (!disconnected)
			self.claymores = [];
	
		for (i = 0; i < claymorearray.size; i++)
			claymorearray[i] deleteSingleClaymore();
		
		//rebuildLevelClaymoreArray();
	}
}
*/

detonateAllClaymores() // detonates all claymore belonging to one player
{
	if (!isdefined(self.claymores))
		self.claymores = [];
	
	claymorearray = self.claymores;
	self.claymores = [];
	
	for (i = 0; i < claymorearray.size; i++)
		claymorearray[i] detonateSingleClaymoreRaw(self);

	if (self.claymoreammo > 0)
		self setHoldingDetonator(false);
}

detonateSingleClaymore(owneroverride)
{
	// must rebuild owner's claymore array or we'll get a script error when they die
	newarray = [];
	for (i = 0; i < self.owner.claymores.size; i++)
	{
		if (self.owner.claymores[i] != self)
			newarray[newarray.size] = self.owner.claymores[i];
	}
	self.owner.claymores = newarray;

	if (isdefined(owneroverride))
		self thread detonateSingleClaymoreRaw(owneroverride);
	else
		self thread detonateSingleClaymoreRaw(self.owner);
}

detonateSingleClaymoreRaw(owner) // should only be called from within detonateAllClaymore or detonateSingleClaymore.
{
	// explode, delete
	
	playfx(level.claymoreexplodefx, self.origin + level.claymoremodelcenteroffset);
	thread playsoundinspace(level.claymoreexplodesound, self.origin + level.claymoremodelcenteroffset);
	
	self claymoreDamage(self.origin + level.claymoremodelcenteroffset, anglesToForward(self.angles), owner, owner.team);
	
	self thread deleteSingleClaymore();
}

deleteSingleClaymore()
{
	self notify("claymore destroyed");
//	self maps\mp\_entityheadicons::setEntityHeadIcon("none");
	self delete();
}

claymoreDamage(pos, forward, owner, team)
{
	radius = level.claymoreDamageRadius;
	max = level.claymoreMaxDamage;
	min = 0;
	
	anglemin = level.claymoreDamageConeInnerAngle;
	anglemax = level.claymoreDamageConeOuterAngle;
	
	forward = vectornormalize(forward);
	
	ents = getDamageableEnts(pos, radius, true ,7);

	for (i = 0; i < ents.size; i++)
	{
		if (ents[i].entity == self)
			continue;
		
		dist = distance(pos, ents[i].damageCenter);
		damage = int(max + (min-max)*dist/radius);
		
		entdir = vectornormalize(ents[i].damageCenter - pos);
		angle = acos(vectordot(entdir, forward));
		if (angle < anglemax)
		{
			if (angle > anglemin)
				damage = damage * (angle-anglemax)/(anglemin-anglemax);
			
			damage = int(damage);
			
			// do damage to the entity.
			
/*			ents[i] maps\mp\gametypes\_weapons::damageEnt(
				self, // eInflictor = the entity that causes the damage (e.g. a claymore)
				owner, // eAttacker = the player that is attacking
				damage, // iDamage = the amount of damage to do
				"MOD_PROJECTILE_SPLASH", // sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
				"claymore_mp", // sWeapon = string specifying the weapon used (e.g. "claymore_mp")
				pos, // damagepos = the position damage is coming from
				vectornormalize(ents[i].damageCenter - pos) // damagedir = the direction damage is moving in
			);
*/
			ents[i].entity dodamage(damage, self.origin);

		}
	}
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
/*	
	if ( getdvarint("scr_damage_debug") != 0 )
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
*/	
	return (trace["fraction"] == 1);
}


getDamageableEnts(pos, radius, doLOS,startradius)
{
	// based on maps\mp\gametypes\_weapons::getDamageableEnts()

	ents = [];
	
	if (!isdefined(doLOS))
		doLOS = false;
	
	// ai and the player
	ai = getaiarray("allies","axis");
	ai[ai.size] = level.player;

	for (i = 0; i < ai.size; i++)
	{
		if ( !isalive(ai[i]) )
			continue;
		
		aipos = ai[i].origin + (0,0,32);
		dist = distance(pos, aipos);
		
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, aipos, startRadius, undefined)))
		{
			newent = spawnstruct();
			newent.isPlayer = true;
			newent.isADestructable = false;
			newent.entity = ai[i];
			newent.damageCenter = aipos;
			ents[ents.size] = newent;
		}
	}
	
	claymores = getentarray("claymore", "targetname");
	for (i = 0; i < claymores.size; i++)
	{
		entpos = claymores[i].origin + (0,0,4);
		dist = distance(pos, entpos);
		if (dist < radius && (!doLOS || bullettracepassed(pos, entpos, false, claymores[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.entity = claymores[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}
	
	return ents;
}



playSoundinSpace (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias, "sounddone");
	else
		org playsound (alias, "sounddone");
	org waittill ("sounddone");
	org delete();
}

createClaymoreHudElements()
{
	if (isdefined(self.showingClaymoreHudElements))
		return;
	self.showingClaymoreHudElements = true;
	
	self.claymoreHud1 = newHudElem(self);
	self.claymoreHud1.horzAlign = "left";
	self.claymoreHud1.vertAlign = "center_safearea";
	self.claymoreHud1.alignX = "left";
	self.claymoreHud1.alignY = "middle";
	self.claymoreHud1.x = 5;
	self.claymoreHud1.y = 0;
	self.claymoreHud1.archived = false;
	self.claymoreHud1.font = "default";
	self.claymoreHud1.fontscale = 1.5;

	/*self.claymoreHud2 = newClientHudElem(self);
	self.claymoreHud2.horzAlign = "left";
	self.claymoreHud2.vertAlign = "center_safearea";
	self.claymoreHud2.alignX = "left";
	self.claymoreHud2.alignY = "middle";
	self.claymoreHud2.x = 5;
	self.claymoreHud2.y = 20;
	self.claymoreHud2.archived = false;
	self.claymoreHud2.font = "default";
	self.claymoreHud2.fontscale = 1.5;*/
	
	self updateClaymoreHudElements();
}

updateClaymoreHudElements()
{
	if (!isdefined(self.showingClaymoreHudElements))
		self createClaymoreHudElements();
	
	if (self.claymoreholdingdetonator) {
		self.claymoreHud1 setText("");
//		self.claymoreHud1 setText(&"CLAYMORE_CLAYMORE_HOLDING_DETONATOR");
		//self.claymoreHud2 setText(&"CLAYMORE_CLAYMORE_PRESS_TO_SWITCH_TO_CLAYMORE");
	}
	else {
		self.claymoreHud1 setText("");
//		self.claymoreHud1 setText(&"CLAYMORE_CLAYMORE_HOLDING_CLAYMORE");
		//self.claymoreHud2 setText(&"CLAYMORE_CLAYMORE_PRESS_TO_SWITCH_TO_DETONATOR");
	}
}

destroyClaymoreHudElements()
{
	if (!isdefined(self.showingClaymoreHudElements))
		return;
	self.showingClaymoreHudElements = undefined;
	
	self.claymoreHud1 destroy();
	//self.claymoreHud2 destroy();
}
