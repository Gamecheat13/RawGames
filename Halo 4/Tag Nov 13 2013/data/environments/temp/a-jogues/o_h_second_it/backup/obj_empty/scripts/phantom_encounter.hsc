// =================================================================================================
// GLOBAL_PHANTOM.HSC
// HOW TO USE:
// 	1. Open your scenario in Sapien
//	2. In the menu bar, open the "Scenarios" menu, then select "Add Mission Script"
//	3. Point the dialogue to this file: main\data\globals\global_phantom.hsc
// =================================================================================================
global boolean b_debug_phantom = false;

/*
== LOAD PARAMETERS ==
1 - LEFT 
2 - RIGHT 
3 - DUAL 
4 - OUT THE CHUTE 
*/

// call this script to load up the phantom before flying it into position ================================================================
script static void	f_load_phantom ( vehicle phantom,		// phantom to load 
								string load_side,		// how to load it 
								ai load_squad_01,		// squads to load 
								ai load_squad_02,
								ai load_squad_03,
								ai load_squad_04   )
			
				
	// place ai 
	ai_place (load_squad_01);
	ai_place (load_squad_02);
	ai_place (load_squad_03);
	ai_place (load_squad_04);
	sleep (1);

		// left 
		if ( load_side == "left") then

							if ( b_debug_phantom ) then
								print ("load phantom left...");
							end
							
							ai_vehicle_enter_immediate ( load_squad_01, phantom, "phantom_p_lb" );
							ai_vehicle_enter_immediate ( load_squad_02, phantom, "phantom_p_lf" );
							ai_vehicle_enter_immediate ( load_squad_03, phantom, "phantom_p_ml_f" );
							ai_vehicle_enter_immediate ( load_squad_04, phantom, "phantom_p_ml_b" );
		end
		// right 
		if ( load_side == "right") then

							if ( b_debug_phantom ) then
								print ("load phantom right...");
							end
							
							ai_vehicle_enter_immediate ( load_squad_01, phantom, "phantom_p_rb" );
							ai_vehicle_enter_immediate ( load_squad_02, phantom, "phantom_p_rf" );
							ai_vehicle_enter_immediate ( load_squad_03, phantom, "phantom_p_mr_f" );
							ai_vehicle_enter_immediate ( load_squad_04, phantom, "phantom_p_mr_b" );
						

		end
		// dual 
		if ( load_side == "dual") then

							if ( b_debug_phantom ) then
								print ("load phantom dual...");
							end
							
							ai_vehicle_enter_immediate ( load_squad_01, phantom, "phantom_p_lf" );
							ai_vehicle_enter_immediate ( load_squad_02, phantom, "phantom_p_rf" );
							ai_vehicle_enter_immediate ( load_squad_03, phantom, "phantom_p_lb" );
							ai_vehicle_enter_immediate ( load_squad_04, phantom, "phantom_p_rb" );

		
		end
		//any
		if ( load_side == "any") then
		
							if ( b_debug_phantom ) then
								print ("load phantom any...");
							end
							
							ai_vehicle_enter_immediate ( load_squad_01, phantom, "phantom_p" );
							ai_vehicle_enter_immediate ( load_squad_02, phantom, "phantom_p" );
							ai_vehicle_enter_immediate ( load_squad_03, phantom, "phantom_p" );
							ai_vehicle_enter_immediate ( load_squad_04, phantom, "phantom_p" );
		end			
		// chute lives!
		if ( load_side == "chute") then
							if ( b_debug_phantom ) then
								print ("load phantom chute...");
							end
							
							ai_vehicle_enter_immediate ( load_squad_01, phantom, "phantom_pc_1" );
							ai_vehicle_enter_immediate ( load_squad_02, phantom, "phantom_pc_2" );
							ai_vehicle_enter_immediate ( load_squad_03, phantom, "phantom_pc_3" );
							ai_vehicle_enter_immediate ( load_squad_04, phantom, "phantom_pc_4" );
						
		
		end
end

script static void f_load_phantom_cargo ( vehicle phantom,		// the phantom you are loading the cargo in to 
										string load_number,	// 1 - single load    ---   2 - double load 
										ai load_squad_01,		// first squad to load 
										ai load_squad_02 )		// second squad to load 

	// place ai 
	
	// load into phantom 
		if( load_number == "single") then
	
			ai_place ( load_squad_01 );
			sleep (1);
			vehicle_load_magic ( phantom, "phantom_lc", ai_vehicle_get_from_squad (load_squad_01, 0));		
							
		elseif( load_number == "double") then
			ai_place ( load_squad_01 );
			ai_place ( load_squad_02 );
			sleep (1);
			vehicle_load_magic ( phantom, "phantom_sc01", ai_vehicle_get_from_squad (load_squad_01, 0));		
			vehicle_load_magic ( phantom, "phantom_sc02", ai_vehicle_get_from_squad (load_squad_02, 0));		
		end
	
