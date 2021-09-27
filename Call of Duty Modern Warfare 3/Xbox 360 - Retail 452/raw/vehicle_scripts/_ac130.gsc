#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );

/*QUAKED script_vehicle_ac130 (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_ac130::main( "tag_origin", undefined, "script_vehicle_ac130" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_ac130

defaultmdl="vehicle_ac130_low"
default:"vehicletype" "ac130"
default:"script_team" "allies"
*/

main( model, type, classname )
{
	build_template( "ac130", model, type, classname );
	build_localinit( ::init_local );
	build_team( "allies" );
	build_bulletshield( true );
	build_grenadeshield( true );

	_ac130_init();
}

init_local()
{
	_ac130_init_vehicle();
}

_ac130_init()
{
	vehicle_scripts\_ac130_snd::main();

	_ac130_init_globals();
	_ac130_init_flags();
	_ac130_init_fx();
	_ac130_set_dvar();
	_ac130_precache();
	_ac130_init_sound();
}


_ac130_init_sound()
{
	//Shot out!
    level.scr_sound[ "gun" ][ "ac130_gun_shotout" ]				= "ac130_gun_shotout";
    //Gun ready!
    level.scr_sound[ "gun" ][ "ac130_gun_gunready" ]			= "ac130_gun_gunready";
    //Watch your fire.  That was too close to our guys.
    level.scr_sound[ "fco" ][ "ac130_fco_tooclose2" ]			= "ac130_fco_tooclose2";   
    //Uhhh you're firing too close to the friendlies.  I repeat - you're firing too close to the friendlies.
    level.scr_sound[ "fco" ][ "ac130_fco_tooclose" ]			= "ac130_fco_tooclose";   
    //Careful ... you almost hit our guys there ...
    level.scr_sound[ "fco" ][ "ac130_fco_careful" ]				= "ac130_fco_careful";   
    //Check your fire, you're shootin' at friendlies.
    level.scr_sound[ "fco" ][ "ac130_fco_checkfire" ]			= "ac130_fco_checkfire";    


 }  



_ac130_init_vehicle()
{
	level.ac130 = Spawn( "script_model", self.origin );
	level.ac130 SetModel( "tag_origin" );
	level.ac130.angles = ( 65, self.angles[ 1 ] + 90, 0 );
	level.ac130 LinkTo( self, "tag_origin" ); 

	level.ac130_weapon_tag = Spawn( "script_model", self.origin );
	level.ac130_weapon_tag SetModel( "tag_origin" );
	level.ac130_weapon_tag.angles = ( 65, self.angles[ 1 ] + 90, 0 );
	level.ac130_weapon_tag LinkTo( self, "tag_origin" );
	
	level.ac130_player_view_controller_target = Spawn( "script_model", 2 * AnglesToForward( level.ac130.angles ) + level.ac130.origin );
	level.ac130_player_view_controller_target SetModel( "tag_origin" );
	level.ac130_player_view_controller_target.angles = level.ac130.angles;
	level.ac130_player_view_controller_target LinkTo( self, "tag_origin" );
	
	level.ac130_player_view_controller_ref = Spawn( "script_model", self.origin );
	level.ac130_player_view_controller_ref SetModel( "tag_origin" );
	level.ac130_player_view_controller_ref.angles = ( level.ac130.angles[ 0 ] + 90, self.angles[ 1 ] + 90, 0 );
	level.ac130_player_view_controller_ref LinkTo( self, "tag_origin" );
	
	level.ac130_player_view_controller = get_player_view_controller( level.ac130_player_view_controller_ref, 
																	 "tag_origin", ( 0, 0, 0 ), "player_view_controller" );
	level.ac130_player_view_controller TurretFireDisable();
	
	self.ignoreme = true;
}

_ac130_init_globals()
{
	//level.vehicleSpawnCallbackThread = ::context_Sensative_Dialog_VehicleSpawn;
	
	level.enemiesKilledInTimeWindow = 0;

	level.radioForcedTransmissionQueue = [];

	level.lastRadioTransmission = GetTime();

	level.color[ "white" ] = ( 1, 1, 1 );
	level.color[ "red" ] = ( 1, 0, 0 );
	level.color[ "blue" ] = ( .1, .3, 1 );

	level.cosine = [];
	level.cosine[ "45" ] = cos( 45 );
	level.cosine[ "5" ] = cos( 5 );

	level.ac130_weapon_loadout = ter_op( IsDefined( level.ac130_weapon_loadout ), level.ac130_weapon_loadout, 2 );
	
	// Gameplay
	
	level.badplaceCount = 0;
	level.badplaceMax = 15;

	level.badplaceRadius[ "ac130_25mm" ] 		= 800;
	level.badplaceRadius[ "ac130_40mm" ] 		= 1000;
	level.badplaceRadius[ "ac130_105mm" ] 		= 1600;
	level.badplaceRadius[ "ac130_25mm_alt" ]    = level.badplaceRadius[ "ac130_25mm" ];
	level.badplaceRadius[ "ac130_40mm_alt" ]    = level.badplaceRadius[ "ac130_40mm" ];
	level.badplaceRadius[ "ac130_105mm_alt" ]   = level.badplaceRadius[ "ac130_105mm" ];
	level.badplaceRadius[ "ac130_25mm_alt2" ]   = level.badplaceRadius[ "ac130_25mm" ];
	level.badplaceRadius[ "ac130_40mm_alt2" ]   = 1000;
	level.badplaceRadius[ "ac130_105mm_alt2" ]  = 1600;

	level.badplaceDuration[ "ac130_25mm" ] 		    = 2.0;
	level.badplaceDuration[ "ac130_40mm" ] 		    = 9.0;
	level.badplaceDuration[ "ac130_105mm" ] 	    = 12.0;
	level.badplaceDuration[ "ac130_25mm_alt" ] 	    = level.badplaceDuration[ "ac130_25mm" ];
	level.badplaceDuration[ "ac130_40mm_alt" ] 	    = level.badplaceDuration[ "ac130_40mm" ];
	level.badplaceDuration[ "ac130_105mm_alt" ]     = level.badplaceDuration[ "ac130_105mm" ];
	level.badplaceDuration[ "ac130_25mm_alt2" ]     = 1.0;
	level.badplaceDuration[ "ac130_40mm_alt2" ]     = 2.5;
	level.badplaceDuration[ "ac130_105mm_alt2" ]    = 5.0;

	level.physicsSphereRadius[ "ac130_25mm" ] 		= 60;
	level.physicsSphereRadius[ "ac130_40mm" ] 		= 600;
	level.physicsSphereRadius[ "ac130_105mm" ] 		= 1000;
	level.physicsSphereRadius[ "ac130_25mm_alt" ] 	= level.physicsSphereRadius[ "ac130_25mm" ];
	level.physicsSphereRadius[ "ac130_40mm_alt" ] 	= level.physicsSphereRadius[ "ac130_40mm" ];
	level.physicsSphereRadius[ "ac130_105mm_alt" ] 	= level.physicsSphereRadius[ "ac130_105mm" ];
	level.physicsSphereRadius[ "ac130_25mm_alt2" ] 	= level.physicsSphereRadius[ "ac130_25mm" ];
	level.physicsSphereRadius[ "ac130_40mm_alt2" ] 	= level.physicsSphereRadius[ "ac130_40mm" ];
	level.physicsSphereRadius[ "ac130_105mm_alt2" ] = level.physicsSphereRadius[ "ac130_105mm" ];

	level.physicsSphereForce[ "ac130_25mm" ] 		= 0;
	level.physicsSphereForce[ "ac130_40mm" ] 		= 3.0;
	level.physicsSphereForce[ "ac130_105mm" ] 		= 6.0;
	level.physicsSphereForce[ "ac130_25mm_alt" ] 	= level.physicsSphereForce[ "ac130_25mm" ];
	level.physicsSphereForce[ "ac130_40mm_alt" ]    = level.physicsSphereForce[ "ac130_40mm" ];
	level.physicsSphereForce[ "ac130_105mm_alt" ]   = level.physicsSphereForce[ "ac130_105mm" ];
	level.physicsSphereForce[ "ac130_25mm_alt2" ] 	= level.physicsSphereForce[ "ac130_25mm" ];
	level.physicsSphereForce[ "ac130_40mm_alt2" ] 	= level.physicsSphereForce[ "ac130_40mm" ];
	level.physicsSphereForce[ "ac130_105mm_alt2" ]  = level.physicsSphereForce[ "ac130_105mm" ];

	level.weapon_reload_time[ "ac130_25mm" ] 		= 0.0;
	level.weapon_reload_time[ "ac130_40mm" ] 		= 0.45;
	level.weapon_reload_time[ "ac130_105mm" ] 	    = 0.0;
	level.weapon_reload_time[ "ac130_25mm_alt" ] 	= level.weapon_reload_time[ "ac130_25mm" ];
	level.weapon_reload_time[ "ac130_40mm_alt" ] 	= level.weapon_reload_time[ "ac130_40mm" ];
	level.weapon_reload_time[ "ac130_105mm_alt" ]  	= level.weapon_reload_time[ "ac130_105mm" ];
	level.weapon_reload_time[ "ac130_25mm_alt2" ]  	= level.weapon_reload_time[ "ac130_25mm" ];
	level.weapon_reload_time[ "ac130_40mm_alt2" ]  	= level.weapon_reload_time[ "ac130_40mm" ];
	level.weapon_reload_time[ "ac130_105mm_alt2" ] 	= level.weapon_reload_time[ "ac130_105mm" ];
	
	level.weapon_input_cooldown_active[ "ac130_25mm" ] 			= false;
	level.weapon_input_cooldown_active[ "ac130_40mm" ] 			= false;
	level.weapon_input_cooldown_active[ "ac130_105mm" ] 	    = false;
	level.weapon_input_cooldown_active[ "ac130_25mm_alt" ]		= false;
	level.weapon_input_cooldown_active[ "ac130_105mm_alt" ]   	= false;
	level.weapon_input_cooldown_active[ "ac130_25mm_alt2" ]   	= false;
	level.weapon_input_cooldown_active[ "ac130_40mm_alt2" ]   	= false;
	level.weapon_input_cooldown_active[ "ac130_105mm_alt2" ]  	= false;
	
	level.weapon_input_cooldown_time[ "ac130_25mm" ] 		= 0.3;
	level.weapon_input_cooldown_time[ "ac130_40mm" ] 		= 0;
	level.weapon_input_cooldown_time[ "ac130_105mm" ] 	    = 0.0;
	level.weapon_input_cooldown_time[ "ac130_25mm_alt" ]	= level.weapon_input_cooldown_time[ "ac130_25mm" ];
	level.weapon_input_cooldown_time[ "ac130_105mm_alt" ]   = level.weapon_input_cooldown_time[ "ac130_105mm" ];
	level.weapon_input_cooldown_time[ "ac130_25mm_alt2" ]   = level.weapon_input_cooldown_time[ "ac130_25mm" ];
	level.weapon_input_cooldown_time[ "ac130_40mm_alt2" ]   = level.weapon_input_cooldown_time[ "ac130_40mm" ];
	level.weapon_input_cooldown_time[ "ac130_105mm_alt2" ]  = level.weapon_input_cooldown_time[ "ac130_105mm" ];

	level.weaponFriendlyCloseDistance[ "ac130_25mm" ] 	    = 150;
	level.weaponFriendlyCloseDistance[ "ac130_40mm" ]	 	= 500;
	level.weaponFriendlyCloseDistance[ "ac130_105mm" ] 		= 1000;
	level.weaponFriendlyCloseDistance[ "ac130_25mm_alt" ] 	= level.weaponFriendlyCloseDistance[ "ac130_25mm" ];
	level.weaponFriendlyCloseDistance[ "ac130_40mm_alt" ] 	= level.weaponFriendlyCloseDistance[ "ac130_40mm" ];
	level.weaponFriendlyCloseDistance[ "ac130_105mm_alt" ] 	= level.weaponFriendlyCloseDistance[ "ac130_105mm" ];
	level.weaponFriendlyCloseDistance[ "ac130_25mm_alt2" ] 	= level.weaponFriendlyCloseDistance[ "ac130_25mm" ];
	level.weaponFriendlyCloseDistance[ "ac130_40mm_alt2" ] 	= level.weaponFriendlyCloseDistance[ "ac130_40mm" ];
	level.weaponFriendlyCloseDistance[ "ac130_105mm_alt2" ] = level.weaponFriendlyCloseDistance[ "ac130_105mm" ];
	
	level.weapon_enemy_close_distance[ "ac130_25mm" ] 		= 300;
	level.weapon_enemy_close_distance[ "ac130_40mm" ]	 	= 500;
	level.weapon_enemy_close_distance[ "ac130_105mm" ] 		= 1000;
	level.weapon_enemy_close_distance[ "ac130_25mm_alt2" ]  = level.weapon_enemy_close_distance[ "ac130_25mm" ];
	level.weapon_enemy_close_distance[ "ac130_40mm_alt2" ]  = level.weapon_enemy_close_distance[ "ac130_40mm" ];
	level.weapon_enemy_close_distance[ "ac130_105mm_alt2" ] = level.weapon_enemy_close_distance[ "ac130_105mm" ];
	
	level.weapon_enemy_near_death_distance[ "ac130_25mm" ] 	        = 0;
	level.weapon_enemy_near_death_distance[ "ac130_40mm" ]	        = 500;
	level.weapon_enemy_near_death_distance[ "ac130_105mm" ]         = 1000;
	level.weapon_enemy_near_death_distance[ "ac130_25mm_alt2" ]     = level.weapon_enemy_near_death_distance[ "ac130_25mm" ];
	level.weapon_enemy_near_death_distance[ "ac130_40mm_alt2" ]     = level.weapon_enemy_near_death_distance[ "ac130_40mm" ];
	level.weapon_enemy_near_death_distance[ "ac130_105mm_alt2" ]    = level.weapon_enemy_near_death_distance[ "ac130_105mm" ];

	level.weapon_ready_to_fire[ "ac130_25mm" ] 			= true;
	level.weapon_ready_to_fire[ "ac130_40mm" ] 			= true;
	level.weapon_ready_to_fire[ "ac130_105mm" ] 		= true;
	level.weapon_ready_to_fire[ "ac130_25mm_alt" ] 		= level.weapon_ready_to_fire[ "ac130_25mm" ];
	level.weapon_ready_to_fire[ "ac130_40mm_alt" ] 		= level.weapon_ready_to_fire[ "ac130_40mm" ];
	level.weapon_ready_to_fire[ "ac130_105mm_alt" ] 	= level.weapon_ready_to_fire[ "ac130_105mm" ];
	level.weapon_ready_to_fire[ "ac130_25mm_alt2" ] 	= level.weapon_ready_to_fire[ "ac130_25mm" ];
	level.weapon_ready_to_fire[ "ac130_40mm_alt2" ] 	= level.weapon_ready_to_fire[ "ac130_40mm" ];
	level.weapon_ready_to_fire[ "ac130_105mm_alt2" ] 	= level.weapon_ready_to_fire[ "ac130_105mm" ];
	
	level.weapon_ammo_max[ "ac130_25mm_alt2" ] 	= 75;
	level.weapon_ammo_max[ "ac130_40mm_alt2" ] 	= 12;
	level.weapon_ammo_max[ "ac130_105mm_alt2" ] = 1;
	
	level.weapon_ammo_count[ "ac130_25mm_alt2" ] 	= level.weapon_ammo_max[ "ac130_25mm_alt2" ];
	level.weapon_ammo_count[ "ac130_40mm_alt2" ] 	= level.weapon_ammo_max[ "ac130_40mm_alt2" ] ;
	level.weapon_ammo_count[ "ac130_105mm_alt2" ] 	= level.weapon_ammo_max[ "ac130_105mm_alt2" ];
	
	level.weapon_chamber_count[ "ac130_25mm_alt2" ] 	= 1;
	level.weapon_chamber_count[ "ac130_40mm_alt2" ] 	= 1;
	level.weapon_chamber_count[ "ac130_105mm_alt2" ] 	= 1;
	
	level.weapon_chamber_max[ "ac130_25mm_alt2" ] 	= 5;
	level.weapon_chamber_max[ "ac130_40mm_alt2" ] 	= 3;
	level.weapon_chamber_max[ "ac130_105mm_alt2" ] 	= 1;
	
	level.weapon_cooldown_active[ "ac130_25mm" ] 		= false;
	level.weapon_cooldown_active[ "ac130_40mm" ] 		= false;
	level.weapon_cooldown_active[ "ac130_105mm" ] 	    = false;
	level.weapon_cooldown_active[ "ac130_25mm_alt" ]	= false;
	level.weapon_cooldown_active[ "ac130_105mm_alt" ]   = false;
	level.weapon_cooldown_active[ "ac130_25mm_alt2" ]   = false;
	level.weapon_cooldown_active[ "ac130_40mm_alt2" ]   = false;
	level.weapon_cooldown_active[ "ac130_105mm_alt2" ]  = false;
	
	level.weapon_cooldown_time[ "ac130_25mm" ] 		    = 2.5;
	level.weapon_cooldown_time[ "ac130_40mm" ] 		    = 3.5;
	level.weapon_cooldown_time[ "ac130_105mm" ] 	    = 5.95;
	level.weapon_cooldown_time[ "ac130_25mm_alt" ] 	    = level.weapon_cooldown_time[ "ac130_25mm" ];
	level.weapon_cooldown_time[ "ac130_105mm_alt" ]     = level.weapon_cooldown_time[ "ac130_105mm" ];
	level.weapon_cooldown_time[ "ac130_25mm_alt2" ]    	= level.weapon_cooldown_time[ "ac130_25mm" ];
	level.weapon_cooldown_time[ "ac130_40mm_alt2" ]     = level.weapon_cooldown_time[ "ac130_40mm" ];
	level.weapon_cooldown_time[ "ac130_105mm_alt2" ]    = level.weapon_cooldown_time[ "ac130_105mm" ];
	
	level.ac130_weapon_tag_offset[ "forward" ]			= 0;
	level.ac130_weapon_tag_offset[ "up" ]				= 128;
	level.ac130_weapon_tag_offset[ "right" ]			= -128;
	
	level.enemiesKilledByPlayer = 0;
	
	level.ac130_weapon_sound_tag = Spawn( "script_model", ( 0, 0, 0 ) );
	level.ac130_weapon_sound_tag SetModel( "tag_origin" );

	level.ac130_default_right_arc = 65;
	level.ac130_default_left_arc = 65;
	level.ac130_default_top_arc = 45;
	level.ac130_default_bottom_arc = 65;
	
	level.ac130_current_right_arc = level.ac130_default_right_arc;
	level.ac130_current_left_arc = level.ac130_default_left_arc;
	level.ac130_current_top_arc = level.ac130_default_top_arc;
	level.ac130_current_bottom_arc = level.ac130_default_bottom_arc;
	
	level.ac130_hud_targets = [];
	level.ac130_hud_target_show_queue = [];
	level.ac130_hud_target_hide_queue = [];
	
	level.ac130_current_fov = 55;
	level.ac130_friendly_fire_dialogue_priority = true;
	
	level.ac130_projectile_callback = undefined;
	
	// Weapons
	
	level.ac130_weapon = [];
	level.ac130_weapon[ 0 ] = SpawnStruct(); // 105
	level.ac130_weapon[ 1 ] = SpawnStruct(); // 40
	level.ac130_weapon[ 2 ] = SpawnStruct(); // 25
	
	switch( level.ac130_weapon_loadout )
    {
        case 0:
        	level.weapon_name[ "25" ] 	= "ac130_25mm";
			level.weapon_name[ "40" ]	= "ac130_40mm";
			level.weapon_name[ "105" ]	= "ac130_105mm";
            level.ac130_weapon[ 0 ].weapon = "ac130_105mm";
		    level.ac130_weapon[ 1 ].weapon = "ac130_40mm";
		    level.ac130_weapon[ 2 ].weapon = "ac130_25mm";
            break;
        case 1:
        	level.weapon_name[ "25" ] 	= "ac130_25mm_alt";
			level.weapon_name[ "40" ]	= "ac130_40mm_alt";
			level.weapon_name[ "105" ]	= "ac130_105mm_alt";
            level.ac130_weapon[ 0 ].weapon = "ac130_105mm_alt";
		    level.ac130_weapon[ 1 ].weapon = "ac130_40mm_alt";
		    level.ac130_weapon[ 2 ].weapon = "ac130_25mm_alt";
            break;
        case 2:
        	level.weapon_name[ "25" ] 	= "ac130_25mm_alt2";
			level.weapon_name[ "40" ]	= "ac130_40mm_alt2";
			level.weapon_name[ "105" ]	= "ac130_105mm_alt2";
            level.ac130_weapon[ 0 ].weapon = "ac130_105mm_alt2";
		    level.ac130_weapon[ 1 ].weapon = "ac130_40mm_alt2";
		    level.ac130_weapon[ 2 ].weapon = "ac130_25mm_alt2";
            break;
    }
    
	// 105 mm
	
	level.ac130_weapon[ 0 ].overlay = "ac130_hudb_reticule_105mm";
	level.ac130_weapon[ 0 ].fov = "55";
	level.ac130_weapon[ 0 ].name = level.weapon_name[ "105" ];
	level.ac130_weapon[ 0 ].hudelem_x = 0;
	level.ac130_weapon[ 0 ].hudelem_y = 0;
	level.ac130_weapon[ 0 ].shader_width = 256;
	level.ac130_weapon[ 0 ].shader_height = 256;
	
	// 40 mm
	
	level.ac130_weapon[ 1 ].overlay = "ac130_hudb_reticule_40mm";
	level.ac130_weapon[ 1 ].fov = "25";
	level.ac130_weapon[ 1 ].name = level.weapon_name[ "40" ];
	level.ac130_weapon[ 1 ].hudelem_x = 0;
	level.ac130_weapon[ 1 ].hudelem_y = 0;
	level.ac130_weapon[ 1 ].shader_width = 256;
	level.ac130_weapon[ 1 ].shader_height = 256;
	
	// 25 mm
	
	level.ac130_weapon[ 2 ].overlay = "ac130_hudb_reticule_25mm";
	level.ac130_weapon[ 2 ].fov = "7"; // 10
	level.ac130_weapon[ 2 ].name = level.weapon_name[ "25" ];
	level.ac130_weapon[ 2 ].hudelem_x = 0;
	level.ac130_weapon[ 2 ].hudelem_y = 64;
	level.ac130_weapon[ 2 ].shader_width = 128;
	level.ac130_weapon[ 2 ].shader_height = 128;
	
	level.current_weapon = level.ac130_weapon[ 0 ].name;
	
	// Game Objects

	// HUD
	
	level.HUDItem = [];
	
	level.ac130_hud_mode_fontscale = 2.5;
	level.ac130_hud_misc_fontscale = 2.0;
	level.ac130_hud_weapon_fontscale = 1.5;
	level.ac130_hud_data_fontscale = 1.0;
	
	level.ac130_HudTargetSize = 30; // vehHudTargetSize
	level.ac130_HudTargetScreenEdgeClampBufferLeft =  0; // vehHudTargetScreenEdgeClampBufferLeft
	level.ac130_HudTargetScreenEdgeClampBufferRight = 0; // vehHudTargetScreenEdgeClampBufferRight
	level.ac130_HudTargetScreenEdgeClampBufferTop = 0; // vehHudTargetScreenEdgeClampBufferTop
	level.ac130_HudTargetScreenEdgeClampBufferBottom = 0;// vehHudTargetScreenEdgeClampBufferBottom
	
	level.ac130_default_HudTargetSize = 50; //GetDvarInt( "vehHudTargetSize", 50 );
	level.ac130_default_HudTargetScreenEdgeClampBufferLeft =  120; //GetDvarInt( "vehHudTargetScreenEdgeClampBufferLeft", 120 );
	level.ac130_default_HudTargetScreenEdgeClampBufferRight = 126; //GetDvarInt( "vehHudTargetScreenEdgeClampBufferRight", 126 );
	level.ac130_default_HudTargetScreenEdgeClampBufferTop = 139; //GetDvarInt( "vehHudTargetScreenEdgeClampBufferTop", 139 ); 
	level.ac130_default_HudTargetScreenEdgeClampBufferBottom = 134; //GetDvarInt( "vehHudTargetScreenEdgeClampBufferBottom", 134 );
	
	// FOG / SUN
	
	ent = maps\_utility::create_vision_set_fog( "ac130_thermal" );
	ent.startDist = 1000;
	ent.halfwayDist = 12000;
	ent.red = 0.0;
	ent.green = 0.0;
	ent.blue = 0.0;
	ent.maxOpacity = 0.8;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
	ent.sunRed = 0.0;
	ent.sunGreen = 0.0;
	ent.sunBlue = 0.0;
	ent.sunDir = (0.0, 0.0, 0.0);
	ent.sunBeginFadeAngle = 0;
	ent.sunEndFadeAngle = 0.0;
	ent.normalFogScale = 0.0;
 
 	ent = maps\_utility::create_vision_set_fog( "ac130_enhanced" );
	ent.startDist = 1024;
	ent.halfwayDist = 13243.8;
	ent.red = 0.523226;
	ent.green = 0.58013;
	ent.blue = 0.587826;
	ent.maxOpacity = 0.681619;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 1;
	ent.sunRed = 0.862916;
	ent.sunGreen = 0.842104;
	ent.sunBlue = 0.816201;
	ent.sunDir = (0.843772, -0.411199, 0.344911);
	ent.sunBeginFadeAngle = 0;
	ent.sunEndFadeAngle = 59.373;
	ent.normalFogScale = 0.300968;
	
	thermal = get_vision_set_fog( "ac130_thermal" );
	
	level.ac130_thermal_fog_color = ( thermal.red, thermal.green, thermal.blue );
	level.ac130_thermal_fog_start = thermal.startDist;
	level.ac130_thermal_fog_halfway_dist = thermal.halfwayDist;
	level.ac130_thermal_fog_opacity = thermal.maxOpacity;
	level.ac130_thermal_sun_color = undefined;
	level.ac130_thermal_sun_dir = undefined;
	level.ac130_thermal_sun_begin_fade_angle = undefined;
	level.ac130_thermal_sun_end_fade_angle = undefined;
	level.ac130_thermal_sun_fog_scale = undefined;
	
	if ( IsDefined( thermal.sunFogEnabled ) & thermal.sunFogEnabled )
	{
		level.ac130_thermal_sun_color = ( thermal.sunRed, thermal.sunGreen, thermal.sunBlue );
		level.ac130_thermal_sun_dir = thermal.sunDir;
		level.ac130_thermal_sun_begin_fade_angle = thermal.sunBeginFadeAngle;
		level.ac130_thermal_sun_end_fade_angle = thermal.sunEndFadeAngle;
		level.ac130_thermal_sun_fog_scale = thermal.normalFogScale;
	}
	
	level.ac130_enhanced_fog_color = ( 0.523226, 0.58013, 0.587826 );
	level.ac130_enhanced_fog_start = 1024;
	level.ac130_enhanced_fog_halfway_dist = 13243.8;
	level.ac130_enhanced_fog_opacity = 0.681619;
	level.ac130_enhanced_sun_color = ( 0.862916, 0.842104, 0.816201 );
	level.ac130_enhanced_sun_dir = ( 0.843772, -0.411199, 0.344911 );
	level.ac130_enhanced_sun_begin_fade_angle = 0;
	level.ac130_enhanced_sun_end_fade_angle = 59.373;
	level.ac130_enhanced_sun_fog_scale = 0.300968;
	
	level.ac130_thermal_vision_set = "ac130_thermal";
	level.ac130_enhanced_vision_set = "ac130_enhanced";
	level.ac130_default_vision_set = undefined;
	
	level.ac130_thermal_blur = 0.5;
	level.ac130_thermal_grain = 0.15;
	level.ac130_enhanced_blur = 0.5;
	level.ac130_enhanced_grain = 0.15;
	
	level.ac130_default_fov = GetDvarInt( "cg_fov" );
	level.ac130_thermal_shock = "ac130";
	level.ac130_enhanced_shock = "ac130_enhanced";
	level.current_shell_shock = level.ac130_thermal_shock;
}

