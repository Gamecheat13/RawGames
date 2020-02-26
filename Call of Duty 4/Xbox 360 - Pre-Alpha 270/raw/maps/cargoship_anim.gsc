#include maps\_anim;


main()
{
	anim_gen_human();
	anim_door();
	anim_chair();
	dialogue();
}

#using_animtree("generic_human");
dialogue()
{

//RIDE IN
	//base plate this is hammer two four, we have visual on the target, eta 60 seconds
	level.scr_radio[ "cargoship_hp1_baseplatehammertwo" ]			= "cargoship_hp1_baseplatehammertwo";
	//copy two four
	level.scr_radio[ "cargoship_hqr_copytwofour" ]					= "cargoship_hqr_copytwofour";
	//30 seconds, going dark
	level.scr_radio[ "cargoship_hp1_thirtysecdark" ]				= "cargoship_hp1_thirtysecdark";
	//crew expenable, lock and load
	level.scr_radio[ "cargoship_pri_crewexpend" ]					= "cargoship_pri_crewexpend";
	//ten seounds
	level.scr_radio[ "cargoship_hp1_tensecondsradio" ]				= "cargoship_hp1_tensecondsradio";
	//radio check, going to secure channel
	level.scr_radio[ "cargoship_hp1_radiocheck" ]					= "cargoship_hp1_radiocheck";
	//green light, go go go
	level.scr_radio[ "cargoship_hp1_greenlightgoradio" ]			= "cargoship_hp1_greenlightgoradio";
		
//BRIDGE
	//bridge secure
	level.scr_radio[ "cargoship_gm1_bridgesecure" ]					= "cargoship_gm1_bridgesecure";
	//weapons free
	level.scr_radio[ "cargoship_pri_weaponsfree" ]					= "cargoship_pri_weaponsfree";
	//griggs, stay in the bird till we secure the deck, over
	level.scr_radio[ "cargoship_pri_holdyourfire" ]					= "cargoship_pri_holdyourfire";
	//roger that
	level.scr_radio[ "cargoship_grg_rogerthat" ]					= "cargoship_grg_rogerthat";
	//squad on me
	level.scr_radio[ "cargoship_pri_squadonme" ]					= "cargoship_pri_squadonme";

//QUARTERS
	//stairs clear
	level.scr_radio[ "cargoship_pri_stairsclear" ]					= "cargoship_pri_stairsclear";
	//hallway clear
	level.scr_radio[ "cargoship_pri_hallwayclear" ]					= "cargoship_pri_hallwayclear";
	//Crew quarters clear. Move up.
	level.scr_radio[ "cargoship_pri_crewquarters" ]					= "cargoship_pri_crewquarters";
	//move up
	level.scr_radio[ "cargoship_pri_moveup" ]						= "cargoship_pri_moveup";
	
//DECK
	//forward deck is clear, green light on alpha, go
	level.scr_radio[ "cargoship_hp1_forwarddeckradio" ]				= "cargoship_hp1_forwarddeckradio";
	//Ready sir.
	level.scr_radio[ "cargoship_grg_readysir" ]						= "cargoship_grg_readysir";
	//Fan out. Three metre spread.
	level.scr_radio[ "cargoship_pri_fanout" ]						= "cargoship_pri_fanout";
	//Got two on the platform.
	level.scr_radio[ "cargoship_grg_gottwo" ]						= "cargoship_grg_gottwo";
	//i see 'em
	level.scr_radio[ "cargoship_pri_iseeem" ]						= "cargoship_pri_iseeem";
	//We got company..
	level.scr_radio[ "cargoship_grg_gotcompany" ]					= "cargoship_grg_gotcompany";
	//Hammer two-four, we got tangos on the 2nd floor.
	level.scr_radio[ "cargoship_pri_tangos2ndfl" ]					= "cargoship_pri_tangos2ndfl";
	//Copy, engaging.
	level.scr_radio[ "cargoship_hp1_copyengaging" ]					= "cargoship_hp1_copyengaging";
	//Bravo Six, Hammer is at bingo fuel. We're buggin out. Big Bird will be on station for evac in ten.
	level.scr_radio[ "cargoship_hp1_bingofuel" ]					= "cargoship_hp1_bingofuel";
	//Copy Hammer.
	level.scr_radio[ "cargoship_pri_copyhammer" ]					= "cargoship_pri_copyhammer";
	
//HALLWAYS
	//Wallcroft, Griffen, cover our six. The rest of you, on me.
	level.scr_radio[ "cargoship_pri_restonme" ]						= "cargoship_pri_restonme";
	//I like to keep this for close encounters.
	level.scr_radio[ "cargoship_grg_closeencounters" ]				= "cargoship_grg_closeencounters";
	//Too right mate.
	level.scr_radio[ "cargoship_gm1_tooright" ]						= "cargoship_gm1_tooright";
	//On my mark - go.
	level.scr_radio[ "cargoship_pri_onmymark" ]						= "cargoship_pri_onmymark";
	//Check your corners…
	level.scr_radio[ "cargoship_pri_checkcorners" ]					= "cargoship_pri_checkcorners";
	//...check those corners!
	level.scr_radio[ "cargoship_pri_checkthose" ]					= "cargoship_pri_checkthose";

//CARGOHOLD 1
	//keep it tight
	level.scr_radio[ "cargoship_pri_keepittight" ]						= "cargoship_pri_keepittight";
	//Gotcha covered, move up.
	level.scr_radio[ "cargoship_gm1_moveup" ]							= "cargoship_gm1_moveup";
	//Griggs, right side.
	level.scr_radio[ "cargoship_pri_rightside" ]						= "cargoship_pri_rightside";
	//I'm on it.
	level.scr_radio[ "cargoship_grg_onit" ]								= "cargoship_grg_onit";
	//Watch for movement.
	level.scr_radio[ "cargoship_pri_watchmovement" ]					= "cargoship_pri_watchmovement";
	//Standing by.
	level.scr_radio[ "cargoship_gm1_standingby" ]						= "cargoship_gm1_standingby";
	//Move.
	level.scr_radio[ "cargoship_pri_move" ]								= "cargoship_pri_move";
	//Stack up.
	level.scr_radio[ "cargoship_pri_stackup" ]							= "cargoship_pri_stackup";
	//One ready.
	level.scr_radio[ "cargoship_grg_oneready" ]							= "cargoship_grg_oneready";
	//Two ready.
	level.scr_radio[ "cargoship_gm1_twoready" ]							= "cargoship_gm1_twoready";
	//Go.
	level.scr_radio[ "cargoship_pri_go" ]								= "cargoship_pri_go";

//CARGOHOLD 2
	//Zero movement.
	level.scr_radio[ "cargoship_grg_zeromovement" ]						= "cargoship_grg_zeromovement";
	//looks quiet
	level.scr_radio[ "cargoship_gm1_looksquiet" ]						= "cargoship_gm1_looksquiet";
	//Stay frosty.
	level.scr_radio[ "cargoship_pri_stayfrosty" ]						= "cargoship_pri_stayfrosty";	
	//The objective should be in the next room.
	level.scr_radio[ "cargoship_pri_nextroom" ]							= "cargoship_pri_nextroom";
	//Standby. On my go.
	level.scr_radio[ "cargoship_pri_standby" ]							= "cargoship_pri_standby";
	//Flashbang out.
	level.scr_radio[ "cargoship_pri_flashbangout" ]						= "cargoship_pri_flashbangout";

//CARGOHOLD 3	
	//Report - All clear?
	level.scr_radio[ "cargoship_pri_report" ]							= "cargoship_pri_report";	
	//Roger that, room's empty. Nobody's home.
	level.scr_radio[ "cargoship_grg_roomsempty" ]						= "cargoship_grg_roomsempty";
	//Hmm, only a skeleton crew eh? That's odd... Did we miss any exits?
	level.scr_radio[ "cargoship_pri_skeletoncrew" ]						= "cargoship_pri_skeletoncrew";
	//Looks like this cargo hold is the end of the line sir. No other exits, except for the way we came in.
	level.scr_radio[ "cargoship_grg_nootherexits" ]						= "cargoship_grg_nootherexits";
	//Baseplate, no sign of the package, over.
	level.scr_radio[ "cargoship_pri_nosign" ]							= "cargoship_pri_nosign";
	//Copy Bravo Six, be advised, Big Bird is en route and will be on station shortly.
	level.scr_radio[ "cargoship_hqr_enroute" ]							= "cargoship_hqr_enroute";
	//Sir, over here! You might want to take a look at this.
	level.scr_radio[ "cargoship_gm1_lookatthis" ]						= "cargoship_gm1_lookatthis";
	//Baseplate, standby.
	level.scr_radio[ "cargoship_pri_bpstandby" ]						= "cargoship_pri_bpstandby";		
	
	//I got a baaad feeling about this…
	level.scr_sound[ "escape" ][ "cargoship_grg_badfeeling" ]			= "cargoship_grg_badfeeling";								
	//Intel might want to take a look at this recording sir.
	level.scr_radio[ "cargoship_gm1_recording" ]						= "cargoship_gm1_recording";
	//Quite right. It appears our source in Russia may be reliable after all..
	level.scr_sound[ "escape" ][ "cargoship_pri_reliablesource" ]		= "cargoship_pri_reliablesource";
	//Bravo Six this is Big Bird. We got a problem here...Radar's pickin' up two bogies headed your way. 
	level.scr_radio[ "cargoship_hp3_problemhere" ]						= "cargoship_hp3_problemhere";
	//Bravo Six, Evac is topside and standing by. Bogies are 20 miles out and closing fast. You guys need to get the hell off that ship right now, over.
	level.scr_radio[ "cargoship_hp3_evactopside" ]						= "cargoship_hp3_evactopside";
	//Fast movers. Probably MiGs. We'd better go..
	level.scr_sound[ "escape" ][ "cargoship_grg_fastmovers" ]			= "cargoship_grg_fastmovers";
	//Mac, grab the camcorder on the table. Everyone else, get topside! Double time!.
	level.scr_sound[ "escape" ][ "cargoship_pri_gettopside" ]						= "cargoship_pri_gettopside";
	//Let's go let's go!.
	level.scr_sound[ "escape" ][ "cargoship_grg_letsgo" ]							= "cargoship_grg_letsgo";
	//Mac, get that camcorder! Hurry!.
	level.scr_sound[ "escape" ][ "cargoship_pri_camcorderhurry" ]					= "cargoship_pri_camcorderhurry";
	//Mac! Grab the camcorder off the table and let's get out of here!.
	level.scr_sound[ "escape" ][ "cargoship_pri_getouttahere" ]						= "cargoship_pri_getouttahere";

//ESCAPE
	//Wallcroft, Griffen, what's your status?.
	level.scr_sound[ "escape" ][ "cargoship_pri_go" ]								= "cargoship_pri_go";
	//Already in the bird…Enemy aircraft inbound…shit they've opened fire! Two anti-ship missiles on the way sir! Get out of there! MOVE!!!!
	level.scr_radio[ "cargoship_gm2_alreadyinbird" ]					= "cargoship_gm2_alreadyinbird";
	//We're hit!!!
	level.scr_radio[ "cargoship_gm2_werehit" ]							= "cargoship_gm2_werehit";
	//The ship's sinking!!! Let's go! LET'S GO!!!.
	level.scr_sound[ "escape" ][ "cargoship_grg_shipssinking" ]						= "cargoship_grg_shipssinking";
	//Captain!!! We've got to go! NOW!!! Where the bloody hell's Mac!!?.
	level.scr_radio[ "cargoship_gm1_gonow" ]							= "cargoship_gm1_gonow";
	//Bravo Six! Come in! Bravo Six, what's your status???.
	level.scr_radio[ "cargoship_hp3_yourstatus" ]						= "cargoship_hp3_yourstatus";
	//We're still here…barely... What about those MiGs, over!.
	level.scr_sound[ "escape" ][ "cargoship_pri_stillhere" ]						= "cargoship_pri_stillhere";
	//We lost 'em in the chop Bravo Six! It's all clear but we're low on fuel so you'd better haul ass, over!.
	level.scr_radio[ "cargoship_hp3_lowonfuel" ]						= "cargoship_hp3_lowonfuel";
	//On your feet soldier, let's go!!!.
	level.scr_sound[ "escape" ][ "cargoship_pri_onyourfeet" ]						= "cargoship_pri_onyourfeet";
	//Get to the catwalks!!! Move move move!!!!.
	level.scr_sound[ "escape" ][ "cargoship_pri_gettocatwalks" ]					= "cargoship_pri_gettocatwalks";
	
	//Back on your feet!!!! Let's go!!!!.
	level.scr_sound[ "escape" ][ "cargoship_pri_backonfeet" ]						= "cargoship_pri_backonfeet";
	//Go! Go!!! Keep moviiiing!!!
	level.scr_sound[ "escape" ][ "cargoship_grg_keepmoving" ]						= "cargoship_grg_keepmoving";
	
	//Talk to me Bravo Six, where the hell are you?!.
	level.scr_radio[ "cargoship_hp3_talktome" ]							= "cargoship_hp3_talktome";
	//Standby. We're almost there!.
	level.scr_sound[ "escape" ][ "cargoship_pri_almostthere" ]						= "cargoship_pri_almostthere";	
	//It's breakin' away!!!!.
	level.scr_sound[ "escape" ][ "cargoship_grg_breakinaway" ]						= "cargoship_grg_breakinaway";
	//Come on, come on!!
	level.scr_sound[ "escape" ][ "cargoship_pri_comeoncomeon" ]						= "cargoship_pri_comeoncomeon";
	
	//Watch the pipes!!!!.
	level.scr_sound[ "escape" ][ "cargoship_grg_watchpipes" ]						= "cargoship_grg_watchpipes";
	//Watch yer head!!!!.
	level.scr_radio[ "cargoship_gm1_watchyerhead" ]						= "cargoship_gm1_watchyerhead";
	//Move it Bravo Six, it's getting choppy out here!
	level.scr_radio[ "cargoship_hp3_moveit" ]							= "cargoship_pri_go";
	//It ain't a walk in the park down here either!! Standby!!!!
	level.scr_sound[ "escape" ][ "cargoship_pri_walkinpark" ]						= "cargoship_pri_walkinpark";
	//We're runnin' outta time!!!! Come on!!! Let's go!!!!.
	level.scr_sound[ "escape" ][ "cargoship_grg_outtatime" ]						= "cargoship_grg_outtatime";
	
	//Keep moving!!!!
	level.scr_sound[ "escape" ][ "cargoship_pri_keepmoving" ]						= "cargoship_pri_keepmoving";
	//Which waaaay?! Which way to the helicopter?!!.
	level.scr_radio[ "cargoship_gm1_whichway" ]							= "cargoship_gm1_whichway";
	//To the right to the right!!!!.
	level.scr_sound[ "escape" ][ "cargoship_pri_totheright" ]						= "cargoship_pri_totheright";
	
	//Move your asses!!!!! Go!!!!.	
	level.scr_sound[ "escape" ][ "cargoship_grg_movego" ]							= "cargoship_grg_movego";
	//Jump for iiiiit!!!!!!!
	//We're all aboard!!! Go!.
	level.scr_sound[ "escape" ][ "cargoship_pri_allaboard" ]						= "cargoship_pri_allaboard";
	//Roger that, we're outta here..
	level.scr_radio[ "cargoship_hp3_outtahere" ]						= "cargoship_hp3_outtahere";
	//Baseplate, this is Big Bird. Package secured, returning to base. Out..
	level.scr_radio[ "cargoship_hp3_returntobase" ]						= "cargoship_hp3_returntobase";

	
//NOTIFIES
	level.scr_radio[ "cargoship_grg_clearleft" ]					= "cargoship_grg_clearleft";
	level.scr_radio[ "cargoship_grg_clearright" ]					= "cargoship_grg_clearright";
	level.scr_radio[ "cargoship_grg_movementright" ]				= "cargoship_grg_movementright";
	level.scr_radio[ "cargoship_grg_catwalkclear" ]					= "cargoship_grg_catwalkclear";
	level.scr_radio[ "cargoship_grg_forwardclear" ]					= "cargoship_grg_forwardclear";
	level.scr_radio[ "cargoship_grg_notangos" ]						= "cargoship_grg_notangos";
	
	level.scr_radio[ "cargoship_gm1_clearleft" ]					= "cargoship_gm1_clearleft";
	level.scr_radio[ "cargoship_gm1_clearright" ]					= "cargoship_gm1_clearright";
	level.scr_radio[ "cargoship_gm1_movementright" ]				= "cargoship_gm1_movementright";
	level.scr_radio[ "cargoship_gm1_catwalkclear" ]					= "cargoship_gm1_catwalkclear";
	level.scr_radio[ "cargoship_gm1_forwardclear" ]					= "cargoship_gm1_forwardclear";
	level.scr_radio[ "cargoship_gm1_notangos" ]						= "cargoship_gm1_notangos";
	
//KILLS
	level.scr_radio[ "cargoship_gm1_targetneutralized" ]			= "cargoship_gm1_targetneutralized";
	level.scr_radio[ "cargoship_gm1_tangodown" ]					= "cargoship_gm1_tangodown";
	
	level.scr_radio[ "cargoship_gm2_targetneutralized" ]			= "cargoship_gm2_targetneutralized";
	level.scr_radio[ "cargoship_gm2_tangodown" ]					= "cargoship_gm2_tangodown";
	
	level.scr_radio[ "cargoship_grg_targetneutralized" ]			= "cargoship_grg_targetneutralized";
	level.scr_radio[ "cargoship_grg_tangodown" ]					= "cargoship_grg_tangodown";
}

