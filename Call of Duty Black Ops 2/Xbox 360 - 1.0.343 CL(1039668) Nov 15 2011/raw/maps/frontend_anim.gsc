#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\flamer_util;


main()
{
	init_player_anims();
	init_prop_anims();
	init_ai_anims();
	init_notetracks();
	init_generic_frontend_questions();
	init_level_specific_frontend_questions();
	init_interstitial_questions();
}

#using_animtree("player");
init_player_anims()
{
	level.scr_animtree[ "player_body" ] 	= #animtree;	
	level.scr_model[ "player_body" ] = level.player_interactive_model;	


	level.scr_anim["player"]["arm_left"] = %int_interrogation_chair_struggle_l;
	level.scr_anim["player"]["arm_right"] = %int_interrogation_chair_struggle_r;
	level.scr_anim["player"]["idle_player"][0] = %int_interrogation_chair_idle;
	level.scr_anim["player"]["idle_player_single"] = %int_interrogation_chair_idle;
	level.scr_anim["player"]["chair_escape"] = %int_interrogation_chair_struggle_l_and_r;
	level.scr_anim["player"]["chair_breakout"] = %int_interrogation_chair_breakout;
	
	level.scr_anim["player"]["look_at_resp"] 		 = %int_interrogation_chair_idle_look_at_respirator;
	level.scr_anim["player"]["look_from_resp"]	 = %int_interrogation_chair_idle_look_back_respirator;
	
	level.scr_animtree[ "player" ] 	= #animtree;
	level.scr_model[ "player" ] = level.player_interactive_model;
	level.scr_anim["player"]["int1_chair_anim"]			 = %ch_inter_01_mason;
	
}

#using_animtree("animated_props");
init_prop_anims()
{
	level.scr_animtree["strap"] 	        				  = #animtree;
	level.scr_model["strap"] 	       					 		  = "p_int_interrogation_chair_strap";
	level.scr_anim["strap"]["rightstrap_break"]		 	= %p_interrogation_rightstrap_breakout;
	level.scr_anim["strap"]["leftstrap_break"]	 		= %p_interrogation_leftstrap_breakout;
	level.scr_anim["strap"]["rightstrap_idle"][0]	 	= %p_interrogation_rightstrap_idle;
	level.scr_anim["strap"]["leftstrap_idle"][0]	 	= %p_interrogation_leftstrap_idle;

	level.scr_anim["strap"]["leftstrap_struggle_r"]	 	= %p_interrogation_leftstrap_struggle_r;
	level.scr_anim["strap"]["rightstrap_struggle_r"]	= %p_interrogation_rightstrap_struggle_r;
	level.scr_anim["strap"]["rightstrap_struggle_l"]	= %p_interrogation_rightstrap_struggle_l;
	level.scr_anim["strap"]["leftstrap_struggle_l"]	 	= %p_interrogation_leftstrap_struggle_l;
	

}

#using_animtree("generic_human");
init_ai_anims()
{
	level.scr_anim["generic"]["guy_01_enter"]	 	= %ch_frontend_guy_01_enter;
	level.scr_anim["generic"]["guy_01_exit"]	 	= %ch_frontend_guy_01_exit;
	level.scr_anim["generic"]["guy_01_loop"][0]	= %ch_frontend_guy_01_loop;
	level.scr_anim["generic"]["guy_02_enter"]		= %ch_frontend_guy_02_enter;
	level.scr_anim["generic"]["guy_02_exit"]		= %ch_frontend_guy_02_exit;
	level.scr_anim["generic"]["guy_02_loop"][0]	= %ch_frontend_guy_02_loop;
	
	level.scr_anim["generic"]["fake_player_chair_loop"][0]	= %ch_interrogation_chair_idle_full_char;
	level.scr_anim["generic"]["int1_chair_anim"]			 = %ch_inter_01_mason_full;

	
	level.scr_anim["generic"]["hudson_inter_01"]			 = %ch_inter_01_hudson;
	level.scr_anim["generic"]["weaver_inter_01"]			 = %ch_inter_01_weaver;

}

init_notetracks()
{
	addNotetrack_customFunction( "player", "shock",  maps\so_narrative2_frontend_anim::electrocute, "int1_chair_anim" );
	
	addNotetrack_customFunction( "generic", "sndnt#vox_fro2_s01_007A_inte",  ::notify_next_tv_round, "hudson_inter_01" );
	addNotetrack_customFunction( "generic", "sndnt#vox_fro2_s01_010A_inte",  ::notify_next_tv_round, "hudson_inter_01" );
	addNotetrack_customFunction( "generic", "sndnt#vox_fro2_s01_011A_inte",  ::notify_next_tv_round, "hudson_inter_01" );
	addNotetrack_customFunction( "generic", "sndnt#vox_fro2_s01_17A_inte",  ::notify_next_tv_round, "hudson_inter_01" );
	addNotetrack_customFunction( "generic", "sndnt#vox_fro2_s01_18A_inte",  ::notify_next_tv_round, "hudson_inter_01" );

		
		
}

