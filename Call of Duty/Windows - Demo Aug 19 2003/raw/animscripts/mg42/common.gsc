main(shoot, recover, aim, turret)
{
	self endon("killanimscript"); // code

	animscripts\utility::initAnimTree("turret"); // "turret" used to avoid continually adding to utility::UpdateCombatEndTime
	[[anim.PutGunInHand]]("none");

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

	for (;;)
	{
		duration = (pauseUntilTime - gettime()) * 0.001;
		if (turret isFiringTurret() && (duration <= 0))
		{
			if (turretState != "fire")
			{
				turretState = "fire";

				thread [[shoot]](turret); // non blocking
			}

			duration = mg42_burst + randomfloat(mg42_burst_range);

			//println("fire duration: ", duration);
			thread TurretTimer(duration, turret);

			turret waittill("turretstatechange"); // code or script

			duration = mg42_delay + randomfloat(mg42_delay_range);
			//println("stop fire duration: ", duration);

			pauseUntilTime = gettime() + (int) (duration * 1000);

			if (isdefined(recover))
			{
				turretState = "recover";

				[[recover]](turret); // blocking
			}
		}
		else
		{
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

