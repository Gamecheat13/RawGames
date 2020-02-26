--## SERVER


function startup.spartan_render()
	print ("setting up spartan physics states and animation");

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  setting physics state <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<	
object_set_physics( OBJECTS.a_common_longshot_spartan, false );
object_set_physics( OBJECTS.a_common_midshot_spartan, false );
object_set_physics( OBJECTS.b_custom_chest01_spartan, false );
object_set_physics( OBJECTS.b_custom_fullbody01_spartan, false );
object_set_physics( OBJECTS.b_custom_head01_spartan, false );
object_set_physics( OBJECTS.c_exitexperience_far_left, false );
object_set_physics( OBJECTS.c_exitexperience_far_right, false );
object_set_physics( OBJECTS.d_weaponcustom_spartan01, false );
object_set_physics( OBJECTS.f_roster01_spartan, false );
object_set_physics( OBJECTS.f_roster02_spartan, false );
object_set_physics( OBJECTS.f_roster03_spartan, false );
object_set_physics( OBJECTS.f_roster04_spartan, false );
object_set_physics( OBJECTS.e_character_select_blue_left, false );
object_set_physics( OBJECTS.e_character_select_blue_centerleft, false );
object_set_physics( OBJECTS.e_character_select_blue_centerright, false );
object_set_physics( OBJECTS.e_character_select_blue_right, false );
object_set_physics( OBJECTS.e_character_select_osiris_left, false );
object_set_physics( OBJECTS.e_character_select_osiris_centerleft, false );
object_set_physics( OBJECTS.e_character_select_osiris_centerright, false );
object_set_physics( OBJECTS.e_character_select_osiris_right, false );


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  setting initial animation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
play_animation_on_object ( OBJECTS.a_common_longshot_spartan, "menu_campaign_selection_vale_unconfirmed" );
play_animation_on_object ( OBJECTS.a_common_midshot_spartan, "menu_campaign_selection_vale_unconfirmed" );

play_animation_on_object ( OBJECTS.b_custom_chest01_spartan, "Menu_MP_custom_helmet_idle" );
play_animation_on_object ( OBJECTS.b_custom_fullbody01_spartan, "Menu_MP_custom_helmet_idle" );
play_animation_on_object ( OBJECTS.b_custom_head01_spartan, "depot:spartan_idle_01" );

play_animation_on_object ( OBJECTS.c_exitexperience_far_left, "depot:spartan_idle_01" );
play_animation_on_object ( OBJECTS.c_exitexperience_far_right, "depot:spartan_idle_01" );

play_animation_on_object ( OBJECTS.d_weaponcustom_spartan01, "menu_mp_custom_rifle_DMR_idle" );

play_animation_on_object ( OBJECTS.f_roster01_spartan, "menu_campaign_selection_locke_unconfirmed" );
play_animation_on_object ( OBJECTS.f_roster02_spartan, "menu_campaign_selection_vale_unconfirmed" );
play_animation_on_object ( OBJECTS.f_roster03_spartan, "menu_campaign_selection_tanaka_unconfirmed" );
play_animation_on_object ( OBJECTS.f_roster04_spartan, "menu_campaign_selection_buck_unconfirmed" );

play_animation_on_object ( OBJECTS.e_character_select_blue_left, "menu_campaign_selection_linda_unconfirmed" );
play_animation_on_object ( OBJECTS.e_character_select_blue_centerleft, "menu_campaign_selection_chief_unconfirmed" );
play_animation_on_object ( OBJECTS.e_character_select_blue_centerright, "menu_campaign_selection_kelly_unconfirmed" );
play_animation_on_object ( OBJECTS.e_character_select_blue_right, "menu_campaign_selection_fred_unconfirmed" );

play_animation_on_object ( OBJECTS.e_character_select_osiris_left, "menu_campaign_selection_tanaka_unconfirmed" );
play_animation_on_object ( OBJECTS.e_character_select_osiris_centerleft, "menu_campaign_selection_locke_unconfirmed" );
play_animation_on_object ( OBJECTS.e_character_select_osiris_centerright, "menu_campaign_selection_vale_unconfirmed" );
play_animation_on_object ( OBJECTS.e_character_select_osiris_right, "menu_campaign_selection_buck_unconfirmed" );


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  loop animations <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--common spartan loop
custom_animation_loop(OBJECTS.a_common_longshot_spartan, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_vale_unconfirmed", true)
custom_animation_loop(OBJECTS.a_common_midshot_spartan, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_vale_unconfirmed", true)
--custom spartan loop
custom_animation_loop(OBJECTS.b_custom_chest01_spartan, TAG('objects\characters\spartans\spartans.model_animation_graph') , "Menu_MP_custom_armor_confirmed", true)
custom_animation_loop(OBJECTS.b_custom_fullbody01_spartan, TAG('objects\characters\spartans\spartans.model_animation_graph') , "Menu_MP_custom_armor_confirmed", true)
custom_animation_loop(OBJECTS.b_custom_head01_spartan, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_servicerecord_locke", true)

--exit experience loops
custom_animation_loop(OBJECTS.c_exitexperience_far_left, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_mp_defeat_idle", true)
custom_animation_loop(OBJECTS.c_exitexperience_far_right, TAG('objects\characters\spartans\spartans.model_animation_graph') , "Menu_custom stance_knife idle", true)

--roster spartan loops
custom_animation_loop(OBJECTS.f_roster01_spartan, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_locke_unconfirmed", true)
custom_animation_loop(OBJECTS.f_roster02_spartan, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_vale_confirmed", true)
custom_animation_loop(OBJECTS.f_roster03_spartan, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_tanaka_confirmed", true)
custom_animation_loop(OBJECTS.f_roster04_spartan, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_buck_confirmed", true)

--weapon skin loop
custom_animation_loop(OBJECTS.d_weaponcustom_spartan01, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_mp_custom_rifle_ar_idle", true)

--blueteam
custom_animation_loop(OBJECTS.e_character_select_blue_left, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_linda_unconfirmed", true)
custom_animation_loop(OBJECTS.e_character_select_blue_centerleft, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_chief_unconfirmed", true)
custom_animation_loop(OBJECTS.e_character_select_blue_centerright, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_kelly_unconfirmed", true)
custom_animation_loop(OBJECTS.e_character_select_blue_right, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_fred_unconfirmed", true)

--osiristeam
custom_animation_loop(OBJECTS.e_character_select_osiris_left, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_tanaka_unconfirmed", true)
custom_animation_loop(OBJECTS.e_character_select_osiris_centerleft, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_locke_unconfirmed", true)
custom_animation_loop(OBJECTS.e_character_select_osiris_centerright, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_vale_unconfirmed", true)
custom_animation_loop(OBJECTS.e_character_select_osiris_right, TAG('objects\characters\spartans\spartans.model_animation_graph') , "menu_campaign_selection_buck_unconfirmed", true)




end;

