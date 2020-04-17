// Montenegro Train car 1
// Builder: Don Sielke
// Scripter: Don Sielke
//////////////////////////////////////////////////////////////////////////////////////////
// includes
#include maps\_utility;

//////////////////////////////////////////////////////////////////////////////////////////
// Luxury Passenger car. (civilian)
//////////////////////////////////////////////////////////////////////////////////////////
e1_main()
{

				//Start Ambient Music - Added by crussom
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

								//////////////////////////////////////////////////////////////////////////
								// 05-14-08
								// wwilliams
								// adding a script_noteworthy so i can get rid of these people
								civies[i].script_noteworthy = "early_cars";
								//////////////////////////////////////////////////////////////////////////
				}

				thread car1_civilian_idles();
}	
//////////////////////////////////////////////////////////////////////////////////////////
// Hint Triggers.
//////////////////////////////////////////////////////////////////////////////////////////
car1_hint_triggers()
{
				car1hint = GetEnt( "car1hint_trig", "targetname" );
				if ( IsDefined( car1hint ) )
				{
								car1hint waittill( "trigger" );

								// WW 07-01-08
								// commenting out the print ln bolds
								/* iPrintLnBold( "Villiers:");
								wait( 1.5 );
								iPrintLnBold( "The adjoining car is locked off.");
								wait( 1.5 );
								iPrintLnBold( "You'll have to find a way to reach the roof and cross over it."); */

								// WW 07-01-08
								// Adding the dialogue lines
								level.player play_dialogue( "TANN_TraiG_026A", true );
				}	
}
//////////////////////////////////////////////////////////////////////////////////////////
// car1 civilian animations.
//////////////////////////////////////////////////////////////////////////////////////////

