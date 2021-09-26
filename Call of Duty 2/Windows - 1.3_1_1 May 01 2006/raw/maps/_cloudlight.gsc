cloudlight(sunlight_bright, sunlight_dark, diffuse_high, diffuse_low)
{
	level.sunlight_bright = sunlight_bright;
	level.sunlight_dark = sunlight_dark;
	level.diffuse_high = diffuse_high;
	level.diffuse_low = diffuse_low;

	setCvar("r_lighttweaksunlight", level.sunlight_dark);
	setCvar("r_lighttweakdiffusefraction", level.diffuse_low);
	direction = "up";

	for(;;)
	{
		sunlight = getCvarFloat("r_lighttweaksunlight");
		jitter = scale(1 + randomint(21));

		flip = randomint(2);
		if(flip)
			jitter = jitter * -1;
		
		if(direction == "up")
			next_target = sunlight + scale(30) + jitter;
		else
			next_target = sunlight - scale(30) + jitter;
	
		//iprintln("jitter = ", jitter);
		if(next_target >= level.sunlight_bright)
		{
			next_target = level.sunlight_bright;
			direction = "down";
		}
		
		if(next_target <= level.sunlight_dark)
		{
			next_target = level.sunlight_dark;
			direction = "up";
		}

		if(next_target > sunlight)
			brighten(next_target, (3 + randomint(3)), .05);
		else
			darken(next_target, (3 + randomint(3)), .05);
	}
}

brighten(target_sunlight, time, freq)
{
	//iprintln("Brightening sunlight to ", target_sunlight);
	sunlight = getCvarFloat("r_lighttweaksunlight");
	//diffuse = getCvarFloat("r_lighttweakdiffusefraction");
	//iprintln("sunlight = ", sunlight);
	//iprintln("diffuse = ", diffuse);
		
	totalchange = target_sunlight - sunlight;
	changeamount = totalchange / (time / freq);
	//iprintln("totalchange = ", totalchange);
	//iprintln("changeamount = ", changeamount);
	
	while(time > 0)
	{
		time = time - freq;
		
		sunlight = sunlight + changeamount;
		setCvar("r_lighttweaksunlight", sunlight);
		//iprintln("^6sunlight = ", sunlight);

		frac = (sunlight - level.sunlight_dark) / (level.sunlight_bright - level.sunlight_dark);
		diffuse = level.diffuse_high + (level.diffuse_low - level.diffuse_high) * frac;
		setCvar("r_lighttweakdiffusefraction", diffuse);
		//iprintln("^6diffuse = ", diffuse);

		wait freq;
	}
}

darken(target_sunlight, time, freq)
{
	//iprintln("Darkening sunlight to ", target_sunlight);
	sunlight = getCvarFloat("r_lighttweaksunlight");
	//diffuse = getCvarFloat("r_lighttweakdiffusefraction");
	//iprintln("sunlight = ", sunlight);
	//iprintln("diffuse = ", diffuse);
		
	totalchange = sunlight - target_sunlight;
	changeamount = totalchange / (time / freq);
	//iprintln("totalchange = ", totalchange);
	//iprintln("changeamount = ", changeamount);
	
	while(time > 0)
	{
		time = time - freq;
		
		sunlight = sunlight - changeamount;
		setCvar("r_lighttweaksunlight", sunlight);
		//iprintln("^6sunlight = ", sunlight);

		frac = (sunlight - level.sunlight_dark) / (level.sunlight_bright - level.sunlight_dark);
		diffuse = level.diffuse_high + (level.diffuse_low - level.diffuse_high) * frac;
		setCvar("r_lighttweakdiffusefraction", diffuse);
		//iprintln("^6diffuse = ", diffuse);

		wait freq;
	}
}

scale(percent)
{
		frac = percent / 100;
		return (level.sunlight_dark + frac * (level.sunlight_bright - level.sunlight_dark)) - level.sunlight_dark;
}