_ac130_init_flags()
{
	flag_init( "allow_context_sensative_dialog" );
	flag_init( "FLAG_ac130_clear_to_engage" );
	flag_init( "FLAG_ac130_rotating" );
	flag_init( "FLAG_ac130_changed_weapons" );
	flag_init( "FLAG_ac130_changed_vision" );
	flag_init( "FLAG_ac130_using_zoom" );
	flag_init( "FLAG_ac130_hud_start" );
	flag_init( "FLAG_ac130_player_in_ac130" );
	flag_init( "FLAG_ac130_change_vision_enabled" );
	flag_init( "FLAG_ac130_change_weapons_enabled" );
	flag_init( "FLAG_ac130_vision_transition" );
	flag_init( "FLAG_ac130_lock_on" );
	flag_init( "FLAG_ac130_recording" );
	flag_init( "FLAG_ac130_hud_on" );
	flag_init( "FLAG_ac130_rumble" );
	
	// Vision Mode
	
	flag_init( "FLAG_ac130_enhanced_vision_enabled" );
	flag_init( "FLAG_ac130_thermal_enabled" );
	
	// Context Sensitive Dialog
	
	flag_init( "FLAG_ac130_context_sensitive_dialog_guy_in_sight" );
	flag_init( "FLAG_ac130_context_sensitive_dialog_filler" );
	flag_init( "FLAG_ac130_context_sensitive_dialog_kill" );
	flag_init( "FLAG_ac130_context_sensitive_dialog_guy_pain" );
}

_ac130_init_fx()
{
	// FX
	
	level._effect[ "cloud" ] 							= LoadFX( "misc/ac130_cloud" );
	level._effect[ "beacon" ] 				    		= LoadFX( "misc/ir_beacon_coop" );
	level._effect[ "FX_thermal_vision_ai_beacon" ]		= LoadFX( "misc/ir_beacon_coop" );
	level._effect[ "FX_night_vision_ai_beacon" ]		= LoadFX( "misc/ir_tapereflect" );
	level._effect[ "FX_night_vision_vehicle_beacon" ]	= LoadFX( "misc/ir_tapereflect" );
	level._effect[ "FX_thermal_vehicle_beacon" ]		= LoadFX( "misc/ir_vehicle_beacon" );

	// ac130 muzzleflash effects for player on ground to see
		
	level._effect[ "FX_ac130_coop_muzzleflash_105mm" ]  = LoadFX( "muzzleflashes/so_ac130_105mm" );
	level._effect[ "FX_ac130_coop_muzzleflash_40mm" ] 	= LoadFX( "muzzleflashes/so_ac130_40mm" );
	level._effect[ "FX_ac130_coop_muzzleflash_25mm" ] 	= LoadFX( "muzzleflashes/so_ac130_25mm" );
}

_ac130_init_hints()
{
}

_ac130_set_dvar()
{
	SetSaveDdvar( "scr_dof_enable", "1" );
	
	SetDvarIfUninitialized( "ac130_zoom_enabled", 1 );
	SetDvarIfUninitialized( "ac130_ragdoll_deaths", "1" );
}

_ac130_precache()
{
	// Shaders
	
	PreCacheShader( "ac130_overlay_grain" );
	PreCacheShader( "ac130_overlay_nofire" );
	
	PreCacheShader( "ac130_hudb_cornera_bl" );
	PreCacheShader( "ac130_hudb_cornera_br" );
	PreCacheShader( "ac130_hudb_cornera_tl" );
	PreCacheShader( "ac130_hudb_cornera_tr" );
	PreCacheShader( "ac130_hudb_missile_warning" );
	PreCacheShader( "ac130_hudb_reticule_105mm" );
	PreCacheShader( "ac130_hudb_reticule_40mm" );
	PreCacheShader( "ac130_hudb_reticule_25mm" );
	PreCacheShader( "ac130_hudb_view_window" );
	PreCacheShader( "ac130_hudb_vision_type_aos" );
	PreCacheShader( "ac130_hudb_vision_type_flir" );
	PreCacheShader( "ac130_hudb_vision_type_box" );
	PreCacheShader( "ac130_hudb_weapon_type_105mm" );
	PreCacheShader( "ac130_hudb_weapon_type_40mm" );
	PreCacheShader( "ac130_hudb_weapon_type_25mm" );
	PreCacheShader( "ac130_hudb_weapon_type_box" );

	PreCacheShader( "ac130_hud_target" );
	PreCacheShader( "ac130_hud_enemy_ai_target_w" );
	PreCacheShader( "ac130_hud_enemy_ai_target_r" );
	PreCacheShader( "ac130_hud_enemy_ai_target_s_r" );
	PreCacheShader( "ac130_hud_enemy_ai_target_s_w" );
	PreCacheShader( "ac130_hud_enemy_vehicle_target_w" );
	PreCacheShader( "ac130_hud_enemy_vehicle_target_r" );
	PreCacheShader( "ac130_hud_enemy_vehicle_target_s_r" );
	PreCacheShader( "ac130_hud_enemy_vehicle_target_s_w" );
	PreCacheShader( "ac130_hud_friendly_ai_target" );
	PreCacheShader( "ac130_hud_friendly_ai_target_s" );
	PreCacheShader( "ac130_hud_friendly_ai_target_s_w" );
	PreCacheShader( "ac130_hud_friendly_ai_diamond_s_w" );
	PreCacheShader( "ac130_hud_friendly_ai_offscreen" );
	PreCacheShader( "ac130_hud_friendly_ai_offscreen_w" );
	PreCacheShader( "ac130_hud_friendly_ai_flash" );
	PreCacheShader( "ac130_hud_friendly_vehicle_target" );
	PreCacheShader( "ac130_hud_friendly_vehicle_target_s" );
	PreCacheShader( "ac130_hud_friendly_vehicle_target_s_w" );
	PreCacheShader( "ac130_hud_friendly_vehicle_diamond_s_w" );
	PreCacheShader( "ac130_hud_friendly_vehicle_offscreen" );
	PreCacheShader( "ac130_hud_friendly_vehicle_offscreen_w" );
	PreCacheShader( "ac130_hud_friendly_vehicle_flash" );
	PreCacheShader( "ac130_hud_player_vehicle_diamond_s_w" );
	
	PreCacheShader( "ac130_hud_alpha_distortion_overlay" );
	
	PreCacheShader( "ac130_friendly_fire_icon" );
	PreCacheShader( "ac130_thermal_overlay" );
	PreCacheShader( "ac130_thermal_overlay_bar" );
	PreCacheShader( "overlay_static" );
	PreCacheShader( "black" );
	//PreCacheShader( "popmenu_bg" );
	
	// Strings
	
	// 105 mm
	PreCacheString( &"AC130_HUD_WEAPON_105MM" );
	// 40 mm
	PreCacheString( &"AC130_HUD_WEAPON_40MM" );
	// 25 mm
	PreCacheString( &"AC130_HUD_WEAPON_25MM" );
	// x
	PreCacheString( &"AC130_HUD_ZOOM" );
	// LOCK ON
	PreCacheString( &"AC130_HUD_LOCK_ON" );
	// FLIR
	PreCacheString( &"AC130_HUD_FLIR" );
	// OPTICS - OPT
	PreCacheString( &"AC130_HUD_OPTICS" );
	// RECORDING - REC
	PreCacheString( &"AC130_HUD_RECORDING" );
	// RELOADING
	PreCacheString( &"AC130_HUD_RELOADING" );
	// AMMO
	PreCacheString( &"AC130_HUD_AMMO" );
	// PERIOD
	PreCacheString( &"AC130_HUD_PERIOD" );
	// COLON
	PreCacheString( &"AC130_HUD_COLON" );
	// &&1 AGL
	PreCacheString( &"AC130_HUD_AGL" );
	// Friendlies: &&1
	PreCacheString( &"AC130_DEBUG_FRIENDLY_COUNT" );
	// Too many friendlies have been KIA. Mission failed.
	PreCacheString( &"AC130_FRIENDLIES_DEAD" );
	// Friendly fire will not be tolerated!\nWatch for blinking IR strobes on friendly units!
	PreCacheString( &"AC130_FRIENDLY_FIRE" );
	// Provide AC-130 air support for friendly SAS ground units.
	
	// Hints
	
	// Press ^3[{weapnext}]^7 to cycle through weapons.
	PreCacheString( &"AC130_HINT_CYCLE_WEAPONS" );
	// "Press ^3[{+activate}]^7 to activate enhanced imaging."
	PreCacheString( &"AC130_HINT_ENHANCED_VISION" );
	// "Press ^3[{+activate}]^7 to activate FLIR."
	PreCacheString( &"AC130_HINT_THERMAL_VISION" );
	//  "Switch to the 40mm or 105mm gun to destroy this target"
	PreCacheString( &"AC130_HINT_USE_40_OR_105" );
	//  "Use the LEFT-ANALOG stick to zoom in and out."
	PreCacheString( &"AC130_HINT_ZOOM" );
	//  "Switch to the 25mm for moving targets"
	PreCacheString( &"AC130_HINT_USE_25_MOVING" );
	
	// Models

	// Items
	
	switch ( level.ac130_weapon_loadout )
	{
	    case 0:
	        PreCacheItem( "ac130_25mm" );
		    PreCacheItem( "ac130_40mm" );
		    PreCacheItem( "ac130_105mm" );
	        break;
	    case 1:
	        PreCacheItem( "ac130_25mm_alt" );
		    PreCacheItem( "ac130_40mm_alt" );
		    PreCacheItem( "ac130_105mm_alt" );
	        break;
	    case 2:
	        PreCacheItem( "ac130_25mm_alt2" );
		    PreCacheItem( "ac130_40mm_alt2" );
		    PreCacheItem( "ac130_105mm_alt2" );
		    break;
	}
	
	PreCacheTurret( "player_view_controller" );
	PreCacheTurret( "player_view_controller_ac130" );
	PreCacheModel( "tag_turret" );
	
	// Rumble
	
	PreCacheRumble( "ac130_105mm_fire" );
	PreCacheRumble( "ac130_40mm_fire" );
	PreCacheRumble( "ac130_25mm_fire" );
	
	// Shell Shock
	
	PreCacheShellShock( "ac130" );
	PreCacheShellShock( "ac130_enhanced" );
	
	// Hints
	
	add_hint_string( "HINT_ac130_change_weapons", &"AC130_HINT_CYCLE_WEAPONS", ::hint_change_weapons );
	add_hint_string( "HINT_ac130_enhanced_vision", &"AC130_HINT_ENHANCED_VISION", ::hint_enhanced_vision );
	add_hint_string( "HINT_ac130_thermal_vision", &"AC130_HINT_THERMAL_VISION", ::hint_thermal_vision );
	add_hint_string( "HINT_ac130_using_zoom", &"AC130_HINT_ZOOM", ::hint_zoom );
	add_hint_string( "HINT_USE_40_OR_105",  &"AC130_HINT_USE_40_OR_105",  ::hint_change_weapons );
	add_hint_string( "HINT_ac130_use_25",  &"AC130_HINT_USE_25_MOVING",  ::hint_change_weapons );
}

_ac130_init_player( player, mode )
{
	Assert( IsPlayer( player ) );
	
	mode = ter_op( IsDefined( mode ), mode, "enhanced" );
	mode = ter_op( mode == "enhanced", mode, "thermal" );
	
	if( !is_coop() )
	{
		SetSavedDvar( "sm_cameraoffset", "5922" );
		SetSavedDvar( "sv_znear", 100 );
	}	
	
	self godon();
	
	player EnableInvulnerability();
	player HideViewModel();
	
	player PainVisionOff();
	player ent_flag_clear( "player_has_red_flashing_overlay" );
	player notify( "noHealthOverlay" );
	
	player.health = player.maxhealth;
	
	// Init AC130
	
	self Hide();
	self DontCastShadows();
	
	level.custom_friendly_fire_message = "@AC130_FRIENDLY_FIRE";
	level.custom_friendly_fire_shader = "ac130_friendly_fire_icon";
	
	level.ac130player = player;
	level.ac130player TakeAllWeapons();
	level.ac130player.ignoreme = true;
	
	level.radio_in_use = false;
	level.radioForcedTransmissionQueue = [];
	level.lastRadioTransmission = GetTime();
	level.enemiesKilledInTimeWindow = 0;
	
	level.time_of_ac130_fire = GetTime();
	level.player_angles_at_last_ac130_fire = level.ac130player GetPlayerAngles();

	if ( is_coop() )
	{
		level.ac130player Hide();
		level.ac130player.has_no_ir = true;
		setup_coop_ac130_model( 0, 512 );
	}
	
	foreach ( i, weapon in level.weapon_ready_to_fire )
		level.weapon_ready_to_fire[ i ] = true;
	foreach ( i, item in level.weapon_input_cooldown_active )
		level.weapon_input_cooldown_active[ i ] = false;
	foreach ( i, item in level.weapon_cooldown_active )
		level.weapon_cooldown_active[ i ] = false;
	foreach ( i, item in level.weapon_chamber_count )
		level.weapon_chamber_count[ i ] = 1;
			
	level.weapon_ammo_count[ level.weapon_name[ "25" ] ] 	= level.weapon_ammo_max[ level.weapon_name[ "25" ] ];
	level.weapon_ammo_count[ level.weapon_name[ "40" ] ] 	= level.weapon_ammo_max[ level.weapon_name[ "40" ] ] ;
	level.weapon_ammo_count[ level.weapon_name[ "105" ] ] 	= level.weapon_ammo_max[ level.weapon_name[ "105" ] ];

	level.ac130player SetActionSlot( 1, "" );
	level.ac130player SetBlurForPlayer( 0.5, 0 );
	
	SetSavedDvar( "scr_dof_enable", "0" );
	SetSavedDvar( "vehHudTargetSize", level.ac130_HudTargetSize );
	SetSavedDvar( "vehHudTargetScreenEdgeClampBufferLeft", level.ac130_HudTargetScreenEdgeClampBufferLeft );
	SetSavedDvar( "vehHudTargetScreenEdgeClampBufferRight", level.ac130_HudTargetScreenEdgeClampBufferRight );
	SetSavedDvar( "vehHudTargetScreenEdgeClampBufferTop", level.ac130_HudTargetScreenEdgeClampBufferTop );
	SetSavedDvar( "vehHudTargetScreenEdgeClampBufferBottom", level.ac130_HudTargetScreenEdgeClampBufferBottom );
	SetSavedDvar( "laserRange_alt", 1500 );
	
	ac130_reset_view_arc();
	
	if ( !flag( "FLAG_ac130_hud_start" ) )
		thread hud_start( mode );
	
	attach_player();
	
	thread hud_target_toggle_visibility_queue();
	thread no_fire_crosshair();	
	thread monitor_change_weapons();
	thread monitor_change_vision();
	thread monitor_zoom();
	thread monitor_25mm_sound();
	thread change_weapons();
	thread weapon_fire();
	thread ppe_shell_shock();
	thread ppe_vision( mode );
	thread context_Sensitive_Dialog();
	thread shotFired();
	thread clouds();
	thread ac130_rumble_sound();
	
	if ( !is_coop() )
		thread vehicle_scripts\_ac130_amb::main();
	
	flag_set( "FLAG_ac130_change_vision_enabled" );
	flag_set( "FLAG_ac130_change_weapons_enabled" );
	flag_set( "FLAG_ac130_player_in_ac130" );
}

attach_player()
{
	level.ac130_view_rig = ac130_rig_controller( level.ac130_player_view_controller, "player_view_controller_ac130" );
	
    level.ac130player PlayerLinkToDelta( level.ac130_player_view_controller, "tag_player", 1.0,
    									 0, 0, 0, 0, true );
	level.ac130player AllowProne( false );
	level.ac130player AllowCrouch( false );
	level.ac130_view_rig UseBy( level.ac130player );
	level.ac130player DisableTurretDismount();
	level.ac130player LerpViewAngleClamp( 0, 0, 0, 
										  level.ac130_default_right_arc, level.ac130_default_left_arc, level.ac130_default_top_arc, level.ac130_default_bottom_arc );
	
	level.ac130_weapon_sound_tag.origin = level.ac130player.origin;
	level.ac130_weapon_sound_tag LinkTo( level.ac130player );
}

ac130_rig_controller( ent, turret )
{
	Assert( IsDefined( turret ) );
	
	tag = "tag_aim";
	origin = ent GetTagOrigin( tag );
	angles = ent GetTagAngles( tag );
	
	rig = SpawnTurret( "misc_turret", origin, turret );
	rig.angles = angles;
	rig SetModel( "tag_turret" );
	rig LinkTo( ent, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	rig MakeUnusable();
	rig Hide();
	rig SetMode( "manual" );
	rig TurretFireDisable();

	return rig;
}

setup_coop_ac130_model( right_offset, up_offset )
{
	Assert( IsDefined( right_offset ) );
	Assert( IsDefined( up_offset ) );
	
	if ( is_coop() )
	{
		if ( IsDefined( level.coop_ac130_vehicle ) )
			level.coop_ac130_vehicle Delete();
			
		level.coop_ac130_vehicle = Spawn( "script_model", self.origin );
		level.coop_ac130_vehicle.angles = self.angles;
		level.coop_ac130_vehicle SetModel( "vehicle_ac130_low" );
		right = right_offset * AnglesToRight( self.angles );
		up = up_offset * AnglesToUp( self.angles );
		level.coop_ac130_vehicle LinkTo( self, "tag_origin", ( 0, 0, 0 ) + right + up, ( 0, 0, 0 ) );
		level.coop_ac130_vehicle NotSolid();
	}
}

ac130_spawn()
{
	wait 0.05;
	if ( !is_coop() )
		return;

	ac130model = Spawn( "script_model", level.ac130 GetTagOrigin( "tag_player" ) );
	ac130model SetModel( "vehicle_ac130_coop" );

	ac130model PlayLoopSound( "veh_ac130_ext_dist" );
	
	ac130model LinkTo( level.ac130, "tag_player", ( 0, 0, 100 ), ( -25, 0, 0 ) );
}

end_ac130()
{
	level notify( "LISTEN_end_ac130" );
	
	level.custom_friendly_fire_message = undefined;
	level.custom_friendly_fire_shader = undefined;
		
	// Remove HUD elements associated with ac130
	
	array_call2( level.HUDItem, ::Destroy );

	hud_remove_all_targets();
	
	SetSaveDdvar( "scr_dof_enable", "1" );
	SetSavedDvar( "vehHudTargetSize", level.ac130_default_HudTargetSize );
	SetSavedDvar( "vehHudTargetScreenEdgeClampBufferLeft", level.ac130_default_HudTargetScreenEdgeClampBufferLeft );
	SetSavedDvar( "vehHudTargetScreenEdgeClampBufferRight", level.ac130_default_HudTargetScreenEdgeClampBufferRight );
	SetSavedDvar( "vehHudTargetScreenEdgeClampBufferTop", level.ac130_default_HudTargetScreenEdgeClampBufferTop );
	SetSavedDvar( "vehHudTargetScreenEdgeClampBufferBottom", level.ac130_default_HudTargetScreenEdgeClampBufferBottom );
	SetSavedDvar( "laserRange_alt", 5000 );

	flag_clear( "FLAG_ac130_hud_start" );
	flag_clear( "FLAG_ac130_change_vision_enabled" );
	flag_clear( "FLAG_ac130_change_weapons_enabled" );
	flag_clear( "FLAG_ac130_lock_on" );
	flag_clear( "FLAG_ac130_recording" );
			
	// Stop any Post Process Effects
	
	level.ac130player StopShellShock();
	level.ac130player SetBlurForPlayer( 0, 0 );
	
	if ( flag( "FLAG_ac130_thermal_enabled" ) )
		level.ac130player ClearThermalFog();	
	
	level.ac130player ThermalVisionOff();
	level.ac130player LaserAltViewOff();
	
	if ( IsDefined( level.ac130_default_vision_set ) )
	{
		level.ac130player VisionSetNakedForPlayer( level.ac130_default_vision_set );
		maps\_utility::vision_set_fog_changes( level.ac130_default_vision_set, 0 );
	}
	
	level.ac130player UnLink();
	level.ac130player LerpFOV( level.ac130_default_fov, 0.05 );
	level.ac130player ShowViewModel();
	level.ac130player AllowProne( true );
	level.ac130player AllowCrouch( true );
	level.ac130player EnableTurretDismount();
	level.ac130_player_view_controller ClearTargetEntity();
	level.ac130_view_rig Delete();
	
	level.ac130player.ignoreall = false;
	level.ac130player.ignoreme = false;
	level.ac130player DisableInvulnerability();
	
	level.ac130player thread maps\_gameskill::healthOverlay();
	level.ac130player stop_loop_sound_on_entity( "ac130_25mm_fire_loop" );
	
	flag_clear( "FLAG_ac130_player_in_ac130" );
	
	SetSavedDvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "hud_showStance", 1 );
	SetSavedDvar( "g_friendlynamedist", 2000 );
	SetSavedDvar( "sm_cameraoffset", "0" );
	SetSavedDvar( "sv_znear", 0 );
}

