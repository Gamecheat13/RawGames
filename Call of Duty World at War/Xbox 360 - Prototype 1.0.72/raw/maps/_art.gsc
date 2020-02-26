// This function should take care of grain and glow settings for each map, plus anything else that artists 
// need to be able to tweak without bothering level designers.
#include maps\_utility;
#include common_scripts\utility;

main()
{
	if ( getDvar( "scr_art_tweak" ) == "" || getDvar( "scr_art_tweak" ) == "0" )
		setDvar( "scr_art_tweak", 0 );

	if ( getDvar( "scr_dof_enable" ) == "" )
		setDvar( "scr_dof_enable", "1" );
		
	if ( getDvar( "scr_cinematic_autofocus" ) == "" )
		setDvar( "scr_cinematic_autofocus", "1" );

	if( !isDefined( level.dofDefault ) )
	{
		level.dofDefault["nearStart"] = 0;
		level.dofDefault["nearEnd"] = 1;
		level.dofDefault["farStart"] = 8000;
		level.dofDefault["farEnd"] = 10000;
		level.dofDefault["nearBlur"] = 5;
		level.dofDefault["farBlur"] = 0;
	}

	level.curDoF = (level.dofDefault["farStart"] - level.dofDefault["nearEnd"]) / 2;
	
	if ( getDvarInt( "scr_dof_enable" ) )
		thread adsDoF();

	thread tweakart();
	
	if ( !isdefined( level.script ) )
		level.script = tolower(getdvar ("mapname"));

	// Grain has been cut
	/*
	if (getDvar("r_grainfilter") == "")
		setdvar("r_grainfilter", "1");
	thread grain_filter();
	*/	
	
}

grain_filter()
{
// Grain has been cut.
/*
	//*****Full screen grain filter*****
	overlay = undefined;
	precacheShader("overlay_grain");
	for(;;)
	{
		if (getdvarfloat("r_grainfilter") > 0)
		{
			if (!isdefined(overlay))
			{
				overlay = newHudElem();
				overlay.x = 0;
				overlay.y = 0;
				overlay setshader ("overlay_grain", 640, 480);
				overlay.alignX = "left";
				overlay.alignY = "top";
				overlay.horzAlign = "fullscreen";
				overlay.vertAlign = "fullscreen";
			}
		}
		else
		{
			if (isdefined(overlay))
				overlay destroy();
		}
		if (isdefined(overlay))
			overlay.alpha = level.grainstrength * getdvarfloat("r_grainfilter");
		wait 0.05;
	}
*/
}



artfxprintln(file,string)
{
	// printing to file is optional now
	if(file == -1)
		return;
	fprintln(file,string);
}



