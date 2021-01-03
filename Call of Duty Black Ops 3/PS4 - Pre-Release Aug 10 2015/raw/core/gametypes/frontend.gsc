
#using scripts\core\gametypes\frontend_zm_bgb_chance;

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

// ARCHETYPE UTILITY SCRIPTS
#using scripts\shared\ai\animation_selector_table_evaluators;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\behavior_state_machine_planners_utility;
#using scripts\shared\ai\archetype_damage_effects;
#using scripts\shared\ai\zombie;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       




#precache( "menu", "SelectMode" );
#precache( "menu", "Main" );
#precache( "menu", "ModeSelect" );
#precache( "menu", "paintshop_light" );
#precache( "menu", "ChooseHead" );
#precache( "menu", "ChooseHead_v1" );
#precache( "menu", "ChooseHero" );
#precache( "menu", "ChooseHero_v1" );
#precache( "menu", "ChooseCharacterLoadout" );
#precache( "menu", "ChoosePersonalizationCharacter" );
#precache( "menu", "personalizeHero" );
#precache( "menu", "personalizeHero_v1" );
#precache( "menu", "ChooseGender" );
#precache( "menu", "ChooseGender_v1" );
#precache( "menu", "CustomClass" );

#precache( "model", "c_zom_der_dempsey_cin_fb" );
#precache( "model", "c_zom_der_nikolai_cin_fb" );
#precache( "model", "c_zom_der_richtofen_cin_fb" );
#precache( "model", "c_zom_der_takeo_cin_fb" );

// keep in synch with _safehouse.gsc
#precache( "xmodel", "p7_bonuscard_primary_gunfighter" );
#precache( "xmodel", "p7_bonuscard_secondary_gunfighter" );
#precache( "xmodel", "p7_bonuscard_overkill" );
#precache( "xmodel", "p7_bonuscard_perk_1_greed" );
#precache( "xmodel", "p7_bonuscard_perk_2_greed" );
#precache( "xmodel", "p7_bonuscard_perk_3_greed" );
#precache( "xmodel", "p7_bonuscard_danger_close" );
#precache( "xmodel", "p7_bonuscard_two_tacticals" );

// group 1 - blue
#precache( "xmodel", "p7_perk_t7_hud_perk_flakjacket" );
#precache( "xmodel", "p7_perk_t7_hud_perk_blind_eye" );
#precache( "xmodel", "p7_perk_t7_hud_perk_hardline" );
#precache( "xmodel", "p7_perk_t7_hud_perk_ghost" );
#precache( "xmodel", "p7_perk_t7_hud_perk_jetsilencer" );
#precache( "xmodel", "p7_perk_t7_hud_perk_lightweight" );
#precache( "xmodel", "p7_perk_t7_hud_perk_jetcharge" );
#precache( "xmodel", "p7_perk_t7_hud_perk_overcharge" );

// group 2 - green
#precache( "xmodel", "p7_perk_t7_hud_perk_hardwired" );
#precache( "xmodel", "p7_perk_t7_hud_perk_scavenger" );
#precache( "xmodel", "p7_perk_t7_hud_perk_cold_blooded" );
#precache( "xmodel", "p7_perk_t7_hud_perk_fasthands" );
#precache( "xmodel", "p7_perk_t7_hud_perk_toughness" );
#precache( "xmodel", "p7_perk_t7_hud_perk_tracker" );
#precache( "xmodel", "p7_perk_t7_hud_perk_ante_up" );

// group 3 - red
#precache( "xmodel", "p7_perk_t7_hud_perk_dexterity" );
#precache( "xmodel", "p7_perk_t7_hud_perk_engineer" );
#precache( "xmodel", "p7_perk_t7_hud_perk_deadsilence" );
#precache( "xmodel", "p7_perk_t7_hud_perk_tacticalmask" );
#precache( "xmodel", "p7_perk_t7_hud_perk_awareness" );
#precache( "xmodel", "p7_perk_t7_hud_perk_sixthsense" );
#precache( "xmodel", "p7_perk_t7_hud_perk_marathon" );
#precache( "xmodel", "p7_perk_t7_hud_perk_gungho" );

// ZM Bubble Gum Buffs
#precache( "xmodel", "p7_zm_bgb_aftertaste" );
#precache( "xmodel", "p7_zm_bgb_alchemical_antithesis" );
#precache( "xmodel", "p7_zm_bgb_always_done_swiftly" );
#precache( "xmodel", "p7_zm_bgb_anywhere_but_here" );
#precache( "xmodel", "p7_zm_bgb_armamental_accomplishment" );
#precache( "xmodel", "p7_zm_bgb_arms_grace" );
#precache( "xmodel", "p7_zm_bgb_arsenal_acelerator" );
#precache( "xmodel", "p7_zm_bgb_burned_out" );
#precache( "xmodel", "p7_zm_bgb_cache_back" );
#precache( "xmodel", "p7_zm_bgb_coagulant" );
#precache( "xmodel", "p7_zm_bgb_danger_closest" );
#precache( "xmodel", "p7_zm_bgb_dead_of_nuclear_winter" );
#precache( "xmodel", "p7_zm_bgb_ephemeral_enhancement" );
#precache( "xmodel", "p7_zm_bgb_firing_on_all_cylinders" );
#precache( "xmodel", "p7_zm_bgb_im_feelin_lucky" );
#precache( "xmodel", "p7_zm_bgb_immolation_liquidation" );
#precache( "xmodel", "p7_zm_bgb_impatient" );
#precache( "xmodel", "p7_zm_bgb_in_plain_sight" );
#precache( "xmodel", "p7_zm_bgb_kill_joy" );
#precache( "xmodel", "p7_zm_bgb_killing_time" );
#precache( "xmodel", "p7_zm_bgb_licensed_contractor" );
#precache( "xmodel", "p7_zm_bgb_lucky_crit" );
#precache( "xmodel", "p7_zm_bgb_now_you_see_me" );
#precache( "xmodel", "p7_zm_bgb_on_the_house" );
#precache( "xmodel", "p7_zm_bgb_one_for_the_road" );
#precache( "xmodel", "p7_zm_bgb_perkaholic" );
#precache( "xmodel", "p7_zm_bgb_phoenix_up" );
#precache( "xmodel", "p7_zm_bgb_pop_shocks" );
#precache( "xmodel", "p7_zm_bgb_private_eyes" );
#precache( "xmodel", "p7_zm_bgb_respin_cycle" );
#precache( "xmodel", "p7_zm_bgb_stock_option" );
#precache( "xmodel", "p7_zm_bgb_sword_flay" );
#precache( "xmodel", "p7_zm_bgb_wall_power" );
#precache( "xmodel", "p7_zm_bgb_whos_keeping_score" );

