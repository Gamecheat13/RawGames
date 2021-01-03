#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "zombie/fx_weapon_box_open_glow_zmb" );
#precache( "client_fx", "zombie/fx_weapon_box_closed_glow_zmb" );


#namespace zm_magicbox;
function autoexec __init__sytem__() {     system::register("zm_magicbox",&__init__,undefined,undefined);    }

function __init__()
{
	level._effect["chest_light"] = "zombie/fx_weapon_box_open_glow_zmb"; 
	level._effect["chest_light_closed"] = "zombie/fx_weapon_box_closed_glow_zmb"; 

	clientfield::register( "zbarrier", "magicbox_open_glow", 1, 1, "int", &magicbox_open_glow_callback, !true, !true );
	clientfield::register( "zbarrier", "magicbox_closed_glow", 1, 1, "int", &magicbox_closed_glow_callback, !true, !true );
	
	clientfield::register( "zbarrier", "zbarrier_show_sounds", 1, 1, "counter", &magicbox_show_sounds_callback, true, !true);
	clientfield::register( "zbarrier", "zbarrier_leave_sounds", 1, 1, "counter", &magicbox_leave_sounds_callback, true, !true);	
}

function magicbox_show_sounds_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	playsound( localClientNum, "zmb_box_poof_land", self.origin  );
	playsound( localClientNum, "zmb_couch_slam", self.origin  );
	playsound( localClientNum, "zmb_box_poof", self.origin );
}

function magicbox_leave_sounds_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	playsound(localClientNum, "zmb_box_move", self.origin);
	playsound(localClientNum, "zmb_whoosh", self.origin );		
}

function magicbox_open_glow_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !isdefined( self.open_glow_obj_array ) )
	{
		self.open_glow_obj_array = [];
	}

	if ( newVal && !isdefined( self.open_glow_obj_array[localClientNum] ) )
	{
		fx_obj = spawn( localClientNum, self.origin, "script_model" ); 
		fx_obj setmodel( "tag_origin" ); 
		fx_obj.angles = self.angles;
		PlayFXOnTag( localClientNum, level._effect["chest_light"], fx_obj, "tag_origin" );

		self.open_glow_obj_array[localClientNum] = fx_obj;
		self open_glow_obj_demo_jump_listener( localClientNum );
	}
	else if ( !newVal && isdefined( self.open_glow_obj_array[localClientNum] ) )
	{
		self open_glow_obj_cleanup( localClientNum );
	}
}


function open_glow_obj_demo_jump_listener( localClientNum )
{
	self endon( "end_demo_jump_listener" );

	level waittill( "demo_jump" );

	self open_glow_obj_cleanup( localClientNum );
}


function open_glow_obj_cleanup( localClientNum )
{
	self.open_glow_obj_array[localClientNum] delete();
	self.open_glow_obj_array[localClientNum] = undefined;

	self notify( "end_demo_jump_listener" );
}

function magicbox_closed_glow_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !isdefined( self.closed_glow_obj_array ) )
	{
		self.closed_glow_obj_array = [];
	}

	if ( newVal && !isdefined( self.closed_glow_obj_array[localClientNum] ) )
	{
		fx_obj = spawn( localClientNum, self.origin, "script_model" ); 
		fx_obj setmodel( "tag_origin" ); 
		fx_obj.angles = self.angles;
		PlayFXOnTag( localClientNum, level._effect["chest_light_closed"], fx_obj, "tag_origin" );

		self.closed_glow_obj_array[localClientNum] = fx_obj;
		self closed_glow_obj_demo_jump_listener( localClientNum );
	}
	else if ( !newVal && isdefined( self.closed_glow_obj_array[localClientNum] ) )
	{
		self closed_glow_obj_cleanup( localClientNum );
	}
}


function closed_glow_obj_demo_jump_listener( localClientNum )
{
	self endon( "end_demo_jump_listener" );

	level waittill( "demo_jump" );

	self closed_glow_obj_cleanup( localClientNum );
}


function closed_glow_obj_cleanup( localClientNum )
{
	self.closed_glow_obj_array[localClientNum] delete();
	self.closed_glow_obj_array[localClientNum] = undefined;

	self notify( "end_demo_jump_listener" );
}
