#using scripts\codescripts\struct;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;

       
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\cp_mi_sing_blackstation;
#using scripts\cp\cp_mi_sing_blackstation_utility;

#using scripts\shared\ai\archetype_warlord_interface;

function main()
{
	level thread hendricks_warlord_fight_path();
	level thread enemy_all_dead();
	level thread lightning_qzone();
}

function lightning_qzone()
{
	level flag::wait_till( "all_players_spawned" );
	
	wait RandomFloatRange( 1.5, 2.5 );  //don't want lightning to strike right away
	
	level thread blackstation_utility::lightning_flashes( "lightning_qzone", "qzone_done" );
}

function vtol_intro()  //TODO - mocking up IGC; everything in this function is temp
{
	e_crate_air = GetEnt( "weapon_crate_air", "targetname" );
	e_crate_land = GetEnt( "weapon_crate_land", "targetname" );
	
	e_crate_land Hide();
	
	level.vh_vtol = vehicle::simple_spawn_single( "vtol_intro" );
		
	e_crate_air LinkTo( level.vh_vtol );
	
	level.a_e_org = GetEntArray( "vtol_pos", "targetname" );
	
	foreach( e_org in  level.a_e_org )
	{
		e_org LinkTo( level.vh_vtol );
	}
	
	e_hendricks_org = GetEnt( "vtol_hendricks", "targetname" );
	e_hendricks_org LinkTo( level.vh_vtol );
	
	level flag::set( "vtol_spawned" );
	
	level flag::wait_till( "all_players_spawned" );
	
	wait 0.1;  //allow time for all entities to link
	
	s_start = struct::get( "vtol_drop" );
	
	level.vh_vtol SetVehGoalPos( s_start.origin, 1 );
	level.vh_vtol SetSpeed( 25, 15, 5 );
	level.vh_vtol waittill( "goal" );
			
	wait 4;  //for pacing
	
	level flag::set( "vtol_jump" );
	
	e_crate_air Unlink();
	e_crate_air MoveTo( e_crate_land.origin, 3.5 );
	e_crate_air waittill( "movedone" );
	
	e_crate_air Delete();
	e_crate_land Show();
	
	level flag::set( "on_ground" );
	
	wait 2;  //allow time for player to jump out
	
	s_end = struct::get( "vtol_end" );
	
	level.vh_vtol SetVehGoalPos( s_end.origin, 0 );
	level.vh_vtol SetSpeed( 25, 15, 5 );
	level.vh_vtol waittill( "goal" );
	
	level.vh_vtol.delete_on_death = true;           level.vh_vtol notify( "death" );           if( !IsAlive( level.vh_vtol ) )           level.vh_vtol Delete();;
}

//TODO - temp until IGC added
function hendricks_igc()
{
	level flag::wait_till( "vtol_spawned" );
		
	e_org = GetEnt( "vtol_hendricks", "targetname" );
		
	level.ai_hendricks skipto::teleport_single_ai( e_org );
	level.ai_hendricks LinkTo( e_org );

	level flag::wait_till( "vtol_jump" );
	
	e_org Unlink();
	e_org MoveX( -150, 0.5 );
	e_org waittill( "movedone" );
	
	level.ai_hendricks Unlink();
	
	e_org Delete();
}

//TODO - temp until IGC added
function vtol_board()  //self = player
{
	self EnableInvulnerability();
	self SetClientUIVisibilityFlag( "hud_visible", 0 );
	self SetLowReady( true );
		
	level flag::wait_till( "vtol_spawned" );
	
	self.e_org = level.a_e_org[ self GetEntityNumber() ];
		
	self SetPlayerAngles( self.e_org.angles );
	
	self PlayerLinkTo( self.e_org, "tag_origin", 1, 45, 45, 60, 60 );
	
	self thread cp_mi_sing_blackstation::close_cacwaitmenu();
	
	level flag::wait_till( "vtol_jump" );
	
	wait 2;  //let Hendricks jump out first
	
	self.e_org Unlink();
	self.e_org MoveTo( struct::get( self.e_org.target, "targetname" ).origin, 1.5 );
	self.e_org waittill( "movedone" );
	
	self Unlink();
	
	self.e_org Delete();
	
	wait 2;  //give time for player to drop from VTOL
	
	self DisableInvulnerability();
	self SetClientUIVisibilityFlag( "hud_visible", 1 );
	self SetLowReady( false );

	self thread missile_launcher_equip_hint();
}

