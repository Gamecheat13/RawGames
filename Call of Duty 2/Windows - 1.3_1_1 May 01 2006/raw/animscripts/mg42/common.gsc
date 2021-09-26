#include animscripts\SetPoseMovement;
#include animscripts\utility;
#include maps\_utility;
#include animscripts\Combat_utility;
main(shoot, recover, aim, turret)
{
	self endon("killanimscript"); // code
	if (isdefined (level.mg42BadPlace) && level.mg42BadPlace)
		thread badplaceOnDeath(turret);
	thread jumpOffTurret(turret);
	if (!isdefined (self.oldThreatbias))
		self.oldThreatbias = self.threatbias;

	if (self.team == "axis" && self.health > 100 && self.health <= 150)
		self.health = 100;
		
	self.threatbias = -500;
	

	animscripts\utility::initAnimTree("turret"); // "turret" used to avoid continually adding to utility::UpdateCombatEndTime
	// was causing errors
	self animscripts\shared::PutGunInHand("none");
	thread GetGunBackOnKillAnimScript();
	thread toggleWeaponDrop(turret);
	
//	[[anim.PutGunInHand]]("none");

	self.anim_special = "mg42";

	if (isdefined (turret.script_delay_min))
		mg42_delay = turret.script_delay_min;
	else
		mg42_delay = maps\_mg42::burst_fire_settings ("delay");

	if (isdefined (turret.script_delay_max)) 
		mg42_delay_range = turret.script_delay_max - mg42_delay;
	else
		mg42_delay_range = maps\_mg42::burst_fire_settings ("delay_range");

	if (isdefined (turret.script_burst_min))
		mg42_burst = turret.script_burst_min;
	else
		mg42_burst = maps\_mg42::burst_fire_settings ("burst");

	if (isdefined (turret.script_burst_max)) 
		mg42_burst_range = turret.script_burst_max - mg42_burst;
	else
		mg42_burst_range = maps\_mg42::burst_fire_settings ("burst_range");

	pauseUntilTime = gettime();
	turretState = "start";

	/*
	hasNode = true;
	if (!isdefined(self.node))
	{
		hasNode = false;
		node = self FindBestCoverNode();
		if ( isdefined(node) )
			self UseCoverNode(node);
	}
	*/
	
	easy = level.gameSkill == 0;
	for (;;)
	{
		/*
		if (hasNode)
		{
			if (!isdefined (self.node))
				break;
			if (distance(self.origin, self.node.origin) > self.goalradius + 128)
				break;
		}
		else
		{
			hasNode = true;
			if (!isdefined(self.node))
			{
				hasNode = false;
				node = self FindBestCoverNode();
				if ( isdefined(node) )
					self UseCoverNode(node);
			}
		}
		*/
		
		if (distance(self.origin, turret.origin) > 90)
			break;

		duration = (pauseUntilTime - gettime()) * 0.001;
		if (turret isFiringTurret() && (duration <= 0))
		{
			if (turretState != "fire")
			{
				turretState = "fire";

				thread [[shoot]](turret); // non blocking
			}

			duration = mg42_burst + randomfloat(mg42_burst_range);
			if (easy)
				duration *= (0.4 + randomfloat(0.3));

			//println("fire duration: ", duration);
			thread TurretTimer(duration, turret);

			turret waittill("turretstatechange"); // code or script

			duration = mg42_delay + randomfloat(mg42_delay_range);
			//println("stop fire duration: ", duration);

			pauseUntilTime = gettime() + int(duration * 1000);

			if (isdefined(recover))
			{
				turretState = "recover";

				[[recover]](turret); // blocking
			}
		}
		else
		{
			if (easy && flag("player_is_invulnerable"))
				duration = 1.4 + randomfloat (1);
			if (turretState != "aim")
			{
				turretState = "aim";

				thread [[aim]](turret); // non blocking
			}
			
			//println("aim duration: ", duration);
			thread TurretTimer(duration, turret);

			turret waittill("turretstatechange"); // code or script
		}
		
	}
	
	self animscripts\shared::PutGunInHand("right");
	self stopuseturret();
}

TurretTimer(duration, turret)
{
	if (duration <= 0)
		return;

	self endon("killanimscript"); // code
	turret endon("turretstatechange"); // code

	//println("start turret timer");

	wait duration;
	turret notify("turretstatechange");

	//println("end turret timer");
}

GetGunBackOnKillAnimScript()
{
	// and stop being usable for the usable turret stuff
	self endon ("death");
	self waittill ("killanimscript");
	self animscripts\shared::PutGunInHand("right");
	self.useable = false;
}

toggleWeaponDrop(turret)
{
	self endon ("death");
	// Disable dropweapon when you're on a turret
	if (!self.dropWeapon)
		return;
	self.dropWeapon = false;
	turret waittill ("turret_deactivate");

	wait (1);
	owner = turret getTurretOwner();

	if (isalive(owner) && owner == self)
	{
		// Got back on turret
		return;
	}
		
	self.dropWeapon = true;
	self.threatbias = self.oldThreatbias;
}

jumpOffTurret(turret)
{
	if (self.team != "allies")
		return;

	self endon("killanimscript"); // code
	self.useable = true;
	self setcursorhint("HINT_NONE");
	if (issubstr(turret.model, "mg42"))
		self setHintString(&"PLATFORM_USEAIONMG42");
	else
		self setHintString(&"PLATFORM_USEAION30CAL");

	for (;;)
	{
		self waittill ("trigger");
		if (isdefined (self.node))
			node = self FindBestCoverNode("ignore", self.node);
		else
			node = self FindBestCoverNode();
		node = self FindBestCoverNode();
		
		if ( isdefined(node) )
		{
			if (self UseCoverNode(node))
				break;
		}
	}
		
	self stopuseturret();
}

badplaceOnDeath(turret)
{
	self notify ("new_badplace_notify");
	self endon ("new_badplace_notify");
	org = self.origin;
	team = self.team;
	self waittill ("death");
	if (!isdefined(self))
		return;
	if (!isdefined(self.origin))
		return;
	if (distance(self.origin, turret.origin) > 100)
		return;
		
	base = level.mg42badplace_mintime;
	range = level.mg42badplace_maxtime - level.mg42badplace_mintime;
	assert (range >= 0);
	badplace_cylinder("", base + randomint(range), turret.origin, 80, 80, team);
}