// **TODO: Possibly make this generic
autosave_ac130()
{
	level notify( "LISTEN_end_autosave_ac130" );
	level endon( "LISTEN_end_autosave_ac130" );
	
	safe_time_before_autosave = 2.25;
	
	for ( ; ; )
	{
		if ( flag( "game_saving" ) )
		return;
		
		if ( ( GetTime() - level.time_of_ac130_fire ) > safe_time_before_autosave * 1000 )
		{
			if ( flag( "can_save" ) )
				autosave_now();
			return;
		}
		else
		{
			// Do bullet trace based on player's last shoot look at
			
			forward = VectorNormalize( AnglesToForward( level.player_angles_at_last_ac130_fire ) );
			player_eye_pos = level.ac130player GetEye();
			trace_dist = 15000;
			trace  = BulletTrace( player_eye_pos, player_eye_pos + ( forward * trace_dist ), true );
			
			// Check if player shot at any flagged objects
			
			safe_distance_from_friendlies = 256;
			shot_not_near_or_hitting_flagged_objects = 1;
			friendlies = GetAIArray( "allies" );
			
			foreach ( guy in friendlies )
				if ( Distance( guy.origin, trace[ "position" ] ) < Squared( safe_distance_from_friendlies ) )
					shot_not_near_or_hitting_flagged_objects *= 0;
			
			triggers = GetEntArray( "building_trigger", "targetname" );
			
			objects = array_combine( friendlies, triggers );
			
			foreach ( object in objects )
				if ( IsDefined( trace[ "entity" ] ) && trace[ "entity" ] == object )		
					shot_not_near_or_hitting_flagged_objects *= 0;
			
			// Save if the player did not shoot at any flagged objects
					
			if ( shot_not_near_or_hitting_flagged_objects )
			{
				if ( flag( "can_save" ) )
					autosave_now();
				return;
			}
			wait 0.5;
		}
		wait 0.05;
	}
}

ac130_weapon_zoom()
{
	level endon( "LISTEN_end_ac130" );
	
	fov_105 = int( level.ac130_weapon[ 0 ].fov );
	fov_40 = int( level.ac130_weapon[ 1 ].fov );
	fov_25 = int( level.ac130_weapon[ 2 ].fov );
	
	last_time_weapon_changed = GetTime();
	start_polling_joystick_movement = true;
	delay_before_polling_joystick_movement = 0.1;
	time = 1.25; // time per ( fov_105 - fov_25 )
	start_fov = fov_105;
	end_fov = fov_105;
	min_fov = fov_25;
	max_fov = fov_105;
	min_zoom = 1.0;
	max_zoom = 5.0;
	
	for ( ; ; )
	{
		//if ( ( GetTime() - last_time_weapon_changed ) > ( delay_before_polling_joystick_movement * 1000 ) )
		//	start_polling_joystick_movement = true;
		
		if ( start_polling_joystick_movement )
		{
			direction = ( level.ac130player GetNormalizedMovement() )[ 0 ];
			fov_change = false;
			start_fov = GetDvarFloat( "cg_fov" );
			_time = time;
			
			if ( IsSubStr( level.current_weapon, "105" ) )
			{
				if ( direction > 0 && start_fov > fov_25 )
				{
					end_fov = fov_25;
					fov_change = true;
				}
				if ( direction < 0 && start_fov < fov_105 )
				{
					end_fov = fov_105;
					fov_change = true;
				}
			}
			else if ( IsSubStr( level.current_weapon, "40" ) )
			{
				if ( direction > 0 && start_fov > fov_25 )
				{
					end_fov = fov_25;
					fov_change = true;
				}
				if ( direction < 0 && start_fov < fov_105 )
				{
					end_fov = fov_105;
					fov_change = true;
				}
			}
			else if ( IsSubStr( level.current_weapon, "25" ) )
			{
				if ( direction > 0 && start_fov > fov_25 )
				{
					end_fov = fov_25;
					fov_change = true;
				}
				if ( direction < 0 && start_fov < fov_105 )
				{
					end_fov = fov_105;
					fov_change = true;
				}
			}
			
			if ( GetDvarInt( "ac130_zoom_enabled", 1 ) && fov_change )
			{
				delta_fov = end_fov - start_fov;
				_time = ( time / ( fov_105 - fov_25 ) ) * abs( delta_fov );
				level.ac130player LerpFOV( end_fov, _time );
				elapsed = 0;
			
				//while ( !flag( "FLAG_ac130_changed_weapons" ) && elapsed < _time )
				while ( elapsed < _time )
				{
					elapsed += 0.05;
					
					_delta_fov = ( elapsed / _time ) * delta_fov;
					level.ac130_current_fov = ( start_fov + _delta_fov );//Ceil( start_fov + _delta_fov );
					level.ac130_current_fov = ter_op( level.ac130_current_fov > max_fov, max_fov, level.ac130_current_fov );
					level.ac130_current_fov = ter_op( level.ac130_current_fov < min_fov, min_fov, level.ac130_current_fov );
						
					delta = ( max_fov - level.ac130_current_fov ) / ( max_fov - min_fov );
					delta_zoom = delta * ( max_zoom - min_zoom );
					zoom = min_zoom + delta_zoom;;
					zoom = round_to( zoom, 100 );
					
					level.HUDItem[ "zoom" ][ "ones" ] SetValue( return_place( zoom, 1 ) );
					level.HUDItem[ "zoom" ][ "tenths" ] SetValue( return_place( zoom, 0.1 ) );
					level.HUDItem[ "zoom" ][ "hundredths" ] SetValue( return_place( zoom, 0.01 ) );
					
					if ( direction * ( level.ac130player GetNormalizedMovement() )[ 0 ] <= 0 )
					{
						SetSavedDvar( "cg_fov", level.ac130_current_fov );
						level.ac130player LerpFOV( level.ac130_current_fov , ( 1 / 60 ) );
						wait 0.05;
						break;
					}
					wait 0.05;
				}
			}
		}
		/*
		if ( flag( "FLAG_ac130_changed_weapons" ) )
		{	
			start_polling_joystick_movement = false;
			last_time_weapon_changed = GetTime();
		}
		*/
		
		//level.ac130_current_fov = GetDvarFloat( "cg_fov" );
		
		delta = ( max_fov - level.ac130_current_fov )/ ( max_fov - min_fov );
		delta_zoom = delta * ( max_zoom - min_zoom );
		zoom = min_zoom + delta_zoom;
		zoom = round_to( zoom, 100 );
		
		level.HUDItem[ "zoom" ][ "ones" ] SetValue( return_place( zoom, 1 ) );
		level.HUDItem[ "zoom" ][ "tenths" ] SetValue( return_place( zoom, 0.1 ) );
		level.HUDItem[ "zoom" ][ "hundredths" ] SetValue( return_place( zoom, 0.01 ) );
		//wait 0.05;
		wait delay_before_polling_joystick_movement;
	}
}

