#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\debug_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

//REGISTER SHARED SYSTEMS - DO NOT REMOVE
#using scripts\shared\doors_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\exploder_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\player_shared;

#using scripts\shared\vehicles\_raps;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace load;

function autoexec __init__sytem__() {     system::register("load",&__init__,undefined,undefined);    }

function __init__()
{
	/#
	
	level thread t7_cleanup_output();
	level thread level_notify_listener();
	level thread client_notify_listener();
	level thread save_game_on_notify();
	level thread first_frame();
		
	#/

	if ( SessionModeIsCampaignGame() )
	{
		level.game_mode_suffix = "_cp";
	}
	else if ( SessionModeIsZombiesGame() )
	{
		level.game_mode_suffix = "_zm";
	}
	else
	{
		level.game_mode_suffix = "_mp";
	}
	
	level.script = Tolower( GetDvarString( "mapname" ) );
		
	level.clientscripts = ( GetDvarString( "cg_usingClientScripts") != "" );
	
	level.campaign = "american";	// TODO T7: some scripts are using this but this should probably go away
	
	//TODO T7 remove level.clientscripts init in MP/ZM once they get a T7 pass
	level.clientscripts = ( GetDvarString( "cg_usingClientScripts" ) != "" );
	
	level flag::init( "all_players_connected" );
	level flag::init( "all_players_spawned" );
	level flag::init( "first_player_spawned" );
	
	if(!isdefined(level.timeofday))level.timeofday="day"; // time of day, used for client side night specific FX

	if ( GetDvarString( "scr_RequiredMapAspectratio" ) == "" )
	{
		SetDvar( "scr_RequiredMapAspectratio", "1" );
	}
	
	// AE 10-29-09: added this to turn off the water fog
	SetDvar( "r_waterFogTest", 0 );
	SetDvar( "tu6_player_shallowWaterHeight", "0.0" );
	
	util::registerClientSys( "levelNotify" ); // register client system for ClientNotify
	
	level thread all_players_spawned();
	
	callback::on_spawned( &on_spawned );
		
	self thread playerDamageRumble();
		
	array::thread_all( GetEntArray( "water", "targetname" ), &water_think );	
	array::thread_all_ents( GetEntArray( "badplace", "targetname" ), &badplace_think );

	weapon_ammo();
	set_objective_text_colors();
}

/#
	
function first_frame()
{
	level.first_frame = true;
	{wait(.05);};
	level.first_frame = undefined;
}

function add_cleanup_msg( msg )
{
	if ( !isdefined( level.cleanup_msgs ) ) level.cleanup_msgs = []; else if ( !IsArray( level.cleanup_msgs ) ) level.cleanup_msgs = array( level.cleanup_msgs ); level.cleanup_msgs[level.cleanup_msgs.size]=msg;;
}

function t7_cleanup_output()
{
	level.cleanup_msgs = array( "1", "2", "3" );
	
	wait 1;
	PrintLn( "----------------------------- T7 Cleanup Summary -----------------------------" );
	foreach ( msg in level.cleanup_msgs )
	{
		PrintLn( "test" );
	}
	PrintLn( "-------------------------------------------------------------------------------" );
}

function level_notify_listener()
{
	while ( true )
	{
		val = GetDvarString( "level_notify" );
		
		if ( val != "" )
		{
			toks = StrTok( val, "," );
			
			if ( toks.size == 3 )
			{
				level notify( toks[0], toks[1], toks[2] );
			}
			else if ( toks.size == 2 )
			{
				level notify( toks[0], toks[1] );
			}
			else
			{
				level notify( toks[0] );
			}
			
			SetDvar( "level_notify", "" );
		}
		
		wait 0.2;
	}
}

function client_notify_listener()
{
	while(1)
	{
		
		val = GetDvarString( "client_notify");
		if(val != "")
		{
			util::clientNotify(val);
			SetDvar("client_notify", "");
		}
		wait(0.2);
	}
}

function save_game_on_notify()
{
	while (1)
	{
		level waittill("save");
		level.checkpoint_time = GetTime();

		//SaveGame("debug_save");//TODO T7 - just comment out for now until we know what is going on with save game
	}
}
#/