function missile_launcher_equip_hint() //self = player
{
	self endon( "death" );
	
	level flag::wait_till( "give_dni_weapon" );
	
	if ( !isdefined( self GetLUIMenu( "MissileLauncherEquipHint" ) ) ) 
	{
		self OpenLUIMenu( "MissileLauncherEquipHint" ); 
	}
	
	while( self GetCurrentWeapon() != GetWeapon( "micromissile_launcher" ) )  //wait for player to equip missile launcher
	{
			wait 0.1;
	}
	
	if ( isdefined( self GetLUIMenu( "MissileLauncherEquipHint" ) ) ) 
	{
		self CloseLUIMenu( self GetLUIMenu( "MissileLauncherEquipHint" ) ); 
	}
	
}

function dead_civilians()
{
	a_e_civs = GetEntArray( "qzone_civilian_body", "targetname" );
	foreach( e_corpse in a_e_civs )
	{
		e_corpse thread scene::play( e_corpse.script_noteworthy, e_corpse ); //Play a specific death pose on each corpse 
	}
}

function hendricks_qzone_path_igc()
{
	level flag::wait_till( "vtol_jump" );
	
	wait 6;  //wait for players to get weapons
	
	trigger::use( "trigger_hendricks_start" );
	
	level hendricks_qzone_path();
}

function hendricks_qzone_path()
{
	level flag::wait_till( "flag_hendricks_bodies" );
	
	//Let hendricks looks at the bodies for a few seconds or have him move if you run past the scene 
	level flag::wait_till_any_timeout( 3, Array( "flag_hendricks_advance_past_bodies" ) ); 
		
	trigger::use( "trigger_hendricks_color_trigger_b2" );
}

function hendricks_warlord_fight_path()
{
	level flag::wait_till( "warlord_backup" );  //set by "trigger_hendricks_warlord_dead" or "enemy_count_watcher()"
	
	trigger::use( "triggercolor_b6_warlord_fallback" ); 
	
	level flag::wait_till( "warlord_retreat" );  //set by "trigger_hendricks_wall_approach" or "enemy_count_watcher()"
	
	trigger::use( "triggercolor_b7_debriswall_approach" );
	
	level flag::wait_till( "qzone_done" );  //set by "trigger_anchor_intro" or "enemy_all_dead()"
	
	trigger::use( "triggercolor_b8_hendricks_wall_climb" ); 	
}

//TODO - temp VO
function vo_qzone()
{
	level flag::wait_till( "flag_hendricks_schoolhouse" );
	
	level.ai_hendricks dialog::say( "We have a blood trail here." );
	
	level flag::wait_till( "flag_hendricks_bodies" ); 
	
	level.ai_hendricks dialog::say( "Looks like a 54I execution." );
	
	level flag::wait_till( "flag_hendricks_street" );
	
	level.ai_hendricks dialog::say( "Kane, we have boots on the ground.");
	dialog::remote( "Confirmed, we have your team in the Q-Zone." );
	dialog::remote( "Satellite shows 54I looting the Black Station.  They're loading up equipment onto trucks." );
	level.ai_hendricks dialog::say( "Copy that.  We're on the move." );
	
}

function vo_warlord_intro()
{
	trigger::wait_till( "trigger_hendricks_warlord" );
	
	level.ai_hendricks dialog::say( "Contact up ahead.  Stay sharp!" );
	//level.ai_hendricks dialog::say( "Clear that debris and make a path." );
	
	level flag::wait_till( "debris_interact" );
	
	level.ai_hendricks thread dialog::say( "Form up on me." );
	
	level flag::set( "warlord_intro_prep" );
	
	level flag::wait_till( "warlord_fight" );
	
	level.ai_hendricks dialog::say( "Take these bastards out!" );
	
	level thread missile_launcher_hint();
}