init_generic_frontend_questions()
{
	level.scr_sound["generic"]["numbers_broadcast"] = "vox_fro1_s01_300A_broa"; //* Twenty-one, thirty-six, forty-nine.  Seventeen, seventeen, three, five, six. Twenty-one, thirty-six, forty-nine.  Seventeen, seventeen, three, five, six.
 	
	level.scr_sound["generic"]["g_question1"] = "vox_fro1_s99_038A_inte"; //We're running out of time.
  level.scr_sound["generic"]["anime"] = "vox_fro1_s99_038B_inte"; //We're running out of time.
  level.scr_sound["generic"]["g_question2"] = "vox_fro1_s99_039A_inte"; //Focus, Mason. Try to remember.
  level.scr_sound["generic"]["anime"] = "vox_fro1_s99_039B_inte"; //Focus, Mason. Try to remember.
  level.scr_sound["generic"]["g_question3"] = "vox_fro1_s99_040A_inte"; //You can stop all this now.
  level.scr_sound["generic"]["anime"] = "vox_fro1_s99_040B_inte"; //You can stop all this now.
  level.scr_sound["generic"]["g_question4"] = "vox_fro1_s99_041A_inte"; //You just have to remember.
  level.scr_sound["generic"]["anime"] = "vox_fro1_s99_041B_inte"; //You just have to remember.
  level.scr_sound["generic"]["g_question5"] = "vox_fro1_s99_042A_inte"; //How can you be sure you know what really happened?
  level.scr_sound["generic"]["anime"] = "vox_fro1_s99_042B_inte"; //How can you be sure you know what really happened?
  level.scr_sound["generic"]["g_question6"] = "vox_fro1_s99_043A_inte"; //You know why you're here.
  level.scr_sound["generic"]["anime"] = "vox_fro1_s99_043B_inte"; //You know why you're here.
  level.scr_sound["generic"]["g_question7"] = "vox_fro1_s99_044A_inte"; //The numbers, Mason... What do they mean?
  level.scr_sound["generic"]["anime"] = "vox_fro1_s99_044B_inte"; //The numbers, Mason... What do they mean?
  level.scr_sound["generic"]["g_question8"] = "vox_fro1_s99_045A_inte"; //Why did you trust him?
  level.scr_sound["generic"]["anime"] = "vox_fro1_s99_045B_inte"; //Why did you trust him?
  level.scr_sound["generic"]["g_question9"] = "vox_fro1_s99_046A_inte"; //Why did you do it, Mason. Why?
  level.scr_sound["generic"]["anime"] = "vox_fro1_s99_046B_inte"; //Why did you do it, Mason. Why?
  level.scr_sound["generic"]["g_question10"] = "vox_fro1_s99_047A_inte"; //It's up to you, Mason.  It's all up to you.
  level.scr_sound["generic"]["anime"] = "vox_fro1_s99_047B_inte"; //It's up to you, Mason.  It's all up to you.
  level.scr_sound["generic"]["g_question11"] = "vox_fro1_s99_048A_inte"; //I know when you're lying.
  level.scr_sound["generic"]["anime"] = "vox_fro1_s99_048B_inte"; //I know when you're lying.
  level.scr_sound["generic"]["g_question12"] = "vox_fro1_s99_049A_inte"; //You killed him, Mason.  You did.  No one else.  Just you.
  level.scr_sound["generic"]["anime"] = "vox_fro1_s99_049B_inte"; //You killed him, Mason.  You did.  No one else.  Just you.
  level.scr_sound["generic"]["g_question13"] = "vox_fro1_s99_050A_inte"; //Who were you working for?
  level.scr_sound["generic"]["anime"] = "vox_fro1_s99_050B_inte"; //Who were you working for?
}

