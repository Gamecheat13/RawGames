#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;

/*
	_lighting.gsc
	
	Script file used for common lighting scripting utilities and settings.
	
	/////////////////////////////////////////////////////////////////////////////
	/INCLUDED
	/////////////////////////////////////////////////////////////////////////////
	SCREEN EFFECT BASE (YOU CAN DO BLOOD OR DIR OR ANY OTHER SCREEN EFFECT WITH THIS BASE)
	BLOOD SIMPLE SCREEN
	DIRT SIMPLE SCREEN
	GASMASK OVERLAY
	FLICKERING LIGHT
	FLICKERING MODEL / LIGHT / FX
	DOF	
	DEPTH OF FIELD VIEW MODEL
	SPOT INTENSITY LERP
	
	/////////////////////////////////////////////////////////////////////////////
	//NOT INCLUDED  more in wb_lighting_scripting.map or _shg_fx
	/////////////////////////////////////////////////////////////////////////////
	WATER SHEET SCREEN  	level.player SetWaterSheeting( 1, 5.5 );
	BLUR					setblur(0, 1);	
	EARTHQUAKE			    Earthquake( 0.2, 3.0, level.player.origin, 1600 );
	SCREENSHAKE				thread screenshake( .2, 13, 1, 5);   #include maps\_shg_fx;
	
	COLORCHANGE				light = GetEnt( "colorchange_light", "targetname" );
							light thread maps\_lights::changeLightColorTo( ( 0.000000, 0.00000, 1.0000 ), 2, .005, .15 );
	
	NIGHT VISION OVERLAY	VisionSetNight("fusion_helicopter_ar", .5);
							level.player NightVisionGogglesForceOn();
							level.player NightVisionGogglesForceOff();
	/////////////////////////////////////////////////////////////////////////////
	
*/
light_init()
{
	if ( !IsDefined( level._light ) )
	{
		level._light = spawnstruct();
		light_setup_global_dvars();
		light_setup_common_dof_presets();
		light_setup_common_dof_viewmodel_presets();
		light_setup_common_flickerLight_presets();
		light_setup_pulse_presets();
		//light_setup_common_screen_material_presets();
		light_message_init();
	}
}

light_setup_global_dvars()
{
	if ( IsUsingHDR() )
	{
		//global veil settings
		setsaveddvar("r_veil", 1);
		setsaveddvar("r_veilStrength", .087);
		
		//global tonemap filimc curve tweaks
		setSavedDvar("r_tonemap", 2);
		setSavedDvar("r_tonemapBlack", 0.0);
		setSavedDvar("r_tonemapCrossover", 1.0);
		setSavedDvar("r_tonemapHighlightRange", 16.0);
		setSavedDvar("r_tonemapKeyDark", .02);
		setSavedDvar("r_tonemapKeyDarkLum", 1.0);
		setSavedDvar("r_tonemapKeyLight", 0.5);
		setSavedDvar("r_tonemapKeyLightLum", 1000);
		setSavedDvar("r_tonemapKeyMax", 0.9);
		setSavedDvar("r_tonemapKeyMin", 0.02);
		setSavedDvar("r_tonemapShoulder", 0.94);
		setSavedDvar("r_tonemapToe", 0.0);
		setSavedDvar("r_tonemapWhite", 512);
		
		//global tonemap settings for dynamic luminance and exposure calculation
		if( !level.ps3 ) // temp hack until current gen auto-exposure is implemented on ps3
		{
			setSavedDvar("r_tonemApadaptSpeed", .02 );
			setSavedDvar("r_tonemapKey", 0.0);
			setSavedDvar("r_tonemapExposure", -10.0);
			setSavedDvar("r_tonemapMaxExposure", -10.0);
		}
				
		//global particle hdr
		setsaveddvar("r_particleHdr", 1);
	}
	if ( IsUsingSSAO() )
	{
		setSavedDvar("r_ssaoPower", 12.0);
		setSavedDvar("r_ssaoStrength", .45);
		setsavedDvar("r_ssaominstrengthdepth", 25.0);
		setsavedDvar("r_ssaomaxstrengthdepth", 40.0);
	}
}
///////////////////////////////////////////////////////
// Screen Effect Base
///////////////////////////////////////////////////////

//level.player delaythread(0, ::screen_effect_base_2,material, (999), .5, .5, 1);

