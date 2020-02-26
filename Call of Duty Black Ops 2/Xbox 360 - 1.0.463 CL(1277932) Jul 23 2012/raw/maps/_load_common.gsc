#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;

#insert raw\common_scripts\utility.gsh;

#using_animtree("generic_human");

autoexec run_gump_functions()
{
	while ( true )
	{
		level waittill( "gump_loaded" );
		str_gump = GetDvar( "gump_name" );
		
		if ( IsDefined( level._gump_functions ) && IsDefined( level._gump_functions[ str_gump ] ) )
		{
			foreach ( func_gump in level._gump_functions[ str_gump ] )
			{
				level thread [[ func_gump ]]();
			}
		}
	}
}

level_notify_listener()
{
	while(1)
	{
		
		val = GetDvar( "level_notify");
		if(val != "")
		{
			level notify(val);
			SetDvar("level_notify", "");
		}
		wait(0.2);
	}
}

client_notify_listener()
{
	while(1)
	{
		
		val = GetDvar( "client_notify");
		if(val != "")
		{
			ClientNotify(val);
			SetDvar("client_notify", "");
		}
		wait(0.2);
	}
}

save_game_on_notify()
{
	while (1)
	{
		level waittill("save");
		SaveGame("debug_save");
	}
}

onFirstPlayerReady()
{
	level waittill( "first_player_ready", player );

	// put any calls here that you want to happen when the FIRST player connects to the game
	/#println( "*********************First player connected to game." );#/
}

set_early_level()
{
	// SUMEET - Vorkuta and Cuba are early levels
	level.early_level = [];
	level.early_level["cuba"] 		 = true;
	level.early_level["vorkuta"] 	 = true;
}

setup_simple_primary_lights()
{
	flickering_lights = GetEntArray( "generic_flickering", "targetname" );
	pulsing_lights = GetEntArray( "generic_pulsing", "targetname" );
	double_strobe = GetEntArray( "generic_double_strobe", "targetname" );
	fire_flickers = GetEntArray( "fire_flicker", "targetname" );
	
	array_thread( flickering_lights, maps\_lights::generic_flickering );
	array_thread( pulsing_lights, maps\_lights::generic_pulsing );
	array_thread( double_strobe, maps\_lights::generic_double_strobe );
	array_thread( fire_flickers, maps\_lights::fire_flicker );
}


weapon_ammo()
{
	ents = GetEntArray();
	for( i = 0; i < ents.size; i ++ )
	{
		if( ( IsDefined( ents[i].classname ) ) &&( GetSubStr( ents[i].classname, 0, 7 ) == "weapon_" ) )
		{
			weap = ents[i];
			change_ammo = false;
			clip = undefined;
			extra = undefined;
				
			if( IsDefined( weap.script_ammo_clip ) )
			{
				clip = weap.script_ammo_clip;
				change_ammo = true;
			}

			if( IsDefined( weap.script_ammo_extra ) )
			{
				extra = weap.script_ammo_extra;
				change_ammo = true;
			}
			
			if( change_ammo )
			{
				if( !IsDefined( clip ) )
				{
					assertmsg( "weapon: " + weap.classname + " " + weap.origin + " sets script_ammo_extra but not script_ammo_clip" );
				}

				if( !IsDefined( extra ) )
				{
					assertmsg( "weapon: " + weap.classname + " " + weap.origin + " sets script_ammo_clip but not script_ammo_extra" );
				}
				weap ItemWeaponSetAmmo( clip, extra );
				weap ItemWeaponSetAmmo( clip, extra, 1 );
				
			}
		}
	}
}

trigger_group()
{
	self thread trigger_group_remove();

	level endon( "trigger_group_" + self.script_trigger_group );
	self waittill( "trigger" );
	level notify( "trigger_group_" + self.script_trigger_group, self );
}

trigger_group_remove()
{
	level waittill( "trigger_group_" + self.script_trigger_group, trigger );
	if( self != trigger )
	{
		self Delete();
	}
}

exploder_load( trigger )
{
	level endon( "killexplodertridgers"+trigger.script_exploder );
	trigger waittill( "trigger" );
	if( IsDefined( trigger.script_chance ) && RandomFloat( 1 )>trigger.script_chance )
	{
		if( IsDefined( trigger.script_delay ) )
		{
			wait( trigger.script_delay );
		}
		else
		{
			wait( 4 );
		}

		level thread exploder_load( trigger );
		return;
	}

	exploder( trigger.script_exploder );
	level notify( "killexplodertridgers"+trigger.script_exploder );
}

setup_traversals()
{
	potential_traverse_nodes = GetAllNodes();
	for (i = 0; i < potential_traverse_nodes.size; i++)
	{
		node = potential_traverse_nodes[i];
		if (node.type == "Begin")
		{
			node animscripts\traverse\shared::init_traverse();
		}
	}
}

badplace_think( badplace )
{
	if( !IsDefined( level.badPlaces ) )
	{
		level.badPlaces = 0;
	}
		
	level.badPlaces++;
	Badplace_Cylinder( "badplace" + level.badPlaces, -1, badplace.origin, badplace.radius, 1024 );
}

setupExploders()
{
	level.exploders = [];
	
	// Hide exploder models.
	ents = GetEntArray( "script_brushmodel", "classname" );
	smodels = GetEntArray( "script_model", "classname" );
	for( i = 0; i < smodels.size; i++ )
	{
		ents[ents.size] = smodels[i];
	}

	for( i = 0; i < ents.size; i++ )
	{
		if( IsDefined( ents[i].script_prefab_exploder ) )
		{
			ents[i].script_exploder = ents[i].script_prefab_exploder;
		}

		if( IsDefined( ents[i].script_exploder ) )
		{
			if( ents[i].script_exploder < 10000 )
			{
				level.exploders[ents[i].script_exploder] = true;  // nate. I wanted a list
			}

			if( ( ents[i].model == "fx" ) &&( ( !IsDefined( ents[i].targetname ) ) ||( ents[i].targetname != "exploderchunk" ) ) )
			{
				ents[i] Hide();
			}
			else if( ( IsDefined( ents[i].targetname ) ) &&( ents[i].targetname == "exploder" ) )
			{
				ents[i] Hide();
				ents[i] NotSolid();

				if( IsDefined( ents[i].script_disconnectpaths ) )
					ents[i] ConnectPaths();
			}
			else if( ( IsDefined( ents[i].targetname ) ) &&( ents[i].targetname == "exploderchunk" ) )
			{
				ents[i] Hide();
				ents[i] NotSolid();

				if( ents[i] has_spawnflag( SPAWNFLAG_MODEL_DYNAMIC_PATH ))
				{
					ents[i] ConnectPaths();
				}
			}
		}
	}

	script_exploders = [];

	potentialExploders = GetEntArray( "script_brushmodel", "classname" );
	for( i = 0; i < potentialExploders.size; i++ )
	{
		if( IsDefined( potentialExploders[i].script_prefab_exploder ) )
		{
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;
		}
			
		if( IsDefined( potentialExploders[i].script_exploder ) )
		{
			script_exploders[script_exploders.size] = potentialExploders[i];
		}
	}

	/#println("Server : Potential exploders from brushmodels " + potentialExploders.size);#/

	potentialExploders = GetEntArray( "script_model", "classname" );
	for( i = 0; i < potentialExploders.size; i++ )
	{
		if( IsDefined( potentialExploders[i].script_prefab_exploder ) )
		{
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;
		}

		if( IsDefined( potentialExploders[i].script_exploder ) )
		{
			script_exploders[script_exploders.size] = potentialExploders[i];
		}
	}

	/#println("Server : Potential exploders from script_model " + potentialExploders.size);#/

	potentialExploders = GetEntArray( "item_health", "classname" );
	for( i = 0; i < potentialExploders.size; i++ )
	{
		if( IsDefined( potentialExploders[i].script_prefab_exploder ) )
		{
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;
		}

		if( IsDefined( potentialExploders[i].script_exploder ) )
		{
			script_exploders[script_exploders.size] = potentialExploders[i];
		}
	}
	
	/#println("Server : Potential exploders from item_health " + potentialExploders.size);#/

	
	if( !IsDefined( level.createFXent ) )
	{
		level.createFXent = [];
	}
	
	acceptableTargetnames = [];
	acceptableTargetnames["exploderchunk visible"] = true;
	acceptableTargetnames["exploderchunk"] = true;
	acceptableTargetnames["exploder"] = true;
	
	for ( i = 0; i < script_exploders.size; i ++ )
	{
		exploder = script_exploders[ i ];
		ent = createExploder( exploder.script_fxid );
		ent.v = [];
		ent.v[ "origin" ] = exploder.origin;
		ent.v[ "angles" ] = exploder.angles;
		ent.v[ "delay" ] = exploder.script_delay;
		ent.v[ "firefx" ] = exploder.script_firefx;
		ent.v[ "firefxdelay" ] = exploder.script_firefxdelay;
		ent.v[ "firefxsound" ] = exploder.script_firefxsound;
		ent.v[ "firefxtimeout" ] = exploder.script_firefxtimeout;
		ent.v[ "earthquake" ] = exploder.script_earthquake;
		ent.v[ "damage" ] = exploder.script_damage;
		ent.v[ "damage_radius" ] = exploder.script_radius;
		ent.v[ "soundalias" ] = exploder.script_soundalias;
		ent.v[ "repeat" ] = exploder.script_repeat;
		ent.v[ "delay_min" ] = exploder.script_delay_min;
		ent.v[ "delay_max" ] = exploder.script_delay_max;
		ent.v[ "target" ] = exploder.target;
		ent.v[ "ender" ] = exploder.script_ender;
		ent.v[ "type" ] = "exploder";
// 		ent.v[ "worldfx" ] = true;
		if ( !isdefined( exploder.script_fxid ) )
			ent.v[ "fxid" ] = "No FX";
		else
			ent.v[ "fxid" ] = exploder.script_fxid;
		ent.v[ "exploder" ] = exploder.script_exploder;
		assert( isdefined( exploder.script_exploder ), "Exploder at origin " + exploder.origin + " has no script_exploder" );

		if ( !isdefined( ent.v[ "delay" ] ) )
			ent.v[ "delay" ] = 0;
			
		if ( isdefined( exploder.target ) )
		{
			// BJoyal (1/12/12) - Added a check to see if the GetEnt returns undefined, in which case, use GetStruct
			e_target = GetEnt( ent.v[ "target" ], "targetname" );
			if( !IsDefined( e_target ) )
			{
				e_target = GetStruct( ent.v[ "target" ], "targetname" );
			}
			
			org = e_target.origin;
			ent.v[ "angles" ] = vectortoangles( org - ent.v[ "origin" ] );
// 			forward = anglestoforward( angles );
// 			up = anglestoup( angles );
		}
			
		// this basically determines if its a brush / model exploder or not
		if ( exploder.classname == "script_brushmodel" || isdefined( exploder.model ) )
		{
			ent.model = exploder;
			ent.model.disconnect_paths = exploder.script_disconnectpaths;
		}
		
		if ( isdefined( exploder.targetname ) && isdefined( acceptableTargetnames[ exploder.targetname ] ) )
			ent.v[ "exploder_type" ] = exploder.targetname;
		else
			ent.v[ "exploder_type" ] = "normal";
		
		/#ent maps\_createfx::post_entity_creation_function();#/
	}

	level.createFXexploders = [];
	
	for(i = 0; i < level.createFXent.size;i ++ )
	{
		ent = level.createFXent[i];
		
		if(ent.v["type"] != "exploder")
			continue;
			
		ent.v["exploder_id"] = getExploderId( ent );

		if(!IsDefined(level.createFXexploders[ent.v["exploder"]]))
		{
			level.createFXexploders[ent.v["exploder"]] = [];
		}
		
		level.createFXexploders[ent.v["exploder"]][level.createFXexploders[ent.v["exploder"]].size] = ent;

	}

	reportExploderIds();
}

