// _sticky_grenade.csc
// Sets up clientside behavior for the sticky grenade
#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

main()
{
	level._effect["grenade_enemy_light"] = loadfx( "weapon/crossbow/fx_trail_crossbow_blink_red_os" );
	level._effect["grenade_friendly_light"] = loadfx( "weapon/crossbow/fx_trail_crossbow_blink_grn_os" );
	//SetDvarFloat("snd_crossbow_bolt_timer_interval", 0.4); 
	//SetDvarFloat("snd_crossbow_bolt_timer_divisor", 1.4); 

	PrintLn( "grenade_enemy_light :" + level._effect["grenade_enemy_light"] );
	PrintLn( "grenade_friendly_light :" + level._effect["grenade_friendly_light"] );
}


spawned( localClientNum, play_sound, override_enemy ) // self == the grenade
{
	self endon( "entityshutdown" );

	if ( isdefined( override_enemy ) )
	{
		enemy = override_enemy;
	}
	else
	{
		enemy = !friendNotFoe( localClientNum );
	}

	if ( enemy )
	{
		if( play_sound )
		{
			self thread loop_local_sound( localClientNum, "wpn_semtex_alert", 0.3, level._effect["grenade_enemy_light"] );
		}
		else
		{
			PlayFXOnTag( localClientNum, level._effect["grenade_enemy_light"], self, "tag_fx" );
		}
	}
	else
	{
		if( play_sound )
		{
			//PrintLn("play sound");
			self thread loop_local_sound( localClientNum, "wpn_semtex_alert", 0.3, level._effect["grenade_friendly_light"] );
		}
		else
		{
			PlayFXOnTag( localClientNum, level._effect["grenade_friendly_light"], self, "tag_fx" );
		}
	}
}

loop_local_sound( localClientNum, alias, interval, fx ) // self == the grenade
{
	self endon( "entityshutdown" );

	while(1)
	{
		self PlaySound( localClientNum, alias );
		PlayFXOnTag( localClientNum, fx, self, "tag_fx" );
		
		owner = self GetOwner( localClientNum );
		self.stuckToPlayer = self GetParentEntity();
		localPlayer = GetLocalPlayer( localClientNum );
		if( IsDefined( self.stuckToPlayer ) && self.stuckToPlayer IsPlayer() && IsDefined( owner.team ) )
		{
			if( IsDefined( self.stuckToPlayer.team ) )
			{
				if( self.stuckToPlayer.team == "free" || self.stuckToPlayer.team != owner.team )
				{
					//PrintLn( "stuck to player on team: " + self.stuckToPlayer.team );
					self.stuckToPlayer PlayRumbleOnEntity( localClientNum, "buzz_high" );
					if ( ( localPlayer == self.stuckToPlayer ) && !( localPlayer isPlayerViewLinkedToEntity( localClientNum ) ) )
					{
						if ( IsSplitscreen() )
							AnimateUI( localClientNum, "sticky_grenade_overlay"+localClientNum, "overlay", "pulse", 0 );
						else
							AnimateUI( localClientNum, "sticky_grenade_overlay", "overlay", "pulse", 0 );
						if( !IsSplitscreen() && GetDvarint( "ui_hud_hardcore" ) == 0 )
							AnimateUI( localClientNum, "stuck", "sticky_grenade", "pulse", 0 );
					}
				}
			}
		}

		serverWait( localClientNum, interval, 0.01 );
		interval = (interval / 1.2);

		if (interval < .08)
		{
			interval = .08;
		}	
	}
}
