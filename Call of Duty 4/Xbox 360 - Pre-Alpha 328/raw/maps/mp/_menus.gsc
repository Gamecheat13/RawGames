// Seperate menu logic from other misc logic a little more
// Misc logic can be executed on events such as onOpen, onClose...

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	precacheMenu( "uiscript_startsingleplayer" );
	precacheMenu( "uiscript_refreshservers" );
	precacheMenu( "uiscript_startserver" );
	precacheMenu( "background_systemlink" );
	
	precacheShader( "black" );
	precacheShader( "white" );
	precacheShader( "gray" );
	precacheShader( "logo_cod2" );
	precacheShader( "xenon_controller_top" );
	precacheShader( "xenon_stick_move" );
	precacheShader( "xenon_stick_move_look" );
	precacheShader( "xenon_stick_move_turn" );
	precacheShader( "xenon_stick_turn" );

	precacheShader( "menu_button" );
	precacheShader( "menu_button_selected" );
	precacheShader( "menu_button_fade" );
	precacheShader( "menu_button_fade_selected" );
	precacheShader( "menu_button_faderight" );
	precacheShader( "menu_button_faderight_selected" );
	precacheShader( "menu_caret_open" );
	precacheShader( "menu_caret_closed" );
	
/*	thread initThumbstickLayout();
	thread initButtonLayout();
	thread initSensitivity();
	thread initInversion();
	thread initAutoaim();
	thread initVibration();*/
	thread initMap();
	thread initGametype();
	
	// threads waiting for events
	thread initEventQuickMatch();
	thread initEventPrivateMatch();
	thread initEventCreateParty();

	level.menuStack = [];

	//level.emptyMenu = createMenu( "empty" );
	systemlinkMenu = createMenu( "systemlink" );
	
	splitscreenMenu = createMenu( "splitscreen" );
	splitscreenMenu addButton( &"MENU_PLACEHOLDER" );	
	splitscreenMenu.actionB = setupActionB( ::popMenu );
	
	createamodeMenu = createMenu( "createamode" );
	createamodeMenu addButton( &"MENU_PLACEHOLDER" );	
	createamodeMenu.actionB = setupActionB( ::popMenu );
	
	controlsMenu = createMenu( "controls", 80, 40, 420, 20 );
	controlsMenu.actionB = setupActionB( ::popMenu );
	//controlsMenu addText( &"MENU_DEFAULT", 0, 0, 3 );
	controlsMenu addImage( "xenon_controller_top", 218, 112, 300, 300 );

	thumbstickSetting = controlsMenu addSetting( &"MENU_THUMBSTICK_LAYOUT", undefined, undefined, "gpad_sticksConfig" );
	value = thumbstickSetting addValue( &"MENU_DEFAULT", "thumbstick_default", true );
	value addImage( "xenon_stick_move", 247, 197, 100, 100);
	value addImage( "xenon_stick_turn", 352, 238, 100, 100);
	value addText( &"MENU_MOVE_FORWARD", 250, 177, 1.5);
	value addText( &"MENU_MOVE_BACK", 172, 237, 1.5);
	value = thumbstickSetting addValue( &"MENU_SOUTHPAW", "thumbstick_southpaw" );
	value addImage( "xenon_stick_turn", 247, 197, 100, 100);
	value addImage( "xenon_stick_move", 352, 238, 100, 100);
	value = thumbstickSetting addValue( &"MENU_LEGACY", "thumbstick_legacy" );
	value addImage( "xenon_stick_move_turn", 247, 197, 100, 100);
	value addImage( "xenon_stick_move_look", 352, 238, 100, 100);
	//value addText( &"MENU_STRAFE_LEFT_RIGHT", 247, 197, 1.5);
	value = thumbstickSetting addValue( &"MENU_LEGACY_SOUTHPAW", "thumbstick_legacysouthpaw" );
	value addImage( "xenon_stick_move_look", 247, 197, 100, 100);
	value addImage( "xenon_stick_move_turn", 352, 238, 100, 100);

	buttonsSetting = controlsMenu addSetting( &"MENU_BUTTON_LAYOUT", undefined, undefined, "gpad_buttonsConfig" );
	value = buttonsSetting addValue( &"MENU_DEFAULT", "buttons_default", true );
	//value addImage( "logo_cod2", 0, 0, 256, 128);
	value = buttonsSetting addValue( &"MENU_EXPERIMENTAL", "buttons_experimental" );
	//value addImage( "black", 0, 0, 256, 128);
	value = buttonsSetting addValue( &"MENU_LEFTY", "buttons_lefty" );
	//value addImage( "white", 0, 0, 256, 128);
	value = buttonsSetting addValue( &"MENU_FINEST_HOUR", "buttons_finesthour" );
	//value addImage( "gray", 0, 0, 256, 128);
	
	sensitivitySetting = controlsMenu addSetting( &"MENU_LOOK_SENSITIVITY", undefined, undefined, "input_viewSensitivity" );
	value = sensitivitySetting addValue( &"MENU_LOW", "0.8" );
	value = sensitivitySetting addValue( &"MENU_MEDIUM", "1", true );
	value = sensitivitySetting addValue( &"MENU_HIGH", "1.8" );
	value = sensitivitySetting addValue( &"MENU_VERY_HIGH", "4" );

	invertpitchSetting = controlsMenu addSetting( &"MENU_LOOK_INVERSION", undefined, undefined, "input_invertpitch" );
	value = invertpitchSetting addValue( &"MENU_DISABLED", "0", true );
	value = invertpitchSetting addValue( &"MENU_ENABLED", "1" );

	autoaimSetting = controlsMenu addSetting( &"MENU_AUTOAIM", undefined, undefined, "input_autoAim" );
	value = autoaimSetting addValue( &"MENU_DISABLED", "0" );
	value = autoaimSetting addValue( &"MENU_ENABLED", "1", true );

	//rumbleSetting = controlsMenu addSetting( &"MENU_CONTROLLER_VIBRATION", undefined, undefined, "gpad_rumble" );
	//value = rumbleSetting addValue( &"MENU_DISABLED", "0" );
	//value = rumbleSetting addValue( &"MENU_ENABLED", "1", true );


	quickmatchMenu = createMenu( "quickmatch" );
	quickmatchMenu addButton( &"MENU_PLACEHOLDER" );	
	quickmatchMenu.actionB = setupActionB( ::popMenu );
	quickmatchMenu.actionB.event = "quickmatch_closed";

	custommatchMenu = createMenu( "custommatch" );
	custommatchMenu addButton( &"MENU_PLACEHOLDER" );	
	custommatchMenu.actionB = setupActionB( ::popMenu );

	privatematchMenu = createMenu( "privatematch" );
	privatematchMenu addButton( &"MENU_PLACEHOLDER" );	
	privatematchMenu.actionB = setupActionB( ::popMenu );
	privatematchMenu.actionB.event = "privatematch_closed";

	createpartyMenu = createMenu( "createparty" );
	createpartyMenu addButton( &"MENU_PLACEHOLDER" );	
	createpartyMenu.actionB = setupActionB( ::popMenu );
	createpartyMenu.actionB.event = "createparty_closed";

	mainMenu = createMenu( "main", 80, 100, 120, 20 );
	mainMenu addImage( "logo_cod2", 0, 24, 288, 72);
	xboxliveSubMenu = mainMenu addSubMenu( &"MENU_XBOX_LIVE", "xboxlive" );
	xboxliveSubMenu.actionB = setupActionB( ::popMenu );
		quickmatchButton = xboxliveSubMenu addButton( &"MENU_QUICK_MATCH" );
		quickmatchButton.actionA = setupActionA( ::pushMenu, quickmatchMenu );
		quickmatchButton.actionA.event = "quickmatch_opened";
		custommatchButton = xboxliveSubMenu addButton( &"MENU_CUSTOM_MATCH" );
		custommatchButton.actionA = setupActionA( ::pushMenu, custommatchMenu );
		privatematchButton = xboxliveSubMenu addButton( &"MENU_PRIVATE_MATCH" );
		privatematchButton.actionA = setupActionA( ::pushMenu, privatematchMenu );
		privatematchButton.actionA.event = "privatematch_opened";
		createpartyButton = xboxliveSubMenu addButton( &"MENU_CREATE_PARTY" );
		createpartyButton.actionA = setupActionA( ::pushMenu, createpartyMenu );
		createpartyButton.actionA.event = "createparty_opened";
		xboxliveSubMenu addButton( &"MENU_ONLINE_STATS" );
	splitscreenButton = mainMenu addButton( &"MENU_SPLIT_SCREEN" );
	splitscreenButton.actionA = setupActionA( ::blah, systemlinkMenu );
	
	systemlinkButton = mainMenu addButton( &"MENU_SYSTEM_LINK" );
	systemlinkButton.actionA = setupActionA( ::blah, systemlinkMenu );
	settingsSubMenu = mainMenu addSubMenu( &"MENU_SETTINGS", "settings" );
	settingsSubMenu.actionB = setupActionB( ::popMenu );
		controlsButton = settingsSubMenu addButton( &"MENU_CONTROLS" );
		controlsButton.actionA = setupActionA( ::pushMenu, controlsMenu );
		createamodeButton = settingsSubMenu addButton( &"MENU_CREATEAMODE" );
		createamodeButton.actionA = setupActionA( ::pushMenu, createamodeMenu );
		settingsSubMenu addButton( &"MENU_SAVE_DEVICE" );
	singleplayerButton = mainMenu addButton( &"MENU_SINGLE_PLAYER" );
	singleplayerButton.actionA = setupActionA( ::startSingleplayer );

	level.gamesetupMenu = createMenu( "gamesetup", 80, 100, 120, 20 );
	button = level.gamesetupMenu addButton( &"MENU_START_GAME" );
	button.actionA = setupActionA( ::startServer );

	/*setting = spawnStruct();
	setting.index = 0;
	setting.dvar = "ui_mapname";
	setting.value[0] = "mp_argun";
	setting.value[1] = "mp_backlot";
	setting.value[2] = "mp_cellblock";
	setting.value[3] = "mp_citystreets";
	setting.value[4] = "mp_convoy";
	setting.value[5] = "mp_crash";
	setting.value[6] = "mp_dusk";
	setting.value[7] = "mp_facility";
	setting.value[8] = "mp_mansion";
	setting.value[9] = "mp_palace";
	setting.value[10] = "mp_shipment";
	setting.value[11] = "mp_strike";
	setting.displaytext[0] = &"MPUI_ARGUN";
	setting.displaytext[1] = &"MPUI_BACKLOT";
	setting.displaytext[2] = &"MPUI_CELLBLOCK";
	setting.displaytext[3] = &"MPUI_CITYSTREETS";
	setting.displaytext[4] = &"MPUI_CONVOY";
	setting.displaytext[5] = &"MPUI_CRASH";
	setting.displaytext[6] = &"MPUI_DUSK";
	setting.displaytext[7] = &"MPUI_FACILITY";
	setting.displaytext[8] = &"MPUI_MANSION";
	setting.displaytext[9] = &"MPUI_PALACE";
	setting.displaytext[10] = &"MPUI_SHIPMENT";
	setting.displaytext[11] = &"MPUI_STRIKE";
	level.gamesetupMenu addSetting( &"MENU_MAP", undefined, undefined, setting );

	setting = spawnStruct();
	setting.index = 0;
	setting.dvar = "ui_gametype";
	setting.value[0] = "war";
	setting.value[1] = "dom";
	setting.value[2] = "sab";
	setting.value[3] = "sd";
	setting.displaytext[0] = &"MPUI_WAR";
	setting.displaytext[1] = &"MPUI_DOMINATION";
	setting.displaytext[2] = &"MPUI_SABOTAGE";
	setting.displaytext[3] = &"MPUI_SEARCH_AND_DESTROY";	
	level.gamesetupMenu addSetting( &"MENU_GAME_TYPE1", undefined, undefined, setting );

	level.gamesetupMenu addButton( &"MENU_QUICK_OPTIONS" );*/
	
	pushMenu( mainMenu );
	createBars();
	createNavButtons();

	for ( ;; )
	{
		while(!isdefined(level.player))
			wait .05;

		level.player openMenu("background_main");
		level.player thread menuResponse();

		while(isdefined(level.player))
			wait .05;
	}
}