tweakart()
{
	/#
	if(!isdefined(level.tweakfile))
		level.tweakfile = false;
	
	if(level.tweakfile && level.bScriptgened)
		script_gen_dump_addline("maps\\createart\\"+level.script+"_art::main();",level.script+"_art");  // adds to scriptgendump

	// Default values
	
	if(getdvar("scr_fog_red") == "")
	{
		setdvar("scr_fog_exp_halfplane", "500");
		setdvar("scr_fog_nearplane", "0");
		setdvar("scr_fog_red", "0.5");
		setdvar("scr_fog_green", "0.5");
		setdvar("scr_fog_blue", "0.5");
	}

	setdvar("scr_fog_fraction", "1.0");
	setdvar("scr_art_dump", "0");

	
	setdvar("scr_dof_nearStart",level.dofDefault["nearStart"]);
	setdvar("scr_dof_nearEnd",level.dofDefault["nearEnd"]);
	setdvar("scr_dof_farStart",level.dofDefault["farStart"]);
	setdvar("scr_dof_farEnd",level.dofDefault["farEnd"]);
	setdvar("scr_dof_nearBlur",level.dofDefault["nearBlur"]);
	setdvar("scr_dof_farBlur",level.dofDefault["farBlur"]);	

	level.fogfraction = 1.0;
	file = undefined;
	filename = undefined;
	
	dofvarupdate();
	
	//test
	//	filename = "createart/"+level.script+"_art.gsc";
	//	file = openfile(filename,"read");	
	//	file = closefile(file);
	
	//end test
	thread dvarsets();
	
	
	for(;;)
	{
		while(getDvarint( "scr_art_tweak" ) == 0 )
		{
			assertex(getdvar("scr_art_dump") == "0","Must Enable Art Tweaks to export _art file.");
			wait .05;
		}
			
		tweakfog_fraction();
		level.fogexphalfplane = getdvarfloat("scr_fog_exp_halfplane");
		level.fognearplane = getdvarfloat("scr_fog_nearplane");
		level.fogred = getdvarfloat("scr_fog_red");
		level.foggreen = getdvarfloat("scr_fog_green");
		level.fogblue = getdvarfloat("scr_fog_blue");


		dofvarupdate();

		
		//catch all those cases where a slider can be pushed to a place of conflict
		if(level.dofDefault["nearStart"] >= level.dofDefault["nearEnd"])
		{
			level.dofDefault["nearStart"] = level.dofDefault["nearEnd"]-1;
			setdvar("scr_dof_nearStart",level.dofDefault["nearStart"]);
		}
		if(level.dofDefault["nearEnd"] <= level.dofDefault["nearStart"])
		{
			level.dofDefault["nearEnd"] = level.dofDefault["nearStart"]+1;
			setdvar("scr_dof_nearEnd",level.dofDefault["nearEnd"]);
		}
		if(level.dofDefault["farStart"] >= level.dofDefault["farEnd"])
		{
			level.dofDefault["farStart"] = level.dofDefault["farEnd"]-1;
			setdvar("scr_dof_farStart",level.dofDefault["farStart"]);
		}
		if(level.dofDefault["farEnd"] <= level.dofDefault["farStart"])
		{
			level.dofDefault["farEnd"] = level.dofDefault["farStart"]+1;
			setdvar("scr_dof_farEnd",level.dofDefault["farEnd"]);
		}
		if(level.dofDefault["farBlur"] >= level.dofDefault["nearBlur"])
		{
			level.dofDefault["farBlur"] = level.dofDefault["nearBlur"]-.1;
			setdvar("scr_dof_farBlur",level.dofDefault["farBlur"]);
		}
		if(level.dofDefault["farStart"] <= level.dofDefault["nearEnd"])
		{
			level.dofDefault["farStart"] = level.dofDefault["nearEnd"]+1;
			setdvar("scr_dof_farStart",level.dofDefault["farStart"]);
		}

		if(getdvar("scr_art_dump") != "0")
		{
			filename = "createart/"+level.script+"_art.gsc";

			//////////////////

			file = openfile(filename,"write");

			assertex(file != -1, "File not writeable (maybe you should check it out): " + filename);
			
			
			artfxprintln (file,"//_createart generated.  modify at your own risk. Changing values should be fine.");
			artfxprintln (file,"main()");
			artfxprintln (file,"{");
			dump = true;

			artfxprintln(file,"");
			artfxprintln(file,"\tlevel.tweakfile = true;");
			artfxprintln(file," ");

			artfxprintln(file,"\t// *Fog section* ");
			artfxprintln(file,"");

			artfxprintln(file,"\tsetdvar(\"scr_fog_exp_halfplane\""+", "+"\""+level.fogexphalfplane+"\""+");");
			artfxprintln(file,"\tsetdvar(\"scr_fog_nearplane\""+", "+"\""+level.fognearplane+"\""+");");
			artfxprintln(file,"\tsetdvar(\"scr_fog_red\""+", "+"\""+level.fogred+"\""+");");
			artfxprintln(file,"\tsetdvar(\"scr_fog_green\""+", "+"\""+level.foggreen+"\""+");");
			artfxprintln(file,"\tsetdvar(\"scr_fog_blue\""+", "+"\""+level.fogblue+"\""+");");
			
			artfxprintln(file,"");
			artfxprintln(file,"\t// *depth of field section* ");
			artfxprintln(file,"");
	
			artfxprintln(file,"\tlevel.dofDefault[\"nearStart\"] = "+getdvarint("scr_dof_nearStart")+";");
			artfxprintln(file,"\tlevel.dofDefault[\"nearEnd\"] = "+getdvarint("scr_dof_nearEnd")+";");
			artfxprintln(file,"\tlevel.dofDefault[\"farStart\"] = "+getdvarint("scr_dof_farStart")+";");
			artfxprintln(file,"\tlevel.dofDefault[\"farEnd\"] = "+getdvarint("scr_dof_farEnd")+";");
			artfxprintln(file,"\tlevel.dofDefault[\"nearBlur\"] = "+getdvarfloat("scr_dof_nearBlur")+";");
			artfxprintln(file,"\tlevel.dofDefault[\"farBlur\"] = "+getdvarfloat("scr_dof_farBlur")+";");
			
//			artfxprintln(file,"level.dof = level.dofDefault;");
			artfxprintln(file,"\tgetent(\"player\",\"classname\") maps\\_art::setdefaultdepthoffield();");
			
			// vision store variables are a quick and dirty method of storing vision file values to the script so that next time we write everything they don't get interupted
				
			if(getdvar("r_glowUseTweaks") == "0")
				getvar = "visionstore";
			else
				getvar = "r";

			if(getdvar("visionstore_glowTweakEnable") == "")
				getvar = "r";  // for initial settings

			artfxprintln(file,"\tsetdvar(\"visionstore_glowTweakEnable\""+", "+"\""+getdvar(getvar+"_glowTweakEnable")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_glowTweakRadius0\""+", "+"\""+getdvar(getvar+"_glowTweakRadius0")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_glowTweakRadius1\""+", "+"\""+getdvar(getvar+"_glowTweakRadius1")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_glowTweakBloomCutoff\""+", "+"\""+getdvar(getvar+"_glowTweakBloomCutoff")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_glowTweakBloomDesaturation\""+", "+"\""+getdvar(getvar+"_glowTweakBloomDesaturation")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_glowTweakBloomIntensity0\""+", "+"\""+getdvar(getvar+"_glowTweakBloomIntensity0")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_glowTweakBloomIntensity1\""+", "+"\""+getdvar(getvar+"_glowTweakBloomIntensity1")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_glowTweakSkyBleedIntensity0\""+", "+"\""+getdvar(getvar+"_glowTweakSkyBleedIntensity0")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_glowTweakSkyBleedIntensity1\""+", "+"\""+getdvar(getvar+"_glowTweakSkyBleedIntensity1")+"\""+");");

			if(getdvar("r_glowUseTweaks") == "0")
				getvar = "visionstore";
			else
				getvar = "r";

			if(getdvar("visionstore_filmTweakEnable") == "")
				getvar = "r";  // for initial settings
								
			artfxprintln(file,"\tsetdvar(\"visionstore_filmTweakEnable\""+", "+"\""+getdvar(getvar+"_filmTweakEnable")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_filmTweakContrast\""+", "+"\""+getdvar(getvar+"_filmTweakContrast")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_filmTweakBrightness\""+", "+"\""+getdvar(getvar+"_filmTweakBrightness")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_filmTweakDesaturation\""+", "+"\""+getdvar(getvar+"_filmTweakDesaturation")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_filmTweakInvert\""+", "+"\""+getdvar(getvar+"_filmTweakInvert")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_filmTweakLightTint\""+", "+"\""+getdvar(getvar+"_filmTweakLightTint")+"\""+");");
			artfxprintln(file,"\tsetdvar(\"visionstore_filmTweakDarkTint\""+", "+"\""+getdvar(getvar+"_filmTweakDarkTint")+"\""+");");
	
			artfxprintln(file,"");
			artfxprintln(file,"\t//");
			artfxprintln(file,"");
			artfxprintln(file,"\tsetExpFog("+level.fognearplane+", "+level.fogexphalfplane+", "+level.fogred+", "+level.foggreen+", "+level.fogblue+", 0);");
			artfxprintln( file, "\tVisionSetNaked( \"" + level.script + "\", 0 );" );
	
			artfxprintln( file, "" );
			artfxprintln( file, "}" );
	
			saved = closefile(file);
			assertex( (saved == 1), "File not saved (see above message?): " + filename );
			//////////////////////////////

			visionFilename = "vision/" + level.script + ".vision";
			file = openfile( visionFilename, "write" );

			assertex( (file != -1), "File not writeable (may need checked out of P4): " + filename );
			

			if(getdvar("r_glowUseTweaks") != "0")
				getvar = "r";
			else
				getvar = "visionstore";

			if(getdvar("visionstore_glow") == "")
				getvar = "r";  // for initial settings


			artfxprintln( file, "r_glow                    \"" + getdvar(getvar+"_glowTweakEnable") + "\"" );
			artfxprintln( file, "r_glowRadius0             \"" + getdvar(getvar+"_glowTweakRadius0") + "\"" );
			artfxprintln( file, "r_glowRadius1             \"" + getdvar(getvar+"_glowTweakRadius1") + "\"" );
			artfxprintln( file, "r_glowBloomCutoff         \"" + getdvar(getvar+"_glowTweakBloomCutoff") + "\"" );
			artfxprintln( file, "r_glowBloomDesaturation   \"" + getdvar(getvar+"_glowTweakBloomDesaturation") + "\"" );
			artfxprintln( file, "r_glowBloomIntensity0     \"" + getdvar(getvar+"_glowTweakBloomIntensity0") + "\"" );
			artfxprintln( file, "r_glowBloomIntensity1     \"" + getdvar(getvar+"_glowTweakBloomIntensity1") + "\"" );
			artfxprintln( file, "r_glowSkyBleedIntensity0  \"" + getdvar(getvar+"_glowTweakSkyBleedIntensity0") + "\"" );
			artfxprintln( file, "r_glowSkyBleedIntensity1  \"" + getdvar(getvar+"_glowTweakSkyBleedIntensity1") + "\"" );

			artfxprintln( file, " " );

			if(getdvar("r_filmUseTweaks") != "0")
				getvar = "r";
			else
				getvar = "visionstore";

			if(getdvar("visionstore_filmEnable") == "")
				getvar = "r";  // for initial settings
				
			artfxprintln( file, "r_filmEnable              \"" + getdvar(getvar+"_filmTweakEnable") + "\"" );
			artfxprintln( file, "r_filmContrast            \"" + getdvar(getvar+"_filmTweakContrast") + "\"" );
			artfxprintln( file, "r_filmBrightness          \"" + getdvar(getvar+"_filmTweakBrightness") + "\"" );
			artfxprintln( file, "r_filmDesaturation        \"" + getdvar(getvar+"_filmTweakDesaturation") + "\"" );
			artfxprintln( file, "r_filmInvert              \"" + getdvar(getvar+"_filmTweakInvert") + "\"" );
			artfxprintln( file, "r_filmLightTint           \"" + getdvar(getvar+"_filmTweakLightTint") + "\"" );
			artfxprintln( file, "r_filmDarkTint            \"" + getdvar(getvar+"_filmTweakDarkTint") + "\"" );


			saved = closefile( file );
			assertex( (saved == 1), "File not saved (see above message?): " + visionFilename );
		}
		else
			dump = false;
			
			
		//sets the fog value
//		//tweak gets turned on the first time fog is enabled.
//		if(getDvarint( "scr_art_tweak" ) != 0)

		setExpFog(level.fognearplane, level.fogexphalfplane, level.fogred, level.foggreen, level.fogblue, 0);

		players = get_players();
		players[0] setDefaultDepthOfField();
		
		if(dump)
		{
			addstring = "maps\\createart\\"+level.script+"_art::main();";
			if(level.bScriptgened)
			{
				script_gen_dump_addline(addstring,level.script+"_art");  // adds to scriptgendump
				maps\_load::script_gen_dump();  //dump scriptgen link
			}
			else
				assertex(level.tweakfile, "remove all art setting in "+level.script+".gsc and add the following line before _load: "+addstring);
			setdvar("scr_art_dump","0");
 		}

		wait .1;
	
	}
	#/

}