playerDamageRumble()
{
	while( true )
	{
		self waittill( "damage", amount );

		if( IsDefined( self.specialDamage ) )
		{
			continue;
		}
		
		self PlayRumbleOnEntity( "damage_heavy" );
	}
}

map_is_early_in_the_game()
{
	/#
	if( IsDefined( level.testmap ) )
	{
		return true;
	}
	#/
	
	/#
	if( !IsDefined( level.early_level[level.script] ) )
	{
		level.early_level[level.script] = false;
	}
	#/
	
	return level.early_level[level.script];
}

player_throwgrenade_timer()
{
	self endon( "death" );
	self endon( "disconnect" );

	self.lastgrenadetime = 0;

	while( 1 )
	{
		while( ! self IsThroWingGrenade() )
		{
			wait( .05 );
		}

		self.lastgrenadetime = GetTime();

		while( self IsThroWingGrenade() )
		{
			wait( .05 );
		}
	}
}

// SUMEET_TODO - Next project clean up this function and make it modular
player_special_death_hint()
{
	self endon( "disconnect" );

	self thread player_throwgrenade_timer(); // this thread used in coop also

	if( isSplitScreen() || coopGame() )
	{
		return;
	}

	// added an inflicter check
	self waittill( "death", attacker, cause, weaponName, inflicter );
	
	if( cause != "MOD_GAS" && cause != "MOD_GRENADE" && cause != "MOD_GRENADE_SPLASH" && cause != "MOD_SUICIDE" && cause != "MOD_EXPLOSIVE" && cause != "MOD_PROJECTILE" && cause != "MOD_PROJECTILE_SPLASH" )
	{
		return;
	}

	// On hardened/veteran difficulty, we only show hints on first couple of levels
	if ( level.gameskill >= 2 )
	{
		if ( !map_is_early_in_the_game() )
			return;
	}
	
	if( cause == "MOD_SUICIDE" )
	{
		// check against the grenade fuse time and the last time the grenade was used
		// SUMEET_TODO - port over GetWeaponFuseTime() from MP
		
		TimeSinceThrown = GetTime() - self.lastgrenadetime;
			
		if ( ( TimeSinceThrown ) < 3.5 * 1000 || ( TimeSinceThrown ) > 4.5 * 1000 )
			return;

		level notify( "new_quote_string" );
		SetDvar( "ui_deadquote", "");
		self thread grenade_death_text_hudelement( &"SCRIPT_GRENADE_SUICIDE_LINE1", &"SCRIPT_GRENADE_SUICIDE_LINE2" );
		return;
	}

	if( cause == "MOD_EXPLOSIVE" )
	{
		// script_vehicle death hint/ also if the script is just manually a model swap instead of script vehicle
		if( IsDefined( attacker ) && ( attacker.classname == "script_vehicle" || IsDefined( attacker.create_fake_vehicle_damage ) ) )
        {
			level notify( "new_quote_string" );
			
			// You were killed by an exploding vehicle. Vehicles on fire are likely to explode.
			SetDvar( "ui_deadquote", "@SCRIPT_EXPLODING_VEHICLE_DEATH" );
			// thread special_death_indicator_hudelement( "hud_burningcaricon", 96, 96 );
			return;
		}

		
		
		// Destructible explosion death hints
		if( IsDefined( inflicter ) && IsDefined( inflicter.destructibledef ) )
		{
			// Destructible Barrel
			if( IsSubStr( inflicter.destructibledef, "barrel_explosive" ) )
			{
				level notify( "new_quote_string" );

				// You were killed by an exploding barrel. Red barrels will explode when shot.
				SetDvar( "ui_deadquote", "@SCRIPT_EXPLODING_BARREL_DEATH" );
				// thread special_death_indicator_hudelement( "hud_burningbarrelicon", 64, 64 );
				return;
			}
			
			// Destructible car
			if( IsDefined( inflicter.destructiblecar ) && inflicter.destructiblecar )
			{
				level notify( "new_quote_string" );
			
				// You were killed by an exploding vehicle. Vehicles on fire are likely to explode.
				SetDvar( "ui_deadquote", "@SCRIPT_EXPLODING_VEHICLE_DEATH" );
				// thread special_death_indicator_hudelement( "hud_burningcaricon", 96, 96 );
				return;
			}
			
		}
	}
	
	if( cause == "MOD_GRENADE" || cause == "MOD_GRENADE_SPLASH" )
	{
		if( IsDefined( weaponName ) && (!IsWeaponDetonationTimed( weaponName ) || WeaponType( weaponName) != "grenade") )
		{
			return;
		}

		level notify( "new_quote_string" );
		
		if (IsDefined( weaponName ) && (weaponName == "titus_explosive_dart_sp") )
		{
			//You were killed by an explosive bolt.
			SetDvar( "ui_deadquote", "@SCRIPT_EXPLOSIVE_FLECHETTE_DEATH" );
			thread explosive_arrow_death_indicator_hudelement();
		}
		else if (IsDefined( weaponName ) && (weaponName == "explosive_bolt_sp") )
		{
			//You were killed by an explosive bolt.
			SetDvar( "ui_deadquote", "@SCRIPT_EXPLOSIVE_BOLT_DEATH" );
			thread explosive_arrow_death_indicator_hudelement();
		}
		else
		{
			//You were killed by a grenade.  Watch out for the grenade danger indicator.
			SetDvar( "ui_deadquote", "@SCRIPT_GRENADE_DEATH" );
			thread grenade_death_indicator_hudelement();
		}
		
		return;
	}
	
	// SUMEET_TODO - Find out a better way to know what destructible it is as compared to checking level script.
	if( cause == "MOD_GAS" && level.script == "monsoon" )
	{
		SetDvar( "ui_deadquote", "@SCRIPT_EXPLODING_NITROGEN_TANK_DEATH" );
		thread explosive_nitrogen_tank_death_indicator_hudelement();
		
		return;
	}
}