hud_init( player )
{
	is_split_screen = IsSplitScreen();
	is_wide_screen	= true;
	if ( !( is_specialop() || is_coop() ) )  
		is_wide_screen = GetDvarInt( "widescreen", 1 );
	
	if ( is_split_screen )
	{
		foreach ( weapon in level.ac130_weapon )
		{
			weapon.hudelem_x		*= 0.8;
			weapon.hudelem_y		*= 0.8;
			weapon.shader_width 	= Int( weapon.shader_width * 0.8 );
			weapon.shader_height 	= Int( weapon.shader_height * 0.8 );
		}
		
		level.ac130_hud_mode_fontscale 		*= 0.8;
		level.ac130_hud_misc_fontscale 		*= 0.8;
		level.ac130_hud_weapon_fontscale 	*= 0.8;
		level.ac130_hud_data_fontscale  	*= 0.8;
	}
	
	// Crosshairs
	
	level.HUDItem[ "crosshairs" ][ 0 ] = NewClientHudElem( player );
	level.HUDItem[ "crosshairs" ][ 0 ].x = level.ac130_weapon[ 0 ].hudelem_x;
	level.HUDItem[ "crosshairs" ][ 0 ].y = level.ac130_weapon[ 0 ].hudelem_y;
	level.HUDItem[ "crosshairs" ][ 0 ].alignX = "center";
	level.HUDItem[ "crosshairs" ][ 0 ].alignY = "middle";
	level.HUDItem[ "crosshairs" ][ 0 ].horzAlign = "center";
	level.HUDItem[ "crosshairs" ][ 0 ].vertAlign = "middle";
	level.HUDItem[ "crosshairs" ][ 0 ] SetShader( level.ac130_weapon[ 0 ].overlay, level.ac130_weapon[ 0 ].shader_width, level.ac130_weapon[ 0 ].shader_height );
	level.HUDItem[ "crosshairs" ][ 0 ].sort = -2;
	level.HUDItem[ "crosshairs" ][ 0 ].alpha = 0.0;
	
	level.HUDItem[ "crosshairs" ][ 1 ] = NewClientHudElem( player );
	level.HUDItem[ "crosshairs" ][ 1 ].x = level.ac130_weapon[ 1 ].hudelem_x;
	level.HUDItem[ "crosshairs" ][ 1 ].y = level.ac130_weapon[ 1 ].hudelem_y;
	level.HUDItem[ "crosshairs" ][ 1 ].alignX = "center";
	level.HUDItem[ "crosshairs" ][ 1 ].alignY = "middle";
	level.HUDItem[ "crosshairs" ][ 1 ].horzAlign = "center";
	level.HUDItem[ "crosshairs" ][ 1 ].vertAlign = "middle";
	level.HUDItem[ "crosshairs" ][ 1 ] SetShader( level.ac130_weapon[ 1 ].overlay, level.ac130_weapon[ 1 ].shader_width, level.ac130_weapon[ 1 ].shader_height );
	level.HUDItem[ "crosshairs" ][ 1 ].sort = -2;
	level.HUDItem[ "crosshairs" ][ 1 ].alpha = 0.0;
	
	level.HUDItem[ "crosshairs" ][ 2 ] = NewClientHudElem( player );
	level.HUDItem[ "crosshairs" ][ 2 ].x = level.ac130_weapon[ 2 ].hudelem_x;
	level.HUDItem[ "crosshairs" ][ 2 ].y = level.ac130_weapon[ 2 ].hudelem_y;
	level.HUDItem[ "crosshairs" ][ 2 ].alignX = "center";
	level.HUDItem[ "crosshairs" ][ 2 ].alignY = "middle";
	level.HUDItem[ "crosshairs" ][ 2 ].horzAlign = "center";
	level.HUDItem[ "crosshairs" ][ 2 ].vertAlign = "middle";
	level.HUDItem[ "crosshairs" ][ 2 ] SetShader( level.ac130_weapon[ 2 ].overlay, level.ac130_weapon[ 2 ].shader_width, level.ac130_weapon[ 2 ].shader_height );
	level.HUDItem[ "crosshairs" ][ 2 ].sort = -2;
	level.HUDItem[ "crosshairs" ][ 2 ].alpha = 0.0;
	
	// Crosshairs Corners
	
	width = ter_op( is_split_screen, 128 * 0.8, 128 );
	height = ter_op( is_split_screen, 112 * 0.8, 112 );
	
	level.HUDItem[ "crosshair_corner" ][ "bottom_left" ] = NewClientHudElem( player );
	level.HUDItem[ "crosshair_corner" ][ "bottom_left" ].x = -1 * width;
	level.HUDItem[ "crosshair_corner" ][ "bottom_left" ].y = height;
	level.HUDItem[ "crosshair_corner" ][ "bottom_left" ].alignX = "center";
	level.HUDItem[ "crosshair_corner" ][ "bottom_left" ].alignY = "middle";
	level.HUDItem[ "crosshair_corner" ][ "bottom_left" ].horzAlign = "center";
	level.HUDItem[ "crosshair_corner" ][ "bottom_left" ].vertAlign = "middle";
	level.HUDItem[ "crosshair_corner" ][ "bottom_left" ] SetShader( "ac130_hudb_cornera_bl", 32, 32 );
	level.HUDItem[ "crosshair_corner" ][ "bottom_left" ].sort = -2;
	level.HUDItem[ "crosshair_corner" ][ "bottom_left" ].alpha = 0.0;
	
	level.HUDItem[ "crosshair_corner" ][ "bottom_right" ] = NewClientHudElem( player );
	level.HUDItem[ "crosshair_corner" ][ "bottom_right" ].x = width;
	level.HUDItem[ "crosshair_corner" ][ "bottom_right" ].y = height;
	level.HUDItem[ "crosshair_corner" ][ "bottom_right" ].alignX = "center";
	level.HUDItem[ "crosshair_corner" ][ "bottom_right" ].alignY = "middle";
	level.HUDItem[ "crosshair_corner" ][ "bottom_right" ].horzAlign = "center";
	level.HUDItem[ "crosshair_corner" ][ "bottom_right" ].vertAlign = "middle";
	level.HUDItem[ "crosshair_corner" ][ "bottom_right" ] SetShader( "ac130_hudb_cornera_br", 32, 32 );
	level.HUDItem[ "crosshair_corner" ][ "bottom_right" ].sort = -2;
	level.HUDItem[ "crosshair_corner" ][ "bottom_right" ].alpha = 0.0;
	
	level.HUDItem[ "crosshair_corner" ][ "top_left" ] = NewClientHudElem( player );
	level.HUDItem[ "crosshair_corner" ][ "top_left" ].x = -1 * width;
	level.HUDItem[ "crosshair_corner" ][ "top_left" ].y = -1 * height;
	level.HUDItem[ "crosshair_corner" ][ "top_left" ].alignX = "center";
	level.HUDItem[ "crosshair_corner" ][ "top_left" ].alignY = "middle";
	level.HUDItem[ "crosshair_corner" ][ "top_left" ].horzAlign = "center";
	level.HUDItem[ "crosshair_corner" ][ "top_left" ].vertAlign = "middle";
	level.HUDItem[ "crosshair_corner" ][ "top_left" ] SetShader( "ac130_hudb_cornera_tl", 32, 32 );
	level.HUDItem[ "crosshair_corner" ][ "top_left" ].sort = -2;
	level.HUDItem[ "crosshair_corner" ][ "top_left" ].alpha = 0.0;
	
	level.HUDItem[ "crosshair_corner" ][ "top_right" ] = NewClientHudElem( player );
	level.HUDItem[ "crosshair_corner" ][ "top_right" ].x = width;
	level.HUDItem[ "crosshair_corner" ][ "top_right" ].y = -1 * height;
	level.HUDItem[ "crosshair_corner" ][ "top_right" ].alignX = "center";
	level.HUDItem[ "crosshair_corner" ][ "top_right" ].alignY = "middle";
	level.HUDItem[ "crosshair_corner" ][ "top_right" ].horzAlign = "center";
	level.HUDItem[ "crosshair_corner" ][ "top_right" ].vertAlign = "middle";
	level.HUDItem[ "crosshair_corner" ][ "top_right" ] SetShader( "ac130_hudb_cornera_tr", 32, 32 );
	level.HUDItem[ "crosshair_corner" ][ "top_right" ].sort = -2;
	level.HUDItem[ "crosshair_corner" ][ "top_right" ].alpha = 0.0;

	// Weapon Text
	
	// 105 mm
	
	x = 216;
	if ( is_split_screen )
	{
		x = 162;
		if ( !is_wide_screen )
			x *= 8 / 9;
	}
	else
	if ( !is_wide_screen )
		x *= 5 / 6;
	
	level.HUDItem[ "weapon_text" ][ 0 ] = NewClientHudElem( player );
	level.HUDItem[ "weapon_text" ][ 0 ].x = x;
	level.HUDItem[ "weapon_text" ][ 0 ].y = ter_op( is_split_screen, 60, 114 );
	level.HUDItem[ "weapon_text" ][ 0 ].alignX = "left";
	level.HUDItem[ "weapon_text" ][ 0 ].alignY = "top";
	level.HUDItem[ "weapon_text" ][ 0 ].horzAlign = "fullscreen";
	level.HUDItem[ "weapon_text" ][ 0 ].vertAlign = "fullscreen";
	level.HUDItem[ "weapon_text" ][ 0 ].fontScale = level.ac130_hud_weapon_fontscale;
	level.HUDItem[ "weapon_text" ][ 0 ] SetText( &"AC130_HUD_WEAPON_105MM" );
	level.HUDItem[ "weapon_text" ][ 0 ].alpha = 0.0;
	level.HUDItem[ "weapon_text" ][ 0 ].font = "objective";

	// 40 mm
	
	x = 222;
	if ( is_split_screen )
	{
		x = 165;
		if ( !is_wide_screen )
			x *= 8 / 9;
		x = Ceil( x ) + 1;
	}
	else
	if ( !is_wide_screen )
	{
		x *= 5 / 6;
		x += 3;
	}
		
	level.HUDItem[ "weapon_text" ][ 1 ] = NewClientHudElem( player );
	level.HUDItem[ "weapon_text" ][ 1 ].x = x;
	level.HUDItem[ "weapon_text" ][ 1 ].y = ter_op( is_split_screen, 74, 132 );
	level.HUDItem[ "weapon_text" ][ 1 ].alignX = "left";
	level.HUDItem[ "weapon_text" ][ 1 ].alignY = "top";
	level.HUDItem[ "weapon_text" ][ 1 ].horzAlign = "fullscreen";
	level.HUDItem[ "weapon_text" ][ 1 ].vertAlign = "fullscreen";
	level.HUDItem[ "weapon_text" ][ 1 ].fontScale = level.ac130_hud_weapon_fontscale;
	level.HUDItem[ "weapon_text" ][ 1 ] SetText( &"AC130_HUD_WEAPON_40MM" );
	level.HUDItem[ "weapon_text" ][ 1 ].alpha = 0.0;
	level.HUDItem[ "weapon_text" ][ 1 ].font = "objective";

	// 25 mm
	
	x = 222;
	if ( is_split_screen )
	{
		x = 165;
		if ( !is_wide_screen )
			x *= 8 / 9;
		x = Ceil( x ) + 1;
	}
	else
	if ( !is_wide_screen )
	{
		x *= 5 / 6;
		x += 3;
	}
		
	level.HUDItem[ "weapon_text" ][ 2 ] = NewClientHudElem( player );
	level.HUDItem[ "weapon_text" ][ 2 ].x = x;
	level.HUDItem[ "weapon_text" ][ 2 ].y = ter_op( is_split_screen, 88, 150 );
	level.HUDItem[ "weapon_text" ][ 2 ].alignX = "left";
	level.HUDItem[ "weapon_text" ][ 2 ].alignY = "top";
	level.HUDItem[ "weapon_text" ][ 2 ].horzAlign = "fullscreen";
	level.HUDItem[ "weapon_text" ][ 2 ].vertAlign = "fullscreen";
	level.HUDItem[ "weapon_text" ][ 2 ].fontScale = level.ac130_hud_weapon_fontscale;
	level.HUDItem[ "weapon_text" ][ 2 ] SetText( &"AC130_HUD_WEAPON_25MM" );
	level.HUDItem[ "weapon_text" ][ 2 ].alpha = 0.0;
	level.HUDItem[ "weapon_text" ][ 2 ].font = "objective";

	// Zoom 'x'
	
	x = 390;
	if ( is_split_screen )
	{
		x = 244;
		if ( !is_wide_screen )
			x *= 55 / 52;
	}
	else
	if ( !is_wide_screen )
	{
		x *= 14 / 13;
		x -= 2;
	}
	y = ter_op( is_split_screen, 60, 114 );
	
	level.HUDItem[ "zoom_x" ] = NewClientHudElem( player );
	level.HUDItem[ "zoom_x" ].x = x;
	level.HUDItem[ "zoom_x" ].y = y;  
	level.HUDItem[ "zoom_x" ].alignX = "left";
	level.HUDItem[ "zoom_x" ].alignY = "top";
	level.HUDItem[ "zoom_x" ].horzAlign = "fullscreen";
	level.HUDItem[ "zoom_x" ].vertAlign = "fullscreen";
	level.HUDItem[ "zoom_x" ].fontScale = level.ac130_hud_weapon_fontscale;
	level.HUDItem[ "zoom_x" ] SetText( &"AC130_HUD_ZOOM" );
	level.HUDItem[ "zoom_x" ].alpha = 0.0;
	level.HUDItem[ "zoom_x" ].font = "objective";
	
	// Zoom - ones : period : tenths : hundredths
	
	x = 398;
	if ( is_split_screen )
	{
		x = 249;
		if ( !is_wide_screen )
			x *= 55 / 52;
	}
	else
	if ( !is_wide_screen )
	{
		x *= 14 / 13;
		x -= 2;
	}
		
	level.HUDItem[ "zoom" ][ "ones" ] = NewClientHudElem( player );
	level.HUDItem[ "zoom" ][ "ones" ].x = x;
	level.HUDItem[ "zoom" ][ "ones" ].y = y;
	level.HUDItem[ "zoom" ][ "ones" ].alignX = "left";
	level.HUDItem[ "zoom" ][ "ones" ].alignY = "top";
	level.HUDItem[ "zoom" ][ "ones" ].horzAlign = "fullscreen";
	level.HUDItem[ "zoom" ][ "ones" ].vertAlign = "fullscreen";
	level.HUDItem[ "zoom" ][ "ones" ].fontScale = level.ac130_hud_weapon_fontscale;
	level.HUDItem[ "zoom" ][ "ones" ] SetValue( 1 );
	level.HUDItem[ "zoom" ][ "ones" ].alpha = 0.0;
	level.HUDItem[ "zoom" ][ "ones" ].font = "objective";
	
	x = 405;
	if ( is_split_screen )
	{
		x = 253;
		if ( !is_wide_screen )
			x *= 55 / 52;
		x = Ceil( x );
	}
	else
	if ( !is_wide_screen )
	{
		x *= 14 / 13;
		x -= 1;
	}
		
	level.HUDItem[ "zoom" ][ "period" ] = NewClientHudElem( player );
	level.HUDItem[ "zoom" ][ "period" ].x = x;
	level.HUDItem[ "zoom" ][ "period" ].y = y;
	level.HUDItem[ "zoom" ][ "period" ].alignX = "left";
	level.HUDItem[ "zoom" ][ "period" ].alignY = "top";
	level.HUDItem[ "zoom" ][ "period" ].horzAlign = "fullscreen";
	level.HUDItem[ "zoom" ][ "period" ].vertAlign = "fullscreen";
	level.HUDItem[ "zoom" ][ "period" ].fontScale = level.ac130_hud_weapon_fontscale;
	level.HUDItem[ "zoom" ][ "period" ] SetText( &"AC130_HUD_PERIOD" );
	level.HUDItem[ "zoom" ][ "period" ].alpha = 0.0;
	level.HUDItem[ "zoom" ][ "period" ].font = "objective";
	
	x = 408;
	if ( is_split_screen )
	{
		x = 256;
		if ( !is_wide_screen )
			x *= 55 / 52;
		x = Floor( x );
	}
	else
	if ( !is_wide_screen )
		x *= 14 / 13;
		
	level.HUDItem[ "zoom" ][ "tenths" ] = NewClientHudElem( player );
	level.HUDItem[ "zoom" ][ "tenths" ].x = x;
	level.HUDItem[ "zoom" ][ "tenths" ].y = y;
	level.HUDItem[ "zoom" ][ "tenths" ].alignX = "left";
	level.HUDItem[ "zoom" ][ "tenths" ].alignY = "top";
	level.HUDItem[ "zoom" ][ "tenths" ].horzAlign = "fullscreen";
	level.HUDItem[ "zoom" ][ "tenths" ].vertAlign = "fullscreen";
	level.HUDItem[ "zoom" ][ "tenths" ].fontScale = level.ac130_hud_weapon_fontscale;
	level.HUDItem[ "zoom" ][ "tenths" ] SetValue( 0 );
	level.HUDItem[ "zoom" ][ "tenths" ].alpha = 0.0;
	level.HUDItem[ "zoom" ][ "tenths" ].font = "objective";
	
	x = 416;
	if ( is_split_screen )
	{
		x = 260;
		if ( !is_wide_screen )
			x *= 55 / 52;
	}
	else
	if ( !is_wide_screen )
		x *= 14 / 13;
		
	level.HUDItem[ "zoom" ][ "hundredths" ] = NewClientHudElem( player );
	level.HUDItem[ "zoom" ][ "hundredths" ].x = x;
	level.HUDItem[ "zoom" ][ "hundredths" ].y = y;
	level.HUDItem[ "zoom" ][ "hundredths" ].alignX = "left";
	level.HUDItem[ "zoom" ][ "hundredths" ].alignY = "top";
	level.HUDItem[ "zoom" ][ "hundredths" ].horzAlign = "fullscreen";
	level.HUDItem[ "zoom" ][ "hundredths" ].vertAlign = "fullscreen";
	level.HUDItem[ "zoom" ][ "hundredths" ].fontScale = level.ac130_hud_weapon_fontscale;
	level.HUDItem[ "zoom" ][ "hundredths" ] SetValue( 0 );
	level.HUDItem[ "zoom" ][ "hundredths" ].alpha = 0.0;
	level.HUDItem[ "zoom" ][ "hundredths" ].font = "objective";
	
	// Player Data
	/*
	y = ter_op( is_split_screen, 224, 300 );
	
	// -- Pitch
	
	level.HUDItem[ "player_pitch" ] = NewClientHudElem( player );
	level.HUDItem[ "player_pitch" ].x = ter_op( is_split_screen, 180, 250 );
	level.HUDItem[ "player_pitch" ].y = y;
	level.HUDItem[ "player_pitch" ].alignX = "left";
	level.HUDItem[ "player_pitch" ].alignY = "top";
	level.HUDItem[ "player_pitch" ].horzAlign = "fullscreen";
	level.HUDItem[ "player_pitch" ].vertAlign = "fullscreen";
	level.HUDItem[ "player_pitch" ].fontScale = level.ac130_hud_data_fontscale;
	level.HUDItem[ "player_pitch" ] SetValue( 0 );
	level.HUDItem[ "player_pitch" ].alpha = 0.0;
	level.HUDItem[ "player_pitch" ].sort = -4;
	
	// -- Yaw
	
	level.HUDItem[ "player_yaw" ] = NewClientHudElem( player );
	level.HUDItem[ "player_yaw" ].x = ter_op( is_split_screen, 196, 280 );
	level.HUDItem[ "player_yaw" ].y = y;
	level.HUDItem[ "player_yaw" ].alignX = "left";
	level.HUDItem[ "player_yaw" ].alignY = "top";
	level.HUDItem[ "player_yaw" ].horzAlign = "fullscreen";
	level.HUDItem[ "player_yaw" ].vertAlign = "fullscreen";
	level.HUDItem[ "player_yaw" ].fontScale = level.ac130_hud_data_fontscale;
	level.HUDItem[ "player_yaw" ] SetValue( 0 );
	level.HUDItem[ "player_yaw" ].alpha = 0.0;
	level.HUDItem[ "player_yaw" ].sort = -4;
	
	// AC130 Info
	
	// -- Pitch
	
	level.HUDItem[ "ac130_pitch" ] = NewClientHudElem( player );
	level.HUDItem[ "ac130_pitch" ].x = ter_op( is_split_screen, 218, 335 );
	level.HUDItem[ "ac130_pitch" ].y = y;
	level.HUDItem[ "ac130_pitch" ].alignX = "left";
	level.HUDItem[ "ac130_pitch" ].alignY = "top";
	level.HUDItem[ "ac130_pitch" ].horzAlign = "fullscreen";
	level.HUDItem[ "ac130_pitch" ].vertAlign = "fullscreen";
	level.HUDItem[ "ac130_pitch" ].fontScale = level.ac130_hud_data_fontscale;
	level.HUDItem[ "ac130_pitch" ] SetValue( 0 );
	level.HUDItem[ "ac130_pitch" ].alpha = 0.0;
	level.HUDItem[ "ac130_pitch" ].sort = -4;
	
	// -- Yaw
	
	level.HUDItem[ "ac130_yaw" ] = NewClientHudElem( player );
	level.HUDItem[ "ac130_yaw" ].x = ter_op( is_split_screen, 234, 365 );
	level.HUDItem[ "ac130_yaw" ].y = y;
	level.HUDItem[ "ac130_yaw" ].alignX = "left";
	level.HUDItem[ "ac130_yaw" ].alignY = "top";
	level.HUDItem[ "ac130_yaw" ].horzAlign = "fullscreen";
	level.HUDItem[ "ac130_yaw" ].vertAlign = "fullscreen";
	level.HUDItem[ "ac130_yaw" ].fontScale = level.ac130_hud_data_fontscale;
	level.HUDItem[ "ac130_yaw" ] SetValue( 0 );
	level.HUDItem[ "ac130_yaw" ].alpha = 0.0;
	level.HUDItem[ "ac130_yaw" ].sort = -4;
	
	// -- Roll
	
	level.HUDItem[ "ac130_roll" ] = NewClientHudElem( player );
	level.HUDItem[ "ac130_roll" ].x = ter_op( is_split_screen, 250, 395 );
	level.HUDItem[ "ac130_roll" ].y = y;
	level.HUDItem[ "ac130_roll" ].alignX = "left";
	level.HUDItem[ "ac130_roll" ].alignY = "top";
	level.HUDItem[ "ac130_roll" ].horzAlign = "fullscreen";
	level.HUDItem[ "ac130_roll" ].vertAlign = "fullscreen";
	level.HUDItem[ "ac130_roll" ].fontScale = level.ac130_hud_data_fontscale;
	level.HUDItem[ "ac130_roll" ] SetValue( 0 );
	level.HUDItem[ "ac130_roll" ].alpha = 0.0;
	level.HUDItem[ "ac130_roll" ].sort = -4;
	
	y = ter_op( is_split_screen, 234, 310 );
	
	// -- Position X
	
	level.HUDItem[ "ac130_position_x" ] = NewClientHudElem( player );
	level.HUDItem[ "ac130_position_x" ].x = ter_op( is_split_screen, 218, 335 );;
	level.HUDItem[ "ac130_position_x" ].y = y;
	level.HUDItem[ "ac130_position_x" ].alignX = "left";
	level.HUDItem[ "ac130_position_x" ].alignY = "top";
	level.HUDItem[ "ac130_position_x" ].horzAlign = "fullscreen";
	level.HUDItem[ "ac130_position_x" ].vertAlign = "fullscreen";
	level.HUDItem[ "ac130_position_x" ].fontScale = level.ac130_hud_data_fontscale;
	level.HUDItem[ "ac130_position_x" ] SetValue( 0 );
	level.HUDItem[ "ac130_position_x" ].alpha = 0.0;
	level.HUDItem[ "ac130_position_x" ].sort = -4;
	
	// -- Position Y
	
	level.HUDItem[ "ac130_position_y" ] = NewClientHudElem( player );
	level.HUDItem[ "ac130_position_y" ].x = ter_op( is_split_screen, 234, 365 );
	level.HUDItem[ "ac130_position_y" ].y = y;
	level.HUDItem[ "ac130_position_y" ].alignX = "left";
	level.HUDItem[ "ac130_position_y" ].alignY = "top";
	level.HUDItem[ "ac130_position_y" ].horzAlign = "fullscreen";
	level.HUDItem[ "ac130_position_y" ].vertAlign = "fullscreen";
	level.HUDItem[ "ac130_position_y" ].fontScale = level.ac130_hud_data_fontscale;
	level.HUDItem[ "ac130_position_y" ] SetValue( 0 );
	level.HUDItem[ "ac130_position_y" ].alpha = 0.0;
	level.HUDItem[ "ac130_position_y" ].sort = -4;
	
	// -- Position Z
	
	level.HUDItem[ "ac130_position_z" ] = NewClientHudElem( player );
	level.HUDItem[ "ac130_position_z" ].x = ter_op( is_split_screen, 250, 395 );
	level.HUDItem[ "ac130_position_z" ].y = y;
	level.HUDItem[ "ac130_position_z" ].alignX = "left";
	level.HUDItem[ "ac130_position_z" ].alignY = "top";
	level.HUDItem[ "ac130_position_z" ].horzAlign = "fullscreen";
	level.HUDItem[ "ac130_position_z" ].vertAlign = "fullscreen";
	level.HUDItem[ "ac130_position_z" ].fontScale = level.ac130_hud_data_fontscale;
	level.HUDItem[ "ac130_position_z" ] SetValue( 0 );
	level.HUDItem[ "ac130_position_z" ].alpha = 0.0;
	level.HUDItem[ "ac130_position_z" ].sort = -4;
	*/
	// Thermal
	
	// -- Grain
	
	level.HUDItem[ "grain" ] = NewClientHudElem( player );
	level.HUDItem[ "grain" ].x = 0;
	level.HUDItem[ "grain" ].y = 0;
	level.HUDItem[ "grain" ].alignX = "left";
	level.HUDItem[ "grain" ].alignY = "top";
	level.HUDItem[ "grain" ].horzAlign = "fullscreen";
	level.HUDItem[ "grain" ].vertAlign = "fullscreen";
	level.HUDItem[ "grain" ] SetShader( "ac130_overlay_grain", 640, 480 );
	level.HUDItem[ "grain" ].alpha = 0.0;// 0.4
	level.HUDItem[ "grain" ].sort = -3;
	
	// -- Thermal
	/*
	level.HUDItem[ "thermal_overlay" ] = NewClientHudElem( player );
	level.HUDItem[ "thermal_overlay" ].x = 0;
	level.HUDItem[ "thermal_overlay" ].y = 0;
	level.HUDItem[ "thermal_overlay" ].alignX = "left";
	level.HUDItem[ "thermal_overlay" ].alignY = "top";
	level.HUDItem[ "thermal_overlay" ].horzAlign = "fullscreen";
	level.HUDItem[ "thermal_overlay" ].vertAlign = "fullscreen";
	level.HUDItem[ "thermal_overlay" ] SetShader( "ac130_thermal_overlay", 640, 480 );
	level.HUDItem[ "thermal_overlay" ].alpha = 0.0;
	level.HUDItem[ "thermal_overlay" ].sort = -2;
	*/
	// "TV" Bar - Thick
	
	level.HUDItem[ "bar_1" ] = NewClientHudElem( player );
	level.HUDItem[ "bar_1" ].x = 0;
	level.HUDItem[ "bar_1" ].y = -128;
	level.HUDItem[ "bar_1" ].alignX = "left";
	level.HUDItem[ "bar_1" ].alignY = "top";
	level.HUDItem[ "bar_1" ].horzAlign = "fullscreen";
	level.HUDItem[ "bar_1" ].vertAlign = "fullscreen";
	level.HUDItem[ "bar_1" ] SetShader( "ac130_thermal_overlay_bar", 640, 320 );
	level.HUDItem[ "bar_1" ].alpha = 0.0;
	level.HUDItem[ "bar_1" ].sort = -1;
	
	// "TV" Bar - Thin
	
	level.HUDItem[ "bar_2" ] = NewClientHudElem( player );
	level.HUDItem[ "bar_2" ].x = 0;
	level.HUDItem[ "bar_2" ].y = -128;
	level.HUDItem[ "bar_2" ].alignX = "left";
	level.HUDItem[ "bar_2" ].alignY = "top";
	level.HUDItem[ "bar_2" ].horzAlign = "fullscreen";
	level.HUDItem[ "bar_2" ].vertAlign = "fullscreen";
	level.HUDItem[ "bar_2" ] SetShader( "ac130_thermal_overlay_bar", 640, 128 );
	level.HUDItem[ "bar_2" ].alpha = 0.0;
	level.HUDItem[ "bar_2" ].sort = -1;
	
	// Static
	
	level.HUDItem[ "static" ] = NewClientHudElem( player );
	level.HUDItem[ "static" ].x = 0;
	level.HUDItem[ "static" ].y = 0;
	level.HUDItem[ "static" ].alignX = "left";
	level.HUDItem[ "static" ].alignY = "top";
	level.HUDItem[ "static" ].horzAlign = "fullscreen";
	level.HUDItem[ "static" ].vertAlign = "fullscreen";
	level.HUDItem[ "static" ] SetShader( "overlay_static", 640, 480 );
	level.HUDItem[ "static" ].alpha = 0.0;
	level.HUDItem[ "static" ].sort = -3;
	
	// LOCK ON
	
	level.HUDItem[ "lock_on" ] = NewClientHudElem( player );
	level.HUDItem[ "lock_on" ].x = 250;
	level.HUDItem[ "lock_on" ].y = 200;
	level.HUDItem[ "lock_on" ].alignX = "left";
	level.HUDItem[ "lock_on" ].alignY = "top";
	level.HUDItem[ "lock_on" ].horzAlign = "fullscreen";
	level.HUDItem[ "lock_on" ].vertAlign = "fullscreen";
	level.HUDItem[ "lock_on" ].fontScale = 2.0;
	level.HUDItem[ "lock_on" ] SetText( &"AC130_HUD_LOCK_ON" );
	level.HUDItem[ "lock_on" ].color = ( 1, 0, 0 );
	level.HUDItem[ "lock_on" ].alpha = 0.0;
	level.HUDItem[ "lock_on" ].font = "objective";
	
	// FLIR
	
	x = 200;
	y = 10;
	if ( is_split_screen )
	{
		x = 132;
		y = 15;
		if ( !is_wide_screen )
			y = 20;
	}
	else
	if ( !is_wide_screen )
	{
		x = 180;
		y = 15;
	}
		
	level.HUDItem[ "flir" ] = NewClientHudElem( player );
	level.HUDItem[ "flir" ].x = x;
	level.HUDItem[ "flir" ].y = y;
	level.HUDItem[ "flir" ].alignX = "left";
	level.HUDItem[ "flir" ].alignY = "top";
	level.HUDItem[ "flir" ].horzAlign = "fullscreen";
	level.HUDItem[ "flir" ].vertAlign = "fullscreen";
	level.HUDItem[ "flir" ].fontScale = level.ac130_hud_mode_fontscale;
	level.HUDItem[ "flir" ] SetText( &"AC130_HUD_FLIR" );
	level.HUDItem[ "flir" ].alpha = 0.0;
	level.HUDItem[ "flir" ].font = "objective";
	
	// OPTICS - OPT
	
	x = 400;
	y = 10;
	if ( is_split_screen )
	{
		x = 270;
		y = 15;
		if ( !is_wide_screen )
		{
			x = 268;
			y = 20;
		}
	}
	else
	if ( !is_wide_screen )
		y = 15;
		
	level.HUDItem[ "enhanced" ] = NewClientHudElem( player );
	level.HUDItem[ "enhanced" ].x = x;
	level.HUDItem[ "enhanced" ].y = y;
	level.HUDItem[ "enhanced" ].alignX = "left";
	level.HUDItem[ "enhanced" ].alignY = "top";
	level.HUDItem[ "enhanced" ].horzAlign = "fullscreen";
	level.HUDItem[ "enhanced" ].vertAlign = "fullscreen";
	level.HUDItem[ "enhanced" ].fontScale = level.ac130_hud_mode_fontscale;
	level.HUDItem[ "enhanced" ] SetText( &"AC130_HUD_OPTICS" );
	level.HUDItem[ "enhanced" ].alpha = 0.0;
	level.HUDItem[ "enhanced" ].font = "objective";
	
	// RECORDING - REC
	
	x = 15;
	y = 440;
	if ( is_split_screen )
	{
		x = 12;
		y = 300;
		if ( !is_wide_screen )
			x = 16;
		if ( player == level.players[ 1 ] )
			y = 280;
	}
	else
	if ( !is_wide_screen )
		x = 40;
		
	level.HUDItem[ "recording" ] = NewClientHudElem( player );
	level.HUDItem[ "recording" ].x = x;
	level.HUDItem[ "recording" ].y = y;
	level.HUDItem[ "recording" ].alignX = "left";
	level.HUDItem[ "recording" ].alignY = "top";
	level.HUDItem[ "recording" ].horzAlign = "fullscreen";
	level.HUDItem[ "recording" ].vertAlign = "fullscreen";
	level.HUDItem[ "recording" ].fontScale = level.ac130_hud_misc_fontscale;
	level.HUDItem[ "recording" ] SetText( &"AC130_HUD_RECORDING" );
	level.HUDItem[ "recording" ].alpha = 0.0;
	level.HUDItem[ "recording" ].font = "objective";
	
	// AMMO
	
	x = 440;
	if ( is_split_screen )
	{
		x = 270;
		if ( !is_wide_screen )
			x *= 55 / 52;
	}
	else
	if ( !is_wide_screen )
		x *= 55 / 52;
	y = ter_op( is_split_screen, 154, 232 );
		
	level.HUDItem[ "ammo" ][ "name" ] = NewClientHudElem( player );
	level.HUDItem[ "ammo" ][ "name" ].x = x;
	level.HUDItem[ "ammo" ][ "name" ].y = y;
	level.HUDItem[ "ammo" ][ "name" ].alignX = "left";
	level.HUDItem[ "ammo" ][ "name" ].alignY = "top";
	level.HUDItem[ "ammo" ][ "name" ].horzAlign = "fullscreen";
	level.HUDItem[ "ammo" ][ "name" ].vertAlign = "fullscreen";
	level.HUDItem[ "ammo" ][ "name" ].fontScale = level.ac130_hud_data_fontscale;
	level.HUDItem[ "ammo" ][ "name" ] SetText( &"AC130_HUD_AMMO" );
	level.HUDItem[ "ammo" ][ "name" ].alpha = 0.0;
	level.HUDItem[ "ammo" ][ "name" ].font = "objective";
	
	// AMMO - Chamber
	
	x = 465;
	if ( is_split_screen )
	{
		x = 284;
		if ( !is_wide_screen )
		{
			x  *= 55 / 52;
			x	= Ceil( x ) + 5;
		}
	}
	else
	if ( !is_wide_screen )
	{
		x *= 55 / 52;
		x += 6;
	}
		
	level.HUDItem[ "ammo" ][ "chamber" ] = NewClientHudElem( player );
	level.HUDItem[ "ammo" ][ "chamber" ].x = x;
	level.HUDItem[ "ammo" ][ "chamber" ].y = y;
	level.HUDItem[ "ammo" ][ "chamber" ].alignX = "left";
	level.HUDItem[ "ammo" ][ "chamber" ].alignY = "top";
	level.HUDItem[ "ammo" ][ "chamber" ].horzAlign = "fullscreen";
	level.HUDItem[ "ammo" ][ "chamber" ].vertAlign = "fullscreen";
	level.HUDItem[ "ammo" ][ "chamber" ].fontScale = level.ac130_hud_data_fontscale;
	level.HUDItem[ "ammo" ][ "chamber" ] SetValue( 1 );
	level.HUDItem[ "ammo" ][ "chamber" ].alpha = 0.0;
	level.HUDItem[ "ammo" ][ "chamber" ].font = "objective";
	
	// AMMO - Colon
	
	x = 470;
	if ( is_split_screen )
	{
		x = 288;
		if ( !is_wide_screen )
		{
			x *= 55 / 52;
			x += 5;
		}
	}
	else
	if ( !is_wide_screen )
	{
		x *= 55 / 52;
		x += 9;
	}
		
	level.HUDItem[ "ammo" ][ "colon" ] = NewClientHudElem( player );
	level.HUDItem[ "ammo" ][ "colon" ].x = x;
	level.HUDItem[ "ammo" ][ "colon" ].y = y;
	level.HUDItem[ "ammo" ][ "colon" ].alignX = "left";
	level.HUDItem[ "ammo" ][ "colon" ].alignY = "top";
	level.HUDItem[ "ammo" ][ "colon" ].horzAlign = "fullscreen";
	level.HUDItem[ "ammo" ][ "colon" ].vertAlign = "fullscreen";
	level.HUDItem[ "ammo" ][ "colon" ].fontScale = level.ac130_hud_data_fontscale;
	level.HUDItem[ "ammo" ][ "colon" ] SetText( &"AC130_HUD_COLON" );
	level.HUDItem[ "ammo" ][ "colon" ].alpha = 0.0;
	level.HUDItem[ "ammo" ][ "colon" ].font = "objective";
	
	// AMMO - Rounds

	x = 475;
	if ( is_split_screen )
	{
		x = 291;
		if ( !is_wide_screen )
		{
			x *= 55 / 52;
			x += 5;
		}
	}
	else
	if ( !is_wide_screen )
	{
		x *= 55 / 52;
		x += 10;
	}
		
	level.HUDItem[ "ammo" ][ "rounds" ] = NewClientHudElem( player );
	level.HUDItem[ "ammo" ][ "rounds" ].x = x;
	level.HUDItem[ "ammo" ][ "rounds" ].y = y;
	level.HUDItem[ "ammo" ][ "rounds" ].alignX = "left";
	level.HUDItem[ "ammo" ][ "rounds" ].alignY = "top";
	level.HUDItem[ "ammo" ][ "rounds" ].horzAlign = "fullscreen";
	level.HUDItem[ "ammo" ][ "rounds" ].vertAlign = "fullscreen";
	level.HUDItem[ "ammo" ][ "rounds" ].fontScale = level.ac130_hud_data_fontscale;
	level.HUDItem[ "ammo" ][ "rounds" ] SetValue( 1 );
	level.HUDItem[ "ammo" ][ "rounds" ].alpha = 0.0;
	level.HUDItem[ "ammo" ][ "rounds" ].font = "objective";
	
	// RELOADING
	
	x = 440;
	if ( is_split_screen )
	{
		x = 270;
		if ( !is_wide_screen )
			x *= 55 / 52;
	}
	else
	if ( !is_wide_screen )
		x *= 55 / 52;
		
	level.HUDItem[ "reloading" ] = NewClientHudElem( player );
	level.HUDItem[ "reloading" ].x = x;
	level.HUDItem[ "reloading" ].y = ter_op( is_split_screen, 164, 244 );
	level.HUDItem[ "reloading" ].alignX = "left";
	level.HUDItem[ "reloading" ].alignY = "top";
	level.HUDItem[ "reloading" ].horzAlign = "fullscreen";
	level.HUDItem[ "reloading" ].vertAlign = "fullscreen";
	level.HUDItem[ "reloading" ].fontScale = level.ac130_hud_data_fontscale;
	level.HUDItem[ "reloading" ] SetText( &"AC130_HUD_RELOADING" );
	level.HUDItem[ "reloading" ].alpha = 0.0;
	level.HUDItem[ "reloading" ].font = "objective";
}

hud_start( mode )
{
	mode = ter_op( IsDefined( mode ), mode, "enhanced" );
	mode = ter_op( mode == "enhanced", mode, "thermal" );
	
	wait 0.05;
		
	if ( !is_coop() )
	{
		SetSavedDvar( "compass", 0 );
		SetSavedDvar( "g_friendlynamedist", 0 );
		SetSavedDvar( "ammoCounterHide", "1" );
		SetSavedDvar( "hud_showStance", 0 );
	}
	else
	{
		SetSavedDvar( "compass", 1 );
		SetSavedDvar( "g_friendlynamedist", 2000 );
	}
		

	
	hud_init( level.ac130player );
	hud_on( mode );
	//thread hud_update_player_data();
	//thread hud_update_ac130_data();
	thread hud_blink_current_weapon_name( 0 );
	thread hud_blink_reloading();
	thread hud_update_tv_bar_1();
	thread hud_udpate_tv_bar_2( 1.0 );
	//thread hud_blur();
	thread hud_weapon_fire();
	thread hud_zoom();	
	//thread ac130_weapon_zoom();
	thread hud_blink_crosshairs( level.weapon_name[ "25" ] );
	thread hud_blink_crosshairs( level.weapon_name[ "40" ] );
	thread hud_blink_crosshairs( level.weapon_name[ "105" ] );
	
	flag_set( "FLAG_ac130_hud_start" );
}