#using_animtree("player");
init_level_specific_frontend_questions()
{
		// CUBA
	level.scr_sound["generic"]["cuba_q1"] = "vox_fro1_s99_051A_inte"; //You said it was Cuba.  What happened in Cuba?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_051B_inte"; //You said it was Cuba.  What happened in Cuba?
	level.scr_sound["generic"]["cuba_q2"] = "vox_fro1_s99_052A_inte"; //Was Castro involved?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_052B_inte"; //Was Castro involved?
	level.scr_sound["generic"]["cuba_q3"] = "vox_fro1_s99_053A_inte"; //Anything.  Something.  Try harder.
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_053B_inte"; //Anything.  Something.  Try harder.
	
		// VORKUTA
	level.scr_sound["generic"]["vorkuta_q1"] = "vox_fro1_s99_054A_inte"; //Why didn't they kill you?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_054B_inte"; //Why didn't they kill you?
	level.scr_sound["generic"]["vorkuta_q2"] = "vox_fro1_s99_055A_inte"; //What did they tell you?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_055B_inte"; //What did they tell you?
	level.scr_sound["generic"]["vorkuta_q3"] = "vox_fro1_s99_056A_inte"; //Who was Castro meeting with?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_056B_inte"; //Who was Castro meeting with?
	level.scr_sound["generic"]["vorkuta_q4"] = "vox_fro1_s99_057A_inte"; //They knew you were coming... You know that, right?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_057B_inte"; //They knew you were coming... You know that, right?
	level.scr_sound["generic"]["vorkuta_q5"] = "vox_fro1_s99_058A_inte"; //Were you collaborating with the Communists?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_058B_inte"; //Were you collaborating with the Communists?

		// PENTAGON
	level.scr_sound["generic"]["pentagon_q1"] = "vox_fro1_s99_059A_inte"; //There's too many gaps in your story, Mason.
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_059B_inte"; //There's too many gaps in your story, Mason.
	level.scr_sound["generic"]["pentagon_q2"] = "vox_fro1_s99_060A_inte"; //The only recorded riot at Vorkuta was ended after three days - peacefully.
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_060B_inte"; //The only recorded riot at Vorkuta was ended after three days - peacefully.
	level.scr_sound["generic"]["pentagon_q3"] = "vox_fro1_s99_061A_inte"; //What happened to Reznov?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_061B_inte"; //What happened to Reznov?
	level.scr_sound["generic"]["pentagon_q4"] = "vox_fro1_s99_062A_inte"; //Alone.  Far from home.  Too easy.
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_062B_inte"; //Alone.  Far from home.  Too easy.

		// FLASHPOINT
	level.scr_sound["generic"]["flashpoint_q1"] = "vox_fro1_s99_063A_inte"; //Kennedy himself gave the order?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_063B_inte"; //Kennedy himself gave the order?
	level.scr_sound["generic"]["flashpoint_q2"] = "vox_fro1_s99_064A_inte"; //Who else knew?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_064B_inte"; //Who else knew?
	level.scr_sound["generic"]["flashpoint_q3"] = "vox_fro1_s99_065A_inte"; //Is there anyone to corroborate your claims?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_065B_inte"; //Is there anyone to corroborate your claims?
	level.scr_sound["generic"]["flashpoint_q4"] = "vox_fro1_s99_066A_inte"; //What happened, next?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_066B_inte"; //What happened, next?

		// KHE SANH
	level.scr_sound["generic"]["khe_sanh_q1"] = "vox_fro1_s99_067A_inte"; //Did you confirm the kill?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_067B_inte"; //Did you confirm the kill?
	level.scr_sound["generic"]["khe_sanh_q2"] = "vox_fro1_s99_068A_inte"; //You spent a long time looking for Dragovich.
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_068B_inte"; //You spent a long time looking for Dragovich.
	level.scr_sound["generic"]["khe_sanh_q3"] = "vox_fro1_s99_069A_inte"; //Did you really want to find him?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_069B_inte"; //Did you really want to find him?
	level.scr_sound["generic"]["khe_sanh_q4"] = "vox_fro1_s99_070A_inte"; //How did you feel about the war in Vietnam?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_070B_inte"; //How did you feel about the war in Vietnam?
	level.scr_sound["generic"]["khe_sanh_q5"] = "vox_fro1_s99_071A_inte"; //Did you believe that your Nation's involvement was justified?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_071B_inte"; //Did you believe that your Nation's involvement was justified?
	
		// HUE CITY
	level.scr_sound["generic"]["hue_city_q1"] = "vox_fro1_s99_072A_inte"; //What did you hope to learn from the defector?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_072B_inte"; //What did you hope to learn from the defector?
	level.scr_sound["generic"]["hue_city_q2"] = "vox_fro1_s99_073A_inte"; //Did you believe that he would lead you to Dragovich?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_073B_inte"; //Did you believe that he would lead you to Dragovich?
	level.scr_sound["generic"]["hue_city_q3"] = "vox_fro1_s99_074A_inte"; //Did you know the identity of the defector in advance?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_074B_inte"; //Did you know the identity of the defector in advance?

			// KOWLOON CITY
	level.scr_sound["generic"]["kowloon_q1"] = "vox_fro1_s99_075A_inte"; //The defector - He was known to you?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_075B_inte"; //The defector - He was known to you?
	level.scr_sound["generic"]["kowloon_q2"] = "vox_fro1_s99_076A_inte"; //Do you consider Viktor Reznov to be your friend?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_076B_inte"; //Do you consider Viktor Reznov to be your friend?
	level.scr_sound["generic"]["kowloon_q3"] = "vox_fro1_s99_077A_inte"; //What did Special Agent Hudson tell you about Doctor Clarke?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_077B_inte"; //What did Special Agent Hudson tell you about Doctor Clarke?


			// VICTOR CHARLIE
	level.scr_sound["generic"]["creek_1_q1"] = "vox_fro1_s99_078A_inte"; //Why do you think the Soviets were there?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_078B_inte"; //Why do you think the Soviets were there?
	level.scr_sound["generic"]["creek_1_q2"] = "vox_fro1_s99_079A_inte"; //Did you see the effects of Nova Six?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_079B_inte"; //Did you see the effects of Nova Six?
	level.scr_sound["generic"]["creek_1_q3"] = "vox_fro1_s99_080A_inte"; //Is there a reason why you chose to keep the defector with you?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_080B_inte"; //Is there a reason why you chose to keep the defector with you?
	level.scr_sound["generic"]["creek_1_q4"] = "vox_fro1_s99_081A_inte"; //Who cleared this course of action?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_081B_inte"; //Who cleared this course of action?

			// RIVER
	level.scr_sound["generic"]["river_q1"] = "vox_fro1_s99_082A_inte"; //Was this your first encounter with Kravchenko since Operation Flashpoint?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_082B_inte"; //Was this your first encounter with Kravchenko since Operation Flashpoint?
	level.scr_sound["generic"]["river_q2"] = "vox_fro1_s99_083A_inte"; //Was this your first encounter with Dragovich since Operation Flashpoint?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_083B_inte"; //Was this your first encounter with Dragovich since Operation Flashpoint?
	level.scr_sound["generic"]["river_q3"] = "vox_fro1_s99_084A_inte"; //Do you think the Soviets knew you were coming?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_084B_inte"; //Do you think the Soviets knew you were coming?
	level.scr_sound["generic"]["river_q4"] = "vox_fro1_s99_085A_inte"; //Who else was with you in the tunnels?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_085B_inte"; //Who else was with you in the tunnels?
 
 			// WMD
	level.scr_sound["generic"]["wmd_q1"] = "vox_fro1_s99_090A_inte"; //Can you describe the Nova 6 victims?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_090B_inte"; //Can you describe the Nova 6 victims?
	level.scr_sound["generic"]["wmd_q2"] = "vox_fro1_s99_091A_inte"; //Did you trust Agent Hudson?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_091B_inte"; //Did you trust Agent Hudson?
	level.scr_sound["generic"]["wmd_q3"] = "vox_fro1_s99_092A_inte"; //What did he hope to achieve?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_092B_inte"; //What did he hope to achieve?
	level.scr_sound["generic"]["wmd_q4"] = "vox_fro1_s99_093A_inte"; //Prior to Hudson's mission, did you ever meet with Steiner?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_093B_inte"; //Prior to Hudson's mission, did you ever meet with Steiner?
	level.scr_sound["generic"]["wmd_q5"] = "vox_fro1_s99_094A_inte"; //What did Yamantau have to do with Project Nova?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_094B_inte"; //What did Yamantau have to do with Project Nova?

			// PAYBACK
	level.scr_sound["generic"]["pow_q1"] = "vox_fro1_s99_095A_inte"; //Was the defector captured with you?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_095B_inte"; //Was the defector captured with you?
	level.scr_sound["generic"]["pow_q2"] = "vox_fro1_s99_096A_inte"; //Did Kravchenko recognize you?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_096B_inte"; //Did Kravchenko recognize you?
	level.scr_sound["generic"]["pow_q3"] = "vox_fro1_s99_097A_inte"; //Why did they keep you alive?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_097B_inte"; //Why did they keep you alive?

			// FULL AHEAD
	level.scr_sound["generic"]["fullahead_q1"] = "vox_fro1_s99_098A_inte"; //What did Reznov tell you?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_098B_inte"; //What did Reznov tell you?
	level.scr_sound["generic"]["fullahead_q2"] = "vox_fro1_s99_099A_inte"; //Did you believe him?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_099B_inte"; //Did you believe him?
	level.scr_sound["generic"]["fullahead_q3"] = "vox_fro1_s99_100A_inte"; //Do you trust him?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_100B_inte"; //Do you trust him?

			// REBIRTH
	level.scr_sound["generic"]["rebirth_q1"] = "vox_fro1_s99_101A_inte"; //You know what you did?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_101B_inte"; //You know what you did?
	level.scr_sound["generic"]["rebirth_q2"] = "vox_fro1_s99_102A_inte"; //Did you achieve what you hoped to?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_102B_inte"; //Did you achieve what you hoped to?
	level.scr_sound["generic"]["rebirth_q3"] = "vox_fro1_s99_103A_inte"; //Did you kill him?
	level.scr_sound["generic"]["anime"] = "vox_fro1_s99_103B_inte"; //Did you kill him?
}