grenade_death_text_hudelement( textLine1, textLine2 )
{
	self.failingMission = true;
	
	SetDvar( "ui_deadquote", "" );

	wait( .5 );

	fontElem = NewHudElem();
	fontElem.elemType = "font";
	fontElem.font = "default";
	fontElem.fontscale = 1.5;
	fontElem.x = 0;
	fontElem.y = -60;

	fontElem.alignX = "center";
	fontElem.alignY = "middle";
	fontElem.horzAlign = "center";
	fontElem.vertAlign = "middle";
	fontElem SetText( textLine1 );
	fontElem.foreground = true;
	fontElem.alpha = 0;
	fontElem FadeOverTime( 1 );
	fontElem.alpha = 1;
	fontElem.hidewheninmenu = true;

	if( IsDefined( textLine2 ) )
	{
		fontElem = NewHudElem();
		fontElem.elemType = "font";
		fontElem.font = "default";
		fontElem.fontscale = 1.5;
		fontElem.x = 0;
		fontElem.y = -60 + level.fontHeight * fontElem.fontscale;

		fontElem.alignX = "center";
		fontElem.alignY = "middle";
		fontElem.horzAlign = "center";
		fontElem.vertAlign = "middle";
		fontElem SetText( textLine2 );
		fontElem.foreground = true;
		fontElem.alpha = 0;
		fontElem FadeOverTime( 1 );
		fontElem.alpha = 1;
		fontElem.hidewheninmenu = true;
		
	}
}

grenade_death_indicator_hudelement()
{
	self endon( "disconnect" );
	wait( .5 );
	overlayIcon = NewClientHudElem( self );
	overlayIcon.x = 0;
	overlayIcon.y = 68;
	overlayIcon SetShader( "hud_grenadeicon", 50, 50 );
	overlayIcon.alignX = "center";
	overlayIcon.alignY = "middle";
	overlayIcon.horzAlign = "center";
	overlayIcon.vertAlign = "middle";
	overlayIcon.foreground = true;
	overlayIcon.alpha = 0;
	overlayIcon FadeOverTime( 1 );
	overlayIcon.alpha = 1;
	overlayIcon.hidewheninmenu = true;

	overlayPointer = NewClientHudElem( self );
	overlayPointer.x = 0;
	overlayPointer.y = 25;
	overlayPointer SetShader( "hud_grenadepointer", 50, 25 );
	overlayPointer.alignX = "center";
	overlayPointer.alignY = "middle";
	overlayPointer.horzAlign = "center";
	overlayPointer.vertAlign = "middle";
	overlayPointer.foreground = true;
	overlayPointer.alpha = 0;
	overlayPointer FadeOverTime( 1 );
	overlayPointer.alpha = 1;
	overlayPointer.hidewheninmenu = true;
	
	self thread grenade_death_indicator_hudelement_cleanup( overlayIcon, overlayPointer );
}


explosive_arrow_death_indicator_hudelement()
{
	self endon( "disconnect" );
	wait( .5 );
	overlayIcon = NewClientHudElem( self );
	overlayIcon.x = 0;
	overlayIcon.y = 68;
	overlayIcon SetShader( "hud_explosive_arrow_icon", 50, 50 );
	overlayIcon.alignX = "center";
	overlayIcon.alignY = "middle";
	overlayIcon.horzAlign = "center";
	overlayIcon.vertAlign = "middle";
	overlayIcon.foreground = true;
	overlayIcon.alpha = 0;
	overlayIcon FadeOverTime( 1 );
	overlayIcon.alpha = 1;
	overlayIcon.hidewheninmenu = true;

	overlayPointer = NewClientHudElem( self );
	overlayPointer.x = 0;
	overlayPointer.y = 25;
	overlayPointer SetShader( "hud_grenadepointer", 50, 25 );
	overlayPointer.alignX = "center";
	overlayPointer.alignY = "middle";
	overlayPointer.horzAlign = "center";
	overlayPointer.vertAlign = "middle";
	overlayPointer.foreground = true;
	overlayPointer.alpha = 0;
	overlayPointer FadeOverTime( 1 );
	overlayPointer.alpha = 1;
	overlayPointer.hidewheninmenu = true;
	
	self thread grenade_death_indicator_hudelement_cleanup( overlayIcon, overlayPointer );
}

explosive_nitrogen_tank_death_indicator_hudelement()
{
	self endon( "disconnect" );
	wait( .5 );
	overlayIcon = NewClientHudElem( self );
	overlayIcon.x = 0;
	overlayIcon.y = 68;
	overlayIcon SetShader( "hud_monsoon_nitrogen_barrel", 50, 50 );
	overlayIcon.alignX = "center";
	overlayIcon.alignY = "middle";
	overlayIcon.horzAlign = "center";
	overlayIcon.vertAlign = "middle";
	overlayIcon.foreground = true;
	overlayIcon.alpha = 0;
	overlayIcon FadeOverTime( 1 );
	overlayIcon.alpha = 1;
	overlayIcon.hidewheninmenu = true;

	overlayPointer = NewClientHudElem( self );
	overlayPointer.x = 0;
	overlayPointer.y = 25;
	overlayPointer SetShader( "hud_grenadepointer", 50, 25 );
	overlayPointer.alignX = "center";
	overlayPointer.alignY = "middle";
	overlayPointer.horzAlign = "center";
	overlayPointer.vertAlign = "middle";
	overlayPointer.foreground = true;
	overlayPointer.alpha = 0;
	overlayPointer FadeOverTime( 1 );
	overlayPointer.alpha = 1;
	overlayPointer.hidewheninmenu = true;
	
	self thread grenade_death_indicator_hudelement_cleanup( overlayIcon, overlayPointer );
}

// CODE_MOD
grenade_death_indicator_hudelement_cleanup( hudElemIcon, hudElemPointer )
{
	self endon( "disconnect" );
	self waittill( "spawned" );
		
	hudElemIcon Destroy();
	hudElemPointer Destroy();
}

special_death_indicator_hudelement( shader, iWidth, iHeight, fDelay, x, y )
{
	if( !IsDefined( fDelay ) )
	{
		fDelay = 0.5;
	}

	wait( fDelay );
	overlay = NewClientHudElem( self );
	
	if( IsDefined( x ) )
		overlay.x = x;
	else
		overlay.x = 0;

	if( IsDefined( y ) )
		overlay.y = y;
	else
		overlay.y = 40;

	overlay SetShader( shader, iWidth, iHeight );
	overlay.alignX = "center";
	overlay.alignY = "middle";
	overlay.horzAlign = "center";
	overlay.vertAlign = "middle";
	overlay.foreground = true;
	overlay.alpha = 0;
	overlay FadeOverTime( 1 );
	overlay.alpha = 1;
	overlay.hidewheninmenu = true;

	self thread special_death_death_indicator_hudelement_cleanup( overlay );
}

special_death_death_indicator_hudelement_cleanup( overlay )
{
	self endon( "disconnect" );
	self waittill( "spawned" );
		
	overlay Destroy();
}


// SCRIPTER_MOD
// MikeD( 3/16/2007 ) TODO: Test this feature
waterThink()
{
	assert( IsDefined( self.target ) );
	targeted = GetEnt( self.target, "targetname" );
	assert( IsDefined( targeted ) );
	waterHeight = targeted.origin[2];
	targeted = undefined;
	
	level.depth_allow_prone = 8;
	level.depth_allow_crouch = 33;
	level.depth_allow_stand = 50;
	
	
	for( ;; )
	{
		wait( 0.05 );
		//restore all defaults
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( players[i].inWater )
			{
				players[i] AllowProne( true );
				players[i] AllowCrouch( true );
				players[i] AllowStand( true );
//				thread waterThink_rampSpeed( level.default_run_speed );
			}
		}
		
		//wait( until in water )
		self waittill( "trigger", other );

		if( !IsPlayer( other ) )
		{
			continue;
		}

		while( 1 )
		{
			players = get_players();

			players_in_water_count = 0;
			for( i = 0; i < players.size; i++ )
			{
				if( players[i] IsTouching( self ) )
				{
					players_in_water_count++;
					players[i].inWater = true;
					playerOrg = players[i] GetOrigin();
					d = ( playerOrg[2] - waterHeight );
					if( d > 0 )
					{
						continue;
					}
					
					//slow the players movement based on how deep it is
					newSpeed = Int( level.default_run_speed - abs( d * 5 ) );
					if( newSpeed < 50 )
					{
						newSpeed = 50;
					}
					assert( newSpeed <= 190 );
//					thread waterThink_rampSpeed( newSpeed );
					
					//controll the allowed stances in this water height
					if( abs( d ) > level.depth_allow_crouch )
					{
						players[i] AllowCrouch( false );
					}
					else
					{
						players[i] AllowCrouch( true );
					}
					
					if( abs( d ) > level.depth_allow_prone )
					{
						players[i] AllowProne( false );
					}
					else
					{
						players[i] AllowProne( true );
					}
				}
				else
				{
					if( players[i].inWater )
					{
						players[i].inWater = false;
					}
				}
			}

			if( players_in_water_count == 0 )
			{
				break;
			}

			wait( 0.5 );
		}

		wait( 0.05 );
	}
	
}

