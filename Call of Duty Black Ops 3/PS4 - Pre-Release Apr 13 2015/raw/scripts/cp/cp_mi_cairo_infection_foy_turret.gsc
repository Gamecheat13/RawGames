#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace foy_turret;

function autoexec __init__sytem__() {     system::register("foy_turret",&__init__,undefined,undefined);    }

function __init__()
{
	
}

class cFoyTurret
{
	var m_vehicle;
	var m_t_gunner;
	
	constructor()
	{
	
	}
	
	destructor()
	{
		
	}
	
	function turret_setup( vehicle, str_gunner_name, str_gunner_trigger )
	{	
		m_vehicle = vehicle;
		m_vehicle flag::init( "gunner_position_occupied" );
		
		if ( IsDefined( str_gunner_name ) )
		{
			sp_gunner = GetEnt( str_gunner_name, "targetname" );
			
			ai_gunner = spawner::simple_spawn_single( sp_gunner );
			
			ai_gunner vehicle::get_in( m_vehicle, "gunner1", true );
		}
		
		if ( IsDefined( str_gunner_trigger ) )
		{
			m_t_gunner = GetEnt( str_gunner_trigger, "targetname" );
		}
		
		self thread turret_think();
	}
	
	function turret_think()
	{
		m_vehicle endon( "death" );
		
		self thread vehicle_death();
		
		self waittill( "gunner_start_think" );
		
		if ( IsDefined( m_t_gunner ) )
		{
			self thread gunner_think( true );
		}
		else
		{
			self thread gunner_think( false );
		}
	}
	
	function gunner_start_think()
	{
		self notify( "gunner_start_think" );
	}
	
	function gunner_think( b_find_new_gunner = false ) // self = vehicle
	{
		m_vehicle endon( "death" );
		
		const GUNNER_CHECK_TIME_MIN = 4;
		const GUNNER_CHECK_TIME_MAX = 5;
		
		// set burst fire parameters
		const FIRE_TIME_MIN = 1.0;
		const FIRE_TIME_MAX = 2.0;
		const FIRE_WAIT_MIN = 0.25;
		const FIRE_WAIT_MAX = 0.75;
		
		m_vehicle turret::set_burst_parameters( FIRE_TIME_MIN, FIRE_TIME_MAX, FIRE_WAIT_MIN, FIRE_WAIT_MAX, 0 );
		
		while ( true )
		{		
			ai_gunner = m_vehicle vehicle::get_rider( "gunner1" );
			
			if ( IsDefined( ai_gunner ) )
			{			
				m_vehicle turret::enable( 1, true );
				
				m_vehicle flag::set( "gunner_position_occupied" );
				
				ai_gunner waittill( "death" );  // TODO: add check on turret exit, if we ever want that
			}
			
			m_vehicle turret::disable( 1 );
			m_vehicle flag::clear( "gunner_position_occupied" );
			
			if ( b_find_new_gunner )
			{
				wait RandomFloatRange( GUNNER_CHECK_TIME_MIN, GUNNER_CHECK_TIME_MAX );
					
				ai_gunner_next = find_new_gunner();
			
				if ( IsAlive( ai_gunner_next ) )
				{		
					ai_gunner_next thread vehicle::get_in( m_vehicle, "gunner1", false );  // gunner runs to turret
					ai_gunner_next util::waittill_any( "death", "in_vehicle" );  // 'in_vehicle' sent from vehicleriders_shared.gsc
				}
			}
			else
			{
				break;
			}
		}
	}

	function delete_gunner()
	{	
		ai_gunner = m_vehicle vehicle::get_rider( "gunner1" );
		
		if ( IsDefined( ai_gunner ) )
		{		
			ai_gunner Delete();
		};
	}
	
	function vehicle_death()  // self = vehicle
	{
		m_vehicle waittill( "death" );
		
		delete_gunner();
		
		m_vehicle = undefined;
	}
	
	function find_new_gunner()
	{
		a_enemies = GetAITeamArray( "axis" );
		a_valid = [];
		
		foreach ( e_enemy in a_enemies )
		{
			if ( IsAlive( e_enemy ) )
			{
				if ( e_enemy IsTouching( m_t_gunner ) )
				{
					if ( !isdefined( a_valid ) ) a_valid = []; else if ( !IsArray( a_valid ) ) a_valid = array( a_valid ); a_valid[a_valid.size]=e_enemy;;
				}
			}
		}
		
		ai_gunner = ArraySort( a_valid, m_vehicle.origin, true, a_valid.size )[ 0 ];
	
		return ai_gunner;
	}
	
	function get_vehicle()
	{
		return m_vehicle;
	}
}

