#include maps\_utility;
#include maps\_hud_util;
#include common_scripts\utility;

main()
{
}
	
create_useable_objects( entities, on_use_function, hint_string, use_time, use_text, single_use, require_lookat, initially_active )
{
	for ( i = 0; i < entities.size; i++)
	{
		create_useable_object( entities[i], on_use_function, hint_string, use_time, use_text, single_use, require_lookat, initially_active );
	}
}

create_useable_object( entity, on_use_function, hint_string, use_time, use_text, single_use, require_lookat, initially_active )
{
	useable_object = spawnStruct();
	
	useable_object.entity			= entity;
	useable_object.active			= false;
	useable_object.in_use			= false;
	useable_object.use_rate			= 1;
	useable_object.on_begin_use		= undefined;
	useable_object.on_end_use		= undefined;
	useable_object.target_use_anim_event	= entity getTargetAnim();
	useable_object.self_use_anim_event		= entity getSelfAnim();

	useable_object set_on_use_function( on_use_function );
	
	useable_object set_hint_string( hint_string );
	
	useable_object set_use_time( use_time );

	
	if ( isDefined( use_time ) && ( use_time > 0 ) )
	{
		
		useable_object.entity setCursorHint("HINT_ACTIVATE_HOLD");
	}
	
	useable_object set_use_text( use_text );
	
	useable_object set_single_use( single_use );
	
	useable_object set_require_lookat( require_lookat );
	
	if( isDefined( initially_active ) )	
		useable_object set_active( initially_active );
	else
		useable_object set_active( true );
		
	useable_object thread useable_object_logic_thread();
	
	return useable_object;
}

useable_object_logic_thread()
{
	while ( true )
	{
		self.entity waittill ( "trigger", player );
		
		if ( !isAlive( player ) )
			continue;

		
		if ( IsDefined(level.player.weapons_holstered) && level.player.weapons_holstered )
		{
			already_holstered = true;
		}
		else
		{
			already_holstered = false;
			holster_weapons();
		}

		min_wait_time = 0.5; 
		
		half_wait_time = min_wait_time * 0.5;
		half_use_time = (self.use_time * 0.5);
		
		if( half_use_time < half_wait_time )
			wait (half_wait_time - half_use_time);
			
		result = true;
		
		if ( self.use_time > 0 )
		{
			if ( isDefined( self.on_begin_use ) )
				self [[self.on_begin_use]]( player );

			result = self use_hold_think( player );
			
			if ( isDefined( self.on_end_use ) )
				self [[self.on_end_use]]( player, result );	
		}

		if ( result )
		{
			self.entity notify( "useable_activated", player );
			
			if ( isDefined( self.on_use ) )
				self [[self.on_use]]( player );
				
			if( self.single_use )
				self set_active( false );
		}

		if( half_use_time < half_wait_time )
			wait (half_wait_time - half_use_time);

		if ( !already_holstered )
		{
			unholster_weapons();
		}
	}
}

use_hold_think( player )
{

	
	tempAngle = player getplayerangles();
	player freezeControls( true );
	player setplayerangles(tempAngle);

	if( self.target_use_anim_event != "" )
		player playerAnimScriptEvent(self.target_use_anim_event);



	self.progress = 0;
	self.in_use = true;

	setDvar("ui_hackprompt_result", "0");

	player.useBarText = createPrimaryProgressBarText();
	player.useBarText setText( self.use_text );
	sf_start_minigame("cm_ig_timer");

	wait(0.5);

	while( self.progress < self.use_time 
	        && self.active
			&& isAlive( player ) 
		    && ( getDvar("cl_ignoreinput") != "1" ) 

			&& player useButtonPressed() 
		)
	{
		self.progress += int( 50 * self.use_rate );
		

		if ( getDvar("ui_hackprompt_result")=="1" )
		{
			self.in_use = false;
			if( self.target_use_anim_event != "" )
				player playerAnimScriptEvent("");
			
			player freezeControls( false );

			wait ( 0.05 );
			sf_end_minigame( "cm_ig_timer" );
			player.useBarText destroyElem();

			return true;
		}


		wait 0.05;
	}

	if( self.target_use_anim_event != "" )
		player playerAnimScriptEvent("");
	

	player freezeControls(false);

	self.in_use = false;

	wait ( 0.05 );
	sf_end_minigame( "cm_ig_timer" );
	player.useBarText destroyElem();

	return false;
}

set_active( active, force_reactivate )
{
	if( ( isDefined( force_reactivate ) && force_reactivate ) 
		|| ( active && !self.active ) 
		|| ( !active && self.active ) 
	  )
	{
		self.entity setUseable( active );
		
		if( active )
		{
			self.entity setHintString( self.hint_string );
			self.entity UseTriggerRequireLookAt( self.require_lookat );
		}
		
		self.active = active;
	}
}

set_hint_string( hint_string )
{
	if( isDefined( hint_string ) )
		self.hint_string = hint_string;
	else
		self.hint_string = "";

	self set_active( self.active, true );
}

set_require_lookat( require_lookat )
{
	if( isDefined( require_lookat ) )
		self.require_lookat = require_lookat;
	else
		self.require_lookat = true;
	
	self set_active( self.active, true );
}

set_single_use( single_use )
{
	if( isDefined( single_use ) )	
		self.single_use = single_use;
	else
		self.single_use = false;
}

set_on_use_function( on_use )
{
	if( isDefined( on_use ) )
		self.on_use = on_use;
	else
		self.on_use = undefined;
}

set_on_begin_use_function( on_begin_use )
{
	if( isDefined( on_begin_use ) )
		self.on_begin_use = on_begin_use;
	else
		self.on_begin_use = undefined;
}

set_on_end_use_function( on_end_use )
{
	if( isDefined( on_end_use ) )
		self.on_end_use = on_end_use;
	else
		self.on_end_use = undefined;
}

set_use_time( use_time )
{
	if( isDefined( use_time ) )
		self.use_time = int( use_time * 1000 );
	else
		self.use_time = 0;

	
	if (self.use_time > 0) {
		self.use_time = 5000;
	}
}

set_use_rate( use_rate )
{
	if( isDefined( use_rate ) )
		self.use_rate = use_rate;
	else
		self.use_rate = 1;
}

set_use_text( use_text )
{
	if( isDefined( use_text ) )
		self.use_text = use_text;
	else
		self.use_text = "";
}