/* DEAD CODE REMOVAL
waterThink_rampSpeed( newSpeed )
{
	level notify( "ramping_water_movement_speed" );
	level endon( "ramping_water_movement_speed" );

// SCRIPTER_MOD
// MikeD( 3/16/2007 ): This will not work since it change the GLOBAL g_speed... We're going to need to be able to change each player's speed if we want this!
// MikeD TODO: FIX THE PLAYER SPEED SO IT AFFECTS EACH PLAYER!
//	rampTime = 0.5;
//	numFrames = Int( rampTime * 20 );
//
//	currentSpeed = GetDvarint( "g_speed" );
//
//	qSlower = false;
//	if( newSpeed < currentSpeed )
//		qSlower = true;
//
//	speedDifference = Int( abs( currentSpeed - newSpeed ) );
//	speedStepSize = Int( speedDifference / numFrames );
//
//	for( i = 0 ; i < numFrames ; i++ )
//	{
//		currentSpeed = GetDvarint( "g_speed" );
//		if( qSlower )
//			SetSavedDvar( "g_speed", ( currentSpeed - speedStepSize ) );
//		else
//			SetSavedDvar( "g_speed", ( currentSpeed + speedStepSize ) );
//		wait( 0.05 );
//	}
//	SetSavedDvar( "g_speed", newSpeed );
}
*/

massNodeInitFunctions()
{
	nodes = GetAllNodes();

//	thread maps\_mgturret::auto_mgTurretLink( nodes );
//	thread maps\_mgturret::saw_mgTurretLink( nodes );
	thread maps\_colors::init_color_grouping( nodes );
}


/*
**********

TRIGGER_UNLOCK

**********
*/

trigger_unlock( trigger )
{
	// trigger unlocks unlock another trigger. When that trigger is hit, all unlocked triggers relock
	// trigger_unlocks with the same script_noteworthy relock the same triggers
	
	noteworthy = "not_set";
	if( IsDefined( trigger.script_noteworthy ) )
	{
		noteworthy = trigger.script_noteworthy;
	}
		
	target_triggers = GetEntArray( trigger.target, "targetname" );

	trigger thread trigger_unlock_death( trigger.target );

	for( ;; )
	{
		array_thread( target_triggers, ::trigger_off );
		trigger waittill( "trigger" );
		array_thread( target_triggers, ::trigger_on );
		
		wait_for_an_unlocked_trigger( target_triggers, noteworthy );

		array_notify( target_triggers, "relock" );
	}
}

trigger_unlock_death( target )
{
	self waittill( "death" );
	target_triggers = GetEntArray( target, "targetname" );
	array_thread( target_triggers, ::trigger_off );
}

wait_for_an_unlocked_trigger( triggers, noteworthy )
{
	level endon( "unlocked_trigger_hit" + noteworthy );
	ent = SpawnStruct();
	for( i = 0; i < triggers.size; i++ )
	{
		triggers[i] thread report_trigger( ent, noteworthy );
	}
	ent waittill( "trigger" );
	level notify( "unlocked_trigger_hit" + noteworthy );
}

report_trigger( ent, noteworthy )
{
	self endon( "relock" );
	level endon( "unlocked_trigger_hit" + noteworthy );
	self waittill( "trigger" );
	ent notify( "trigger" );
}

get_trigger_look_target()
{
	if ( IsDefined( self.target ) )
	{
		a_potential_targets = GetEntArray( self.target, "targetname" );
		a_targets = [];
		
		foreach ( target in a_potential_targets )
		{
			if ( IS_EQUAL( target.classname, "script_origin" ) )
			{
				ARRAY_ADD( a_targets, target );
			}
		}
		
		a_potential_target_structs = get_struct_array( self.target );
		a_targets = ArrayCombine( a_targets, a_potential_target_structs, true, false );
		
		if ( a_targets.size > 0 )
		{
			Assert( a_targets.size == 1, "Look tigger at " + self.origin + " targets multiple origins/structs." );
			e_target = a_targets[0];
		}
	}
	
	DEFAULT( e_target, self );
	
	return e_target;
}

trigger_look( trigger )
{
	trigger endon( "death" );
	
	e_target = trigger get_trigger_look_target();
	
	if ( IsDefined( trigger.script_flag ) && !IsDefined( level.flag[trigger.script_flag] ) )
	{
		flag_init( trigger.script_flag );
	}
	
	a_parameters = [];
	if ( IsDefined( trigger.script_parameters ) )
	{
		a_parameters = StrTok( trigger.script_parameters, ",; " );
	}
	
	b_ads_check = IsInArray( a_parameters, "check_ads" );
		
	while ( true )
	{
		trigger waittill( "trigger", e_other );
		
		if ( IsPlayer( e_other ) )
		{
			while ( e_other IsTouching( trigger ) )
			{
				if ( e_other is_looking_at( e_target, trigger.script_dot, IS_TRUE( trigger.script_trace ) )
					&& ( !b_ads_check || !e_other is_ads() ) )
				{
					trigger notify( "trigger_look" );
					
					if ( IsDefined( trigger.script_flag ) )
					{
						flag_set( trigger.script_flag );
					}
				}
				else
				{
					if ( IsDefined( trigger.script_flag ) )
					{
						flag_clear( trigger.script_flag );
					}
				}
				
				WAIT_FRAME;
			}
			
			if ( IsDefined( trigger.script_flag ) )
			{
				flag_clear( trigger.script_flag );
			}
		}
		else
		{
			AssertMsg( "Look triggers only support players." );
		}
	}
}

indicate_start( start )
{
	hudelem = NewHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.x = 70;
	hudelem.y = 400;
//	hudelem.label = "Loading from start: " + start;
	hudelem.label = start;
	hudelem.alpha = 0;
	hudelem.fontScale = 3;
	wait( 1 );
	hudelem FadeOverTime( 1 );
	hudelem.alpha = 1;
	wait( 5 );
	hudelem FadeOverTime( 1 );
	hudelem.alpha = 0;
	wait( 1 );
	hudelem Destroy();
}

/@
"Name: trigger_notify()"
"Summary: Sends out a level notify of the trigger's script_notify once triggered"
"Module: Trigger"
"CallOn: "
"Example: trigger thread trigger_notify(); "
"SPMP: singleplayer"
@/
trigger_notify( trigger, msg )
{
	trigger endon( "death" );
	
	other = trigger trigger_wait();
	
	if(IsDefined(trigger.target))
	{
		notify_ent = GetEnt(trigger.target, "targetname");
		if(IsDefined(notify_ent))
		{
			notify_ent notify( msg, other );
		}
	}
	
	level notify( msg, other );
}

flag_set_trigger( trigger, str_flag )
{
	trigger endon( "death" );

	flag = trigger get_trigger_flag( str_flag );
	if ( !IsDefined( level.flag[flag] ) )
	{
		flag_init( flag );
	}
	
	while ( true )
	{
		trigger trigger_wait();

		if ( IsDefined( trigger.targetname ) && ( trigger.targetname == "flag_set" ) )
		{
			// this is a "flag_set" trigger so support script_delay
			// generic triggers don't use script_dealy for flag setting because the
			// script_delay might be intended for something else

			trigger script_delay();
		}
		
		flag_set( flag );
	}
}

flag_clear_trigger( trigger, flag_name )
{
	trigger endon( "death" );

	flag = trigger get_trigger_flag(flag_name);
	if( !IsDefined( level.flag[flag] ) )
	{
		flag_init( flag );
	}

	for( ;; )
	{
		trigger trigger_wait();

		if ( IsDefined( trigger.targetname ) && ( trigger.targetname == "flag_clear" ) )
		{
			// this is a "flag_clear" trigger so support script_delay
			// generic triggers don't use script_dealy for flag clearing because the
			// script_delay might be intended for something else

			trigger script_delay();
		}

		flag_clear( flag );
	}
}