array_set_key( array, value, key )
{
	Assert( IsDefined( array ) && IsArray( array ) );
	Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	
	foreach( item in array )
		if ( IsArray( item ) )
			array_set_key( item, value, key );
		else
			if ( IsDefined( item ) )
				switch( key )
				{
					case "alpha":
						item.alpha = value;
						break;
					case "sort":
						item.sort = value;
						break;
				}
				
}

array_thread2( ents, process, args )
{
	Assert( IsDefined( ents ) );
	Assert( IsDefined( process ) );
	
	if ( !IsDefined( args ) )
	{
		foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_thread2( ent, process );
			else
				ent thread [[ process ]]();
		return;
	}
	
	Assert( IsArray( args ) );
				
	switch( args.size )
	{
		case 0:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_thread2( ent, process, args );
			else
				ent thread [[ process ]]();
			break;
		case 1:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_thread2( ent, process, args );
			else
				ent thread [[ process ]]( args[ 0 ] );
			break;
		case 2:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_thread2( ent, process, args );
			else
				ent thread [[ process ]]( args[ 0 ], args[ 1 ] );
			break;
		case 3:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_thread2( ent, process, args );
			else
				ent thread [[ process ]]( args[ 0 ], args[ 1 ], args[ 2 ] );
			break;
		case 4:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_thread2( ent, process, args );
			else
				ent thread [[ process ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ] );
			break;
		case 5:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_thread2( ent, process, args );
			else
				ent thread [[ process ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ] );
			break;
	}
	return;
}

array_call2( ents, process, args )
{
	Assert( IsDefined( ents ) );
	Assert( IsDefined( process ) );
	
	if ( !IsDefined( args ) )
	{
		foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_call2( ent, process );
			else
				ent call [[ process ]]();
		return;
	}
	
	Assert( IsArray( args ) );
				
	switch( args.size )
	{
		case 0:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_call2( ent, process, args );
			else
				ent call [[ process ]]();
			break;
		case 1:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_call2( ent, process, args );
			else
				ent call [[ process ]]( args[ 0 ] );
			break;
		case 2:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_call2( ent, process, args );
			else
				ent call [[ process ]]( args[ 0 ], args[ 1 ] );
			break;
		case 3:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_call2( ent, process, args );
			else
				ent call [[ process ]]( args[ 0 ], args[ 1 ], args[ 2 ] );
			break;
		case 4:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_call2( ent, process, args );
			else
				ent call [[ process ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ] );
			break;
		case 5:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				array_call2( ent, process, args );
			else
				ent call [[ process ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ] );
			break;
	}
	return;
}

hud_on( vision, time )
{
	vision = ter_op( IsDefined( vision ), vision, "thermal" );
	vision = ter_op( vision == "thermal", vision, "enhanced" );
	time = ter_op( IsDefined( time ), time, 0 );
	time = ter_op( time > 0, time, 0 );

	if ( time > 0 )
		array_call2( level.HUDItem, ::FadeOverTime, [ time ] );
	
	current_weapon = 0;
	
	if ( IsSubStr( level.current_weapon, "40" ) )
		current_weapon  = 1;
	if ( IsSubStr( level.current_weapon, "25" ) )
		current_weapon = 2;
						
	// Crosshairs
	
	level.HUDItem[ "crosshairs" ][ current_weapon ].alpha = 1.0;
	
	// Crosshair Corners
	level.HUDItem[ "crosshair_corner" ][ "bottom_left" ].alpha = 1.0;
	level.HUDItem[ "crosshair_corner" ][ "bottom_right" ].alpha = 1.0;
	level.HUDItem[ "crosshair_corner" ][ "top_left" ].alpha = 1.0;
	level.HUDItem[ "crosshair_corner" ][ "top_right" ].alpha = 1.0;
	
	// Weapon Text

	// 		 : 105 mm
	level.HUDItem[ "weapon_text" ][ 0 ].alpha = ter_op( IsSubStr( level.current_weapon, "105" ), 1.0, 0.2 );
	// 		 : 40 mm
	level.HUDItem[ "weapon_text" ][ 1 ].alpha = ter_op( IsSubStr( level.current_weapon, "40" ), 1.0, 0.2 );
	//		 : 25 mm
	level.HUDItem[ "weapon_text" ][ 2 ].alpha = ter_op( IsSubStr( level.current_weapon, "20" ), 1.0, 0.2 );
	
	// Zoom 'x'
	level.HUDItem[ "zoom_x" ].alpha = 0.5;
	
	// Zoom - ones : period : tenths : hundredths
	level.HUDItem[ "zoom" ][ "ones" ].alpha = 0.5;
	level.HUDItem[ "zoom" ][ "period" ].alpha = 0.5;
	level.HUDItem[ "zoom" ][ "tenths" ].alpha = 0.5;
	level.HUDItem[ "zoom" ][ "hundredths" ].alpha = 0.5;
		
	// Player Data
	/*
	// -- Pitch
	level.HUDItem[ "player_pitch" ].alpha = 0.5;
	
	// -- Yaw
	level.HUDItem[ "player_yaw" ].alpha = 0.5;
	
	// AC130 Info
	
	// -- Pitch
	level.HUDItem[ "ac130_pitch" ].alpha = 0.5;
	// -- Yaw
	level.HUDItem[ "ac130_yaw" ].alpha = 0.5;
	// -- Roll
	level.HUDItem[ "ac130_roll" ].alpha = 0.5;
	// -- Position X
	level.HUDItem[ "ac130_position_x" ].alpha = 0.5;
	// -- Position Y
	level.HUDItem[ "ac130_position_y" ].alpha = 0.5;
	// -- Position Z
	level.HUDItem[ "ac130_position_z" ].alpha = 0.5;
	*/
	// Thermal
	
	// -- Grain
	level.HUDItem[ "grain" ].alpha = ter_op( vision == "thermal", level.ac130_thermal_grain, level.ac130_enhanced_grain );
	// -- Thermal
	//level.HUDItem[ "thermal_overlay" ].alpha = ter_op( vision == "thermal", 1.0, 0.0 );
	
	// "TV" Bar - Thick
	level.HUDItem[ "bar_1" ].alpha = 1.0;
	// "TV" Bar - Thin
	level.HUDItem[ "bar_2" ].alpha = 1.0;
	
	// FLIR
	level.HUDItem[ "flir" ].alpha = ter_op( vision == "thermal", 1.0, 0.2 );
	
	// OPTICS - OPT
	level.HUDItem[ "enhanced" ].alpha = ter_op( vision == "thermal", 0.2, 1.0 );
	
	// RECORDING - REC
	level.HUDItem[ "recording" ].alpha = 0.5;
	
	// AMMO
	level.HUDItem[ "ammo" ][ "name" ].alpha = 0.5;
	// AMMO - Chamber
	level.HUDItem[ "ammo" ][ "chamber" ].alpha = 0.5;
	// AMMO - Colon
	level.HUDItem[ "ammo" ][ "colon" ].alpha = 0.5;
	// AMMO - Rounds
	level.HUDItem[ "ammo" ][ "rounds" ].alpha = 0.5;
	
	flag_set( "FLAG_ac130_hud_on" );
}

hud_off()
{
	static_alpha = level.HUDItem[ "static" ].alpha;
	grain_alpha = level.HUDItem[ "grain" ].alpha;
	lock_on_alpha = level.HUDItem[ "lock_on" ].alpha;
	
	array_set_key( level.HUDItem, 0, "alpha" );

	level.HUDItem[ "static" ].alpha = static_alpha;
	level.HUDItem[ "grain" ].alpha = grain_alpha;
	level.HUDItem[ "lock_on" ].alpha = lock_on_alpha;
						
	flag_clear( "FLAG_ac130_hud_on" );
}

hud_create_box( player, shader, thickness, width, height, x, y )
{
	Assert( IsDefined( player ) && IsPlayer( player ) );
	Assert( IsDefined( shader ) );
	
	thickness = ter_op( IsDefined( thickness ), thickness, 1 );
	thickness = ter_op( thickness > 1, thickness, 1 );
	width = ter_op( IsDefined( width ), width, 2 * thickness );
	width = ter_op( width > 2 * thickness, width, 2 * thickness );
	height = ter_op( IsDefined( height ), height, 2 * thickness );
	height = ter_op( height > 2 * thickness, height, 2 * thickness );
	x = ter_op( IsDefined( x ), x, 0 );
	y = ter_op( IsDefined( y ), y, 0 );
	
	struct = SpawnStruct();

	hud = NewClientHudElem( player );
	hud.x = x;
	hud.y = y;
	hud.alignX = "left";
	hud.alignY = "top";
	hud.horzAlign = "fullscreen";
	hud.horzAlign = "fullscreen";
	hud SetShader( shader, width, thickness );
	hud.alpha = 0.0;

	struct.top = hud;
	
	hud = NewClientHudElem( player );
	hud.x = x;
	hud.y = y + thickness;
	hud.alignX = "left";
	hud.alignY = "top";
	hud.horzAlign = "fullscreen";
	hud.horzAlign = "fullscreen";
	hud SetShader( shader, thickness, height - ( 2 * thickness ) );
	hud.alpha = 0.0;

	struct.left = hud;	
	
	hud = NewClientHudElem( player );
	hud.x = x;
	hud.y = y + height - thickness;
	hud.alignX = "left";
	hud.alignY = "top";
	hud.horzAlign = "fullscreen";
	hud.horzAlign = "fullscreen";
	hud SetShader( shader, width, thickness );
	hud.alpha = 0.0;

	struct.bottom = hud;
	
	hud = NewClientHudElem( player );
	hud.x = x + width - thickness;
	hud.y = y + thickness;
	hud.alignX = "left";
	hud.alignY = "top";
	hud.horzAlign = "fullscreen";
	hud.horzAlign = "fullscreen";
	hud SetShader( shader, thickness, height - ( 2 * thickness ) );
	hud.alpha = 0.0;

	struct.right = hud;
	
	return struct;	
}

hud_update_player_data()
{
	thread hud_update_player_pitch();
	thread hud_update_player_yaw();
}

hud_update_player_pitch()
{
	level endon( "LISTEN_end_ac130" );
	level endon( "LISTEN_end_ac130_hud_misc_data" );

	for ( ; ; )
	{
		level.HUDItem[ "player_pitch" ] SetValue( round_to( abs( level.ac130player GetPlayerAngles()[ 0 ] + 0.2187298 ), 1000 ) );
		wait 0.05;
	}
}

hud_update_player_yaw()
{
	level endon( "LISTEN_end_ac130" );
	level endon( "LISTEN_end_ac130_hud_misc_data" );
	
	for ( ; ; )
	{
		level.HUDItem[ "player_yaw" ] SetValue( round_to( abs( level.ac130player GetPlayerAngles()[ 1 ] + 0.2187298 ), 1000 ) );
		wait 0.05;
	}
}

hud_update_ac130_data()
{
	thread hud_update_ac130_pitch();
	thread hud_update_ac130_yaw();
	thread hud_update_ac130_roll();
	thread hud_update_ac130_position_x();
	thread hud_update_ac130_position_y();
	thread hud_update_ac130_position_z();
}

hud_update_ac130_pitch()
{
	level endon( "LISTEN_end_ac130" );
	level endon( "LISTEN_end_ac130_hud_misc_data" );
	
	for ( ; ; )
	{
		level.HUDItem[ "ac130_pitch" ] SetValue( round_to( abs( ( level.ac130.angles[ 0 ] + level.ac130.angles[ 1 ] + 0.2187298 ) * 0.5 ), 1000 ) );
		wait 0.05;
	}
}

hud_update_ac130_yaw()
{
	level endon( "LISTEN_end_ac130" );
	level endon( "LISTEN_end_ac130_hud_misc_data" );
	
	for ( ; ; )
	{
		level.HUDItem[ "ac130_yaw" ] SetValue( round_to( abs( level.ac130.angles[ 1 ] + 0.2187298 ), 1000 ) );
		wait 0.05;
	}
}

hud_update_ac130_roll()
{
	level endon( "LISTEN_end_ac130" );
	level endon( "LISTEN_end_ac130_hud_misc_data" );
	
	for ( ; ; )
	{
		value = round_to( abs( level.ac130.angles[ 2 ] + ( ( level.ac130.angles[ 0 ] + level.ac130.angles[ 1 ] ) / ( level.ac130.angles[ 0 ] - level.ac130.angles[ 1 ] + 0.0005 ) ) + 0.2187298 ) * 10, 1000 );
		level.HUDItem[ "ac130_roll" ] SetValue( value );
		wait 0.05;
	}
}

hud_update_ac130_position_x()
{
	level endon( "LISTEN_end_ac130" );
	level endon( "LISTEN_end_ac130_hud_misc_data" );
	
	for ( ; ; )
	{
		level.HUDItem[ "ac130_position_x" ] SetValue( round_to( abs( level.ac130.origin[ 0 ] + 0.2187298 ), 1000 ) );
		wait 0.05;
	}
}

hud_update_ac130_position_y()
{
	level endon( "LISTEN_end_ac130" );
	level endon( "LISTEN_end_ac130_hud_misc_data" );
	
	for ( ; ; )
	{
		level.HUDItem[ "ac130_position_y" ] SetValue( round_to( abs( level.ac130.origin[ 1 ] + 0.2187298 ), 1000 ) );
		wait 0.05;
	}
}

hud_update_ac130_position_z()
{
	level endon( "LISTEN_end_ac130" );
	level endon( "LISTEN_end_ac130_hud_misc_data" );
	
	for ( ; ; )
	{
		value = round_to( abs( level.ac130.origin[ 2 ] + ( ( level.ac130.origin[ 0 ] + level.ac130.origin[ 1 ] ) / ( level.ac130.origin[ 0 ] - level.ac130.origin[ 1 ] + 0.0005 ) ) + 0.2187298 ) / 100, 1000 );
		level.HUDItem[ "ac130_position_z" ] SetValue( value );
		wait 0.05;
	}
}

hud_update_tv_bar_1( delay )
{
	level endon( "LISTEN_end_ac130" );
	
	delay = ter_op ( IsDefined( delay ), delay, 0.05 );
	delay = ter_op( delay > 0.5, delay, 0.05 );
	wait delay;
	
	min_y = level.HUDItem[ "bar_1" ].y;
	y = min_y;
	max_y = 512;
	delta_y = 5.0;
	
	for ( ; ; )
	{
		y += delta_y;
		if ( y > max_y )
			y = min_y;
		level.HUDItem[ "bar_1" ] MoveOverTime( 0.05 );
		level.HUDItem[ "bar_1" ].y = y;
		wait 0.05;
	}
}

hud_udpate_tv_bar_2( delay )
{
	level endon( "LISTEN_end_ac130" );
	
	delay = ter_op ( IsDefined( delay ), delay, 0.05 );
	delay = ter_op( delay > 0.5, delay, 0.05 );
	wait delay;
	
	min_y = level.HUDItem[ "bar_2" ].y;
	y = min_y;
	max_y = 512;
	delta_y = 5.0;
	
	for ( ; ; )
	{
		y += delta_y;
		if ( y > max_y )
			y = min_y;
		level.HUDItem[ "bar_2" ] MoveOverTime( 0.05 );
		level.HUDItem[ "bar_2" ].y = y;
		wait 0.05;
	}
}

hud_blink_current_weapon_name( current_weapon )
{
	level notify( "LISTEN_end_hud_blink_current_weapon_name" );
	level endon( "LISTEN_end_hud_blink_current_weapon_name" );
	level endon( "LISTEN_end_ac130" );

	if ( !IsDefined( level.HUDItem[ "weapon_text" ] ) )
		return;

	foreach ( item in level.HUDItem[ "weapon_text" ] )
		item.alpha = 0.2;
	level.HUDItem[ "weapon_text" ][ current_weapon ].alpha = 1;
	
	for ( ;; )
	{
		if ( flag( "FLAG_ac130_vision_transition" ) )
		{
			wait 0.05;
			continue;
		}
		
		level.HUDItem[ "weapon_text" ][ current_weapon ] FadeOverTime( 0.2 );
		level.HUDItem[ "weapon_text" ][ current_weapon ].alpha = 0;
		wait 0.2;

		if ( flag( "FLAG_ac130_vision_transition" ) || 
			 !flag( "FLAG_ac130_hud_on" ) )
		{
			wait 0.05;
			continue;
		}
		
		level.HUDItem[ "weapon_text" ][ current_weapon ] FadeOverTime( 0.2 );
		level.HUDItem[ "weapon_text" ][ current_weapon ].alpha = 1;
		wait 0.2;
	}
}

hud_blink_crosshairs( weapon )
{
	level endon( "LISTEN_end_ac130" );
	level endon( "LISTEN_end_hud_blink_crosshairs_" + weapon );

	if ( !IsDefined( weapon ) )
		return;
	
	current_weapon = 0;
	
	if ( IsSubStr( weapon, "40" ) )
		current_weapon = 1;
	if ( IsSubStr( weapon, "25" ) )
		current_weapon = 2;	
	level.HUDItem[ "crosshairs" ][ current_weapon ].alpha = 1;

	for ( ; ; )
	{
		if ( flag( "FLAG_ac130_vision_transition" ) || 
			 !flag( "FLAG_ac130_hud_on" ) || 
			 weapon != level.current_weapon )
		{
			level.HUDItem[ "crosshairs" ][ current_weapon ].alpha = 0;
			wait 0.05;
			continue;
		}
		
		if ( weapon == level.current_weapon &&
			 !level.weapon_cooldown_active[ weapon ] )
		{
			level.HUDItem[ "crosshairs" ][ current_weapon ].alpha = 1;
			wait 0.05;
			continue;
		}
			
		level.HUDItem[ "crosshairs" ][ current_weapon ] FadeOverTime( 0.3 );
		level.HUDItem[ "crosshairs" ][ current_weapon ].alpha = 0;
		wait 0.3;
		
		if ( flag( "FLAG_ac130_vision_transition" ) || 
			 !flag( "FLAG_ac130_hud_on" ) || 
			 weapon != level.current_weapon )
		{
			level.HUDItem[ "crosshairs" ][ current_weapon ].alpha = 0;
			wait 0.05;
			continue;
		}
		
		if ( weapon == level.current_weapon &&
			 !level.weapon_cooldown_active[ weapon ] )
		{
			level.HUDItem[ "crosshairs" ][ current_weapon ].alpha = 1;
			wait 0.05;
			continue;
		}
		
		level.HUDItem[ "crosshairs" ][ current_weapon ] FadeOverTime( 0.3 );
		level.HUDItem[ "crosshairs" ][ current_weapon ].alpha = 1;
		wait 0.3;
	}
}

hud_blink_reloading()
{
	level endon( "LISTEN_end_ac130" );
	
	for ( ;; )
	{
		if ( flag( "FLAG_ac130_vision_transition" ) )
		{
			wait 0.05;
			continue;
		}
		
		level.HUDItem[ "reloading" ] FadeOverTime( 0.2 );
		level.HUDItem[ "reloading" ].alpha = 0;
		wait 0.2;

		if ( flag( "FLAG_ac130_vision_transition" ) || 
			 !flag( "FLAG_ac130_hud_on" ) || 
			 !level.weapon_cooldown_active[ level.current_weapon ] )
		{
			wait 0.05;
			continue;
		}
		
		level.HUDItem[ "reloading" ] FadeOverTime( 0.2 );
		level.HUDItem[ "reloading" ].alpha = 1;
		wait 0.2;
	}
}

hud_blur()
{
	level endon( "LISTEN_end_ac130" );
	
	fov_105 = int( level.ac130_weapon[ 0 ].fov );
	fov_25 = int( level.ac130_weapon[ 2 ].fov );
	
	min_fov = fov_25;
	max_fov = fov_105;
	
	for ( ; ; )
	{
		fov = ter_op( GetDvarFloat( "cg_fov" ) > max_fov, max_fov, GetDvarFloat( "cg_fov" ) );
		delta = ( fov - min_fov ) / ( max_fov - min_fov );
		blur = ter_op( flag( "FLAG_ac130_thermal_enabled" ), level.ac130_thermal_blur, level.ac130_enhanced_blur );
		level.ac130player SetBlurForPlayer( blur * delta, 0 );
		wait 0.05;
	}
}

hud_lock_on_flash_start( interval, timeout )
{
	level endon( "LISTEN_end_ac130" );
	
	interval = ter_op( IsDefined( interval ), interval, 0.05 );
	interval = ter_op( interval > 0.05, interval, 0.05 );
	timeout = ter_op( IsDefined( timeout ), timeout, 100000 );
	timeout = ter_op( timeout > 0.05, timeout, 0.05 );
	timeout = ter_op( timeout > 2 * interval, timeout, 2 * interval );
	
	flag_set( "FLAG_ac130_lock_on" );
	
	elapsed = 0.0;
	
	while ( flag( "FLAG_ac130_lock_on" ) && elapsed < timeout )
	{
		if ( flag( "FLAG_ac130_vision_transition" ) || 
			 !flag( "FLAG_ac130_hud_on" ) )
		{
			wait 0.05;
			continue;
		}
		
		level.HUDItem[ "lock_on" ].alpha = 1.0;
		wait interval;
		level.HUDItem[ "lock_on" ].alpha = 0.0;
		wait interval;
		elapsed += 2 * interval;
	}
}

hud_lock_on_flash_stop()
{
	flag_clear( "FLAG_ac130_lock_on" );
}

hud_recording_start()
{
	level endon( "LISTEN_end_ac130" );
	
	flag_set( "FLAG_ac130_recording" );
	
	interval = 0.2;
	
	while ( flag( "FLAG_ac130_recording" ) )
	{
		if ( flag( "FLAG_ac130_vision_transition" ) ||
			 !flag( "FLAG_ac130_hud_on" ) )
		{
			wait 0.05;
			continue;
		}
		
		level.HUDItem[ "recording" ].alpha = 0.5;
		wait interval;
		level.HUDItem[ "recording" ].alpha = 0.0;
		wait interval;
	}
}

hud_weapon_fire()
{
	level endon( "LISTEN_end_ac130" );
	
	thread hud_weapon_fire_chamber( level.weapon_name[ "105" ] );
	thread hud_weapon_fire_chamber( level.weapon_name[ "40" ] ); 
	thread hud_weapon_fire_chamber( level.weapon_name[ "25" ] );
	
	for ( ; ; )
	{
		level.HUDItem[ "ammo" ][ "rounds" ] SetValue( level.weapon_ammo_count[ level.current_weapon ] );
		level.HUDItem[ "ammo" ][ "chamber" ] SetValue( level.weapon_chamber_count[ level.current_weapon ] );
		wait 0.05;
	}
}

hud_weapon_fire_chamber( current_weapon )
{
	Assert( IsDefined( current_weapon ) );
	
	level endon( "LISTEN_end_ac130" );
	
	current_ammo = level.weapon_ammo_count[ current_weapon ];
	
	for ( ; ; )
	{
		if ( current_ammo != level.weapon_ammo_count[ current_weapon ] && 
			 level.weapon_ammo_count[ current_weapon ] == level.weapon_ammo_max[ current_weapon ] )
		{
			current_ammo = level.weapon_ammo_count[ current_weapon ];
			level.weapon_chamber_count[ current_weapon ]++;
			if ( level.weapon_chamber_count[ current_weapon ] > level.weapon_chamber_max[ current_weapon ] )
				level.weapon_chamber_count[ current_weapon ] = 1;
		}
		
		if ( level.weapon_ammo_count[ current_weapon ] > 0 )
			current_ammo = level.weapon_ammo_count[ current_weapon ];
		wait 0.05;
	}
}

