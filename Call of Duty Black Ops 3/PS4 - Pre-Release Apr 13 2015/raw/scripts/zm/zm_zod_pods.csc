    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\shared\system_shared;
	
#namespace zm_zod_pods;


function autoexec __init__sytem__() {     system::register("zm_zod_pods",&__init__,undefined,undefined);    }
	
	










	


#precache( "client_fx", "zombie/fx_fungus_pod_explo_blue_zod_zmb" );
#precache( "client_fx", "zombie/fx_fungus_pod_explo_green_zod_zmb" );
#precache( "client_fx", "zombie/fx_fungus_pod_explo_zod_zmb" );
#precache( "client_fx", "zombie/fx_fungus_pod_ambient_blue_zod_zmb" );
#precache( "client_fx", "zombie/fx_fungus_pod_ambient_green_zod_zmb" );
#precache( "client_fx", "zombie/fx_fungus_pod_ambient_zod_zmb" );

function __init__()
{
	clientfield::register( "scriptmover", "pod_level", 1, 2, "int", &update_pod_level, !true, !true );
	clientfield::register( "scriptmover", "pod_harvest", 1, 1, "int", &play_harvested_fx, !true, !true );
}

function pod_pulsate()
{
	self endon( "entityshutdown" );
	
	self.pod_scale = 0.1;
	b_growing = true;
	n_stepsize = 0.00025;
	n_pulse_size = 0.01;
	n_goal_scale = self.pod_base_scale + n_pulse_size;
	
	while ( true )
	{
		// If we're changing sizes, move faster.
		if ( b_growing && (n_goal_scale - self.pod_scale) > (n_pulse_size * 2.0) )
		{
			n_stepsize = 0.0025;
		}
		else
		{
			n_stepsize = 0.00025;
		}
		
		if ( b_growing )
		{
			if ( self.pod_scale >= n_goal_scale )
			{
				n_goal_scale = self.pod_base_scale - n_pulse_size;
				b_growing = false;
			}
			else
			{
				self.pod_scale += n_stepsize;
			}
		}
		else
		{
			if ( self.pod_scale <= n_goal_scale )
			{
				n_goal_scale = self.pod_base_scale + n_pulse_size;
				b_growing = true;
			}
			else
			{
				self.pod_scale -= n_stepsize;
			}
		}
		
		self.e_model SetScale( self.pod_scale );
		wait 0.001;
	}
}

function delete_pod_model()
{
	e_model = self.e_model;
	self waittill( "entityshutdown" );
	e_model Delete();
}

function update_pod_level( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !isdefined( self.e_model ) )
	{
		self.e_model = Spawn( localClientNum, self.origin, "script_model" );
	}
	switch( newVal )
	{
		case 1:
			if( isDefined( self.ambient_fx) )
			{
				StopFX( localClientNum, self.ambient_fx );
			}
			self.pod_base_scale = 0.5;
			self.e_model SetModel( "p7_zm_zod_fungus_pod_green" );
			self.ambient_fx = PlayFX( localClientNum, "zombie/fx_fungus_pod_ambient_green_zod_zmb", self.origin );
			break;
		case 2:
			if( isDefined( self.ambient_fx) )
			{
				StopFX( localClientNum, self.ambient_fx );
			}
			self.pod_base_scale = 0.75;
			self.e_model SetModel( "p7_zm_zod_fungus_pod" );
			self.ambient_fx = PlayFX( localClientNum, "zombie/fx_fungus_pod_ambient_zod_zmb", self.origin );
			break;
		case 3:
			if( isDefined( self.ambient_fx) )
			{
				StopFX( localClientNum, self.ambient_fx );
			}
			self.pod_base_scale = 1.0;
			self.e_model SetModel( "p7_zm_zod_fungus_pod_blue" );
			self.ambient_fx = PlayFX( localClientNum, "zombie/fx_fungus_pod_ambient_blue_zod_zmb", self.origin );
			break;
	}
	
	if ( !isdefined( self.pod_scale ) )
	{
		self thread delete_pod_model();
		self thread pod_pulsate();
	}
}


//self is the pod that has been harvested
function play_harvested_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	if( newVal === 0 )
		return;
	
	StopFX( localClientNum , self.ambient_fx );
	
	if( self.e_model.model === "p7_zm_zod_fungus_pod_green" )
	{
		explosion_fx = PlayFX( localClientNum, "zombie/fx_fungus_pod_explo_green_zod_zmb", self.origin );
	}

	if( self.e_model.model === "p7_zm_zod_fungus_pod" )
	{
		explosion_fx = PlayFX( localClientNum, "zombie/fx_fungus_pod_explo_zod_zmb", self.origin );
	}
		
	if( self.e_model.model === "p7_zm_zod_fungus_pod_blue" )
	{
		explosion_fx = PlayFX( localClientNum, "zombie/fx_fungus_pod_explo_blue_zod_zmb", self.origin );
	}
	
	wait 10;
	
	StopFX( localClientNum , explosion_fx );

}