tweakfog_fraction()
{
		fogfraction = getdvarfloat("scr_fog_fraction");
		if(fogfraction != level.fogfraction)
			level.fogfraction = fogfraction;
		else
			return;
			
		color = [];
		color[0] = getdvarfloat("scr_fog_red");
		color[1] = getdvarfloat("scr_fog_green");
		color[2] = getdvarfloat("scr_fog_blue");

		setdvar("scr_fog_fraction", 1);
		if(fogfraction < 0)
		{
			println("no negative numbers please.");
			return;
		}

		fc = [];
		larger = 1;
		for(i=0;i<color.size;i++)
		{
			fc[i] = fogfraction*color[i];
			if(fc[i] > larger)
				larger = fc[i];
		}

		if(larger > 1)
			for(i=0;i<fc.size;i++)
				fc[i] = fc[i]/larger;

		setdvar("scr_fog_red",fc[0]);
		setdvar("scr_fog_green",fc[1]);
		setdvar("scr_fog_blue",fc[2]);

}

cloudlight(sunlight_bright, sunlight_dark, diffuse_high, diffuse_low)
{
	level.sunlight_bright = sunlight_bright;
	level.sunlight_dark = sunlight_dark;
	level.diffuse_high = diffuse_high;
	level.diffuse_low = diffuse_low;

	setdvar("r_lighttweaksunlight", level.sunlight_dark);
	setdvar("r_lighttweakdiffusefraction", level.diffuse_low);
	direction = "up";

	for(;;)
	{
		sunlight = getdvarFloat("r_lighttweaksunlight");
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
	sunlight = getdvarFloat("r_lighttweaksunlight");
	//diffuse = getdvarFloat("r_lighttweakdiffusefraction");
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
		setdvar("r_lighttweaksunlight", sunlight);
		//iprintln("^6sunlight = ", sunlight);

		frac = (sunlight - level.sunlight_dark) / (level.sunlight_bright - level.sunlight_dark);
		diffuse = level.diffuse_high + (level.diffuse_low - level.diffuse_high) * frac;
		setdvar("r_lighttweakdiffusefraction", diffuse);
		//iprintln("^6diffuse = ", diffuse);

		wait freq;
	}
}

