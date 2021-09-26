main(shoot, recover, aim, turret)
{
	self endon("killanimscript"); // code

	animscripts\utility::initAnimTree("turret"); // "turret" used to avoid continually adding to utility::UpdateCombatEndTime
	[[anim.PutGunInHand]]("none");

	self.anim_special = "mg42";

	if (isdefined (turret.script_delay_min))
		b30cal_delay = turret.script_delay_min;
	else
		b30cal_delay = maps\_mg42::burst_fire_settings ("delay");

	if (isdefined (turret.script_delay_max)) 
		b30cal_delay_range = turret.script_delay_max - b30cal_delay;
	else
		b30cal_delay_range = maps\_mg42::burst_fire_settings ("delay_range");

	if (isdefined (turret.script_burst_min))
		b30cal_burst = turret.script_burst_min;
	else
		b30cal_burst = maps\_mg42::burst_fire_settings ("burst");

	if (isdefined (turret.script_burst_max)) 
		b30cal_burst_range = turret.script_burst_max - b30cal_burst;
	else
		b30cal_burst_range = maps\_mg42::burst_fire_settings ("burst_range");

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

			duration = b30cal_burst + randomfloat(b30cal_burst_range);

			//println("fire duration: ", duration);
			thread TurretTimer(duration, turret);

			turret waittill("turretstatechange"); // code or script

			duration = b30cal_delay + randomfloat(b30cal_delay_range);
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

