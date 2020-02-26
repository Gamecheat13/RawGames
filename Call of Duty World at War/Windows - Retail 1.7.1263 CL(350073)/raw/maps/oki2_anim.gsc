/*-----------------------------------------------------
Animation loadout for Okinawa 2
-----------------------------------------------------*/
#include maps\_utility;
#include maps\_anim;


main()
{

		init_anims();
		init_spiderhole_anims();
		init_lid_anims();
		init_mg_tarp();
		//still need this ?
		maps\_mganim::main();

}

// MISSING: No "nice work!" type responses for sarge
// MISSING: No Sarge acknowledgement of "meet me here" objective

#using_animtree("generic_human");
init_anims()
{
	level.scr_anim["guy1"]["here_comes"] = %Oki2_pointing_plane;

	// "Gear up.  We're moving out."
	level.scr_sound["sarge"]["moveout"] = "Oki2_IGD_000A_ROEB";
	// "What's the skinny?"
	level.scr_sound["polonsky"]["skinny"] = "Oki2_IGD_001A_POLO";
	// "Major Gordon's ordered another assault on the ridge."
	level.scr_sound["sarge"]["gordon"] = "Oki2_IGD_002A_ROEB";
	
// ~~~~~ AFTER FADE IN ~~~~~~	// these are in
	
	// "Any word on supplies?"
	level.scr_sound["polonsky"]["supplies"] = "Oki2_IGD_003A_POLO";
	// "They're coming."
	level.scr_sound["sarge"]["coming"] = "Oki2_IGD_004A_ROEB";
	// "When?"
	level.scr_sound["polonsky"]["when"] = "Oki2_IGD_005A_POLO";
	// "Just get up the hill, Polonsky"
	level.scr_sound["sarge"]["uphill"] = "Oki2_IGD_006A_ROEB";
	
// ~~~~~~ UPON REACHING FIRST ROCKS ~~~~
	// "Spread out…"
	level.scr_sound["sarge"]["spreadout"] = "Oki2_IGD_008A_ROEB";
	// "Spider Holes!!!"
	level.scr_sound["sarge"]["spiderholes"] = "Oki2_IGD_009A_ROEB";
	// "Return fire!"
	level.scr_sound["sarge"]["returnfire"] = "Oki2_IGD_010A_ROEB";
	// "Miller!   Burn the grass!!!"
	level.scr_sound["sarge"]["burngrass"] = "Oki2_IGD_011A_ROEB";
	
// ~~~~~~ AFTER SECOND SPIDERHOLE FIGHT
	
	// "We got a heavily fortified MG in that bunker."
	level.scr_sound["sarge"]["fortifiedmg"] = "Oki2_IGD_007A_ROEB";
	
// ~~~~~ UPON APPROACHING WANA HILL BUNKER ~~~~~~
	
	// "Damn M.G's got the area covered!"
	level.scr_sound["polonsky"]["mgcovered"] = "Oki2_IGD_012A_POLO";
	// "Miller - Pop smoke!"
	level.scr_sound["sarge"]["popsmoke"] = "Oki2_IGD_013A_ROEB";

	// "C'mon, Miller - We need cover!"
	level.scr_sound["polonsky"]["smokereminder"] = "Oki2_IGD_014A_POLO";
	// "Smoke!"
	level.scr_sound["sarge"]["smokereminder"] = "Oki2_IGD_015A_ROEB";

	// "Go! They can't see us!"
	level.scr_sound["sarge"]["cantseeus"] = "Oki2_IGD_016A_ROEB";
	// "Clear that bunker!"
	level.scr_sound["sarge"]["clearbunker"] = "Oki2_IGD_017A_ROEB";
	
// ~~~~~~ UPON REACHING BUNKER AND FIRST CAVE ~~~~~~

	// "Through the caves - there's more bunkers up ahead."
	level.scr_sound["sarge"]["throughcaves"] = "Oki2_IGD_018A_ROEB";
	
// ~~~~~~ UPON GUY JUMPING DOWN FROM RIDGE ~~~~~~

	// "We know the drill - Watch EVERYWHERE!"
	//level.scr_sound["sarge"]["REFERENCE"] = "Oki2_IGD_021A_ROEB";

	// "On the ridge!"
	//level.scr_sound["sarge"]["REFERENCE"] = "Oki2_IGD_019A_ROEB";
	// "Fucking bastards!!"
	//level.scr_sound["polonsky"]["REFERENCE"] = "Oki2_IGD_020A_POLO";
	

	// "We got three active bunkers... "
	level.scr_sound["sarge"]["threeactive"] = "Oki2_IGD_022A_ROEB";
	// "Miller - Flank round and clear 'em out!"
	level.scr_sound["sarge"]["flankround"] = "Oki2_IGD_023A_ROEB";
	
	// "Miller - Get that flamethrower on 'em!"
	level.scr_sound["sarge"]["flamenag"] = "Oki2_IGD_024A_ROEB";


	// "Miller - Throw a satchel charge!"
	level.scr_sound["sarge"]["satchelnag1"] = "Oki2_IGD_025A_ROEB"; // happens every time, then every third reminder

	// "We need to knock out those bunkers!"
	level.scr_sound["sarge"]["satchelnag2"] = "Oki2_IGD_027A_ROEB"; // used as a reminder
	// "Get to it, Miller! Take out that bunker!"
	level.scr_sound["sarge"]["satchelnag3"] = "Oki2_IGD_103A_ROEB"; // added July 25
	// "Put a fucking grenade in there!"
	// level.scr_sound["sarge"]["satchelnag3"] = "Oki2_IGD_026A_ROEB";

	// "Hurry it up, Miller!"
	level.scr_sound["polonsky"]["hurryitup"] = "Oki2_IGD_028A_POLO"; // used as a reminder for both flame and satchel
	
	// "Finish the job!"
	level.scr_sound["sarge"]["finishjob"] = "Oki2_IGD_029A_ROEB";
	
	// "One down - keep on it!"
	level.scr_sound["sarge"]["onedown"] = "Oki2_IGD_030A_ROEB";
	// "Outstanding Miller, only one to go!"
	level.scr_sound["sarge"]["twodown"] = "Oki2_IGD_031A_ROEB";
	
// ~~~~~~ UPON REACHING LITTLE BRIDGE IN CANYON ~~~~~~
	
	// "Other side of the bridge!"
	level.scr_sound["sarge"]["otherside"] = "Oki2_IGD_032A_ROEB";
	// "Last one's taken out.  Good work!"
	level.scr_sound["sarge"]["lastone"] = "Oki2_IGD_033A_ROEB";
	
// ~~~~~~ EXITING TUNNEL, SEEING FRIENDLIES ~~~~~~
	
	// "Our tanks are moving up... Get behind."
	level.scr_sound["sarge"]["tanksmoving"] = "Oki2_IGD_034A_ROEB";
	// "Incoming!!!"
	//level.scr_sound["sarge"]["incoming"] = "Oki2_IGD_036A_ROEB";
	// "Mortar fire!!!"
	level.scr_sound["polonsky"]["mortarfire"] = "Oki2_IGD_037A_POLO";
	// "Take cover!"
	level.scr_sound["sarge"]["takecover"] = "Oki2_IGD_038A_ROEB";
	
// ~~~~~~ REACHING CREST OF HILL

	// "That our destination?... it's a goddamn fortess!"
	level.scr_sound["polonsky"]["fortress"] = "Oki2_IGD_035A_POLO";
	// "Roebuck! - We can flank 'em - I see paths around either side!!"
	level.scr_sound["polonsky"]["seepaths"] = "Oki2_IGD_039A_POLO";

// BELOW IS NEW AS OF JULY 25!
	
// ~~~~~~ TREE SNIPERS

	// "We got snipers in the trees!"
	level.scr_sound["polonsky"]["snipersintrees"] = "Oki2_IGD_100A_POLO";
	// "I see 'em!"
	level.scr_sound["sarge"]["iseeem"] = "Oki2_IGD_101A_ROEB";
	// "You know what to do - bring 'em down!"
	level.scr_sound["sarge"]["bringemdown"] = "Oki2_IGD_102A_ROEB";
	
// ~~~~~~ ADDITIONAL BUNKER REMINDERS

	// "Burn those bunkers!"
	level.scr_sound["sarge"]["burnthose"] = "Oki2_IGD_104A_ROEB";
	// "Put some goddamn flames in those bunkers!"
	level.scr_sound["sarge"]["goddamnflames"] = "Oki2_IGD_105A_ROEB";
	// "What you waitin' for, Miller?!... Burn 'em!!"
	level.scr_sound["polonsky"]["burnem"] = "Oki2_IGD_106A_POLO";
	// "Flame those bunkers, Miller!!!"
	level.scr_sound["polonsky"]["flamethose"] = "Oki2_IGD_107A_POLO";
	
// ~~~~~~ KICKING DOWN PLAYER BLOCKER

	// "Everyone! On me!"
	level.scr_sound["sarge"]["meetme"] = "Oki2_IGD_108A_ROEB";
	// "What do we do now?"
	level.scr_sound["polonsky"]["whatnow"] = "Oki2_IGD_109A_POLO";
	// "We keep moving, Polonsky…"
	level.scr_sound["sarge"]["keepmovingpolonsky"] = "Oki2_IGD_110A_ROEB";
	// "We keep moving."
	level.scr_sound["sarge"]["keepmoving"] = "Oki2_IGD_111A_ROEB";	
	// "Stay in cover - let's get through this…"
	level.scr_sound["sarge"]["stayincover"] = "Oki2_IGD_112A_ROEB";
	
// ~~~~~~ FOUND TUNNEL ENTRANCE BEHIND E3 BUNKER
	
	// "Sarge, tunnel up ahead! "
	level.scr_sound["polonsky"]["tunnelahead"] = "Oki2_IGD_113A_POLO";
	// "Good work, people."
	level.scr_sound["sarge"]["goodworkpeople"] = "Oki2_IGD_114A_ROEB";
	// "The Major's convoy is en route - after this... We'll be on easy street."
	level.scr_sound["sarge"]["convoyenroute"] = "Oki2_IGD_115A_ROEB";

// ~~~~~~ REACHING LADDER INTO E3 BUNKER PROPER

	// "Up the ladder!  Double time! "
	level.scr_sound["sarge"]["upladder"] = "Oki2_IGD_120A_ROEB";
	// "I want this area secured."
	level.scr_sound["sarge"]["areasecured"] = "Oki2_IGD_119A_ROEB";
	// "Don't skip those mortar positions above us."
	level.scr_sound["sarge"]["mortarpositions"] = "Oki2_IGD_118A_ROEB";
	
	// "Everyone ready?"
	level.scr_sound["sarge"]["REFERENCE"] = "Oki2_IGD_116A_ROEB";
	// "Move!"
	level.scr_sound["sarge"]["REFERENCE"] = "Oki2_IGD_117A_ROEB";

// ~~~~~~ E3 BUNKER IS SECURE

	// "Outstanding, marines... "
	level.scr_sound["sarge"]["outstandingmarines"] = "Oki2_IGD_121A_ROEB";
	// "Out-fucking-standing…"
	level.scr_sound["sarge"]["outfuckingstanding"] = "Oki2_IGD_122A_ROEB";
	// "Now let's get out of this damn hole and start tending to our wounded... "
	level.scr_sound["sarge"]["tendwounded"] = "Oki2_IGD_123A_ROEB";
	
// ~~~~~~ OUTRO CUTSCENE

	// "Keep moving you little bastards… (beat) You're running out of places to hide…"
	//level.scr_sound["polonsky"]["littlebastards"] = "Oki2_OUT_000A_POLO";
	// "MILLER! GET OVER HERE!"
	level.scr_sound["sarge"]["miller"] = "Oki2_OUT_001A_ROEB";
	// "Hold on kid, we're gonna get you out of here."
	level.scr_sound["sarge"]["holdonkid"] = "Oki2_OUT_002A_ROEB";
	// "Help me get him on the truck."
	level.scr_sound["sarge"]["onthetruck"] = "Oki2_OUT_003A_ROEB";
	// "We're moving out."
	level.scr_sound["co"]["movingout"] = "Oki2_OUT_004A_MAJG";
	// "One... two... three."
	level.scr_sound["sarge"]["onetwothree"] = "Oki2_OUT_005A_ROEB";
	// "It's not bad, okay? (beat) It's not bad."
	level.scr_sound["sarge"]["itsnotbad"] = "Oki2_OUT_006A_ROEB";
	// "You leavin'?"
	level.scr_sound["polonsky"]["youleavin"] = "Oki2_OUT_007A_POLO";
	// "Push ahead and take Shuri castle."
	level.scr_sound["co"]["shuricastle"] = "Oki2_OUT_008A_MAJG";
	// "But we're runnin' on empty here!"
	level.scr_sound["polonsky"]["runninonempty"] = "Oki2_OUT_009A_POLO";
	// "You'll have a supply drop tomorrow morning."
	level.scr_sound["co"]["supplydrop"] = "Oki2_OUT_010A_MAJG";
	// "Tomorrow?!!... How the hell are we supposed to hold out till tomorrow?!"
	level.scr_sound["polonsky"]["holdout"] = "Oki2_OUT_011A_POLO";
	// "This is bullshit."
	level.scr_sound["polonsky"]["bullshit"] = "Oki2_OUT_012A_POLO";
	// "You hear this, Sarge?... We ain't getting shit 'til tomorrow morning."
	level.scr_sound["polonsky"]["hearthissarge"] = "Oki2_OUT_013A_POLO";
	// "Intel says the castle is mostly deserted - main force pulled back the north ridge."
	level.scr_sound["co"]["deserted"] = "Oki2_OUT_014A_MAJG";
	// "Easy - we got you."
	level.scr_sound["guy1"]["wegotyou"] = "Oki2_OUT_015A_COR1";
	// "Look on the bright side… After this, you boys will probably get relieved and be on the boat home…"
	level.scr_sound["co"]["boathome"] = "Oki2_OUT_016A_MAJG";
	// "Yeah?... We heard that crock of shit after Peleliu…"
	level.scr_sound["polonsky"]["crockofshit"] = "Oki2_OUT_017A_POLO";
	// "You have to stay calm, okay?"
	level.scr_sound["guy2"]["staycalm"] = "Oki2_OUT_500A_COR2";
	// "You're conscious and alert - that's a good sign - trust me."
	level.scr_sound["guy2"]["conscious"] = "Oki2_OUT_501A_COR2";
	// "You - Private...Come here!"
	//level.scr_sound["guy2"]["comehere"] = "Oki2_OUT_502A_COR2";
	// "Keep pressure on the wound, okay?"
	//level.scr_sound["guy2"]["pressure"] = "Oki2_OUT_503A_COR2";

	// "Corpsman!"
	//level.scr_sound["pgas (private gascoine)"]["REFERENCE"] = "Oki2_OUT_504A_PGAS";
	// "Hill's hurt bad!"
	//level.scr_sound["pgas (private gascoine)"]["REFERENCE"] = "Oki2_OUT_505A_PGAS";
	// "Somebody... (beat) Please!!!!"
	//level.scr_sound["pgas (private gascoine)"]["REFERENCE"] = "Oki2_OUT_506A_PGAS";


	
	

	level.scr_anim["sarge"]["door_kick"]		= %door_kick_in;
	level.scr_anim["sarge"]["door_bash"]		= %ch_holland3_door_bash;
	addNotetrack_sound("sarge", "bash", "door_bash", "metal_door_kick");
	addNotetrack_customFunction("sarge", "oki2_bash", maps\oki2::move_e3_start_gate, "door_bash");

	level.scr_anim["bayonet_guy1"]["flipover"] = %ch_bayonet_flipover_guy1;
	level.scr_anim["bayonet_guy2"]["flipover"] = %ch_bayonet_flipover_guy2;
}