darken(target_sunlight, time, freq)
{
	//iprintln("Darkening sunlight to ", target_sunlight);
	sunlight = getdvarFloat("r_lighttweaksunlight");
	//diffuse = getdvarFloat("r_lighttweakdiffusefraction");
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
		setdvar("r_lighttweaksunlight", sunlight);
		//iprintln("^6sunlight = ", sunlight);

		frac = (sunlight - level.sunlight_dark) / (level.sunlight_bright - level.sunlight_dark);
		diffuse = level.diffuse_high + (level.diffuse_low - level.diffuse_high) * frac;
		setdvar("r_lighttweakdiffusefraction", diffuse);
		//iprintln("^6diffuse = ", diffuse);

		wait freq;
	}
}

scale( percent )
{
		frac = percent / 100;
		return (level.sunlight_dark + frac * (level.sunlight_bright - level.sunlight_dark)) - level.sunlight_dark;
}


adsDoF()
{
	level.dof = level.dofDefault;
	
	for ( ;; )
	{
		if ( getDvarInt( "scr_cinematic" ) )
			updateCinematicDoF();
		else if ( getDvarInt( "scr_dof_enable" ) && !getDvarInt( "scr_art_tweak" ) )
			updateDoF();
		else
		{
			players = get_players();
			players[0] setDefaultDepthOfField();
		}

		wait ( 0.05 );
	}
}