init_interstitial_questions()
{
				// Interstitial Frontend - Pre Cuba
	level.scr_sound["generic"]["is_0_line_1"] = "vox_fro2_s01_001A_inte"; //Wake up.  WAKE UP!
	level.scr_sound["generic"]["anime"] = "vox_fro2_s01_001B_inte"; //Wake up.  WAKE UP!
	level.scr_sound["generic"]["is_0_line_2"] = "vox_fro2_s01_002A_maso"; //Where am I --? Where’s Reznov?
	level.scr_sound["generic"]["is_0_line_3"] = "vox_fro2_s01_003A_inte"; //You will answer our questions.  Do you understand?
	level.scr_sound["generic"]["anime"] = "vox_fro2_s01_003B_inte"; //You will answer our questions.  Do you understand?
	level.scr_sound["generic"]["is_0_line_4"] = "vox_fro2_s01_004A_maso"; //Who the hell are you?
	level.scr_sound["generic"]["is_0_line_5"] = "vox_fro2_s01_005A_inte"; //That’s not important.  What’s important is who you are.  What’s your name?
	level.scr_sound["generic"]["anime"] = "vox_fro2_s01_005B_inte"; //That’s not important.  What’s important is who you are.  What’s your name?
	level.scr_sound["generic"]["is_0_line_6"] = "vox_fro2_s01_006A_maso"; //Fuck you.
	level.scr_sound["generic"]["is_0_line_7"] = "vox_fro2_s01_007A_inte"; //Where were you born?
	level.scr_sound["generic"]["anime"] = "vox_fro2_s01_007B_inte"; //Where were you born?
	level.scr_sound["generic"]["is_0_line_8"] = "vox_fro2_s01_008A_maso"; //Moscow, Russia.
	level.scr_sound["generic"]["is_0_line_9"] = "vox_fro2_s01_009A_maso"; //AARRRGH!!!
	level.scr_sound["generic"]["is_0_line_10"] = "vox_fro2_s01_010A_inte"; //Your name is Alex Mason.  You were born in Fairbanks, Alaska.  In 1961 you served in a CIA assassination team known as Operation 40.  Is that correct?
	level.scr_sound["Mason"]["anime"] = "vox_fro2_s01_009B_maso"; //AARRRGH!!!
	level.scr_sound["generic"]["anime"] = "vox_fro2_s01_010B_inte"; //Your name is Alex Mason.  You were born in Fairbanks, Alaska.  In 1961 you served in a CIA assassination team known as Operation 40.  Is that correct?
	level.scr_sound["generic"]["is_0_line_11"] = "vox_fro2_s01_011A_inte"; //Is that correct?
	level.scr_sound["generic"]["anime"] = "vox_fro2_s01_011B_inte"; //Is that correct?
	level.scr_sound["generic"]["is_0_line_12"] = "vox_fro2_s01_012A_maso"; //Yes.
	level.scr_sound["generic"]["is_0_line_13"] = "vox_fro2_s01_013A_inte"; //Where is the broadcast station?
	level.scr_sound["generic"]["anime"] = "vox_fro2_s01_013B_inte"; //Where is the broadcast station?
	level.scr_sound["generic"]["is_0_line_14"] = "vox_fro2_s01_014A_maso"; //I don’t know what you’re talking about --
	level.scr_sound["generic"]["is_0_line_15"] = "vox_fro2_s01_015A_inte"; //The numbers, Mason.  What do they mean?  Where are they broadcast from?
	level.scr_sound["generic"]["anime"] = "vox_fro2_s01_015B_inte"; //The numbers, Mason.  What do they mean?  Where are they broadcast from?
	level.scr_sound["generic"]["is_0_line_16"] = "vox_fro2_s01_016A_maso"; //I don’t know anything about any numbers!
	level.scr_sound["Mason"]["anime"] = "vox_fro2_s01_009C_maso"; //AARRRGH!!!
	level.scr_sound["generic"]["is_0_line_17"] = "vox_fro2_s01_17A_inte"; //What about Dragovich?  Do you remember him? Give us what we want and we’ll guarantee your safety.
	level.scr_sound["generic"]["anime"] = "vox_fro2_s01_17B_inte"; //What about Dragovich?  Do you remember him? Give us what we want and we’ll guarantee your safety.
	level.scr_sound["generic"]["is_0_line_18"] = "vox_fro2_s01_18A_inte"; //Let’s start at the beginning.  Cuba, 1961.  The Bay of Pigs.  We know you were there.
	level.scr_sound["generic"]["anime"] = "vox_fro2_s01_18B_inte"; //Let’s start at the beginning.  Cuba, 1961.  The Bay of Pigs.  We know you were there.

				// Interstitial 1 - Pre Vorkuta
	level.scr_sound["generic"]["is_1_line_1"] = "vox_fro3_s01_001A_maso"; //It was a set-up.  They knew we were coming.  That bastard, Dragovich --
	level.scr_sound["generic"]["is_1_line_2"] = "vox_fro3_s01_002A_inte"; //The Russian.
	level.scr_sound["generic"]["anime"] = "vox_fro3_s01_002B_inte"; //The Russian.
	level.scr_sound["generic"]["is_1_line_3"] = "vox_fro3_s01_003A_maso"; //Yeah.  He was behind everything.
	level.scr_sound["generic"]["is_1_line_4"] = "vox_fro3_s01_004A_inte"; //Where did Dragovich take you?
	level.scr_sound["generic"]["anime"] = "vox_fro3_s01_004B_inte"; //Where did Dragovich take you?
	level.scr_sound["generic"]["is_1_line_5"] = "vox_fro3_s01_005A_maso"; //Russia.  A labor camp.  A hell-hole named Vorkuta -- My God --
	level.scr_sound["generic"]["is_1_line_6"] = "vox_fro3_s01_006A_inte"; //What did they do to you in Vorkuta, Mason?
	level.scr_sound["generic"]["anime"] = "vox_fro3_s01_006B_inte"; //What did they do to you in Vorkuta, Mason?
	level.scr_sound["generic"]["is_1_line_7"] = "vox_fro3_s01_007A_maso"; //What didn’t they do...

				// Interstitial 2 - Pre Khe Sahn
	level.scr_sound["generic"]["is_2_line_1"] = "vox_fro4_s01_001A_maso"; //Baikonur was another dead-end.  But somehow -- I knew Dragovich was still alive.
	level.scr_sound["generic"]["is_2_line_2"] = "vox_fro4_s01_002A_inte"; //He became your obsession. You spent the next five years trying to track him down.
	level.scr_sound["generic"]["anime"] = "vox_fro4_s01_002B_inte"; //He became your obsession. You spent the next five years trying to track him down.
	level.scr_sound["generic"]["is_2_line_3"] = "vox_fro4_s01_003A_maso"; //He was everywhere.  Couldn’t get him out of my head.  Just like the others --
	level.scr_sound["generic"]["is_2_line_4"] = "vox_fro4_s01_004A_inte"; //What do you mean by others?
	level.scr_sound["generic"]["anime"] = "vox_fro4_s01_004B_inte"; //What do you mean by others?
	level.scr_sound["generic"]["is_2_line_5"] = "vox_fro4_s01_005A_weav"; //This is a waste of time.  He’s delusional.  We pumped so much shit into him he doesn’t even know what he’s saying.
	level.scr_sound["generic"]["is_2_line_6"] = "vox_fro4_s01_006A_maso"; //Voices -- Russians -- always in my head --
	level.scr_sound["generic"]["is_2_line_7"] = "vox_fro4_s01_007A_inte"; //No, I want to keep pressing him --
	level.scr_sound["generic"]["anime"] = "vox_fro4_s01_007B_inte"; //No, I want to keep pressing him --
	level.scr_sound["generic"]["is_2_line_8"] = "vox_fro4_s01_008A_maso"; //HEY!  Who are you people?  What do you want from me?
	level.scr_sound["generic"]["is_2_line_9"] = "vox_fro4_s01_009A_weav"; //We want the numbers, Mason.  That’s all we’ve ever wanted.

				// Interstitial 3 - Pre Creek
	level.scr_sound["generic"]["is_3_line_1"] = "vox_fro5_s01_001A_inte"; //We know that Jason Hudson briefed you on the intel extracted from Dr. Clarke at Kowloon.
	level.scr_sound["generic"]["anime"] = "vox_fro5_s01_001B_inte"; //We know that Jason Hudson briefed you on the intel extracted from Dr. Clarke at Kowloon.
	level.scr_sound["generic"]["is_3_line_2"] = "vox_fro5_s01_002A_maso"; //An abomination....Hudson said that Clarke was insane... Paranoid... Fixated with numbers.
	level.scr_sound["generic"]["is_3_line_3"] = "vox_fro5_s01_003A_inte"; //Clarke created Nova Six. A nerve toxin that can rupture a body in seconds.
	level.scr_sound["generic"]["anime"] = "vox_fro5_s01_003B_inte"; //Clarke created Nova Six. A nerve toxin that can rupture a body in seconds.
	level.scr_sound["generic"]["is_3_line_4"] = "vox_fro5_s01_004A_maso"; //Dragovich’s second in command, Kravchenko, tests it in Vietnam. On them, on us, on his own...he doesn’t care.

				// Interstitial 4 - Pre River
	level.scr_sound["generic"]["is_4_line_1"] = "vox_fro6_s01_001A_inte"; //You confirmed that Dragovich’s second in command, Kravchenko, was operating in Laos.
	level.scr_sound["generic"]["anime"] = "vox_fro6_s01_001B_inte"; //You confirmed that Dragovich’s second in command, Kravchenko, was operating in Laos.
	level.scr_sound["generic"]["is_4_line_2"] = "vox_fro6_s01_002A_maso"; //Yeah. Reznov said they’d killed more people than I could count --
	level.scr_sound["generic"]["is_4_line_3"] = "vox_fro6_s01_003A_inte"; //Listen to me carefully, Mason.  Reznov cannot be trusted.  No matter what he tells you, what he says --
	level.scr_sound["generic"]["anime"] = "vox_fro6_s01_003B_inte"; //Listen to me carefully, Mason.  Reznov cannot be trusted.  No matter what he tells you, what he says --
	level.scr_sound["generic"]["is_4_line_4"] = "vox_fro6_s01_004A_maso"; //But he gave us the dossier on Clarke!  He lead us to Nova 6!
	level.scr_sound["generic"]["is_4_line_5"] = "vox_fro6_s01_005A_inte"; //Reznov’s not who you think he is.
	level.scr_sound["generic"]["anime"] = "vox_fro6_s01_005B_inte"; //Reznov’s not who you think he is.
	level.scr_sound["generic"]["is_4_line_6"] = "vox_fro6_s01_006A_maso"; //No -- he’s my friend!  He helped me escape! Betrayed, forgotten, abandoned -- all brothers --
	level.scr_sound["generic"]["is_4_line_7"] = "vox_fro6_s01_007A_inte"; //Forget Reznov!  Focus, Mason!  We are out of fucking time!  The world is on the brink of war!
	level.scr_sound["generic"]["anime"] = "vox_fro6_s01_007B_inte"; //Forget Reznov!  Focus, Mason!  We are out of fucking time!  The world is on the brink of war!
	level.scr_sound["generic"]["is_4_line_8"] = "vox_fro6_s01_008A_maso"; //Whose war?  Who the fuck are you, anyway?
	level.scr_sound["generic"]["is_4_line_9"] = "vox_fro6_s01_009A_maso"; //Agggh.  I -- keep -- hearing -- fucking -- numbers ---
	level.scr_sound["generic"]["is_4_line_10"] = "vox_fro6_s01_010A_inte"; //It’s a broadcast, Mason.  The numbers are a broadcast.  You’ve been brainwashed.
	level.scr_sound["generic"]["anime"] = "vox_fro6_s01_010B_inte"; //It’s a broadcast, Mason.  The numbers are a broadcast.  You’ve been brainwashed.

				// Interstitial 5 - Pre Rebirth
	level.scr_sound["generic"]["is_5_line_1"] = "vox_fro7_s01_001A_inte"; //After you left Kravchenko’s compound in Laos, after your team were killed, you went rogue.
	level.scr_sound["generic"]["anime"] = "vox_fro7_s01_001B_inte"; //After you left Kravchenko’s compound in Laos, after your team were killed, you went rogue.
	level.scr_sound["generic"]["is_5_line_2"] = "vox_fro7_s01_002A_maso"; //No!  I wasn’t rogue!  I was continuing the mission!
	level.scr_sound["generic"]["is_5_line_3"] = "vox_fro7_s01_003A_inte"; //You went to Rebirth Island, against orders.  Why, Mason?!
	level.scr_sound["generic"]["anime"] = "vox_fro7_s01_003B_inte"; //You went to Rebirth Island, against orders.  Why, Mason?!
	level.scr_sound["generic"]["is_5_line_4"] = "vox_fro7_s01_004A_maso"; //Steiner was there.  Had to kill Steiner.
	level.scr_sound["generic"]["is_5_line_5"] = "vox_fro7_s01_005A_inte"; //But Hudson and the CIA were already on their way to get Steiner at Rebirth. Why did you have to go?
	level.scr_sound["generic"]["anime"] = "vox_fro7_s01_005B_inte"; //But Hudson and the CIA were already on their way to get Steiner at Rebirth. Why did you have to go?
	level.scr_sound["generic"]["is_5_line_6"] = "vox_fro7_s01_006A_maso"; //Dragovich.  Kravchenko.  Steiner.  They all had to die.
	level.scr_sound["generic"]["is_5_line_7"] = "vox_fro7_s01_007A_inte"; //We wanted Steiner alive.  Why did you have to kill him?
	level.scr_sound["generic"]["anime"] = "vox_fro7_s01_007B_inte"; //We wanted Steiner alive.  Why did you have to kill him?
	level.scr_sound["generic"]["is_5_line_8"] = "vox_fro7_s01_008A_maso"; //The numbers were telling me to!  Why don’t you understand?!

}