startSingleplayer()
{
	level.player openMenu( "uiscript_startsingleplayer" );
}

refreshServers()
{
	level.player openMenu( "uiscript_refreshservers" );
}

startServer()
{
	level.player openMenu( "uiscript_startserver" );
}


pushMenu( menuDef )
{
	level.menuStack[level.menuStack.size] = menuDef;

	oldMenu = level.curMenu;
	level.curMenu = menuDef;

	if ( menuDef.type == "fullScreen" )
	{
		if ( isDefined( oldMenu ) )
			oldMenu thread hideMenu( 0.2, true );

		menuDef thread showMenu( 0.2, true );	
		level notify ( "open_menu", level.curMenu.name );
	}
	else
	{
		menuDef thread expandMenu( 0.2 );
	}
	
	if(isdefined(level.player))	// TEMP, this will script error if not included because the player is undefined when this runs the first time
		level.player playsound("mouse_click");
}


popMenu()
{
	if ( level.menuStack.size == 1 )
		return;

	level.menuStack[level.menuStack.size - 1] = undefined;
	oldMenu = level.curMenu;
	level.curMenu = level.menuStack[level.menuStack.size - 1];
	
	if ( oldMenu.type == "subMenu" )
	{
		oldMenu thread collapseMenu( 0.2 );
		level.curMenu updateMenu( 0.2, true );
	}
	else
	{
		oldMenu thread hideMenu( 0.2, false );
		level.curMenu thread showMenu( 0.2, false );
		level notify ( "close_menu", level.menuStack.size );
	}
	
	level.player playsound("mouse_click");
}


