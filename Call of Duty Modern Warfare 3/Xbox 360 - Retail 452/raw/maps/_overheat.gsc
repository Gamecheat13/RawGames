#include maps\_hud_util;
#include maps\_utility;
#include common_scripts\utility;

TURRET_HEAT_MAX = 114;// Dont touch

// Tweaks
TURRET_HEAT_RATE = 1.0;					// Rate that the gun overheats( high number means faster overheat )
TURRET_COOL_RATE = 1.0;					// Rate that the gun cools down( higher number means it cools off faster )
OVERHEAT_TIME = 2.0;					// Time to flash the overheat meter
OVERHEAT_FLASH_TIME = 0.2;				// When the gun first overheats the status bar blinks at this rate
OVERHEAT_FLASH_TIME_INCREMENT = 0.1;	// Each time the status bar blinks it increments by this much each blink( causes it to blink slower as the overheat period runs out )
GUN_USAGE_DELAY_AFTER_OVERHEAT = 2.0;	// Once you have overheated the gun waits this amount of time before turning on again

init_overheat()
{
	PrecacheShader( "hud_temperature_gauge" );
}

overheat_enable( vehicle )
{
	Assert( IsPlayer( self ) );
	Assert( IsDefined( vehicle ) );
	Assert( IsSubStr( vehicle.classname, "script_vehicle" ) );

	AssertEx( !IsDefined( self.overheat ), "Tried to call overheat_enable() on a player that is already doing overheat logic." );

	if ( IsDefined( self.overheat ) )
		return;

	self.overheat = SpawnStruct();
	self.overheat.turret_heat_status = 1;
	self.overheat.overheated = false;
	
	self.overheat.turret_heat_max 					= TURRET_HEAT_MAX;
	self.overheat.turret_heat_rate 					= TURRET_HEAT_RATE;
	self.overheat.turret_cool_rate					= TURRET_COOL_RATE;
	self.overheat.overheat_time 					= OVERHEAT_TIME;
	self.overheat.overheat_flash_time 				= OVERHEAT_FLASH_TIME;
	self.overheat.overheat_flash_time_increment 	= OVERHEAT_FLASH_TIME_INCREMENT;
	self.overheat.gun_usage_delay_after_overheat 	= GUN_USAGE_DELAY_AFTER_OVERHEAT;

	self thread create_hud();
	self thread status_meter_update( vehicle );
}

overheat_disable()
{
	Assert( IsPlayer( self ) );

	self notify( "disable_overheat" );
	level.savehere = undefined;

	waittillframeend;

	if ( IsDefined( self.overheat.overheat_bg ) )
		self.overheat.overheat_bg Destroy();
	if ( IsDefined( self.overheat.overheat_status ) )
		self.overheat.overheat_status Destroy();

	self.overheat = undefined;
}

status_meter_update( vehicle )
{
	// Notify doesn't work the way Ned is doing his vehicle ride so this hacked with attackButtonPressed() for now

	self endon( "disable_overheat" );

	for ( ;; )
	{
		//iprintln( self.overheat.turret_heat_status );

		if ( self.overheat.turret_heat_status >= self.overheat.turret_heat_max )
		{
			wait 0.05;
			continue;
		}

		if ( self AttackButtonPressed() && !self.overheat.overheated )
			self.overheat.turret_heat_status += self.overheat.turret_heat_rate;
		else
			self.overheat.turret_heat_status -= self.overheat.turret_cool_rate;

		self.overheat.turret_heat_status = Clamp( self.overheat.turret_heat_status, 1, self.overheat.turret_heat_max );

		self update_overheat_meter();
		self thread overheated( vehicle );

		wait 0.05;
	}
}

update_overheat_meter()
{
	self.overheat.overheat_status ScaleOverTime( 0.05, 10, int( self.overheat.turret_heat_status ) );
	self thread overheat_setColor( self.overheat.turret_heat_status, 0.05 );
}

create_hud()
{
	//Draw the temperature gauge and filler bar components

	self endon( "disable_overheat" );

	coopOffset = 0;
	if ( is_coop() )
		coopOffset = 70;
	barX = -10;
	barY = -152 + coopOffset;
	
	if ( !IsDefined( self.overheat.overheat_bg ) )
	{
		self.overheat.overheat_bg = NewClientHudElem( self );
		self.overheat.overheat_bg.alignX = "right";
		self.overheat.overheat_bg.alignY = "bottom";
		self.overheat.overheat_bg.horzAlign = "right";
		self.overheat.overheat_bg.vertAlign = "bottom";
		self.overheat.overheat_bg.x = 2;
		self.overheat.overheat_bg.y = -120 + coopOffset;
		self.overheat.overheat_bg SetShader( "hud_temperature_gauge", 35, 150 );
		self.overheat.overheat_bg.sort = 4;
	}

	//status bar
	if ( !IsDefined( self.overheat.overheat_status ) )
	{
		self.overheat.overheat_status = NewClientHudElem( self );
		self.overheat.overheat_status.alignX = "right";
		self.overheat.overheat_status.alignY = "bottom";
		self.overheat.overheat_status.horzAlign = "right";
		self.overheat.overheat_status.vertAlign = "bottom";
		self.overheat.overheat_status.x = barX;
		self.overheat.overheat_status.y = barY;
		self.overheat.overheat_status SetShader( "white", 10, 1 );
		self.overheat.overheat_status.color = ( 1, .9, 0 );
		self.overheat.overheat_status.alpha = 1;
		self.overheat.overheat_status.sort = 1;
	}
}