/*
=============
///ScriptDocBegin
"Name: screen_effect_base( <time> , <materials> , <fadein_> , <fadeout_> , <max_alpha_> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <time>: "
"MandatoryArg: <materials>: either a single material name, or an array of materials."
"MandatoryArg: <fadein_>: "
"MandatoryArg: <fadeout_>: "
"MandatoryArg: <max_alpha_>: "
"Example:  		level.player thread screen_effect_base(5, "fullscreen_bloodsplat_bottom", .5, .5, 1, -50, 50);"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
screen_effect_base(time, materials, fadein_, fadeout_, max_alpha_, xpos, ypos )
{
	// write some code here to "validate" the required params
	assert(IsDefined(time));
	level endon("end_screen_effect");
	
	overlay = NewClientHudElem( level.player );
	overlay.x = 0;
	overlay.y = 0;
	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = max_alpha_;
	
	if (IsDefined(xpos))
	{
		overlay.x = xpos;
	}
	if (IsDefined(ypos))
	{
		overlay.y = ypos;
	}	

	// "materials" is an array of material
	if(IsArray(materials))
	{
		/*
		// optional way to go if you want to define a size per material... could also go with material "structs" in the array
		// screen_effect_base_2(10, ["material", "material2", 300, 200], .. );
		for (i = 0; i < materials.size;)
		{
			materialName = materials[i];
			materialW = 640;
			materialH = 480;
			assert(IsString(materialName));
			if (IsDefined(materials[i + 1]) && !IsString(materials[i + 1]))
			{
				materialW = materials[i + 1];
				materialH = materials[i + 2];
				i = i + 3;
			}
			else
			{
				i = i + 1;
			}
			
			overlay SetShader(materialName, materialW, materialH);			
		}
		*/

		foreach (material in materials)
		{
			assert(IsString(material));
			overlay SetShader(material, 640, 480);
		}
	}
	else
	{
		// "materials" is a single material
		assert(IsString(materials));
		overlay SetShader(materials, 640, 480);		
	}
	if (time > 0)
	{
		overlay.alpha = 0;
		fadein = 1;
		if (IsDefined(fadein_))
		{
			assert(fadein_ >= 0);
			fadein = fadein_;
		}
		
		fadeout = 1;
		if (IsDefined(fadeout_))
		{
			assert(fadeout_ >= 0);
			fadeout = fadeout_;
		}
		
		max_alpha = 1;	
		if (IsDefined(max_alpha_))
		{
			assert(max_alpha_ >= 0);
			max_alpha = clamp(max_alpha_, 0.0, 1.0);
		}
	
		//fade up
		step_time = 0.05;
		
		if ( fadein > 0 )
		{
			current_alpha = 0;
			increment_alpha = max_alpha / (fadein/step_time); 
			AssertEx( increment_alpha > 0, "alpha not increasing; infinite loop" );
			while ( current_alpha < max_alpha )
			{
				overlay.alpha = current_alpha;
				current_alpha = current_alpha + increment_alpha;
				wait step_time;  //wait one frame
		}
		}
		
		overlay.alpha = max_alpha;
		
		wait(time - (fadein + fadeout));
	
		//fade down
		if ( fadeout > 0 )
		{
			current_alpha = max_alpha;
			decrement_alpha = max_alpha / (fadeout/step_time);
			AssertEx( decrement_alpha > 0, "alpha not decreasing; infinite loop" );
			while ( current_alpha > 0 )
			{
				overlay.alpha = current_alpha;
				current_alpha = current_alpha - decrement_alpha;
				wait step_time;
			}
		}
		
		overlay.alpha = 0;
		overlay destroy();
	}
		return overlay;
}

///////////////////////////////////////////////////////
// Blood Screen Simple
///////////////////////////////////////////////////////