createMenu( name, xPos, yPos, itemWidth, itemHeight )
{
	if(!isdefined(xPos))
		xPos = 80;
	if(!isdefined(yPos))
		yPos = 100;
	if(!isdefined(itemWidth))
		itemWidth = 120;
	if(!isdefined(itemHeight))
		itemHeight = 20;
	
	menuDef = spawnStruct();
	menuDef.name = name;
	menuDef.type = "fullScreen";
	menuDef.itemDefs = [];
	menuDef.itemWidth = itemWidth;
	menuDef.itemHeight = itemHeight;
	menuDef.itemPadding = 0;
	menuDef.selectedIndex = 0;
	menuDef.xPos = xPos;
	menuDef.yPos = yPos;
	menuDef.xOffset = 0;
	menuDef.yOffset = 0;
	menuDef.decorations = [];

	//menuDef.buttonA = undefined;
	//menuDef.buttonB = undefined;
	//menuDef.buttonX = undefined;
	//menuDef.buttonY = undefined;
	
	return menuDef;
}


createSubMenu( name, itemWidth, itemHeight )
{
	if(!isdefined(itemWidth))
		itemWidth = 120;
	if(!isdefined(itemHeight))
		itemHeight = 20;

	subMenuDef = spawnStruct();
	subMenuDef.name = name;
	subMenuDef.type = "subMenu";
	subMenuDef.itemDefs = [];
	subMenuDef.itemWidth = itemWidth;
	subMenuDef.itemHeight = itemHeight;
	subMenuDef.itemPadding = 0;
	subMenuDef.selectedIndex = 0;
	subMenuDef.isExpanded = false;
	
	return subMenuDef;
}


createBars()
{
/*	level.topbar = createServerIcon( "gray", 854, 64 );
	level.topbar setPoint( "TOPLEFT", "TOPLEFT", -64, -72 );
	level.topbar setPoint( "TOPLEFT", "TOPLEFT", -64, -36, 2 );`

	level.bottombar = createServerIcon( "gray", 854, 64 );
	level.bottombar setPoint( "BOTTOMLEFT", "BOTTOMLEFT", -64, 72 );
	level.bottombar setPoint( "BOTTOMLEFT", "BOTTOMLEFT", -64, 36, 2 );*/

	level.topbar = createServerIcon( "gray", 854, 240 );
	level.topbar setPoint( "TOPLEFT", "TOPLEFT", -64, -36 );
	level.topbar setPoint( "TOPLEFT", "TOPLEFT", -64, -212, 2 );

	level.bottombar = createServerIcon( "gray", 854, 240 );
	level.bottombar setPoint( "BOTTOMLEFT", "BOTTOMLEFT", -64, 36 );
	level.bottombar setPoint( "BOTTOMLEFT", "BOTTOMLEFT", -64, 212, 2 );
}

createNavButtons()
{
	// menu can trigger text change per navbutton
	// menu can trigger show/hide per navbutton

	//level.nav_a = createServerFontString( "default", 1.5 );
	//level.nav_a setText( "@PLATFORM_SELECT" );
	//level.nav_b = createServerFontString( "default", fontScale, team )
	//level.nav_x = createServerFontString( "default", fontScale, team )
	//level.nav_y = createServerFontString( "default", fontScale, team )
}

addButton( text, event, description )
{
	precacheString(text);

	itemDef = spawnStruct();
	itemDef.type = "button";	
	itemDef.bgShader = "menu_button_selected";
	itemDef.fgText = text;
	itemDef.xPos = 0;
	itemDef.yPos = 0;
	itemDef.xOffset = 0;
	itemDef.yOffset = 0;
	itemDef.event = event;
	itemDef.description = description;
	itemDef.parentDef = self;
	itemDef.index = self.itemDefs.size;

	self.itemDefs[self.itemDefs.size] = itemDef;
	
	return itemDef;
}


addSetting( text, event, description, dvar )
{
	precacheString(text);

	itemDef = spawnStruct();
	itemDef.type = "setting";	
	itemDef.bgShader = "menu_button_selected";
	itemDef.fgText = text;
	itemDef.xPos = 0;
	itemDef.yPos = 0;
	itemDef.xOffset = 0;
	itemDef.yOffset = 0;
	itemDef.event = event;
	itemDef.description = description;
	itemDef.parentDef = self;
	itemDef.dvar = dvar;
	itemDef.values = [];
	itemDef.index = self.itemDefs.size;

	self.itemDefs[self.itemDefs.size] = itemDef;
	
	return itemDef;
}


addValue( text, dvarValue, setdefault, name )
{
	value = spawnStruct();
	value.text = text;
	value.dvarValue = dvarValue;
	value.decorations = [];
	value.name = name; // TEMP for testing

	if ( isdefined ( setdefault ) )
		self.settingIndex = self.values.size;

	if ( !isdefined ( self.settingIndex ) )
		self.settingIndex = 0;

	self.values[self.values.size] = value;

	return value;
}


