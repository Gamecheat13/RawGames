#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	level.tips = [];

	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_ADS";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SPRINT";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_KILLSTREAK";       // PC:2
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SWITCH_WEAPON";    // PC:3
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_NEW_WEAPON";		// PC:4
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_MINIMAP";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_STANCE";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SKULLS";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_GRENADES";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SMG";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_RIFLE";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SHOTGUN";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_MACHINE_GUN";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SNIPER";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_EQUIPMENT";        // PC:14
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_PERKS";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_JUMP";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_THEATER";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SPYPLANE";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_CAREPACKAGE";      // PC:19
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_ATTACHMENT";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_KILLSTREAK_UNLOCK";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_LAUNCHERS";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SPYPLANE2";        // PC:23
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_TV_MISSILE";       // PC:24
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_MELEE";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_CONTROLS";			// PC:26
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_LIGHTWEIGHT";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_STEADYAIM";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_PERKS2";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_MARATHON";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_GRENADE_COOK";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_GRENADE_SMOKE";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_PRONE";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_OPTIONS";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_INSIDE";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_ASSIST";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_XP_TIP";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_FOOTSTEPS";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SECOND_CHANCE";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SECONDARY_WEAPON"; // _PC:40
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_TACTICAL";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SMG_CLASS";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_CQB_CLASS";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_ASSAULT_CLASS";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_LMG_CLASS";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SNIPER_CLASS";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_HARDLINE";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_TACTICAL_MASK";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SCAVENGER";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_FLAK_JACKET";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_DEEP_IMPACT";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_HACKER";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SCOUT";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_NINJA";
	level.tips[ level.tips.size ] = &"MPTIP_TRAINING_SLEIGHT_OF_HAND";

	if( !level.console )
	{	
		level.tips[  2 ] = &"MPTIP_TRAINING_KILLSTREAK_PC";
		level.tips[  3 ] = &"MPTIP_TRAINING_SWITCH_WEAPON_PC";
		level.tips[  4 ] = &"MPTIP_TRAINING_NEW_WEAPON_PC";
		level.tips[ 14 ] = &"MPTIP_TRAINING_EQUIPMENT_PC";
		level.tips[ 19 ] = &"MPTIP_TRAINING_CAREPACKAGE_PC";
		level.tips[ 23 ] = &"MPTIP_TRAINING_SPYPLANE2_PC";
		level.tips[ 24 ] = &"MPTIP_TRAINING_TV_MISSILE_PC";
		level.tips[ 26 ] = &"MPTIP_TRAINING_CONTROLS_PC";
		level.tips[ 40 ] = &"MPTIP_TRAINING_SECONDARY_WEAPON_PC";
	}

	for ( i = 0; i < level.tips.size; i++ )
	{
		PrecacheString( level.tips[i] );
	}
}

tutorial_display_tip()
{
	assert( IsPlayer( self ) );

	self endon( "disconnect" );
	
	if ( !GameModeIsMode( level.GAMEMODE_BASIC_TRAINING ) )
	{
		return;
	}

	if ( !GetLocalProfileInt( "bot_tips" ) )
	{
		return;
	}

	if ( self is_bot() )
	{
		return;
	}

	if ( !IsDefined( self.tips_seen ) )
	{
		self.tips_seen = [];
		self tutorial_create_hud();
	}

	if ( self.tips_seen.size == level.tips.size )
	{
		self.tips_seen = [];
	}

	tip_string = "";

	for ( ;; )
	{
		index = RandomIntRange( 0, level.tips.size );

		if ( IsDefined( self.tips_seen[ index ] ) )
		{
			continue;
		}

		tip_string = level.tips[ index ];
		self.tips_seen[ index ] = true;
		break;
	}

	self.tip_hud setText( tip_string );
	self.tip_hud.alpha = 1;
	self.tip_hud SetPulseFX( 60, 9000, 500 );

	self waittill_any( "end_killcam", "abort_killcam", "tactical_insertion_canceled" );
	self.tip_hud.alpha = 0;
}

tutorial_create_hud()
{
	self.tip_hud = NewClientHudElem( self );
	self.tip_hud.archived = false;
	self.tip_hud.alignX = "center";
	self.tip_hud.alignY = "top";
	self.tip_hud.horzAlign = "center";
	self.tip_hud.vertAlign = "top";
	self.tip_hud.sort = 10; // force to draw after the bars
	self.tip_hud.font = "objective";
	self.tip_hud.foreground = true;
	self.tip_hud.hideWhenInMenu = true;
	self.tip_hud.hideWhenInDemo = true;
		
	if ( self IsSplitscreen() )
	{
		self.tip_hud.fontscale = 1.2;
		self.tip_hud.y = 30;
	}
	else
	{
		self.tip_hud.fontscale = 1.5;
		self.tip_hud.y = 75;
	}
}
