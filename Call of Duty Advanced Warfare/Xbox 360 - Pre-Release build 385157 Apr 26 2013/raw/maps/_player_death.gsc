#include common_scripts\utility;
#include maps\_utility;

main()
{
	set_deadquote( "" );

	level.player thread player_throwgrenade_timer();
	level.player waittill( "death", attacker, cause, weaponName );

	special_death_hint( attacker, cause, weaponName );
}

player_throwgrenade_timer()
{
	self endon( "death" );
	self.lastgrenadetime = 0;

	while ( 1 )
	{
		while ( !self IsThrowingGrenade() )
			wait .05;
		self.lastgrenadetime = GetTime();
		while ( self IsThrowingGrenade() )
			wait .05;
	}
}

special_death_hint( attacker, cause, weaponName )
{
	// Special Ops requires a different style of tracking and custom language in the hints.
	// Safer to branch cleanly and track separately from SP.
	if ( is_specialop() )
		return;

	if ( level.missionfailed )
	{
		return;
	}

	set_deadquote( "" );

	if ( cause != "MOD_GRENADE" && cause != "MOD_GRENADE_SPLASH" && cause != "MOD_SUICIDE" && cause != "MOD_EXPLOSIVE" )
		return;

	if ( level.gameskill >= 2 )
	{
		// less death hinting on hard / fu
		if ( !maps\_load::map_is_early_in_the_game() )
			return;
	}

	switch( cause )
	{
	    case "MOD_SUICIDE":
			if ( ( level.player.lastgrenadetime - GetTime() ) > 3.5 * 1000 )
				return;// magic number copied from fraggrenade asset.
			// You died holding a grenade for too long.
			// Holding ^3[{+frag}]^7 allows you to cook off live grenades.
			thread grenade_death_hint( &"SCRIPT_GRENADE_SUICIDE_LINE1", &"SCRIPT_GRENADE_SUICIDE_LINE2" );
			break;

		case "MOD_EXPLOSIVE":
			if ( level.player destructible_death( attacker ) )
				return;

			if ( level.player vehicle_death( attacker ) )
				return;
			
			if ( level.player exploding_barrel_death( attacker ) )
				return;
			break;

		case "MOD_GRENADE":
		case "MOD_GRENADE_SPLASH":
			if ( IsDefined( weaponName ) && !IsWeaponDetonationTimed( weaponName ) )
			{
				return;
			}
	
			// Would putting the content of the string here be so hard?
			set_deadquote( "@SCRIPT_GRENADE_DEATH" );
			thread grenade_death_indicator_hud();
			break;

		default:
			break;
	}
}

vehicle_death( attacker )
{
	if ( !isdefined( attacker ) )
		return false;
	
	if ( attacker.code_classname != "script_vehicle" )
		return false;
	
	level notify( "new_quote_string" );

	// You were killed by an exploding vehicle. Vehicles on fire are likely to explode.
	set_deadquote( "@SCRIPT_EXPLODING_VEHICLE_DEATH" );
	thread set_death_icon( "hud_burningcaricon", 96, 96 );
	
	return true;
}

destructible_death( attacker )
{
	if ( !isdefined( attacker ) )
		return false;

	if ( !isdefined( attacker.destructible_type ) )
		return false;

	level notify( "new_quote_string" );

	if ( IsSubStr( attacker.destructible_type, "vehicle" ) )
	{
		// You were killed by an exploding vehicle. Vehicles on fire are likely to explode.
		set_deadquote( "@SCRIPT_EXPLODING_VEHICLE_DEATH" );
		thread set_death_icon( "hud_burningcaricon", 96, 96 );
	}
	else
	{
		// You were killed by an explosion.\nSome burning objects can explode.
		set_deadquote( "@SCRIPT_EXPLODING_DESTRUCTIBLE_DEATH" );
		thread set_death_icon( "hud_destructibledeathicon", 96, 96 );
	}

	return true;
}

exploding_barrel_death( attacker )
{
	// check if the death was caused by a barrel
	// have to check time and location against the last explosion because the attacker isn't the
	// barrel because the ent that damaged the barrel is passed through as the attacker instead
	if ( IsDefined( level.lastExplodingBarrel ) )
	{
		// killed the same frame a barrel exploded
		if ( GetTime() != level.lastExplodingBarrel[ "time" ] )
			return false;

		// within the blast radius of the barrel that exploded
		d = Distance( self.origin, level.lastExplodingBarrel[ "origin" ] );
		if ( d > level.lastExplodingBarrel[ "radius" ] )
			return false;

		// must have been killed by that barrel
		level notify( "new_quote_string" );
		// You were killed by an exploding barrel. Red barrels will explode when shot.
		set_deadquote( "@SCRIPT_EXPLODING_BARREL_DEATH" );
		thread set_death_icon( "hud_burningbarrelicon", 64, 64 );
		return true;
	}
	return false;
}

