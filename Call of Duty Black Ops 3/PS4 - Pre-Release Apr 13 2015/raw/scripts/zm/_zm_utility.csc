#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_buildables;
#using scripts\zm\_zm_powerups;

#namespace zm_utility;

/@
"Name: ignore_triggers( <timer> )"
"Summary: Makes the entity that this is threaded on not able to set off triggers for a certain length of time."
"Module: Utility"
"CallOn: an entity"
"Example: guy thread ignore_triggers( 0.2 );"
"SPMP: singleplayer"
@/ 
function ignore_triggers( timer )
{
	// ignore triggers for awhile so others can trigger the trigger we're in.
	self endon( "death" ); 
	self.ignoreTriggers = true; 
	if( IsDefined( timer ) )
	{
		wait( timer ); 
	}
	else
	{
		wait( 0.5 ); 
	}
	self.ignoreTriggers = false; 
}

////////////////////////////// Callbacks ////////////////////////////////////////////

function is_encounter()
{
	if(( isdefined( level._is_encounter ) && level._is_encounter ))
	{
		return true;
	}
	dvar = GetDvarString( "ui_zm_gamemodegroup" );
	if(dvar == "zencounter")
	{
		level._is_encounter = true;
		return true;
	}	
	
	return false;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// WEAPONS
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function spawn_weapon_model( localClientNum, weapon, model, origin, angles, options )
{
	if ( !isdefined( model ) )
	{
		model = weapon.worldModel;
	}
	
	weapon_model = spawn( localClientNum, origin, "script_model" ); 
	if ( isdefined( angles ) )
	{
		weapon_model.angles = angles;
	}

	if (isdefined(options))
	{
		weapon_model useweaponmodel( weapon, model, options );
	}
	else
	{
		weapon_model useweaponmodel( weapon, model );
	}

	return weapon_model;
}

function is_classic()
{
	dvar = GetDvarString( "ui_zm_gamemodegroup" );
	
	if ( dvar == "zclassic" )
	{
		return true;
	}
	
	return false;
}

function is_gametype_active( a_gametypes )
{
	b_is_gametype_active = false;
	
	if ( !IsArray( a_gametypes ) )
	{
		a_gametypes = Array( a_gametypes );
	}
	
	for ( i = 0; i < a_gametypes.size; i++ )
	{
		if ( GetDvarString( "g_gametype" ) == a_gametypes[ i ] )
		{
			b_is_gametype_active = true;
		}
	}

	return b_is_gametype_active;
}