add_tokens_to_trigger_flags( tokens )
{
	for( i = 0; i < tokens.size; i++ )
	{
		flag = tokens[i];
		if( !IsDefined( level.trigger_flags[flag] ) )
		{
			level.trigger_flags[flag] = [];
		}
		
		level.trigger_flags[flag][level.trigger_flags[flag].size] = self;
	}
}

script_flag_false_trigger( trigger )
{
	// all of these flags must be false for the trigger to be enabled
	tokens = create_flags_and_return_tokens( trigger.script_flag_false );
	trigger add_tokens_to_trigger_flags( tokens );
	trigger update_trigger_based_on_flags();
}

script_flag_true_trigger( trigger )
{
	// all of these flags must be false for the trigger to be enabled
	tokens = create_flags_and_return_tokens( trigger.script_flag_true );
	trigger add_tokens_to_trigger_flags( tokens );
	trigger update_trigger_based_on_flags();
}

/*
	for( ;; )
	{
		trigger trigger_on();
		wait_for_flag( tokens );
		
		trigger trigger_off();
		wait_for_flag( tokens );
		for( i = 0; i < tokens.size; i++ )
		{
			flag_wait( tokens[i] );
		}
	}
	*/


/*
script_flag_true_trigger( trigger )
{
	// any of these flags have to be true for the trigger to be enabled
	tokens = create_flags_and_return_tokens( trigger.script_flag_true );

	for( ;; )
	{
		trigger trigger_off();
		wait_for_flag( tokens );
		trigger trigger_on();
		for( i = 0; i < tokens.size; i++ )
		{
			flag_waitopen( tokens[i] );
		}
	}
}
*/

wait_for_flag( tokens )
{
	for( i = 0; i < tokens.size; i++ )
	{
		level endon( tokens[i] );
	}
	level waittill( "foreverrr" );
}

friendly_respawn_trigger( trigger )
{
	spawners = GetEntArray( trigger.target, "targetname" );
	assert( spawners.size == 1, "friendly_respawn_trigger targets multiple spawner with targetname " + trigger.target + ". Should target just 1 spawner." );
	spawner = spawners[0];
	assert( !IsDefined( spawner.script_forcecolor ), "targeted spawner at " + spawner.origin + " should not have script_forcecolor set!" );
	spawners = undefined;
	
	spawner endon( "death" );
	
	for( ;; )
	{
		trigger waittill( "trigger" );
		
		// SRS 12/20/2007: updated to allow for multiple color chains to be reinforced from different areas
		if( IsDefined( trigger.script_forcecolor ) )
		{
			level.respawn_spawners_specific[trigger.script_forcecolor] = spawner;
		}
		else
		{
			level.respawn_spawner = spawner;
		}
		flag_set( "respawn_friendlies" );
		wait( 0.5 );
	}
}

friendly_respawn_clear( trigger )
{
	for( ;; )
	{
		trigger waittill( "trigger" );
		flag_clear( "respawn_friendlies" );
		wait( 0.5 );
	}
}

//radio_trigger( trigger )
//{
//	trigger waittill( "trigger" );
//	radio_dialogue( trigger.script_noteworthy );
//}

trigger_ignore( trigger )
{
	thread trigger_runs_function_on_touch( trigger, ::set_ignoreme, ::get_ignoreme );
}

trigger_pacifist( trigger )
{
	thread trigger_runs_function_on_touch( trigger, ::set_pacifist, ::get_pacifist );
}

trigger_runs_function_on_touch( trigger, set_func, get_func )
{
	for( ;; )
	{
		trigger waittill( "trigger", other );
		if( !IsAlive( other ) )
		{
			continue;
		}

		if( other[[get_func]]() )
		{
			continue;
		}
		other thread touched_trigger_runs_func( trigger, set_func );
	}
}

touched_trigger_runs_func( trigger, set_func )
{
	self endon( "death" );
	self.ignoreme = true;
	[[set_func]]( true );
	// so others can touch the trigger
	self.ignoretriggers = true;
	wait( 1 );
	self.ignoretriggers = false;
	
	while( self IsTouching( trigger ) )
	{
		wait( 1 );
	}
	
	[[set_func]]( false );
}

trigger_turns_off( trigger )
{
	trigger trigger_wait();
	trigger trigger_off();
	
	if( !IsDefined( trigger.script_linkTo ) )
	{
		return;
	}
	
	// also turn off all triggers this trigger links to
	tokens = Strtok( trigger.script_linkto, " " );
	for( i = 0; i < tokens.size; i++ )
	{
		array_thread( GetEntArray( tokens[i], "script_linkname" ), ::trigger_off );
	}
}

/#
script_gen_dump_checksaved()
{
	signatures = GetArrayKeys( level.script_gen_dump );
	for( i = 0; i < signatures.size; i++ )
	{
		if( !IsDefined( level.script_gen_dump2[signatures[i]] ) )
	 	{
			level.script_gen_dump[signatures[i]] = undefined;
			level.script_gen_dump_reasons[level.script_gen_dump_reasons.size] = "Signature unmatched( removed feature ): "+signatures[i];
		}
	}
}