addSubMenu( text, name, itemWidth, itemHeight )
{
	itemDef = createSubMenu(name, itemWidth, itemHeight);
	itemDef.type = "subMenu";
	itemDef.bgShader = "menu_button_selected";
	itemDef.fgText = text;
	itemDef.xPos = 0;
	itemDef.yPos = 0;
	itemDef.xOffset = 20;
	itemDef.yOffset = (self.itemHeight + self.itemPadding) ;
	itemDef.parentDef = self;
	itemDef.index = self.itemDefs.size;

	self.itemDefs[self.itemDefs.size] = itemDef;

	return itemDef;
}


addText( text, xPos, yPos, textSize )
{
	if ( !isdefined ( xPos ) )
		xPos = 0;
	if ( !isdefined ( yPos ) )
		yPos = 0;
	if ( !isdefined ( textSize ) )
		textSize = 1.5;

	decoration = spawnStruct();
	decoration.type = "text";
	decoration.fgText = text;
	decoration.xPos = xPos;
	decoration.yPos = yPos;
	decoration.textSize = textSize;
	//decoration.width = width;
	//decoration.height = height;
	//decoration.xOffset = xOffset;
	//decoration.yOffset = yOffset;
	decoration.parentDef = self;
	//decoration.index = self.decoration.size;

	self.decorations[self.decorations.size] = decoration;
}


addImage( image, xPos, yPos, width, height )
{
	if ( !isdefined ( xPos ) )
		xPos = 0;
	if ( !isdefined ( yPos ) )
		yPos = 0;

	decoration = spawnStruct();
	decoration.type = "image";	
	decoration.image = image;
	decoration.xPos = xPos;
	decoration.yPos = yPos;
	decoration.width = width;
	decoration.height = height;
	//decoration.color = color;
	//decoration.xOffset = xOffset;
	//decoration.yOffset = yOffset;
	decoration.parentDef = self;
	//decoration.index = self.decoration.size;

	self.decorations[self.decorations.size] = decoration;
}


createItemElems()
{
	if(self.type != "image")
	{
		self.bgIcon = createServerIcon( self.bgShader, self.parentDef.itemWidth, self.parentDef.itemHeight );
		self.bgIcon.alpha = 0;
		self.bgIcon.sort = 0;

		self.fontString = createServerFontString( "default", 1.5 );
		self.fontString.alpha = 0;
		self.fontString.sort = 100;
		self.fontString setText( self.fgText );
	}

	/*if ( self.type == "image" )
	{
		self.settingTextValue = createServerIcon( self.image, self.width, self.height, undefined, self.color );
		self.settingTextValue.alpha = 1;
		self.settingTextValue.sort = 100;
	}*/

	if ( self.type == "setting" )
	{
		self.settingTextValue = createServerFontString( "default", 1.5 );
		self.settingTextValue.alpha = 0;
		self.settingTextValue.sort = 100;
		self updateDisplayTextValue();

		self createValueElems();
		self updateValueElems();
	}
	
	if ( self.type == "subMenu" )
	{
		//self.caretIcon = createServerIcon( "menu_caret_closed", self.parentDef.itemHeight, self.parentDef.itemHeight );	
		//self.caretIcon.alpha = 0;
		//self.caretIcon.sort = 100;
	}

	if ( isdefined ( self.description ) )
	{
		self.descriptionValue = createServerFontString( "default", 1.5 );
		self.descriptionValue.alpha = 0;
		self.descriptionValue.sort = 100;
		self.descriptionValue setText( self.description.displaytext );
	}
}


createMenuElems()
{
	if(self.type == "text")
	{
		self.fontString = createServerFontString( "default", self.textSize );
		self.fontString.alpha = 0;
		self.fontString.sort = 100;
		self.fontString setText( self.fgText );
	}

	if(self.type == "image")
	{
		self.bgIcon = createServerIcon( self.image, self.width, self.height );
		self.bgIcon.alpha = 0;
		self.bgIcon.sort = 0;
	}
}


createValueElems()
{
	println( "^6createValueElems ", self.name );

	if ( isdefined ( self.values ) )
	{
		for ( i = 0; i < self.values.size; i++ )
		{
			if ( isdefined ( self.values[i].decorations ) )
			{
				decorations = self.values[i].decorations;
				
				for ( j = 0; j < decorations.size; j++ )
				{
					decoration = decorations[j];

					if(decoration.type == "text")
					{
						decoration.fontString = createServerFontString( "default", decoration.textSize );
						decoration.fontString.alpha = 0;
						decoration.fontString.sort = 100;
						decoration.fontString setText( decoration.fgText );
						
						println( "^6	TEXT: ", decoration.text );
					}

					if(decoration.type == "image")
					{
						decoration.bgIcon = createServerIcon( decoration.image, decoration.width, decoration.height );
						decoration.bgIcon.alpha = 0;
						decoration.bgIcon.sort = 100;
						
						println( "^6	IMAGE: ", decoration.image );
					}

					decoration setPointValueElems( "TOPLEFT", "TOPLEFT", decoration.xPos, decoration.yPos );
				}
			}
		}
	}
}


destroyItemElems()
{
	//if ( self.type == "image" )
		//self.caretIcon destroyElem();

	//if ( self.type == "subMenu" )
		//self.caretIcon destroyElem();

	if ( self.type == "setting" )
	{
		if ( isdefined ( self.settingTextValue ) )
			self.settingTextValue destroyElem();
			
		if ( isdefined ( self.settingImageValue ) )
			self.settingImageValue destroyElem();

		self destroyValueElems();
	}

	if ( isdefined ( self.descriptionValue ) )
		self.descriptionValue destroyElem();

	self.bgIcon destroyElem();
	self.fontString destroyElem();
}		


destroyMenuElems()
{
	if ( isdefined ( self.fontString ) )
		self.fontString destroyElem();

	if ( isdefined ( self.bgIcon ) )
		self.bgIcon destroyElem();
}