end



// call this script when the phantom is in place to drop off all the ai ====================================================================
script static void f_unload_phantom ( vehicle phantom, string drop_side )

	
	if ( b_debug_phantom ) then
		print ( "opening phantom...");
	end
	
	unit_open ( phantom );
	sleep (60);
	// determine how to unload the phantom 
	if ( drop_side == "left" ) then
							f_unload_ph_left ( phantom );
							sleep (45);
							f_unload_ph_mid_left ( phantom );
							sleep (75);
		end
		if ( drop_side == "right" ) then
							f_unload_ph_right ( phantom );
							sleep (45);
							f_unload_ph_mid_right ( phantom );
							sleep (75);
		end
		if ( drop_side == "dual" ) then

							f_unload_ph_left ( phantom );
							f_unload_ph_right ( phantom );
							sleep (75);
		end
		if ( drop_side == "chute" ) then

							f_unload_ph_chute ( phantom );
							sleep (75);
		end
	
	if ( b_debug_phantom ) then
		print ( "closing phantom..." );
	end
	
	unit_close ( phantom );
	
end

// you never have to call these scripts directly ===========================================================================================
script static void f_unload_ph_left( vehicle phantom )

	// randomly evacuate the two sides 
	begin_random
		begin
			vehicle_unload ( phantom, "phantom_p_lf" );
			sleep (random_range( 0, 10));
		end
		
		begin
			vehicle_unload ( phantom, "phantom_p_lb" );
			sleep (random_range( 0, 10));
		end
	end
	
end

script static void f_unload_ph_right ( vehicle phantom )
				
	// randomly evacuate the two sides 
	begin_random
		begin
			vehicle_unload ( phantom, "phantom_p_rf" );
			sleep (random_range( 0, 10));
		end

		begin
			vehicle_unload ( phantom, "phantom_p_rb" );
			sleep (random_range( 0, 10));
		end
	end

end

script static void f_unload_ph_mid_left( vehicle phantom )

	// randomly evacuate the two sides 
	begin_random
		begin
			vehicle_unload (phantom, "phantom_p_ml_f");
			sleep (random_range( 0, 10));
		end
		
		begin
			vehicle_unload (phantom, "phantom_p_ml_b");
			sleep (random_range( 0, 10));
		end
	end
	
end

script static void f_unload_ph_mid_right( vehicle phantom )

	// randomly evacuate the two sides 
	begin_random
		begin
			vehicle_unload (phantom, "phantom_p_mr_f");
			sleep (random_range( 0, 10));
		end
		
		begin
			vehicle_unload (phantom, "phantom_p_mr_b");
			sleep (random_range( 0, 10));
		end		
	end
	
end

script static void f_unload_ph_chute ( vehicle phantom )
				
	// turn on phantom power 
	object_set_phantom_power ( phantom, TRUE);
	
	// poop dudes out the chute 

	if (vehicle_test_seat ( phantom, "phantom_pc_1"))	then

			vehicle_unload ( phantom, "phantom_pc_1" );
			sleep( 120 );
	end
	
	if (vehicle_test_seat ( phantom, "phantom_pc_2")	) then

			vehicle_unload ( phantom, "phantom_pc_2" );
			sleep( 120 );
	end
	
	if (vehicle_test_seat ( phantom, "phantom_pc_3"))	then

			vehicle_unload ( phantom ,"phantom_pc_3");
			sleep( 120 );
	end
								
	if (vehicle_test_seat ( phantom, "phantom_pc_4"))	then
	
			vehicle_unload ( phantom, "phantom_pc_4" );
			sleep( 120 );
	end
	
	// turn off phantom power 
	object_set_phantom_power (phantom, FALSE);
									
end

script static void f_unload_phantom_cargo	( vehicle phantom, string load_number )
			
	// unload cargo seats 

		if ( load_number == "single")	then
			vehicle_unload( phantom, "phantom_lc");
			
		elseif ( load_number == "double") then
			begin_random
			
				begin
					vehicle_unload ( phantom, "phantom_sc01" );
					sleep (random_range (15, 30));
				end
				
				begin
					vehicle_unload ( phantom, "phantom_sc02" );
					sleep (random_range (15, 30));
				end
				
			end // end random
		end		// end if-else
end