script_gen_dump()
{
	//initialize scriptgen dump

	script_gen_dump_checksaved(); // this checks saved against fresh, if there is no matching saved value then something has changed and the dump needs to happen again.
	
	if( !level.script_gen_dump_reasons.size )
	{
		flag_set( "scriptgen_done" );
		return; // there's no reason to dump the file so exit
	}
	
	firstrun = false;
	if( level.bScriptgened )
	{
		println( " " );
		println( " " );
		println( " " );
		println( "^2----------------------------------------" );
		println( "^3Dumping scriptgen dump for these reasons" );
		println( "^2----------------------------------------" );
		for( i = 0; i < level.script_gen_dump_reasons.size; i++ )
		{
			if( IsSubStr( level.script_gen_dump_reasons[i], "nowrite" ) )
			{
				substr = GetSubStr( level.script_gen_dump_reasons[i], 15 ); // I don't know why it's 15, maybe investigate -nate
				println( i+". ) "+substr );
				
			}
			else
			{
				println( i+". ) "+level.script_gen_dump_reasons[i] );
				if( level.script_gen_dump_reasons[i] == "First run" )
				{
					firstrun = true;
				}
			}
		}
		println( "^2----------------------------------------" );
		println( " " );
		if( firstrun )
		{
			println( "for First Run make sure you delete all of the vehicle precache script calls, createart calls, createfx calls( most commonly placed in maps\\"+level.script+"_fx.gsc ) " );
			println( " " );
			println( "replace:" );
			println( "maps\\\_load::main( 1 ); " );
			println( " " );
			println( "with( don't forget to add this file to P4 ):" );
			println( "maps\\scriptgen\\"+level.script+"_scriptgen::main(); " );
			println( " " );
		}
//		println( "make sure this is in your "+level.script+".csv:" );
//		println( "rawfile, maps/scriptgen/"+level.script+"_scriptgen.gsc" );
		println( "^2----------------------------------------" );
		println( " " );
		println( "^2/\\/\\/\\" );
		println( "^2scroll up" );
		println( "^2/\\/\\/\\" );
		println( " " );
	}
	else
	{
/*		println( " " );
		println( " " );
		println( "^3for legacy purposes I'm printing the would be script here, you can copy this stuff if you'd like to remain a dinosaur:" );
		println( "^3otherwise, you should add this to your script:" );
		println( "^3maps\\\_load::main( 1 ); " );
		println( " " );
		println( "^3rebuild the fast file and the follow the assert instructions" );
		println( " " );
		
		*/
		return;
	}
	
	filename = "scriptgen/"+level.script+"_scriptgen.gsc";
	csvfilename = "zone_source/"+level.script+".csv";
	
	if( level.bScriptgened )
	{
		file = OpenFile( filename, "write" );
	}
	else
	{
		file = 0;
	}

	assert( file != -1, "File not writeable( check it and and restart the map ): " + filename );

	script_gen_dumpprintln( file, "//script generated script do not write your own script here it will go away if you do." );
	script_gen_dumpprintln( file, "main()" );
	script_gen_dumpprintln( file, "{" );
	script_gen_dumpprintln( file, "" );
	script_gen_dumpprintln( file, "\tlevel.script_gen_dump = []; " );
	script_gen_dumpprintln( file, "" );

	signatures = GetArrayKeys( level.script_gen_dump );
	for( i = 0; i < signatures.size; i++ )
	{
		if( !IsSubStr( level.script_gen_dump[signatures[i]], "nowrite" ) )
		{
		    script_gen_dumpprintln( file, "\t"+level.script_gen_dump[signatures[i]] );
		}
	}

	for( i = 0; i < signatures.size; i++ )
	{
        if( !IsSubStr( level.script_gen_dump[signatures[i]], "nowrite" ) )
	    {
	        script_gen_dumpprintln( file, "\tlevel.script_gen_dump["+"\""+signatures[i]+"\""+"] = "+"\""+signatures[i]+"\""+"; " );
	    }
		else
		{
			script_gen_dumpprintln( file, "\tlevel.script_gen_dump["+"\""+signatures[i]+"\""+"] = "+"\"nowrite\""+"; " );
		}
	}

	script_gen_dumpprintln( file, "" );
	
	keys1 = undefined;
	keys2 = undefined;
	// special animation threading to capture animtrees
	if( IsDefined( level.sg_precacheanims ) )
	{
		keys1 = GetArrayKeys( level.sg_precacheanims );
	}

	if( IsDefined( keys1 ) )
	{
		for( i = 0; i < keys1.size; i++ )
		{
			script_gen_dumpprintln( file, "\tanim_precach_"+keys1[i]+"(); " );
		}
	}

	
	script_gen_dumpprintln( file, "\tmaps\\\_load::main( 1, "+level.bCSVgened+", 1 ); " );
	script_gen_dumpprintln( file, "}" );
	script_gen_dumpprintln( file, "" );
	
	/// animations section
	
//	level.sg_precacheanims[animtree][animation]
	if( IsDefined( level.sg_precacheanims ) )
	{
		keys1 = GetArrayKeys( level.sg_precacheanims );
	}

	if( IsDefined( keys1 ) )
	{
		for( i = 0; i < keys1.size; i++ )
		{
			//first key being the animtree
			script_gen_dumpprintln( file, "#using_animtree( \""+keys1[i]+"\" ); " );
			script_gen_dumpprintln( file, "anim_precach_"+keys1[i]+"()" );  // adds to scriptgendump
			script_gen_dumpprintln( file, "{" );
			script_gen_dumpprintln( file, "\tlevel.sg_animtree[\""+keys1[i]+"\"] = #animtree; " );  // adds to scriptgendump get the animtree without having to put #using animtree everywhere.
	
			keys2 = GetArrayKeys( level.sg_precacheanims[keys1[i]] );
			if( IsDefined( keys2 ) )
			{
			    for( j = 0; j < keys2.size; j++ )
		        {
				    script_gen_dumpprintln( file, "\tlevel.sg_anim[\""+keys2[j]+"\"] = %"+keys2[j]+"; " );  // adds to scriptgendump
				}
			}
			script_gen_dumpprintln( file, "}" );
			script_gen_dumpprintln( file, "" );
		}
	}
	
	
	if( level.bScriptgened )
	{
		saved = Closefile( file );
	}
	else
	{
		saved = 1;  //dodging save for legacy levels
	}
	
	//CSV section
		
	if( level.bCSVgened )
	{
		csvfile = OpenFile( csvfilename, "write" );
	}
	else
	{
		csvfile = 0;
	}
	
	assert( csvfile != -1, "File not writeable( check it and and restart the map ): " + csvfilename );
	
	signatures = GetArrayKeys( level.script_gen_dump );
	for( i = 0; i < signatures.size; i++ )
	{
		script_gen_csvdumpprintln( csvfile, signatures[i] );
	}

	if( level.bCSVgened )
	{
		csvfilesaved = Closefile( csvfile );
	}
	else
	{
		csvfilesaved = 1; //dodging for now
	}

	// check saves
		
	assert( csvfilesaved == 1, "csv not saved( see above message? ): " + csvfilename );
	assert( saved == 1, "map not saved( see above message? ): " + filename );

		
	//level.bScriptgened is not set on non scriptgen powered maps, keep from breaking everything
	assert( !level.bScriptgened, "SCRIPTGEN generated: follow instructions listed above this error in the console" );
	if( level.bScriptgened )
	{
		assertmsg( "SCRIPTGEN updated: Rebuild fast file and run map again" );
	}
		
	flag_set( "scriptgen_done" );
	
}


script_gen_csvdumpprintln( file, signature )
{
	
	prefix = undefined;
	writtenprefix = undefined;
	path = "";
	extension = "";
	
	
	if( IsSubStr( signature, "ignore" ) )
	{
		prefix = "ignore";
	}
	else if( IsSubStr( signature, "col_map_sp" ) )
	{
		prefix = "col_map_sp";
	}
	else if( IsSubStr( signature, "gfx_map" ) )
	{
		prefix = "gfx_map";
	}
	else if( IsSubStr( signature, "rawfile" ) )
	{
		prefix = "rawfile";
	}
	else if( IsSubStr( signature, "sound" ) )
	{
		prefix = "sound";
	}
	else if( IsSubStr( signature, "xmodel" ) )
	{
		prefix = "xmodel";
	}
	else if( IsSubStr( signature, "xanim" ) )
	{
		prefix = "xanim";
	}
	else if( IsSubStr( signature, "item" ) )
	{
		prefix = "item";
		writtenprefix = "weapon";
		path = "sp/";
	}
	else if( IsSubStr( signature, "fx" ) )
	{
		prefix = "fx";
	}
	else if( IsSubStr( signature, "menu" ) )
	{
		prefix = "menu";
		writtenprefix = "menufile";
		path = "ui/scriptmenus/";
		extension = ".menu";
	}
	else if( IsSubStr( signature, "rumble" ) )
	{
		prefix = "rumble";
		writtenprefix = "rawfile";
		path = "rumble/";
	}
	else if( IsSubStr( signature, "shader" ) )
	{
		prefix = "shader";
		writtenprefix = "material";
	}
	else if( IsSubStr( signature, "shock" ) )
	{
		prefix = "shock";
		writtenprefix = "rawfile";
		extension = ".shock";
		path = "shock/";
	}
	else if( IsSubStr( signature, "string" ) )
	{
		prefix = "string";
		assertmsg( "string not yet supported by scriptgen" );  // I can't find any instances of string files in a csv, don't think we've enabled localization yet
	}
	else if( IsSubStr( signature, "turret" ) )
	{
		prefix = "turret";
		writtenprefix = "weapon";
		path = "sp/";
	}
	else if( IsSubStr( signature, "vehicle" ) )
	{
		prefix = "vehicle";
		writtenprefix = "rawfile";
		path = "vehicles/";
	}
	
	
/*
sg_PrecacheVehicle( vehicle )
*/

		
	if( !IsDefined( prefix ) )
	{
		return;
	}

	if( !IsDefined( writtenprefix ) )
	{
		string = prefix+", "+GetSubStr( signature, prefix.size+1, signature.size );
	}
	else
	{
		string = writtenprefix+", "+path+GetSubStr( signature, prefix.size+1, signature.size )+extension;
	}

	
	/*
	ignore, code_post_gfx
	ignore, common
	col_map_sp, maps/nate_test.d3dbsp
	gfx_map, maps/nate_test.d3dbsp
	rawfile, maps/nate_test.gsc
	sound, voiceovers, rallypoint, all_sp
	sound, us_battlechatter, rallypoint, all_sp
	sound, ab_battlechatter, rallypoint, all_sp
	sound, common, rallypoint, all_sp
	sound, generic, rallypoint, all_sp
	sound, requests, rallypoint, all_sp
*/

	// printing to file is optional
	if( file == -1 || !level.bCSVgened )
	{
		println( string );
	}
	else
	{
		FPrintLn( file, string );
	}
}

script_gen_dumpprintln( file, string )
{
	// printing to file is optional
	if( file == -1 || !level.bScriptgened )
	{
		println( string );
	}
	else
	{
		FPrintLn( file, string );
	}
}
#/
	
trigger_hInt( trigger )
{
	assert( IsDefined( trigger.script_hint ), "Trigger_hint at " + trigger.origin + " has no .script_hint" );
	trigger endon( "death" );
	
	if( !IsDefined( level.displayed_hints ) )
	{
		level.displayed_hints = [];
	}
	// give level script a chance to set the hint string and optional boolean functions on this hint
	waittillframeend;

	hint = trigger.script_hint;
	assert( IsDefined( level.trigger_hint_string[hint] ), "Trigger_hint with hint " + hint + " had no hint string assigned to it. Define hint strings with add_hint_string()" );
	trigger waittill( "trigger", other );
	assert( IsPlayer( other ), "Tried to do a trigger_hint on a non player entity" );
	
	if( IsDefined( level.displayed_hints[hint] ) )
	{
			return;
	}
	level.displayed_hints[hint] = true;
	
	display_hInt( hint );
}