destroyValueElems()
{
	println( "^5destroyValueElems ", self.name );

	if ( isdefined ( self.values) && isdefined ( self.values[self.settingIndex].decorations ) )
	{
		for ( index = 0; index < self.values[self.settingIndex].decorations.size; index++ )
		{
			decoration = self.values[self.settingIndex].decorations[index];
			
			if ( isdefined ( decoration.fontString ) )
			{
				println( "^5	TEXT: ", decoration.text );
				decoration.fontString destroyElem();
			}
			
			if ( isdefined ( decoration.bgIcon ) )
			{
				println( "^5	IMAGE: ", decoration.image );
				decoration.bgIcon destroyElem();
			}
		}
	}
}


setPointItemElems( point, relativePoint, xPos, yPos, transTime )
{
	xOffset = 3;

	if ( self.type != "image" )
	{
		self.bgIcon setPoint( point, relativePoint, xPos, yPos, transTime );
		self.fontString setPoint( point, relativePoint, xPos + xOffset, yPos, transTime );
	}

	if ( self.type == "image" )
		self.settingTextValue setPoint( point, relativePoint, xPos, yPos, transTime );


	if ( self.type == "subMenu" )
	{
		//self.caretIcon setPoint( point, relativePoint, xPos, yPos, transTime );
		xOffset += 16;
	}

	if ( self.type == "setting" )
	{
		if ( isdefined ( self.settingTextValue ) )
			self.settingTextValue setPoint( "TOPRIGHT", relativePoint, xPos + xOffset + 400, yPos, transTime );
		
		if ( isdefined ( self.settingImageValue ) )
			self.settingImageValue setPoint( "CENTER", "CENTER", 0, 60, transTime );
	}

	if ( isdefined ( self.descriptionValue ) )
	{
		self.descriptionValue setPoint( "TOPLEFT", relativePoint, self.description.xPos, self.description.yPos, transTime );
	}
}


setPointMenuElems( point, relativePoint, xPos, yPos, transTime )
{
	if ( isdefined ( self.fontString ) )
		self.fontString setPoint( point, relativePoint, xPos, yPos, transTime );

	if ( isdefined ( self.bgIcon ) )
		self.bgIcon setPoint( point, relativePoint, xPos, yPos, transTime );
}


setPointValueElems( point, relativePoint, xPos, yPos, transTime )
{
	if ( isdefined ( self.fontString ) )
		self.fontString setPoint( point, relativePoint, xPos, yPos, transTime );

	if ( isdefined ( self.bgIcon ) )
		self.bgIcon setPoint( point, relativePoint, xPos, yPos, transTime );
}


showMenu( transTime, isNew )
{
	println( "^3showMenu ", self.name );
	
	yOffset = 0;
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];
		itemDef createItemElems();

		if ( isNew )
			itemDef setPointItemElems( "TOPLEFT", "TOPRIGHT", self.xPos, self.yPos + yOffset );
		else
			itemDef setPointItemElems( "TOPRIGHT", "TOPLEFT", self.xPos, self.yPos + yOffset );

		itemDef.xPos = self.xPos;
		itemDef.yPos = self.yPos + yOffset;

		yOffset += (self.itemHeight + self.itemPadding);
		
		if ( itemDef.type == "subMenu" && itemDef.isExpanded )
		{
			yOffset += itemDef getMenuHeight();
//			itemDef thread showMenu( transTime, isNew );
		}
	}

	if ( isdefined ( self.decorations ) )
	{
		for ( index = 0; index < self.decorations.size; index++ )
		{
			decoration = self.decorations[index];
			decoration createMenuElems();
			decoration setPointMenuElems( "TOPLEFT", "TOPLEFT", decoration.xPos, decoration.yPos );
		}
	}

	if ( self.type == "subMenu" )
		self.parentDef showMenu( transTime, isNew );
			
	self updateMenu( transTime, true );
}


hideMenu( transTime, isNew )
{
	println( "^3hideMenu ", self.name );
	
	yOffset = 0;
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];

		xOffset = -1 * self.itemWidth;

		if ( isNew )
		{
			itemDef setPointItemElems( "TOPRIGHT", "TOPLEFT", self.xPos, self.yPos + yOffset, transTime );
			itemDef.bgIcon fadeOverTime( transTime );
			itemDef.bgIcon.alpha = 0;
			itemDef.fontString fadeOverTime( transTime );
			itemDef.fontString.alpha = 0;			

			if ( itemDef.type == "setting" )
			{
				itemDef.settingTextValue fadeOverTime( transTime );
				itemDef.settingTextValue.alpha = 0;
				
				itemDef.settingImageValue fadeOverTime( transTime );
				itemDef.settingImageValue.alpha = 0;
			}

			if ( itemDef.type == "subMenu" )
			{
				//itemDef.caretIcon fadeOverTime( transTime );
				//itemDef.caretIcon.alpha = 0;
			}
		}
		else
		{
			itemDef setPointItemElems( "TOPLEFT", "TOPRIGHT", self.xPos, self.yPos + yOffset, transTime );
			itemDef.bgIcon fadeOverTime( transTime );
			itemDef.bgIcon.alpha = 0;
			itemDef.fontString fadeOverTime( transTime );
			itemDef.fontString.alpha = 0;			

			if ( itemDef.type == "setting" )
			{
				if ( isdefined ( itemDef.settingTextValue ) )
				{
					itemDef.settingTextValue fadeOverTime( transTime );
					itemDef.settingTextValue.alpha = 0;
				}
				
				if ( isdefined ( itemDef.settingImageValue ) )
				{
					itemDef.settingImageValue fadeOverTime( transTime );
					itemDef.settingImageValue.alpha = 0;
				}
			}

			if ( itemDef.type == "subMenu" )
			{
				//itemDef.caretIcon fadeOverTime( transTime );
				//itemDef.caretIcon.alpha = 0;
			}
		}

		itemDef.xPos = self.xPos;
		itemDef.yPos = self.yPos + yOffset;

		yOffset += (self.itemHeight + self.itemPadding);
		
		if ( itemDef.type == "subMenu" && itemDef.isExpanded )
		{
			yOffset += itemDef getMenuHeight();
//			itemDef thread hideMenu( transTime, isNew );
		}
	}
	
	if ( self.type == "subMenu" )
		self.parentDef thread hideMenu( transTime, isNew );
	
	wait transTime;
	
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];
		itemDef destroyItemElems();
	}	

	if ( isdefined ( self.decorations ) )
	{
		for ( index = 0; index < self.decorations.size; index++ )
		{
			decoration = self.decorations[index];
			decoration destroyMenuElems();
		}	
	}
}


