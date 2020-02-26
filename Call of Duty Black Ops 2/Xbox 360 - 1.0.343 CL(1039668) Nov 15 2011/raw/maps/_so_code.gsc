#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;

// ======================================================================
// AIRDROP FUNCTIONS
// ======================================================================

// ======================================================================
// HUD FUNCTIONS
// ======================================================================

splash_notify_message( splashData )
{
	self endon( "death" );

	assert( isDefined( splashData.title ) );

	// TODO - maybe reconstitute? With this, the message won't appear until after flashbangs wear off, etc.
	//waitRequireVisibility( 0 );
	
	if( !IsDefined( splashData.type ) )
		splashData.type = "";
	
	duration = splashData.duration;
	transTime = 0.15;
	
	self.doingNotify = true;
	self.splashTitle transitionReset();
	self.splashDesc transitionReset();
	self.splashDesc1 transitionReset();
	self.splashDesc2 transitionReset();
	self.splashDesc3 transitionReset();
	self.splashDesc4 transitionReset();
	self.splashHint transitionReset();
	self.splashIcon transitionReset();
	wait ( 0.05 );
	
	// don't draw the sniper breath hint while doing our splash
	SetSavedDvar( "cg_drawBreathHint", "0" );
	
	elements = [];
	elements[elements.size] = self.splashTitle;
	self.splashTitle.label = splashData.title;
	
	if( IsDefined( splashData.title_set_value ) )
		self.splashTitle SetValue( splashData.title_set_value );
	
	self.splashTitle SetPulseFX( int( 5 * duration ), int( duration * 1000 ), 1000 );
	
	og_title_font = self.splashTitle.font;
	if( IsDefined( splashData.title_font ) )
		self.splashTitle.font = splashData.title_font;
	
	og_title_label = splashData.title;
	if ( isDefined( splashData.title_label ) )
		self.splashTitle.label = splashData.title_label;
	
	og_title_baseFontScale = self.splashTitle.baseFontScale;
	if( IsDefined( splashData.title_baseFontScale ) )
		self.splashTitle.baseFontScale = splashData.title_baseFontScale;

	og_title_glowColor = self.splashTitle.glowColor;
	og_title_glowAlpha = self.splashTitle.glowAlpha;
	if ( IsDefined( splashData.title_glowColor ) )
	{
		self.splashTitle.glowColor = splashData.title_glowColor;
		self.splashTitle.glowAlpha = 1.0;
	}
	
	og_title_color = self.splashTitle.color;
	if ( isDefined( splashData.title_color ) )
	{
		og_title_color = splashData.title_color;
		self.splashTitle.color = splashData.title_color;
	}
	
	og_icon_shader = self.splashIcon.shader;
	if ( isDefined( splashData.icon ) && splashData.icon != "" )
	{
		elements[elements.size] = self.splashIcon;
		self.splashIcon.shader = splashData.icon;
	}
	
	// desc section =======================================================
	og_desc_font			= undefined;
	og_desc_baseFontScale	= undefined;
	if ( isDefined( splashData.desc ) && (!isString( splashData.desc ) || splashData.desc != "") )
	{
		elements[elements.size] = self.splashDesc;
		self.splashDesc.label = splashData.desc;

		if ( isdefined( splashData.desc_set_value ) )
			self.splashDesc SetValue( splashData.desc_set_value );

		og_desc_font = self.splashDesc.font;
		if( IsDefined( splashData.desc_font ) )
			self.splashDesc.font = splashData.Desc_Font;

		og_desc_baseFontScale = self.splashDesc.baseFontScale;
		if( IsDefined( splashData.desc_baseFontScale ) )
			self.splashDesc.baseFontScale = splashData.desc_baseFontScale;
		
		// extra desc
		if ( isDefined( splashData.desc1 ) && (!isString( splashData.desc1 ) || splashData.desc1 != "") )
		{
			elements[elements.size] = self.splashDesc1;
			self.splashDesc1.label = splashData.desc1;
			self.splashDesc1.font = self.splashDesc.font;
			
			if ( isdefined( splashData.desc1_set_value ) )
				self.splashDesc1 SetValue( splashData.desc1_set_value );
		}
		if ( isDefined( splashData.desc2 ) && (!isString( splashData.desc2 ) || splashData.desc2 != "") )
		{
			elements[elements.size] = self.splashDesc2;
			self.splashDesc2.label = splashData.desc2;
			self.splashDesc2.font = self.splashDesc.font;
			
			if ( isdefined( splashData.desc2_set_value ) )
				self.splashDesc2 SetValue( splashData.desc2_set_value );
		}
		if ( isDefined( splashData.desc3 ) && (!isString( splashData.desc3 ) || splashData.desc3 != "") )
		{
			elements[elements.size] = self.splashDesc3;
			self.splashDesc3.label = splashData.desc3;
			self.splashDesc3.font = self.splashDesc.font;
			
			if ( isdefined( splashData.desc3_set_value ) )
				self.splashDesc3 SetValue( splashData.desc3_set_value );
		}
		if ( isDefined( splashData.desc4 ) && (!isString( splashData.desc4 ) || splashData.desc4 != "") )
		{
			elements[elements.size] = self.splashDesc4;
			self.splashDesc4.label = splashData.desc4;
			self.splashDesc4.font = self.splashDesc.font;
			
			if ( isdefined( splashData.desc4_set_value ) )
				self.splashDesc4 SetValue( splashData.desc4_set_value );
		}
	}

	// END desc section =======================================================
	
	if ( isDefined( splashData.hint ) && ( !isString( splashData.hint ) || splashData.hint != "") )
	{
		elements[elements.size] = self.splashHint;
		self.splashHint.label = splashData.hint;

		if ( isDefined( splashData.hintLabel ) )
			self.splashHint.label = splashData.hintLabel;
	}
		
	if ( isDefined( splashData.fadeIn ) )
	{
		foreach ( element in elements )
			element transitionFadeIn( transTime );
	}
		
	if ( isDefined( splashData.zoomIn ) )
	{
		foreach ( element in elements )
			element transitionZoomIn( transTime );
	}

	if ( isDefined( splashData.slideIn ) )
	{
		foreach ( element in elements )
			element transitionSlideIn( transTime, splashData.slideIn );
	}

	if ( isDefined( splashData.pulseFXIn ) )
	{
		foreach ( element in elements )
			element transitionPulseFXIn( transTime, duration );
	}

	if ( isDefined( splashData.sound ) )
	{
		if( IsDefined( splashData.playSoundLocally ) )
		{
			self PlayLocalSound( splashData.sound );
		}
		else
		{
			foreach( player in level.players )
				player playLocalSound( splashData.sound );
		}
	}

	// wait for splash duration then reset
	if( IsDefined( splashData.abortFlag ) )
		ent_flag_wait_or_timeout( splashData.abortFlag, duration );
	else
		wait ( duration );

	if ( isDefined( splashData.fadeOut ) )
	{
		foreach ( element in elements )
			element transitionFadeOut( transTime );
	}
		
	if ( isDefined( splashData.zoomOut ) )
	{
		foreach ( element in elements )
			element transitionZoomOut( transTime );
	}

	if ( isDefined( splashData.slideOut ) )
	{
		foreach ( element in elements )
			element transitionSlideOut( transTime, splashData.slideOut );
	}
	
	wait( transTime );
	SetSavedDvar( "cg_drawBreathHint", "1" );
	
	// reset params that we may have changed from the default
	self.splashTitle.font			= og_title_font;
	self.splashTitle.label			= og_title_label;
	self.splashTitle.baseFontScale	= og_title_baseFontScale;
	self.splashTitle.glowColor		= og_title_glowColor;
	self.splashTitle.glowAlpha		= og_title_glowAlpha;
	self.splashTitle.color			= og_title_color;
	self.splashIcon.shader			= og_icon_shader;
	
	if( IsDefined( og_desc_font ) )
		self.splashDesc.font = og_desc_font;
		
	if( IsDefined( og_desc_baseFontScale ) )
		self.splashDesc.baseFontScale = og_desc_baseFontScale;
	
	self.doingNotify = false;
}

