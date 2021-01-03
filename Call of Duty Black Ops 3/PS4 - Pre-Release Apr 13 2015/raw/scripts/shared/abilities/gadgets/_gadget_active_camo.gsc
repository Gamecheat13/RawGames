#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                    	   	  	

#using scripts\shared\system_shared;

function autoexec __init__sytem__() {     system::register("gadget_active_camo",&__init__,undefined,undefined);    }

function __init__()
{
	ability_player::register_gadget_activation_callbacks( 38, &camo_gadget_on, &camo_gadget_off );
	ability_player::register_gadget_possession_callbacks( 38, &camo_on_give, &camo_on_take );
	ability_player::register_gadget_flicker_callbacks( 38, &camo_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 38, &camo_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 38, &camo_is_flickering );
	
	//clientfield::register( "allplayers", "camo_shader", VERSION_SHIP, 3, "int" ); 	//already registered in _gadget_camo
	callback::on_connect( &camo_on_connect );
	callback::on_spawned( &camo_on_spawn );
	callback::on_disconnect( &camo_on_disconnect );
}
function camo_on_connect()
{
	if(isDefined(level.cybercom) && isDefined(level.cybercom.active_camo))
	{
		self [[level.cybercom.active_camo._on_connect]]();
	}
}
function camo_on_disconnect()
{
	/*if ( IsDefined( self.active_camo_sound_ent ) )
	{
		self.active_camo_sound_ent stoploopsound( .05 );
		self.active_camo_sound_ent delete();	
	}*/
}
function camo_on_spawn()
{
	self flagsys::clear( "camo_suit_on" );
	self notify( "camo_off" );
	self clientfield::set( "camo_shader", 0 );
	/*if ( IsDefined( self.active_camo_sound_ent ) )
	{
		self.active_camo_sound_ent stoploopsound( .05 );
		self.active_camo_sound_ent delete();	
	}*/
}


function camo_is_inuse( slot )
{
	return self flagsys::get( "camo_suit_on" );
}

function camo_is_flickering( slot )
{
	// returns true when the gadget is flickering
	return self GadgetFlickering( slot );
}

function camo_on_give( slot, weapon )
{
	if(isDefined(level.cybercom) && isDefined(level.cybercom.active_camo))
	{
		self [[level.cybercom.active_camo._on_give]](slot, weapon);
	}
}

function camo_on_take( slot, weapon )
{
	self notify( "camo_removed" );
	if(isDefined(level.cybercom) && isDefined(level.cybercom.active_camo))
	{
		self [[level.cybercom.active_camo._on_take]](slot, weapon);
	}
}

function camo_on_flicker( slot, weapon )
{
	self thread suspend_camo_suit( slot, weapon );
	if(isDefined(level.cybercom) && isDefined(level.cybercom.active_camo))
	{
		self thread [[level.cybercom.active_camo._on_flicker]](slot, weapon);
	}	
}

function camo_gadget_on( slot, weapon )
{
	if(isDefined(level.cybercom) && isDefined(level.cybercom.active_camo))
	{
		self thread [[level.cybercom.active_camo._on]](slot, weapon);
	}
	
	self clientfield::set( "camo_shader", 1 );

	self flagsys::set( "camo_suit_on" );
	//self thread camo_loop_audio();
}

function camo_gadget_off( slot, weapon )
{
	self flagsys::clear( "camo_suit_on" );
	if(isDefined(level.cybercom) && isDefined(level.cybercom.active_camo))
	{
		self thread [[level.cybercom.active_camo._off]](slot, weapon);
	}	
	/*if ( IsDefined( self.active_camo_sound_ent ) )
	{
		self.active_camo_sound_ent PlaySound( "gdt_camo_suit_off");
		self.active_camo_sound_ent delete();	
	}*/
	self notify( "camo_off" );
	self clientfield::set( "camo_shader", 0 );
}


function suspend_camo_suit( slot, weapon )
{
	self endon( "disconnect" );
	self endon( "camo_off" );
	
	self clientfield::set( "camo_shader", 2 );

	suspend_camo_suit_wait( slot, weapon );

	if ( self camo_is_inuse( slot ) )
	{
		self clientfield::set( "camo_shader", 1 );
	}
}

function suspend_camo_suit_wait( slot, weapon )
{
	self endon( "death" );
	self endon( "camo_off" );

	while ( self camo_is_flickering( slot ) )
	{
		wait 0.5;
	}
}

/*function camo_loop_audio()
{
	if ( IsDefined( self.active_camo_sound_ent ) )
	{
		self.active_camo_sound_ent stoploopsound( .05 );
		self.active_camo_sound_ent delete();	
	}
	self.active_camo_sound_ent = Spawn( "script_origin", self.origin );
	self.active_camo_sound_ent linkto( self );
	self playsound ("gdt_camo_suit_on");
	wait .5;
	
	if ( IsDefined( self.active_camo_sound_ent ) )
	{
		self.active_camo_sound_ent PlayLoopSound( "gdt_camo_suit_loop" , .1 );	
	}
}
*/