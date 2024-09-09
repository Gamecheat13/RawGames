#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\perks\_perkfunctions;
#include maps\mp\gametypes\_scrambler;
#include maps\mp\gametypes\_portable_radar;

init()
{
	PreCacheShader( "hudcolorbar" );
}

active_cloaking_ui()
{
	self endon("connect");
	self endon("disconnect");
	self endon("death");
	self endon("new_perk_stack");
	
	if ( !IsDefined( self.hud_cloak_meter ) )
	{
		self.hud_cloak_meter = NewClientHudElem(self);
		self.hud_cloak_meter.x = 30;
		self.hud_cloak_meter.y = 200;
		self.hud_cloak_meter.sort = 6;
		self.hud_cloak_meter.horzalign = "left";
		self.hud_cloak_meter.vertalign = "top";
		self.hud_cloak_meter SetShader( "hudcolorbar", 20, 100 );
	}

	while ( true )
	{
		self.hud_cloak_meter.y = 200 - self.active_cloak_fuel;
		wait( 0.05 );
	}	
}

active_cloaking_disable( modelName, headName, handsName )
{
	self SetModel( modelName );
	
	self detach( "mp_head_cloak_test" );
	self attach( headName );
	self.headModel = headName;
	
	self setViewmodel( handsName );
	
	self.active_cloak_enabled = false;
}

active_cloaking_enable( modelName, headName, handsName )
{
	self SetModel( "mp_body_cloak_test" );
	
	self detach( headName );
	self attach( "mp_head_cloak_test" );
	self.headModel = "mp_head_cloak_test";
	
	self setViewmodel( "mp_viewhands_cloak_test" );
	
	self.active_cloak_enabled = true;
}

active_cloaking_monitor()
{
	self endon("connect");
	self endon("disconnect");
	self endon("death");
	self endon("new_perk_stack");

	self waittill( "player_model_set" );
	
	modelName = self GetModelFromEntity();
	headName = self.headModel;
	handsName = self GetViewModel();
	self.active_cloak_enabled = false;
	self.active_cloak_fuel = 100;
	buttonPressed = false;
	
	/#
	Print( "active_cloaking_monitor(): The player model is " );
	Print( modelName );
	Print( ", the head model is " );
	Print( headName );
	Print( ", and the view model is " );
	Print( handsName );
	Print( "\n" );
	#/
	assert( IsDefined( headName ) );
	
	self thread active_cloaking_ui(); // this is here to guarantee active_cloak_fuel is defined.
	
	while ( true )
	{
		if ( self.active_cloak_enabled )
			self.active_cloak_fuel -= 1;
		else if ( self.active_cloak_fuel < 100 )
			self.active_cloak_fuel += 1;
		
		if ( self SecondaryOffhandButtonPressed() )
		{
			if ( !buttonPressed )
			{
				if ( self.active_cloak_enabled )
				{
					active_cloaking_disable( modelName, headName, handsName );
				}
				else
				{
					active_cloaking_enable( modelName, headName, handsName );
				}
			}
			
			buttonPressed = true;
		}
		else
		{
			buttonPressed = false;
		}
		
		if ( self.active_cloak_fuel <= 0 )
		{
			active_cloaking_disable( modelName, headName, handsName );
		}
		
		wait 0.05;
	}
}