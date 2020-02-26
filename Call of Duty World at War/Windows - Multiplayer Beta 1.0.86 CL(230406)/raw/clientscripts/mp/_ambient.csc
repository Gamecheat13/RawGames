#include clientscripts\mp\_utility;
#include clientscripts\mp\_utility_code;

// setup a script_struct to play scripted Flak88 tracers FX
setup_point_fx(point, fx_id)
{
	if(isDefined(point.script_fxid))
	{
		fx_id = point.script_fxid;
	}
	
	point.fx_id = fx_id;
	
	if(isDefined(point.angles))
	{
		point.forward = anglesToForward(point.angles);
		point.up = anglesToUp(point.angles);
	}
	else
	{
		point.angles = (0, 0, 0);
		point.forward = (0, 0, 0);
		point.up = (0, 0, 0);
	}
	
	if(point.targetname == "flak_fire_fx")
	{
		level thread ambient_flak_think(point);
	}
	
	if(point.targetname == "fake_fire_fx")
	{
		level thread ambient_fakefire_think(point);
	}
}

// rotate the Flak88 tracers FX
ambient_flak_think(point)
{
	amount = undefined;
	speed = undefined;
	night = false;
	
	min_delay = 0.4;
	max_delay = 4;
	
	min_burst_time = 1;
	max_burst_time = 3;
	
	point.is_firing = false;
	level thread ambient_flak_rotate(point);
	level thread ambient_flak_flash(point, min_burst_time, max_burst_time);	
	
	for(;;)
	{
		timer = randomFloatRange(min_burst_time, max_burst_time);
		while(timer > 0)
		{
			point.is_firing = true;
			playFX(0, level._effect[point.fx_id], point.origin, point.forward, point.up);
			thread play_sound_in_space(0, "wpn_triple25_fire", point.origin);
			wait(0.2);
			
			timer -= 0.2;
		}
				
		point.is_firing = false;
		wait(randomFloatRange(min_delay, max_delay));
	}
}

// This mimics the rotation of the FX, but without using an ent (or client-ent)
// Updates the forward and up vectors which are used above
ambient_flak_rotate(point)
{
	min_pitch = 30;
	max_pitch = 80;
	
	if(isDefined(point.angles))
	{
		pointangles = point.angles;
	}
	else
	{
		pointangles = (0, 0, 0);
	}

	for(;;)
	{	
		time = randomFloatRange(0.5, 2);
		steps = time * 10;
		
		random_angle = (randomIntRange(min_pitch, max_pitch) * -1, randomInt(360), 0);
		
		forward = anglesToForward(random_angle);
		up = anglesToUp(random_angle);
			
		diff_forward = (forward - point.forward) / steps;
		diff_up = (up - point.up) / steps;
		
		for(i = 0; i < steps; i++)
		{
			point.forward += diff_forward;
			point.up += diff_up;
			
			wait(0.1);
		}
		
		point.forward = forward;
		point.up = up;
	}
}

// This gives a random chance to play a cloud flash
// or flak burst FX for the ambient Flak
ambient_flak_flash(point, min_burst_time, max_burst_time)
{
	min_dist = 5000;
	max_dist = 6500;
	
	if(isDefined(point.script_mindist))
	{
		min_dist = point.script_mindist;
	}
	
	if(isDefined(point.script_maxdist))
	{
		max_dist = point.script_maxdist;
	}
	
	min_burst_time = 0.25;
	max_burst_time = 1;

	fxpos = undefined;
	
	while(1)
	{
		if( !point.is_firing )
		{
			wait( 0.25 );
			continue;
		}
		
		fxpos = point.origin + vector_multiply(point.forward, randomIntRange(min_dist, max_dist));
		
		playFX(0, level._effect["flak_burst_single"], fxpos);
		
		if(isDefined(level.timeofday) && (level.timeofday == "evening" || level.timeofday == "night"))
		{
			playFX(0, level._effect["flak_cloudflash_night"], fxpos);
		}
		
		wait randomFloatRange(min_burst_time, max_burst_time);
	}
}