#using_animtree("all_player");

function callback_void()
{

}

function Callback_ActorSpawnedFrontEnd( spawner )
{
	self thread spawner::spawn_think( spawner );
}

function main()
{
	level.callbackStartGameType = &callback_void;
	level.callbackPlayerConnect = &callback_void;
	level.callbackPlayerDisconnect = &callback_void;
	level.callbackEntitySpawned = &callback_void;
	level.callbackActorSpawned =&Callback_ActorSpawnedFrontEnd;	

	level.orbis = (GetDvarString( "orbisGame") == "true");
	level.durango = (GetDvarString( "durangoGame") == "true");
	
	clientfield::register( "world", "safehouse", 1, GetMinBitCountForNum( 3 ), "int" );
	clientfield::register( "world", "first_time_flow", 1, GetMinBitCountForNum( 1 ), "int" );
	clientfield::register( "world", "cp_bunk_anim_type", 1, GetMinBitCountForNum( 1 ), "int" );

	clientfield::register("actor", "zombie_has_eyes", 1, 1, "int");
	level.weaponNone = GetWeapon( "none" );
	
	/#
		SetDvar( "scr_cycle_frontend_anims", 0 );
		AddDebugCommand( "devgui_cmd \"Frontend/Cycle Player Anims\" \"toggle scr_cycle_frontend_anims 0 1\"\n" );
		
		SetDvar( "scr_frontend_safehouse", "default" );
		AddDebugCommand( "devgui_cmd \"Frontend/Set CP Safe House/Cairo:1\" \"set scr_frontend_safehouse cairo\"\n" );
		AddDebugCommand( "devgui_cmd \"Frontend/Set CP Safe House/Mobile:2\" \"set scr_frontend_safehouse mobile\"\n" );
		AddDebugCommand( "devgui_cmd \"Frontend/Set CP Safe House/Singapore:3\" \"set scr_frontend_safehouse singapore\"\n" );
		AddDebugCommand( "devgui_cmd \"Frontend/Set CP Safe House/Default:4\" \"set scr_frontend_safehouse default\"\n" );
	#/
	
	level thread zm_frontend_zombie_logic();
	level thread zm_frontend_zm_bgb_chance::zm_frontend_bgb_slots_logic();
	
	level thread set_current_safehouse_on_client();
}

function set_current_safehouse_on_client()
{
	wait .05;
	
	n_safehouse = 1;
	
	if ( isdefined( world ) && isdefined( world.next_map ) )
	{
		str_safehouse = util::get_next_safehouse( world.next_map );
		
		switch ( str_safehouse )
		{
			case "cp_sh_cairo":
				
				n_safehouse = 1;
				break;
				
			case "cp_sh_mobile":
				
				n_safehouse = 2;
				break;
				
			case "cp_sh_singapore":
				
				n_safehouse = 3;
				break;
		}
	}
		
	level clientfield::set( "safehouse", n_safehouse );
	
	if ( world.is_first_time_flow !== false )
	{
		world.cp_bunk_anim_type = 0;
		level clientfield::set( "first_time_flow", 1 );
		
		/#
			PrintTopRightln( "first time flow active - server", ( 1, 1, 1 ) );
		#/
	}
	else
	{
		if ( math::cointoss() ) // Bed or desk - read this in the safehouse to match animation there
		{
			world.cp_bunk_anim_type = 0;
			
			/#
				PrintTopRightln( "bed - server", ( 1, 1, 1 ) );
			#/
		}
		else
		{
			world.cp_bunk_anim_type = 1;
			
			/#
				PrintTopRightln( "desk - server", ( 1, 1, 1 ) );
			#/
		}

		level clientfield::set( "cp_bunk_anim_type", world.cp_bunk_anim_type );
	}
}

function zm_frontend_zombie_logic()
{
	const N_MAX_ZOMBIES = 20;
		
	//wait a little bit before ramping up
	wait 5;
	
	a_sp_zombie = GetEntArray( "sp_zombie_frontend", "targetname" );
	
	while( true )
	{
		a_sp_zombie = array::randomize( a_sp_zombie );
		foreach( sp_zombie in a_sp_zombie )
		{
			//fail safe and also making sure there isn't a ton of zombies
			while( GetAICount() >= N_MAX_ZOMBIES )
			{
				wait 1;
			}
			
			ai_zombie = sp_zombie SpawnFromSpawner();
			if( isdefined( ai_zombie ) )
			{
				ai_zombie SetAvoidanceMask( "avoid all" );
				ai_zombie PushActors( false );
				ai_zombie clientfield::set("zombie_has_eyes", 1);
				ai_zombie.delete_on_path_end = true;
				sp_zombie.count++;
			}
			
			wait RandomFloatRange( 3.0, 8.0 );
		}
	}
}
