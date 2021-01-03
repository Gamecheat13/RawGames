#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_util;
#using scripts\zm\_zm;

                                                                                       	                                
                                                                                                                               

#namespace zm_pap_util;

function init_parameters()
{
	if ( !isdefined( level.pack_a_punch ) )
	{
		level.pack_a_punch = SpawnStruct();
		level.pack_a_punch.timeout = 15;
		level.pack_a_punch.interaction_height = 35;
		level.pack_a_punch.move_in_func = &pap_weapon_move_in;
		level.pack_a_punch.move_out_func = &pap_weapon_move_out;
		level.pack_a_punch.grabbable_by_anyone = false;
		level.pack_a_punch.swap_attachments_on_reuse = false;
		level.pack_a_punch.triggers = [];
	}
}

function set_timeout( n_timeout_s )
{
	init_parameters();
	level.pack_a_punch.timeout = n_timeout_s;
}

function set_interaction_height( n_height )
{
	init_parameters();
	level.pack_a_punch.interaction_height = n_height;
}

function set_move_in_func( fn_move_weapon_in )
{
	init_parameters();
	level.pack_a_punch.move_in_func = fn_move_weapon_in;
}

function set_move_out_func( fn_move_weapon_out )
{
	init_parameters();
	level.pack_a_punch.move_out_func = fn_move_weapon_out;
}

function set_grabbable_by_anyone()
{
	init_parameters();
	level.pack_a_punch.grabbable_by_anyone = true;
}

function get_triggers()
{
	init_parameters();
/#
	if (level.pack_a_punch.triggers.size == 0 )
	{
		println( "^1ZM Pack a Punch: Retrieving no triggers.  Make sure not to call this until after __main__ has run.\n" );
	}
#/
	return level.pack_a_punch.triggers;
}

function is_pap_trigger()
{
	return isdefined( self.script_noteworthy ) && self.script_noteworthy == "pack_a_punch";
}

function enable_swap_attachments()
{
	init_parameters();
	level.pack_a_punch.swap_attachments_on_reuse = true;
}

function can_swap_attachments()
{
	if( !isdefined(level.pack_a_punch) )
		return false;
	return level.pack_a_punch.swap_attachments_on_reuse;
}

function update_hint_string()
{
	if ( zm_pap_util::can_swap_attachments() )
	{
		self SetHintString( &"ZOMBIE_PERK_PACKAPUNCH_ATT", self.cost );
	}
	else
	{
		self SetHintString( &"ZOMBIE_PERK_PACKAPUNCH", self.cost );
	}
}

function private pap_weapon_move_in(trigger, origin_offset, angles_offset )
{
	level endon("Pack_A_Punch_off");
	trigger endon("pap_player_disconnected");
	
	trigger.worldgun rotateto( self.angles+angles_offset+(0,90,0), 0.35, 0, 0 );

	offsetdw = ( 3, 3, 3 );
	
	if( IsDefined( trigger.worldgun.worldgundw ) )
	{
		trigger.worldgun.worldgundw rotateto( self.angles+angles_offset+(0,90,0), 0.35, 0, 0 );
	}
	
	wait( 0.5 );

	trigger.worldgun moveto( self.origin+origin_offset, 0.5, 0, 0 );
	if ( isdefined( trigger.worldgun.worldgundw ) )
	{
		trigger.worldgun.worldgundw moveto( self.origin+origin_offset+offsetdw, 0.5, 0, 0 );
	}

}

function private pap_weapon_move_out(trigger, origin_offset, interact_offset)
{
	level endon("Pack_A_Punch_off");
	trigger endon("pap_player_disconnected");
	
	offsetdw = ( 3, 3, 3 );
	
	if( !IsDefined( trigger.worldgun ) )
	{
		return;
	}
	
	trigger.worldgun moveto( self.origin+interact_offset, 0.5, 0, 0 );
	if( IsDefined( trigger.worldgun.worldgundw ) )
	{
		trigger.worldgun.worldgundw moveto( self.origin+interact_offset + offsetdw, 0.5, 0, 0 );
	}
	
	wait( 0.5 );

	if( !IsDefined( trigger.worldgun ) )
	{
		return;
	}
	
	trigger.worldgun moveto( self.origin+origin_offset, level.pack_a_punch.timeout, 0, 0);
	if ( isdefined( trigger.worldgun.worldgundw ) )
	{
		trigger.worldgun.worldgundw moveto( self.origin+origin_offset+offsetdw, level.pack_a_punch.timeout, 0, 0);
	}
}