function hendricks_warlord_fight()
{
	level flag::wait_till( "warlord_fight" );
	
	level.ai_hendricks ai::set_behavior_attribute( "cqb", false );
	
	nd_cover = GetNode( "cover_warlord_engage", "targetname" );
	
	level.ai_hendricks SetGoal( nd_cover );
	
	level thread shelter_blow_away();
}

function interact_warlord_intro()
{
//	trigger::wait_till( "trigger_hendricks_interact" );
//	
//	t_interact = GetEnt( "trigger_warlord_intro", "targetname" );
//	t_interact SetCursorHint( "HINT_NOICON" );
	
	level thread warlord_intro_debris();
	
//  TODO - disable for now...
//	v_offset = ( 0, 0, 0 );
//	visuals_use_object = [];
//	
//	e_object = gameobjects::create_use_object( "allies" , t_interact , visuals_use_object , v_offset , undefined );
//	
//	// Setup use object params
//	e_object gameobjects::set_use_hint_text( &"CP_MI_SING_BLACKSTATION_WARLORD_INTERACT" );
//	e_object gameobjects::set_visible_team( "any" );
//	e_object gameobjects::set_3d_icon( "friendly", "t7_hud_prompt_pickup_64" );	
//	
//	t_interact waittill( "trigger", player );
//	
//	player FreezeControls( true );
	
	trigger::wait_till( "trigger_warlord_igc" );
	
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypt_warlord_igc" ) );
	
	level flag::set( "debris_interact" );
	
//	e_object gameobjects::disable_object();
	
	level thread spawn_warlord_intro();
	
	level flag::wait_till( "warlord_intro_prep" );
	
	level thread warlord_intro_prep();
}

function warlord_intro_debris()  //TODO - disabling mostly since will probably delete interact
{
	e_blocker = GetEnt( "warlord_debris", "targetname" );
	e_blocker Delete();
	e_clip = GetEnt( "clip_warlord_debris", "targetname" );
	e_clip Delete();
//	e_blocker oed::enable_keyline( true );
	
	level flag::wait_till( "debris_interact" );
	
//	e_blocker oed::disable_keyline();
	
//	e_blocker MoveZ( 20, 1 );
//	e_blocker waittill( "movedone" );
	
//	wait 0.5;  //timing for throw
	
//	e_blocker MoveX( -450, 1 );
//	e_blocker waittill( "movedone" );
	
	level flag::set( "debris_clear" );
	
//	e_clip = GetEnt( "clip_warlord_debris", "targetname" );
//	e_clip Delete();
	
	trigger::use( "trigger_hendricks_debris" );
}

function warlord_intro_prep()
{
	level flag::wait_till( "debris_clear" );
	
	foreach( player in level.players )
	{
		player FreezeControls( true );
		player clientfield::increment_to_player( "postfx_igc", 1 );
	}
	
	util::screen_fade_out( 1 );
	
	a_e_orgs = GetEntArray( "warlord_intro_pos", "targetname" );
	
	foreach( player in level.players )
	{
		player.e_org = a_e_orgs[ player GetEntityNumber() ];
		
		player SetOrigin( player.e_org.origin );
		player SetPlayerAngles( player.e_org.angles );
		player PlayerLinkTo( player.e_org, "tag_origin", 1, 45, 45, 60, 60 );
		player SetLowReady( true );
	}
	
	wait 0.5;  //allow warlord to get into position
	
	util::screen_fade_in( 1 );
	
	foreach( player in level.players )
	{
		player clientfield::increment_to_player( "postfx_igc", 0 );
	}
	
	level flag::wait_till( "warlord_fight" );
	
	foreach( player in level.players )
	{
		player FreezeControls( false );
		player Unlink();
		player.e_org Delete();
		player SetLowReady( false );
	}
}