updateCinematicDoF()
{
	players = get_players();
	adsFrac = players[0] playerADS();
	if ( adsFrac == 1 && getDvarInt( "scr_cinematic_autofocus" ) )
	{
		traceDir = vectorNormalize( anglesToForward( players[0] getPlayerAngles() ) );
		trace = bulletTrace( players[0] getEye(), players[0] getEye() + vectorscale( traceDir, 100000 ), true, players[0] );
	
		enemies = getAIArray();
		nearEnd = 10000;
		farStart = -1;
		start_origin = players[0] getEye();
		start_angles = players[0] getPlayerAngles();
		bestDot = 0;
		bestFocalPoint = undefined;
		for ( index = 0; index < enemies.size; index++ )
		{
			end_origin = enemies[index].origin;
			normal = vectorNormalize( end_origin - start_origin );
			forward = anglestoforward( start_angles );
			dot = vectorDot( forward, normal );
	
			if ( dot > bestDot )
			{
				bestDot = dot;
				bestFocalPoint = enemies[index].origin;
			}
		}
		
		if ( bestDot < 0.923 )
		{
			scrDoF = distance( start_origin, trace["position"] );
//			scrDoF = getDvarInt( "scr_cinematic_doffocus" ) * 39;
		}
		else
		{
			scrDoF = distance( start_origin, bestFocalPoint );
		}

		changeDoFValue( "nearStart", 1, 200 );
		changeDoFValue( "nearEnd", scrDoF, 200 );
		changeDoFValue( "farStart", scrDoF + 196, 200 );
		changeDoFValue( "farEnd", (scrDoF + 196) * 2, 200 );
		changeDoFValue( "nearBlur", 5, 0.1 );
		changeDoFValue( "farBlur", 3, 0.1 );
	}
	else
	{
		scrDoF = getDvarInt( "scr_cinematic_doffocus" ) * 39;
		
		if ( level.curDoF != scrDoF )
		{
			changeDoFValue( "nearStart", 1, 100 );
			changeDoFValue( "nearEnd", scrDoF, 100 );
			changeDoFValue( "farStart", scrDoF + 196, 100 );
			changeDoFValue( "farEnd", (scrDoF + 196) * 2, 100 );
			changeDoFValue( "nearBlur", 5, 0.1 );
			changeDoFValue( "farBlur", 3, 0.1 );
		}
	}

	level.curDoF = (level.dof["farStart"] - level.dof["nearEnd"]) / 2;

	players[0] setDepthOfField( 
							level.dof["nearStart"], 
							level.dof["nearEnd"],
							level.dof["farStart"],
							level.dof["farEnd"],
							level.dof["nearBlur"],
							level.dof["farBlur"]
							);
}