player_reward_splash_init()
{
	line_yOffset = 15;
	
	if ( IsSplitscreen() )
	{
		titleFont = "objective";
		titleSize = 2.25;
		title_yOffset = 30;
		title_xOffset = 0;
		
		textFont = "objective";
		textSize = 1;
		text_yOffset = 57;
		text_xOffset = 0;
		
		text2Font = "small";
		text2Size = 1.4;
		text2_yOffset = 72;
		text2_xOffset = 0;
		
		iconSize = 24;
		icon_yOffset = 5;
		icon_xOffset = 0;
		
		point = "TOP";
		relativePoint = "BOTTOM";
	}
	else
	{
		titleFont = "objective";
		titleSize = 2.5;
		title_yOffset = 10;
		title_xOffset = 0;
		
		textFont = "objective";
		textSize = 1.1;
		text_yOffset = 42; //79;
		text_xOffset = 0;
		
		text2Font = "small";
		text2Size = 1.5;
		text2_yOffset = 300; //96;
		text2_xOffset = 0;
		
		iconSize = 42;
		icon_yOffset = 250; //8;
		icon_xOffset = 0;
		
		point = "TOP";
		relativePoint = "BOTTOM";
	}
	
	elem = createFontString_mp( titleFont, titleSize );
	elem maps\_hud_util::setPoint( point, undefined, title_xOffset, title_yOffset );
	elem.glowColor = ( 0.3, 0.6, 0.3 );
	elem.glowAlpha = 1;
	//elem.glowColor = (0.2, 0.3, 0.7);
	//elem.glowAlpha = 1;
	elem.hideWhenInMenu = true;
	elem.archived = false;
	elem.alpha = 0;
	self.splashTitle = elem;
	
	elem = undefined;

	elem = createFontString_mp( textFont, textSize );
	elem maps\_hud_util::setParent( self.splashTitle );
	elem maps\_hud_util::setPoint( point, relativePoint, text_xOffset, text_yOffset );
	elem.glowColor = ( 0, 0, 0 );
	elem.glowAlpha = 0;
	elem.hideWhenInMenu = true;
	elem.archived = false;
	elem.alpha = 0;
	self.splashDesc = elem;
	
	elem = undefined;
	
	elem = createFontString_mp( textFont, textSize );
	elem maps\_hud_util::setParent( self.splashTitle );
	elem maps\_hud_util::setPoint( point, relativePoint, text_xOffset, text_yOffset+(1*(line_yOffset)) );
	elem.glowColor = ( 0, 0, 0 );
	elem.glowAlpha = 0;
	elem.hideWhenInMenu = true;
	elem.archived = false;
	elem.alpha = 0;
	self.splashDesc1 = elem;
	
	elem = undefined;

	elem = createFontString_mp( textFont, textSize );
	elem maps\_hud_util::setParent( self.splashTitle );
	elem maps\_hud_util::setPoint( point, relativePoint, text_xOffset, text_yOffset+(2*(line_yOffset)) );
	elem.glowColor = ( 0, 0, 0 );
	elem.glowAlpha = 0;
	elem.hideWhenInMenu = true;
	elem.archived = false;
	elem.alpha = 0;
	self.splashDesc2 = elem;
	
	elem = undefined;

	elem = createFontString_mp( textFont, textSize );
	elem maps\_hud_util::setParent( self.splashTitle );
	elem maps\_hud_util::setPoint( point, relativePoint, text_xOffset, text_yOffset+(3*(line_yOffset)) );
	elem.glowColor = ( 0, 0, 0 );
	elem.glowAlpha = 0;
	elem.hideWhenInMenu = true;
	elem.archived = false;
	elem.alpha = 0;
	self.splashDesc3 = elem;
	
	elem = undefined;

	elem = createFontString_mp( textFont, textSize );
	elem maps\_hud_util::setParent( self.splashTitle );
	elem maps\_hud_util::setPoint( point, relativePoint, text_xOffset, text_yOffset+(4*(line_yOffset)) );
	elem.glowColor = ( 0, 0, 0 );
	elem.glowAlpha = 0;
	elem.hideWhenInMenu = true;
	elem.archived = false;
	elem.alpha = 0;
	self.splashDesc4 = elem;
	
	elem = undefined;
	
	elem = createFontString_mp( "big", 0.75 );
	elem maps\_hud_util::setParent( self.splashDesc );
	elem maps\_hud_util::setPoint( point, relativePoint, text2_xOffset, text2_yOffset );
	elem.glowColor = ( 0, 0, 0 );
	elem.glowAlpha = 0;
	elem.hideWhenInMenu = true;
	elem.archived = false;
	elem.alpha = 0;
	elem.color = ( 0.75, 1, 0.75 );
	self.splashHint = elem;
	
	elem = undefined;

	elem = createIcon_mp( "white", iconSize, iconSize );
	elem maps\_hud_util::setParent( self.splashTitle );
	elem setPoint( point, relativePoint, icon_xOffset, icon_yOffset );
	elem.hideWhenInMenu = true;
	elem.archived = false;
	elem.alpha = 0;
	self.splashIcon = elem;
}