car1_civilian_idles()
{

				//////////////////////////////////////////////////////////////////////////////////////////
				// 04-17-08
				// wwilliams
				// adding control for passenger1 in car1
				//////////////////////////////////////////////////////////////////////////////////////////
				car1_passenger1_ai = getent( "car1_passenger1_ai", "targetname" );
				if( isdefined( car1_passenger1_ai ) )
				{
								car1_passenger1_ai thread car1_passenger1();
				}
				else
				{
								/*iprintlnbold( "couldn't find passenger1" );*/
				}
//////////////////////////////////////////////////////////////////////////////////////////
				//////////////////////////////////////////////////////////////////////////////////////////
				// 04-17-08
				// wwilliams
				// changing passenger2 to go to a node then sit down and loop a sitting anim
				//////////////////////////////////////////////////////////////////////////////////////////
				car1_passenger2_ai = getent( "car1_passenger2_ai", "targetname" );
				if( isdefined( car1_passenger2_ai ) )
				{
								//////////////////////////////////////////////////////////////////////////////////////////
								// 04-17-08
								// wwilliams
								// single function running on the civ for ambient actions
								//////////////////////////////////////////////////////////////////////////////////////////
								car1_passenger2_ai thread car1_passenger2();
				}
				else
				{
								/*iPrintLnBold( "Couldn't find passenger2");*/
				}
//////////////////////////////////////////////////////////////////////////////////////////
				//////////////////////////////////////////////////////////////////////////////////////////
				// 04-17-08
				// wwilliams
				// changing passenger3 to loop a sitting anim
				//////////////////////////////////////////////////////////////////////////////////////////
				car1_passenger3_ai = getent( "car1_passenger3_ai", "targetname" );
				if( isdefined( car1_passenger3_ai ) )
				{
								car1_passenger3_ai thread car1_passenger3();
				}
				else
				{
								/*iprintlnbold( "couldn't find passenger3" );*/
				}
//////////////////////////////////////////////////////////////////////////////////////////
				//////////////////////////////////////////////////////////////////////////////////////////
				// 04-17-08
				// wwilliams
				// changing passenger4 to go to a node then sit down and loop a sitting anim
				//////////////////////////////////////////////////////////////////////////////////////////
				car1_passenger4_ai = GetEnt( "car1_passenger4_ai", "targetname" );
				if ( IsDefined( car1_passenger4_ai ) )
				{
								//////////////////////////////////////////////////////////////////////////////////////////
								// 04-17-08
								// wwilliams
								// single function running on the civ for ambient actions
								//////////////////////////////////////////////////////////////////////////////////////////
								car1_passenger4_ai thread car1_passenger4();
				}	
				else
				{
								//iPrintLnBold( "Couldn't find passenger4");
				}
//////////////////////////////////////////////////////////////////////////////////////////
				//////////////////////////////////////////////////////////////////////////////////////////////////
				// 04-17-08
				// wwilliams
				// changing passenger5 to go to a node then sit down and loop a sitting anim
				//////////////////////////////////////////////////////////////////////////////////////////////////
				car1_passenger5_ai = GetEnt( "car1_passenger5_ai", "targetname" );
				// car1_passenger5_node = getnode( car1_passenger5_ai.target, "targetname" );
				if ( IsDefined( car1_passenger5_ai ) )
				{
								//////////////////////////////////////////////////////////////////////////////////////////
								// 04-17-08
								// wwilliams
								// single function running on the civ for ambient actions
								//////////////////////////////////////////////////////////////////////////////////////////
								car1_passenger5_ai thread car1_passenger5();
				}	
				else
				{
								//iPrintLnBold( "Couldn't find passenger5");
				}	
//////////////////////////////////////////////////////////////////////////////////////////
				car1_passenger6_ai = GetEnt( "car1_passenger6_ai", "targetname" );
				if ( IsDefined( car1_passenger6_ai ) )
				{
								// camerapos = getent("car1_camerapos", "targetname");
								//thread maps\MontenegroTrain_util::camera_info_HUD( car1_passenger6_ai, true); //facing
								//thread maps\MontenegroTrain_util::camera_info_HUD( car1_passenger6_ai, true, -30); //follow
								//thread maps\MontenegroTrain_util::camera_info_HUD( car1_passenger6_ai, true, 30, camerapos.origin);

								//////////////////////////////////////////////////////////////////////////////////////////
								// 04-17-08
								// wwilliams
								// single function running on the civ for ambient actions
								//////////////////////////////////////////////////////////////////////////////////////////
								car1_passenger6_ai thread car1_passenger6();

				}	
				else
				{
								//iPrintLnBold( "Couldn't find passenger6");
				}
//////////////////////////////////////////////////////////////////////////////////////////
				car1_passenger7_ai = GetEnt( "car1_passenger7_ai", "targetname" );
				if ( IsDefined( car1_passenger7_ai ) )
				{
								// camerapos = getent("car1_camerapos", "targetname");
								//thread maps\MontenegroTrain_util::camera_info_HUD( car1_passenger6_ai, true); //facing
								//thread maps\MontenegroTrain_util::camera_info_HUD( car1_passenger6_ai, true, -30); //follow
								//thread maps\MontenegroTrain_util::camera_info_HUD( car1_passenger6_ai, true, 30, camerapos.origin);

								//////////////////////////////////////////////////////////////////////////////////////////
								// 04-17-08
								// wwilliams
								// single function running on the civ for ambient actions
								//////////////////////////////////////////////////////////////////////////////////////////
								car1_passenger7_ai thread car1_passenger7();

				}	
				else
				{
								//iPrintLnBold( "Couldn't find passenger6");
				}
//////////////////////////////////////////////////////////////////////////////////////////
				car1_passenger8_ai = GetEnt( "car1_passenger8_ai", "targetname" );
				if ( IsDefined( car1_passenger7_ai ) )
				{
								// camerapos = getent("car1_camerapos", "targetname");
								//thread maps\MontenegroTrain_util::camera_info_HUD( car1_passenger6_ai, true); //facing
								//thread maps\MontenegroTrain_util::camera_info_HUD( car1_passenger6_ai, true, -30); //follow
								//thread maps\MontenegroTrain_util::camera_info_HUD( car1_passenger6_ai, true, 30, camerapos.origin);

								//////////////////////////////////////////////////////////////////////////////////////////
								// 04-17-08
								// wwilliams
								// single function running on the civ for ambient actions
								//////////////////////////////////////////////////////////////////////////////////////////
								car1_passenger8_ai thread car1_passenger8();

				}	
				else
				{
								//iPrintLnBold( "Couldn't find passenger6");
				}


}	
//////////////////////////////////////////////////////////////////////////////////////////
// 04-17-08
// wwilliams
// waits for the clean flag to be set
// then stops animations on the civs
// runs on the level
//////////////////////////////////////////////////////////////////////////////////////////
flag_stop_anims( ent_actor )
{
				// iprintlnbold( "waiting to clean car one" );

				// wait for the flag to be set
				level flag_wait( "clean_car_1" );

				// iprintlnbold( "cleaning car one" );

				// stop the animation
				// trying to notify the ai specifically
				ent_actor stopallcmds();

				// stop any convo threads going
				level notify( "convo_end" );

				// delete the actors
				ent_actor delete();

}
//////////////////////////////////////////////////////////////////////////////////////////
// 04-17-08
// wwilliams
// function controls passenger1 in car1
// runs on passenger1/self
//////////////////////////////////////////////////////////////////////////////////////////
car1_passenger1()
{
				// endon
				self endon( "death" );
				self endon( "damage" );

				// define the objects needed for this function
				// trig
				trig = getent( "car1_passenger1_trig", "targetname" );
				// node
				node = getnode( "car1_passenger1_dest", "targetname" );

				// turn off sense
				self setenablesense( false );

				// wait for the trig
				trig waittill( "trigger" );

				// send to node
				self setgoalnode( node );

				// wait for goal
				self waittill( "goal" );

				// thread off the dialogue function
				level thread train_convo_one();

				// notify passenger 6 to start animation
				level notify( "car1_passenger6" );

				// check self.script_string
				if( isdefined( self.script_string ) )
				{
								// check to seee which string it is
								if( self.script_string == "man" )
								{
												// play a male animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_StandConversationV2", true );

								}
								else if( self.script_string == "woman" )
								{
												// play a female animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_StandConversationV2_Female", true );
								}
								else
								{
												// failed script_string check
												//iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								// debug text
								//iprintlnbold( self.origin + "ai missing script_string" );
				}

				// thread off the anim stop func
				level thread flag_stop_anims( self );

}
//////////////////////////////////////////////////////////////////////////////////////////
// 04-17-08
// wwilliams
// function controls passenger2 in car1
// runs on passenger2/self
//////////////////////////////////////////////////////////////////////////////////////////
car1_passenger2()
{
				// endon
				self endon( "death" );
				self endon( "damage" );

				// define the objects needed for the function
				// trig
				trig = getent( "car1_passenger2_trig", "targetname" );
				// node
				node = getnode( "car1_passenger2_dest", "targetname" );

				// turn off sense
				self setenablesense( false );

				// wait for trig
				trig waittill( "trigger" );

				// start the dialogue
				level thread train_convo_two();

				// send to node
				self setgoalnode( node );

				// wait for passenger2 to finish goal
				self waittill( "goal" );

				// rotate the guy to face the angles of the node
				self cmdfaceangles( 180, false );

				// wait for the rotate to finish
				self waittill( "cmd_done" );

				// check self.script_string
				if( isdefined( self.script_string ) )
				{
								// check to seee which string it is
								if( self.script_string == "man" )
								{
												// play a male animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_StndArmsCrossed", true );

								}
								else if( self.script_string == "woman" )
								{
												// play a female animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_StndArmsCrossed_Female", true );
								}
								else
								{
												// failed script_string check
												//iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								// debug text
								//iprintlnbold( self.origin + "ai missing script_string" );
				}

				// passenger two plays their animation
				// self cmdplayanim( "Gen_Civs_StndArmsCrossed", true );

				// thread off the anim stop func
				level thread flag_stop_anims( self );

}
//////////////////////////////////////////////////////////////////////////////////////////
// 04-17-08
// wwilliams
// function controls passenger2 in car1
// runs on passenger2/self
//////////////////////////////////////////////////////////////////////////////////////////
car1_passenger3()
{
				// endon
				self endon( "death" );
				self endon( "damage" );

				// turn off sense
				self setenablesense( false );

				// wait for the notify to the level to start the animations for the civs in car 1
				level waittill( "start_anim_car1" );

				// check self.script_string
				if( isdefined( self.script_string ) )
				{
								// check to seee which string it is
								if( self.script_string == "man" )
								{
												// play a male animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_SitConversation_Listen", true );

								}
								else if( self.script_string == "woman" )
								{
												// play a female animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_SitConversation_Listen_Female", true );
								}
								else
								{
												// failed script_string check
												//iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								// debug text
								//iprintlnbold( self.origin + "ai missing script_string" );
				}

				// passenger two plays their animation
				// self cmdplayanim( "Gen_Civs_SitIdle_B", true );

				// thread off the anim stop func
				level thread flag_stop_anims( self );

}
//////////////////////////////////////////////////////////////////////////////////////////
// 04-17-08
// wwilliams
// function controls passenger4 in car1
// runs on passenger4/self
//////////////////////////////////////////////////////////////////////////////////////////
car1_passenger4()
{
				// endon
				self endon( "death" );
				self endon( "damage" );

				// turn off sense
				self setenablesense( false );

				// wait for the notify to the level to start the animations for the civs in car 1
				level waittill( "start_anim_car1" );

				//// spawn out a script origin at this guy
				//scr_org = spawn( "script_origin", self.origin );

				//// frame wait
				//wait( 0.05 );

				//// link the guy to it
				//self linkto( scr_org );

				//// move the guy up three units
				//scr_org moveto( scr_org.origin + ( 0, 0, 3 ), 0.05, 0.0, 0.0 );

				//// wait for the move to finish
				//scr_org waittill( "movedone" );

				//// unlink the guy
				//self unlink();

				//// frame wait
				//wait( 0.05 );

				//// delete the scr_org
				//scr_org delete();

				// car1_passenger4_ai CmdPlayAnim( "Civs_Train_StandConversation", true );
				// thread maps\MontenegroTrain_util::camera_info_HUD( car1_passenger4_ai );

				// check self.script_string
				if( isdefined( self.script_string ) )
				{
								// check to seee which string it is
								if( self.script_string == "man" )
								{
												// play a male animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_SitConversation_Listen", true );

								}
								else if( self.script_string == "woman" )
								{
												// play a female animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_SitConversation_Listen_Female", true );
								}
								else
								{
												// failed script_string check
												//iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								// debug text
								//iprintlnbold( self.origin + "ai missing script_string" );
				}

				// now play the sitting anim
				// self cmdplayanim( "Gen_Civs_SitIdle_E", true );

				// thread off the anim stop func
				level thread flag_stop_anims( self );
}
//////////////////////////////////////////////////////////////////////////////////////////
// 04-17-08
// wwilliams
// funcitons controls passenger5 in car1
// runs on passenger5/self
//////////////////////////////////////////////////////////////////////////////////////////
car1_passenger5()
{
				// endon
				self endon( "death" );
				self endon( "damage" );

				// turn off sense
				self setenablesense( false );

				// wait for the notify to the level to start the animations for the civs in car 1
				level waittill( "start_anim_car1" );

				// check self.script_string
				if( isdefined( self.script_string ) )
				{
								// check to seee which string it is
								if( self.script_string == "man" )
								{
												// play a male animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_SitConversation_A", true );

								}
								else if( self.script_string == "woman" )
								{
												// play a female animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_SitConversation_A_Female", true );
								}
								else
								{
												// failed script_string check
												//iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								// debug text
								//iprintlnbold( self.origin + "ai missing script_string" );
				}

				// now play the sitting anim
				// self cmdplayanim( "Gen_Civs_SitIdle_C", true );
				// car1_passenger5_ai CmdPlayAnim( "Civs_Train_SeatedReading", true );

				// thread off the anim stop func
				level thread flag_stop_anims( self );
}
//////////////////////////////////////////////////////////////////////////////////////////
// 04-17-08
// wwilliams
// function controls passenger6 in car1
// runs on passenger6/self
//////////////////////////////////////////////////////////////////////////////////////////
car1_passenger6()
{
				// endon
				self endon( "death" );
				self endon( "damage" );

				// turn off sense
				self setenablesense( false );

				// wait for the notify from passenger1 func
				level waittill( "car1_passenger6" );

				// check self.script_string
				if( isdefined( self.script_string ) )
				{
								// check to seee which string it is
								if( self.script_string == "man" )
								{
												// play a male animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_StandConversation", true );

								}
								else if( self.script_string == "woman" )
								{
												// play a female animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_StandConversation_Female", true );
								}
								else
								{
												// failed script_string check
												//iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								// debug text
								//iprintlnbold( self.origin + "ai missing script_string" );
				}

				// play ambient animation
				// self cmdplayanim( "Gen_Civs_StandConversation", true );

				// thread off the anim stop func
				level thread flag_stop_anims( self );
}
//////////////////////////////////////////////////////////////////////////////////////////
// 07-01-08
// wwilliams
// function controls passenger7 in car1
// runs on passenger7/self
//////////////////////////////////////////////////////////////////////////////////////////
car1_passenger7()
{
				// endon
				self endon( "death" );
				self endon( "damage" );

				// turn off sense
				self setenablesense( false );

				// wait for the notify to the level to start the animations for the civs in car 1
				level waittill( "start_anim_car1" );

				// wait for the notify from passenger1 func
				// level waittill( "car1_passenger6" );

				// check self.script_string
				if( isdefined( self.script_string ) )
				{
								// check to seee which string it is
								if( self.script_string == "man" )
								{
												// play a male animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_SitConversation_A", true );

								}
								else if( self.script_string == "woman" )
								{
												// play a female animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_SitConversation_A_Female", true );
								}
								else
								{
												// failed script_string check
												//iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								// debug text
								//iprintlnbold( self.origin + "ai missing script_string" );
				}

				// play ambient animation
				// self cmdplayanim( "Gen_Civs_StandConversation", true );

				// thread off the anim stop func
				level thread flag_stop_anims( self );
}
//////////////////////////////////////////////////////////////////////////////////////////
// 07-01-08
// wwilliams
// function controls passenger8 in car1
// runs on passenger8/self
//////////////////////////////////////////////////////////////////////////////////////////
car1_passenger8()
{
				// endon
				self endon( "death" );
				self endon( "damage" );

				// turn off sense
				self setenablesense( false );

				// wait for the notify to the level to start the animations for the civs in car 1
				level waittill( "start_anim_car1" );

				// wait for the notify from passenger1 func
				// level waittill( "car1_passenger6" );

				// check self.script_string
				if( isdefined( self.script_string ) )
				{
								// check to seee which string it is
								if( self.script_string == "man" )
								{
												// play a male animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_SitConversation_B", true );

								}
								else if( self.script_string == "woman" )
								{
												// play a female animation
												// play animation with passenger6
												self cmdplayanim( "Gen_Civs_SitConversation_B_Female", true );
								}
								else
								{
												// failed script_string check
												//iprintlnbold( self.origin + " check for script_string!" );
								}
				}
				else
				{
								// debug text
								//iprintlnbold( self.origin + "ai missing script_string" );
				}

				// play ambient animation
				// self cmdplayanim( "Gen_Civs_StandConversation", true );

				// thread off the dialogue func
				level thread train_convo_three();

				// thread off the anim stop func
				level thread flag_stop_anims( self );
}
//////////////////////////////////////////////////////////////////////////////////////////
// wwilliams 07-01-08
// function causes the talking between car1_passenger1 & car1_passenger6
// runs on level
//////////////////////////////////////////////////////////////////////////////////////////
train_convo_one()
{
				// endon
				level endon( "convo_end" );

				// objects to be defined for this function
				// ents
				passenger_1 = getent( "car1_passenger1_ai", "targetname" );
				passenger_6 = getent( "car1_passenger6_ai", "targetname" );

				// double check defines
				//assertex( isdefined( passenger_1 ), "passenger_1 not defined" );
				//assertex( isdefined( passenger_6 ), "passenger_6 not defined" );

				// start the dialogue
				// line one from passenger6/woman
				passenger_6 play_dialogue( "TRF1_TraiG_012A" );

				// line two from passenger1/man
				passenger_1 play_dialogue( "TRM1_TraiG_013A" );

				// line three from passenger6/woman
				passenger_6 play_dialogue( "TRF1_TraiG_014A" );

				// line four from passenger1/man
				passenger_1 play_dialogue( "TRM1_TraiG_015A" );

				// line five from passenger6/woman
				passenger_6 play_dialogue( "TRF1_TraiG_016A" );

				// line six from passenger1/man
				passenger_1 play_dialogue( "TRM1_TraiG_017A" );

				// line seven from passenger6/woman
				passenger_6 play_dialogue( "TRF1_TraiG_018A" );

}
//////////////////////////////////////////////////////////////////////////////////////////
// wwilliams 07-01-08
// function causes the talking between car1_passenger2, car1_passenger4 & car1_passenger5
// runs on level
//////////////////////////////////////////////////////////////////////////////////////////
train_convo_two()
{
				// endon
				level endon( "convo_end" );

				// objects to be defined for this function
				// ents
				passenger_2 = getent( "car1_passenger2_ai", "targetname" ); // male
				passenger_4 = getent( "car1_passenger4_ai", "targetname" ); // male
				passenger_5 = getent( "car1_passenger5_ai", "targetname" ); // female

				// start the conversation between passenger4 and passenger5 who are
				// sitting
				// line one from passenger_4/man
				passenger_4 play_dialogue( "TRM2_TraiG_019A" );

				// line two from passenger_5/female
				passenger_5 play_dialogue( "TRF2_TraiG_020A" );

				// wait for passenger_2 to hit goal
				// passenger_2 waittill( "goal" );

				// line three from passenger_2/man
				passenger_2 play_dialogue( "TRM3_TraiG_021A" );

				// line four from passenger_5/female
				passenger_5 play_dialogue( "TRF2_TraiG_022A" );

}
//////////////////////////////////////////////////////////////////////////////////////////
// wwilliams 07-01-08
// function causes the talking between car1_passenger7 & car1_passenger8
// runs on level
//////////////////////////////////////////////////////////////////////////////////////////
train_convo_three()
{
				// endon
				level endon( "convo_end" );

				// objects to be defined for this function
				// ents
				passenger_7 = getent( "car1_passenger7_ai", "targetname" ); // male
				passenger_8 = getent( "car1_passenger8_ai", "targetname" ); // male
				// trig
				trig = getent( "trig_start_pass7_pass8_convo", "targetname" );

				// wait for the trigger to hit
				trig waittill( "trigger" );

				// start the conversation between passenger7 and passenger8 who are
				// sitting
				// line one from passenger_7/man
				passenger_7 play_dialogue( "TRM4_TraiG_023A" );

				// line two from passenger_5/female
				passenger_8 play_dialogue( "TRM5_TraiG_024A" );

				// line three from passenger_2/man
				passenger_7 play_dialogue( "TRM4_Traig_025A" );
}