chair_trigger_setup()
{
	level endon ("first_interstitial_go");
	while(1)
	{
		self waittill("chair_break");
		
		get_players()[0] giveachievement_wrapper( "SP_LVL_FRONTEND_CHAIR" );

		NearStart = 0;
		NearEnd = 0;
		FarStart = 92;
		FarEnd = 225;
		NearBlur = 6;
		FarBlur = 2.5;
		
		self SetDepthOfField( NearStart, NearEnd, FarStart, FarEnd, NearBlur, FarBlur);	


		press_start = a_safe_text_display(&"FRONTEND_PRESS_BUTTON_TO_SIT_DOWN", -40, 0, undefined, 1.2,"right", "bottom", "right", "bottom");
		
		while(!get_players()[0] jumpbuttonpressed() && !flag("warp_player_to_chair") )
		{
			if (GetDvarint( "dec20_inuse"))
			{
				press_start Destroy();
				while(GetDvarint( "dec20_inuse"))
					wait(0.05);
				press_start = a_safe_text_display(&"FRONTEND_PRESS_BUTTON_TO_SIT_DOWN", -40, 0, undefined, 1.2,"right", "bottom", "right", "bottom");
			}
			
			wait 0.05;
		}

		flag_set("warping_player_to_chair");
		VisionSetNaked( "int_frontend_char_trans", 1);
					
		press_start Destroy();

		wait .3;
		thread cover_screen_in_white(.5, .5, .5);
			
		wait .5;
		self OpenMainMenu( "main" );
		self thread setup_idle_animation();
		
		wait .5;
		
		flag_clear("warping_player_to_chair");
		flag_clear("warp_player_to_chair");
		maps\frontend::set_default_vision(1);
		
	}
}