function spawn_warlord_intro()  //TODO - temp IGC stand-in
{
	ai_man = spawner::simple_spawn_single( "civ_man", &civ_spawn_func );
	ai_woman = spawner::simple_spawn_single( "civ_woman", &civ_spawn_func );
	ai_warlord = spawner::simple_spawn_single( "warlord_intro", &warlord_spawn_func, true );
	a_ai_guards = spawner::simple_spawn( "warlord_guard", &warlord_guard_spawn_func, true );
	
	ai_warlord thread warlord_death_watcher();
		
	level flag::wait_till( "warlord_intro_done" );
	
	ai_woman.e_org = Spawn( "script_origin", ai_woman.origin );
	ai_woman LinkTo( ai_woman.e_org );
	ai_woman.e_org MoveZ( 20, 2 );
	
	wait 4;  //allow "scene" to play out
	
	ai_woman util::stop_magic_bullet_shield();
	ai_woman Unlink();
	ai_woman.e_org Delete();
	ai_woman StartRagDoll();
	ai_woman LaunchRagDoll( ( 80, 0, 40 ) );
	ai_woman Kill();
	
	wait 1;  //give time for man to react before running away
	
	ai_man util::stop_magic_bullet_shield();
	ai_man SetGoal( struct::get( "head_popper_goal" ).origin, true );
	ai_man waittill( "goal" );
	ai_man fx::play( "blood_headpop", undefined, undefined, undefined, true, "J_Neck", true );
	ai_man Kill();
	
	level flag::set( "warlord_fight" );
}

function warlord_death_watcher()  //self = warlord
{
	self waittill( "death" );
	
	wait 1;  //timing purpose
	
	level flag::set( "warlord_backup" );
	
	self WarlordInterface::ClearAllPreferedPoints();
}

function civ_spawn_func()  //self = civilian
{
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self.goalradius = 1;
}

function warlord_intro_spawn_func( b_enemy )
{
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self util::magic_bullet_shield();
	
	if ( isdefined( b_enemy ) )
	{
		nd_start = GetNode( self.script_noteworthy, "targetname" );
		
		self.e_org = Spawn( "script_origin", self.origin );
		self LinkTo ( self.e_org );
		self.e_org MoveTo( nd_start.origin, 3.0 );
		self.e_org waittill( "movedone" );
	}
	
	level flag::wait_till( "warlord_fight" );
	
	self Unlink();
		
	if ( isdefined ( self.e_org ) )
	{
		self.e_org Delete();
	}
}

function warlord_guard_spawn_func()
{
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self util::magic_bullet_shield();
	
	nd_start = GetNode( self.script_noteworthy, "targetname" );
			
	self.e_org = Spawn( "script_origin", self.origin );
	self LinkTo ( self.e_org );
	self.e_org MoveTo( nd_start.origin, 3.0 );
	self.e_org waittill( "movedone" );
	
	level flag::wait_till( "warlord_fight" );
	
	self util::stop_magic_bullet_shield();
	
	self Unlink();
		
	if ( isdefined ( self.e_org ) )
	{
		self.e_org Delete();
	}
	
	wait 2;  //give Hendricks time to start down hill
	
	self ai::set_ignoreme( false );
	self ai::set_ignoreall( false );
}

function warlord_spawn_func()  //self = warlord
{
	self endon( "death" );
	
	self thread warlord_retreat();
	
	nd_start = GetNode( self.script_noteworthy, "targetname" );
		
	self.e_org = Spawn( "script_origin", self.origin );
	self LinkTo ( self.e_org );
	self.e_org MoveTo( nd_start.origin, 3.0 );
	self.e_org waittill( "movedone" );
		
	level flag::set( "warlord_intro_done" );
		
	level flag::wait_till( "warlord_fight" );
	
	self Unlink();
		
	if ( isdefined ( self.e_org ) )
	{
		self.e_org Delete();
	}
}