// Quote Section ------------------------------------------
set_deadquote( quote )
{
	SetDvar( "ui_deadquote", quote );
}

//setDeadQuote()
//{
//	level endon( "mine death" );
//
//	// kill any deadquotes already running
//	level notify( "new_quote_string" );
//	level endon( "new_quote_string" );
//
//	// player can be dead if the player died at the same point that setDeadQuote was called from another script
//	if ( isalive( level.player ) )
//		level.player waittill( "death" );
//	
//	if ( !level.missionfailed )
//	{
//		deadQuoteSize = ( Int( TableLookup( "sp/deathQuoteTable.csv", 1, "size", 0 ) ) );
//		deadQuoteIndex = randomInt( deadQuoteSize );
//
//		// This is used for testing
//		if ( GetDvar( "cycle_deathquotes" ) != "" )
//		{
//			if ( GetDvar( "ui_deadquote_index" ) == "" )
//				SetDvar( "ui_deadquote_index", "0" );
//
//			deadQuoteIndex = GetDvarInt( "ui_deadquote_index" );
//
//			SetDvar( "ui_deadquote", lookupDeathQuote( deadQuoteIndex ) );
//
//			deadQuoteIndex++;
//			if ( deadQuoteIndex > (deadQuoteSize - 1) )
//				deadQuoteIndex = 0;
//			
//			SetDvar( "ui_deadquote_index", deadQuoteIndex );
//		}
//		else
//		{
//			SetDvar( "ui_deadquote", lookupDeathQuote( deadQuoteIndex ) );
//		}
//	}
//}

deadquote_recently_used( deadquote )
{
	if ( deadquote == getdvar( "ui_deadquote_v1" ) )
		return true;
	
	if ( deadquote == getdvar( "ui_deadquote_v2" ) )
		return true;
		
	if ( deadquote == getdvar( "ui_deadquote_v3" ) )
		return true;

	return false;
}

lookupDeathQuote( index )
{
	// since Code handles "ui_deadquote" with and without "@" in front of the string, we should always have it
	quote = TableLookup( "sp/deathQuoteTable.csv", 0, index, 1 );
	
	if ( tolower( quote[0] ) != tolower( "@" ) )
		quote = "@" + quote;
	
	return quote;
}

grenade_death_hint( textLine1, textLine2 )
{
	level.player.failingMission = true;

	set_deadquote( "" );

	wait( 1.5 );

	fontElem = NewHudElem();
	fontElem.elemType = "font";
	fontElem.font = "default";
	fontElem.fontscale = 1.5;
	fontElem.x = 0;
	fontElem.y = -30;
	fontElem.alignX = "center";
	fontElem.alignY = "middle";
	fontElem.horzAlign = "center";
	fontElem.vertAlign = "middle";
	fontElem SetText( textLine1 );
	fontElem.foreground = true;
	fontElem.alpha = 0;
	fontElem FadeOverTime( 1 );
	fontElem.alpha = 1;

	if ( IsDefined( textLine2 ) )
	{
		fontElem = NewHudElem();
		fontElem.elemType = "font";
		fontElem.font = "default";
		fontElem.fontscale = 1.5;
		fontElem.x = 0;
		fontElem.y = -25 + level.fontHeight * fontElem.fontscale;
		fontElem.alignX = "center";
		fontElem.alignY = "middle";
		fontElem.horzAlign = "center";
		fontElem.vertAlign = "middle";
		fontElem SetText( textLine2 );
		fontElem.foreground = true;
		fontElem.alpha = 0;
		fontElem FadeOverTime( 1 );
		fontElem.alpha = 1;
	}
}

grenade_death_indicator_hud()
{
	wait( 1.5 );
	overlay = NewHudElem();
	overlay.x = 0;
	overlay.y = 68;
	overlay SetShader( "hud_grenadeicon", 50, 50 );
	overlay.alignX = "center";
	overlay.alignY = "middle";
	overlay.horzAlign = "center";
	overlay.vertAlign = "middle";
	overlay.foreground = true;
	overlay.alpha = 0;
	overlay FadeOverTime( 1 );
	overlay.alpha = 1;

	overlay = NewHudElem();
	overlay.x = 0;
	overlay.y = 25;
	overlay SetShader( "hud_grenadepointer", 50, 25 );
	overlay.alignX = "center";
	overlay.alignY = "middle";
	overlay.horzAlign = "center";
	overlay.vertAlign = "middle";
	overlay.foreground = true;
	overlay.alpha = 0;
	overlay FadeOverTime( 1 );
	overlay.alpha = 1;
}

set_death_icon( shader, iWidth, iHeight, fDelay )
{
	if ( !isdefined( fDelay ) )
		fDelay = 1.5;
	wait fDelay;
	overlay = NewHudElem();
	overlay.x = 0;
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
}