//thread blood_screen();
/*
=============
///ScriptDocBegin
"Name: blood_splatter_simple()"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"Example: thread blood_splatter_simple();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

blood_splatter_simple()
{
	overlay = NewClientHudElem(level.player);
	overlay.x = 0;
	overlay.y = 0;
	overlay SetShader( "fullscreen_bloodsplat_bottom", 640, 480 );//"splatter_alt_sp"
	overlay SetShader( "fullscreen_bloodsplat_left", 640, 480 );//"splatter_alt_sp"
	overlay SetShader( "fullscreen_bloodsplat_right", 640, 480 );//"splatter_alt_sp"
	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;
	overlay FadeOverTime( 3 );
	overlay.alpha = 0;
}

///////////////////////////////////////////////////////
// Dirt Screen Simple
///////////////////////////////////////////////////////
dirt_splatter_simple()
{
	overlay = NewClientHudElem(level.player);
	overlay.x = 0;
	overlay.y = 0;
	overlay SetShader( "fullscreen_dirt_bottom", 640, 480 );//"splatter_alt_sp"
	overlay SetShader( "fullscreen_dirt_bottom_b", 640, 480 );//"splatter_alt_sp"
	overlay SetShader( "fullscreen_dirt_left", 640, 480 );//"splatter_alt_sp"
	overlay SetShader( "fullscreen_dirt_right", 640, 480 );//"splatter_alt_sp"
	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;
	overlay FadeOverTime( 3 );
	overlay.alpha = 0;
}
///////////////////////////////////////////////////////
// Gasmask Overlay
///////////////////////////////////////////////////////
//CSV
//materials
//material,gasmask_overlay_delta2
//GSC	
//PrecacheShader( "gasmask_overlay_delta2_top" );
//PrecacheShader( "gasmask_overlay_delta2_bottom" );
//level.player thread gasmask_on_player(false);

bob_mask( hudElement )
{
	self endon( "stop_mask_bob" );

	weapIdleTime = 0;
	previousAngles = level.player GetPlayerAngles();
	offsetY = 0;	// for vertical changes. eg. jumping
	offsetX = 0;	// for turning left/right
	
	addYoffset = hudElement.y;
	addXoffset = hudElement.x;
	
	frameTime = 0.05;
	while (1)
	{
		if ( IsDefined( hudElement ) )
		{
			angles = level.player GetPlayerAngles();
			velocity = level.player GetVelocity();
			zVelocity = velocity[2];
			velocity = velocity - velocity * ( 0, 0, 1 ); // zero out z velocity ( up/down velocity )
			speedXY = Length( velocity );
			stance = level.player GetStance();

			// speedScale goes from 0 to 1 as speed goes between 0 and full sprint
			speedScale = clamp( speedXY, 0, 280 ) / 280;
			// bobXFraction and bobXFraction control the amount of the maximum xy displacement that is allocated to the bob motion.
			// The remainder goes to the xy offset due to turn and z velocity.
			// As speed increases more displacement goes to bob and less to the xy offset due to turn and z velocity.
			bobXFraction = 0.1 + speedScale * 0.25;
			bobYFraction = 0.1 + speedScale * 0.25;

			// bobScale controls the amount of bob displacement based on stance
			bobScale = 1.0;	// default
			if ( stance == "crouch" )	bobScale = 0.75;
			if ( stance == "prone" )	bobScale = 0.4;
			if ( stance == "stand" )	bobScale = 1.0;

			// bobSpeed controls the frequency of the bob cycle
			idleSpeed = 5.0;
			ADSSpeed = 0.9;
			playerADS = level.player playerADS();
			// lerp bobSpeed between idleSpeed and ADSSpeed
			bobSpeed = idleSpeed * ( 1.0 - playerADS ) + ADSSpeed * playerADS;
			bobSpeed = bobSpeed * ( 1 + speedScale * 2 );

			maxXYDisplacement = 5;	// corresponds to 650 by 490 in the hud elem SetShader()
			bobAmplitudeX = maxXYDisplacement * bobXFraction * bobScale;
			bobAmplitudeY = maxXYDisplacement * bobYFraction * bobScale;

			// control the bob motion in the same pattern as the viewmodel bob - through it will not be in phase
			weapIdleTime = weapIdleTime + frameTime * 1000.0 * bobSpeed;
			rad_to_deg = 57.295779513; // radians to degrees
			 // the constants 0.001 and 0.0007 match those in BG_ComputeAndApplyWeaponMovement_IdleAngles()
			verticalBob   = sin( weapIdleTime * 0.001  * rad_to_deg );
			horizontalBob = sin( weapIdleTime * 0.0007 * rad_to_deg );

			// calculate some x offset based on player turning
			angleDiffYaw = AngleClamp180( angles[ 1 ] - previousAngles[ 1 ] );
			angleDiffYaw = clamp( angleDiffYaw, -10, 10 );
			offsetXTarget = ( angleDiffYaw / 10 ) * maxXYDisplacement * ( 1 - bobXFraction );
			offsetXChange = offsetXTarget - offsetX;
			offsetX = offsetX + clamp( offsetXChange, -1.0, 1.0 );

			// calculate some y offset based on vertical velocity
			offsetYTarget = ( clamp( zVelocity, -200, 200 ) / 200 ) * maxXYDisplacement * ( 1 - bobYFraction );
			offsetYChange = offsetYTarget - offsetY;
			offsetY = offsetY + clamp( offsetYChange, -0.6, 0.6 );
			
			hudElement MoveOverTime( 0.05 );
			hudElement.x = addXoffset + clamp( ( verticalBob   * bobAmplitudeX + offsetX - maxXYDisplacement ), ( 0 - 2 * maxXYDisplacement ), 0 );
			hudElement.y = addYoffset + clamp( ( horizontalBob * bobAmplitudeY + offsetY - maxXYDisplacement ), ( 0 - 2 * maxXYDisplacement ), 0 );
			previousAngles = angles;
			
			// /# debug_print("hud " + hudElement.x + ", " + hudElement.y); #/
		}
		wait frameTime;
	}
}
/*
=============
///ScriptDocBegin
"Name: gasmask_on_player( <bFadeIn> , <fadeOutTime> , <fadeInTime> , <darkTime> )"
"Summary: //CSV//material,gasmask_overlay_delta2, material,gasmask_overlay_delta2_bottom, material,gasmask_overlay_delta2_top//GSC//PrecacheShader( "gasmask_overlay_delta2_top" );, PrecacheShader( "gasmask_overlay_delta2_bottom" );"
"Module: Entity"
"CallOn: player"
"MandatoryArg: <bFadeIn>: "
"MandatoryArg: <fadeOutTime>: "
"MandatoryArg: <fadeInTime>: "
"MandatoryArg: <darkTime>: "
"Example: level.player thread gasmask_on_player(false);"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

gasmask_on_player(bFadeIn, fadeOutTime, fadeInTime, darkTime)
{
	Assert(IsPlayer(self));	
	
	if(!IsDefined(bFadeIn)) bFadeIn = true;
	if(!IsDefined(fadeOutTime)) fadeOutTime = 0;
	if(!IsDefined(fadeInTime)) fadeInTime = 1;
	if(!IsDefined(darkTime)) darkTime = .25;
	
	if(bFadeIn)
	{
		fade_out( fadeOutTime );
	}
	
	SetHUDLighting( true );

	// originally this was one fullscreen element with coordinates of 0,0, and size 650x490, and the bob_mask()
	// thread will generally move the coordinates to -5, -5, plus or minus 5 units based on sway.
	// We've broken it in half, and changed bob_mask() to take the initial coordinates into account.
	// Anyway, the position and size must be such that the coordinates can move between -10 and 0 from their inital value in each coordinate.
	
	self.gasmask_hud_elem = NewClientHudElem( self ); 
	self.gasmask_hud_elem.x = 0;
	self.gasmask_hud_elem.y = 0;
	self.gasmask_hud_elem.horzAlign = "fullscreen";
	self.gasmask_hud_elem.vertAlign = "fullscreen";
	self.gasmask_hud_elem.foreground = false;
	self.gasmask_hud_elem.sort = -1; // trying to be behind introscreen_generic_black_fade_in	
	self.gasmask_hud_elem SetShader("gasmask_overlay_delta2_top", 650, 138);
	self.gasmask_hud_elem.alpha = 1.0;
	
	self.gasmask_hud_elem1 = NewClientHudElem( self ); 
	self.gasmask_hud_elem1.x = 0;
	self.gasmask_hud_elem1.y = 490 - 138;
	self.gasmask_hud_elem1.horzAlign = "fullscreen";
	self.gasmask_hud_elem1.vertAlign = "fullscreen";
	self.gasmask_hud_elem1.foreground = false;
	self.gasmask_hud_elem1.sort = -1; // trying to be behind introscreen_generic_black_fade_in	
	self.gasmask_hud_elem1 SetShader("gasmask_overlay_delta2_bottom", 650, 138);
	self.gasmask_hud_elem1.alpha = 1.0;

	level.player delaythread( 1.0, ::gasmask_breathing );
	//vision_set_fog_changes( "paris_gasmask", .5 );

	thread bob_mask( self.gasmask_hud_elem );
	thread bob_mask( self.gasmask_hud_elem1 );
		
	if(bFadeIn)
	{
		wait( darkTime );
		fade_in( fadeInTime );
	}
}
	
/*
=============
///ScriptDocBegin
"Name: gasmask_off_player()"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"Example: level.player thread gasmask_off_player();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

gasmask_off_player()
{
	Assert(IsPlayer(self));	
	
	fade_out( 0.25 );

	self notify( "stop_mask_bob" );

	if(IsDefined(self.gasmask_hud_elem))
	{
		self.gasmask_hud_elem Destroy();	
		self.gasmask_hud_elem = undefined;
	}

	if(IsDefined(self.gasmask_hud_elem1))
	{
		self.gasmask_hud_elem1 Destroy();	
		self.gasmask_hud_elem1 = undefined;
	}


	SetHUDLighting( false );

	//vision_set_fog_changes( "paris_catacombs", 0 );
	level.player notify( "stop_breathing" ); 
	wait( 0.25 );
	fade_in( 1.5 );
}	

gasmask_breathing()
{
	delay = 1.0;
	self endon( "stop_breathing" );
	
	while ( 1 )
	{
		self play_sound_on_entity( "breathing_gasmask" );
		wait( delay );
	}
}

gasmask_on_npc()
{
	self.gasmask = Spawn("script_model", (0, 0, 0));
	self.gasmask SetModel("prop_sas_gasmask");
	self.gasmask LinkTo(self, "tag_eye", (-4, 0, 2), (120, 0, 0));
}

gasmask_off_npc()
{
	if(IsDefined(self.gasmask))
		self.gasmask Delete();
}
	
///////////////////////////////////////////////////////
// Night Vision Overlay
///////////////////////////////////////////////////////
//CSV
//material,nightvision_overlay_goggles
//GSC
//PrecacheNightvisionCodeAssets();
//FX GSC
//VisionSetNight("fusion_helicopter_ar", .5);
//level.player NightVisionGogglesForceOn();
//level.player NightVisionGogglesForceOff();

///////////////////////////////////////////////////////
// FLICKERING LIGHT Code
///////////////////////////////////////////////////////

light_setup_common_flickerLight_presets()
{		
	//name										color0								color1										minDelay		maxDelay	intensity
	create_flickerLight_preset("fire", 			( 0.972549, 0.624510, 0.345098 ),	 ( .2, 0.1462746, 0.0878432 ), 				.005, 			.2,			8 );
	create_flickerLight_preset("pulse", 		( 0, 0, 0 ),						 ( 255, 107, 107 ),			 				.2, 			1,			8 );
	create_flickerLight_preset("lightbulb", 	( 0.972549, 0.624510, 0.345098 ),	 ( .2, 0.1462746, 0.0878432 ), 				.005, 			.2,			6 );
	create_flickerLight_preset("fluorescent", 	( 0.972549, 0.624510, 0.345098 ),	 ( .2, 0.1462746, 0.0878432 ), 				.005, 			.2,			7 );
	create_flickerLight_preset("static_screen",	( 0.63, 0.72, 0.92 ),	 			 ( .40, 0.43, 0.48 ), 						.005, 			.2,			7 );
}	

/*
=============
///ScriptDocBegin
"Name: create_flickerLight_preset( <name> , <color0> , <color1> , <minDelay> , <maxDelay> , <intensity> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <name>: "
"MandatoryArg: <color0>: "
"MandatoryArg: <color1>: "
"MandatoryArg: <minDelay>: "
"MandatoryArg: <maxDelay>: "
"MandatoryArg: <intensity>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

create_flickerLight_preset(name, color0, color1, minDelay, maxDelay, intensity)
{
	if (!IsDefined(level._light.flicker_presets))
	{
		level._light.flicker_presets = [];
	}
	
	new_preset = spawnstruct();
	new_preset.color0 = color0;
	new_preset.color1 = color1;
	new_preset.minDelay = minDelay;
	new_preset.maxDelay = maxDelay;
	new_preset.intensity = intensity;
	
	level._light.flicker_presets[name] = new_preset;
	
//	dyn_flickerLight(name, color0, color1, minDelay, maxDelay);
}

get_flickerLight_preset(name)
{
	if (IsDefined(level._light.flicker_presets) && IsDefined(level._light.flicker_presets[name]))
	{
		return level._light.flicker_presets[name];
	}
	return undefined;
}


/*
=============
///ScriptDocBegin
"Name: play_flickerLight_preset( <name> , <targetName>, <intensity_> )"
"Summary: Plays a flickering light preset (defined with create_flickerLight_preset)"
"Module: Lighting"
"CallOn: Nothing"
"MandatoryArg: <name>: the name of the preset"
"MandatoryArg: <targetName>: the targetname of the entity type"
"OptionalArg: <intensity_>: optionally override the intensity parameter of the preset"
"Example: ent play_flickerLight_preset("fire", "fire_flicker", 4); or play_flickerLight_preset("fire", "fire_flicker");"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
play_flickerLight_preset(name, targetName, intensity_)
{
	assert(IsString(name));
	assert(IsString(targetName));
	
	ent = GetEnt( targetName, "targetname" );
	if( !IsDefined( ent ) )
	{
		println("Error Light Scripts: play_flickerLight_preset with name, \"" + name + "\", was called on a non-existant targetName, \"" + targetName + "\".");
		return;
	}
	
	preset = get_flickerLight_preset(name);
	if (!IsDefined(preset))
	{
		PrintLn("Error Light Scripts: flickerLight preset " + name + " is not defined. Please define before calling it with play_flickerLight_preset.");
		return;
	}
	
	if (IsDefined(intensity_))
	{
		if (intensity_ < 0)
		{
			PrintLn("Warning: flickerLight preset " + name + " is playing with an intensity override less than zero. Truncating.");
			intensity_ = 0;
		}
			
		preset.intensity = intensity_;
	}
	
	ent SetLightIntensity( preset.intensity );

	ent.isLightFlickering = true;
	ent.isLightFlickerPaused = false;
	
	ent thread dyn_flickerLight( preset.color0, preset.color1, preset.minDelay, preset.MaxDelay );
	
	return ent;	
}


/*
=============
///ScriptDocBegin
"Name: stop_flickerLight( <name> , <targetName> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <name>: "
"MandatoryArg: <targetName>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
stop_flickerLight(name, targetName, intensity_)
{
	ent = GetEnt( targetName, "targetname" );

	if(!IsDefined(ent))
	{
		println("Error Light Scripts: stop_flickerLight, \"" + name + "\", was called on a non-existant targetName, \"" + targetName + "\".");
		return;
	}
		
	if (!IsDefined(ent.isLightFlickering))
	{
		println("Error Light Scripts: stop_flickerLight was called on a flickering light but flickering light isn't flickering.");
		return;		
	}	
	if (IsDefined(intensity_))
	{
		if (intensity_ < 0)
		{
			PrintLn("Warning: flickerLight preset " + name + " is playing with an intensity override less than zero. Truncating.");
			intensity_ = 0;
		}
	}
	
	ent SetLightIntensity( intensity_ );
	
	ent notify("kill_flicker");
	ent.isLightFlickering = undefined;
}


/*
=============
///ScriptDocBegin
"Name: pause_flickerLight( <name> , <targetName> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <name>: "
"MandatoryArg: <targetName>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

pause_flickerLight(name, targetName)
{
	ent = GetEnt( targetName, "targetname" );

	if(!IsDefined(ent))
	{
		println("Error Light Scripts: pause_flickerLight, \"" + name + "\", was called on a non-existant targetName, \"" + targetName + "\".");
		return;
	}
	
	if (!IsDefined(ent.isLightFlickering))
	{
		println("Error Light Scripts: pause_flickerLight was called on a flickering light but flickering light isn't flickering.");
		return;		
	}
	
	ent.isLightFlickerPaused = true;
}

/*
=============
///ScriptDocBegin
"Name: unpause_flickerLight( <name> , <targetName> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <name>: "
"MandatoryArg: <targetName>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

unpause_flickerLight(name, targetName)
{
	ent = GetEnt( targetName, "targetname" );

	if(!IsDefined(ent))
	{
		println("Error Light Scripts: unpause_flickerLight, \"" + name + "\", was called on a non-existant targetName, \"" + targetName + "\".");
		return;
	}
	
	if (!IsDefined(ent.isLightFlickering))
	{
		println("Error Light Scripts: pause_flickerLight was called on a flickering light but flickering light isn't flickering.");
		return;		
	}

	ent.isLightFlickerPaused = false;
}

///the code below is mostly old and might need updating...

dyn_flickerLight( color0, color1, minDelay, maxDelay )
{
	assert(IsDefined(self.isLightFlickering));
	assert(IsDefined(self.isLightFlickerPaused));
	
	self endon("kill_flicker");
	toColor = color0;
	delay = 0.0;

	for ( ;; )
	{
		if (self.isLightFlickerPaused)
		{
			wait 0.05;
		}
		else
		{
			fromColor = toColor;
			toColor = color0 + ( color1 - color0 ) * randomfloat( 1.0 );
	
			if ( minDelay != maxDelay )
				delay += randomfloatrange( minDelay, maxDelay );
			else
				delay += minDelay;
			
			if(delay==0) delay+=.0000001;//Prevent divide by zero
			colorDeltaPerTime = ( fromColor - toColor ) * ( 1 / delay );
			while ( (delay > 0) && !self.isLightFlickerPaused )
			{
				self setLightColor( toColor + colorDeltaPerTime * delay );
				wait 0.05;
				delay -= 0.05;
			}
		}
	}
}
///////////////////////////////////////////////////////
// SPOT INTENSITY LERP
///////////////////////////////////////////////////////

lerp_spot_intensity(targetname, time, endintensity)
{
	ent = GetEnt( targetName, "targetname" );
	startintensity = ent GetLightIntensity();
	ent.endintensity = endintensity;
	
	t = 0;
	
	while (t < time)
	{
		new_intensity = startintensity + (endintensity - startintensity) * (t/time);
		t += 0.05;
		ent setLightIntensity( new_intensity );
		wait 0.05;
	}
	ent setLightIntensity(endintensity);
}	
	
///////////////////////////////////////////////////////
// PULSE LIGHT
///////////////////////////////////////////////////////
light_setup_pulse_presets()
{		
							//name    			transition_on		transition_off		intensity     color				num
	create_pulseLight_preset("red",    			.1, 				.1,					10000,        ( 1, .2, .2 ),	2	 );
}	
create_pulseLight_preset(name, transition_on, transition_off, intensity, color01, num)
{
	if (!IsDefined(level._light.pulse_presets))
	{
		level._light.pulse_presets = [];
	}
	
	new_preset = spawnstruct();
	new_preset.transition_on = transition_on;
	new_preset.transition_off = transition_off;
	new_preset.intensity = intensity;
	new_preset.color01 = color01;
	new_preset.num = num;
	
	level._light.pulse_presets[name] = new_preset;
}

get_pulseLight_preset(name)
{
	if (IsDefined(level._light.pulse_presets) && IsDefined(level._light.pulse_presets[name]))
	{
		return level._light.pulse_presets[name];
	}
	return undefined;
}

play_pulse_preset(name, targetName, intensity_, fxid1)
{
	assert(IsString(name));
	assert(IsString(targetName));
	notify_string = name+targetname+"_pulse";
	level notify( notify_string );
	level endon( notify_string );
	
	ent = GetEnt( targetName, "targetname" );
	if( !IsDefined( ent ) )
	{
		println("Error Light Scripts: play_pulseLight_preset with name, \"" + name + "\", was called on a non-existant targetName, \"" + targetName + "\".");
		return;
	}
	
	preset = get_pulseLight_preset(name);
	if (!IsDefined(preset))
	{
		PrintLn("Error Light Scripts: pulseLight preset " + name + " is not defined. Please define before calling it with play_pulseLight_preset.");
		return;
	}
	
	if (IsDefined(intensity_))
	{
		if (intensity_ < 0)
		{
			PrintLn("Warning: pulseLight preset " + name + " is playing with an intensity override less than zero. Truncating.");
			intensity_ = 0;
		}
			
		preset.intensity = intensity_;
	}
	
	ent SetLightIntensity( preset.intensity );
	ent setLightColor( preset.color01 );
	num = preset.num;
	
	on = ent getLightIntensity();
	off = .05;
	curr = on;
	transition_on = preset.transition_on;
	transition_off = preset.transition_off;
	increment_on = ( on - off ) / ( transition_on / .05 );
	increment_off = ( on - off ) / ( transition_off / .05 );
	numcurr = preset.num;

	for ( ;; )
	{
		//ramp down
		numcount = 1;
		time = 0;
		while (  time < transition_off )
		{
			curr -= increment_off;
			curr = clamp( curr, 0, 300000 );
			ent setLightIntensity( curr );
			time += .05;
			wait( .05 );
		}
		
    	if( IsDefined( fxid1 ) )
		{
		   	stop_exploder(fxid1);
		}
    	
		//off wait time
		wait( .8 );
		
		//ramp up
		time = 0;
		while ( time < transition_on )
		{
			curr += increment_on;
			curr = clamp( curr, 0, 300000 );
			ent setLightIntensity( curr );
			time += .05;
			wait( .05 );
		}
		
		if( IsDefined( fxid1 ) )
		{
		   	exploder(fxid1);
		}
		
		//on wait time
		wait( .1 );	
		
		while ( numcount < numcurr )
		{
		//ramp down
		time = 0;
		while (  time < transition_off )
		{
			curr -= increment_off;
			curr = clamp( curr, 0, 300000 );
			ent setLightIntensity( curr );
			time += .05;
			wait( .05 );
		}

		//off wait time
		wait( .1 );
		
		//ramp up
		time = 0;
		while ( time < transition_on )
		{
			curr += increment_on;
			curr = clamp( curr, 0, 300000 );
			ent setLightIntensity( curr );
			time += .05;
			wait( .05 );
		}
		//on wait time
		wait( .1 );	
		numcount += 1;		
		}
	
	}
	return ent;
}
///////////////////////////////////////////////////////
// FLICKERING MODEL / LIGHT
///////////////////////////////////////////////////////
/*
=============
///ScriptDocBegin
"Name: model_flicker_preset( <script_noteworthy> , <number_of_flickers> , <fxid1> , <fxid2> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <script_noteworthy>: "
"MandatoryArg: <number_of_flickers>: "
"MandatoryArg: <fxid1>: "
"MandatoryArg: <fxid2>: "
"Example: 		thread model_flicker_preset("light_flicker_test", 7, 1667, 1668);"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
model_flicker_preset(script_noteworthy, number_of_flickers, intensity_, fxid1, fxid2, minDelay, maxDelay )
{
	assert(IsString(script_noteworthy));
	
	ents = GetEntArray( script_noteworthy, "script_noteworthy" );
	
	if( !IsDefined( ents ) )
	{
		println("please define a script_noteworthy");
		return;
	}
	
	lightents = [];
	modelents = [];
	
	foreach (ent in ents)
	{
		if ( ent.classname == "script_model" )
    	{
			modelents[modelents.size] = ent;
    	}
    	if ( ent.classname == "light_spot" )
    	{
			lightents[lightents.size] = ent;
			ent SetLightIntensity( intensity_ );
    	}
	}
	
	self endon( "death" );
    flicker_count = 0;
    
    if( IsDefined( fxid1 ) )
		{
		   	exploder(fxid1);
		}    
   
    while (flicker_count < number_of_flickers || number_of_flickers == 0)
    {
		on = undefined;
    	off = .05; 	
    	delay = 0.0;
    	
    	if( isdefined( minDelay) && isdefined( maxDelay) )
		{
    			time_between_flicker = RandomFloatRange( minDelay, maxDelay);
    	}
    	else
    	{
    		time_between_flicker = RandomFloatRange( .1, .8);
		} 
    	if( IsDefined( fxid2 ) )
		{
		   	stop_exploder(fxid2);
		}
    	
		foreach (model01 in modelents)
			{
 	 			model01 Hide();
			}
		
 	  	foreach (light in lightents)
			{
 	  		on = light getLightIntensity();
 	  		light setLightIntensity( off );
			}
    	
 	  	wait time_between_flicker;
 	  	
    	if( IsDefined( fxid2 ) )
		{
		   	exploder(fxid2);
		}
    	
 	  	foreach (model01 in modelents)
			{
 	 			model01 Show();
			}	
 	  	foreach (light in lightents)
			{
 	  		light setLightIntensity( on );
			}		 	  	
 	  	
 	  	wait time_between_flicker;
		
 	  	if(number_of_flickers != 0)
 	  	{
 	  		flicker_count++;
 	  	}
    }
}
///////////////////////////////////////////////////////
// Depth of Field Script Code
///////////////////////////////////////////////////////
light_setup_common_dof_presets()
{	
	//					name					nStart	nEnd	nBlur	fStart	fEnd	fBlur	fBias
	create_dof_preset("default", 				1, 		1, 		4.5, 	500, 	500, 	0.05,	0.5);
	create_dof_preset("viewmodel_blur", 		1, 		1, 		4.5, 	500, 	500, 	0.05,	0.5);
	create_dof_preset("river", 			1, 		104, 	4.5, 	500, 	500, 	1.8,	0.5);
}

create_dof_preset(name, nStart,	nEnd, nBlur, fStart, fEnd, fBlur, fBias)
{
	if (!IsDefined(level._light.dof_presets))
		level._light.dof_presets = [];
	
	new_dof = [];
	new_dof["nearStart"] 	= nStart;
	new_dof["nearEnd"] 		= nEnd;
	new_dof["nearBlur"] 	= nBlur;
	new_dof["farStart"] 	= fStart;
	new_dof["farEnd"] 		= fEnd;
	new_dof["farBlur"] 		= fBlur;
	new_dof["bias"]			= fBias;
	//new_dof["start"]		= start;
//	new_dof["end"]			= end;
		
//	level.player SetViewModelDepthOfField( start, end );

			
	level._light.dof_presets[name] = new_dof;
	
}

light_get_dof_preset(name)
{
	if (IsDefined(level._light.dof_presets) && isDefined(level._light.dof_presets[name]))
	{
		return level._light.dof_presets[name];
	}
	
/#
	println("Error Light Scripts: light_get_dof_preset, \"" + name + "\", does not exist.");	
#/
}
/*
=============
///ScriptDocBegin
"Name: blend_dof_presets( <preset1> , <preset2> , <time> )"
"Summary: "
"Module: Lighting"
"CallOn: Level"
"MandatoryArg: <preset1>: "
"MandatoryArg: <preset2>: "
"MandatoryArg: <time>: "
"Example: 	blend_dof_presets( "default", "fusion_fly", 1);"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

blend_dof_presets(preset1, preset2, time)
{	
	assert(IsDefined(preset1));
	assert(IsDefined(preset2));
	assert(IsDefined(time) && time >= 0);
	
	if ( IsDefined( level._light.dof_presets ) )
	{
		dof1 = light_get_dof_preset(preset1);
		dof2 = light_get_dof_preset(preset2);
		
		if (IsDefined(dof1) && IsDefined(dof2) )
		{
			blend_dof(dof1, dof2, time);
		}
		else
		{
			// print an error saying you dont have those presets defined yet
		}
	}	
}
///////////////////////////////////////////////////////
// Depth of Field View Model
///////////////////////////////////////////////////////

light_setup_common_dof_viewmodel_presets()
{	
	//					name							start	end
	create_dof_viewmodel_preset("default", 				2,		8);
	create_dof_viewmodel_preset("viewmodel_blur", 		10,		90);
}
create_dof_viewmodel_preset(name, start, end)
{
	if (!IsDefined(level._light.dof_viewmodel_presets))
		level._light.dof_viewmodel_presets = [];


	new_dof_viewmodel["start"]	= start;
	new_dof_viewmodel["end"]	= end;
	
	level.player.viewmodel_dof_start = new_dof_viewmodel[ "start" ];
	level.player.viewmodel_dof_end = new_dof_viewmodel[ "end" ];
		
	level._light.dof_viewmodel_presets[name] = new_dof_viewmodel;
	
}
light_get_dof_viewmodel_preset(name)
{
	if (IsDefined(level._light.dof_viewmodel_presets) && isDefined(level._light.dof_viewmodel_presets[name]))
	{
		return level._light.dof_viewmodel_presets[name];
	}
	
/#
	println("Error Light Scripts: light_get_dof_preset, \"" + name + "\", does not exist.");	
#/
}
/*
=============
///ScriptDocBegin
"Name: blend_dof_viewmodel_presets( <preset1> , <preset2> , <time> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <preset1>: "
"MandatoryArg: <preset2>: "
"MandatoryArg: <time>: "
"Example: 		thread blend_dof_viewmodel_presets( "default", "viewmodel_blur", 1);"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
blend_dof_viewmodel_presets(preset1, preset2, time)
{	
	assert(IsDefined(preset1));
	assert(IsDefined(preset2));
	assert(IsDefined(time) && time >= 0);
	
	if ( IsDefined( level._light.dof_viewmodel_presets ) )
	{
		start_viewmodel = light_get_dof_viewmodel_preset(preset1);
		end_viewmodel = light_get_dof_viewmodel_preset(preset2);
		
		if (IsDefined(start_viewmodel) && IsDefined(end_viewmodel) )
		{
			blend_viewmodel_dof(start_viewmodel, end_viewmodel, time);
		}
		else
		{
			// print an error saying you dont have those presets defined yet
		}
	}	
}	
blend_viewmodel_dof( start_viewmodel, end_viewmodel, time )
{
	if ( time > 0 )
	{
		start_dof_inc = ( ( end_viewmodel[ "start" ] - start_viewmodel[ "start" ] ) * 0.05 ) / time;
		end_dof_inc = ( ( end_viewmodel[ "end" ] - start_viewmodel[ "end" ] ) * 0.05 ) / time;
		
		thread lerp_viewmodel_dof( end_viewmodel, start_dof_inc, end_dof_inc);
	}
	else
	{
		level.player.viewmodel_dof_start = end_viewmodel[ "start" ];
		level.player.viewmodel_dof_end = end_viewmodel[ "end" ];
	}
}

lerp_viewmodel_dof( end_viewmodel, start_dof_inc, end_dof_inc )
{
	level notify( "lerp_viewmodel_dof" );
	level endon( "lerp_viewmodel_dof" );
	
	start_done = false;
	end_done = false;
	
	while ( !start_done || !end_done )
	{
		if ( !start_done )
		{
			level.player.viewmodel_dof_start = level.player.viewmodel_dof_start + start_dof_inc;
			if ( ( start_dof_inc > 0 && level.player.viewmodel_dof_start > end_viewmodel[ "start" ] ) ||
				 ( start_dof_inc < 0 && level.player.viewmodel_dof_start < end_viewmodel[ "start" ] ) )
			{
				level.player.viewmodel_dof_start = end_viewmodel[ "start" ];
				start_done = true;
			}
		}
		
		if ( !end_done )
		{
			level.player.viewmodel_dof_end = level.player.viewmodel_dof_end + end_dof_inc;
			if ( ( end_dof_inc > 0 && level.player.viewmodel_dof_end > end_viewmodel[ "end" ] ) ||
				 ( end_dof_inc < 0 && level.player.viewmodel_dof_end < end_viewmodel[ "end" ] ) )
			{
				level.player.viewmodel_dof_end = end_viewmodel[ "end" ];
				end_done = true;
			}
		}
		
		level.player SetViewModelDepthOfField( level.player.viewmodel_dof_start, level.player.viewmodel_dof_end );
		wait 0.05;
	}
}
///////////////////////////////////////////////////////
// Darken Light Grid
///////////////////////////////////////////////////////
/*
set_grid_color_dark()
{
	//set light grid color to get inside of chopper dark / correct EV values
	flag_wait( "sun_shad_fly_in" );
	
	wait 1;
    foreach(prop in level.warbird_a.zipline_gun_model)
    {
        prop StartUsingHeroOnlyLighting();
    }
	level.warbird_a StartUsingHeroOnlyLighting();

	SetSavedDvar("r_lightgridenabletweaks", "1");
	SetSavedDvar("r_lightgridintensity", ".02");
}
*/
///////////////////////////////////////////////////////
// Light Message Script Code
///////////////////////////////////////////////////////