out_of_chair_idle_control()
{
	level endon ("first_interstitial_go");
	while(1)
	{
		flag_wait("player_out_of_chair");
		flag_waitopen("flag_frontend_usecomputer");
		out_of_chair_idle_check();
		wait 0.2;
		flag_clear("warp_player_to_chair");
	}
}

out_of_chair_idle_check()
{
	level endon ("first_interstitial_go");
	level endon ("pressed_button");
	level endon ("player_camera_moving");
	level endon ("player_linked_absolute");
	level endon ("flag_frontend_usecomputer");
	wait 60;
	flag_set("warp_player_to_chair");
}

logo_fade()
{
	level endon ("first_interstitial_go");

	last_move=0;
	count=301;
	while(1)
	{
		movement = length(self GetNormalizedMovement());
		camera_movement = length(self GetNormalizedCameraMovement());
		if (last_move==0 && (movement>0.1 || camera_movement>0.1))
		{
			last_move=1;
//			black_bg FadeOverTime(1); 
//			black_bg.alpha = 0;
			count=0;
			level notify ("pressed_button");
		}
		else if (movement<0.1 && camera_movement<0.1)
		{
			last_move=0;
		}
	
//		if (count==300)
//		{
//			black_bg FadeOverTime( 1 ); 
//			black_bg.alpha = 0.15; 
//		}
		count++;
		
		wait(0.05);
	}
}

setup_idle_animation()
{
	level endon ("first_interstitial_go");
	
	self endon("sub_menu_select");
	
	sync_node = GetEnt("interrogation_chair", "targetname");
	align_struct = getstruct("int_anims_align_struct", "targetname");

	if (!IsDefined (level.player_hands) )
	{
		level.player_hands = Spawn_anim_model( "player_body" );	
	}
	
	level.player_hands Show();
	level.player_hands.angles = self.angles;
	level.player_hands.origin = self.origin;
	level.player_hands.animname = "player";
	
	flag_set("player_linked_absolute");
	flag_clear("player_out_of_chair");
	self PlayerLinkToAbsolute(level.player_hands, "tag_origin");
	

	level.player_hands SetVisibleToPlayer( self );
	self HideViewModel();

	counter = 0;
	
	if (level.console)
		self thread lr_buttuncheck_for_chair();
	else
		self thread pc_buttoncheck_for_chair();

	self thread player_camera_idle_drift();
	self thread setup_idle_strugles();
	
	sync_node thread anim_loop_aligned(level.player_hands, "idle_player", "tag_origin", "stoplooping");
	
	if (!IsDefined(level._leftstrap) )
	{
		level._leftstrap = Spawn_anim_model( "strap" );
	}
	if (!IsDefined(level._rightstrap))
	{
		level._rightstrap = Spawn_anim_model( "strap" );
	}
	
	level._leftstrap.animname = "strap";
	level._rightstrap.animname = "strap";
	
	level._leftstrap UseAnimTree(level.scr_animtree["strap"]);
	level._rightstrap UseAnimTree(level.scr_animtree["strap"]);
	
	align_struct thread anim_loop_aligned(level._leftstrap, "leftstrap_idle", undefined, "stoplooping");
	align_struct thread anim_loop_aligned(level._rightstrap, "rightstrap_idle",undefined, "stoplooping");

	while(1)
	{
		wait 0.2;
		flag_clear("warp_player_to_chair");
		get_players()[0] playerlinktodelta(level.player_hands, "tag_origin", 0, 0, 0, 0, 0, true);
		wait 0.2;
		flag_waitopen("ignore_chair_playerlook");
		self playerlinktodelta(level.player_hands, "tag_origin", 0, 70, 65, 40, 60);
		flag_clear("player_linked_absolute");
		
		if (level.script != "frontend") // for interstitials
		{
			return;
		}
		
		level waittill_any("button_pressed", "ignore_chair_playerlook");
		
		if (!flag("button_pressed"))
		{
			continue;
		}
	

		self notify("stoplooping");
		level notify ("player_camera_moving");
		get_players()[0] setclientflagasval(1);//turn on the static
		self CloseMainMenu();
		get_players()[0] notify ("chair_break_go");
		sync_node anim_single_aligned(level.player_hands, "chair_escape");

		level notify ("player_camera_moving");
		
		align_struct thread anim_single_aligned(level._leftstrap, "leftstrap_break");
		align_struct thread anim_single_aligned(level._rightstrap, "rightstrap_break");
		
		get_players()[0] FreezeControls(true);
		thread stand_up_shrink_viewclamp();
		
		sync_node anim_single_aligned(level.player_hands, "chair_breakout");
		get_players()[0] FreezeControls(false);
		
		self notify("chair_break");
		level notify ("chair_breakout");
		level notify ("chair_break");
			
		flag_set("player_out_of_chair");		
		break;
	}
	
	self unlink();
	get_players()[0] SetOrigin(level.player_hands.origin);
	level.player_hands Hide();
	self showviewmodel();
}

