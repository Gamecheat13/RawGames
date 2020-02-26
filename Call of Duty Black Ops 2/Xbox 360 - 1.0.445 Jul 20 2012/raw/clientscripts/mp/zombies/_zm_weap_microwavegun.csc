#include clientscripts\mp\_utility; 
#include clientscripts\mp\_fx;
#include clientscripts\mp\zombies\_zm_utility;

init()
{
	if ( GetDvar( "createfx" ) == "on" )
	{
		return;
	}
	
	if ( !clientscripts\mp\zombies\_zm_weapons::is_weapon_included( "microwavegundw_zm" ) )
	{
		return;
	}

	// turns on the blood_eyes
	level._ZOMBIE_ACTOR_FLAG_MICROWAVEGUN_INITIAL_HIT_RESPONSE = 6;
	register_clientflag_callback( "actor", level._ZOMBIE_ACTOR_FLAG_MICROWAVEGUN_INITIAL_HIT_RESPONSE, ::microwavegun_zombie_initial_hit_response );
	// set: start bloat shader, clear or (set with no initial response): death mist 
	level._ZOMBIE_ACTOR_FLAG_MICROWAVEGUN_EXPAND_RESPONSE = 9;
	register_clientflag_callback( "actor", level._ZOMBIE_ACTOR_FLAG_MICROWAVEGUN_EXPAND_RESPONSE, ::microwavegun_zombie_expand_response );

	level._effect["microwavegun_sizzle_blood_eyes"]			= loadfx( "weapon/microwavegun/fx_sizzle_blood_eyes" );
	level._effect["microwavegun_sizzle_death_mist"]			= loadfx( "weapon/microwavegun/fx_sizzle_mist" );
	level._effect["microwavegun_sizzle_death_mist_low_g"]	= loadfx( "weapon/microwavegun/fx_sizzle_mist_low_g" );

	level thread player_init();
}


player_init()
{
	waitforclient( 0 );

	players = GetLocalPlayers();
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
	}
}


microwavegun_create_hit_response_fx( localClientNum, tag, effect )
{
	if ( !isdefined( self._microwavegun_hit_response_fx[localClientNum][tag] ) )
	{
		self._microwavegun_hit_response_fx[localClientNum][tag] = PlayFxOnTag( localClientNum, effect, self, tag );
	}
}

	
microwavegun_delete_hit_response_fx( localClientNum, tag )
{
	if ( isdefined( self._microwavegun_hit_response_fx[localClientNum][tag] ) )
	{
		DeleteFx( localClientNum, self._microwavegun_hit_response_fx[localClientNum][tag], false );
		self._microwavegun_hit_response_fx[localClientNum][tag] = undefined;
	}
}


microwavegun_bloat( localClientNum )
{
	self endon( "entityshutdown" );

	durationMsec = 2500;
	tag_pos = self gettagorigin( "J_SpineLower" );
	bloat_max_fraction = 1.0;
	if ( !isdefined( tag_pos ) )
	{
		// must be a dog, use a shorter duration
		durationMsec = 1000;
	}
	
	self mapshaderconstant( localClientNum, 0, "scriptVector3" );

	begin_time = GetRealTime();
	while( 1 )
	{
		age = GetRealTime() - begin_time;
		bloat_fraction = age / durationMsec;

		if ( bloat_fraction > bloat_max_fraction )
			bloat_fraction = bloat_max_fraction;

		if ( !IsDefined( self ) )
		{
			return;
		}

		self setshaderconstant( localClientNum, 0, (bloat_fraction * 4.0), 0, 0, 0 );

		if ( bloat_fraction >= bloat_max_fraction )
			break;

		waitrealtime( 0.05 );
	}

}


microwavegun_zombie_initial_hit_response( localClientNum, set, newEnt )
{
	if ( isdefined( self.microwavegun_zombie_hit_response ) )
	{
		self [[ self.microwavegun_zombie_hit_response ]]( localClientNum, set, newEnt );
		return;
	}

	if ( localClientNum != 0 )
	{
		return;
	}

	if ( !isdefined( self._microwavegun_hit_response_fx ) )
	{
		self._microwavegun_hit_response_fx = [];
	}

	self.microwavegun_initial_hit_response = true;

	players = GetLocalPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( !isdefined( self._microwavegun_hit_response_fx[i] ) )
		{
			self._microwavegun_hit_response_fx[i] = [];
		}

		if ( set )
		{
			self microwavegun_create_hit_response_fx( i, "J_Eyeball_LE", level._effect["microwavegun_sizzle_blood_eyes"] );
			playsound( 0, "wpn_mgun_impact_zombie", self.origin );
		}
	}
}


microwavegun_zombie_expand_response( localClientNum, set, newEnt )
{
	if ( isdefined( self.microwavegun_zombie_hit_response ) )
	{
		self [[ self.microwavegun_zombie_hit_response ]]( localClientNum, set, newEnt );
		return;
	}

	if ( localClientNum != 0 )
	{
		return;
	}

	if ( !isdefined( self._microwavegun_hit_response_fx ) )
	{
		self._microwavegun_hit_response_fx = [];
	}

	initial_hit_occurred = isdefined( self.microwavegun_initial_hit_response ) && self.microwavegun_initial_hit_response;

	players = GetLocalPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( !isdefined( self._microwavegun_hit_response_fx[i] ) )
		{
			self._microwavegun_hit_response_fx[i] = [];
		}

		if ( set && initial_hit_occurred )
		{
			playsound( 0, "wpn_mgun_impact_zombie", self.origin );
			self thread microwavegun_bloat( i );
		}
		else
		{
			if ( initial_hit_occurred )
			{
				self microwavegun_delete_hit_response_fx( i, "J_Eyeball_LE" );
			}

			tag_pos = self gettagorigin( "J_SpineLower" );
			if ( !isdefined( tag_pos ) )
			{
				tag_pos = self gettagorigin( "J_Spine1" );
			}

			fx = level._effect["microwavegun_sizzle_death_mist"];
			if ( isdefined( self.in_low_g ) && self.in_low_g )
			{
				fx = level._effect["microwavegun_sizzle_death_mist_low_g"];
			}
			playfx( i, fx, tag_pos );
			playsound( 0, "wpn_mgun_explode_zombie", self.origin );
		}
	}
}