createFontString_mp( font, textSize )
{
	fontElem = NewClientHudElem( self );
	fontElem.hidden = false;
	fontElem.elemType = "font";
	fontElem.font = font;
	fontElem.fontscale = textSize;
	fontElem.baseFontScale = fontElem.fontScale;
	fontElem.x = 0;
	fontElem.y = 0;
	fontElem.width = 0;
	fontElem.height = int( level.fontHeight * fontElem.fontScale );
	fontElem.xOffset = 0;
	fontElem.yOffset = 0;
	fontElem.children = [];
	fontElem maps\_hud_util::setParent( level.uiParent );
	
	return fontElem;
}

createIcon_mp( shader, width, height )
{
	iconElem = NewClientHudElem( self );
	iconElem.elemType = "icon";
	iconElem.x = 0;
	iconElem.y = 0;
	iconElem.width = width;
	iconElem.height = height;
	iconElem.baseWidth = iconElem.width;
	iconElem.baseHeight = iconElem.height;
	iconElem.xOffset = 0;
	iconElem.yOffset = 0;
	iconElem.children = [];
	iconElem maps\_hud_util::setParent( level.uiParent );
	iconElem.hidden = false;
	
	if ( isDefined( shader ) )
	{
		iconElem setShader( shader, width, height );
		iconElem.shader = shader;
	}
	
	return iconElem;
}