setup_idle_strugles()
{
	level endon ("first_interstitial_go");
	get_players()[0] endon ("chair_break_go");
	
	sync_node = GetEnt("interrogation_chair", "targetname");
	align_struct = getstruct("int_anims_align_struct", "targetname");
	
	flag_clear("struggle_left");
	flag_clear("struggle_right");
	wait 1;
	
	while(1)
	{
		flag_wait_any("struggle_left", "struggle_right");
		if (flag("struggle_right"))
		{
			align_struct thread anim_single_aligned( level._rightstrap, "rightstrap_struggle_r");
			align_struct thread anim_single_aligned( level._leftstrap, "leftstrap_struggle_r");
			sync_node anim_single_aligned( level.player_hands, "arm_right");

			
			sync_node thread anim_loop_aligned(level.player_hands, "idle_player", "tag_origin", "stoplooping");
			align_struct thread anim_loop_aligned(level._leftstrap, "leftstrap_idle", undefined, "stoplooping");
			align_struct thread anim_loop_aligned(level._rightstrap, "rightstrap_idle",undefined, "stoplooping");
			
			flag_clear("struggle_left");
			flag_clear("struggle_right");
		}
		if (flag("struggle_left"))
		{
			align_struct thread anim_single_aligned( level._leftstrap, "leftstrap_struggle_l");
			align_struct thread anim_single_aligned( level._rightstrap, "rightstrap_struggle_l");
			sync_node anim_single_aligned( level.player_hands, "arm_left");
			
			align_struct thread anim_loop_aligned(level._leftstrap, "leftstrap_idle", undefined, "stoplooping");
			align_struct thread anim_loop_aligned(level._rightstrap, "rightstrap_idle",undefined, "stoplooping");
			sync_node thread anim_loop_aligned(level.player_hands, "idle_player", "tag_origin", "stoplooping");
			
			flag_clear("struggle_left");
			flag_clear("struggle_right");
		}
	}
}

		// TEMP TODO - Menu is breaking the normal code calls, using these for the 8/1 disc to avoid code change
throw_buttonpressed()
{
	if (get_players()[0] ButtonPressed("BUTTON_LTRIG"))
	{
		flag_set("struggle_left");
		level notify("pressed_button");
		return true;
	}
	else
		return false;
}

Attack_ButtonPressed()
{
	if (get_players()[0] ButtonPressed("BUTTON_RTRIG"))
	{
		flag_set("struggle_right");
		level notify("pressed_button");
		return true;
	}
	else
		return false;
}

pc_buttoncheck_for_chair()
{
	level endon ("first_interstitial_go");
	level endon ("chair_break");
	start_over = undefined;
	
	if (level.script != "frontend") // for interstitials
	{
		return;
	}
	flag_wait("past_splash_screen");
	
	while(1)
	{
		while( 1 )
		{
			if (get_players()[0] jumpbuttonpressed() && flag("allow_escape_buttons") )
				break;
			wait 0.1;
		}
		
		flag_set("button_pressed");
		wait(0.1);
		flag_clear("button_pressed");
	}
}


lr_buttuncheck_for_chair()
{
	level endon ("first_interstitial_go");
	level endon ("chair_break");
	start_over = undefined;
	
	if (level.script != "frontend") // for interstitials
	{
		return;
	}
	
	flag_wait("past_splash_screen");

	while( 1 )
	{
		while ( !get_players()[0] throw_buttonpressed() && !get_players()[0] Attack_ButtonPressed() )
		{
			wait 0.1;
		}
		
		if (!flag("allow_escape_buttons"))
		{
			wait 0.1;
			continue;
		}
		
		for (i=0; i < 2; i++)
		{
			start_over = 1;
			if ( get_players()[0] throw_buttonpressed() )
			{
				for (j=0; j < 30; j++)
				{
					if ( get_players()[0] Attack_ButtonPressed() )
					{
						for (k=0; k < 30; k++)
						{
							if (!get_players()[0] Attack_ButtonPressed() )
							{
								start_over = 0;
								break;
							}
							wait 0.05;
						}
						break;
					}
					wait 0.05;
				}
			}
			else
			{
				for (j=0; j < 30; j++)
				{
					if ( get_players()[0] throw_buttonpressed() )
					{
						
						for (k=0; k < 30; k++)	// need to depress
						{
							if (!get_players()[0] throw_buttonpressed() )
							{
								start_over = 0;
								break;
							}
							wait 0.05;
						}
						break;
					}
					wait 0.05;
				}
			}
			
			if (start_over == 1)
			{
				break;
			}
		}
		if (start_over == 0)
		{
			flag_set("button_pressed");
			flag_clear("warp_player_to_chair");
			wait(0.1);
			flag_clear("button_pressed");
			continue;
		}
		wait 0.05;
	}
}

player_camera_idle_drift()
{
	level endon ("first_interstitial_go");
	level endon ("chair_breakout");
	flag_wait("past_splash_screen");
	
	while(1)
	{
		flag_wait("enable_idle_drift");

		do_player_idle_drift();
		if (flag("player_linked_absolute"))
		{
			get_players()[0] cameraactivate(false);
			get_players()[0] startcameratween( 0.5);
			get_players()[0] playerlinktodelta(level.player_hands, "tag_origin", 0, 60, 60, 40, 60);
			flag_clear("player_linked_absolute");
		}
	}
}
	
