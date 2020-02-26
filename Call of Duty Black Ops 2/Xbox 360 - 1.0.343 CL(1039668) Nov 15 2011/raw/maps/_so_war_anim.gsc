#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_so_code;
#include maps\_specialops;
#include maps\_hud_util;
#include maps\_scene;
#include maps\_anim;

#using_animtree ("generic_human");

// ======================================================================
//	ANIM INITS
// ======================================================================
main()
{
	level.scr_animtree[ "player_hands_contextual_melee" ] 	= #animtree;
	level.scr_model[ "player_hands_contextual_melee" ] 		= level.player_interactive_model;
}



// self = player
spawn_player_hands(align_ent, info)
{
	start_org = undefined;
	start_ang = undefined;
//	start_org = GetStartOrigin(align_ent.origin, align_ent.angles, info["player"] );
//	start_ang = GetStartAngles(align_ent.origin, align_ent.angles, info["player"] );

	if(!isDefined(start_org))
		start_org = self.origin;
	if(!isDefined(start_ang))
		start_ang = self.angles;
		
	self.player_hands = spawn_anim_model( "player_hands_contextual_melee", start_org, start_ang );
	self.player_hands Hide();
}

/////////////////////////////////////////////////////////////////////////////////////////////////
war_anim_play_cleanup(endons,listener)
{
	self endon("death");
	listener endon( "war_anim_play_cleanup" );
	
	listener waittill(endons);
	
	if (isDefined(self.player_hands))
	{
		self Unlink();
		self anim_stopAnimScripted();
		self.player_hands Delete();
		self.player_hands = undefined;
		enable_weapon();
	}
	else if( isAI( self ) )
	{
		self Unlink();
		self anim_stopAnimScripted();
	}
	
	// kill off all other waiting threads
	listener notify( "war_anim_play_cleanup" );
}

war_anim_play(name, looping, endons, listener)
{
	self endon("death");
	
	if (!isDefined(listener))
		listener = level;
		
	if (isarray(endons) )
	{
		foreach (note in endons)
		{
			listener endon(note);
			self thread war_anim_play_cleanup(note, listener);
		}
	}
	else
	{
		listener endon(endons);
		self thread war_anim_play_cleanup(endons,listener);
	}
	
	if (isPlayer(self))
	{
		if (looping)
		{
			while(1)
			{
				self animate_player_hands_capture(level.scr_anim[self.animname][name]);
			}
		}
		else
		{
			self animate_player_hands_capture(level.scr_anim[self.animname][name]);
		}
	}
	else
	{
		if (looping)
		{
			while(1)
			{
				self.animname = "war_ai";
				self anim_single(self, name);
			}
		}
		else
		{
			self.animname = "war_ai";
			self anim_single(self, name);
		}
	}
}

disable_weapon()
{
	self HideViewModel();
	self DisableWeapons();
}

enable_weapon()
{
	self ShowViewModel();
	self EnableWeapons();
	self AllowMelee(true);
}

animate_player_hands_capture( name )
{
	const TWEEN_TIME = 0.3;
	
	disable_weapon();
	
	self spawn_player_hands();
	self.player_hands SetAnim( name, 1, 0, 0 );

	self StartCameraTween( TWEEN_TIME );
	self PlayerLinkToAbsolute(self.player_hands, "tag_player");

	wait( TWEEN_TIME / 2);
	
	self.player_hands AnimScripted( "hacking_anim", self.origin, self.angles, name );
	
	wait (.05);
	self.player_hands Show();

	self.player_hands animscripts\shared::DoNoteTracks( "hacking_anim" );
	
	self.player_hands Delete();
	self.player_hands = undefined;
	
	enable_weapon();
}
