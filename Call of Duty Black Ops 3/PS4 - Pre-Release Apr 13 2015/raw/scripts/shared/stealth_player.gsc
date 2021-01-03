#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\cp\sidemissions\_sm_ui;
#using scripts\shared\stealth;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_player;
#using scripts\shared\stealth_tagging;
#using scripts\shared\stealth_debug;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
	            

/*
	STEALTH - Status Indicator system
			
	// =========================================
	//
	// FIXME THIS WHOLE FILE IS PLACE HOLDER
	// 
	// TODO: This should likely be a native client display instead
	// 
	// =========================================
 */



	
#precache( "material", "white_stealth_arrow_01" );
#precache( "material", "white_stealth_arrow_02" );
#precache( "material", "white_stealth_arrow_03" );
#precache( "material", "white_stealth_arrow_04" );
#precache( "material", "white_stealth_arrow_05" );
#precache( "material", "white_stealth_arrow_06" );
#precache( "material", "white_stealth_arrow_07" );
#precache( "material", "white_stealth_arrow_08" );
#precache( "material", "white_stealth_arrow_09" );

#namespace stealth_status;

/@
"Name: init()"
"Summary: Initializes stealth status indication for an entity"
"Module: stealth"
"CallOn: Entity"
"Example: self stealth_status::init();"
@/
function init( )
{
	assert( isDefined( self.stealth ) );
	assert( !isDefined( self.stealth.status ) );

	if(!isdefined(self.stealth.status))self.stealth.status=SpawnStruct();
	
	self.stealth.status.icons = 	[];
	self.stealth.status.icon_ent =	undefined;
	
	self thread clean_icon_on_death();

	self thread status_monitor_thread();
}

/@
"Name: enabled()"
"Summary: returns if this system is enabled on the given object
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: if ( player stealth_status::enabled() )"
"SPMP: singleplayer"
@/
function enabled( )
{
	return IsDefined( self.stealth ) && isDefined( self.stealth.status );
}

/@
"Name: create_stealth_indicator( <str_shader>, <v_origin>, <z_offset>, <forPlayer> )"
"Summary: Creates stealth indicator waypoint for a given ai agent"
"Module: stealth"
"CallOn: Entity"
@/
function create_stealth_indicator( str_shader, v_origin, z_offset, forPlayer )
{
	hud_waypoint = undefined;
	if ( !isDefined( forPlayer ) )
		hud_waypoint = NewHudElem( );
	else
		hud_waypoint = NewClientHudElem( forPlayer );
	hud_waypoint.horzAlign = "right";
	hud_waypoint.vertAlign = "middle";
	hud_waypoint.sort = 2;		
	hud_waypoint SetShader( str_shader, 5, 5 );
	hud_waypoint SetWaypoint( true, str_shader, false, false );
	hud_waypoint.hidewheninmenu = true;
	hud_waypoint.immunetodemogamehudsettings = true;	

	hud_waypoint.x = v_origin[0];
	hud_waypoint.y = v_origin[1];
	hud_waypoint.z = v_origin[2] + z_offset;	
	
	return hud_waypoint;
}

/@
"Name: icon_show( <forPlayer> )"
"Summary: Setup icon for this agent"
"Module: stealth"
"CallOn: Entity"
"Example: ai stealth_status::icons_show( )"
@/
function icon_show( forPlayer )
{
	index = -1;
	if ( isDefined( forPlayer ) )
		index = forPlayer GetEntityNumber();
	
	if ( !isDefined( self.stealth.status.icon_ent ) )
	{
		ent = util::spawn_model( "tag_origin", self.origin + (0, 0, 70), (0, 0, 0) );
		ent LinkTo( self );
		self.stealth.status.icon_ent = ent;
	}

	if ( !isDefined( self.stealth.status.icons[index] ) )
	{						
		icon = create_stealth_indicator( "white_stealth_arrow_01", self.stealth.status.icon_ent.origin, 16, forPlayer );
		icon settargetent( self.stealth.status.icon_ent );	
		self.stealth.status.icons[index] = icon;
	}
}

/@
"Name: status_monitor_thread( )"
"Summary: Updates status display for stealth"
"Module: stealth"
"CallOn: Entity"
"Example: ai thread stealth_status::status_monitor_thread( )"
@/
function status_monitor_thread()
{
	self endon("stop_stealth");
	self endon("death");

	while ( 1 )
	{
		util::waittill_any( "stealth_sight_start", "alert" );

		while ( isAlive( self ) )
		{
			if ( !self stealth_status::update() )
				break;
				
			{wait(.05);};
		}
	}	
}

/@
"Name: shader_for_alert_level( <alertLevel> )"
"Summary: Gets the icon material to use for a given 0 to 1 value"
"Module: stealth"
"Example: shader = stealth_status::shader_for_alert_level( 0.5 );"
@/
function shader_for_alert_level( alertLevel )
{
	if ( alertLevel < 0.0 )
		alertLevel = 0.0;

	if( alertLevel > 1.0 )
		alertLevel = 1.0;

	return "white_stealth_arrow_0" + (1 + int(7 * alertLevel));
}

