#include common_scripts\utility;
#include animscripts\anims;
#include maps\_utility;

#using_animtree ("bigdog");

main()
{
}

end_script()
{
}

melee_init()
{
	level._CLAW_MELEE_DIST 			= 70;
	level._CLAW_MELEE_DIST_SQ 		= level._CLAW_MELEE_DIST * level._CLAW_MELEE_DIST;

	level._CLAW_MELEE_LERP_TIME 	= .3;
	
	level.scr_animtree[ "player_hands_contextual_melee" ] 	= #animtree;
	level.scr_model[ "player_hands_contextual_melee" ] 		= level.player_interactive_model;
	
	self thread melee_thread();
}

melee_thread()
{
	self endon("death");
	
	self notify("_contextual_melee_thread");
	self endon("_contextual_melee_thread");
	self endon("stop_contextual_melee");

	player = waittill_melee();

	if (IsAlive(self) && IsDefined(player))
	{
		self thread do_melee(player);
	}
}

waittill_melee()
{
	while (true)
	{
		player = undefined;
		while (!IsDefined(player))
		{
			wait .05;

			if (!IsAlive(self))
			{
				return;
			}

			players = get_players();
			for (i = 0; i < players.size; i++)
			{
				if (players[i] player_can_melee(self))
				{
					player = players[i];
					break;
				}
			}
		}

		if (player player_interaction(self))
		{
			player notify("melee_attack", self);
			self notify("melee_victim", player);

			return player;
		}
	}
}

//self = player
player_can_melee(guy)
{
	dist = DistanceSquared(guy.origin, self.origin);
	if (dist < level._CLAW_MELEE_DIST_SQ)
	{
		looking_at = is_player_looking_at(guy GetTagOrigin("tag_body_animate"), .7, false);
		
		if( isdefined(guy._melee_ignore_angle_override) )
		{
			return looking_at;
		}	
				
		return looking_at;
	}

	return false;
}

player_interaction(guy)
{
	self AllowMelee(false);
	
	cancled = false;
	
	while (!self MeleeButtonPressed() && !cancled )
	{
		if (!self player_can_melee(guy) || !IsAlive(guy))
		{
			// This player is no longer in position to start the melee
			// Cancel everything and restart the process

			self enable_weapon();
			cancled = true;
		}
		else
		{
			self notify("melee_in_position");
		}

		wait(0.05);
	}

	if (!cancled)
	{
		self disable_weapon();
	}

	return !cancled;
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

// self = claw
get_info(player)
{
	info = [];
	
	yaw = self animscripts\utility::GetYawToSpot( player.origin );
	
	if( yaw >= 135 || yaw <= -135 )
	{
		info["player"] 	= %int_contextual_melee_claw_back;
		info["ai"] 		= %ai_contextual_melee_claw_back;
	}
	else if( yaw > 45 && yaw < 135 )
	{
		info["player"] 	= %int_contextual_melee_claw_right;
		info["ai"] 		= %ai_contextual_melee_claw_right;
	}
	else if( yaw < -45 && yaw > -135 )
	{
		info["player"] 	= %int_contextual_melee_claw_left;
		info["ai"] 		= %ai_contextual_melee_claw_left;
	}
	else
	{
		info["player"] 	= %int_contextual_melee_claw_front;
		info["ai"] 		= %ai_contextual_melee_claw_front;
	}
	
	return info;
}

do_melee(player)
{
	info = self get_info(player);
		
	player FreezeControls(true);
	player notify( "do_contextual_melee" );
	self notify( "do_contextual_melee" );
	self stop_everything();

	self._contextual_melee_align_obj = self;// get_alignment_object();
	
	player spawn_player_hands(self._contextual_melee_align_obj, info);

	player thread animate_player_hands(self, info);
	self waittill("contextual_melee_start_anim");

	self notify("stop_contextual_melee_idle");
	self AnimScripted("contextual_melee_anim", self._contextual_melee_align_obj.origin, self._contextual_melee_align_obj.angles, info["ai"]);

	self thread contextual_melee_watch_for_anim_end();

	self waittill_either("finish_contextual_melee", "death");

	player thread end_contextual_melee(self);

	self notify("melee_done");
	player notify("melee_done");

	player.player_hands Delete();
	
	self.a.noDeathAnim = true;
	self.allowdeath = true;
	self DoDamage( self.health + 1, self.origin, player, -1, "melee" );
}

end_contextual_melee(victim)
{
	level waittill_any_ents(victim, "death", self, "melee_done");

	self Unlink();

	self notify( "contextual_melee_complete" );
	//SOUND Shawn J
	victim notify( "claw_cntxt" );	

	self FreezeControls(false);
	self enable_weapon();
}

contextual_melee_watch_for_anim_end()
{
	self animscripts\shared::DoNoteTracks("contextual_melee_anim");
	self notify("finish_contextual_melee");
}

stop_everything()
{
	// keep still
	self.ignoreall = true;
	self.goalradius = 0;
	self SetGoalPos(self.origin);

	self Unlink();
	self anim_stopAnimScripted();
	
	// stop turret
	self.turret maps\_turret::disable_turret( 0 );
}

// self = player
spawn_player_hands(align_ent, info)
{
	start_org = GetStartOrigin(align_ent.origin, align_ent.angles, info["player"] );
	start_ang = GetStartAngles(align_ent.origin, align_ent.angles, info["player"] );
	self.player_hands = spawn_anim_model( "player_hands_contextual_melee", start_org, start_ang );
	
	self.player_hands Hide();
}

animate_player_hands(victim, info)
{
	//-- Animate first frame to position player tag via animat ion
	self.player_hands SetAnim( info["player"], 1, 0, 0 );

	self StartCameraTween(level._CLAW_MELEE_LERP_TIME);
	self PlayerLinkToAbsolute(self.player_hands, "tag_player");

	wait (level._CONTEXTUAL_MELEE_LERP_TIME / 2);
	
	victim notify("contextual_melee_start_anim");

	self.player_hands AnimScripted("contextual_melee_anim", victim._contextual_melee_align_obj.origin, victim._contextual_melee_align_obj.angles, info["player"]);

	wait (.05);
	self.player_hands Show();

	/#
		recordEnt( self.player_hands );
	#/

	self.player_hands animscripts\shared::DoNoteTracks("contextual_melee_anim");
}