// waits for splash notifies, uav usage, etc to finish
waittill_players_ready_for_splash( timeoutSecs )
{
	timeoutTime = GetTime() + milliseconds( timeoutSecs );
	
	while( 1 )
	{
		if( GetTime() >= timeoutTime )
		{
			break;
		}
		
		delay = false;
		players = get_players();
		foreach( player in players )
		{
			if( is_true(player.doingNotify) || is_true(player.using_uav) )
			{
				delay = true;
				break;
			}
		}
		
		if( delay )
		{
			wait( 0.5 );
		}
		else
		{
			break;
		}
	}
}

transitionReset()
{
	self SetText( "" );
	
	self.x = self.xOffset;
	self.y = self.yOffset;
	if ( self.elemType == "font" )
	{
		self.fontScale = self.baseFontScale;
		self.label = &"";
	}
	else if ( self.elemType == "icon" )
	{
		//self scaleOverTime( 0.001, self.width, self.height );
		self setShader( self.shader, self.width, self.height );
	}
	self.alpha = 0;
}

transitionZoomIn( duration )
{
	switch ( self.elemType )
	{
		case "font":
		case "timer":
			self.fontScale = 6.3;
			self changeFontScaleOverTime( duration );
			self.fontScale = self.baseFontScale;
			break;
		case "icon":
			self setShader( self.shader, self.width * 6, self.height * 6 );
			self scaleOverTime( duration, self.width, self.height );
			break;
	}
}

transitionPulseFXIn( inTime, duration )
{
	transTime = int(inTime)*1000;
	showTime = int(duration)*1000;
	
	switch ( self.elemType )
	{
		case "font":
		case "timer":
			self setPulseFX( transTime+250, showTime+transTime, transTime+250 );
			break;
		default:
			break;
	}
}

transitionSlideIn( duration, direction )
{
	if ( !isDefined( direction ) )
		direction = "left";

	switch ( direction )
	{
		case "left":
			self.x += 1000;
			break;
		case "right":
			self.x -= 1000;
			break;
		case "up":
			self.y -= 1000;
			break;
		case "down":
			self.y += 1000;
			break;		
	}
	self moveOverTime( duration );
	self.x = self.xOffset;
	self.y = self.yOffset;
}

transitionSlideOut( duration, direction )
{
	if ( !isDefined( direction ) )
		direction = "left";

	gotoX = self.xOffset;
	gotoY = self.yOffset;

	switch ( direction )
	{
		case "left":
			gotoX += 1000;
			break;
		case "right":
			gotoX -= 1000;
			break;
		case "up":
			gotoY -= 1000;
			break;
		case "down":
			gotoY += 1000;
			break;		
	}

	self.alpha = 1;
	
	self moveOverTime( duration );
	self.x = gotoX;
	self.y = gotoY;
}

