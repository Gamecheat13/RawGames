




#include maps\_utility;




e1_main()
{

				
				level notify( "playmusicpackage_ambient" );

				thread car1_hint_triggers();
				thread load_car1_civilians();
				thread maps\MontenegroTrain_car2::e2_main();
}

load_car1_civilians()
{
				civies = maps\MontenegroTrain_util::spawn_group_ordinal( "car1_passenger" );
				for( i=0; i<civies.size; i++ )
				{
								civies[i] thread maps\MontenegroTrain_util::make_civilian( "car1_passenger"+(i+1) );

								
								
								
								
								civies[i].script_noteworthy = "early_cars";
								
				}

				thread car1_civilian_idles();
}	



car1_hint_triggers()
{
				car1hint = GetEnt( "car1hint_trig", "targetname" );
				if ( IsDefined( car1hint ) )
				{
								car1hint waittill( "trigger" );

								
								
								

								
								
								level.player play_dialogue( "TANN_TraiG_026A", true );
				}	
}




car1_civilian_idles()
{

				
				
				
				
				
				car1_passenger1_ai = getent( "car1_passenger1_ai", "targetname" );
				if( isdefined( car1_passenger1_ai ) )
				{
								car1_passenger1_ai thread car1_passenger1();
				}
				else
				{
								iprintlnbold( "couldn't find passenger1" );
				}

				
				
				
				
				
				car1_passenger2_ai = getent( "car1_passenger2_ai", "targetname" );
				if( isdefined( car1_passenger2_ai ) )
				{
								
								
								
								
								
								car1_passenger2_ai thread car1_passenger2();
				}
				else
				{
								iPrintLnBold( "Couldn't find passenger2");
				}

				
				
				
				
				
				car1_passenger3_ai = getent( "car1_passenger3_ai", "targetname" );
				if( isdefined( car1_passenger3_ai ) )
				{
								car1_passenger3_ai thread car1_passenger3();
				}
				else
				{
								iprintlnbold( "couldn't find passenger3" );
				}

				
				
				
				
				
				car1_passenger4_ai = GetEnt( "car1_passenger4_ai", "targetname" );
				if ( IsDefined( car1_passenger4_ai ) )
				{
								
								
								
								
								
								car1_passenger4_ai thread car1_passenger4();
				}	
				else
				{
								iPrintLnBold( "Couldn't find passenger4");
				}

				
				
				
				
				
				car1_passenger5_ai = GetEnt( "car1_passenger5_ai", "targetname" );
				
				if ( IsDefined( car1_passenger5_ai ) )
				{
								
								
								
								
								
								car1_passenger5_ai thread car1_passenger5();
				}	
				else
				{
								iPrintLnBold( "Couldn't find passenger5");
				}	

				car1_passenger6_ai = GetEnt( "car1_passenger6_ai", "targetname" );
				if ( IsDefined( car1_passenger6_ai ) )
				{
								
								
								
								

								
								
								
								
								
								car1_passenger6_ai thread car1_passenger6();

				}	
				else
				{
								iPrintLnBold( "Couldn't find passenger6");
				}

				car1_passenger7_ai = GetEnt( "car1_passenger7_ai", "targetname" );
				if ( IsDefined( car1_passenger7_ai ) )
				{
								
								
								
								

								
								
								
								
								
								car1_passenger7_ai thread car1_passenger7();

				}	
				else
				{
								iPrintLnBold( "Couldn't find passenger6");
				}

				car1_passenger8_ai = GetEnt( "car1_passenger8_ai", "targetname" );
				if ( IsDefined( car1_passenger7_ai ) )
				{
								
								
								
								

								
								
								
								
								
								car1_passenger8_ai thread car1_passenger8();

				}	
				else
				{
								iPrintLnBold( "Couldn't find passenger6");
				}


}	







flag_stop_anims( ent_actor )
{
				

				
				level flag_wait( "clean_car_1" );

				

				
				
				ent_actor stopallcmds();

				
				level notify( "convo_end" );

				
				ent_actor delete();

}






