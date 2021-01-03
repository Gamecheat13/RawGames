#using scripts\codescripts\struct;

#using scripts\cp\_load;
#using scripts\cp\_util;
#using scripts\shared\util_shared;

#using scripts\cp\cp_mi_cairo_infection_church;
#using scripts\cp\cp_mi_cairo_infection_sgen_server_room;
#using scripts\cp\cp_mi_cairo_infection_forest;
#using scripts\cp\cp_mi_cairo_infection_murders;
#using scripts\cp\cp_mi_cairo_infection_village;
#using scripts\cp\cp_mi_cairo_infection_village_surreal;
#using scripts\cp\cp_mi_cairo_infection_underwater;
#using scripts\cp\cp_mi_cairo_infection_util;
#using scripts\cp\cp_mi_cairo_infection_tiger_tank;

#using scripts\cp\cp_mi_cairo_infection2_fx;
#using scripts\cp\cp_mi_cairo_infection2_sound;

#using scripts\shared\vehicles\_quadtank;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                               	                                                          	              	                                                                                           
                                                           

//--------------------------------------------------------------------------------------------------
// 	main
//--------------------------------------------------------------------------------------------------
function main()
{
	util::set_streamer_hint_function( &force_streamer, 7 );

	cp_mi_cairo_infection2_fx::main();
	cp_mi_cairo_infection2_sound::main();
	church::main();
	sgen_server_room::main();
	cp_mi_cairo_infection_forest::main();
	village::main();
	village_surreal::main();
	blackstation_murders::main();		
	underwater::main();

	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}

//--------------------------------------------------------------------------------------------------
// 	force_streamer
//--------------------------------------------------------------------------------------------------
function force_streamer( n_zone )
{
    switch ( n_zone )
    {
        case 6:
			ForceStreamBundle( "cin_inf_05_taylorinfected_server_3rd_sh010" );
			ForceStreamBundle( "cin_inf_05_taylorinfected_server_3rd_sh020" );
			ForceStreamBundle( "cin_inf_05_taylorinfected_server_3rd_sh030" );
			ForceStreamBundle( "cin_inf_05_taylorinfected_server_3rd_sh040" );
			ForceStreamBundle( "cin_inf_05_taylorinfected_server_3rd_sh050" );
			ForceStreamBundle( "cin_inf_05_taylorinfected_server_3rd_sh060" );
			ForceStreamBundle( "cin_inf_05_taylorinfected_server_3rd_sh070" );
			ForceStreamBundle( "cin_inf_05_taylorinfected_server_3rd_sh080" );
			ForceStreamBundle( "cin_inf_05_taylorinfected_server_3rd_sh090" );
			break;
    	    	
    	case 2:
            ForceStreamBundle( "cin_inf_08_blackstation_3rd_sh010" );
            ForceStreamBundle( "cin_inf_08_blackstation_3rd_sh020" );
            ForceStreamBundle( "cin_inf_08_blackstation_3rd_sh030" );
            ForceStreamBundle( "cin_inf_08_blackstation_3rd_sh040" );
            ForceStreamBundle( "cin_inf_08_blackstation_3rd_sh050" );
            ForceStreamBundle( "cin_inf_08_blackstation_3rd_sh060" );
            ForceStreamBundle( "cin_inf_08_blackstation_3rd_sh070" );
            ForceStreamBundle( "cin_inf_08_blackstation_3rd_sh080" );
            ForceStreamBundle( "cin_inf_08_blackstation_3rd_sh090" );
            ForceStreamBundle( "cin_inf_08_blackstation_3rd_sh100" );
            ForceStreamBundle( "cin_inf_08_blackstation_3rd_sh110" );
            ForceStreamBundle( "cin_inf_08_03_blackstation_vign_aftermath" );
            ForceStreamBundle( "cin_inf_07_04_sarah_vign_03" );
            break;
       
        case 4:
            ForceStreamBundle( "cin_inf_07_04_sarah_vign_03" );
            break;
           
        default:
            break;
    }
}