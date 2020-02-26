#include maps\mp\_utility;

init()
{
	level.cac_attributes = [];
	level.cac_attributes[ "mobility" ] = [];
	level.cac_attributes[ "armor_bullet" ] = [];
	level.cac_attributes[ "armor_explosive" ] = [];
	level.cac_attributes[ "sprint_time_total" ] = [];
	level.cac_attributes[ "sprint_time_cooldown" ] = [];

	level.cac_functions = [];
	level.cac_functions[ "precache" ] = [];
	level.cac_functions[ "set_body_model" ] = [];
	level.cac_functions[ "set_head_model" ] = [];
	level.cac_functions[ "set_hat_model" ] = [];
	level.cac_functions[ "set_specialties" ] = [];
	level.cac_functions[ "get_default_head" ] = [];

	level.cac_assets = [];
}

is_asset_of_type( asset_name, array_type )
{
	if ( !IsDefined( asset_name ) )
	{
		return false;
	}
	
	if ( !IsDefined( level.cac_functions[ array_type ] ) )
	{
		return false;
	}

	keys = GetArrayKeys( level.cac_functions[ array_type ] );

	for ( i = 0; i < keys.size; i++ )
	{
		if ( asset_name == keys[i] )
		{
			return true;
		}
	}

	return false;
}

is_head( asset_name )
{
	return is_asset_of_type( asset_name, "set_head_model" );
}

is_hat( asset_name )
{
	return is_asset_of_type( asset_name, "set_hat_model" );
}

get_mobility_body()
{
	return ( level.cac_attributes[ "mobility" ][ self.cac_body_type ] );
}

get_sprint_duration()
{
	return ( level.cac_attributes[ "sprint_time_total" ][ self.cac_body_type ] );
}

get_sprint_cooldown()
{
	return ( level.cac_attributes[ "sprint_time_cooldown" ][ self.cac_body_type ] );
}

get_mobility_head()
{
	head = self.cac_head_type;

	if ( self.cac_hat_type != "none" )
	{
		head = self.cac_hat_type; // hat model supercedes head model
	}

	return ( level.cac_attributes[ "mobility" ][ head ] );
}

get_armor_bullet_body()
{
	return ( level.cac_attributes[ "armor_bullet" ][ self.cac_body_type ] );
}

get_armor_explosive_body()
{
	return ( level.cac_attributes[ "armor_explosive" ][ self.cac_body_type ] );
}

get_armor_bullet_head()
{
	head = self.cac_head_type;

	if ( self.cac_hat_type != "none" )
	{
		head = self.cac_hat_type; // hat model supercedes head model
	}

	return ( level.cac_attributes[ "armor_bullet" ][ head ] );
}

get_armor_explosive_head()
{
	head = self.cac_head_type;

	if ( self.cac_hat_type != "none" )
	{
		head = self.cac_hat_type; // hat model supercedes head model
	}

	return ( level.cac_attributes[ "armor_explosive" ][ head ] );
}

get_armor_damage( meansofdeath, weapon, hitloc, damage )
{
	armor = 0;
	
	if( isdefined(self.cac_body_type) )
	{
		if ( maps\mp\gametypes\_class::isExplosiveDamage( meansofdeath, weapon ) )
		{
			if ( maps\mp\gametypes\_class::isHeadDamage( hitloc ) )
			{
				armor = self get_armor_explosive_head();
			}
			else
			{
				armor = self get_armor_explosive_body();
			}
		}
		else if( maps\mp\gametypes\_class::isPrimaryDamage( meansofdeath ) )
		{
			if ( maps\mp\gametypes\_class::isHeadDamage( hitloc ) )
			{
				armor = self get_armor_bullet_head();
			}
			else
			{
				armor = self get_armor_bullet_body();
			}
		}
	}

	armor = 1 - armor;
	final_damage = int( damage * armor );

	return ( final_damage );
}