car1_passenger1()
{
				
				self endon( "death" );
				self endon( "damage" );

				
				
				trig = getent( "car1_passenger1_trig", "targetname" );
				
				node = getnode( "car1_passenger1_dest", "targetname" );

				
				self setenablesense( false );

				
				trig waittill( "trigger" );

				
				self setgoalnode( node );

				
				self waittill( "goal" );

				
				level thread train_convo_one();

				
				level notify( "car1_passenger6" );

				
				if( isdefined( self.script_string ) )
				{
								
								if( self.script_string == "man" )
								{
												
												
												self cmdplayanim( "Gen_Civs_StandConversationV2", true );

								}
								else if( self.script_string == "woman" )
								{
												
												
												self cmdplayanim( "Gen_Civs_StandConversationV2_Female", true );
								}
								else
								{
												
												iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								
								iprintlnbold( self.origin + "ai missing script_string" );
				}

				
				level thread flag_stop_anims( self );

}






car1_passenger2()
{
				
				self endon( "death" );
				self endon( "damage" );

				
				
				trig = getent( "car1_passenger2_trig", "targetname" );
				
				node = getnode( "car1_passenger2_dest", "targetname" );

				
				self setenablesense( false );

				
				trig waittill( "trigger" );

				
				level thread train_convo_two();

				
				self setgoalnode( node );

				
				self waittill( "goal" );

				
				self cmdfaceangles( 360, false );

				
				self waittill( "cmd_done" );

				
				if( isdefined( self.script_string ) )
				{
								
								if( self.script_string == "man" )
								{
												
												
												self cmdplayanim( "Gen_Civs_StndArmsCrossed", true );

								}
								else if( self.script_string == "woman" )
								{
												
												
												self cmdplayanim( "Gen_Civs_StndArmsCrossed_Female", true );
								}
								else
								{
												
												iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								
								iprintlnbold( self.origin + "ai missing script_string" );
				}

				
				

				
				level thread flag_stop_anims( self );

}






car1_passenger3()
{
				
				self endon( "death" );
				self endon( "damage" );

				
				self setenablesense( false );

				
				level waittill( "start_anim_car1" );

				
				if( isdefined( self.script_string ) )
				{
								
								if( self.script_string == "man" )
								{
												
												
												self cmdplayanim( "Gen_Civs_SitConversation_Listen", true );

								}
								else if( self.script_string == "woman" )
								{
												
												
												self cmdplayanim( "Gen_Civs_SitConversation_Listen_Female", true );
								}
								else
								{
												
												iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								
								iprintlnbold( self.origin + "ai missing script_string" );
				}

				
				

				
				level thread flag_stop_anims( self );

}






car1_passenger4()
{
				
				self endon( "death" );
				self endon( "damage" );

				
				self setenablesense( false );

				
				level waittill( "start_anim_car1" );

				
				

				
				if( isdefined( self.script_string ) )
				{
								
								if( self.script_string == "man" )
								{
												
												
												self cmdplayanim( "Gen_Civs_SitConversation_A", true );

								}
								else if( self.script_string == "woman" )
								{
												
												
												self cmdplayanim( "Gen_Civs_SitConversation_A_Female", true );
								}
								else
								{
												
												iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								
								iprintlnbold( self.origin + "ai missing script_string" );
				}

				
				

				
				level thread flag_stop_anims( self );
}






car1_passenger5()
{
				
				self endon( "death" );
				self endon( "damage" );

				
				self setenablesense( false );

				
				level waittill( "start_anim_car1" );

				
				if( isdefined( self.script_string ) )
				{
								
								if( self.script_string == "man" )
								{
												
												
												self cmdplayanim( "Gen_Civs_SitConversation_A", true );

								}
								else if( self.script_string == "woman" )
								{
												
												
												self cmdplayanim( "Gen_Civs_SitConversation_A_Female", true );
								}
								else
								{
												
												iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								
								iprintlnbold( self.origin + "ai missing script_string" );
				}

				
				
				

				
				level thread flag_stop_anims( self );
}






car1_passenger6()
{
				
				self endon( "death" );
				self endon( "damage" );

				
				self setenablesense( false );

				
				level waittill( "car1_passenger6" );

				
				if( isdefined( self.script_string ) )
				{
								
								if( self.script_string == "man" )
								{
												
												
												self cmdplayanim( "Gen_Civs_StandConversation", true );

								}
								else if( self.script_string == "woman" )
								{
												
												
												self cmdplayanim( "Gen_Civs_StandConversation_Female", true );
								}
								else
								{
												
												iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								
								iprintlnbold( self.origin + "ai missing script_string" );
				}

				
				

				
				level thread flag_stop_anims( self );
}






car1_passenger7()
{
				
				self endon( "death" );
				self endon( "damage" );

				
				self setenablesense( false );

				
				level waittill( "start_anim_car1" );

				
				

				
				if( isdefined( self.script_string ) )
				{
								
								if( self.script_string == "man" )
								{
												
												
												self cmdplayanim( "Gen_Civs_SitConversation_A", true );

								}
								else if( self.script_string == "woman" )
								{
												
												
												self cmdplayanim( "Gen_Civs_SitConversation_A_Female", true );
								}
								else
								{
												
												iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								
								iprintlnbold( self.origin + "ai missing script_string" );
				}

				
				

				
				level thread flag_stop_anims( self );
}






car1_passenger8()
{
				
				self endon( "death" );
				self endon( "damage" );

				
				self setenablesense( false );

				
				level waittill( "start_anim_car1" );

				
				

				
				if( isdefined( self.script_string ) )
				{
								
								if( self.script_string == "man" )
								{
												
												
												self cmdplayanim( "Gen_Civs_SitConversation_B", true );

								}
								else if( self.script_string == "woman" )
								{
												
												
												self cmdplayanim( "Gen_Civs_SitConversation_B_Female", true );
								}
								else
								{
												
												iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								
								iprintlnbold( self.origin + "ai missing script_string" );
				}

				
				

				
				level thread train_convo_three();

				
				level thread flag_stop_anims( self );
}





train_convo_one()
{
				
				level endon( "convo_end" );

				
				
				passenger_1 = getent( "car1_passenger1_ai", "targetname" );
				passenger_6 = getent( "car1_passenger6_ai", "targetname" );

				
				assertex( isdefined( passenger_1 ), "passenger_1 not defined" );
				assertex( isdefined( passenger_6 ), "passenger_6 not defined" );

				
				
				passenger_6 play_dialogue( "TRF1_TraiG_012A" );

				
				passenger_1 play_dialogue( "TRM1_TraiG_013A" );

				
				passenger_6 play_dialogue( "TRF1_TraiG_014A" );

				
				passenger_1 play_dialogue( "TRM1_TraiG_015A" );

				
				passenger_6 play_dialogue( "TRF1_TraiG_016A" );

				
				passenger_1 play_dialogue( "TRM1_TraiG_017A" );

				
				passenger_6 play_dialogue( "TRF1_TraiG_018A" );

}





train_convo_two()
{
				
				level endon( "convo_end" );

				
				
				passenger_2 = getent( "car1_passenger2_ai", "targetname" ); 
				passenger_4 = getent( "car1_passenger4_ai", "targetname" ); 
				passenger_5 = getent( "car1_passenger5_ai", "targetname" ); 

				
				
				
				passenger_4 play_dialogue( "TRM2_TraiG_019A" );

				
				passenger_5 play_dialogue( "TRF2_TraiG_020A" );

				
				

				
				passenger_2 play_dialogue( "TRM3_TraiG_021A" );

				
				passenger_5 play_dialogue( "TRF2_TraiG_022A" );

}





train_convo_three()
{
				
				level endon( "convo_end" );

				
				
				passenger_7 = getent( "car1_passenger7_ai", "targetname" ); 
				passenger_8 = getent( "car1_passenger8_ai", "targetname" ); 
				
				trig = getent( "trig_start_pass7_pass8_convo", "targetname" );

				
				trig waittill( "trigger" );

				
				
				
				passenger_7 play_dialogue( "TRM4_TraiG_023A" );

				
				passenger_8 play_dialogue( "TRM5_TraiG_024A" );

				
				passenger_7 play_dialogue( "TRM5_TraiG_025A" );
}