overheated( vehicle )
{
	self endon( "disable_overheat" );

	if ( self.overheat.turret_heat_status < self.overheat.turret_heat_max )
		return;

	if ( self.overheat.overheated )
		return;
	self.overheat.overheated = true;

	// Gun has overheated

	level.savehere = false;
	self thread play_sound_on_entity( "smokegrenade_explode_default" );

	self.overheat.turret_heat_status = self.overheat.turret_heat_max;

	if ( IsDefined( vehicle.mgturret ) )
		vehicle.mgturret[ 0 ] TurretFireDisable();

	time = GetTime();

	flashTime = self.overheat.overheat_flash_time;
	for ( ;; )
	{
		self.overheat.overheat_status FadeOverTime( flashTime );
		self.overheat.overheat_status.alpha = 0.2;
		wait flashTime;
		self.overheat.overheat_status FadeOverTime( flashTime );
		self.overheat.overheat_status.alpha = 1.0;
		wait flashTime;

		flashTime += self.overheat.overheat_flash_time_increment;

		if ( GetTime() - time >= self.overheat.overheat_time * 1000 )
			break;
	}
	self.overheat.overheat_status.alpha = 1.0;

	// Start cooldown again
	self.overheat.turret_heat_status -= self.overheat.turret_cool_rate;

	// wait for it to cool down a bit
	wait self.overheat.gun_usage_delay_after_overheat;

	// Make gun usable
	if ( IsDefined( vehicle.mgturret ) )
		vehicle.mgturret[ 0 ] TurretFireEnable();

	level.savehere = undefined;
	self.overheat.overheated = false;
}

overheat_setColor( value, fadeTime )
{
	self endon( "disable_overheat" );

	//define what colors to use
	color_cold = [];
	color_cold[ 0 ] = 1.0;
	color_cold[ 1 ] = 0.9;
	color_cold[ 2 ] = 0.0;
	color_warm = [];
	color_warm[ 0 ] = 1.0;
	color_warm[ 1 ] = 0.5;
	color_warm[ 2 ] = 0.0;
	color_hot = [];
	color_hot[ 0 ] = 0.9;
	color_hot[ 1 ] = 0.16;
	color_hot[ 2 ] = 0.0;

	//default color
	CurrentColor = [];
	CurrentColor[ 0 ] = color_cold[ 0 ];
	CurrentColor[ 1 ] = color_cold[ 1 ];
	CurrentColor[ 2 ] = color_cold[ 2 ];

	//define where the non blend points are
	cold = 0;
	warm = ( self.overheat.turret_heat_max / 2 );
	hot = self.overheat.turret_heat_max;

	iPercentage = undefined;
	difference = undefined;
	increment = undefined;

	if ( ( value > cold ) && ( value <= warm ) )
	{
		iPercentage = int( value * ( 100 / warm ) );
		for ( colorIndex = 0 ; colorIndex < CurrentColor.size ; colorIndex++ )
		{
			difference = ( color_warm[ colorIndex ] - color_cold[ colorIndex ] );
			increment = ( difference / 100 );
			CurrentColor[ colorIndex ] = color_cold[ colorIndex ] + ( increment * iPercentage );
		}
	}
	else if ( ( value > warm ) && ( value <= hot ) )
	{
		iPercentage = int( ( value - warm ) * ( 100 / ( hot - warm ) ) );
		for ( colorIndex = 0 ; colorIndex < CurrentColor.size ; colorIndex++ )
		{
			difference = ( color_hot[ colorIndex ] - color_warm[ colorIndex ] );
			increment = ( difference / 100 );
			CurrentColor[ colorIndex ] = color_warm[ colorIndex ] + ( increment * iPercentage );
		}
	}

	if ( IsDefined( fadeTime ) )
		self.overheat.overheat_status FadeOverTime( fadeTime );

	if ( IsDefined( self.overheat.overheat_status.color ) )
		self.overheat.overheat_status.color = ( CurrentColor[ 0 ], CurrentColor[ 1 ], CurrentColor[ 2 ] );
}