get_default_head()
{
	return ( self [[level.cac_functions[ "get_default_head" ][ self.cac_body_type ]]]() );
}

set_body_model( faction )
{
	assert( IsDefined( faction ) );
	assert( IsDefined( self.cac_body_type ) );
	assert( self.cac_body_type != "armor_null" );
	assert( self.cac_body_type != "weapon_null" );

	if ( !IsDefined( self.cac_body_type ) || self.cac_body_type == "armor_null" || self.cac_body_type == "weapon_null" )
	{
		self.cac_body_type = "standard_mp";
	}
	
	self [[level.cac_functions[ "set_body_model" ][ self.cac_body_type ]]]( faction );
}

set_head_model( faction )
{
	assert( IsDefined( faction ) );
	assert( IsDefined( self.cac_head_type ) );
	assert( self.cac_head_type != "armor_null" );
	assert( self.cac_head_type != "weapon_null" );

	if ( !IsDefined( self.cac_head_type ) || self.cac_head_type == "armor_null" || self.cac_head_type == "weapon_null" )
	{
		self.cac_head_type = "head_standard_mp";
	}
	
	self [[level.cac_functions[ "set_head_model" ][ self.cac_head_type ]]]( faction );
}

set_hat_model( faction )
{
	assert( IsDefined( faction ) );
	assert( IsDefined( self.cac_hat_type ) );
	assert( self.cac_hat_type != "armor_null" );
	assert( self.cac_hat_type != "weapon_null" );

	if ( !IsDefined( self.cac_hat_type ) || self.cac_hat_type == "armor_null" || self.cac_hat_type == "weapon_null" )
	{
		self.cac_hat_type = "none";
	}

	if ( self.cac_hat_type != "none" )
	{
		self [[level.cac_functions[ "set_hat_model" ][ self.cac_hat_type ]]]( faction );
	}
}

set_movement_scale()
{
	self SetMoveSpeedScale( 1 + self get_mobility_body() + self get_mobility_head() );
	self SetSprintDuration( self get_sprint_duration() );
	self SetSprintCooldown( self get_sprint_cooldown() );
}

set_specialties()
{
	self [[level.cac_functions[ "set_specialties" ][ self.cac_body_type ]]]();
	self [[level.cac_functions[ "set_specialties" ][ self.cac_head_type ]]]();

	if ( self.cac_hat_type != "none" )
	{
		self [[level.cac_functions[ "set_specialties" ][ self.cac_hat_type ]]]();
	}

	if ( self HasPerk( "specialty_extraammo" ) )
	{
		weapons = self GetWeaponsListPrimaries();

		for ( i = 0; i < weapons.size; i++ )
		{
			// Do NOT give extra ammo to the weapons specifically called out
			switch ( weapons[i] )
			{
			case "china_lake_mp":
			case "rpg_mp":
			case "strela_mp":
			case "m220_tow_mp_mp":
			case "m72_law_mp":
			case "m202_flash_mp":
			case "minigun_mp":
			case "mp40_mp":
				break;
			default:
				self GiveMaxAmmo( weapons[i] );
			}
		}
	}
}

set_faction_for_team()
{
	assert( IsDefined( game[ self.pers[ "team" ] ] ) );
	assert( IsDefined( game["cac_faction_"+self.pers[ "team" ]] ), "CAC faction is not set for " + self.pers["team"] + " check the teamset" );
	
	self.cac_faction  = game["cac_faction_"+self.pers[ "team" ]];
}

set_player_model()
{
	self DetachAll();
	
	if ( isDefined( level.giveCustomCharacters ) )
	{
		self [[level.giveCustomCharacters]]();
	}
	else
	{
		self set_faction_for_team();
		self set_body_model( self.cac_faction );
		self set_head_model( self.cac_faction );
		self set_hat_model( self.cac_faction );

		self set_movement_scale();

		if ( GetDvarint( "scr_game_perks" ) )
		{
			self set_specialties();
		}
	}
}