collapseMenu( transTime )
{
	println( "^3collapseMenu ", self.name );
	
	self.isExpanded = false;
	//self.caretIcon setShader( "menu_caret_closed", self.parentDef.itemHeight, self.parentDef.itemHeight );

	yOffset = 0;
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];

		itemDef setPointItemElems( "TOPLEFT", "TOPLEFT", self.xPos, self.yPos, transTime );
		itemDef.bgIcon fadeOverTime( transTime );
		itemDef.bgIcon.alpha = 0;
		itemDef.fontString fadeOverTime( transTime );
		itemDef.fontString.alpha = 0;

		if ( itemDef.type == "subMenu" )
		{
			//itemDef.caretIcon fadeOverTime( transTime );
			//itemDef.caretIcon.alpha = 0;
		}
		
		itemDef.xPos = self.xPos;
		itemDef.yPos = self.yPos;
	}
	
	wait transTime;
	
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];
		
		itemDef.bgIcon destroyElem();
		itemDef.fontString destroyElem();
		
		//if ( itemDef.type == "subMenu" )	
			//itemDef.caretIcon destroyElem();
	}
}


expandMenu( transTime )
{
	println( "^3expandMenu ", self.name );
	
	self.isExpanded = true;
	//self.caretIcon setShader( "menu_caret_open", self.parentDef.itemHeight, self.parentDef.itemHeight );
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];

		itemDef createItemElems();

		itemDef setPointItemElems( "TOPLEFT", "TOPLEFT", self.xPos + self.xOffset, self.yPos + self.yOffset );
		
		itemDef.xPos = self.xPos + self.xOffset;
		itemDef.yPos = self.yPos + self.yOffset;
	}
	self updateMenu( transTime, true );
}


updateMenu( transTime, forceRedraw )
{
	println( "^3updateMenu ", self.name );
	
	xOffset = self.xOffset;
	yOffset = self.yOffset;

	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];
		itemDef setSelected( transTime, index == self.selectedIndex );

		lastXPos = itemDef.xPos;
		lastYPos = itemDef.yPos;

		if ( forceRedraw || (self.xPos + xOffset != lastXPos) || (self.yPos + yOffset != lastYPos) )
		{
			itemDef setPointItemElems( "TOPLEFT", "TOPLEFT", self.xPos + xOffset, self.yPos + yOffset, transTime );
	
			itemDef.xPos = self.xPos + xOffset;
			itemDef.yPos = self.yPos + yOffset;
		}

		yOffset += (self.itemHeight + self.itemPadding);

		if ( itemDef.type == "subMenu" && itemDef.isExpanded )
		{
			assert( level.curMenu != self );
			yOffset += itemDef getMenuHeight();
		}
	}

	if ( isDefined ( self.parentDef ) )
		self.parentDef thread updateMenu( transTime, forceRedraw );
		
	if ( isdefined ( self.decorations ) )
	{
		for ( index = 0; index < self.decorations.size; index++ )
		{
			decoration = self.decorations[index];
			decoration setElemAlpha( 1 );
		}
	}
}


setSelected( transTime, isSelected )
{
	if ( isdefined( self.bgIcon ) )
		self.bgIcon fadeOverTime( transTime );
	
	if ( isdefined( self.fontString ) )
		self.fontString fadeOverTime( transTime );
	
	if ( isdefined( self.settingTextValue ) )
		self.settingTextValue fadeOverTime( transTime );

	if ( isdefined( self.settingImageValue ) )
		self.settingImageValue fadeOverTime( transTime );

	if ( isdefined( self.descriptionValue ) )
		self.descriptionValue fadeOverTime( transTime );
	
	/*
	self setElemAlpha( 0.85 );
	if ( isSelected )
	{
		if ( self.parentDef == level.curMenu )
			self setElemColor( (1,1,1) );
		else
			self setElemColor( (0.85,0.85,0.85) );
	}
	else
	{
		if ( self.parentDef == level.curMenu )
			self setElemColor( (0.75,0.75,0.75) );
		else
			self setElemColor( (0.5,0.5,0.5) );
	}
	*/

	if ( isSelected )
	{
		if ( self.parentDef == level.curMenu )
			self setElemAlpha( 1 );
		else
			self setElemAlpha( 0.5 );

		if ( isdefined ( self.descriptionValue ) )
			self.descriptionValue.alpha = 1;

		// if this item is a setting
		//		set all value elems to alpha 0 except the current, set it 1 
		
		//for all values
		//	for all value decorations
		//		if this value is current, set alpha 1
		//		else set alpha 0
		
		// && isdefined ( self.values[self.settingIndex].decorations ) 
		/*if ( isdefined ( self.values ) )
		{
			for ( i = 0; i < self.values.size; i++ )
			{
				if ( isdefined ( self.values[i].decorations ) )
				{
					decorations = self.values[i].decorations;
					
					for ( j = 0; j < decorations.size; j++ )
					{
						if ( self.values[i] == self.values[self.settingIndex] )
							decorations[j] setElemAlpha( 1 );
						else
							decorations[j] setElemAlpha( 0 );
					}
				}
			}
		}*/
	}
	else
	{
		if ( self.parentDef == level.curMenu )
			self setElemAlpha( 0.5 );
		else
			self setElemAlpha( 0.25 );

		if ( isdefined ( self.descriptionValue ) )
			self.descriptionValue.alpha = 0;

		/*if ( isdefined ( self.values ) )
		{
			for ( i = 0; i < self.values.size; i++ )
			{
				if ( isdefined ( self.values[i].decorations ) )
				{
					decorations = self.values[i].decorations;
					
					for ( j = 0; j < decorations.size; j++ )
					{
							decorations[j] setElemAlpha( 0 );
					}
				}
			}
		}*/
	}
	
	// NOTE, just update the value elems for the selected?
	self updateValueElems();
}