transitionZoomOut( duration )
{
	switch ( self.elemType )
	{
		case "font":
		case "timer":
			self changeFontScaleOverTime( duration );
			self.fontScale = 6.3;
		case "icon":
			self scaleOverTime( duration, self.width * 6, self.height * 6 );
			break;
	}
}

transitionFadeIn( duration )
{
	self fadeOverTime( duration );
	if ( isDefined( self.maxAlpha ) )
		self.alpha = self.maxAlpha;
	else
		self.alpha = 1;
}

transitionFadeOut( duration )
{
	self fadeOverTime( 0.15 );
	self.alpha = 0;
}
// END HUD UTILITY -------------------------------------------------------

// ==========================================================================
// AI HELPER FUNCTIONS
// ==========================================================================

// get spawners array by classname
get_spawners_by_classname( classname )
{
	spawners = getentarray( classname, "classname" );
	real_spawners = [];
	foreach( spawner in spawners )
	{
		if ( isspawner( spawner ) )
			real_spawners[ real_spawners.size ] = spawner;
	}
	
	return real_spawners;
}

get_spawners_by_targetname( targetname )
{
	all_spawners 	= getspawnerarray();
	found_spawners 	= [];
	
	foreach( spawner in all_spawners )
		if ( isdefined( spawner.targetname ) && spawner.targetname == targetname )
			found_spawners[ found_spawners.size ] = spawner;
	
	return found_spawners;
}

// best spawn location helper function
get_furthest_from_these( array, avoid_locs, rand_locs_num )
{
	rand_locs_num = ( isdefined( rand_locs_num )?rand_locs_num:1 );
	rand_locs_num = max( 1, rand_locs_num );
	
	// keep removing closest spawns to leaders and players until 1 left, then randomly pick one to spawn
	while( array.size > rand_locs_num )
	{
		foreach ( avoid_loc in avoid_locs )
		{
			element = getclosest( avoid_loc.origin, array );
			if ( array.size > rand_locs_num )
			{
				//thread maps\_squad_enemies::draw_debug_marker( element.origin, ( 1, 0.5, 0.5 ) );
				array = array_remove( array, element );
			}
			else
			{
				element = array[ 0 ];
				thread maps\_squad_enemies::draw_debug_marker( element.origin, ( 1, 1, 1 ) );
				break;
			}
		}
	}
	
	return array[ randomint( array.size ) ];
}

// this only makes AI more inclined to throw grenade, not ASAP nor guaranteed
throw_grenade_at_player( player )
{
	self 	endon( "death" );
	player 	endon( "stopped camping" );
	
	if( self.type != "human" )
		return;
	
	// some stuns
	if ( cointoss() )
		self.grenadeweapon  = "flash_grenade_sp";
	else
		self.grenadeweapon  = "frag_grenade_sp";
	
	self.grenadeammo = 2;
	self.script_forceGrenade = 1;
	//self ThrowGrenadeAtPlayerASAP();
	wait 8;
	self.script_forceGrenade = 0;
	
	// reset
	self.grenadeweapon  = "frag_grenade_sp";
}

// rid the dead or removed bosses from level.bosses array
clear_from_boss_array_when_dead()
{
	self waittill( "death" );
	bosses = [];
	
	foreach( boss in level.bosses )
		if ( isdefined( boss ) && ( !isdefined( self ) || self != boss ) )
			bosses[ bosses.size ] = boss;

	level.bosses = bosses;
}

// rid the dead or removed special AI from level.special_ai array
clear_from_special_ai_array_when_dead()
{
	self waittill( "death" );
	special_ais = [];
	foreach( ai in level.special_ai )
	{
		if ( isalive( ai ) )
			special_ais[ special_ais.size ] = ai;
	}
	level.special_ai = special_ais;	
}

was_headshot()
{
	// Special field set in Survival AI when damage was scaled
	// up enough on a headshot to force a kill
	if ( IsDefined( self.died_of_headshot ) && self.died_of_headshot )
		return true;
		
	if ( !IsDefined( self.damageLocation ) )
		return false;

	return( self.damageLocation == "helmet" || self.damageLocation == "head" || self.damageLocation == "neck" );
}

// ==========================================================================
// UTILITY FUNCTIONS
// ==========================================================================

// removing MP ents that show up in SO
MP_ents_cleanup()
{
	entitytypes = getentarray();
	for ( i = 0; i < entitytypes.size; i++ )
	{
		if ( isdefined( entitytypes[ i ].script_gameobjectname ) )
			entitytypes[ i ] delete();
		
		if ( isdefined( entitytypes[ i ].targetname ) && entitytypes[ i ].targetname == "war_delete" )
			entitytypes[ i ] delete();
	}
}