do_player_idle_drift()
{
	level endon ("first_interstitial_go");
	level endon ("chair_breakout");
	level endon ("player_camera_moving");
	level endon ("pressed_button");
		
	
	sync_node = GetEnt("interrogation_chair", "targetname");
	time_to_wait_before_idle = 45;
	time_to_wait_after_centering = 5;
	time_to_wait_after_turning = 5;
	angle_to_rotate_to_side = 45;
	time_to_rotate_to_side = 55;
	
	wait time_to_wait_before_idle;
	
	if (!IsDefined(level.player_drift_linker))
	{
		level.player_drift_linker = spawn_a_model(level.player_interactive_model, level.player_hands.origin );
		level.player_drift_linker Hide();
	}
	
	//get_players()[0] PlayerLinkToAbsolute(level.player_drift_linker, "tag_origin");
	flag_set("player_linked_absolute");
	center_camera_for_idle();

	
	

	ang_dif = angle_dif(level.player_drift_linker.angles[1], level.player_hands.angles[1]);
	if (ang_dif > 0)
	{
		level.player_drift_linker RotateTo( level.player_hands.angles, ang_dif, ang_dif*(0.5) );
		level.player_drift_linker waittill ("rotatedone");
	}
	while(1)
	{
		wait time_to_wait_after_centering;
		
		get_players()[0] playerlinktodelta(level.player_drift_linker, undefined, 0, 1, 1, 1, 1);
		
		if (cointoss() )
		{
				/*
				sync_node anim_single_aligned(level.player_hands , "look_at_resp");
				wait 5;
				sync_node anim_single_aligned(level.player_hands , "look_from_resp");
				*/
			level.player_drift_linker RotateTo(level.player_drift_linker.angles + (0,angle_to_rotate_to_side,0), time_to_rotate_to_side);
			level.player_drift_linker waittill ("rotatedone");
			wait time_to_wait_after_turning;
			level.player_drift_linker RotateTo(level.player_drift_linker.angles + (0,-1*angle_to_rotate_to_side,0), time_to_rotate_to_side);
			level.player_drift_linker waittill ("rotatedone");

		}
		else
		{
			/*
			sync_node anim_single_aligned(level.player_hands , "look_at_resp");
			wait 5;
			sync_node anim_single_aligned(level.player_hands , "look_from_resp");
			*/
			level.player_drift_linker RotateTo(level.player_drift_linker.angles + (0,-1*angle_to_rotate_to_side,0), time_to_rotate_to_side);
			level.player_drift_linker waittill ("rotatedone");
			wait time_to_wait_after_turning;
			level.player_drift_linker RotateTo(level.player_drift_linker.angles + (0,angle_to_rotate_to_side,0), time_to_rotate_to_side);
			level.player_drift_linker waittill ("rotatedone");
		}
	}
}

#using_animtree("player");		
center_camera_for_idle()
{
	level endon ("first_interstitial_go");
	level endon ("player_camera_moving");
	level endon ("chair_breakout");
	
	level.player_drift_linker.origin = level.player_hands.origin;
	level.player_drift_linker.angles = level.player_hands.angles;
	
	sync_node = GetEnt("interrogation_chair", "targetname");
	level.player_drift_linker.animname = "player";
	level.player_drift_linker UseAnimTree( #animtree );
	sync_node anim_first_frame(level.player_drift_linker, "idle_player_single");
	
	
	//get_players()[0] PlayerLinkToAbsolute(level.player_drift_linker, "tag_origin");
	
	og_clamp = 60;
	get_players()[0] startcameratween( 0.5);
	
	while(og_clamp > 1)
	{
		og_clamp -= 0.05;
		//og_clamp -= 1;
		get_players()[0] playerlinktodelta(level.player_drift_linker, undefined, 0, og_clamp, og_clamp, og_clamp, og_clamp);
		wait 0.05;
	}
	og_clamp = 1;
	get_players()[0] playerlinktodelta(level.player_drift_linker, undefined, 0, og_clamp, og_clamp, og_clamp, og_clamp);
}
	
player_camera_movment_tracker()
{
	level endon ("first_interstitial_go");
	while(1)
	{
		movement = get_players()[0] GetNormalizedCameraMovement();
		if ( movement[0] > 0 || movement[1] > 0)
		{
			level notify ("player_camera_moving");
		}
		wait 0.05;
	}
}


#using_animtree ("generic_human");
window_ambient_anims()
{
	level endon ("first_interstitial_go");
	level thread zombie_vision_sets();
	align_struct = getstruct("int_anims_align_struct", "targetname");
	
	while(1)
	{
		if (!IsDefined(level.interrogator) )
		{
			interrogator = simple_spawn_single("hudson");
			interrogator.animname = "generic";
			level.interrogator = interrogator;
		}
		
		if (IsDefined(level.weaver))
		{
			level.weaver Delete();
			level.weaver = undefined;
		}
		if (IsDefined(level.hudson))
		{
			level.hudson Delete();
			level.hudson = undefined;
		}
		
		interrogator = level.interrogator;
			
		if (!flag("in_zombie_menu"))
		{
			align_struct anim_single_aligned(interrogator, "guy_01_enter");
			align_struct thread anim_loop_aligned(interrogator, "guy_01_loop");
			flag_wait("in_zombie_menu");
			align_struct anim_single_aligned(interrogator, "guy_01_exit");
		}
		if (flag("in_zombie_menu"))
		{
			align_struct anim_single_aligned(interrogator, "guy_02_enter");
			align_struct thread anim_loop_aligned(interrogator, "guy_02_loop");
			flag_waitopen("in_zombie_menu");
			align_struct anim_single_aligned(interrogator, "guy_02_exit");
		}
	}
}

zombie_vision_sets()
{
	while(1)
	{
		flag_wait("in_zombie_menu");
		VisionSetNaked("zombie_frontend_default", 5);
		flag_waitopen("in_zombie_menu");
		level notify ("left_zombie_menu");
		maps\frontend::set_default_vision(5);
	}
}

stand_up_shrink_viewclamp()
{
	target_clamp = 5;
	current_clamp = 60;
	get_players()[0] startcameratween(1);
	
	while(current_clamp > target_clamp)
	{
		current_clamp -= 3;
		get_players()[0] playerlinktodelta(level.player_hands, "tag_camera", 0, current_clamp, current_clamp, current_clamp, current_clamp);
		wait 0.05;
	}
}

notify_next_tv_round(guy)
{
	flag_set("next_tv_round");
}	