light_message_init()
{
	assert(IsDefined(level._light));
	level._light.messages = [];
}

light_debug_dvar_init()
{
	/#
	SetDvarIfUninitialized( "light_debug_messages", 0 );
	#/
}

light_register_message( message, callback )
{
	assertEx( IsDefined( level._light ), "Need to call light_message_init() before calling this function." );
	assert( IsArray( level._light.messages ) );
	level._light.messages[message] = callback;
}

light_message( message, arg1, arg2, arg3 )
{
	AssertEx( IsDefined( level._light ), "Need to call light_message_init() before calling this function." );
	Assert( IsArray( level._light.messages ) );
	
	if ( IsDefined( level._light.messages[message] ) )
	{
		if ( IsDefined( arg3 ) )
			thread [[ level._light.messages[message] ]]( arg1, arg2, arg3 );
		else if ( IsDefined( arg2 ) )
			thread [[ level._light.messages[message] ]]( arg1, arg2 );
		else if ( IsDefined( arg1 ) )
			thread [[ level._light.messages[message] ]]( arg1 );
		else
			thread [[ level._light.messages[message] ]]();
	}
	
	/#
	if ( !IsDefined( level._light.messages[message] ) && IsDefined( GetDebugDvarInt( "light_debug_messages") ) && GetDebugDvarInt( "light_debug_messages" ) == 1 )
	{
		IPrintLn( "light_message not handled: " + message );
	}
	#/
}