function warlord_intro_nodes()
{
	level flag::wait_till( "warlord_fight" );
	
	wait 1;  //give time to finish IGC
	
	a_nd_warlord = GetNodeArray( "node_warlord_intro", "targetname" );
	a_ai_enemies = GetEntArray( "warlord_guard_ai", "targetname" );
	
	for ( i = 0; i < a_ai_enemies.size; i++ )
	{
		if ( IsAlive( a_ai_enemies[i] ) )
		{
			a_ai_enemies[i] SetGoal( a_nd_warlord[i], true );
			a_ai_enemies[i] thread clear_force_goal();
		}
	}
}

function clear_force_goal()  //self = ai
{
	self endon( "death" );
	
	//trigger::wait_till( "trigger_shelter" );
	
	self waittill( "goal" );
	
	wait RandomFloatRange( 0.5, 1.5 );  //different reaction times
	
	self ClearForcedGoal();
}

function warlord_retreat()  //self = warlord
{
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self util::magic_bullet_shield();
	self ai::disable_pain();
	
	level flag::wait_till( "warlord_fight" );
	
	wait 1; //prevent warlord from running off so suddenly
	
	self SetGoal( GetNode( "china_town_warlord_escape_node", "targetname"), 8 );
	
	self waittill ( "goal" );
	
	self SetGoal( GetNode( "china_town_warlord_fallback", "script_noteworthy"), 8 );
	
	self waittill ( "goal" );
	
	self ai::set_ignoreme( false );
	self ai::set_ignoreall( false );
	self util::stop_magic_bullet_shield();
	self ai::enable_pain();
	
	wait 6; //wait a few seconds so he doesn't just leave right away if you advance
	
	self ClearForcedGoal();
	
	self.goalHeight = 512; //make his goal height higher so he can reach the nodes up on top of stuff 
	
	a_warlord_nodes = GetNodeArray( "china_town_warlord_preferred_goal", "targetname" );
	
	foreach ( node in a_warlord_nodes )
	{
		self WarlordInterface::AddPreferedPoint( node.origin, 5000, 10000 );
	}	
	
}

function spawn_truck_warlord()
{
	level flag::wait_till( "warlord_fight" );
	
	vh_truck = vehicle::simple_spawn_single( "truck_warlord" );
	
	vh_truck util::magic_bullet_shield();
	
	nd_start = GetVehicleNode( "truck_start", "targetname" );
	
	vh_truck thread vehicle::get_on_and_go_path( nd_start );
		
	vh_truck waittill( "truck_dropoff" );
	
	vh_truck SetSpeedImmediate( 0 );
	
	vh_truck thread protect_riders();
	
	vh_truck turret::enable( 1, true );
	
	vh_truck blackstation_utility::truck_unload( "passenger1" );
	
	level thread enemy_count_watcher( 3, "warlord_backup" );
	
	vh_truck ResumeSpeed( 15 );
	
	vh_truck waittill( "reached_end_node" );
	
	vh_truck blackstation_utility::truck_unload( "driver" );
	
	vh_truck thread blackstation_utility::truck_gunner_replace( level.players.size, 2, "warlord_fight_done" );
	
	vh_truck util::stop_magic_bullet_shield();
	
	vh_truck MakeVehicleUsable();
	vh_truck SetSeatOccupied( 0 );
}

function protect_riders()  //self = vehicle
{
	self endon( "death" );
	
	ai_driver = self vehicle::get_rider( "driver" );
	ai_passenger = self vehicle::get_rider( "passenger1" );
	
	ai_driver util::magic_bullet_shield();
	ai_passenger util::magic_bullet_shield();
}

function warlord_backup_trigger()
{
	trigger::wait_till( "trigger_warlord_backup" );
	
	level flag::set( "warlord_backup" );
	
	level thread start_background_debris();
	level thread enemy_fallback();
	
	trigger::wait_till( "trigger_warlord_reinforce" );
	
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypt_anchor_intro" ) );
	
	level flag::set( "warlord_reinforce" );
	
	trigger::wait_till( "anchor_intro_wind" );
	
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypt_anchor_intro" ) );
}

