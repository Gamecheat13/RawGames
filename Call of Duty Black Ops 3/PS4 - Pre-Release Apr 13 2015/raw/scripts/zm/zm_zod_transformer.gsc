/* zm_zod_transformer.gsc
 *
 * Purpose : 	Transformer which must be ripped open and electrified using Beast Mode from ZM_ZOD.
 *		
 * Author : 	G Henry Schmitt
 * 
 * 
 */
 
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#using scripts\zm\_zm_altbody_beast;




#namespace zm_zod_transformer;



#using_animtree( "generic" );

function autoexec __init__sytem__() {     system::register("zm_zod_transformer",undefined,&__main__,undefined);    }

function __main__()
{
	wait(0.05);
	level thread init_transformers();
}

function init_transformers()
{
	if(!isdefined(level.beast_mode_targets))level.beast_mode_targets=[];

	if( !isdefined( level.a_o_beast_transformers ) )
	{
		level.a_o_beast_transformers = [];
		init_transformer( "slums",					1 );
		init_transformer( "canal",					2 );
		init_transformer( "theater",					3 );
		init_transformer( "start",					4 );
		init_transformer( "underground",				5 );
		init_transformer( "slums" + "_stairs",		1 + 10 );
		init_transformer( "canal" + "_stairs",		2 + 10 );
		init_transformer( "theater" + "_stairs",		3 + 10 );
		init_transformer( "start" + "_stairs",		4 + 10 );
		init_transformer( "underground" + "_stairs",	5 + 10 );
		init_transformer( "brothel",					6 );
		init_transformer( "junction_crane",			20 );
		init_transformer( "club",					21 );
		init_transformer( "robot",					22 );
	}
}

function init_transformer( str_areaname, n_power_index )
{
	if( !isdefined( level.a_o_beast_transformers[ n_power_index ] ) )
	{
		level.a_o_beast_transformers[ n_power_index ] = new cTransformer();
		[[ level.a_o_beast_transformers[ n_power_index ] ]]->init_transformer( str_areaname );
	}
}


class cTransformer
{
	// triggers, entities
	var m_t_elec_triggers; // elec-trigger to activate power
	var m_a_e_bodies; // transformer body (door animation is played on this)
	
	// state / stats
	
	// settings
	var m_str_areaname; // the part of the map this transformer is in
	var m_n_power_index; // the power index that this transformer will turn on

	var m_b_discovered;
	
	// str_targetname = targetname of an array of script_models / script_brushmodels in the map that are the steps
	function init_transformer( str_areaname )
	{
		m_str_areaname	= str_areaname;
		
		a_t_elec_triggers		= GetEntArray( "use_elec_switch",			"targetname" );
		a_e_bodies				= GetEntArray( "transformer_body",			"targetname" );
		
		m_t_elec_triggers		= array::filter( a_t_elec_triggers,		false, &filter_areaname, str_areaname );
		m_a_e_bodies			= array::filter( a_e_bodies,			false, &filter_areaname, str_areaname );
		
		foreach( e_body in m_a_e_bodies )
		{
			e_body UseAnimTree( #animtree );
			if( isdefined( e_body.script_linkto ) )
			{
				e_body EnableLinkTo();
				e_linkto = GetEnt( e_body.script_linkto, "targetname" );
 				e_body LinkTo( e_linkto );
			}
			self thread transformer_think( e_body ); 
		}
		
		m_b_discovered			= false;
		
		// watch grapple trigger
		self thread				elec_trigger_think();
	}
	
	function filter_areaname( e_entity, str_areaname )
	{
		if( !isdefined( e_entity.script_string ) || ( e_entity.script_string != str_areaname ) )
		{
			return false;
		}
		return true;
	}

	function elec_trigger_think()
	{
		foreach( e_body in m_a_e_bodies )
		{
			e_body clientfield::set( "bminteract", 1 ); // turn on interact shader
		}
		
		foreach( t_elec in m_t_elec_triggers )
		{
			self thread elec_trigger_wait( t_elec );
		}
		
		self waittill( "elec_trigger" );
		
		foreach( e_body in m_a_e_bodies )
		{
			e_body clientfield::set( "bminteract", 0 ); // turn off interact shader
			e_body SetAnim( %p7_fxanim_zm_zod_beast_transformer_open_anim ); // animate door opening
			e_body notify("transformer_opened");
		}
	}
	
	function elec_trigger_wait( t_elec )
	{
		self endon( "elec_trigger" ); // duplicate threads won't remain
		
		t_elec waittill( "trigger" );
		self notify( "elec_trigger" );
	}
	
	function transformer_think( e_body )
	{
		e_body endon("transformer_opened");
		e_body zm_altbody_beast::watch_lightning_damage( m_t_elec_triggers );
	}
	
	
}
