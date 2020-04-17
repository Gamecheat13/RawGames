#include maps\mp\_utility;
main()
{
	maps\mp\_constants::main();
	
	if (getDvar("scr_RequiredMapAspectratio") == "")
		setDvar("scr_RequiredMapAspectratio", "1");

	common_scripts\ambientpackage::init();
	level.ambientPackageHandler = maps\mp\gametypes\_perplayer::init( "ambientpackage", common_scripts\ambientpackage::initPlayer, common_scripts\ambientpackage::shutdownPlayer );
	maps\mp\gametypes\_perplayer::enable( level.ambientPackageHandler );

	thread maps\mp\gametypes\_tweakables::init();
	thread maps\mp\_minefields::minefields();
	thread maps\mp\_shutter::main();
	thread maps\mp\_destructables::init();
	thread maps\mp\_useableobjects::main();
	thread maps\mp\_playerawareness::init();
	thread maps\mp\_doors::init();

	precacheRumble( "coverenter_rumble" );
	precacheRumble( "melee_attack_hit" );
	precacheRumble( "melee_attack_miss" );
	precacheRumble( "melee_struck_general" );
	precacheRumble( "movebody_rumble" );
	precacheRumble( "qk_hit" );

	lanterns = getentarray("lantern_glowFX_origin","targetname");
	for( i = 0 ; i < lanterns.size ; i++ )
		lanterns[i] thread lanterns();

	setupExploders();
	
	level.createFX_enabled = (getdvar("createfx") != "");
	thread maps\mp\_createfx::fx_init();
	if (level.createFX_enabled)
		maps\mp\_createfx::createfx();
	
	// Do various things on triggers
	for (p=0;p<6;p++)
	{
		switch (p)
		{
			case 0:
				triggertype = "trigger_multiple";
				break;

			case 1:
				triggertype = "trigger_once";
				break;

			case 2:
				triggertype = "trigger_use";
				break;
				
			case 3:	
				triggertype = "trigger_radius";
				break;
			
			case 4:	
				triggertype = "trigger_lookat";
				break;

			default:
				assert(p == 5);
				triggertype = "trigger_damage";
				break;
		}

		triggers = getentarray (triggertype,"classname");
		for (i=0;i<triggers.size;i++)
		{
			if (isdefined (triggers[i].script_prefab_exploder))
				triggers[i].script_exploder = triggers[i].script_prefab_exploder;

			if (isdefined (triggers[i].script_exploder))
				level thread maps\mp\_load::exploder_load(triggers[i]);
		}
	}
}

exploder_load (trigger)
{
	level endon ("killexplodertridgers"+trigger.script_exploder);
	trigger waittill ("trigger");
	if(isdefined(trigger.script_chance) && randomfloat(1)>trigger.script_chance)
	{
		if(isdefined(trigger.script_delay))
			wait trigger.script_delay;
		else
			wait 4;
		level thread exploder_load(trigger);
		return;
	}
	maps\mp\_utility::exploder (trigger.script_exploder);
	level notify ("killexplodertridgers"+trigger.script_exploder);
}


