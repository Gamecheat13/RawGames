#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                    	   	  	

#using scripts\shared\system_shared;

function autoexec __init__sytem__() {     system::register("gadget_shock_field",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "allplayers", "shock_field" , 1, 1, "int" );
	
	ability_player::register_gadget_activation_callbacks( 39, &gadget_shock_field_on, &gadget_shock_field_off );
	ability_player::register_gadget_possession_callbacks( 39, &gadget_shock_field_on_give, &gadget_shock_field_on_take );
	ability_player::register_gadget_flicker_callbacks( 39, &gadget_shock_field_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 39, &gadget_shock_field_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 39, &gadget_shock_field_is_flickering );

	callback::on_connect( &gadget_shock_field_on_connect );
}

function gadget_shock_field_is_inuse( slot )
{
	// returns true when the gadget is on
	return self GadgetIsActive( slot );
}

function gadget_shock_field_is_flickering( slot )
{
	// returns true when the gadget is flickering
}

function gadget_shock_field_on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function gadget_shock_field_on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
	self clientfield::set( "shock_field", 0 );
}

function gadget_shock_field_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
	self clientfield::set( "shock_field", 0 );
}

//self is the player
function gadget_shock_field_on_connect()
{
	// setup up stuff on player connect	
}

function gadget_shock_field_on( slot, weapon )
{
	// excecutes when the gadget is turned on
	self GadgetSetActivateTime( slot, GetTime() );
	self thread shock_field_think( slot, weapon );
	self clientfield::set( "shock_field", 1 );
}

function gadget_shock_field_off( slot, weapon )
{
	// excecutes when the gadget is turned off`
	self notify ( "shock_field_off" );
	self clientfield::set( "shock_field", 0 );
}

function shock_field_think( slot, weapon )
{
	self endon ( "shock_field_off" );
	
	self notify ( "shock_field_on" );
	self endon( "shock_field_on" );
	
	while( 1 )
	{
		wait ( .25 );
		
		if ( !self gadget_shock_field_is_inuse( slot ) )
		{
			return;
		}
		
		entities = GetDamageableEntArray( self.origin, weapon.gadget_shockfield_radius );
		foreach( entity in entities )
		{
			if( IsPlayer( entity ) )
			{
				if( self GetEntityNumber() == entity GetEntityNumber() )
				{
					continue;
				}
				
				if( self.team == entity.team )
				{
					continue;
				}
				
				if ( !IsAlive( entity ) )
				{
					continue;
				}
				
				if ( BulletTracePassed( self.origin + ( 0, 0, 30 ), entity.origin + ( 0, 0, 30 ), true, self, undefined, false, true ) )
				{
					entity DoDamage( weapon.gadget_shockfield_damage, self.origin + ( 0, 0, 30 ), self, self, 0, "MOD_GRENADE_SPLASH" );
					entity setdoublejumpenergy( 0 );
					entity resetdoublejumprechargetime();
					entity thread shock_field_zap_sound( weapon );
					self thread flicker_field_fx();
						
					shellshock_duration = .25;
					
					if ( entity util::mayApplyScreenEffect() )
					{
						shellshock_duration = 0.5;
						entity shellshock("proximity_grenade", shellshock_duration, false );
					}
				}
			}
		}
	}
}

function shock_field_zap_sound( weapon )
{
	if ( ( isdefined( self.shock_field_zap_sound ) && self.shock_field_zap_sound ) )
		return;
	self.shock_field_zap_sound=true;
	self playsound("wpn_taser_mine_zap");
	wait 1.0;
	if ( IsDefined(self) )
		self.shock_field_zap_sound=false;
	
}

function flicker_field_fx()
{
	self endon ( "shock_field_off" );
	self notify( "flicker_field_fx" );
	self endon ( "flicker_field_fx" );
	self clientfield::set( "shock_field", 0 );
	wait RandomFloatRange(0.03,0.23);
	if (IsDefined(self))
		self clientfield::set( "shock_field", 1 );
}