throw_grenade_at_player_trigger( trigger )
{
	trigger endon( "death" );
	
	trigger waittill( "trigger" );

	ThrowGrenadeAtPlayerASAP();
}

flag_on_cleared( trigger )
{
	flag = trigger get_trigger_flag();
	
	if( !IsDefined( level.flag[flag] ) )
	{
		flag_init( flag );
	}
	
	for( ;; )
	{
		trigger waittill( "trigger" );
		wait( 1 );
		if( trigger found_toucher() )
		{
			continue;
		}

		break;
	}
	
	flag_set( flag );
}

found_toucher()
{
	ai = GetAiArray( "axis" );
	for( i = 0; i < ai.size; i++ )
	{
		guy = ai[i];
		if( !IsAlive( guy ) )
		{
			continue;
		}
			
		if( guy IsTouching( self ) )
		{
			return true;
		}

		// spread the touches out over time
		wait( 0.1 );
	}
	
	// couldnt find any touchers so do a single frame complete check just to make sure
	
	ai = GetAiArray( "axis" );
	for( i = 0; i < ai.size; i++ )
	{
		guy = ai[i];
		if( guy IsTouching( self ) )
		{
			return true;
		}
	}
	
	return false;
}

trigger_delete_on_touch( trigger )
{
	for( ;; )
	{
		trigger waittill( "trigger", other );
		if( IsDefined( other ) )
		{
			// might've been removed before we got it
			other Delete();
		}
	}
}


flag_set_touching( trigger )
{
	flag = trigger get_trigger_flag();
	
	if( !IsDefined( level.flag[flag] ) )
	{
		flag_init( flag );
	}
	
	for( ;; )
	{
		trigger waittill( "trigger", other );
		flag_set( flag );
		while( IsAlive( other ) && other IsTouching( trigger ) && IsDefined( trigger ) )
		{
			wait( 0.25 );
		}
		flag_clear( flag );
	}
}

/*
rpg_aim_assist()
{
	level.player endon( "death" );
	for( ;; )
	{
		level.player waittill( "weapon_fired" );
		currentweapon = level.player GetCurrentWeapon();
		if( ( currentweapon == "rpg" ) ||( currentweapon == "rpg_player" ) )
		{
			thread rpg_aim_assist_attractor();
		}
	}
}

rpg_aim_assist_attractor()
{
	
	// Trace to where the player is looking
	start = level.player GetEye();
	direction = level.player GetPlayerAngles();
	coord = BulletTrace( start, start + VectorScale( AnglesToForward( direction ), 15000 ), true, level.player )["position"];
	
	thread draw_line_for_time( level.player.origin, coord, 1, 0, 0, 10000 );
	
	
	attractor = missile_createAttractorOrigin( coord, 10000, 3000 );
	wait( 3.0 );
	missile_deleteAttractor( attractor );
}
*/

add_nodes_mins_maxs( nodes )
{
	for( index = 0; index < nodes.size; index++ )
	{
		origin = nodes[index].origin;

		level.nodesMins = expandMins( level.nodesMins, origin );
		level.nodesMaxs = expandMaxs( level.nodesMaxs, origin );
	}
}

calculate_map_center()
{
	//GLocke( 5/14 ) -- Do not compute and set the map center if the level script has already done so.
	if( !IsDefined( level.mapCenter ) )
	{
		level.nodesMins = ( 0, 0, 0 );
		level.nodesMaxs = ( 0, 0, 0 );
	
		// grab all of the path nodes in the level and use them to determine the
		// the center of the playable map
		nodes = GetAllNodes();

		if( IsDefined( nodes[0] ) )
		{
			level.nodesMins = nodes[0].origin;
			level.nodesMaxs = nodes[0].origin;
		}
	
		add_nodes_mins_maxs( nodes );
	
		level.mapCenter = findBoxCenter( level.nodesMins, level.nodesMaxs );
		
		/#
			println( "map center: ", level.mapCenter );
		#/

		SetMapCenter( level.mapCenter );
	}
}


SetObjectiveTextColors()
{
	// The darker the base color, the more-readable the text is against a stark-white backdrop.
	// However; this sacrifices the "white-hot"ness of the text against darker backdrops.

	MY_TEXTBRIGHTNESS_DEFAULT = "1.0 1.0 1.0";
	MY_TEXTBRIGHTNESS_90 = "0.9 0.9 0.9";
	MY_TEXTBRIGHTNESS_85 = "0.85 0.85 0.85";

	if( level.script == "armada" )
	{
		SetSavedDvar( "con_typewriterColorBase", MY_TEXTBRIGHTNESS_90 );
		return;
	}

	SetSavedDvar( "con_typewriterColorBase", MY_TEXTBRIGHTNESS_DEFAULT );
}

get_script_linkto_targets()
{
	targets = [];
	if( !IsDefined( self.script_linkto ) )
	{
		return targets;
	}
		
	tokens = Strtok( self.script_linkto, " " );
	for( i = 0; i < tokens.size; i++ )
	{
		token = tokens[i];
		target = GetEnt( token, "script_linkname" );
		if( IsDefined( target ) )
		{
			targets[targets.size] = target;
		}
	}
	return targets;
}

delete_link_chain( trigger )
{
	// deletes all entities that it script_linkto's, and all entities that entity script linktos, etc.
	trigger waittill( "trigger" );

	targets = trigger get_script_linkto_targets();
	array_thread( targets, ::delete_links_then_self );
}

delete_links_then_self()
{
	targets = get_script_linkto_targets();
	array_thread( targets, ::delete_links_then_self );
	self Delete();
}

defer_vision_set_naked(vision, time)
{
	if(NumRemoteClients())
	{
		wait_network_frame();
	}
	
	self VisionSetNaked( vision, time );
}

/*
	A depth trigger that sets fog
*/
trigger_fog( trigger )
{
	trigger endon( "death" );

	dofog = true;
	if( !IsDefined( trigger.script_start_dist ) )
	{
		dofog = false;
	}

	if( !IsDefined( trigger.script_halfway_dist ) )
	{
		dofog = false;
	}

	if( !IsDefined( trigger.script_halfway_height ) )
	{
		dofog = false;
	}

	if( !IsDefined( trigger.script_base_height ) )
	{
		dofog = false;
	}

	if( !IsDefined( trigger.script_color ) )
	{
		dofog = false;
	}
	
	if( !IsDefined( trigger.script_color_scale ) )
	{
		dofog = false;
	}

	if( !IsDefined( trigger.script_transition_time  ) )
	{
		dofog = false;
	}
	
	if( !IsDefined( trigger.script_sun_color  ) )
	{
		dofog = false;
	}
	
	if( !IsDefined( trigger.script_sun_direction  ) )
	{
		dofog = false;
	}
	
	if( !IsDefined( trigger.script_sun_start_ang ) )
	{
		dofog = false;
	}
	
	if( !IsDefined( trigger.script_sun_stop_ang ) )
	{
		dofog = false;
	}
	
	if( !IsDefined( trigger.script_max_fog_opacity ) )
	{
		dofog = false;
	}

	do_sunsamplesize = false;
	sunsamplesize_time = undefined;
	if( IsDefined( trigger.script_sunsample ) )
	{
		do_sunsamplesize = false;
		trigger.lerping_dvar["sm_sunSampleSizeNear"] = false;

		sunsamplesize_time = 1;
		if( IsDefined( trigger.script_transition_time  ) )
		{
			sunsamplesize_time = trigger.script_sunsample_time;
		}

		if( IsDefined( trigger.script_sunsample_time ) )
		{
			sunsamplesize_time = trigger.script_sunsample_time;
		}
	}
	
	// loop forever, waittill player is in trigger and do fog and vision file changes
	for( ;; )
	{
		trigger waittill( "trigger", other );
		assert( IsPlayer( other ), "Non-player entity touched a trigger_fog." );
		
		wait( 0.05 );
		
		players = get_players();
		
		for(i = 0; i < players.size; i ++)
		{
			player = players[i];
			
			if(player istouching(trigger))
			{
				if( !IsSplitscreen() )
				{
					if( dofog && ( !isdefined(player.fog_trigger_current) || player.fog_trigger_current != trigger ))
					{
						player SetVolFog( trigger.script_start_dist,
											 				trigger.script_halfway_dist,
											 				trigger.script_halfway_height,
											 				trigger.script_base_height,
											 				trigger.script_color[0],
											 				trigger.script_color[1],
											 				trigger.script_color[2],
											 				trigger.script_color_scale,
											 				trigger.script_sun_color[0],
											 				trigger.script_sun_color[1],
											 				trigger.script_sun_color[2],
											 				trigger.script_sun_direction[0],
											 				trigger.script_sun_direction[1],
											 				trigger.script_sun_direction[2],
											 				trigger.script_sun_start_ang,
											 				trigger.script_sun_stop_ang,
											 				trigger.script_transition_time,
											 				trigger.script_max_fog_opacity );
					}
				}
		
				if( (IsDefined( trigger.script_vision ) && IsDefined( trigger.script_vision_time )) && ( !isdefined(player.fog_trigger_current) || player.fog_trigger_current != trigger ) )
				{
					player thread defer_vision_set_naked(trigger.script_vision, trigger.script_vision_time);
				}
				
				player.fog_trigger_current = trigger;
				
			}
		}
		
		// Non coop settings only
		players = get_players();
		if( players.size > 1 )
		{
			if( do_sunsamplesize )
			{
				dvar = "sm_sunSampleSizeNear";
				if( !trigger.lerping_dvar[dvar] && GetDvar( dvar ) != trigger.script_sunsample )
				{
					level thread lerp_trigger_dvar_value( trigger, dvar, trigger.script_sunsample, sunsamplesize_time );
				}
			}
		}
	}
}