function spawn_warlord_backup()
{
	level flag::wait_till( "warlord_backup" );
	
	spawner::simple_spawn( "warlord_backup_point" );
	
	spawn_manager::enable( "sm_warlord_launchers" );
	
	wait 2;  //allow first guy to get player's attention
	
	spawner::simple_spawn( "warlord_backup" );
	
	spawn_manager::enable( "sm_warlord_support" );
	
	level thread warlord_backup_monitor();
	
	level flag::wait_till( "warlord_reinforce" );
	
	spawner::add_spawn_function_group( "warlord_reinforce", "targetname", &warlord_reinforce_spawnfunc );
	spawn_manager::enable( "sm_warlord_reinforce" );
	
	spawn_manager::wait_till_complete( "sm_warlord_reinforce" );
	
	level thread enemy_count_watcher( 3, "warlord_retreat" );
}

function warlord_reinforce_spawnfunc()  //self = enemy ai
{
	self ai::set_behavior_attribute( "sprint", true );
	self ai::set_ignoreall( true );
	self.goalradius = 4;
	
	self waittill( "goal" );
	
	self ai::set_behavior_attribute( "sprint", false );
	self ai::set_ignoreall( false );
	self.goalradius = 2048;
}

function warlord_backup_monitor()
{
	spawner::waittill_ai_group_count( "group_warlord_backup", 3 );
	
	level flag::set( "warlord_reinforce" );
}

function enemy_all_dead()
{
	spawner::waittill_ai_group_cleared( "group_warlord" );
	spawner::waittill_ai_group_cleared( "group_warlord_backup" );
	spawner::waittill_ai_group_cleared( "group_warlord_truck" );
	spawn_manager::wait_till_cleared( "sm_warlord_launchers" );
	spawn_manager::wait_till_cleared( "sm_warlord_support" );
	spawn_manager::wait_till_cleared( "sm_warlord_reinforce" );
	
	level flag::set( "qzone_done" );
}

function enemy_count_watcher( n_aicount, str_flag )  //for spawning enemies
{
	while( GetAICount() > n_aicount + 1 )  //"+1" refers to Hendricks
	{
		wait 1;	
	}
	
	level flag::set( str_flag );
}

function enemy_fallback()
{
	level flag::wait_till( "warlord_retreat" );  //set by "trigger_hendricks_wall_approach" or "enemy_count_watcher()"
	
	vol_qzone = GetEnt( "vol_qzone", "targetname" );
	
	a_ai_enemies = GetAITeamArray( "axis" );
	
	foreach( ai_guy in a_ai_enemies )
	{
		ai_guy SetGoal( vol_qzone );
	}
}

function start_background_debris()
{
	level endon( "warlord_fight_done" );
	
	while( 1 )
	{
		level blackstation_utility::setup_random_debris();
		
		wait RandomFloatRange( 3.5, 5.5 );
	}
}

function roof_tiles()
{
	level flag::wait_till( "all_players_spawned" );
	s_roof_tiles_0 = struct::get( "struct_roof_tiles_0" );
	level thread spawn_roof_tiles( s_roof_tiles_0 );
	
	trigger::wait_till( "trigger_hendricks_schoolhouse" );
	s_roof_tiles_1 = struct::get( "struct_roof_tiles_1" );
	level thread spawn_roof_tiles( s_roof_tiles_1 );
	
	trigger::wait_till( "trigger_hendricks_street" );
	e_roof = GetEnt( "roof_flap", "targetname" );
	e_roof thread roof_flap_fly();
	
	trigger::wait_till( "trigger_hendricks_tent" );
	s_roof_tiles_2 = struct::get( "struct_roof_tiles_2" );
	level thread spawn_roof_tiles( s_roof_tiles_2 );
}

function roof_flap_fly()  //self = roof flap entity
{
	self thread roof_flap();
	
	trigger::wait_till( "trigger_hendricks_tent" );
	
	self notify( "stop_flap" );
	
	self RotatePitch( 120, 1 );
	self MoveTo( self.origin + (1000, 3000, -700), 2.5 );
	self waittill( "movedone" );
	
	self Delete();
}

