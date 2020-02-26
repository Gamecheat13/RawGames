/*
 * Created by ScriptDevelop.
 * User: bbarnes
 * Date: 5/9/2012
 * Time: 4:32 PM
 *
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
 
#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_objectives;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

////////////////////////////////
//                            //
//       PLAYER CAMO SUIT	  //
//                            //
////////////////////////////////

// call before _load::main
precache()
{
	PrecacheString( &"hud_update_visor_text" );	
	PrecacheString( &"SCRIPT_HINT_CAMO_SUIT_EQUIPED" );	
	PrecacheString( &"SCRIPT_HINT_CAMO_SUIT_ACTIVATE" );		
}

autoexec _camo_suit_perk_init()
{
	setup_anim();
	
	flag_init( "lock_breaker_perk_used" );
	
	level.OBJ_LOCKBREAKER = register_objective( "" );
	
	//create the use trigger for the perk
	t_use = GetEnt( "use_lockbreaker", "targetname" );
	t_use SetHintString( &"SCRIPT_HOLD_TO_USE" );
	t_use SetCursorHint( "HINT_NOICON" );
	t_use trigger_off();
	
	flag_wait( "level.player" );
	
	level.player waittill_player_has_lock_breaker_perk();
	
	t_use trigger_on();
	set_objective( level.OBJ_LOCKBREAKER, t_use, "interact" );
	
	t_use waittill( "trigger", player );
	
	//special VO for Monsoon
	if ( level.script == "monsoon" )
	{
		level thread monsoon_vo();
	}
	
	set_objective( level.OBJ_LOCKBREAKER, t_use, "remove" );
	
	flag_set( "lock_breaker_perk_used" );
	
	run_scene( "lockbreaker_perk" );

	player DisableWeapons();
	
	screen_fade_out( 1 );
	
	wait 1;
	
	player thread player_camo_suit();
	
	screen_fade_in( 1 );
	
	player EnableWeapons();
}

setup_anim()
{
	if ( level.script == "yemen" )
	{
		add_scene( "lockbreaker_perk", "lockbreaker_case" );
		add_player_anim( "player_body", %player::int_specialty_yemen_lockbreaker, true );
		add_prop_anim( "lockbreaker_dongle", %animated_props::o_specialty_yemen_lockbreaker_dongle, "t6_wpn_hacking_dongle_prop", true );
		add_prop_anim( "lockbreaker_camosuit", %animated_props::o_specialty_yemen_lockbreaker_camosuit, "p6_intruder_perk_pickup", true );
		add_prop_anim( "lockbreaker_case", %animated_props::o_specialty_yemen_lockbreaker_crate );
	}
	else if ( level.script == "monsoon" )
	{
		add_scene( "lockbreaker_perk", "lockbreaker_case" );
		add_player_anim( "player_body", %player::int_specialty_monsoon_lockbreaker, true );
		add_prop_anim( "lockbreaker_dongle", %animated_props::o_specialty_monsoon_lockbreaker_dongle, "t6_wpn_hacking_dongle_prop", true );
		add_prop_anim( "lockbreaker_camosuit", %animated_props::o_specialty_monsoon_lockbreaker_camosuit, "p6_intruder_perk_pickup", true );
		add_prop_anim( "lockbreaker_case", %animated_props::o_specialty_monsoon_lockbreaker_crate );
	
	}
	
	precache_assets();
}

//self is the player
#define CAMO_VISIBLE_DIST 400
#define CAMO_ACTIVE_MULT 2
#define CAMO_ATTACKER_ACC 0.5
#define CAMO_TRANSITION_TIME 1
player_camo_suit()
{
	self endon( "death" );
	
	self ent_flag_init( "camo_suit_on" );
	self notify( "camo_suit_equipped" );
	self thread _watch_toggle_suit();
	
	n_old_maxvisibledist = self.maxvisibledist;
	n_old_attackeraccuracy = self.attackerAccuracy;
	
	LUINotifyEvent( &"hud_update_visor_text", 1, istring( "SCRIPT_HINT_CAMO_SUIT_EQUIPED" ) );
	LUINotifyEvent( &"hud_update_visor_text", 1, istring( "SCRIPT_HINT_CAMO_SUIT_ACTIVATE" ) );
	//screen_message_create( &"SCRIPT_HINT_CAMO_SUIT_EQUIPED", &"SCRIPT_HINT_CAMO_SUIT_ACTIVATE" );
	waittill_notify_or_timeout( "camo_suit_on", 5 );
	screen_message_delete();
		
	while( 1 )
	{
		self ent_flag_wait( "camo_suit_on" );
		
		/#
			IPrintLn( "camo suit on" );
		#/
		
		//SOUND - Shawn J
		//iprintlnbold ("camo_suit_on");
		camo_suit_snd_ent = spawn( "script_origin", (0,0,0) );
		level.player playsound ("fly_camo_suit_plr_on");
		camo_suit_snd_ent playloopsound ("fly_camo_suit_plr_loop", 1);
			
		self.maxvisibledist = CAMO_VISIBLE_DIST;
		self.attackerAccuracy = CAMO_ATTACKER_ACC;
		self VisionSetNaked( "claw_base", CAMO_TRANSITION_TIME );
		
		//set camo player arms
		self SetViewModel( level.player_camo_viewmodel );

		while( ent_flag( "camo_suit_on" ) )
		{
			if( self IsFiring() || ( self.health < self.maxhealth ) )
			{
				self.maxvisibledist = CAMO_VISIBLE_DIST * CAMO_ACTIVE_MULT;
			}
			else
			{
				self.maxvisibledist = CAMO_VISIBLE_DIST;
			}
			
			wait 0.05;
		}
		
			//SOUND - Shawn J
			//iprintlnbold ("camo_suit_off");
			self playsound ("fly_camo_suit_plr_off");
			camo_suit_snd_ent stoploopsound (.5);
		
			camo_suit_snd_ent delete();
		/#
			IPrintLn( "camo suit off" );
		#/
		
		self.maxvisibledist = n_old_maxvisibledist;
		self.attackerAccuracy = n_old_attackeraccuracy;
		self VisionSetNaked( "default", CAMO_TRANSITION_TIME );
		self SetViewModel( level.player_viewmodel );
	}

}

_watch_toggle_suit()
{
	self endon( "death" );
	
	while( 1 )
	{
		while( !self ActionSlotTwoButtonPressed() )
		{
			wait 0.05;
		}
		
		self ent_flag_toggle( "camo_suit_on" );
		wait CAMO_TRANSITION_TIME;
	}
}

monsoon_vo()
{
	level.crosby say_dialog( "cros_what_are_you_doing_0", 0.5 );
	wait 0.5;
	level.player say_dialog( "sect_trying_to_keep_a_low_0" );	
}