setElemAlpha( alpha )
{
	if ( isdefined ( self.bgIcon ) )
		self.bgIcon.alpha = alpha;
	
	if ( isdefined ( self.fontString ) )
		self.fontString.alpha = alpha;
	
	if ( self.type == "setting" )
	{
		if ( isdefined ( self.settingTextValue ) )
			self.settingTextValue.alpha = alpha;

		if ( isdefined ( self.settingImageValue ) )
		{
			if ( alpha == 0.5 )
				self.settingImageValue.alpha = 0;
			else
				self.settingImageValue.alpha = alpha;
		}
	}
	
	//if ( self.type == "subMenu" )
		//self.caretIcon.alpha = alpha;	

//	if ( isdefined ( self.descriptionValue ) )
//		self.descriptionValue.alpha = alpha;
}


setElemColor( color )
{
	self.fontString.color = color;
}


getMenuHeight()
{
	menuHeight = 0;
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];
		menuHeight += (self.itemHeight + self.itemPadding);
		
		if ( itemDef.type == "subMenu" && itemDef.isExpanded )
			menuHeight += itemDef getMenuHeight();
	}
	
	return menuHeight;
}


onDPadUp()
{
	self.selectedIndex--;
	
	if ( self.selectedIndex	< 0 )
		self.selectedIndex = self.itemDefs.size - 1;
		
	self updateMenu( 0.1, false );
	
	level.player playsound("mouse_over");
}


onDPadDown()
{
	self.selectedIndex++;
	
	if ( self.selectedIndex	>= self.itemDefs.size )
		self.selectedIndex = 0;
		
	self updateMenu( 0.1, false );
	
	level.player playsound("mouse_over");
}


onDPadLeft()
{
	focusedItem = self.itemDefs[self.selectedIndex];
	
	if ( focusedItem.type == "setting" )
	{
		dvarCurrent = getdvar( focusedItem.dvar );
		dvarValues = focusedItem.values;
		
		indexNew = 0;
		for ( i = 0; i < dvarValues.size; i++ )
		{
		    dvarValue = dvarValues[i].dvarValue;
		    
		    if(dvarValue != dvarCurrent)
		    	continue;

			indexNew = i - 1;
	
			if(indexNew >= 0)
			{
				focusedItem.settingIndex = indexNew;
				
				setdvar( focusedItem.dvar, dvarValues[indexNew].dvarValue );
				focusedItem updateDisplayTextValue();
				focusedItem updateValueElems();
				println( "Setting: " + focusedItem.dvar + " to " + dvarValues[indexNew].dvarValue );
				level.player playsound("mouse_over");
			}

	    	break;
		}	
	}
}


onDPadRight()
{
	focusedItem = self.itemDefs[self.selectedIndex];
	
	if ( focusedItem.type == "setting" )
	{
		dvarCurrent = getdvar( focusedItem.dvar );
		dvarValues = focusedItem.values;
		
		indexNew = 0;
		for ( i = 0; i < dvarValues.size; i++ )
		{
		    dvarValue = dvarValues[i].dvarValue;
		    
		    if(dvarValue != dvarCurrent)
		    	continue;

			indexNew = i + 1;
	
			if(indexNew <= focusedItem.values.size - 1)
			{
				focusedItem.settingIndex = indexNew;
				
				setdvar( focusedItem.dvar, dvarValues[indexNew].dvarValue );
				focusedItem updateDisplayTextValue();
				focusedItem updateValueElems();
				level.player playsound("mouse_over");
				println( "Setting: " + focusedItem.dvar + " to " + dvarValues[indexNew].dvarValue );
			}

	    	break;
		}	
	}
}


onButtonA()
{
	focusedItem = self.itemDefs[self.selectedIndex];

	if ( focusedItem.type == "subMenu" )
	{
		pushMenu( focusedItem );
	}
	else if ( isdefined ( focusedItem.actionA ) )
	{
		focusedItem thread execActionA();
		println( "^6item action A" );
	}
	else if ( isdefined ( self.actionA ) )
	{
		self thread execActionA();
		println( "^6menu action A" );
	}
	else
	{
		println( "^6undefined action A" );
	}
}


onButtonB()
{
	focusedItem = self.itemDefs[self.selectedIndex];
	
	if ( isdefined ( focusedItem.actionB ) )
	{
		focusedItem thread execActionB();
		println( "^6item action B" );
	}
	else if ( isdefined ( self.actionB ) )
	{
		self thread execActionB();
		println( "^6menu action B" );
	}
	else
	{
		println( "^6undefined action B" );
	}
}


onButtonX()
{
/*	focusedItem = self.itemDefs[self.selectedIndex];
	
	if ( isdefined ( focusedItem.actionX ) )
	{
		focusedItem thread execActionX();
		println( "^6item action X" );
	}
	else if ( isdefined ( self.actionX ) )
	{
		self thread execActionX();
		println( "^6menu action X" );
	}
	else
	{
		println( "^6undefined action X" );
	}*/
}


onButtonY()
{
	/*focusedItem = self.itemDefs[self.selectedIndex];
	
	if ( isdefined ( focusedItem.actionY ) )
	{
		focusedItem thread execActionY();
		println( "^6item action Y" );
	}
	else if ( isdefined ( self.actionY ) )
	{
		self thread execActionY();
		println( "^6menu action Y" );
	}
	else
	{
		println( "^6undefined action Y" );
	}*/
}


initThumbstickLayout()
{
	// update to use the real dvars when code will allow it
	setdvar( "gpad_sticksConfig", "thumbstick_default" );
}

initButtonLayout()
{
	// update to use the real dvars when code will allow it
	setdvar( "gpad_buttonsConfig", "buttons_default" );
}

initSensitivity()
{
	// update to use the real dvars when code will allow it
	setdvar( "input_viewSensitivity", "sensitivity_medium" );
}

initInversion()
{
	// update to use the real dvars when code will allow it
	setdvar( "input_invertpitch", "inversion_disabled" );
}

initAutoAim()
{
	// update to use the real dvars when code will allow it
	setdvar( "input_autoAim", "autoaim_enabled" );
}

initVibration()
{
	// update to use the real dvars when code will allow it
	setdvar( "gpad_rumble", "vibration_enabled" );
}

initMap()
{
	// update to use the real dvars when code will allow it
	setdvar( "ui_mapname", "mp_argun" );
}

initGametype()
{
	// update to use the real dvars when code will allow it
	setdvar( "g_gametype", "war" );
}


