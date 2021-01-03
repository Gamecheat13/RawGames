#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\string_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
#using scripts\cp\_load;
#using scripts\shared\util_shared;
#using scripts\cp\cp_ctistaert_test_amb;
#using scripts\cp\cp_ctistaert_test_fx;

// Test clientside script for cp_ctistaert_test
 //from Barry's test map
 //from Barry's test map

function main()
{
	// _load!
	load::main();

	cp_ctistaert_test_fx::main();

	thread cp_ctistaert_test_amb::main();

	// This needs to be called after all systems have been registered.
	util::waitforclient( 0 );

	/# println("*** Client : cp_ctistaert_test running..."); #/
	level thread setup_fx_triggers(); //from Barry's test map			
}

//VVV from Barry's test map VVV

function setup_fx_triggers()
{
	t_client_one_shot_start = getent( 0, "start_one_shot_client", "targetname" );
	t_client_one_shot_stop = getent( 0, "stop_one_shot_client", "targetname" );
	t_client_loop_start = getent( 0, "start_loop_client", "targetname" );
	t_client_loop_stop = getent( 0, "stop_loop_client", "targetname" );	
	
	t_client_one_shot_start thread fire_one_shot( "exploder_test_client_oneshot" );
	t_client_one_shot_stop thread stop_one_shot( "exploder_test_client_oneshot" );
	t_client_loop_start thread fire_one_shot( "exploder_loop_client" );
	t_client_loop_stop thread stop_one_shot( "exploder_loop_client" );	
}

function fire_one_shot( str_effect )
{
	self endon( "death" );
	
	while( true )
	{
		self waittill( "trigger", e_triggered );
		n_client = e_triggered GetLocalClientNumber();
		PlayRadiantExploder( n_client, str_effect );
		util::wait_till_not_touching( e_triggered, self );
	}
}

function stop_one_shot( str_effect )
{
	self endon( "death" );
	
	while( true )
	{
		self waittill( "trigger", e_triggered );
		n_client = e_triggered GetLocalClientNumber();
		StopRadiantExploder( n_client, str_effect );
		util::wait_till_not_touching( e_triggered, self );
	}	
}

