#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       




#namespace parasite;

function autoexec main()
{	
	clientfield::register( "vehicle", "parasite_tell_fx", 1, 1, "int", &parasiteTellFxHandler, !true, !true );
	clientfield::register( "toplayer", "parasite_damage", 1, 1, "counter", &parasite_damage, !true, !true );
	clientfield::register( "vehicle", "parasite_secondary_deathfx", 1, 1, "int", &parasiteSecondaryDeathFxHandler, !true, !true );
	
	vehicle::add_vehicletype_callback( "parasite", &_setup_ );
}

function private parasiteTellFxHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{	
	if ( IsDefined( self.tellFxHandle ) )
	{
		StopFX( localClientNum, self.tellFxHandle );
		self.tellFxHandle = undefined;
		self MapShaderConstant( localClientNum, 0, "scriptVector2", 0.1 );
	}
	
	settings = struct::get_script_bundle( "vehiclecustomsettings", "parasitesettings" );
	
	if( IsDefined( settings ) )
	{
		if( newValue )
		{
			self.tellFxHandle = PlayFXOnTag( localClientNum, settings.weakspotfx, self, "tag_flash" );
			self MapShaderConstant( localClientNum, 0, "scriptVector2", 1.0 );
		}
	}
}

function private parasite_damage( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( newValue )
	{
		self postfx::PlayPostfxBundle( "pstfx_parasite_dmg" );
	}
}

function private parasiteSecondaryDeathFxHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	settings = struct::get_script_bundle( "vehiclecustomsettings", "parasitesettings" );
	
	if( IsDefined( settings ) )
	{
		if( newValue )
		{
			PlayFX( localClientNum, settings.secondary_death_fx_1, self GetTagOrigin( settings.secondary_death_tag_1 ) );
		}
	}
}

function private _setup_( localClientNum )
{	
	self MapShaderConstant( localClientNum, 0, "scriptVector2", 0.1 );
}