setupExploders()
{
	// Hide exploder models.
	ents = getentarray ("script_brushmodel","classname");
	smodels = getentarray ("script_model","classname");
	for(i=0;i<smodels.size;i++)
		ents[ents.size] = smodels[i];

	for (i=0;i<ents.size;i++)
	{
		if (isdefined (ents[i].script_prefab_exploder))
			ents[i].script_exploder = ents[i].script_prefab_exploder;

		if (isdefined (ents[i].script_exploder))
		{
			if ((ents[i].model == "fx") && ((!isdefined (ents[i].targetname)) || (ents[i].targetname != "exploderchunk")))
				ents[i] hide();
			else if ((isdefined (ents[i].targetname)) && (ents[i].targetname == "exploder"))
			{
				ents[i] hide();
				ents[i] notsolid();
				//if(isdefined(ents[i].script_disconnectpaths))
					//ents[i] connectpaths();
			}
			else if ((isdefined (ents[i].targetname)) && (ents[i].targetname == "exploderchunk"))
			{
				ents[i] hide();
				ents[i] notsolid();
				//if(isdefined(ents[i].spawnflags) && (ents[i].spawnflags & 1))
					//ents[i] connectpaths();
			}
		}
	}

	script_exploders = [];

	potentialExploders = getentarray ("script_brushmodel","classname");
	for (i=0;i<potentialExploders.size;i++)
	{
		if (isdefined (potentialExploders[i].script_prefab_exploder))
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;
			
		if (isdefined (potentialExploders[i].script_exploder))
			script_exploders[script_exploders.size] = potentialExploders[i];
	}

	potentialExploders = getentarray ("script_model","classname");
	for (i=0;i<potentialExploders.size;i++)
	{
		if (isdefined (potentialExploders[i].script_prefab_exploder))
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;

		if (isdefined (potentialExploders[i].script_exploder))
			script_exploders[script_exploders.size] = potentialExploders[i];
	}

	potentialExploders = getentarray ("item_health","classname");
	for (i=0;i<potentialExploders.size;i++)
	{
		if (isdefined (potentialExploders[i].script_prefab_exploder))
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;

		if (isdefined (potentialExploders[i].script_exploder))
			script_exploders[script_exploders.size] = potentialExploders[i];
	}
	
	if (!isdefined(level.createFXent))
		level.createFXent = [];
	
	acceptableTargetnames = [];
	acceptableTargetnames["exploderchunk visible"] = true;
	acceptableTargetnames["exploderchunk"] = true;
	acceptableTargetnames["exploder"] = true;
	
	for ( i=0; i<script_exploders.size; i++)
	{
		exploder = script_exploders[i];
		ent = createExploder(exploder.script_fxid);
		ent.v = [];
		ent.v["origin"] = exploder.origin;
		ent.v["angles"] = exploder.angles;
		ent.v["delay"] = exploder.script_delay;
		ent.v["firefx"] = exploder.script_firefx;
		ent.v["firefxdelay"] = exploder.script_firefxdelay;
		ent.v["firefxsound"] = exploder.script_firefxsound;
		ent.v["firefxtimeout"] = exploder.script_firefxtimeout;
		ent.v["earthquake"] = exploder.script_earthquake;
		ent.v["damage"] = exploder.script_damage;
		ent.v["damage_radius"] = exploder.script_radius;
		ent.v["soundalias"] = exploder.script_soundalias;
		ent.v["repeat"] = exploder.script_repeat;
		ent.v["delay_min"] = exploder.script_delay_min;
		ent.v["delay_max"] = exploder.script_delay_max;
		ent.v["target"] = exploder.target;
		ent.v["ender"] = exploder.script_ender;
		ent.v["type"] = "exploder";
//		ent.v["worldfx"] = true;
		if(!isdefined(exploder.script_fxid))
			ent.v["fxid"] = "No FX";
		else
			ent.v["fxid"] = exploder.script_fxid;
		ent.v["exploder"] = exploder.script_exploder;
		assertEx (isdefined(exploder.script_exploder), "Exploder at origin " + exploder.origin + " has no script_exploder");

		if (!isdefined (ent.v["delay"]))
			ent.v["delay"] = 0;
			
		if ( isdefined( exploder.target ) )
		{
			org = getent( ent.v["target"], "targetname" ).origin;
			ent.v["angles"] = vectortoangles( org - ent.v["origin"] );
//			forward = anglestoforward( angles );
//			up = anglestoup( angles );
		}
			
		// this basically determines if its a brush/model exploder or not
		if (exploder.classname == "script_brushmodel" || isdefined( exploder.model ))
		{
			ent.model = exploder;
			ent.model.disconnect_paths = exploder.script_disconnectpaths;
		}
		
		if ( isdefined( exploder.targetname ) && isdefined( acceptableTargetnames[ exploder.targetname ] ))
			ent.v["exploder_type"] = exploder.targetname;
		else
			ent.v["exploder_type"] = "normal";
		
		ent maps\mp\_createfx::post_entity_creation_function();
	}
}

lanterns()
{
	if (!isdefined(level._effect["lantern_light"]))
		level._effect["lantern_light"]	= loadfx("props/glow_latern");
	maps\mp\_fx::loopfx("lantern_light", self.origin, 0.3, self.origin + (0,0,1));
}