updateDoF()
{
	players = get_players();
	if ( players[0] playerADS() == 0.0 )
	{
		players[0] setDefaultDepthOfField();
		return;
	}

	playerEye = players[0] getEye();
	playerAngles = players[0] getPlayerAngles();
	playerForward = vectorNormalize( anglesToForward( playerAngles ) );
	
	trace = bulletTrace( playerEye, playerEye + vectorscale( playerForward, 8192 ), true, players[0] );

	enemies = getAIArray( "axis" );
	nearEnd = 10000;
	farStart = -1;
	
	for ( index = 0; index < enemies.size; index++ )
	{
		enemyDir = vectorNormalize( enemies[index].origin - playerEye );
		
		dot = vectorDot( playerForward, enemyDir );
		if ( dot < 0.923 ) // 45 degrees
			continue;

		distFrom = distance( playerEye, enemies[index].origin );
		
		if ( distFrom - 30 < nearEnd )
			nearEnd = distFrom - 30;

		if ( distFrom + 30 > farStart )
			farStart = distFrom + 30;
	}

	if ( nearEnd > farStart )
	{
		nearEnd = 256;
		farStart = 2500;
	}
	else
	{
		if ( nearEnd < 50 )
			nearEnd = 50;
		else if ( nearEnd > 512 )
			nearEnd = 512;
		
		if ( farStart > 2500 )
			farStart = 2500;
		else if ( farStart < 1000 )
			farStart = 1000;
	}
	
	traceDist = distance( playerEye, trace["position"] );
	
	if ( nearEnd > traceDist )
		nearEnd = traceDist - 30;
		
	if ( nearEnd < 1 )
		nearEnd = 1;

	if ( farStart < traceDist )
		farSTart = traceDist;

	setDoFTarget( 1, nearEnd, farStart, farStart * 4, 5, 1.5 );
}

setDoFTarget( nearStart, nearEnd, farStart, farEnd, nearBlur, farBlur )
{
	players = get_players();
	adsFrac = players[0] playerADS();
	if ( adsFrac == 1 )
	{
		changeDoFValue( "nearStart", nearStart, 50 );
		changeDoFValue( "nearEnd", nearEnd, 50 );
		changeDoFValue( "farStart", farStart, 400 );
		changeDoFValue( "farEnd", farEnd, 400 );
		changeDoFValue( "nearBlur", nearBlur, 0.1 );
		changeDoFValue( "farBlur", farBlur, 0.1 );
	}
	else
	{
		lerpDoFValue( "nearStart", nearStart, adsFrac );
		lerpDoFValue( "nearEnd", nearEnd, adsFrac );
		lerpDoFValue( "farStart", farStart, adsFrac );
		lerpDoFValue( "farEnd", farEnd, adsFrac );
		lerpDoFValue( "nearBlur", nearBlur, adsFrac );
		lerpDoFValue( "farBlur", farBlur, adsFrac );
	}

	players[0] setDepthOfField( 
							level.dof["nearStart"], 
							level.dof["nearEnd"],
							level.dof["farStart"],
							level.dof["farEnd"],
							level.dof["nearBlur"],
							level.dof["farBlur"]
							);
}