function weapon_ammo()
{
	ents = GetEntArray();
	for( i = 0; i < ents.size; i ++ )
	{
		if( ( isdefined( ents[i].classname ) ) &&( GetSubStr( ents[i].classname, 0, 7 ) == "weapon_" ) )
		{
			weap = ents[i];
			change_ammo = false;
			clip = undefined;
			extra = undefined;
				
			if( isdefined( weap.script_ammo_clip ) )
			{
				clip = weap.script_ammo_clip;
				change_ammo = true;
			}

			if( isdefined( weap.script_ammo_extra ) )
			{
				extra = weap.script_ammo_extra;
				change_ammo = true;
			}
			
			if( change_ammo )
			{
				if( !isdefined( clip ) )
				{
					assertmsg( "weapon: " + weap.classname + " " + weap.origin + " sets script_ammo_extra but not script_ammo_clip" );
				}

				if( !isdefined( extra ) )
				{
					assertmsg( "weapon: " + weap.classname + " " + weap.origin + " sets script_ammo_clip but not script_ammo_extra" );
				}
				weap ItemWeaponSetAmmo( clip, extra );
				weap ItemWeaponSetAmmo( clip, extra, 1 );
				
			}
		}
	}
}

function badplace_think( badplace )
{
	if( !isdefined( level.badPlaces ) )
	{
		level.badPlaces = 0;
	}
		
	level.badPlaces++;

	badplace_box( "badplace" + level.badPlaces, -1, badplace.origin, badplace.radius, "all" );
}

function playerDamageRumble()
{
	while( true )
	{
		self waittill( "damage", amount );

		if( isdefined( self.specialDamage ) )
		{
			continue;
		}
		
		self PlayRumbleOnEntity( "damage_heavy" );
	}
}

function map_is_early_in_the_game()
{
	/#
	if( isdefined( level.testmap ) )
	{
		return true;
	}
	#/
	
	/#
	if( !isdefined( level.early_level[level.script] ) )
	{
		level.early_level[level.script] = false;
	}
	#/
	
	return ( isdefined( level.early_level[level.script] ) && level.early_level[level.script] );
}

function player_throwgrenade_timer()
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
function player_special_death_hint()
{
	self endon( "disconnect" );

	self thread player_throwgrenade_timer(); // this thread used in coop also

	if( isSplitScreen() || util::coopGame() )
	{
		return;
	}

	// added an inflicter check
	self waittill( "death", attacker, cause, weapon, inflicter );
	
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

	if( cause == "MOD_EXPLOSIVE" )
	{
		// script_vehicle death hint/ also if the script is just manually a model swap instead of script vehicle
		if( isdefined( attacker ) && ( attacker.classname == "script_vehicle" || isdefined( attacker.create_fake_vehicle_damage ) ) )
        {
			level notify( "new_quote_string" );
			
			// You were killed by an exploding vehicle. Vehicles on fire are likely to explode.
			SetDvar( "ui_deadquote", "@SCRIPT_EXPLODING_VEHICLE_DEATH" );
			self thread explosive_vehice_death_indicator_hudelement();
			return;
		}

		
		
		// Destructible explosion death hints
		if( isdefined( inflicter ) && isdefined( inflicter.destructibledef ) )
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
			if( isdefined( inflicter.destructiblecar ) && inflicter.destructiblecar )
			{
				level notify( "new_quote_string" );
			
				// You were killed by an exploding vehicle. Vehicles on fire are likely to explode.
				SetDvar( "ui_deadquote", "@SCRIPT_EXPLODING_VEHICLE_DEATH" );
				self thread explosive_vehice_death_indicator_hudelement();
				return;
			}
			
		}
	}
	
	if( cause == "MOD_GRENADE" || cause == "MOD_GRENADE_SPLASH" )
	{
		if( !weapon.isTimedDetonation || !weapon.isGrenadeWeapon )
		{
			return;
		}

		level notify( "new_quote_string" );
		
		if (weapon.name == "explosive_bolt" )
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
}

function grenade_death_text_hudelement( textLine1, textLine2 )
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

	if( isdefined( textLine2 ) )
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