/*------------------------------------
spiderhole stuff
------------------------------------*/

#using_animtree( "spiderhole_model" );
init_lid_anims()
{
	PrecacheModel( "tag_origin_animate" ); // Used to link the spiderhole lid
	level.scr_animtree["spiderhole_lid"] = #animtree;
	level.scr_anim["spiderhole_lid"]["jump_out"] = %o_spiderhole_jump_out_lid;
	level.scr_anim["spiderhole_lid"]["stumble_out"] = %o_spiderhole_stumble_out_lid;
	level.scr_anim["spiderhole_lid"]["grenade_toss"] = %o_spiderhole_grenade_toss_lid;
	level.scr_anim["spiderhole_lid"]["gun_spray"] = %o_spiderhole_gun_spray_lid;
	level.scr_anim["spiderhole_lid"]["idle"] = %o_spiderhole_idle_lid;
	level.scr_anim["spiderhole_lid"]["crouch2stand"] = %o_spiderhole_jump_out_lid;
	level.scr_anim["spiderhole_lid"]["jump_attack"] = %o_spiderhole_jump_attack_lid;
}

#using_animtree( "generic_human" );
init_spiderhole_anims()
{
	level.scr_anim["spiderhole"]["sprint"][0] = %ai_bonzai_sprint_a;
	level.scr_anim["spiderhole"]["sprint"][1] = %ai_bonzai_sprint_b;
	level.scr_anim["spiderhole"]["sprint"][2] = %ai_bonzai_sprint_c;

	level.scr_anim["spiderhole"]["jump_out"] = %ai_spiderhole_jump_out;
	level.scr_anim["spiderhole"]["stumble_out"] = %ai_spiderhole_stumble_out;
	level.scr_anim["spiderhole"]["grenade_toss"] = %ai_spiderhole_grenade_toss;
	level.scr_anim["spiderhole"]["gun_spray"] = %ai_spiderhole_gun_spray;
	level.scr_anim["spiderhole"]["crouch2stand"] = %crouch2stand;
	level.scr_anim["spiderhole"]["jump_attack"] = %ai_spiderhole_jump_attack;

	level.scr_anim["spiderhole"]["spiderhole_idle_crouch"][0] = %ai_spiderhole_idle;
	
	// used for guys following the E3 tank
	level.scr_anim[ "generic" ][ "combat_jog" ] = %combat_jog;
	
	level.scr_anim["collectible"]["collectible_loop"][0]	= %ch_oki2_collectible;
}

//flappy curtain sweetness
#using_animtree( "oki3_models" );
init_mg_tarp()
{
	level.scr_animtree["mg_curtains"]			= #animtree;
	level.scr_anim["mg_curtains"]["intro"]		= %o_clothblinders_flap_intro;
	level.scr_anim["mg_curtains"]["loop"]		= %o_clothblinders_flap_loop;
	level.scr_anim["mg_curtains"]["outro"]		= %o_clothblinders_flap_outro;
}