// *******************************************************************************************************
// Ambient Weapon Muzzleflashes
//
// point = a script_struct in the map
// This is used to play the ambient fake fire fx and sound
ambient_fakefire_think(point)
{
	fireSound = undefined;
	weapType  = undefined;
	
	burstMin = undefined;
	burstMax = undefined;
	betweenShotsMin = undefined;
	betweenShotsMax = undefined;
	reloadTimeMin = undefined;
	reloadTimeMax = undefined;
	soundChance = undefined;

	if(!isDefined(point.weaponinfo))
	{
		point.weaponinfo = "axis_turret";
	}

	// determine what type of weapon the script_struct is faking
	switch(point.weaponinfo)
	{
		case "allies_assault":
		
			if(isDefined(level.allies_team) && (level.allies_team == "marines"))
			{
				fireSound = "weap_bar_fire";
			}
			else
			{
				fireSound = "weap_dp28_fire_plr";
			}
			
			burstMin = 16;
			burstMax = 24;
			betweenShotsMin = 0.05;
			betweenShotsMax = 0.08;
			reloadTimeMin = 4;
			reloadTimeMax = 7;
			soundChance = 75;
			weapType = "assault";
			break;
			
		case "axis_assault":
		
			if(isDefined(level.axis_team) && (level.axis_team == "german"))
			{
				fireSound = "weap_mp44_fire";
			}
			else
			{
				fireSound = "weap_type99_fire";
			}
			
			burstMin = 16;
			burstMax = 24;
			betweenShotsMin = 0.05;
			betweenShotsMax = 0.08;
			reloadTimeMin = 4;
			reloadTimeMax = 7;
			soundChance = 75;
			weapType = "assault";
			break;
			
		case "allies_rifle":
		
			if(isDefined(level.allies_team) && (level.allies_team == "marines"))
			{
				fireSound = "weap_m1garand_fire";
			}
			else
			{
				fireSound = "weap_mosinnagant_fire";
			}
			
			burstMin = 1;
			burstMax = 3;
			betweenShotsMin = 0.8;
			betweenShotsMax = 1.3;
			reloadTimeMin = 3;
			reloadTimeMax = 6;
			soundChance = 95;
			weapType = "rifle";
			break;
			
		case "axis_rifle":
		
			if(isDefined(level.axis_team) && (level.axis_team == "german"))
			{
				fireSound = "weap_kar98k_fire";
			}
			else
			{
				fireSound = "weap_arisaka_fire";
			}
			
			burstMin = 1;
			burstMax = 3;
			betweenShotsMin = 0.8;
			betweenShotsMax = 1.3;
			reloadTimeMin = 3;
			reloadTimeMax = 6;
			soundChance = 95;
			weapType = "rifle";
			break;
			
		case "allies_smg":
		
			if(isDefined(level.allies_team) && (level.allies_team == "marines"))
			{
				fireSound = "weap_thompson_fire";
			}
			else
			{
				fireSound = "weap_ppsh_fire";
			}
			
			burstMin = 14;
			burstMax = 28;
			betweenShotsMin = 0.08;
			betweenShotsMax = 0.12;
			reloadTimeMin = 2;
			reloadTimeMax = 5;
			soundChance = 75;
			weapType = "smg";
			break;
			
		case "axis_smg":
		
			if(isDefined(level.axis_team) && (level.axis_team == "german"))
			{
				fireSound = "weap_mp40_fire";
			}
			else
			{
				fireSound = "weap_type100_fire";
			}
			
			burstMin = 14;
			burstMax = 28;
			betweenShotsMin = 0.08;
			betweenShotsMax = 0.12;
			reloadTimeMin = 2;
			reloadTimeMax = 5;
			soundChance = 75;
			weapType = "smg";
			break;
			
		case "allies_turret":
		
			if(isDefined(level.allies_team) && (level.allies_team == "marines"))
			{
				fireSound = "weap_30cal_fire";
			}
			else
			{
				fireSound = "weap_dp28_fire_plr";
			}
			
			burstMin = 60;
			burstMax = 90;
			betweenShotsMin = 0.05;
			betweenShotsMax = 0.08;
			reloadTimeMin = 3;
			reloadTimeMax = 6;
			soundChance = 95;
			weapType = "turret";
			break;
			
		case "axis_turret":
		
			if(isDefined(level.axis_team) && (level.axis_team == "german"))
			{
				fireSound = "weap_bar_fire"; //update this if the sound changes
			}
			else
			{
				fireSound = "weap_type92_fire";
			}
			
			burstMin = 60;
			burstMax = 90;
			betweenShotsMin = 0.05;
			betweenShotsMax = 0.08;
			reloadTimeMin = 3;
			reloadTimeMax = 6;
			soundChance = 95;
			weapType = "turret";
			break;

		default:
			ASSERTMSG("Ambient Fakefire: Weapon Info '" + point.weaponinfo + "' is not recognized.");
	}

	while(1)
	{
		// burst fire
		burst = randomIntRange(burstMin, burstMax);

		for(i = 0; i < burst; i++)
		{
			traceDist = 10000;
			
			target = point.origin + vector_multiply(anglesToForward(point.angles + (-3 + randomInt(6), -5 + randomInt(10), 0)), traceDist);

			// -- not using real weaponsettings
			bulletTracer(point.origin, target, false);
			
			playFX(0, level._effect[point.fx_id], point.origin, point.forward);

			// snyder steez - reduce popcorn effect
//			if(randomInt(100) <= soundChance)
//			{
//				thread play_sound_in_space(0, fireSound, point.origin);
//			}

			wait (randomFloatRange(betweenShotsMin, betweenShotsMax));
		}

		wait (randomFloatRange(reloadTimeMin, reloadTimeMax));
	}
}