#using_animtree("generic_human");
anim_gen_human()
{	
	//BRIDGE SEQUENCE	
	
	level.scr_anim["bridge_capt"]["idle"][0]		= %cargoship_stunned_coffee_react_idle;
	level.scr_anim["bridge_capt"]["react"]			= %cargoship_stunned_coffee_react;
	level.scr_anim["bridge_capt"]["death"]			= %cargoship_stunned_coffee_death;
	
	level.scr_anim["bridge_tv"]["idle"][0]			= %cargoship_stunned_tv_react_idle;
	level.scr_anim["bridge_tv"]["react"]			= %cargoship_stunned_tv_react;
	level.scr_anim["bridge_tv"]["death"]			= %cargoship_stunned_tv_death;
	
	level.scr_anim["bridge_clipboard"]["idle"][0]	= %cargoship_stunned_clipboard_react_idle;
	level.scr_anim["bridge_clipboard"]["react"]		= %cargoship_stunned_clipboard_react;
	level.scr_anim["bridge_clipboard"]["death"]		= %cargoship_stunned_clipboard_death;
	
	level.scr_anim["bridge_stand1"]["idle"][0]		= %cargoship_stunned_react_v2_idle;
	level.scr_anim["bridge_stand1"]["react"]		= %cargoship_stunned_react_v2;
	level.scr_anim["bridge_stand1"]["death"]		= %cargoship_stunned_react_v2_death;
	
	//QUARTERS SEQUENCE
	
	level.scr_anim["sleeper_0"]["sleep"][0]						= %cargoship_sleeping_guy_idle_1;
	level.scr_anim["sleeper_0"]["death"]						= %cargoship_sleeping_guy_death_1;
	level.scr_anim["sleeper_1"]["sleep"][0]						= %cargoship_sleeping_guy_idle_2;
	level.scr_anim["sleeper_1"]["death"]						= %cargoship_sleeping_guy_death_2;
	
	level.scr_anim["drunk"]["walk"]								= %cargoship_drunk_sequence;
	level.scr_anim["drunk"]["death"]							= %cargoship_drunk_sequence_death;
	
	level.scr_anim[ "price" ][ "door_breach_setup" ]			= %shotgunbreach_cs_shoot_hinge;
	level.scr_anim[ "price" ][ "door_breach_setup_idle" ][0]	= %shotgunbreach_v1_shoot_hinge_idle;
	level.scr_anim[ "price" ][ "door_breach_idle" ]				= %shotgunbreach_v1_shoot_hinge_ready_idle;
	level.scr_anim[ "price" ][ "door_breach" ]					= %shotgunbreach_cs_shoot_hinge_runin;

	level.scr_anim[ "alavi" ][ "door_breach_setup" ]			= %shotgunbreach_cs_stackB;
	level.scr_anim[ "alavi" ][ "door_breach_setup_idle" ][0]	= %shotgunbreach_v1_stackB_idle;
	level.scr_anim[ "alavi" ][ "door_breach_idle" ]				= %shotgunbreach_v1_stackB_ready_idle;
	level.scr_anim[ "alavi" ][ "door_breach" ]					= %shotgunbreach_cs_stackB_runin;
		
	level.scr_anim[ "grigsby" ][ "door_breach_setup" ]			= %shotgunbreach_cs_stackB;
	level.scr_anim[ "grigsby" ][ "door_breach_setup_idle" ][0]	= %shotgunbreach_v1_stackB_idle;
	level.scr_anim[ "grigsby" ][ "door_breach_idle" ]			= %shotgunbreach_v1_stackB_ready_idle;
	level.scr_anim[ "grigsby" ][ "door_breach" ]				= %shotgunbreach_cs_stackB_runin;
	
	//DECK
	
	level.scr_anim["smoker"]["idle"][0]							= %parabolic_leaning_guy_idle; 
	level.scr_anim["smoker"]["idle"][1]							= %parabolic_leaning_guy_twitch;  
	level.scr_anim["smoker"]["smoke"]							= %parabolic_leaning_guy_smoking_idle; 
	level.scr_anim["smoker"]["smoke2"]							= %parabolic_leaning_guy_smoking_twitch;							
	level.scr_anim["smoker"]["idle_to_smoke"]					= %parabolic_leaning_guy_trans2smoke;				
	level.scr_anim["smoker"]["smoke_to_idle"]					= %parabolic_leaning_guy_trans2idle;
	
	level.scr_anim[ "platform_center" ][ "talk" ] 				= %bog_a_tank_dialogue;
	level.scr_anim[ "platform_left" ][ "talk" ] 				= %bog_a_tank_dialogue_guyL;
	level.scr_anim[ "platform_right" ][ "talk" ] 				= %bog_a_tank_dialogue_guyR;

	level.scr_anim[ "platform_center" ][ "talk_idle" ][ 0 ]		= %bog_a_tank_dialogue_idle;
	level.scr_anim[ "platform_left" ][ "talk_idle" ][ 0 ]		= %bog_a_tank_dialogue_guyL_idle;
	level.scr_anim[ "platform_right" ][ "talk_idle" ][ 0 ]		= %bog_a_tank_dialogue_guyR_idle;
	
	level.scr_anim[ "patrol" ][ "pause" ] 						= %active_patrolwalk_pause;
	level.scr_anim[ "patrol" ][ "turn" ] 						= %active_patrolwalk_turn_180;
	level.scr_anim[ "patrol" ][ "walk1" ]						= %active_patrolwalk_v1;
	level.scr_anim[ "patrol" ][ "walk2" ]						= %active_patrolwalk_v2;
	level.scr_anim[ "patrol" ][ "walk3" ]						= %active_patrolwalk_v3;
	level.scr_anim[ "patrol" ][ "walk4" ]						= %active_patrolwalk_v4;
	level.scr_anim[ "patrol" ][ "walk5" ]						= %active_patrolwalk_v5;
	
	//HALLWAYS
	level.scr_anim[ "sprinter" ][ "sprint" ] 					= %sprint1_loop;
	
	//CARGOHOLD
	level.scr_anim[ "guy" ][ "grenade_throw" ]					= %corner_standL_grenade_B;//exposed_grenadeThrowB//
	level.scr_anim[ "guy" ][ "corner_l_look" ]					= %corner_standl_alert_2_look;
	level.scr_anim[ "guy" ][ "corner_l_quickreact" ]			= %corner_standl_look_2_alert_fast_v1;
	level.scr_anim[ "guy" ][ "corner_l_idle" ][0]				= %corner_standl_alert_idle;
	level.scr_anim[ "guy" ][ "corner_l_idle" ][1]				= %corner_standl_alert_twitch01;
	level.scr_anim[ "guy" ][ "corner_l_idle" ][2]				= %corner_standl_alert_twitch02;
	level.scr_anim[ "guy" ][ "corner_l_idle" ][3]				= %corner_standl_alert_twitch03;
	level.scr_anim[ "guy" ][ "corner_l_idle" ][4]				= %corner_standl_alert_twitch06;
	level.scr_anim[ "guy" ][ "corner_l_idle" ][5]				= %corner_standl_alert_twitch07;
	
	level.scr_anim[ "guy" ][ "grenade_throw" ]					= %corner_standL_grenade_B;
	level.scr_anim[ "guy" ][ "onme" ]							= %CQB_stand_wave_on_me;
	level.scr_anim[ "guy" ][ "go" ]								= %CQB_stand_wave_go_v1;
	level.scr_anim[ "guy" ][ "coverstand_aim" ]					= %coverstand_hide_2_aim;
	level.scr_anim[ "guy" ][ "coverleft_crouch_aim" ]			= %CornerCrL_alert_2_stand;
	level.scr_anim[ "guy" ][ "standaim2idle" ]					= %casual_stand_idle_trans_in;
	level.scr_anim[ "guy" ][ "standidle" ][0]					= %casual_stand_idle;
	level.scr_anim[ "guy" ][ "standidle" ][1]					= %casual_stand_idle_twitch;
	level.scr_anim[ "guy" ][ "standidle" ][2]					= %casual_stand_idle_twitchB;
		
	level.scr_anim[ "shuffle" ][ "loop" ]						= %walk_left;//combatrun_left //walk_left
	level.scr_anim[ "shuffle" ][ "exit" ]						= %stand_2_run_L;
	level.scr_anim[ "shuffle" ][ "stop" ]						= %casual_stand_idle_trans_in;
	level.scr_anim[ "shuffle" ][ "arrival" ]					= %run_2_stand_90R;
	
	
	level.scr_anim[ "guy" ][ "cornerright8" ]				= %corner_standR_trans_OUT_8;
	level.scr_anim[ "guy" ][ "cornerright9" ]				= %corner_standR_trans_OUT_9;
	level.scr_anim[ "guy" ][ "cornerleft8" ]				= %corner_standL_trans_OUT_8;
	level.scr_anim[ "guy" ][ "cornerleft7" ]				= %corner_standL_trans_OUT_7;
	level.scr_anim[ "guy" ][ "cornerleft6" ]				= %corner_standL_trans_OUT_6;
	level.scr_anim[ "guy" ][ "stand2run" ]					= %stand_2_run_F_2;
	level.scr_anim[ "guy" ][ "stand2run180" ]				= %stand_2_run_180_med;
	level.scr_anim[ "guy" ][ "stand2runL" ]					= %stand_2_run_L;
	level.scr_anim[ "guy" ][ "stand2runR" ]					= %stand_2_run_R;
	
	level.scr_anim[ "flashed" ][ "0" ]						= %exposed_flashbang_v1;
	level.scr_anim[ "flashed" ][ "1" ]						= %exposed_flashbang_v2;
	level.scr_anim[ "flashed" ][ "2" ]						= %exposed_flashbang_v3;
	level.scr_anim[ "flashed" ][ "3" ]						= %exposed_flashbang_v4;
	level.scr_anim[ "flashed" ][ "4" ]						= %exposed_flashbang_v5;	
	
	level.scr_anim[ "guy" ][ "crouch2run" ]					= %crouch_2run_F;
	level.scr_anim[ "guy" ][ "walk" ]						= %patrol_bored_patrolwalk;//patrolwalk_tired//
	level.scr_anim[ "guy" ][ "jog" ]						= %huntedrun_2;//patrolwalk_tired//
	
	
	//ESCAPE
	
	level.scr_anim[ "escape" ][ "blowback" ] 					= %backdraft;//death_run_onfront
	level.scr_anim[ "escape" ][ "jog" ] 						= %huntedrun_2;
	level.scr_anim[ "escape" ][ "sprint" ] 						= %sprint1_loop;
	
	level.scr_anim[ "escape" ][ "stumble1" ]					= %run_pain_fallonknee;
	level.scr_anim[ "escape" ][ "stumble2" ]					= %run_pain_stomach;
	level.scr_anim[ "escape" ][ "stumble3" ]					= %run_pain_fallonknee_02;
}

#using_animtree( "door" );
anim_door()
{
	level.scr_anim[ "door" ][ "door_breach" ] = 	%shotgunbreach_v1_shoot_hinge_door;
	level.scr_animtree[ "door" ] = #animtree;	
	level.scr_model[ "door" ] = "cs_cargoship_door_PUSH";
	precachemodel( level.scr_model[ "door" ] );
}

#using_animtree( "chair" );
anim_chair()
{
	level.scr_anim[ "chair" ][ "start" ][0]			= %cargoship_stunned_coffee_death_chair_startidle;
	level.scr_anim[ "chair" ][ "fall" ]				= %cargoship_stunned_coffee_death_chair;
	level.scr_anim[ "chair" ][ "end" ][0]			= %cargoship_stunned_coffee_death_chair_endidle;
}
