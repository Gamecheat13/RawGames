//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
//
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

script startup instanced fill_narrative_drop_content_m80()
		static real distance = 0.922;
		static boolean end_narrative_device = 0;

 	 	static real length = 9.0;
 	 	static string content = "NAR: The Didact's scans have not yet located the Composer.  The Covenant's orders are to minimize human casualties while searching for the 'holy relic.'";
 	 	  	
  	object_set_velocity (this, real_random_range(0.3,1.2), real_random_range(0.3,1.2), real_random_range(1.5,2.5));
  	 	
 	 	// Fonts:
 	 	// Assign the font to use. Valid options are: terminal, body, title, super_large,
		// large_body, split_screen_hud, full_screen_hud, English_body, 
  	// hud_number, subtitle, main_menu. Default is “subtitle”
		set_text_defaults();
		
		// color, scale, life, font
    set_text_lifespan(length);
		set_text_color(1, 0.0, 0.8, 1.0);
		set_text_font(arame_regular_16);                                                                  
		set_text_scale(0.9);
		
		// alignments
		set_text_alignment(top);
		set_text_margins(0.05, 0.23, 0.07, 0.0);	// l,t,r,b        
		set_text_indents(0,0); 
		set_text_justification(right);
		set_text_wrap(1, 1);
				
		// shadow
		set_text_shadow_style(drop);							// Sets the drop shadow type. Options are drop, outline, none.
		set_text_shadow_color(1, 0, 0, 0);
		
		player_action_test_reset();
		
		repeat 
		 	if (objects_distance_to_object(players(), this) < distance) then
				show_text("Press X to see Narrative Drop");
				
				if (player_action_test_context_primary() == TRUE) then
					end_narrative_device = 1;
					//thread (pip_on());
					thread (story_blurb_add_domain(content));
				end
			end
		player_action_test_reset();
		until( end_narrative_device == 1, 1);
		
		end_narrative_device = 0;
end