/@
"Name: update(  )"
"Summary: Updates a single frame of status display for stealth for this entity"
"Module: stealth"
"CallOn: Entity"
"Example: ai stealth_status::update( );"
@/
function update( )
{
	bAnyVisible = false;
	
	playerList = GetPlayers();
	
	foreach ( player in playerList )
	{	
		index = player GetEntityNumber();
		alertThisEnemy = self GetStealthSightValue( player );
		
		awareness =  self stealth_aware::get_awareness();
		bAlerted = awareness == "combat" || awareness == "high_alert";
		bAlertedThisEnemy = bAlerted && isDefined( self.stealth.aware_alerted[index] );
		bCombatThisEnemy = isDefined( self.stealth.aware_combat[index] );
		bAware = alertThisEnemy > 0.0;
		bCanSee = self stealth::can_see( player ) && !self.ignoreall;

		if ( player stealth_player::enabled() )
		{
			player stealth_player::update_audio( bCanSee, awareness );

			if ( bAlertedThisEnemy )
				player stealth_player::inc_detected( self, alertThisEnemy );
			
			// Only give feedback to the player if they could ever actually see them or are currently aware
			if ( isDefined( self.stealth.aware_sighted[index] ) || bAware )
			{
				if ( bAlertedThisEnemy || bCombatThisEnemy )
					player stealth_player::inc_aware( self, 1 );
				else
					player stealth_player::inc_aware( self, alertThisEnemy );
								
				bAnyVisible = bAnyVisible || bAlertedThisEnemy || bCombatThisEnemy || bAware;
			}
		}
		
		// dedwards - 2/26/2015 - overhead status indicators are only seen when stealth_debug is enabled now
		if ( ( GetDvarInt("stealth_display", 1 ) == 2 || stealth_debug::enabled() ) && ( bAware || bAlerted ) )
   		{
			// Aware to some degree at least
			self icon_show( player );
			bAnyVisible = true;
			str_shader = "white_stealth_arrow_01";
			color = stealth::awareness_color( "unaware" );
			
			if ( !bAlertedThisEnemy && bAlerted )
			{
				// Alerted but not to this player
				color = stealth::awareness_color( awareness );
			}
			else if ( self stealth_aware::get_awareness() == "unaware" )
			{
				// Seeing this player
				str_shader = shader_for_alert_level( alertThisEnemy );
				color = stealth::awareness_color( awareness, bCanSee );
			}
			else
			{
				// Already alerted and seeking enemy
				str_shader = shader_for_alert_level( alertThisEnemy );
				color = stealth::awareness_color( awareness );
			}

			// Fill grows in size according to alert level
			if ( isDefined( self.stealth.status.icon_ent ) && isDefined( self.stealth.status.icons[index] ) )
			{
				self.stealth.status.icons[index] SetTargetEnt( self.stealth.status.icon_ent );	
				self.stealth.status.icons[index] SetShader( str_shader, 5, 5 );
				self.stealth.status.icons[index] SetWaypoint( false, str_shader, false, false );
				self.stealth.status.icons[index].color = color;
			}
		}
		else if ( isDefined( self.stealth.status.icons[index] ) )
		{
			// Completely unaware - remove the icon
			self clean_icon( index );
		}
	}
	
	// Return true only if we are stil showing any icons to anyone
	return bAnyVisible;
}

/@
"Name: clean_icon( <index> )"
"Summary: Removes hud elements"
"Module: stealth"
"CallOn: Entity"
"OptionalArg: <index>: specific icon to delete
"Example: ai stealth_status::clean_icon()"
@/
function clean_icon( index )
{
	if ( !isDefined( self ) || !isDefined( self.stealth ) || !isDefined( self.stealth.status ) || !isDefined( self.stealth.status.icons ) )
		return;
		
	if ( isDefined( index ) )
	{
		if ( isDefined( self.stealth.status.icons[index] ) )
		{
			self.stealth.status.icons[index] Destroy();
			self.stealth.status.icons[index] = undefined;
		}
	}
	else
	{
		foreach ( icon in self.stealth.status.icons ) 
		{
			if ( isdefined( icon ) )
				icon Destroy();
		}
		self.stealth.status.icons = [];
	}

	if ( isDefined( self.stealth.status.icon_ent ) && self.stealth.status.icons.size == 0 )
	{
		self.stealth.status.icon_ent Delete();		
		self.stealth.status.icon_ent = undefined;
	}
}

/@
"Name: clean_icon_on_death()"
"Summary: Removes hud elements when entity dies"
"Module: stealth"
"CallOn: Entity"
"Example: ai stealth_status::clean_icons_on_death()"
@/
function clean_icon_on_death( )
{
	self notify("stealth_status_clean_icons_on_death");
	self endon("stealth_status_clean_icons_on_death");
	
	self util::waittill_any( "death", "stop_stealth" );
	
	self clean_icon();
}
	