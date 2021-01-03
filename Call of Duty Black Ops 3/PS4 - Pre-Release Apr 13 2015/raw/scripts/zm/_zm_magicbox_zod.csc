#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

// TODO: precache any custom fx here



#namespace zm_magicbox_zod;

function init()
{
	// custom fx
	/*
	level._effect["lght_marker"] 						= Loadfx("maps/zombie_tomb/fx_tomb_marker");
	level._effect["lght_marker_flare"] 					= Loadfx("maps/zombie/fx_zmb_tranzit_marker_fl");
	
	level._effect["box_powered"]						= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_on");
	level._effect["box_unpowered"]						= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_off");
	level._effect["box_gone_ambient"]					= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_amb_base");
	level._effect["box_here_ambient"]					= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_amb_slab");
	level._effect["box_is_open"]						= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_open");
	level._effect["box_portal"] 						= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_portal");
	level._effect["box_is_leaving"] 					= LoadFX("maps/zombie_tomb/fx_tomb_magicbox_leave");
	*/

	RegisterClientField( "zbarrier", "magicbox_initial_fx", 1, 1, "int", &magicbox_initial_closed_fx ); //-- sets the basic fx for all non-starting boxes
	RegisterClientField( "zbarrier", "magicbox_amb_fx", 	1, 2, "int", &magicbox_ambient_fx ); //-- used to toggle the fx (0 - box not here, 1 - box here and power off, 2 - box here and power on )
	RegisterClientField( "zbarrier", "magicbox_open_fx",	1, 1, "int", &magicbox_open_fx ); //-- fills the inside of the box when its open
	RegisterClientField( "zbarrier", "magicbox_leaving_fx",	1, 1, "int", &magicbox_leaving_fx ); //-- 
}

function magicbox_leaving_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(!IsDefined(self.fx_obj))
	{
		self.fx_obj = spawn( localClientNum, self.origin, "script_model" );
		self.fx_obj.angles = self.angles;
		self.fx_obj setmodel( "tag_origin" ); 
	}
			
	if( newVal == 1 ) // BOX OPEN
	{
		self.fx_obj.curr_leaving_fx = PlayFXOnTag( localClientNum, level._effect["box_is_leaving"], self.fx_obj, "tag_origin" );	
	}
}

function magicbox_open_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(!IsDefined(self.fx_obj))
	{
		self.fx_obj = spawn( localClientNum, self.origin, "script_model" );
		self.fx_obj.angles = self.angles;
		self.fx_obj setmodel( "tag_origin" ); 
	}
	
	if(!IsDefined(self.fx_obj_2))
	{
		self.fx_obj_2 = spawn( localClientNum, self.origin, "script_model" );
		self.fx_obj_2.angles = self.angles;
		self.fx_obj_2 setmodel( "tag_origin" ); 
	}
			
	if( newVal == 0 ) // BOX CLOSED
	{
		StopFX( localClientNum, self.fx_obj.curr_open_fx );
		self.fx_obj_2 StopLoopSound (1);
		self notify( "magicbox_portal_finished" );
	}
	else if( newVal == 1 ) // BOX OPEN
	{
		self.fx_obj.curr_open_fx = PlayFXOnTag( localClientNum, level._effect["box_is_open"], self.fx_obj, "tag_origin" );
		self.fx_obj_2 PlayLoopSound ("zmb_hellbox_open_effect");
		self thread fx_magicbox_portal( localClientNum );
	}
}

function fx_magicbox_portal( localClientNum )
{
	self endon( "magicbox_portal_finished" );
	
	wait 0.5;
	
	while ( true )
	{
		self.fx_obj_2.curr_portal_fx = PlayFXOnTag( localClientNum, level._effect["box_portal"], self.fx_obj_2, "tag_origin" );	
		wait 0.1;
	}
}

function magicbox_initial_closed_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(!IsDefined(self.fx_obj))
	{
		self.fx_obj = spawn( localClientNum, self.origin, "script_model" );
		self.fx_obj.angles = self.angles;
		self.fx_obj setmodel( "tag_origin" ); 
	}
	else
	{
		return; //-- early out if something else has already played an fx	
	}
			
	if( newVal == 1 ) // HERE AMBIENT
	{
		self.fx_obj playloopsound( "zmb_hellbox_amb_low" );
	}
}

function magicbox_ambient_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(!IsDefined(self.fx_obj))
	{
		self.fx_obj = spawn( localClientNum, self.origin, "script_model" );
		self.fx_obj.angles = self.angles;
		self.fx_obj setmodel( "tag_origin" ); 
	}
		
	if( IsDefined( self.fx_obj.curr_amb_fx ) )
	{
		StopFX( localClientNum, self.fx_obj.curr_amb_fx );
	}
	
	if( IsDefined( self.fx_obj.curr_amb_fx_power ) )
	{
		StopFX( localClientNum, self.fx_obj.curr_amb_fx_power );
	}
	
	if( newVal == 0 ) // NOT HERE AND POWER OFF
	{
		self.fx_obj playloopsound( "zmb_hellbox_amb_low" );
		playsound( 0, "zmb_hellbox_leave", self.fx_obj.origin );
		StopFX( localClientNum, self.fx_obj.curr_amb_fx );
	}
	else if( newVal == 1 ) // HERE AND POWER OFF
	{
		self.fx_obj.curr_amb_fx_power = PlayFXOnTag( localClientNum, level._effect["box_unpowered"], self.fx_obj, "tag_origin" );
		self.fx_obj.curr_amb_fx = PlayFXOnTag( localClientNum, level._effect["box_here_ambient"], self.fx_obj, "tag_origin" );
		self.fx_obj playloopsound( "zmb_hellbox_amb_low" );
		playsound( 0, "zmb_hellbox_arrive", self.fx_obj.origin );
	}
	else if( newVal == 2 ) // HERE AND POWER ON
	{
		self.fx_obj.curr_amb_fx_power = PlayFXOnTag( localClientNum, level._effect["box_powered"], self.fx_obj, "tag_origin" );
		self.fx_obj.curr_amb_fx = PlayFXOnTag( localClientNum, level._effect["box_here_ambient"], self.fx_obj, "tag_origin" );
		self.fx_obj playloopsound( "zmb_hellbox_amb_high" );	
		playsound( 0, "zmb_hellbox_arrive", self.fx_obj.origin );
	}
	else if( newVal == 3 ) // NOT HERE AND POWER ON
	{
		self.fx_obj.curr_amb_fx_power = PlayFXOnTag( localClientNum, level._effect["box_unpowered"], self.fx_obj, "tag_origin" ); // prod decided they like the red light
		self.fx_obj.curr_amb_fx = PlayFXOnTag( localClientNum, level._effect["box_gone_ambient"], self.fx_obj, "tag_origin" );
		self.fx_obj playloopsound( "zmb_hellbox_amb_high" );	
		playsound( 0, "zmb_hellbox_leave", self.fx_obj.origin );
	}
}
