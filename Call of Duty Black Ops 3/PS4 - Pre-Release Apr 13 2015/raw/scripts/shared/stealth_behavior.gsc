#using scripts\codescripts\struct;

#using scripts\cp\_load;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace stealth_client;

// FIXME : Prototype directional indicators


function autoexec __init__sytem__() {     system::register("stealth_client",&stealth_client::__init__,undefined,undefined);    }

function __init__()
{
	init_clientfields();
	level.stealth_is_alerted = false;
	level.stealth_awareness_level = 0;
}

function init_clientfields()
{
	// clientfield setup
	clientfield::register( "toplayer", "stealth_sighting", 1, 2, "int", &callback_stealth_sighting, false, false );
	clientfield::register( "toplayer", "stealth_alerted", 1, 1, "int", &callback_stealth_alerted, false, false );
	
	// FIXME : Prototype directional indicators
	clientfield::register( "toplayer", "stealth_sight_ent_01", 1, 7, "int", &callback_stealth_sight_ent_01, false, false );
	clientfield::register( "toplayer", "stealth_sight_ent_02", 1, 7, "int", &callback_stealth_sight_ent_02, false, false );
	clientfield::register( "toplayer", "stealth_sight_ent_03", 1, 7, "int", &callback_stealth_sight_ent_03, false, false );
	clientfield::register( "toplayer", "stealth_sight_ent_04", 1, 7, "int", &callback_stealth_sight_ent_04, false, false );
	
	// FIXME : Prototype directional indicators
	clientfield::register( "toplayer", "stealth_sight_lvl_01", 1, 7, "int", &callback_stealth_sight_lvl_01, false, false );
	clientfield::register( "toplayer", "stealth_sight_lvl_02", 1, 7, "int", &callback_stealth_sight_lvl_02, false, false );
	clientfield::register( "toplayer", "stealth_sight_lvl_03", 1, 7, "int", &callback_stealth_sight_lvl_03, false, false );
	clientfield::register( "toplayer", "stealth_sight_lvl_04", 1, 7, "int", &callback_stealth_sight_lvl_04, false, false );
}

// FIXME : Prototype directional indicators
function callback_stealth_sight_ent_01( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) { self callback_stealth_sight_ent( localClientNum, 0, newVal ); }
function callback_stealth_sight_ent_02( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) { self callback_stealth_sight_ent( localClientNum, 1, newVal ); }
function callback_stealth_sight_ent_03( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) { self callback_stealth_sight_ent( localClientNum, 2, newVal ); }
function callback_stealth_sight_ent_04( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) { self callback_stealth_sight_ent( localClientNum, 3, newVal ); }

// FIXME : Prototype directional indicators
function callback_stealth_sight_lvl_01( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) { self callback_stealth_sight_lvl( 0, newVal ); }
function callback_stealth_sight_lvl_02( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) { self callback_stealth_sight_lvl( 1, newVal ); }
function callback_stealth_sight_lvl_03( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) { self callback_stealth_sight_lvl( 2, newVal ); }
function callback_stealth_sight_lvl_04( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) { self callback_stealth_sight_lvl( 3, newVal ); }

// FIXME : Prototype directional indicators
function callback_stealth_sight_ent( localClientNum, index, entNumber )
{
	entity = undefined;
	if ( entNumber != 127 )
		entity = GetEntByNum( localClientNum, entNumber );
	
	if ( !isDefined( self.stealth_sight_ent ) )
		self.stealth_sight_ent = [];
	
	self.stealth_sight_ent[index] = entity;
	
	if ( !isDefined( self.stealth_display ) )
		self thread stealth_display( localClientNum );
}

// FIXME : Prototype directional indicators
function callback_stealth_sight_lvl( index, sightLevel )
{
	if ( !isDefined( self.stealth_sight_lvl ) )
		self.stealth_sight_lvl = [];
	
	self.stealth_sight_lvl[index] = sightLevel;

	if ( !isDefined( self.stealth_display ) )
		self thread stealth_display();
}

// FIXME : Prototype directional indicators
function shader_for_alert_level( alertLevel )
{
	if ( alertLevel < 0.0 )
		alertLevel = 0.0;

	if( alertLevel > 1.0 )
		alertLevel = 1.0;
	
	// only show last frame if full 100%
	if ( alertLevel == 1.0 )
		return "white_stealth_arrow_0" + "9";
	else
		return "white_stealth_arrow_0" + (1 + int(7 * alertLevel));
}

// FIXME : Prototype directional indicators
function create_stealth_indicator( localClientNum )
{
//	hudelem = CreateLUIMenu( localClientNum, "HudStealthIndicator" );	
	hudelem = CreateLUIMenu( localClientNum, "HudElementImage" );	
	
	if ( isDefined( hudelem ) )
	{
		// These must be set prior to calling OpenLUIMenu so that the values will be subscribed and updated each frame
		
		SetLuiMenuData( localClientNum, hudelem, "x", 			0 );
		SetLuiMenuData( localClientNum, hudelem, "y", 			0 );
		SetLuiMenuData( localClientNum, hudelem, "width", 		64 );
		SetLuiMenuData( localClientNum, hudelem, "height", 		64 );
		SetLuiMenuData( localClientNum, hudelem, "alpha", 		1.0 );
		SetLuiMenuData( localClientNum, hudelem, "material", 	shader_for_alert_level( 0 ) );
		SetLuiMenuData( localClientNum, hudelem, "red", 		1.0 );
		SetLuiMenuData( localClientNum, hudelem, "green", 		1.0 );
		SetLuiMenuData( localClientNum, hudelem, "blue", 		1.0 );
		SetLuiMenuData( localClientNum, hudelem, "zRot", 		0.0 );

		OpenLUIMenu( localclientnum, hudelem );
	}
	
	return hudelem;	
}