function roof_flap()  //self = roof flap entity
{
	self endon( "stop_flap" );
	
	while( 1 )
	{
		self RotatePitch( -35, 0.2 );
		self waittill( "rotatedone" );
		self RotatePitch( 35, 0.2 );
		self waittill( "rotatedone" );
	}
}

function spawn_roof_tiles( s_org )
{
	for( i = 0; i < 30; i++ )
	{
		e_tile = Spawn( "script_model", s_org.origin + ( RandomIntRange(-40,40), RandomIntRange(-40,40), 0 ) );
		e_tile SetModel( "p7_sin_rowhouse_roof_tile_single" );
		wait RandomFloatRange( 0.1, 0.3 );
		e_tile thread launch_roof_tile( s_org );
		e_tile thread rotate_roof_tile();
	}
}

function launch_roof_tile( s_org )  //self = roof tile
{
	s_end = struct::get( s_org.target );
	
	self MoveZ( 60, 0.1 );
	self waittill( "movedone" );
	self MoveTo( s_end.origin + ( RandomIntRange(-200,200), 0, RandomFloatRange(-200,200) ), 6 );
	self waittill( "movedone" );
	self Delete();
}

function rotate_roof_tile()  //self = roof tile
{
	self endon( "death" );
	
	while( 1 )
	{
		self RotateRoll( -90, 0.3 );
		wait 0.25;
	}
}

function shelter_blow_away()
{
	trigger::wait_till( "trigger_shelter" );
	
	e_shelter = GetEnt( "shelter", "targetname" );
	s_goal = struct::get( "shelter_goal" );
	
	e_shelter RotateRoll( -180, 2 );
	e_shelter MoveTo( s_goal.origin, 4 );
	e_shelter waittill( "movedone" );
	e_shelter Delete();
}

function missile_launcher_hint()
{
	foreach( player in level.players )
	{
		player thread check_missile_launcher();
	}
}

function check_missile_launcher()  //self = player
{
	self endon( "death" );
	
	if( self GetCurrentWeapon() != GetWeapon( "micromissile_launcher" ) ) //check to see if the luancher is already equipped
	{
		if ( !isdefined( self GetLUIMenu( "MissileLauncherEquipHint" ) ) ) 
		{
			self OpenLUIMenu( "MissileLauncherEquipHint" ); 
		}
	
		while( self GetCurrentWeapon() != GetWeapon( "micromissile_launcher" ) )  //wait for player to equip missile launcher
		{
				wait 0.1;
		}
	
		if ( isdefined( self GetLUIMenu( "MissileLauncherEquipHint" ) ) ) 
		{
			self CloseLUIMenu( self GetLUIMenu( "MissileLauncherEquipHint" ) ); 
		}
	}
	
	while( !self.b_launcher_hint )
	{
		while( self GetCurrentWeapon() != GetWeapon( "micromissile_launcher" ) )  //wait for player to equip missile launcher to display hint text
		{
			wait 0.1;
		}
	
		if ( !isdefined( self GetLUIMenu( "MissileLauncherHint" ) ) )
		{
			self OpenLUIMenu( "MissileLauncherHint" );
			
			while( !isdefined( self GetLUIMenu( "MissileLauncherHint" ) ) )
			{
				{wait(.05);};  //wait until text is displayed
			}
			
			self thread launcher_hint_watcher();
			self thread close_launcher_hint();
		}
		
		{wait(.05);};
	}
}

function launcher_hint_watcher()  //self = player
{
	self endon( "death" );
	self endon( "weapon_change" );
	
	while( !self AdsButtonPressed() )
	{
		{wait(.05);};
	}
	
	wait 2;  //give player time to read hint text
	
	if ( isdefined( self GetLUIMenu( "MissileLauncherHint" ) ) )
	{
		self CloseLUIMenu( self GetLUIMenu( "MissileLauncherHint" ) );
		
		self.b_launcher_hint = true;
		
		self notify( "launcher_hint" );
	}
}