hud_add_targets( targets, delay )
{
	if( !IsDefined( targets ) || !IsArray( targets ) )
		return;
	
	delay = ter_op( IsDefined( delay ), delay, 0.05 );
	delay = ter_op( delay > 0.05, delay, 0.05 );
	
	shader = "ac130_hud_friendly_ai_target";
	offscreen_shader = undefined;
	offscreen_shader_blink = undefined;
    offset = ( 0, 0, 0 );
    active_mode = "both";
    active = false;
    draw_corners = false;
    draw_single = false;
    min_size = -1;
	max_size = -1;
    scaled_target = true;
    draw_square = false;
    color = undefined;
    radius = -1;
    
	foreach ( target in targets )
	{
		if ( !IsDefined( target ) || IsDefined( target.shader ) || Target_IsTarget( target ) ||
			 Target_GetArray().size >= 64 )
			continue;
	
		if ( IsDefined( target.classname ) )
		{
			if ( IsAI( target ) )
			{
				if ( IsDefined( target.team ) && target.team == "allies" )
				{
					//shader = "ac130_hud_friendly_ai_target";
					//shader = "ac130_hud_friendly_ai_target_s_w";
					shader = "ac130_hud_friendly_ai_diamond_s_w";
					//offscreen_shader = "ac130_hud_friendly_ai_offscreen_w";
					//offscreen_shader_blink = "ac130_hud_friendly_ai_flash";
					active = true;
					//draw_corners = true;
					offset = ( 0, 0, 32 );
					draw_single = true;
					draw_square = true;
					radius = 60;
					color = ( 0.3, 0.3, 0.3 );
				}
				else
				{
					//shader = "ac130_hud_enemy_ai_target_w";
					//shader = "ac130_hud_enemy_ai_target_r";
					//shader = "ac130_hud_enemy_ai_target_s_r";
					shader = "ac130_hud_enemy_ai_target_s_w";
					color = ( 0.5, 0.15, 0.15 );
					active_mode = "enhanced";
					offset = ( 0, 0, 32 );
					//draw_single = true;
					draw_square = true;
					radius = 60;
				}
			}
			else
			if ( IsSubStr( target.classname, "vehicle" ) )
			{
				if  ( IsDefined( target.script_team ) && target.script_team == "allies" )
				{
					//shader = "ac130_hud_friendly_vehicle_target";
					//shader = "ac130_hud_friendly_vehicle_target_s_w";
					shader = "ac130_hud_friendly_vehicle_diamond_s_w";
					//offscreen_shader = "ac130_hud_friendly_ai_offscreen";
					//offscreen_shader_blink = "ac130_hud_friendly_ai_flash";
					active = true;
					//draw_corners = true;
					draw_single = true;
					draw_square = true;
					color = ( 0.3, 0.3, 0.3 );
					
					if ( IsSubStr( target.classname, "blackhawk" ) )
					{
						if ( IsSubStr( target.classname, "so" ) )
   	 						shader = "ac130_hud_player_vehicle_diamond_s_w";
						offset = ( 0, 0, -72 );
						radius = 150;
					}
					else
					if ( IsSubStr( target.classname, "m1a1" ) )
					{
   	 					radius = 200;
   	 				}
					else
					if ( IsSubStr( target.classname, "hummer" ) )
					{
						radius = 150;
					}
   	 				else
   	 				if ( IsSubStr( target.classname, "ch46e" ) )
   	 				{
   	 					if ( IsSubStr( target.classname, "so" ) )
   	 						shader = "ac130_hud_player_vehicle_diamond_s_w";
   	 					radius = 150;
   	 				}
   	 				else
   	 				if ( IsSubStr( target.classname, "c130" ) )
   	 				{
   	 					radius = 200;
   	 				}
				}
				else
				{
					//shader = "ac130_hud_enemy_vehicle_target_w";
					//shader = "ac130_hud_enemy_vehicle_target_r";
					//shader = "ac130_hud_enemy_vehicle_target_s_r";
					shader = "ac130_hud_enemy_vehicle_target_s_w";
					active_mode = "enhanced";
					draw_square = true;
					//draw_single = true;
					draw_corners = true;
					color = ( 0.5, 0.15, 0.15 );
					
					if ( IsSubStr( target.classname, "mi17" ) )
					{
						offset = ( 0, 0, -72 );
						radius = 150;
					}
					else
					if ( IsSubStr( target.classname, "t72" ) )
					{
						radius = 150;
					}
					else
					if ( IsSubStr( target.classname, "btr" ) )
					{
						radius = 150;
					}
					else
   	 				if ( IsSubStr( target.classname, "hind" ) )
   	 				{
   	 					offset = ( 0, 0, -72 );
						radius = 150;
   	 				}
				}
			}
			else
			if ( target.classname == "script_model" )
			{
				if ( IsDefined( target.team ) && target.team == "allies" )
				{
					//shader = "ac130_hud_friendly_vehicle_target";
					//shader = "ac130_hud_friendly_vehicle_target_s_w";
					shader = "ac130_hud_friendly_vehicle_diamond_s_w";
					//offscreen_shader = "ac130_hud_friendly_ai_offscreen";
					//offscreen_shader_blink = "ac130_hud_friendly_ai_flash";
					active = true;
					draw_single = true;
					draw_square = true;
					//draw_corners = true;
					color = ( 0.3, 0.3, 0.3 );
					radius = 150;
				}
				else
				{
					//shader = "ac130_hud_enemy_ai_target_w";
					//shader = "ac130_hud_enemy_ai_target_r";
					//shader = "ac130_hud_enemy_ai_target_s_r";
					shader = "ac130_hud_enemy_ai_target_s_w";
					color = ( 0.5, 0.15, 0.15 );
					active_mode = "enhanced";
					offset = ( 0, 0, 32 );
					//draw_single = true;
					draw_square = true;
					radius = 60;
					
					if ( IsDefined( target.model ) )
					{
						shader = "ac130_hud_enemy_vehicle_target_s_w";
						active_mode = "enhanced";
						draw_square = true;
						draw_corners = true;
						color = ( 0.5, 0.15, 0.15 );
						
						if ( IsSubStr( target.model, "t72" ) )
						{
							radius = 150;
						}
					}
				}
			}
		}
		else
		{
			// default
			
			shader = "ac130_hud_friendly_ai_target";
   			offset = ( 0, 0, 32 );
		}
	
		target.hud_target_active_mode = active_mode;
		target.hud_target_active = active;
		target.hud_target_offscreen_shader = offscreen_shader;
		target.hud_target_offscreen_shader_blink = offscreen_shader_blink;
		
		if ( scaled_target )
		{
			Target_Alloc( target, offset );
		    Target_SetShader( target, shader );
		    Target_SetScaledRenderMode( target, true );
		    
		    if ( draw_single )
		    	Target_DrawSingle( target );
		    if ( draw_square )
		    	Target_DrawSquare( target, radius );
		    if ( draw_corners )
		    	Target_DrawCornersOnly( target, true );
		    if ( IsDefined( color ) )
		    	Target_SetColor( target, color );
		    
		    Target_SetMaxSize( target, max_size );
		    Target_SetMinSize( target, min_size, false );
		    //Target_SetDelay( target, 0.5 );
			Target_Flush( target );
		}
		else
		{
			Target_Set( target, offset );
		    Target_SetShader( target, shader );
		}
		
		if ( active )
		{
			foreach ( player in level.players )
				if ( player == level.ac130player )
					Target_ShowToPlayer( target, level.ac130player );
				else
					Target_HideFromPlayer( target, player );
		}
		else
			foreach ( player in level.players )
				Target_HideFromPlayer( target, player );
			
		if ( IsDefined( offscreen_shader ) && IsDefined( offscreen_shader_blink ) )
			thread hud_target_offscreen_blink( target );
		wait 0.05;
		thread hud_monitor_target( target );
		wait delay;
	}
}

hud_target_offscreen_blink( target )
{
	Assert( IsDefined( target ) );
	
	level endon( "LISTEN_end_ac130" );

	while ( IsDefined( target ) && Target_IsTarget( target ) )
	{
		if ( IsDefined( target.hud_target_offscreen_shader ) )
			Target_SetOffScreenShader( target, target.hud_target_offscreen_shader );
		wait 0.2;
		if ( IsDefined( target ) && Target_IsTarget( target ) && IsDefined( target.hud_target_offscreen_shader_blink ) )
			Target_SetOffScreenShader( target, target.hud_target_offscreen_shader_blink );
		wait 0.5;
	}
}

hud_monitor_target( target )
{
	level endon( "LISTEN_end_ac130" );
	
	while ( IsDefined( target ) && Target_IsTarget( target ) )
	{
		if ( target.classname != "script_model" && !IsAlive( target ) )
			break;
			
		show_to_player = false;
		hide_from_player = false;
		
		switch( target.hud_target_active_mode )
		{
			case "thermal":
				if ( flag( "FLAG_ac130_vision_transition" ) && target.hud_target_active )
					hide_from_player = true;
				else
				if ( flag( "FLAG_ac130_thermal_enabled" ) && !target.hud_target_active )
					show_to_player = true;
				else
				if ( !flag( "FLAG_ac130_thermal_enabled" ) && target.hud_target_active )
					hide_from_player = true;
				break;
			case "enhanced":
				if ( flag( "FLAG_ac130_vision_transition" ) && target.hud_target_active )
					hide_from_player = true;
				else
				if ( flag( "FLAG_ac130_enhanced_vision_enabled" ) && !target.hud_target_active )
					show_to_player = true;
				else
				if ( !flag( "FLAG_ac130_enhanced_vision_enabled" ) && target.hud_target_active )
					hide_from_player = true;
				break;
			case "both":
				if ( flag( "FLAG_ac130_vision_transition" ) && target.hud_target_active )
					hide_from_player = true;
				else
				if ( !flag( "FLAG_ac130_vision_transition" ) && !target.hud_target_active )
					show_to_player = true;
		}
		
		if ( show_to_player )
		{
			in_queue = false;
			
			foreach ( item in level.ac130_hud_target_show_queue )
			{
				if ( IsDefined( item ) && item == target )
				{
					in_queue = true;
					break;
				}
			}
			
			if ( !in_queue )
				level.ac130_hud_target_show_queue[ level.ac130_hud_target_show_queue.size ] = target;
		}
		
		if ( hide_from_player )
		{
			in_queue = false;
			
			foreach ( item in level.ac130_hud_target_hide_queue )
			{
				if ( IsDefined( item ) && item == target )
				{
					in_queue = true;
					break;
				}
			}
			
			if ( !in_queue )
				level.ac130_hud_target_hide_queue[ level.ac130_hud_target_hide_queue.size ] = target;
		}
		wait 0.05;
	}
		
	if ( IsDefined( target ) && Target_IsTarget( target ) )
		Target_Remove( target );
}

hud_target_toggle_visibility_queue()
{
	level endon( "LISTEN_end_ac130" );
	
	max_count = 24;
	count = max_count;
	
	for ( ; ; )
	{
		// Hide
		
		level.ac130_hud_target_hide_queue = array_removeundefined( level.ac130_hud_target_hide_queue );
		
		foreach ( i, target in level.ac130_hud_target_hide_queue )
		{
			if ( count == 0 )
			{
				count = max_count;
				wait 0.05;
			}
			
			if ( IsDefined( target ) && Target_IsTarget( target ) )
			{
				Target_HideFromPlayer( target, level.ac130player );
				target.hud_target_active = false;
				count--;
				level.ac130_hud_target_hide_queue[ i ] = undefined;
			}
		}
		
		// Show
		
		level.ac130_hud_target_show_queue = array_removeundefined( level.ac130_hud_target_show_queue );
		
		foreach ( i, target in level.ac130_hud_target_show_queue )
		{
			if ( count == 0 )
			{
				count = max_count;
				wait 0.05;
			}
			
			if ( IsDefined( target ) && Target_IsTarget( target ) )
			{
				Target_ShowToPlayer( target, level.ac130player );
				target.hud_target_active = true;
				count--;
				level.ac130_hud_target_show_queue[ i ] = undefined;
			}
		}
		
		count = ter_op( count == 0, max_count, count );
		wait 0.05;
	}
}

hud_add_friendly_targets()
{
	ais = GetAIArray( "allies" );
	hud_add_targets( ais );
}

hud_remove_targets( targets, delay )
{
	Assert( IsDefined( targets ) && IsArray( targets ) );
	
	delay = ter_op( IsDefined( delay ), delay, 0 );
	delay = ter_op( delay > 0, delay, 0 );
	targets = array_removeundefined( targets );
	
	foreach ( target in targets )
	{
		if ( IsDefined( target ) )
		{
			_targets = Target_GetArray();
			
			foreach( _target in _targets )
			{
				if ( target == _target )
				{
					Target_Remove( _target );
					if ( delay > 0 )
						wait delay;
				}
			}
		}
	}
}

hud_remove_all_targets()
{
	targets = Target_GetArray();

	foreach ( target in targets )
		Target_Remove( target );
}

hud_set_static( value )
{
	value = ter_op( IsDefined( value ), value, 0 );
	value = ter_op( value < 0, 0, value );
	
	level.HUDItem[ "static" ].alpha = value;
}

hud_set_grain( value )
{
	value = ter_op( IsDefined( value ), value, 0 );
	value = ter_op( value < 0, 0, value );
	
	level.HUDItem[ "grain" ].alpha = value;
}

hud_set_alpha( hud_item, value )
{
	Assert( IsDefined( hud_item ) );
	
	value = ter_op( IsDefined( value ), value, 0 );
	value = ter_op( value < 0, 0, value );
	
	hud_item.alpha = value;
}

hud_toggle_static_over_time( mid_value, time )
{
	mid_value = ter_op( IsDefined( mid_value ), mid_value, 0 );
	mid_value = ter_op( mid_value < 0, 0, mid_value );
	
	half_time = time * 0.5;
	start_value= level.HUDItem[ "static" ].alpha;
	
	level.HUDItem[ "static" ] FadeOverTime( half_time );
	level.HUDItem[ "static" ].alpha = mid_value;
	wait half_time;
	level.HUDItem[ "static" ] FadeOverTime( half_time );
	level.HUDItem[ "static" ].alpha = start_value;
	wait half_time;
}

hud_zoom()
{
	level endon( "LISTEN_end_ac130" );
	level endon( "LISTEN_end_hud_zoom" );
	
	fov_adjust_rate = 50; 	// Assuming change of 50 fov / 1 sec
	fov_max = 55;
	fov_min = 7; 
	fov_current = fov_max;
	
	for ( ; ; )
	{
		fov_current -= level.ac130player GetNormalizedMovement()[ 0 ] * fov_adjust_rate * 0.05;
		fov_current = Clamp( fov_current, fov_min, fov_max );
		
		zoom = 1 + ( ( fov_max - fov_current ) / ( fov_max - fov_min ) ) * 4;
		 
		level.HUDItem[ "zoom" ][ "ones" ] SetValue( return_place( zoom, 1 ) );
		level.HUDItem[ "zoom" ][ "tenths" ] SetValue( return_place( zoom, 0.1 ) );
		level.HUDItem[ "zoom" ][ "hundredths" ] SetValue( return_place( zoom, 0.01 ) );
		wait 0.05;
	}
}

round_to( val, mult )
{
	return ( int( val * mult ) / mult );
}

return_place( val, place )
{
	Assert( IsDefined( val ) );
	val = abs( val );
	place = ter_op( place < 0, 0, place );
	
	if ( place <= 0 )
		return val;
	if ( place >= 1 )
	{
		_val = Int( val );
		val_highest_dec_place = 1;
		ten_exp = 1;
		while ( _val - ten_exp > 0 )
		{
			val_highest_dec_place++;
			ten_exp *= 10;
		}
		
		power = val_highest_dec_place - 1;
		
		if ( place > ten_to_int_power( power ) )
			return 0;
		while ( power != place && power > 0 )
		{
			ten_to_power = ten_to_int_power( power );
			while ( _val - ten_to_power >= 0 )
				_val -= ten_to_power;
			power--;
		}
		return Int( _val );
	}
	else
	{
		_val = val - Int( val );
		place = 1 / place;
		_val *= place;
		
		val_highest_dec_place = 0;
		ten_exp = 1;
		while ( _val - ten_exp > 0 )
		{
			val_highest_dec_place++;
			ten_exp *= 10;
		}
		
		power = val_highest_dec_place - 1;
		while ( power > 0 )
		{
			ten_to_power = ten_to_int_power( power );
			while ( _val - ten_to_power >= 0 )
				_val -= ten_to_power;
			power--;
		}
		return Int( _val );
	}
}

ten_to_int_power( power )
{
	result = 1;
	if ( power >= 1 )
		for( i = 0; i < power; i++ )
			result *= 10;
	else
	if ( power < 0 )
		for ( i = 1; i < abs( power ); i++ )
			result /= 10;
	return result;
}

monitor_change_weapons()
{
	level endon( "LISTEN_end_ac130" );
	level endon( "LISTEN_end_monitor_change_weapons" );
	
	NotifyOnCommand( "LISTEN_ac130_change_weapons", "weapnext" );
	
	for ( ; ; )
	{
		flag_clear( "FLAG_ac130_changed_weapons" );
		level.ac130player waittill( "LISTEN_ac130_change_weapons" );
		flag_set( "FLAG_ac130_changed_weapons" );
		wait 0.1;
	}
}

monitor_25mm_sound()
{
	level endon( "LISTEN_end_ac130" );
	
	button_pressed = false;
	
	flag_wait( "FLAG_ac130_clear_to_engage" );
	
	weapon_cooldown_active = level.weapon_cooldown_active[ level.weapon_name[ "25" ] ];
	
	for( ; ; )
	{
		if ( IsSubStr( level.current_weapon, "25" ) )
		{
			if ( weapon_cooldown_active != level.weapon_cooldown_active[ level.weapon_name[ "25" ] ] )
			{
				level.ac130player stop_loop_sound_on_entity( "ac130_25mm_fire_loop" );
				weapon_cooldown_active = level.weapon_cooldown_active[ level.weapon_name[ "25" ] ];
			}
				
			if ( level.weapon_cooldown_active[ level.weapon_name[ "25" ] ] )
			{
				if ( button_pressed )
					level.ac130player thread play_sound_on_entity( "ac130_25mm_fire_loop_cooldown" );
				button_pressed = false;
			}
			else
			if ( level.ac130player AttackButtonPressed() )
			{
				if ( !button_pressed )
					level.ac130player thread play_loop_sound_on_entity( "ac130_25mm_fire_loop" );
				button_pressed = true;
			}
			else
			{
				if ( button_pressed )
				{
					level.weapon_input_cooldown_active[ level.weapon_name[ "25" ] ] = true;
					
					level.ac130player stop_loop_sound_on_entity( "ac130_25mm_fire_loop" );
					level.ac130player thread play_sound_on_entity( "ac130_25mm_fire_loop_cooldown" );
					
					wait level.weapon_input_cooldown_time[ level.weapon_name[ "25" ] ];
					level.ac130player SetWeaponAmmoClip( level.weapon_name[ "25" ], 1 );
					level.weapon_input_cooldown_active[ level.weapon_name[ "25" ] ] = false;
				}
				button_pressed = false;
			}
			wait 0.05;
		}
		else
		if ( button_pressed )
		{	
			level.ac130player stop_loop_sound_on_entity( "ac130_25mm_fire_loop" );
			button_pressed = false;
		}
		wait 0.05;
	}
	level.ac130player stop_loop_sound_on_entity( "ac130_25mm_fire_loop" );
}

monitor_change_vision()
{
	level endon( "LISTEN_end_ac130" );
	level endon( "LISTEN_end_monitor_change_vision" );
	
	NotifyOnCommand( "LISTEN_ac130_change_vision", "+activate" );
	NotifyOnCommand( "LISTEN_ac130_change_vision", "+usereload" );
	
	for ( ; ; )
	{
		flag_clear( "FLAG_ac130_changed_vision" );
		level.ac130player waittill( "LISTEN_ac130_change_vision" );
		flag_set( "FLAG_ac130_changed_vision" );
		wait 0.1;
	}
}

monitor_zoom()
{
	level endon( "LEVEL_end_ac130" );
	level endon( "LEVEL_end_monitor_zoom" );
	
	for ( ; ; )
	{
		flag_clear( "FLAG_ac130_using_zoom" );
		if ( ( level.ac130player GetNormalizedMovement() )[ 0 ] != 0 )
			flag_set( "FLAG_ac130_using_zoom" );
		wait 0.1;
	}
}

hint_change_weapons()
{
	return flag( "FLAG_ac130_changed_weapons" );
}

hint_enhanced_vision()
{
	return flag( "FLAG_ac130_changed_vision" );
}

hint_thermal_vision()
{
	return flag( "FLAG_ac130_changed_vision" );
}

hint_zoom()
{
	return flag( "FLAG_ac130_using_zoom" );
}

ac130_set_view_arc( time, accel_time, decel_time, right, left, top, bottom )
{
	if ( !level.ac130player IsLinked() || !flag( "FLAG_ac130_player_in_ac130" ) )
		return;
		
	time = ter_op( IsDefined( time ), time, 0 );
	time = ter_op( time > 0, time, 0 );
	accel_time = ter_op( IsDefined( accel_time ), accel_time, 0 );
	accel_time = ter_op( accel_time > 0, accel_time, 0 );
	decel_time = ter_op( IsDefined( decel_time ), decel_time, 0 );
	decel_time = ter_op( decel_time > 0, decel_time, 0 );
	
	right = ter_op( IsDefined( right ), right, 65 );
	right = ter_op( right < 180, right, 180 );
	right = ter_op( right > 0, right, 0 );
	
	level.ac130_current_right_arc = right;
	
	left = ter_op( IsDefined( left ), left, 65 );
	left = ter_op( left < 180, left, 180 );
	left = ter_op( left > 0, left, 0 );
	
	level.ac130_current_left_arc = left;
	
	top = ter_op( IsDefined( top ), top, 45 );
	top = ter_op( top < 180, top, 180 );
	top = ter_op( top > 0, top, 0 );
	
	level.ac130_current_top_arc = top;
	
	bottom = ter_op( IsDefined( bottom ), bottom, 65 );
	bottom = ter_op( bottom < 180, bottom, 180 );
	bottom = ter_op( bottom > 0, bottom, 0 );
	
	level.ac130_current_bottom_arc = bottom;
	
	level.ac130player LerpViewAngleClamp( time, accel_time, decel_time, right, left, top, bottom );
}

ac130_reset_view_arc()
{
	level.ac130_current_right_arc = level.ac130_default_right_arc;
	level.ac130_current_left_arc = level.ac130_default_left_arc;
	level.ac130_current_top_arc = level.ac130_default_top_arc;
	level.ac130_current_bottom_arc = level.ac130_default_bottom_arc;
}

ac130_set_thermal_shock( shock )
{
	Assert( IsDefined( shock ) && IsString( shock ) );
	level.ac130_thermal_shock = shock;
}

ac130_set_enhanced_shock( shock )
{
	Assert( IsDefined( shock ) && IsString( shock ) );
	level.ac130_enhanced_shock = shock;
}

ac130_set_thermal_vision_set( vision )
{
	Assert( IsDefined( vision ) && IsString( vision ) );
	level.ac130_thermal_vision_set = vision;
}

ac130_set_enhanced_vision_set( vision )
{
	Assert( IsDefined( vision ) && IsString( vision ) );
	level.ac130_enhanced_vision_set = vision;
}

ac130_set_default_vision_set( vision )
{
	Assert( IsDefined( vision ) && IsString( vision ) );
	level.ac130_default_vision_set = vision;
}

ac130_set_thermal_fog( duration, 
					   color, 
					   fog_start, 
					   halfway_dist, 
					   fog_max_opacity, 
					   sun_color, 
					   sun_dir, 
					   sun_begin_fade_angle, 
					   sun_end_fade_angle, 
					   sun_fog_scale )
{
	Assert( IsDefined( duration ) );
	Assert( IsDefined( color ) );
	Assert( IsDefined( fog_start ) );
	Assert( IsDefined( halfway_dist ) );
	Assert( IsDefined( fog_max_opacity ) );
	
	if ( !IsDefined( sun_color ) || 
		 !IsDefined( sun_dir ) || 
		 !IsDefined( sun_begin_fade_angle ) ||
		 !IsDefined( sun_end_fade_angle ) ||
		 !IsDefined( sun_fog_scale ) )
	{
		self SetThermalFog( duration, 
							color, 
							fog_start, 
	                        halfway_dist, 
	                        fog_max_opacity);
	}
	else
	{
		Assert( IsDefined( sun_color ) );
		Assert( IsDefined( sun_dir ) );
		Assert( IsDefined( sun_begin_fade_angle ) );
		Assert( IsDefined( sun_end_fade_angle ) );
		Assert( IsDefined( sun_fog_scale ) );
		
		self SetThermalFog( duration, 
							color, 
							fog_start, 
                            halfway_dist, 
                            fog_max_opacity,
                            sun_color, 
                            sun_dir,
                            sun_begin_fade_angle,
                            sun_end_fade_angle,
                            sun_fog_scale );
	}
}

