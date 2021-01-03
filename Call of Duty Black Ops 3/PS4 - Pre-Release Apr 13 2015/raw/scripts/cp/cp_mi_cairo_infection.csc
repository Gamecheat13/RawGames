#using scripts\codescripts\struct;

#using scripts\cp\_util;
#using scripts\cp\_load;
#using scripts\shared\util_shared;

#using scripts\cp\cp_mi_cairo_infection_fx;
#using scripts\cp\cp_mi_cairo_infection_sound;
#using scripts\cp\cp_mi_cairo_infection_util;

#using scripts\cp\cp_mi_cairo_infection_theia_battle;
#using scripts\cp\cp_mi_cairo_infection_sim_reality_starts;
#using scripts\cp\cp_mi_cairo_infection_sgen_test_chamber;

#using scripts\cp\_siegebot_theia;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

                                               	                                                          	              	                                                                                           

function main()
{
	util::set_streamer_hint_function( &force_streamer, 7 );

	cp_mi_cairo_infection_fx::main();
	cp_mi_cairo_infection_sound::main();

	cp_mi_cairo_infection_theia_battle::main();
	cp_mi_cairo_infection_sim_reality_starts::main();
	cp_mi_cairo_infection_sgen_test_chamber::main();
		
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
        case 1:
            ForceStreamBundle( "cin_inf_01_01_vtolarrival_1st_encounter_v2" );
            break;
        case 7:
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh010" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh020" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh030" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh040" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh050" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh060" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh070" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh080" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh090" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh100" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh110" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh120" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh130" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh140" );
			ForceStreamBundle( "cin_inf_04_humanlabdeath_3rd_sh150" );
			break;    
        case 3:
            ForceStreamBundle( "cin_inf_04_02_sarah_vign_01" );
            ForceStreamBundle( "cin_inf_05_taylorinfected_3rd_sh010" );
            ForceStreamBundle( "cin_inf_05_taylorinfected_3rd_sh020" );
            ForceStreamBundle( "cin_inf_05_taylorinfected_3rd_sh030" );
            ForceStreamBundle( "cin_inf_05_taylorinfected_3rd_sh040" );
            ForceStreamBundle( "cin_inf_05_taylorinfected_3rd_sh050" );
            ForceStreamBundle( "cin_inf_05_taylorinfected_3rd_sh060" );
            ForceStreamBundle( "cin_inf_05_taylorinfected_3rd_sh070" );
            ForceStreamBundle( "cin_inf_05_taylorinfected_3rd_sh080" );
             
            break;
        default:
            break;
    }
}