lerp_trigger_dvar_value( trigger, dvar, value, time )
{
	trigger.lerping_dvar[dvar] = true;
	steps = time * 20;
	curr_value = GetDvarFloat( dvar );
	diff = ( curr_value - value ) / steps;
	
	for( i = 0; i < steps; i++ )
	{
		curr_value = curr_value - diff;
		SetSavedDvar( dvar, curr_value );
		wait( 0.05 );
	}
	
	SetSavedDvar( dvar, value );
	trigger.lerping_dvar[dvar] = false;
}

set_fog_progress( progress )
{
	anti_progress = 1 - progress;
	startdist = self.script_start_dist * anti_progress + self.script_start_dist * progress;
	halfwayDist = self.script_halfway_dist * anti_progress + self.script_halfway_dist * progress;
	color = self.script_color * anti_progress + self.script_color * progress;
	
	SetVolFog( startdist, halfwaydist, self.script_halfway_height, self.script_base_height, color[0], color[1], color[2], 0.4 );
}

remove_level_first_frame()
{
	wait( 0.05 );
	level.first_frame = undefined;
}

no_crouch_or_prone_think( trigger )
{
	for( ;; )
	{
		trigger waittill( "trigger", other );

		if( !IsPlayer( other ) )
		{
			continue;
		}

		while( other IsTouching( trigger ) )
		{
			other AllowProne( false );
			other AllowCrouch( false );
			wait( 0.05 );
		}

		other AllowProne( true );
		other AllowCrouch( true );
	}
}

no_prone_think( trigger )
{
	for( ;; )
	{
		trigger waittill( "trigger", other );

		if( !IsPlayer( other ) )
		{
			continue;
		}

		while( other IsTouching( trigger ) )
		{
			other AllowProne( false );
			wait( 0.05 );
		}

		other AllowProne( true );
	}
}

/#
ascii_logo()
{
	println( "Call Of Duty 7" );
}
#/

check_flag_for_stat_tracking( msg )
{
	if( !is_prefix( msg, "aa_" ) )
	{
		return;
	}
		
	[[level.sp_stat_tracking_func]]( msg );
}

precache_script_models()
{
	if( !IsDefined( level.scr_model ) )
	{
		return;
	}
	models = GetArrayKeys( level.scr_model );
	for( i = 0; i < models.size; i++ )
	{
		PrecacheModel( level.scr_model[models[i]] );
	}
}

player_death_detection()
{
	// a dvar starts high then degrades over time whenever the player dies,
	// checked from maps\_utility::player_died_recently()
	SetDvar( "player_died_recently", "0" );
	thread player_died_recently_degrades();

	level add_wait( ::flag_wait, "missionfailed" );
	self add_wait( ::waittill_msg, "death" );
	do_wait_any();
		
	recently_skill = [];
	recently_skill[0] = 70;
	recently_skill[1] = 30;
	recently_skill[2] = 0;
	recently_skill[3] = 0;
	
	SetDvar( "player_died_recently", recently_skill[level.gameskill] );
}

player_died_recently_degrades()
{
	for( ;; )
	{
		recent_death_time = GetDvarint( "player_died_recently" );
		if( recent_death_time > 0 )
		{
			recent_death_time -= 5;
			SetDvar( "player_died_recently", recent_death_time );
		}
		wait( 5 );
	}
}

all_players_connected()
{
	while(1)
	{
		num_con = getnumconnectedplayers();
		num_exp = getnumexpectedplayers();
		/#println( "all_players_connected(): getnumconnectedplayers=", num_con, "getnumexpectedplayers=", num_exp );#/
			
		if(num_con == num_exp && (num_exp != 0))
		{
			flag_set( "all_players_connected" );
	        // CODER_MOD: GMJ (08/28/08): Setting dvar for use by code
	        SetDvar( "all_players_are_connected", "1" );
			return;
		}

		wait( 0.05 );
	}
}

all_players_spawned()
{
	flag_wait( "all_players_connected" );
	waittillframeend; // We need to make sure the clients actually get setup before we can do things to them.

	while(1)
	{
		players = get_players();

		count = 0;
		for( i = 0; i < players.size; i++ )
		{
			if( players[i].sessionstate == "playing" )
			{
				count++;
			}
		}

		if( count == players.size )
		{
			break;
		}

		wait( 0.05 );
	}

	flag_set( "all_players_spawned" );
}

// MikeD (6/24/2008): This handles what placed weapons to keep depending on the amount of players in the game
adjust_placed_weapons()
{
	weapons = GetEntArray( "placed_weapon", "targetname" );

	flag_wait( "all_players_connected" );

	players = get_players();
	player_count = players.size;

	for( i = 0; i < weapons.size; i++ )
	{
		if( IsDefined( weapons[i].script_player_min ) && player_count < weapons[i].script_player_min )
		{
			weapons[i] Delete();
		}
	}
	
}

// BB (4.28.09): For AI awareness of explodables
explodable_volume()
{
	self thread explodable_volume_think();

	exploder = GetEnt(self.target, "targetname");
	if (IsDefined(exploder) && IsDefined(exploder.script_exploder))
	{
		level waittill("exploder" + exploder.script_exploder);
	}
	else
	{
		exploder waittill("exploding");
	}

	self Delete();
}

explodable_volume_think()
{
	assert(IsDefined(self.target), "Explodable Volume must be targeting an exploder or an explodable object.");

	target = GetEnt(self.target, "targetname");
	assert(IsDefined(target), "Explodable Volume has an invalid target.");

	if (IsDefined(target.remove))
	{
		target = target.remove;
	}

	self._explodable_target = target;

	while (true)
	{
		self waittill("trigger", ent);
		ent thread explodable_volume_ent_think(self, target);
		wait .5;
	}
}

explodable_volume_ent_think(volume, target)
{
	if (!IsDefined(self._explodable_volumes))
	{
		self._explodable_volumes = [];
	}
	
	if (IsInArray(self._explodable_volumes, volume))
	{
		return; // already handling this volume for this entity
	}
	
	if (!IsDefined(self._explodable_targets))
	{
		self._explodable_targets = [];
	}

	ARRAY_ADD(self._explodable_volumes, volume);
	ARRAY_ADD(self._explodable_targets, target);

	while (IsAlive(self) && IsDefined(volume) && self IsTouching(volume))
	{
		wait .5;
	}

	if (IsDefined(self))
	{
		ArrayRemoveValue(self._explodable_volumes, volume);
		ArrayRemoveValue(self._explodable_targets, target);
	}
}


// SJ ( 2/15/2010 ) Updates script_forcespawn KVP based on the SPAWNFLAG_ACTOR_SCRIPTFORCESPAWN
// flag for later use in _spawner and other functions of the script
update_script_forcespawn_based_on_flags() // self = spawner
{
	spawners = GetSpawnerArray();

	for( i = 0; i < spawners.size; i++ )
	{
		if( spawners[i] has_spawnflag( SPAWNFLAG_ACTOR_SCRIPTFORCESPAWN ) )
		{
			spawners[i].script_forcespawn = 1;
		}
	}
}

trigger_once( trig )
{
	trig endon( "death" );
	
	if ( is_look_trigger( trig ) )
	{
		trig waittill( "trigger_look" );
	}
	else
	{
		trig waittill( "trigger" );
	}
	
	waittillframeend;
	waittillframeend;

	if ( IsDefined( trig ) )
	{
/#
		println( "" );
		println( "*** trigger debug: deleting trigger with ent#: " + trig getentitynumber() + " at origin: " + trig.origin );
		println( "" );
#/

		trig Delete();
	}
}