// FIXME : Prototype directional indicators
function stealth_display( localClientNum )
{
	self notify( "stealth_display_thread" );
	self endon( "stealth_display_thread" );
	
	self.stealth_display = true;
	
	if ( !isDefined( self.stealth_elems ) )
		self.stealth_elems = [];
	
	while ( isDefined( self ) )
	{
		time = 0;
		for ( i = 0; i < 4; i++ )
		{
			entity = self.stealth_sight_ent[i];

			if ( isDefined( self.stealth_elems[i] ) )
				SetLuiMenuData( localClientNum, self.stealth_elems[i], "alpha", 0.0 );
						
			if ( isDefined( entity ) && isDefined( self.stealth_sight_lvl ) && isDefined( self.stealth_sight_lvl[i] ) )
			{		
				value = float(self.stealth_sight_lvl[i]);
				visible = value > 50.0;
				if ( visible )
					value = value - 50.0;
				else if ( value == 50 )
					value = 0;
				lvl = float(value) / 50.0;
				shader = shader_for_alert_level( lvl );
				pulse = false;
				if ( lvl >= 1.0 )
					pulse = true;

//#if 0
//				self AddAwarenessIndicator( entity.origin, shader );
//#else							
				// Update x,y according to relative yaw rotation of the entity to the current player
				radius = 200.0;
				baseX = 640;
				baseY = 360;
				size = 64;
							
				dir = VectorNormalize( entity.origin - self.origin );
				yawToEnt = VectorToAngles( dir )[1];
				angle = ( self.angles[1] - yawToEnt ) - 90;
				cosAngle = cos( angle );
				sinAngle = sin( angle );
				halfSize = int( size * 0.5 );

				if ( !isDefined( self.stealth_elems[i] ) )
					self.stealth_elems[i] = create_stealth_indicator( localClientNum );
				
				elem = self.stealth_elems[i];
				
				if ( isDefined( elem ) )
				{
					xOffset = cosAngle * radius;
					yOffset = sinAngle * radius;
					
					x = int( baseX + xOffset );
					y = int( baseY + yOffset );
					
					SetLuiMenuData( localClientNum, elem, "material", shader );
					SetLuiMenuData( localClientNum, elem, "x", x - halfSize );
					SetLuiMenuData( localClientNum, elem, "y", y - halfSize );

					if ( visible )
					{
						SetLuiMenuData( localClientNum, elem, "red", 1.0 );
						SetLuiMenuData( localClientNum, elem, "green", 1.0 );
						SetLuiMenuData( localClientNum, elem, "blue", 1.0 );
					}
					else
					{
						SetLuiMenuData( localClientNum, elem, "red", 0.5 );
						SetLuiMenuData( localClientNum, elem, "green", 0.5 );
						SetLuiMenuData( localClientNum, elem, "blue", 0.5 );
					}
					
					if ( pulse )
						SetLuiMenuData( localClientNum, elem, "alpha", ( sin( time * 5 ) * 0.1 ) + 0.9 );
					else
						SetLuiMenuData( localClientNum, elem, "alpha", 1.0 );
					
					SetLuiMenuData( localClientNum, elem, "zRot", -(angle + 90));
				}		
//#endif
			}
		}	
		
		time += .016;
		
		{wait(.016);};
	}	
}

// Clientfield callbacks
function callback_stealth_sighting( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = client
{
	if ( newVal > 0 )
	{
		if (level.stealth_awareness_level == 0 || newVal == 2)  // don't set awareness level 1
		{
			level.stealth_awareness_level = newVal;
			self thread stealth_sighted_sound();
		}
	}
	else
	{
		level.stealth_awareness_level = 0;
		self notify("stealth_sighting_thread");
	}
	
}

function callback_stealth_alerted( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = client
{
	if ( newVal == 1 )
	{
		if ( level.stealth_is_alerted == false )
		{
			self thread stealth_alerted_sound();
			level.stealth_is_alerted = true;
		}
	}
	else
	{
		self notify("stealth_alerted_thread");
		level.stealth_is_alerted = false;
	}
}

function stealth_sighted_sound()
{
	self notify("stealth_sighting_thread");
	self endon("stealth_sighting_thread");
	self endon("stealth_alerted_thread");
	self endon("death");
	self endon("disconnect");
	
	wait_length = 0.3;
	
	if ( level.stealth_awareness_level == 2 )
		wait_length = 0.2;
	
	while ( 1 )
	{
		self playsound( self, "uin_stealth_beep" );
		wait wait_length;
	}
}

function stealth_alerted_sound()  
{
	self notify("stealth_alerted_thread");
	self endon("stealth_alerted_thread");
	self endon("death");
	self endon("disconnect");
	
	if ( level.stealth_awareness_level == 1 )
	{
		self playsound( self, "uin_stealth_hint" );
	}
	
	while ( 1 )
	{
		self playsound( self, "uin_stealth_beep" );
		wait 0.8;
	}
}