updateDisplayTextValue()
{
	if ( isdefined ( self.settingTextValue ) )
		self.settingTextValue setText( self.values[self.settingIndex].text );
}


updateValueElems()
{
	println( "^2updateValueElems ", self.name );

	/*if ( isdefined ( self.decorations ) )
	{
		for ( index = 0; index < self.decorations.size; index++ )
		{
			//decoration = self.decorations[index];
			//decoration setElemAlpha( 1 );
			
			if ( isdefined ( self.text ) )
				println( "^2	TEXT: ", self.text );

			if ( isdefined ( self.image ) )
				println( "^2	IMAGE: ", self.image );
		}
	}*/
	
	if ( self == self.parentDef.itemDefs[self.parentDef.selectedIndex] )
		isSelected = true;
	else
		isSelected = false;

	if ( isSelected )
	{
		// if this item is a setting
		//		set all value elems to alpha 0 except the current, set it 1 
		
		//for all values
		//	for all value decorations
		//		if this value is current, set alpha 1
		//		else set alpha 0
		
		if ( isdefined ( self.values ) )
		{
			for ( i = 0; i < self.values.size; i++ )
			{
				if ( isdefined ( self.values[i].decorations ) )
				{
					decorations = self.values[i].decorations;
					
					for ( j = 0; j < decorations.size; j++ )
					{
						if ( self.values[i] == self.values[self.settingIndex] )
						{	
							/// TESTING
							if ( isdefined ( decorations[j].text ) )
								println( "^2	TEXT: ", decorations[j].text, " set alpha 1" );

							if ( isdefined ( decorations[j].image ) )
								println( "^2	IMAGE: ", decorations[j].image, " set alpha 1" );
							/// TESTING
							
							decorations[j] setElemAlpha( 1 );
						}
						else
						{	
							/// TESTING
							if ( isdefined ( decorations[j].text ) )
								println( "^2	TEXT: ", decorations[j].text, " set alpha 0" );

							if ( isdefined ( decorations[j].image ) )
								println( "^2	IMAGE: ", decorations[j].image, " set alpha 0" );
							/// TESTING

							decorations[j] setElemAlpha( 0 );
						}
					}
				}
			}
		}
	}
	else
	{
		if ( isdefined ( self.values ) )
		{
			for ( i = 0; i < self.values.size; i++ )
			{
				if ( isdefined ( self.values[i].decorations ) )
				{
					decorations = self.values[i].decorations;
					
					for ( j = 0; j < decorations.size; j++ )
					{
							decorations[j] setElemAlpha( 0 );
					}
				}
			}
		}
	}
}


setupActionA(name, arg1, arg2)
{
	actionA = spawnStruct();
	actionA.name = name;
	
	if ( isdefined ( arg1 ) )
		actionA.arg1 = arg1;
	
	if ( isdefined ( arg2 ) )
		actionA.arg2 = arg2;
		
	return actionA;
}


setupActionB(name, arg1, arg2)
{
	actionB = spawnStruct();
	actionB.name = name;
	
	if ( isdefined ( arg1 ) )
		actionB.arg1 = arg1;
	
	if ( isdefined ( arg2 ) )
		actionB.arg2 = arg2;
		
	return actionB;
}


execActionA()
{
	if ( isdefined ( self.actionA ) )
	{
		if ( isdefined ( self.actionA.arg1 ) )
			thread [[self.actionA.name]]( self.actionA.arg1 );
		else
			thread [[self.actionA.name]]();
	}		
	
	if ( isdefined ( self.actionA.event ) )
	{
		level notify ( self.actionA.event );
		println( "^6event ", self.actionA.event );
	}
}


execActionB()
{
	if ( isdefined ( self.actionB ) )
	{
		if ( isdefined ( self.actionB.arg1 ) )
			thread [[self.actionB.name]]( self.actionB.arg1 );
		else
			thread [[self.actionB.name]]();
	}		
	
	if ( isdefined ( self.actionB.event ) )
	{
		level notify ( self.actionB.event );
		println( "^6event ", self.actionB.event );
	}
}


menuResponse()
{
	for ( ;; )
	{
		self waittill( "menuresponse", menu, response );
		println( response );

		switch ( response )
		{
			case "DPAD_UP":
				level.curMenu onDPadUp();
			break;
			case "DPAD_DOWN":
				level.curMenu onDPadDown();
			break;
			case "DPAD_LEFT":
				level.curMenu onDPadLeft();
			break;
			case "DPAD_RIGHT":
				level.curMenu onDPadRight();
			break;
			case "BUTTON_A":
				level.curMenu onButtonA();
			break;
			case "BUTTON_B":
				level.curMenu onButtonB();
			break;
			case "BUTTON_X":
				level.curMenu onButtonX();
			break;
			case "BUTTON_Y":
				level.curMenu onButtonY();
			break;
			case "gamesetup_systemlink":
				gamesetup_systemlink();
			break;
			case "popMenu":
				popMenu();
			break;
		}
	}
}

blah(menu)
{
	pushMenu( menu );
	
	level.player closeMenu();
	level.player closeInGameMenu();

	level.player openMenu("background_systemlink");
}

gamesetup_systemlink()
{
	pushMenu( level.gamesetupMenu );

	level.player closeMenu();
	level.player closeInGameMenu();
	
	level.player openMenu("background_main");
}


initEventQuickMatch()
{
	for ( ;; )
	{
		level waittill( "quickmatch_opened" );
	
		setdvar( "party_timerVisible", 0 );
		setdvar( "xblive_privatematch", 0 );
		searchForOnlineGames();
	
		level waittill( "quickmatch_closed" );
		
		quitLobby();
	}
}

initEventPrivateMatch()
{
	for ( ;; )
	{
		level waittill( "privatematch_opened" );
	
		setdvar( "party_timerVisible", 0 );
		setdvar( "xblive_privatematch", 1 );
		setdvar( "xblive_rankedmatch", 0 );
		startPrivateMatch();
		
		level waittill( "privatematch_closed" );
		
		quitLobby();
	}
}

initEventCreateParty()
{
	for ( ;; )
	{
		level waittill( "createparty_opened" );

		setdvar( "xblive_rankedmatch", 0 );
		startParty();
		
		level waittill( "createparty_closed" );

		quitParty();
	}
}