function grenade_death_indicator_hudelement()
{
	self endon( "disconnect" );
	wait( .5 );
	overlayIcon = NewClientHudElem( self );
	overlayIcon.x = 0;
	overlayIcon.y = 68;
	overlayIcon SetShader( "hud_grenadeicon_256", 50, 50 );
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


function explosive_arrow_death_indicator_hudelement()
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

function explosive_dart_death_indicator_hudelement()
{
	self endon( "disconnect" );
	wait( .5 );
	overlayIcon = NewClientHudElem( self );
	overlayIcon.x = 0;
	overlayIcon.y = 68;
	overlayIcon SetShader( "hud_monsoon_titus_arrow", 50, 50 );
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

function explosive_nitrogen_tank_death_indicator_hudelement()
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

function explosive_vehice_death_indicator_hudelement()
{
	self endon( "disconnect" );
	wait( .5 );
	overlayIcon = NewClientHudElem( self );
	overlayIcon.x = 0;
	overlayIcon.y = -10;
	overlayIcon SetShader( "hud_exploding_vehicles", 50, 50 );
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
//	overlayPointer.x = 0;
//	overlayPointer.y = 25;
//	overlayPointer SetShader( "hud_grenadepointer", 50, 25 );
//	overlayPointer.alignX = "center";
//	overlayPointer.alignY = "middle";
//	overlayPointer.horzAlign = "center";
//	overlayPointer.vertAlign = "middle";
//	overlayPointer.foreground = true;
//	overlayPointer.alpha = 0;
//	overlayPointer FadeOverTime( 1 );
//	overlayPointer.alpha = 1;
//	overlayPointer.hidewheninmenu = true;
	
	self thread grenade_death_indicator_hudelement_cleanup( overlayIcon, overlayPointer );
}

// CODE_MOD
function grenade_death_indicator_hudelement_cleanup( hudElemIcon, hudElemPointer )
{
	self endon( "disconnect" );
	self waittill( "spawned" );
		
	hudElemIcon Destroy();
	hudElemPointer Destroy();
}

function special_death_indicator_hudelement( shader, iWidth, iHeight, fDelay, x, y )
{
	if( !isdefined( fDelay ) )
	{
		fDelay = 0.5;
	}

	wait( fDelay );
	overlay = NewClientHudElem( self );
	
	if( isdefined( x ) )
		overlay.x = x;
	else
		overlay.x = 0;

	if( isdefined( y ) )
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

function special_death_death_indicator_hudelement_cleanup( overlay )
{
	self endon( "disconnect" );
	self waittill( "spawned" );
		
	overlay Destroy();
}


// SCRIPTER_MOD
// MikeD( 3/16/2007 ) TODO: Test this feature
function water_think()
{
	assert( isdefined( self.target ) );
	targeted = GetEnt( self.target, "targetname" );
	assert( isdefined( targeted ) );
	waterHeight = targeted.origin[2];
	targeted = undefined;
	
	level.depth_allow_prone = 8;
	level.depth_allow_crouch = 33;
	level.depth_allow_stand = 50;
	
	
	while ( true )
	{
		{wait(.05);};
		//restore all defaults
		players = GetPlayers();
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
			players = GetPlayers();

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

		{wait(.05);};
	}
	
}

function indicate_start( start )
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

function calculate_map_center()
{
	// Do not compute and set the map center if the level script has already done so.
	if ( !isdefined( level.mapCenter ) )
	{
		// grab all of the path nodes in the level and use them to determine the
		// the center of the playable map

		nodes = GetAllNodes();
		
		if ( isdefined( nodes[ 0 ] ) )
		{
			level.nodesMins = nodes[ 0 ].origin;
			level.nodesMaxs = nodes[ 0 ].origin;
		}
		else
		{
			level.nodesMins = ( 0, 0, 0 );
			level.nodesMaxs = ( 0, 0, 0 );
		}
		
		for ( index = 0; index < nodes.size; index++ )
		{
			if ( nodes[ index ].type == "BAD NODE" )
			{
				/#
					println( "Level has BAD NODE(s) - not included in map center calculations: ", nodes[ index ].origin );
				#/
				continue;
			}
			
			origin = nodes[ index ].origin;
	
			level.nodesMins = math::expand_mins( level.nodesMins, origin );
			level.nodesMaxs = math::expand_maxs( level.nodesMaxs, origin );
		}
	
		level.mapCenter = math::find_box_center( level.nodesMins, level.nodesMaxs );
		
		/#
			println( "map center: ", level.mapCenter );
		#/

		SetMapCenter( level.mapCenter );
	}
}


function set_objective_text_colors()
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

function lerp_trigger_dvar_value( trigger, dvar, value, time )
{
	trigger.lerping_dvar[dvar] = true;
	steps = time * 20;
	curr_value = GetDvarFloat( dvar );
	diff = ( curr_value - value ) / steps;
	
	for( i = 0; i < steps; i++ )
	{
		curr_value = curr_value - diff;
		SetSavedDvar( dvar, curr_value );
		{wait(.05);};
	}
	
	SetSavedDvar( dvar, value );
	trigger.lerping_dvar[dvar] = false;
}

function set_fog_progress( progress )
{
	anti_progress = 1 - progress;
	startdist = self.script_start_dist * anti_progress + self.script_start_dist * progress;
	halfwayDist = self.script_halfway_dist * anti_progress + self.script_halfway_dist * progress;
	color = self.script_color * anti_progress + self.script_color * progress;
	
	SetVolFog( startdist, halfwaydist, self.script_halfway_height, self.script_base_height, color[0], color[1], color[2], 0.4 );
}

/#
function ascii_logo()
{
	println( "Call Of Duty 7" );
}
#/

function all_players_spawned()
{
	level flag::wait_till( "all_players_connected" );
	waittillframeend; // We need to make sure the clients actually get setup before we can do things to them.

	while ( true )
	{
		if ( GetNumConnectedPlayers() == 0 )
		{
			// GetNumConnectedPlayers returns 0 when loading movie is playing
			// But the players spawn before the movie is done.  So wait here
			// until movie is done.
			{wait(.05);};
			continue;
		}
		
		players = GetPlayers();

		count = 0;
		for( i = 0; i < players.size; i++ )
		{
			if( players[i].sessionstate == "playing" )
			{
				count++;
			}
		}

		{wait(.05);};
		
		if ( count > 0 )
		{
			level flag::set( "first_player_spawned" );
		}

		if ( count == players.size )
		{
			break;
		}
	}

	level flag::set( "all_players_spawned" );
}

function shock_onpain()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon("killOnPainMonitor");
	

	if( GetDvarString( "blurpain" ) == "" )
	{
		SetDvar( "blurpain", "on" );
	}

	while( 1 )
	{
		oldhealth = self.health;
		self waittill( "damage", damage, attacker, direction_vec, point, mod );

		if( isdefined( level.shock_onpain ) && !level.shock_onpain )
		{
			continue;
		}

		if( isdefined( self.shock_onpain ) && !self.shock_onpain )
		{
			continue;
		}

		if( self.health < 1 )
		{
			continue;
		}

		if( mod == "MOD_PROJECTILE" )
		{
			continue;
		}
		else if( mod == "MOD_GRENADE_SPLASH" || mod == "MOD_GRENADE" ||  mod == "MOD_EXPLOSIVE" || mod == "MOD_PROJECTILE_SPLASH" )
		{
			self shock_onexplosion( damage );
		}
		else
		{
			if( GetDvarString( "blurpain" ) == "on" )
			{
				self ShellShock( "pain", 0.5 );
			}
		}
	}
}

function shock_onexplosion( damage )
{
	time = 0;

	multiplier = self.maxhealth / 100;
	scaled_damage = damage * multiplier;

	if( scaled_damage >= 90 )
	{
		time = 4;
	}
	else if( scaled_damage >= 50 )
	{
		time = 3;
	}
	else if( scaled_damage >= 25 )
	{
		time = 2;
	}
	else if( scaled_damage > 10 )
	{
		time = 1;
	}

	if( time )
	{
		//self ShellShock( "explosion", time ); // commented out for now to get around "explosion" not precached error -RMA
	}
}

function shock_ondeath()
{
	self waittill( "death" );

	if( isdefined( level.shock_ondeath ) && !level.shock_ondeath )
	{
		return;
	}

	if( isdefined( self.shock_ondeath ) && !self.shock_ondeath )
	{
		return;
	}

	if( isdefined( self.specialDeath ) )
	{
		return;
	}

	if( GetDvarString( "r_texturebits" ) == "16" )
	{
		return;
	}
	//self shellshock( "default", 3 );
}

function on_spawned()
{
	if( !isdefined( self.player_inited ) || !self.player_inited )
	{
		if( SessionModeIsCampaignGame() )
		{
			self thread shock_ondeath();
			self thread shock_onpain();
		}
		
		//self thread cheat::player_init();
		
		//self damagefeedback::player_init();		


		{wait(.05);};
		
		if ( isdefined( self ) )
		{
			self.player_inited = true;
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ART REVIEW - Set up the level to run for art/geo review (no event scripting) - should be called from load::main //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function art_review()
{
	if ( GetDvarString( "art_review" ) == "" )
	{
		SetDvar( "art_review", "0" );
	}
	
	if ( GetDvarString( "art_review" ) == "1" )
	{
		hud = hud::createServerFontString( "objective", 1.2 );
		hud hud::setPoint( "CENTER", "CENTER", 0, -200 );
		hud.sort = 1001;
		hud.color = ( 1, 0, 0 );
		hud SetText( "ART REVIEW" );
		hud.foreground = false;
		hud.hidewheninmenu = false;
		
		if ( SessionModeIsZombiesGame() )
		{
			SetDvar( "zombie_cheat", "2" );
			SetDvar( "zombie_devgui", "power_on" );
		}
		else
		{
			foreach ( trig in trigger::get_all() )
			{
				trig TriggerEnable( false );
			}
		}
		
		level waittill( "forever" );
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// !ART REVIEW                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
