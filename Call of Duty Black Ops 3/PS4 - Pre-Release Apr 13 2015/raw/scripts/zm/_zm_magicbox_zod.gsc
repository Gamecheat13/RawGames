#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      
                                                                                                                               



#namespace zm_magicbox_zod;

function init()
{
	RegisterClientField( "zbarrier", "magicbox_initial_fx",	1, 1, "int" );
	RegisterClientField( "zbarrier", "magicbox_amb_fx",		1, 2, "int" );
	RegisterClientField( "zbarrier", "magicbox_open_fx",	1, 1, "int" );
	RegisterClientField( "zbarrier", "magicbox_leaving_fx",	1, 1, "int" );
	
	/*
	// custom fx
	//Magic Box
	level._effect["lght_marker"] 						= Loadfx("maps/zombie_tomb/fx_tomb_marker");
	level._effect["lght_marker_flare"] 					= Loadfx("maps/zombie/fx_zmb_tranzit_marker_fl");
	level._effect["poltergeist"]						= LoadFX("system_elements/fx_null"); // no fx for this
	
	level._effect["box_powered"]						= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_on");
	level._effect["box_unpowered"]						= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_off");
	level._effect["box_gone_ambient"]					= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_amb_base");
	level._effect["box_here_ambient"]					= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_amb_slab");
	level._effect["box_is_open"]						= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_open");
	level._effect["box_portal"] 						= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_portal");
	level._effect["box_is_leaving"] 					= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_leave");
	
	level.chest_joker_model = "zombie_teddybear";
	
	level.chest_joker_custom_movement = ::custom_joker_movement;
	level.custom_magic_box_timer_til_despawn = ::custom_magic_box_timer_til_despawn;
	level.custom_magic_box_do_weapon_rise = ::custom_magic_box_do_weapon_rise;
	level.custom_magic_box_weapon_wait = ::custom_magic_box_weapon_wait;
	level.custom_magicbox_float_height = 50;
		
	level.magic_box_zbarrier_state_func = ::set_magic_box_zbarrier_state;
	
	level thread wait_then_create_base_magic_box_fx();
	level thread handle_fire_sale();
	*/
}

//override for the default bear movement
function custom_joker_movement()
{
	//record the weapon model origin and delete it, it could have parts hidden based on what weapon spawned
	v_origin = self.weapon_model.origin - ( 0, 0, 5 );
	self.weapon_model Delete();
	
	//spawn a fresh new model with everything correct
	m_lock = Spawn( "script_model", v_origin );
	m_lock SetModel( level.chest_joker_model );
	m_lock.angles = self.angles + ( 0, 270, 0 );
	m_lock PlaySound ("zmb_hellbox_bear");
	
	//let the pain linger for a while
	wait .5;
	level notify("weapon_fly_away_start");
	wait 1;

	//start spinning fast
	m_lock RotateYaw( 3000, 4, 4 );
	
	//wait for it to get real fast
	wait 3;
	
	//move up in the z a bit
	
	v_angles = AnglesToForward( self.angles - (0, 90, 0) );
		
	m_lock MoveTo( m_lock.origin + (20 * v_angles), 0.5, 0.5 );
	m_lock waittill( "movedone" );
	
	//fast move down into the box
	m_lock MoveTo( m_lock.origin + (-100 * v_angles), 0.5, 0.5 );
	m_lock waittill( "movedone" );
	
	//and it's gone
	m_lock Delete();
	
	self notify( "box_moving" );
	level notify("weapon_fly_away_end");
}

function custom_magic_box_timer_til_despawn( magic_box )
{
	self endon( "kill_weapon_movement" );

	const FLOAT_HEIGHT = 40;
	
	// SRS 9/3/2008: if we timed out, move the weapon back into the box instead of deleting it
	putBackTime = 12;
	v_float = AnglesToForward( magic_box.angles - (0, 90, 0) ) * FLOAT_HEIGHT; // draw vector straight forward with reference to the mystery box angles
	self MoveTo( self.origin - ( v_float * 0.25 ), putBackTime, ( putBackTime * 0.5 ) );
	wait( putBackTime );

	if( isdefined( self ) )
	{	
		self Delete();
	}
}

function custom_magic_box_weapon_wait()
{
	wait 0.5;
}

function wait_then_create_base_magic_box_fx()
{
	//level.chests created by _zm_magicbox.gsc and is an array of structs whose .zbarrier should be the zbarrier object
	while( !IsDefined( level.chests ) )
	{
		wait(0.5);
	}
	
	// just in case the data needed isn't created yet
	while( !IsDefined( level.chests[level.chests.size - 1].zbarrier ) )
	{
		wait(0.5);
	}
	
	foreach( chest in level.chests )
	{
		chest.zbarrier clientfield::set( "magicbox_initial_fx", 1 ); //-- turn on the base ambient fx
	}
}

function set_magic_box_zbarrier_state(state)
{
	for(i = 0; i < self GetNumZBarrierPieces(); i ++)
	{
		self HideZBarrierPiece(i);
	}
	
	self notify("zbarrier_state_change");
	
	switch(state)
	{
		case "away":
			self ShowZBarrierPiece(0);
			self.state = "away";
			self.owner.is_locked = false;
			break;
		case "arriving":
			self ShowZBarrierPiece(1);
			self thread magic_box_arrives();
			self.state = "arriving";
			break;
		case "initial":
			self ShowZBarrierPiece(1);
			self thread magic_box_initial();
			self thread zm_unitrigger::register_static_unitrigger( self.owner.unitrigger_stub, &zm_magicbox::magicbox_unitrigger_think );
			self.state = "close";
			break;
		case "open":
			self ShowZBarrierPiece(2);
			self thread magic_box_opens();
			self.state = "open";
			break;
		case "close":
			self ShowZBarrierPiece(2);
			self thread magic_box_closes();
			self.state = "close";
			break;
		case "leaving":
			self showZBarrierPiece(1);
			self thread magic_box_leaves();
			self.state = "leaving";
			self.owner.is_locked = false;
			break;
		default:
			if( IsDefined( level.custom_magicbox_state_handler ) )
			{
				self [[ level.custom_magicbox_state_handler ]]( state );
			}
			break;
	}
}