// Precache item helper
Precache_loadout_item( item_ref )
{
	if ( isdefined( item_ref ) && item_ref != "" )
		PrecacheItem( item_ref );	
}


int_capped( int_input, int_min, int_max )
{
	return int( max( int_min, min( int_max, int_input ) ) );
}

float_capped( float_input, float_min, float_max )
{
	return max( float_min, min( float_max, float_input ) );
}

delete_on_load()
{
	ents = GetEntArray( "delete", "targetname" );
	foreach( ent in ents )
		ent Delete();
}

milliseconds( seconds )
{
	return seconds * 1000;
}

seconds( milliseconds )
{
	return milliseconds / 1000;
}

random_player_origin()
{
	assert( isdefined( level.players ) && level.players.size, "Level.players not defined yet." );
	
	return level.players[ randomint( level.players.size ) ].origin;
}


// Wait at least 0.05 to avoid error: - cannot delete during think -
// that happens when an entity was linked and then is deleted :-/
ent_linked_delete()
{
	assert( isdefined( self ), "Entity must be defined." );
	
	self endon( "death" );
	
	self unlink();
	
	wait 0.05;
	
	if ( isdefined( self ) )
		self delete();
}



// this opens a menu to set milliseconds() in menu script to get menu element to animate
surHUD_animate( ref )
{
	level endon( "special_op_terminated" );
	
	if ( !isdefined( self.surHUD_busy ) )
		self.surHUD_busy = false;

	while ( self.surHUD_busy )
		wait 0.05;
	
	// only one animate to be done in a frame, queuing
	self.surHUD_busy = true;
	
	// if hidden, we show since animate implies visbility
	if ( !surHUD_is_enabled( ref ) )
		self surHUD_enable( ref );
	
	// sets the element to be animated
	self _setplayerdata_single( "surHUD_set_animate", ref );
	wait 0.05;
	
	// opens menu to set timer to animate for item
	//self openmenu( "surHUD_display" );
	
	wait 0.05;
	self.surHUD_busy = false;
}

// sets mini challenge text label per slot
surHUD_challenge_label( slot, value )
{
	if ( isdefined( self ) )
		self _setplayerdata_array( "surHUD_challenge_label", "slot_" + slot, value );
}

// set mini challenge progress per slot
surHUD_challenge_progress( slot, value )
{
	if ( isdefined( self ) )
		self _setplayerdata_array( "surHUD_challenge_progress", "slot_" + slot, value );
}

// set mini challenge reward amount per slot
surHUD_challenge_reward( slot, value )
{
	if ( isdefined( self ) )
		self _setplayerdata_array( "surHUD_challenge_reward", "slot_" + slot, value );
}

// show menu hud element
surHUD_is_enabled( ref )
{
//TODO dk getplayerdata undefined currently
//	if ( isdefined( self ) && self getplayerdata( "surHUD", ref ) )
//		return true;
		
	return false;
}

// show menu hud element
surHUD_enable( ref )
{
	if ( isdefined( self ) )
		self _setplayerdata_array( "surHUD", ref, 1 );
}

// hide menu hud element
surHUD_disable( ref )
{
	if ( isdefined( self ) )
		self _setplayerdata_array( "surHUD", ref, 0 );
}

_setplayerdata_single( data_name, value )
{
//	name = "player";
//	if ( isdefined( self.unique_id ) )
//		name = self.unique_id;
		
//	println( name + "> setplayerdata("+data_name+","+value+") START: " + gettime() );
//TODO dk setplayerdata undefined currently
//	self setplayerdata( data_name, value );
//	println( name + "> setplayerdata("+data_name+","+value+") END: " + gettime() );
}

_setplayerdata_array( data_name, data_index, value )
{
//	name = "player";
//	if ( isdefined( self.unique_id ) )
//		name = self.unique_id;
		
//	println( name + "> setplayerdata("+data_name+","+data_index+","+value+") START: " + gettime() );
//TODO dk setplayerdata undefined currently
//	self setplayerdata( data_name, data_index, value );
//	fprintln( name + "> setplayerdata("+data_name+","+data_index+","+value+") END: " + gettime() );
}

SQR(val)
{
	return (val*val);
}