ac130_set_enhanced_vision_fog( duration, 
						   	color, 
						   	fog_start, 
						   	halfway_dist, 
						   	fog_max_opacity, 
						   	sun_color, 
						   	sun_dir, 
						   	sun_begin_fade_angle, 
						   	sun_end_fade_angle, 
						   	sun_fog_scale )
{
	Assert( IsDefined( duration ) );
	Assert( IsDefined( color ) );
	Assert( IsDefined( fog_start ) );
	Assert( IsDefined( halfway_dist ) );
	Assert( IsDefined( fog_max_opacity ) );
	
	if ( !IsDefined( sun_color ) || 
		 !IsDefined( sun_dir ) || 
		 !IsDefined( sun_begin_fade_angle ) ||
		 !IsDefined( sun_end_fade_angle ) ||
		 !IsDefined( sun_fog_scale ) )
	{
		self PlayerSetExpFog( fog_start,
								halfway_dist,
								color[ 0 ],
								color[ 1 ],
								color[ 2 ], 
		               		 	fog_max_opacity,
		                		duration );
	}
	else
	{
		Assert( IsDefined( sun_color ) );
		Assert( IsDefined( sun_dir ) );
		Assert( IsDefined( sun_begin_fade_angle ) );
		Assert( IsDefined( sun_end_fade_angle ) );
		Assert( IsDefined( sun_fog_scale ) );
		
		self PlayerSetExpFog( fog_start,
                        		halfway_dist, 
								color[ 0 ],
								color[ 1 ],
								color[ 2 ], 
                        		fog_max_opacity,
                        		duration,
                        		sun_color[ 0 ],
                        		sun_color[ 1 ],
                        		sun_color[ 2 ], 
                       			sun_dir,
                        		sun_begin_fade_angle,
                       			sun_end_fade_angle,
                        		sun_fog_scale );
	}
}
		 
ppe_shell_shock()
{
	level endon( "LISTEN_end_ac130" );
	level endon( "post_effects_disabled" );
	
	current_shell_shock = undefined;
	duration = 60000;
	
	for ( ; ; )
	{
		if ( !IsDefined( current_shell_shock ) || current_shell_shock != level.current_shell_shock )
		{
			current_shell_shock = level.current_shell_shock;
			level.ac130player StopShellShock();
			level.ac130player ShellShock( level.current_shell_shock, duration );
		}
		wait 0.05;
	}
}

ppe_vision( mode )
{
    level endon( "LISTEN_end_ac130" );
	level.ac130player endon( "death" );

	mode = ter_op( IsDefined( mode ), mode, "enhanced" );
	mode = ter_op( mode == "enhanced", mode, "thermal" );
	
	NotifyOnCommand( "LISTEN_ac130_change_vision", "+usereload" );
	NotifyOnCommand( "LISTEN_ac130_change_vision", "+activate" );
	
	flag_wait( "FLAG_ac130_hud_start" );
	
	inverted = false;
	
	switch ( mode )
	{
		case "enhanced":
			// Enhanced Vision On / Thermal Off
			
			if ( !flag( "FLAG_ac130_enhanced_vision_enabled" ) )
	    		flag_set( "FLAG_ac130_enhanced_vision_enabled" );
			if ( flag( "FLAG_ac130_thermal_enabled" ) )
	            flag_clear( "FLAG_ac130_thermal_enabled" );

			level.ac130player SetBlurForPlayer( level.ac130_enhanced_blur, 0 );
			level.current_shell_shock = level.ac130_enhanced_shock; // enhanced
			level.ac130player vision_set_fog_changes( level.ac130_enhanced_vision_set, 0 );
			hud_on( "enhanced" );
			inverted = true;
			break;
		case "thermal":
			// Enhanced Vision Off / Thermal On
			
			if ( flag( "FLAG_ac130_enhanced_vision_enabled" ) )
        		flag_clear( "FLAG_ac130_enhanced_vision_enabled" );
			if ( !flag( "FLAG_ac130_thermal_enabled" ) )
	            flag_set( "FLAG_ac130_thermal_enabled" );
	            
			level.ac130player SetBlurForPlayer( level.ac130_thermal_blur, 0 );
			level.current_shell_shock = level.ac130_thermal_shock;
			level.ac130player ac130_set_thermal_fog( 0, 
													 level.ac130_thermal_fog_color, 
													 level.ac130_thermal_fog_start, 
					                                 level.ac130_thermal_fog_halfway_dist, 
					                                 level.ac130_thermal_fog_opacity,
					                                 level.ac130_thermal_sun_color, 
					                                 level.ac130_thermal_sun_dir,
					                                 level.ac130_thermal_sun_begin_fade_angle,
					                                 level.ac130_thermal_sun_end_fade_angle,
					                                 level.ac130_thermal_sun_fog_scale );
					                                 
			level.ac130player VisionSetThermalForPlayer( level.ac130_thermal_vision_set, 0 );
			level.ac130player ThermalVisionOn();
			hud_on( "thermal" );
			inverted = false;
			break;
	}
	
	
	for ( ; ; )
	{
		level.ac130player waittill( "LISTEN_ac130_change_vision" );

		if ( !flag( "FLAG_ac130_change_vision_enabled" ) )
			continue;
			
        if ( !inverted )
		{
			// Enhanced
			
			// Enhanced Vision On / Thermal Off
			
			if ( !flag( "FLAG_ac130_enhanced_vision_enabled" ) )
	    		flag_set( "FLAG_ac130_enhanced_vision_enabled" );
			if ( flag( "FLAG_ac130_thermal_enabled" ) )
	            flag_clear( "FLAG_ac130_thermal_enabled" );
	        flag_set( "FLAG_ac130_vision_transition" );
	        
	        level.ac130player thread play_sound_on_entity( "ui_ac130_view_switch" ); // **TODO needs to go in ac130 vehicle sounds
	        
			//fade_time = 0.05;
			//thread fade_to_white( fade_time, 1.0 );
			hud_off();
			level.HUDItem[ "static" ].alpha = 1.0;
	
			level.ac130player SetBlurForPlayer( level.ac130_enhanced_blur, 0 );
			level.current_shell_shock = level.ac130_enhanced_shock; // enhanced
			level.ac130player ThermalVisionOff();
			level.ac130player ClearThermalFog();
			level.ac130player vision_set_fog_changes( level.ac130_enhanced_vision_set, 0 );
			
			//wait fade_time;
			wait 0.15;

			hud_on( "enhanced" );
			//fade_in_from_white( fade_time, 0.0 );
			level.HUDItem[ "static" ].alpha = 0.0;
			inverted = true;
			
			flag_clear( "FLAG_ac130_vision_transition" );
		}
		else
		{
			// Thermal
			
			// Enhanced Vision Off / Thermal On
			
			if ( flag( "FLAG_ac130_enhanced_vision_enabled" ) )
        		flag_clear( "FLAG_ac130_enhanced_vision_enabled" );
			if ( !flag( "FLAG_ac130_thermal_enabled" ) )
	            flag_set( "FLAG_ac130_thermal_enabled" );
	        flag_set( "FLAG_ac130_vision_transition" );
	        
	        level.ac130player thread play_sound_on_entity( "ui_ac130_view_switch" ); // **TODO needs to go in ac130 vehicle sounds
	            
			hud_off();
			level.HUDItem[ "static" ].alpha = 1.0;
			                        
			level.ac130player SetBlurForPlayer( level.ac130_thermal_blur, 0 );
			level.current_shell_shock = level.ac130_thermal_shock;
			level.ac130player ac130_set_thermal_fog( 0, 
													 level.ac130_thermal_fog_color, 
													 level.ac130_thermal_fog_start, 
					                                 level.ac130_thermal_fog_halfway_dist, 
					                                 level.ac130_thermal_fog_opacity,
					                                 level.ac130_thermal_sun_color, 
					                                 level.ac130_thermal_sun_dir,
					                                 level.ac130_thermal_sun_begin_fade_angle,
					                                 level.ac130_thermal_sun_end_fade_angle,
					                                 level.ac130_thermal_sun_fog_scale );
					                                 
			level.ac130player VisionSetThermalForPlayer( level.ac130_thermal_vision_set, 0 );
			level.ac130player ThermalVisionOn();
			
			wait 0.15;

			hud_on( "thermal" );
			level.HUDItem[ "static" ].alpha = 0.0;
			inverted = false;

			flag_clear( "FLAG_ac130_vision_transition" );
		}
	}
}

fade_to_white( fade_time, _alpha )
{
	fade_time = ter_op( IsDefined( fade_time ), fade_time, 0.05 );
 	fade_time = ter_op( fade_time > 0.05, fade_time, 0.05 );
 	_alpha = ter_op( IsDefined( _alpha ), _alpha, 0 );
 	_alpha = ter_op( _alpha > 0, _alpha, 0 );
 	_alpha = ter_op( _alpha < 1, _alpha, 1 );
 	   
	level.white_overlay = maps\_hud_util::create_client_overlay( "white", 0, level.ac130player );
	level.white_overlay FadeOverTime( fade_time );
	level.white_overlay.alpha = _alpha;
	level.white_overlay.foreground = true;
	
	wait fade_time;
}

fade_in_from_white( fade_time, _alpha )
{
 	fade_time = ter_op( IsDefined( fade_time ), fade_time, 0.05 );
 	fade_time = ter_op( fade_time > 0.05, fade_time, 0.05 );
 	_alpha = ter_op( IsDefined( _alpha ), _alpha, 0 );
 	_alpha = ter_op( _alpha > 0, _alpha, 0 );
 	_alpha = ter_op( _alpha < 1, _alpha, 1 );
    
    if ( !IsDefined( level.white_overlay ) )
        return;
        
	level.white_overlay FadeOverTime( fade_time );
	level.white_overlay.alpha = _alpha;
	
	wait fade_time;
	
	level.white_overlay Destroy();
}

change_weapons()
{
	level endon( "LISTEN_end_ac130" );

	current_weapon = 0;
	level.current_weapon = level.ac130_weapon[ current_weapon ].name;
		
	thread camera_shake_on_weapon_fire();

	NotifyOnCommand( "LISTEN_switch_weapons", "weapnext" );
	NotifyOnCommand( "LISTEN_attack_button_pressed", "+attack" );
	NotifyOnCommand( "LISTEN_attack_button_pressed", "+attack_akimbo_accessible" );	// support accessibility control scheme

	wait 0.05;

	for ( ;; )
	{
		level.ac130player waittill( "LISTEN_switch_weapons" );
		
		if ( !flag( "FLAG_ac130_change_weapons_enabled" ) )
			continue;

		level.ac130player notify( "shot weapon" );

		// Change to next weapon
		
		current_weapon++;
		if ( current_weapon >= level.ac130_weapon.size )
			current_weapon = 0;

		level.current_weapon = level.ac130_weapon[ current_weapon ].name;

		// Turn Off crosshairs of other weapons
		
		foreach( i, item in level.HUDItem[ "crosshairs" ] )
		{
			if ( i != current_weapon )
			{
				item FadeOverTime( 1 / 60 );
				item.alpha = 0.0;
			}
		}
		
		thread hud_blink_current_weapon_name( current_weapon );
		level.ac130player thread play_sound_on_entity( "ac130_weapon_switch" );
		
		// Turn On crosshairs of current weapon
		
		wait 0.05;
		
		if( !level.weapon_cooldown_active[ level.current_weapon ] )
			level.HUDItem[ "crosshairs" ][ current_weapon ].alpha = 1.0;
	}
}

weapon_fire_notify()
{
	level endon( "LISTEN_end_ac130" );
	
	for ( ; ; )
	{
		if ( level.ac130player AttackButtonPressed() )
			level.ac130player notify( "LISTEN_attack_button_pressed" );
		wait 0.05;
	}
}

weapon_fire()
{
	level endon( "LISTEN_end_ac130" );
	
	thread weapon_fire_notify();
	
	time_of_last_trace = 0;
	time_for_25mm_trace = 0.2; // max of 5 traces per sec
	do_25mm_trace = true;
	height = level.ac130player GetEye()[ 2 ];
	time_before_resetting_height = 1.5;
	
	for ( ; ; )
	{
		level.ac130player waittill( "LISTEN_attack_button_pressed" );
		
		level.time_of_ac130_fire = GetTime();
		level.player_angles_at_last_ac130_fire = level.ac130player GetPlayerAngles();
			
		if ( !level.weapon_ready_to_fire[ level.current_weapon ] || 
			 level.weapon_cooldown_active[ level.current_weapon ] || 
			 level.weapon_input_cooldown_active[ level.current_weapon ] || 
			 !flag( "FLAG_ac130_clear_to_engage" ) )
		{
			continue;
		}
		else
		{
			fwd = level.ac130_weapon_tag_offset[ "forward" ] * AnglesToForward( level.ac130_weapon_tag.angles );
			up = level.ac130_weapon_tag_offset[ "up" ] * AnglesToUp( level.ac130_weapon_tag.angles );
			right = level.ac130_weapon_tag_offset[ "right" ] * AnglesToRight( level.ac130_weapon_tag.angles );
			
			start = level.ac130_weapon_tag.origin + fwd + up + right;
			end = level.ac130player GetEye() + 15000 * AnglesToForward( level.ac130player GetPlayerAngles() );
			
			if ( ( level.time_of_ac130_fire - time_of_last_trace ) > time_for_25mm_trace * 1000 )
				do_25mm_trace = true;
			
			if ( ( level.time_of_ac130_fire - time_of_last_trace ) > time_before_resetting_height * 1000 )
				height = level.ac130player GetEye()[ 2 ];
			
			trace = undefined;
				
			if ( IsSubStr( level.current_weapon, "25" ) )
			{
				if ( do_25mm_trace )
				{
					time_of_last_trace 		= level.time_of_ac130_fire;
					do_25mm_trace			= false;
					trace 					= BulletTrace( level.ac130player GetEye(), end, true, level.ac130player );
					
					if ( IsDefined( trace[ "position" ] ) )
					{
						end 	= trace[ "position" ];
						height 	= level.ac130player GetEye()[ 2 ] - trace[ "position" ][ 2 ];
						height 	= ter_op( height > 0, height, 0 );
					}
					else
					{
						end = level.ac130player GetEye() + ( height / Cos( 90 - level.ac130player GetPlayerAngles()[ 0 ] ) ) * AnglesToForward( level.ac130player GetPlayerAngles() );
					}
				}
				else
				{
					end = level.ac130player GetEye() + ( height / Cos( 90 - level.ac130player GetPlayerAngles()[ 0 ] ) ) * AnglesToForward( level.ac130player GetPlayerAngles() );
				}
			}
			else
			{
				time_of_last_trace 		= level.time_of_ac130_fire;
				trace 					= BulletTrace( level.ac130player GetEye(), end, true, level.ac130player );
				
				if ( IsDefined( trace[ "position" ] ) )
				{
					end 	= trace[ "position" ];
					height 	= level.ac130player GetEye()[ 2 ] - trace[ "position" ][ 2 ];
					height 	= ter_op( height > 0, height, 0 );
				}
				else
				{
					end = level.ac130player GetEye() + ( height / Cos( 90 - level.ac130player GetPlayerAngles()[ 0 ] ) ) * AnglesToForward( level.ac130player GetPlayerAngles() );
				}
			}

			if ( is_coop() )
			{
				tag = "tag_flash_105mm1";
				fx = "FX_ac130_coop_muzzleflash_105mm"; 
				
				if ( IsSubStr( level.current_weapon, "40" ) )
				{
					tag = "tag_flash_40mm";
					fx = "FX_ac130_coop_muzzleflash_40mm";
				}
				else
				if ( IsSubStr( level.current_weapon, "25" ) )
				{
					tag = "tag_flash_25mm";
					fx = "FX_ac130_coop_muzzleflash_25mm";
				}
					
				start = level.coop_ac130_vehicle GetTagOrigin( tag );
				PlayFXOnTag( getfx( fx ), level.coop_ac130_vehicle, tag ); 
			}

			projectile = MagicBullet( level.current_weapon, start, end, level.ac130player );

			if ( IsDefined( level.ac130_projectile_callback ) )
			{
				args = [ level.current_weapon, trace ];
				projectile thread [[ level.ac130_projectile_callback ]]( args );
			}
			
			level.ac130player notify( "missile_fire", projectile, level.current_weapon );
			level.ac130player notify( "LISTEN_ac130_weapon_fired" );
			
			if ( IsSubStr( level.current_weapon, "105" ) )
			{
				level.ac130player thread play_sound_on_entity( "ac130_105mm_fire" );
				//level.ac130_weapon_sound_tag PlaySoundAsMaster( "ac130_105mm_fire", "ac130_105mm_fire", true );
				level.ac130player PlayRumbleOnEntity( "ac130_105mm_fire" );
			}
			else
			if ( IsSubStr( level.current_weapon, "40" ) )
			{
				level.ac130player thread play_sound_on_entity( "ac130_40mm_fire" );
				//level.ac130_weapon_sound_tag PlaySoundAsMaster( "ac130_40mm_fire", "ac130_40mm_fire", true );
				level.ac130player PlayRumbleOnEntity( "ac130_40mm_fire" );
			}
			else
			if ( IsSubStr( level.current_weapon, "25" ) )
				level.ac130player PlayRumbleOnEntity( "ac130_25mm_fire" );
		}
			
		if ( IsSubStr( level.current_weapon, "105" ) )
			thread playSoundOverRadio( level.scr_sound[ "gun" ][ "ac130_gun_shotout" ], false );

		thread weapon_reload( level.current_weapon );
	}
}

weapon_reload( weapon )
{
	Assert( IsDefined( weapon ) );
	
	level endon( "LISTEN_end_ac130" );
	
	level.weapon_ready_to_fire[ weapon ] = false;
	level.weapon_ammo_count[ weapon ]--;

	if ( level.weapon_reload_time[ weapon ] > 0 )
		wait level.weapon_reload_time[ weapon ];

	if ( level.weapon_ammo_count[ weapon ] <= 0 )
	{
		/*
		if ( IsSubStr( weapon, "105" ) )
			level.ac130player thread play_sound_on_entity( "ac130_105mm_reload" );
		else
		*/
		if ( IsSubStr( weapon, "40" ) )
			level.ac130player thread play_sound_on_entity( "ac130_40mm_reload" );
		else
		if ( IsSubStr( weapon, "25" ) )
			level.ac130player thread play_sound_on_entity( "ac130_25mm_reload" );

		level.weapon_cooldown_active[ weapon ] = true;
		if ( level.weapon_cooldown_time[ weapon ] > 0 )
			wait level.weapon_cooldown_time[ weapon ];
		level.weapon_ammo_count[ weapon ] = level.weapon_ammo_max[ weapon ];
		level.weapon_cooldown_active[ weapon ] = false;
		
		if ( weapon == level.current_weapon )
			thread playSoundOverRadio( level.scr_sound[ "gun" ][ "ac130_gun_gunready" ], false );
	}
	level.weapon_ready_to_fire[ weapon ] = true;
}

no_fire_crosshair()
{
	level endon( "FLAG_ac130_clear_to_engage" );
	level endon( "LISTEN_end_ac130" );

	if ( flag( "FLAG_ac130_clear_to_engage" ) )
		return;

	level.ac130_nofire = NewClientHudElem( level.ac130player );
	level.ac130_nofire.x = 0;
	level.ac130_nofire.y = 0;
	level.ac130_nofire.alignX = "center";
	level.ac130_nofire.alignY = "middle";
	level.ac130_nofire.horzAlign = "center";
	level.ac130_nofire.vertAlign = "middle";
	level.ac130_nofire SetShader( "ac130_overlay_nofire", 64, 64 );

	thread no_fire_crosshair_remove();

	level.ac130_nofire.alpha = 0;

	for ( ; ; )
	{
		while ( level.ac130player AttackButtonPressed() )
		{
			level.ac130_nofire.alpha = 1;
			level.ac130_nofire FadeOverTime( 1.0 );
			level.ac130_nofire.alpha = 0;
			wait 1.0;
		}
		wait 0.05;
	}
}

no_fire_crosshair_remove()
{
	level endon( "LISTEN_end_ac130" );
	
	level waittill( "FLAG_ac130_clear_to_engage" );
	level.ac130_nofire Destroy();
}

camera_shake_on_weapon_fire()
{
	level endon( "LISTEN_end_ac130" );
	
	for ( ;; )
	{
		level.ac130player waittill( "LISTEN_ac130_weapon_fired" );

		if ( level.weapon_ready_to_fire[ level.current_weapon ] )
		{
			if ( IsSubStr( level.current_weapon, "105" ) )
			{
				if ( !flag( "FLAG_ac130_clear_to_engage" ) )
					continue;
				//earthquake( <scale>, <duration>, <source>, <radius> )
				Earthquake( 0.2, 1, level.ac130player.origin, 1000 );
			}
			else
			if ( IsSubStr( level.current_weapon, "40" ) )
			{
				if ( !flag( "FLAG_ac130_clear_to_engage" ) )
					continue;
				//earthquake( <scale>, <duration>, <source>, <radius> )
				Earthquake( 0.1, 0.5, level.ac130player.origin, 1000 );
			}
		}
		wait 0.05;
	}
}

ac130_rumble_sound()
{
	level endon( "LISTEN_end_ac130" );
	
	for ( ; ; )
	{
		if ( flag( "FLAG_ac130_rumble" ) )
		{
			level.ac130player play_sound_on_entity( "scn_ac130_screenshake_rattles" );
			flag_clear( "FLAG_ac130_rumble" );
		}
		else
			wait 0.05;
	}
}

clouds()
{
	level endon( "stop_clounds" );
	level endon( "LISTEN_end_ac130" );
	
	wait 6;
	clouds_create();
	for ( ;; )
	{
		wait( RandomFloatRange( 40, 80 ) );
		clouds_create();
	}
}

clouds_create()
{
	if ( ( IsDefined( level.current_weapon ) ) && ( IsSubStr( ToLower( level.current_weapon ), "25" ) ) )
		return;
	PlayFXOnTag( level._effect[ "cloud" ], level.ac130, "tag_player" );
}

getFriendlysCenter()
{
	// Returns vector which is the center mass of all friendlies
	
	averageVec = undefined;
	friendlies = GetAIArray( "allies" );
	
	if ( !IsDefined( friendlies ) )
		return( 0, 0, 0 );
	if ( friendlies.size <= 0 )
		return( 0, 0, 0 );
		
	for ( i = 0 ; i < friendlies.size ; i++ )
	{
		if ( !IsDefined( averageVec ) )
			averageVec = friendlies[ i ].origin;
		else
			averageVec += friendlies[ i ].origin;
	}
	averageVec = ( ( averageVec[ 0 ] / friendlies.size ), ( averageVec[ 1 ] / friendlies.size ), ( averageVec[ 2 ] / friendlies.size ) );
	return averageVec;
}

is_ac130_weapon( weapon_name, ac130_weapon )
{
	Assert( IsDefined( weapon_name ) );
	
	if ( IsDefined( ac130_weapon ) )
		return ( IsSubStr( ToLower( weapon_name ), ac130_weapon ) );
	else
		return ( IsSubStr( ToLower( weapon_name ), "105" ) ||
				 IsSubStr( ToLower( weapon_name ), "40" ) ||
				 IsSubStr( ToLower( weapon_name ), "20" ) );
}

set_badplace_max( max )
{
	max = ter_op( IsDefined( max ), max, 0 );
	max = ter_op( max < 0, 0, max );
	
	level.badplaceMax = max;
}