function magic_box_initial()
{
	self SetZBarrierPieceState(1, "open");
	wait(1);
	self clientfield::set( "magicbox_amb_fx", 1 ); // box here and power off
}

function magic_box_arrives()
{
	self clientfield::set( "magicbox_leaving_fx", 0 );
	
	self SetZBarrierPieceState(1, "opening");
	while(self GetZBarrierPieceState(1) == "opening")
	{
		wait (0.05);
	}
	self notify("arrived");
	self.state = "close";

	s_zone_capture_area = level.zone_capture.zones[ self.zone_capture_area ];
	if ( IsDefined( s_zone_capture_area ) )
	{
		if ( !s_zone_capture_area flag::get( "player_controlled" ) )
		{
			self clientfield::set( "magicbox_amb_fx", 1 ); // box here and power off
		}
		else
		{
			self clientfield::set( "magicbox_amb_fx", 2 ); // box here and power on
		}
	}

}

function magic_box_leaves()
{
	self clientfield::set( "magicbox_leaving_fx", 1 );
	self clientfield::set( "magicbox_open_fx", 0 );
	self SetZBarrierPieceState(1, "closing");
	//SOUND - Shawn J
	self playsound ("zmb_hellbox_rise");
	while(self GetZBarrierPieceState(1) == "closing")
	{
		wait (0.1);
	}
	self notify("left");
	
	s_zone_capture_area = level.zone_capture.zones[ self.zone_capture_area ];
	if ( IsDefined( s_zone_capture_area ) )
	{
		if ( s_zone_capture_area flag::get( "player_controlled" ) )
		{
			self clientfield::set( "magicbox_amb_fx", 3 ); // box gone and power on
		}
		else
		{
			self clientfield::set( "magicbox_amb_fx", 0 ); // box gone and power off
		}
	}
	
	//determines if fire sale can be dug up
	if( !( isdefined( level.dig_magic_box_moved ) && level.dig_magic_box_moved ) )
	{
		level.dig_magic_box_moved = true;
	}
}

function magic_box_opens()
{
	self clientfield::set( "magicbox_open_fx", 1 );
	self SetZBarrierPieceState(2, "opening");
	self playsound( "zmb_hellbox_open" );
	while(self GetZBarrierPieceState(2) == "opening")
	{
		wait (0.1);
	}
	self notify("opened");
	self thread magic_box_open_idle(); // play the idle animation once the magic box is finished opening
}

function magic_box_open_idle()
{
	self endon( "stop_open_idle" );
	
	// hide the standing opening/closing zbarrier piece
	self HideZBarrierPiece(2);

	// show the idle animation zbarrier piece, and set its animation
	self ShowZBarrierPiece(5);
	while( true )
	{
		self SetZBarrierPieceState(5, "opening");
		while( self GetZBarrierPieceState(5) != "open" )
		{
			wait 0.05;
		}
	}
}

function magic_box_closes()
{
	self notify( "stop_open_idle" );
	
	// hide the idle animation zbarrier piece; show the standard opening/closing zbarrier piece
	self HideZBarrierPiece(5);
	self ShowZBarrierPiece(2);

	self SetZBarrierPieceState(2, "closing");
	self playsound( "zmb_hellbox_close" );
	self clientfield::set( "magicbox_open_fx", 0 );
	while(self GetZBarrierPieceState(2) == "closing")
	{
		wait (0.1);
	}
	self notify("closed");
}

function custom_magic_box_do_weapon_rise()
{
	self endon("box_hacked_respin");
	
	wait 0.5; // waiting so that the portal effect can start playing
	
	self SetZBarrierPieceState(3, "closed");
	self SetZBarrierPieceState(4, "closed");
	
	util::wait_network_frame();
	
	self ZBarrierPieceUseBoxRiseLogic(3);
	self ZBarrierPieceUseBoxRiseLogic(4);
	
	self ShowZBarrierPiece(3);
	self ShowZBarrierPiece(4);
	self SetZBarrierPieceState(3, "opening");
	self SetZBarrierPieceState(4, "opening");
	
	while(self GetZBarrierPieceState(3) != "open")
	{
		wait(0.5);
	}
	
	self HideZBarrierPiece(3);
	self HideZBarrierPiece(4);
}

//fire sales do not enter the leave state so the fx must be manually removed
function handle_fire_sale()
{
	while( 1 )
	{
		level waittill( "fire_sale_off" );
		
		for( i = 0; i < level.chests.size; i++ )
		{
			if( level.chest_index != i && IsDefined(level.chests[i].was_temp))
			{
				if ( IsDefined( level.chests[ i ].zbarrier.zone_capture_area ) && level.zone_capture.zones[ level.chests[ i ].zbarrier.zone_capture_area ] flag::get( "player_controlled" ) )
				{
					level.chests[i].zbarrier clientfield::set( "magicbox_amb_fx", 3 ); // not here and power on

				}
				else
				{
					level.chests[i].zbarrier clientfield::set( "magicbox_amb_fx", 0 ); // not here and power off
				}
			}
		}
	}
}