changeDoFValue( valueName, targetValue, maxChange )
{
	if ( level.dof[valueName] > targetValue )
	{
		changeVal = (level.dof[valueName] - targetValue) * 0.5;
		if ( changeVal > maxChange )
			changeVal = maxChange;
		else if ( changeVal < 1 )
			changeVal = 1;
		
		if ( level.dof[valueName] - changeVal < targetValue )
			level.dof[valueName] = targetValue;
		else
			level.dof[valueName] -= changeVal;
	}
	else if ( level.dof[valueName] < targetValue )
	{
		changeVal = (targetValue - level.dof[valueName]) * 0.5;
		if ( changeVal > maxChange )
			changeVal = maxChange;
		else if ( changeVal < 1 )
			changeVal = 1;

		if ( level.dof[valueName] + changeVal > targetValue )
			level.dof[valueName] = targetValue;
		else
			level.dof[valueName] += changeVal;
	}
}

lerpDoFValue( valueName, targetValue, lerpAmount )
{
	level.dof[valueName] = level.dofDefault[valueName] + ((targetValue - level.dofDefault[valueName]) * lerpAmount) ;	
}

dofvarupdate()
{
		level.dofDefault["nearStart"] = getdvarint("scr_dof_nearStart");
		level.dofDefault["nearEnd"] = getdvarint("scr_dof_nearEnd");
		level.dofDefault["farStart"] = getdvarint("scr_dof_farStart");
		level.dofDefault["farEnd"] = getdvarint("scr_dof_farEnd");
		level.dofDefault["nearBlur"] = getdvarfloat("scr_dof_nearBlur");
		level.dofDefault["farBlur"] = getdvarfloat("scr_dof_farBlur");	
}

setdefaultdepthoffield()
{
		self setDepthOfField( 
								level.dofDefault["nearStart"], 
								level.dofDefault["nearEnd"],
								level.dofDefault["farStart"],
								level.dofDefault["farEnd"],
								level.dofDefault["nearBlur"],
								level.dofDefault["farBlur"]
								);
}


isDoFDefault()
{
	if ( level.dofDefault["nearStart"] != getDvarInt( "scr_dof_nearStart" ) )
		return false;

	if ( level.dofDefault["nearEnd"] != getDvarInt( "scr_dof_nearEnd" ) )
		return false;

	if ( level.dofDefault["farStart"] != getDvarInt( "scr_dof_farStart" ) )
		return false;

	if ( level.dofDefault["farEnd"] != getDvarInt( "scr_dof_farEnd" ) )
		return false;

	if ( level.dofDefault["nearBlur"] != getDvarInt( "scr_dof_nearBlur" ) )
		return false;

	if ( level.dofDefault["farBlur"] != getDvarInt( "scr_dof_farBlur" ) )
		return false;
		
	return true;
}

dvarsets()
{
	/#
/*	if(getdvar("visionstore_glowTweakEnable") != "")
	{
		setsaveddvar("r_glowTweakEnable",getdvar("visionstore_glowTweakEnable"));
		setsaveddvar("r_glowTweakRadius0",getdvar("visionstore_glowTweakRadius0"));
		setsaveddvar("r_glowTweakEnable",getdvar("visionstore_glowTweakRadius1"));
		setsaveddvar("r_glowTweakBloomCutoff",getdvar("visionstore_glowTweakBloomCutoff"));
		setsaveddvar("r_glowTweakBloomDesaturation",getdvar("visionstore_glowTweakBloomDesaturation"));
		setsaveddvar("r_glowTweakEnable",getdvar("visionstore_glowTweakBloomIntensity0"));
		setsaveddvar("r_glowTweakEnable",getdvar("visionstore_glowTweakBloomIntensity1"));
	}
*/
		
	if(getdvar("visionstore_filmTweakEnable") != "")
	{
		setsaveddvar("r_filmTweakEnable",getdvar("visionstore_filmTweakEnable"));
		setsaveddvar("r_filmTweakContrast",getdvar("visionstore_filmTweakContrast"));
		setsaveddvar("r_filmTweakBrightness",getdvar("visionstore_filmTweakBrightness"));
		setsaveddvar("r_filmTweakDesaturation",getdvar("visionstore_filmTweakDesaturation"));
		setsaveddvar("r_filmTweakInvert",getdvar("visionstore_filmTweakInvert"));
		setsaveddvar("r_filmTweakLightTint",getdvar("visionstore_filmTweakLightTint"));
		setsaveddvar("r_filmTweakDarkTint",getdvar("visionstore_filmTweakDarkTint"));
	}
	#/
	
}
