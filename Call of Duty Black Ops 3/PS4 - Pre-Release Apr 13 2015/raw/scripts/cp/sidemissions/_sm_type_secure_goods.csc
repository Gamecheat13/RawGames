#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

          





	
#precache( "client_fx", "electric/fx_elec_sparks_dir_wire_sm_orange" );

function autoexec __init__sytem__() {     system::register("sm_type_secure_goods",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "toplayer", "sm_secure_goods_sfx", 			1, 1, "int", 					&callback_set_sfx, !true, !true );
	clientfield::register( "toplayer", "sm_secure_goods_blur", 			1, 7, "float", 			&callback_set_blur, !true, !true );
	clientfield::register( "toplayer", "sm_secure_goods_intensity", 1, 7, "float", 	&callback_set_intensity, !true, !true );
	clientfield::register( "toplayer", "sm_secure_goods_visionset", 1, 7, "float", 	&callback_set_visionset, !true, !true );
	
	clientfield::register( "scriptmover", "sm_secure_goods_circuit_breaker_panel_fx", 1, 1, "int", 	&callback_circuit_breaker_panel_fx, !true, !true );
	
	// Clientfields to be handled by LUI.
	clientfield::register( "world", "sm_ransack_inv_unobtanium_a", 1, 3, "int", undefined, !true, true );
	clientfield::register( "world", "sm_ransack_inv_unobtanium_b", 1, 3, "int", undefined, !true, true );
	clientfield::register( "world", "sm_ransack_inv_unobtanium_c", 1, 3, "int", undefined, !true, true );
	SetupClientFieldCodeCallbacks( "world", 3, "sm_ransack_inv_unobtanium_a", "sm_ransack_inv_unobtanium_b", "sm_ransack_inv_unobtanium_c" );
}

function callback_set_sfx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	SetDvar( "r_radioactiveFX_enable", newVal );
	
	if ( newVal != oldVal )
	{
		SetDvar( "r_radioactiveIntensity", 0 );
	}
}

function callback_set_blur( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	n_blur_amount = math::linear_map( newVal, 0.00, 1.00, 0.00, 2.00 );
	
	SetDvar( "r_radioactiveBlur", n_blur_amount );
}

function callback_set_intensity( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	n_intensity_amount = math::linear_map( newVal, 0.00, 1.00, 0.00, 2.00 );
	
	SetDvar( "r_radioactiveIntensity", n_intensity_amount );
}

function callback_set_visionset( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	VisionSetNakedLerp( localClientNum, "radiation", "default", newVal );  // IMPORTANT: this is a TEMP way of transitioning a visionset until visionset_mgr supports smooth transitions to environmental visionsets. -TJanssen 3/4/2014
}

function callback_circuit_breaker_panel_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		self spark_fx_add_left( localClientNum );
	}
	else if ( newVal == 2 )
	{
		self spark_fx_add_right( localClientNum );
	}
	else  // can be 'off' or unused value
	{
		self spark_fx_remove( localClientNum );
	}
}

function spark_fx_add_left( localClientNum )  // self = scriptmover
{
	self spark_fx_remove_left( localClientNum );
	
	self.a_fx_left[ localClientNum ] = PlayFXOnTag( localClientNum, "electric/fx_elec_sparks_dir_wire_sm_orange", self, "j_wire_blue" );
}

function spark_fx_add_right( localClientNum )  // self = scriptmover
{
	self spark_fx_remove_right( localClientNum );
	
	self.a_fx_red[ localClientNum ] = PlayFXOnTag( localClientNum, "electric/fx_elec_sparks_dir_wire_sm_orange", self, "j_wire_red" );
}

function spark_fx_remove( localClientNum )
{
	self spark_fx_remove_right( localClientNum );
	self spark_fx_remove_left( localClientNum );
}

function spark_fx_remove_right( localClientNum )  // self = scriptmover
{
	if ( !IsDefined( self.a_fx_right ) )
	{
		self.a_fx_right = [];
	}
	
	if ( IsDefined( self.a_fx_right[ localClientNum ] ) )
	{
		DeleteFX( localClientNum, self.a_fx_right[ localClientNum ], false );
	}
}

function spark_fx_remove_left( localClientNum )  // self = scriptmover
{
	if ( !IsDefined( self.a_fx_left ) )
	{
		self.a_fx_left = [];
	}
	
	if ( IsDefined( self.a_fx_left[ localClientNum ] ) )
	{
		DeleteFX( localClientNum, self.a_fx_left[ localClientNum ], false );
	}
}