function close_launcher_hint()  //self = player
{
	self endon( "death" );
	self endon( "launcher_hint" );
	
	self waittill( "weapon_change" );
	
	if ( isdefined( self GetLUIMenu( "MissileLauncherHint" ) ) )
	{
		self CloseLUIMenu( self GetLUIMenu( "MissileLauncherHint" ) );
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// skipto functions ///////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

function objective_igc_init( str_objective, b_starting )
{
	blackstation_utility::init_hendricks( "objective_igc" );
	
	level thread blackstation_utility::player_rain_intensity( "light" );
	level thread vtol_intro();
	level thread hendricks_qzone_path_igc();
	level thread hendricks_warlord_fight();
	level thread hendricks_igc();
	level thread dead_civilians();
	level thread vo_qzone();
	level thread vo_warlord_intro();
	level thread roof_tiles();
			
	level flag::wait_till( "vtol_jump" );
	
	level skipto::objective_completed( "objective_igc" );
}

function objective_igc_done( str_objective, b_starting, b_direct, player )
{
	
}

function objective_qzone_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_qzone" );
		
		level thread hendricks_qzone_path();
		level thread hendricks_warlord_fight();
		level thread dead_civilians();
		level thread vo_qzone();
		level thread vo_warlord_intro();
		level thread roof_tiles();
		
		level flag::set( "on_ground" );
		
		trigger::use( "trigger_hendricks_start" );
		
		level flag::wait_till( "all_players_spawned" );
	
		wait 0.1;  //wait until player gets weapon first
		
		foreach( player in level.players )
		{
			player thread missile_launcher_equip_hint();
		}
	}
	
	objectives::set( "cp_level_blackstation_qzone" );
	
	level thread interact_warlord_intro();
	
	trigger::wait_till( "trigger_hendricks_interact" );
	
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypt_warlord_igc" ) );
	
	trigger::wait_till( "trigger_warlord_igc" );
	
	level skipto::objective_completed( "objective_qzone" );
}

function objective_qzone_done( str_objective, b_starting, b_direct, player )
{
	
}

function objective_warlord_igc_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_warlord_igc" );
		
		objectives::set( "cp_level_blackstation_qzone" );
						
		level thread interact_warlord_intro();
		level thread hendricks_warlord_fight();
		level thread vo_warlord_intro();
		
		objectives::set( "cp_standard_breadcrumb" , struct::get( "waypt_warlord_igc" ) );
		
		level flag::wait_till( "all_players_spawned" );
	
		wait 0.1;  //wait until player gets weapon first
		
		foreach( player in level.players )
		{
			player SwitchToWeapon( GetWeapon( "micromissile_launcher" ) );
		}
	}
	
	level flag::wait_till( "warlord_fight" );
	
	level skipto::objective_completed( "objective_warlord_igc" );
}

function objective_warlord_igc_done( str_objective, b_starting, b_direct, player )
{
	
}

function objective_warlord_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_warlord" );
		
		objectives::set( "cp_level_blackstation_qzone" );
		
		level flag::wait_till( "all_players_spawned" );
		
		ai_warlord = spawner::simple_spawn_single( "warlord_intro" );
		a_ai_guards = spawner::simple_spawn( "warlord_guard" );
		
		ai_warlord thread warlord_death_watcher();
		ai_warlord thread warlord_retreat();
		
		wait 0.1;  //wait until player gets weapon first
		
		foreach( player in level.players )
		{
			player SwitchToWeapon( GetWeapon( "micromissile_launcher" ) );
		}
				
		wait 0.5;  //allow warlord to start moving first
		
		level flag::set( "warlord_fight" );
		
		level thread hendricks_warlord_fight();
		level thread missile_launcher_hint();
	}
	
	level thread warlord_intro_nodes();
	level thread spawn_truck_warlord();
	level thread spawn_warlord_backup();
	level thread warlord_backup_trigger();
	level thread blackstation_utility::constant_debris();
			
	trigger::wait_till( "trigger_hendricks_hotel_approach" );
	
	level flag::set( "warlord_fight_done" );
	
	level skipto::objective_completed( "objective_warlord" );
}

function objective_warlord_done( str_objective, b_starting, b_direct, player )
{
	
}