shotFired()
{
	level endon( "LISTEN_end_ac130" );
	
	for ( ;; )
	{
		level.ac130player waittill( "projectile_impact", weaponName, position, radius );

		thread shotFiredFriendlyProximity( weaponName, position );

		if ( is_ac130_weapon( weaponName, "105" ) )
		{
			Earthquake( 0.4, 1.0, position, 3500 );
			thread shotFiredDarkScreenOverlay();
		}
		else if ( is_ac130_weapon( weaponName, "40" ) )
		{
			Earthquake( 0.2, 0.5, position, 2000 );
		}

        if ( is_ac130_weapon( weaponName ) )
			thread shotFiredBadPlace( position, weaponName );
        
		if ( is_ac130_weapon( weaponName ) )
			thread shotFiredPhysicsSphere( position, weaponName );
		wait 0.05;
	}
}

shotFiredFriendlyProximity( weaponName, position )
{
	if ( !IsDefined( level.weaponFriendlyCloseDistance[ weaponName ] ) )
		return;

	trigger_origin = position - ( 0, 0, 50 );
	trigger_radius = level.weaponFriendlyCloseDistance[ weaponName ];
	trigger_height = 300;
	trigger_spawnflags = 2; // AI_ALLIES AND THE PLAYER // keept the ai if it ever get used with friendlies again.
	trigger_lifetime = 1.0;

	prof_begin( "ac130_friendly_proximity_check" );
	trigger = Spawn( "trigger_radius", trigger_origin, trigger_spawnflags, trigger_radius, trigger_height );
	prof_end( "ac130_friendly_proximity_check" );
	level thread shotFiredFriendlyProximity_trigger( trigger, trigger_lifetime );
}

shotFiredFriendlyProximity_trigger( trigger, trigger_lifetime )
{
	trigger endon( "timeout" );
	level thread shotFiredFriendlyProximity_trigger_timeout( trigger, trigger_lifetime );
	trigger waittill( "trigger" );

	// don't play warning dialog if one played within the last 5 seconds.
	
	prof_begin( "ac130_friendly_proximity_check" );
	if ( ( IsDefined( level.lastFriendlyProximityWarningPlayed ) ) && ( GetTime() - level.lastFriendlyProximityWarningPlayed < 7000 ) )
	{
		prof_end( "ac130_friendly_proximity_check" );
		return;
	}

	level.lastFriendlyProximityWarningPlayed = GetTime();
	prof_end( "ac130_friendly_proximity_check" );

	sounds = [];
	
    // 3-11 Watch your fire.  That was too close to our guys.
    sounds[ sounds.size ] = level.scr_sound[ "fco" ][ "ac130_fco_tooclose2" ];
    // 3-12 Uhhh you're firing too close to the friendlies.  I repeat - you're firing too close to the friendlies.
    sounds[ sounds.size ] = level.scr_sound[ "fco" ][ "ac130_fco_tooclose" ];
    // 3-13 Careful ... you almost hit our guys there ...
    sounds[ sounds.size ] = level.scr_sound[ "fco" ][ "ac130_fco_careful" ];
    // 3-14 Check your fire, you're shootin' at friendlies.
    sounds[ sounds.size ] = level.scr_sound[ "fco" ][ "ac130_fco_checkfire" ];

    if ( sounds.size > 0 )
    {
    	sound = sounds[ RandomInt( sounds.size ) ];
    	
    	if ( IsDefined( sound ) )
			thread playSoundOverRadio( sound, level.ac130_friendly_fire_dialogue_priority, 5.0 );
	}
}

shotFiredFriendlyProximity_trigger_timeout( trigger, trigger_lifetime )
{
	wait trigger_lifetime;
	trigger notify( "timeout" );
	trigger Delete();
}

shotFiredBadPlace( center, weapon )
{
	// no new badplace if more then 20
	if ( level.badplaceCount >= level.badplaceMax )
		return;

	Assert( IsDefined( level.badplaceRadius[ weapon ] ) );
	BadPlace_Cylinder( "", level.badplaceDuration[ weapon ], center, level.badplaceRadius[ weapon ], level.badplaceRadius[ weapon ], "axis" );
	thread shotFiredBadPlaceCount( level.badplaceDuration[ weapon ] );
}

shotFiredBadPlaceCount( durration )
{
	Assert( level.badplaceCount >= 0 );
	Assert( level.badplaceCount < level.badplaceMax );

	level.badplaceCount++;
	wait durration;
	level.badplaceCount--;
}

shotFiredPhysicsSphere( center, weapon )
{
	wait 0.1;
	if ( !IsSubStr( weapon, "25" ) )
		PhysicsExplosionSphere( center, level.physicsSphereRadius[ weapon ], level.physicsSphereRadius[ weapon ] / 2, level.physicsSphereForce[ weapon ] );
}

shotFiredDarkScreenOverlay()
{
	level notify( "darkScreenOverlay" );
	level endon( "darkScreenOverlay" );

	if ( !IsDefined( level.darkScreenOverlay ) )
	{
		level.darkScreenOverlay = NewClientHudElem( level.ac130player );
		level.darkScreenOverlay.x = 0;
		level.darkScreenOverlay.y = 0;
		level.darkScreenOverlay.alignX = "left";
		level.darkScreenOverlay.alignY = "top";
		level.darkScreenOverlay.horzAlign = "fullscreen";
		level.darkScreenOverlay.vertAlign = "fullscreen";
		level.darkScreenOverlay SetShader( "black", 640, 480 );
		level.darkScreenOverlay.sort = -10;
		level.darkScreenOverlay.alpha = 0.0;
	}
	level.darkScreenOverlay.alpha = 0.0;
	level.darkScreenOverlay FadeOverTime( 0.2 );
	level.darkScreenOverlay.alpha = 0.6;
	wait 0.4;
	level.darkScreenOverlay FadeOverTime( 0.8 );
	level.darkScreenOverlay.alpha = 0.0;
}

// **TODO: put night vision beacon asset in ac130 common

add_beacon_effect()
{
	self endon( "death" );
	level endon( "LISTEN_end_ac130" );

    interval = 0.05;
	flash_delay = 0.75;

	wait RandomFloat( 3.0 );
	
	for ( ; ; )
	{
	    count = 0;
	    toggle = true;
	    
	    while ( count <= flash_delay  )
	    {
	        if ( flag( "FLAG_ac130_thermal_enabled" ) && toggle )
	        {
	            toggle = false;
	            StopFXOnTag( getfx( "FX_night_vision_ai_beacon" ), self, "j_spine4" );
	            
	            if ( IsDefined( level.ac130player ) )
			        PlayFXOnTagForClients( getfx( "FX_thermal_vision_ai_beacon" ), self, "j_spine4", level.ac130player );
	        }
	        
	        if ( !flag( "FLAG_ac130_thermal_enabled" ) && !toggle )
	        {
	            toggle = true;
	            StopFXOnTag( getfx( "FX_thermal_vision_ai_beacon" ), self, "j_spine4" );
	            
	            if ( IsDefined( level.ac130player ) )
			        PlayFXOnTagForClients( getfx( "FX_night_vision_ai_beacon" ), self, "j_spine4", level.ac130player );
	        }
	        
	        count += interval;
	        wait interval;
	    }
	}
}

add_ac130_vehicle_beacon_effect( _tag )
{
	Assert( IsDefined( _tag ) );
	
	self endon( "death" );
	level endon( "LISTEN_end_ac130" );

    interval = 0.05;
	flash_delay = 0.75;

	wait RandomFloat( 3.0 );
	
	for ( ; ; )
	{
	    count = 0;
	    toggle = true;
	    
	    while ( count <= flash_delay  )
	    {
	        if ( flag( "FLAG_ac130_thermal_enabled" ) && !flag( "FLAG_ac130_enhanced_vision_enabled" ) && toggle )
	        {
	            toggle = false;
	            StopFXOnTag( getfx( "FX_night_vision_vehicle_beacon" ), self, _tag );
			   	PlayFXOnTag( getfx( "FX_thermal_vehicle_beacon" ), self, _tag );
	        }
	        
	        if ( !flag( "FLAG_ac130_thermal_enabled" ) && flag( "FLAG_ac130_enhanced_vision_enabled" ) && !toggle )
	        {
	            toggle = true;
	            StopFXOnTag( getfx( "FX_thermal_vehicle_beacon" ), self, _tag );
			    PlayFXOnTag( getfx( "FX_night_vision_vehicle_beacon" ), self, _tag );
	        }
	        
	        count += interval;
	        wait interval;
	    }
	}
}

enemy_killed_thread( guy )
{
	if ( guy.team != "axis" )
		return;

	if ( GetDvar( "ac130_ragdoll_deaths", "1" ) == "1" )
		guy.skipDeathAnim = true;

	guy waittill( "death", attacker );

	if ( ( IsDefined( attacker ) ) && ( IsPlayer( attacker ) ) )
		level.enemiesKilledByPlayer++ ;

	if ( GetDvar( "ac130_ragdoll_deaths", "1" ) == "1" )
	{
		if ( ( IsDefined( guy.damageweapon ) ) && ( IsSubStr( guy.damageweapon, "25mm" ) ) )
			guy.skipDeathAnim = undefined;
	}

	// context kill dialog
	thread context_Sensative_Dialog_Kill( guy, attacker );
}

context_Sensitive_Dialog()
{
	//thread context_Sensitive_Dialog_Guy_In_Sight();
	//thread context_Sensitive_Dialog_Guy_Crawling();
	thread context_Sensitive_Dialog_Guy_Pain();
	thread context_Sensitive_Dialog_Guy_Pain_Falling();
	//thread context_Sensitive_Dialog_Secondary_Explosion_Vehicle();
	//thread context_Sensitive_Dialog_Kill_Thread();
	//thread context_Sensitive_Dialog_Locations();
	thread context_Sensative_Dialog_Filler();
}

context_Sensitive_Dialog_Guy_In_Sight()
{
	level endon( "LISTEN_end_ac130" );
	
	for ( ; ; )
	{
		if ( flag( "FLAG_ac130_context_sensitive_dialog_guy_in_sight" ) && context_Sensitive_Dialog_Guy_In_Sight_Check() )
			thread context_Sensitive_Dialog_Play_Random_Group_Sound( "ai", "in_sight" );
		wait RandomFloatRange( 1, 3 );
	}
}

context_Sensitive_Dialog_Guy_In_Sight_Check()
{
	level endon( "LISTEN_end_ac130" );
	
	prof_begin( "AI_in_sight_check" );

	enemies = GetAIArray( "axis" );
	foreach ( guy in enemies )
	{
		if ( !flag( "FLAG_ac130_context_sensitive_dialog_guy_in_sight" ) )
			continue;
		if ( !IsDefined( guy ) || !IsAlive( guy ) )
			continue;

		if ( within_fov( level.ac130player GetEye(), level.ac130player GetPlayerAngles(), guy.origin, level.cosine[ "5" ] ) )
		{
			prof_end( "AI_in_sight_check" );
			return true;
		}
		wait 0.05;
	}

	prof_end( "AI_in_sight_check" );
	return false;
}

context_Sensitive_Dialog_Guy_Crawling()
{
	level endon( "LISTEN_end_ac130" );
	
	for ( ;; )
	{
		level waittill( "ai_crawling", guy );
		thread context_Sensitive_Dialog_Play_Random_Group_Sound( "ai", "wounded_crawl" );
	}
}

context_Sensitive_Dialog_Guy_Pain_Falling()
{
	level endon( "LISTEN_end_ac130" );
	
	for ( ;; )
	{
		level waittill( "ai_pain_falling", guy );
		if ( flag( "FLAG_ac130_context_sensitive_dialog_guy_pain" ) )
			thread context_Sensitive_Dialog_Play_Random_Group_Sound( "ai", "wounded_pain" );
	}
}

context_Sensitive_Dialog_Guy_Pain()
{
	level endon( "LISTEN_end_ac130" );
	
	for ( ;; )
	{
		level waittill( "ai_pain", guy );
		if ( flag( "FLAG_ac130_context_sensitive_dialog_guy_pain" ) )
			thread context_Sensitive_Dialog_Play_Random_Group_Sound( "ai", "wounded_pain" );
	}
}

context_Sensitive_Dialog_Secondary_Explosion_Vehicle()
{
	level endon( "LISTEN_end_ac130" );
	
	for ( ;; )
	{
		level waittill( "vehicle_explosion", vehicle_origin );

		wait 1;
		thread context_Sensitive_Dialog_Play_Random_Group_Sound( "explosion", "secondary" );
	}
}

context_Sensative_Dialog_Kill( guy, attacker )
{
	level endon( "LISTEN_end_ac130" );
	
	if ( !flag( "FLAG_ac130_context_sensitive_dialog_kill" ) || 
		 !IsDefined( attacker ) || !IsPlayer( attacker ) )
		return;
		
	level.enemiesKilledInTimeWindow++;
	level notify( "LISTEN_ac130_enemy_killed" );
}

context_Sensitive_Dialog_Kill_Thread()
{
	level endon( "LISTEN_end_ac130" );
	
	timeWindow = 1;
	for ( ;; )
	{
		level waittill( "LISTEN_ac130_enemy_killed" );
		if ( !flag( "FLAG_ac130_context_sensitive_dialog_kill" ) )
			continue;
		wait timeWindow;
		if ( !flag( "FLAG_ac130_context_sensitive_dialog_kill" ) )
			continue;

		soundAlias1 = "kill";
		soundAlias2 = undefined;

		if ( level.enemiesKilledInTimeWindow >= 3 )
			soundAlias2 = "large_group";
		else if ( level.enemiesKilledInTimeWindow >= 2 )
			soundAlias2 = "small_group";
		else
		{
			soundAlias2 = "single";
			if ( RandomInt( 3 ) != 1 )
			{
				level.enemiesKilledInTimeWindow = 0;
				continue;
			}
		}

		level.enemiesKilledInTimeWindow = 0;
		Assert( IsDefined( soundAlias2 ) );

		thread context_Sensitive_Dialog_Play_Random_Group_Sound( soundAlias1, soundAlias2, true );
	}
}

context_Sensitive_Dialog_Locations()
{
	array_thread( GetEntArray( "context_dialog_car", 		"targetname" ), 	::context_Sensitive_Dialog_Locations_Add_Notify_Event, "car" );
	array_thread( GetEntArray( "context_dialog_truck", 		"targetname" ), 	::context_Sensitive_Dialog_Locations_Add_Notify_Event, "truck" );
	array_thread( GetEntArray( "context_dialog_building", 	"targetname" ), 	::context_Sensitive_Dialog_Locations_Add_Notify_Event, "building" );
	array_thread( GetEntArray( "context_dialog_wall", 		"targetname" ), 	::context_Sensitive_Dialog_Locations_Add_Notify_Event, "wall" );
	array_thread( GetEntArray( "context_dialog_field", 		"targetname" ), 	::context_Sensitive_Dialog_Locations_Add_Notify_Event, "field" );
	array_thread( GetEntArray( "context_dialog_road", 		"targetname" ), 	::context_Sensitive_Dialog_Locations_Add_Notify_Event, "road" );
	array_thread( GetEntArray( "context_dialog_church", 		"targetname" ), 	::context_Sensitive_Dialog_Locations_Add_Notify_Event, "church" );
	array_thread( GetEntArray( "context_dialog_ditch", 		"targetname" ), 	::context_Sensitive_Dialog_Locations_Add_Notify_Event, "ditch" );

	thread context_Sensitive_Dialog_Locations_Thread();
}

context_Sensitive_Dialog_Locations_Thread()
{
	level endon( "LISTEN_end_ac130" );
	
	for ( ;; )
	{
		level waittill( "context_location", locationType );

		if ( !IsDefined( locationType ) )
		{
			AssertMsg( "LocationType " + locationType + " is not valid" );
			continue;
		}

		if ( !flag( "allow_context_sensative_dialog" ) )
			continue;

		thread context_Sensitive_Dialog_Play_Random_Group_Sound( "location", locationType );

		wait( 5 + RandomFloat( 10 ) );
	}
}

context_Sensitive_Dialog_Locations_Add_Notify_Event( locationType )
{
	level endon( "LISTEN_end_ac130" );
	
	for ( ;; )
	{
		self waittill( "trigger", triggerer );

		if ( !IsDefined( triggerer ) )
			continue;

		if ( ( !IsDefined( triggerer.team ) ) || ( triggerer.team != "axis" ) )
			continue;

		level notify( "context_location", locationType );

		wait 5;
	}
}

context_Sensative_Dialog_VehicleSpawn( vehicle )
{
	level endon( "LISTEN_end_ac130" );
	
	if ( vehicle.script_team != "axis" )
		return;

	thread context_Sensative_Dialog_VehicleDeath( vehicle );

	vehicle endon( "death" );

	while ( !within_fov( level.ac130player getEye(), level.ac130player getPlayerAngles(), vehicle.origin, level.cosine[ "45" ] ) )
		wait 0.5;

	context_Sensitive_Dialog_Play_Random_Group_Sound( "vehicle", "incoming" );
}

context_Sensative_Dialog_VehicleDeath( vehicle )
{
	vehicle waittill( "death" );
	thread context_Sensitive_Dialog_Play_Random_Group_Sound( "vehicle", "death" );
}

context_Sensative_Dialog_Filler()
{
	level endon( "LISTEN_end_ac130" );
	
	for ( ;; )
	{
		if ( !flag( "FLAG_ac130_context_sensitive_dialog_filler" ) )
		{
			wait 0.05;
			continue;
		}
		if ( ( IsDefined( level.radio_in_use ) ) && ( level.radio_in_use == true ) )
			level waittill( "radio_not_in_use" );
		if ( !flag( "FLAG_ac130_context_sensitive_dialog_filler" ) )
		{
			wait 0.05;
			continue;
		}

		// if 3 seconds has passed and nothing has been transmitted then play a sound
		currentTime = GetTime();
		if ( ( currentTime - level.lastRadioTransmission ) >= 3000 )
		{
			level.lastRadioTransmission = currentTime;
			thread context_Sensitive_Dialog_Play_Random_Group_Sound( "misc", "action" );
		}
		wait 0.25;
	}
}

context_Sensitive_Dialog_Play_Random_Group_Sound( name1, name2, force_transmit_on_turn )
{
	assert( IsDefined( level.scr_sound[ name1 ] ) );
	assert( IsDefined( level.scr_sound[ name1 ][ name2 ] ) );

	level endon( "LISTEN_end_ac130" );
	
	if ( !IsDefined( force_transmit_on_turn ) )
		force_transmit_on_turn = false;

	if ( !flag( "allow_context_sensative_dialog" ) )
	{
		if ( force_transmit_on_turn )
			flag_wait( "allow_context_sensative_dialog" );
		else
			return;
	}

	validGroupNum = undefined;

	randGroup = RandomInt( level.scr_sound[ name1 ][ name2 ].size );

	// if randGroup has already played
	if ( level.scr_sound[ name1 ][ name2 ][ randGroup ].played == true )
	{
		//loop through all groups and use the next one that hasn't played yet

		for ( i = 0 ; i < level.scr_sound[ name1 ][ name2 ].size ; i++ )
		{
			randGroup++ ;
			if ( randGroup >= level.scr_sound[ name1 ][ name2 ].size )
				randGroup = 0;
			if ( level.scr_sound[ name1 ][ name2 ][ randGroup ].played == true )
				continue;
			validGroupNum = randGroup;
			break;
		}

		// all groups have been played, reset all groups to false and pick a new random one
		if ( !IsDefined( validGroupNum ) )
		{
			for ( i = 0 ; i < level.scr_sound[ name1 ][ name2 ].size ; i++ )
				level.scr_sound[ name1 ][ name2 ][ i ].played = false;
			validGroupNum = randomint( level.scr_sound[ name1 ][ name2 ].size );
		}
	}
	else
		validGroupNum = randGroup;

	Assert( IsDefined( validGroupNum ) );
	Assert( validGroupNum >= 0 );

	if ( context_Sensitive_Dialog_Timedout( name1, name2, validGroupNum ) )
		return;

	level.scr_sound[ name1 ][ name2 ][ validGroupNum ].played = true;
	randSound = RandomInt( level.scr_sound[ name1 ][ name2 ][ validGroupNum ].size );
	playSoundOverRadio( level.scr_sound[ name1 ][ name2 ][ validGroupNum ].sounds[ randSound ], force_transmit_on_turn );
}

context_Sensitive_Dialog_Timedout( name1, name2, groupNum )
{
	level endon( "LISTEN_end_ac130" );
	
	// dont play this sound if it has a timeout specified and the timeout has not expired

	if ( !IsDefined( level.context_sensitive_dialog_timeouts ) )
		return false;

	if ( !IsDefined( level.context_sensitive_dialog_timeouts[ name1 ] ) )
		return false;

	if ( !IsDefined( level.context_sensitive_dialog_timeouts[ name1 ][ name2 ] ) )
		return false;

	if ( ( IsDefined( level.context_sensitive_dialog_timeouts[ name1 ][ name2 ].groups ) ) && ( IsDefined( level.context_sensitive_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ] ) ) )
	{
		Assert( IsDefined( level.context_sensitive_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v[ "timeoutDuration" ] ) );
		Assert( IsDefined( level.context_sensitive_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v[ "lastPlayed" ] ) );

		currentTime = GetTime();
		if ( ( currentTime - level.context_sensitive_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v[ "lastPlayed" ] ) < level.context_sensitive_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v[ "timeoutDuration" ] )
			return true;

		level.context_sensitive_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v[ "lastPlayed" ] = currentTime;
	}
	else if ( IsDefined( level.context_sensitive_dialog_timeouts[ name1 ][ name2 ].v ) )
	{
		Assert( IsDefined( level.context_sensitive_dialog_timeouts[ name1 ][ name2 ].v[ "timeoutDuration" ] ) );
		Assert( IsDefined( level.context_sensitive_dialog_timeouts[ name1 ][ name2 ].v[ "lastPlayed" ] ) );

		currentTime = GetTime();
		if ( ( currentTime - level.context_sensitive_dialog_timeouts[ name1 ][ name2 ].v[ "lastPlayed" ] ) < level.context_sensitive_dialog_timeouts[ name1 ][ name2 ].v[ "timeoutDuration" ] )
			return true;

		level.context_sensitive_dialog_timeouts[ name1 ][ name2 ].v[ "lastPlayed" ] = currentTime;
	}

	return false;
}

playSoundOverRadio( soundAlias, force_transmit_on_turn, timeout )
{
	level endon( "LISTEN_end_ac130" );
	
	if ( !IsDefined( level.radio_in_use ) )
		level.radio_in_use = false;
	if ( !IsDefined( force_transmit_on_turn ) )
		force_transmit_on_turn = false;
	if ( !IsDefined( timeout ) )
		timeout = 0;
	timeout = timeout * 1000;
	soundQueueTime = GetTime();

	soundPlayed = false;
	soundPlayed = playAliasOverRadio( soundAlias );
	if ( soundPlayed )
		return true;

	// Dont make the sound wait to be played if force transmit wasn't set to true
	if ( !force_transmit_on_turn )
		return false;

	level.radioForcedTransmissionQueue[ level.radioForcedTransmissionQueue.size ] = soundAlias;
	while ( !soundPlayed )
	{
		if ( level.radio_in_use )
			level waittill( "radio_not_in_use" );

		if ( ( timeout > 0 ) && ( GetTime() - soundQueueTime > timeout ) )
			break;

		soundPlayed = playAliasOverRadio( level.radioForcedTransmissionQueue[ 0 ] );
		if ( !level.radio_in_use && !soundPlayed )
			AssertMsg( "The radio wasn't in use but the sound still did not play. This should never happen." );
	}
	level.radioForcedTransmissionQueue = array_remove_index( level.radioForcedTransmissionQueue, 0 );
	return true;
}

playAliasOverRadio( soundAlias )
{
	level endon( "LISTEN_end_ac130" );
	
	if ( level.radio_in_use )
		return false;

	level.radio_in_use = true;
	level.ac130player PlayLocalSound( soundAlias, "playSoundOverRadio_done", true );
	level.ac130player waittill( "playSoundOverRadio_done" );	
	level.radio_in_use = false;
	level.lastRadioTransmission = GetTime();
	level notify( "radio_not_in_use" );
	return true;
}
