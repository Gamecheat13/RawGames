#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;

#using_animtree( "generic_human" );

prepare_dialogue()
{
//ACTORS
	Sandman = "lone_star"; //William Fichtner
	Truck = "truck"; //Idris Elba
	Grinch = "essex"; //Timothy Olyphant
	AmericanSoldier = "generic"; //Matt Mercer
	AmericanSoldier2 = "generic"; //Liam O'Brien
	Alena = "alena"; //Anna Graves
	
//RADIO ACTORS
	//Overlord - Bruce Greenwood
	//Granite Leader - Michael Cudlitz
	//Valkyrie - Anna Graves
	//Little Bird Pilot - Zach Hanks
	//Pilot 1 - Brian Bloom
	//Pilot 2 - Zach Hanks
	//Apache Gunner - Matt Mercer
	//German Tank Commander - Kai Wulf


//DIALOGUE

//global nag
	//Sandman: Frost, what are you waiting for?
	level.scr_sound[Sandman][ "berlin_cby_waitingfor" ]		= "berlin_cby_waitingfor";	
	
	
//Intro: see Aftermath	
	
	
//Heli Ride

	//Little Bird Pilot: 30 seconds!
	level.scr_radio[ "berlin_lbp_deltaboys" ]		= "berlin_lbp_deltaboys";
	//Grinch: Berlin's getting ripped apart down there.
	level.scr_radio[ "berlin_rno_rippedapart" ]		= "berlin_rno_rippedapart";
	//Grinch: RPG! Look out!
	level.scr_sound[Grinch][ "berlin_rno_rpglookout" ]		= "berlin_rno_rpglookout";
	//Sandman: Bird is down! Bird is down!
	level.scr_sound[Sandman][ "berlin_cby_birdisdown" ]		= "berlin_cby_birdisdown";
	//Littlebird Pilot: Metal One is on the deck.  Viper Five going in to holding pattern.
	level.scr_radio[ "berlin_lbp_ondeck" ]		= "berlin_lbp_ondeck";

/* cut
//Pilot 1: Got targets in the killbox - missiles loose.
level.scr_radio[ "berlin_plt1_killbox" ]		= "berlin_plt1_killbox";
//Pilot 2: Chalk 1 - customers on the ground. I'm out. Chalk 2 is in.
level.scr_radio[ "berlin_plt2_imout" ]		= "berlin_plt2_imout";
//Pilot 1: Hammer 6-4 established in off-set orbit. Minimum two minues out. Standing by for recall.
level.scr_radio[ "berlin_plt1_standingby" ]		= "berlin_plt1_standingby";
//Truck: Thirty seconds!
level.scr_radio[ "berlin_trk_thirtyseconds" ]		= "berlin_trk_thirtyseconds";
//Littlebird Pilot: And you guys want to fly in to the middle of it.  You're outta your damn minds.
level.scr_radio[ "berlin_lbp_wannafly" ]		= "berlin_lbp_wannafly";
//Sandman: Just get us as close to the roof as you can.
level.scr_sound[Sandman][ "berlin_cby_closetotheroof" ]		= "berlin_cby_closetotheroof";
//Littlebird Pilot: Viper Five touching down at target.
level.scr_radio[ "berlin_lbp_touchingdown" ]		= "berlin_lbp_touchingdown";
*/
	
	
//AA building
	
	//Sandman: Go! Go! Go!
	level.scr_sound[Sandman][ "go_go_go" ] 		= "berlin_cby_gogogo";
	//Grinch: Contact!  Second floor!
	level.scr_sound[Grinch][ "berlin_rno_secondfloor2" ]		= "berlin_rno_secondfloor2";
	//Sandman: Head up!
	level.scr_sound[Sandman][ "berlin_cby_headup" ]		= "berlin_cby_headup";
	//Sandman: Head for the roof!
	level.scr_sound[Sandman][ "berlin_cby_headforroof2" ]		= "berlin_cby_headforroof2";
	//SANDMAN: We need to get to the roof!
	level.scr_sound[Sandman][ "berlin_cby_destroysam" ] 		= "berlin_cby_destroysam";
	//SANDMAN: Frost, with me!
	level.scr_sound[Sandman][ "frost_with_me" ] 		= "berlin_cby_frostwithme";
	//Truck: Clear!
	level.scr_sound[Truck][ "berlin_trk_clear" ]		= "berlin_trk_clear";
	//Truck: Clear!
	level.scr_sound[Truck][ "berlin_trk_clear2" ]		= "berlin_trk_clear2";
	//Grinch: Rog'!
	level.scr_sound[Grinch][ "berlin_rno_rog" ]		= "berlin_rno_rog";
	//Sandman: Up the stairs!
	level.scr_sound[Sandman][ "berlin_cby_upthestairs" ]		= "berlin_cby_upthestairs";
	//SANDMAN: Move!
	level.scr_sound[Sandman][ "berlin_cby_move" ] 		= "berlin_cby_move";
	//GRINCH: Moving!
	level.scr_sound[Grinch][ "berlin_rno_moving" ] 		= "berlin_rno_moving";
	//Sandman: Secure this area fast!
	level.scr_sound[Sandman][ "berlin_cby_visontarget" ]		= "berlin_cby_visontarget";
	//Sandman: Strongpoint the roof and get eyes on the hotel across the street!
	level.scr_sound[Sandman][ "berlin_cby_strongpoint" ]		= "berlin_cby_strongpoint";


//sniper riffle pickup nag

	//Sandman: Frost, use your sniper rifle!
	level.scr_sound[Sandman][ "berlin_cby_userifle" ]		= "berlin_cby_userifle";
	//Sandman: Frost, grab a sniper rifle!
	level.scr_sound[Sandman][ "berlin_cby_grabrifle" ]		= "berlin_cby_grabrifle";


//sniper

	//overwatch nags	
	//Sandman: Frost, get on overwatch!
	level.scr_sound[Sandman][ "berlin_cby_overwatch" ]		= "berlin_cby_overwatch";
	//Sandman: You're wasting time, Frost, let's go!
	level.scr_sound[Sandman][ "berlin_cby_wastingtime" ]		= "berlin_cby_wastingtime";
	
	//Sandman: Granite 0-1, we're in position.
	level.scr_radio[ "berlin_cby_inposition" ]		= "berlin_cby_inposition";
	//Littlebird Pilot: Solid Copy, Zero One.  Will relay.
	level.scr_radio[ "berlin_lbp_willrelay" ]		= "berlin_lbp_willrelay";
	//Littlebird Pilot: Granite Zero One, overwatch established.  
	level.scr_radio[ "berlin_lbp_overwatch" ]		= "berlin_lbp_overwatch";
	//Granite Leader: Copy that.  We're inbound.
	level.scr_radio[ "berlin_grl_breaching" ]		= "berlin_grl_breaching";
	//Apache Gunner: Got targets in the LZ - missiles loose.
	level.scr_radio[ "berlin_apg_missilesloose" ]		= "berlin_apg_missilesloose";
	//Grinch: Hostiles on the roof!
	level.scr_sound[Grinch][ "berlin_rno_ontheroof" ]		= "berlin_rno_ontheroof";
	//Sandman: Keep em covered.
	level.scr_sound[Sandman][ "berlin_cby_giveemcover" ]		= "berlin_cby_giveemcover";
	
	//sniper rooftop nags
	//Truck: Still got guys on the roof - building across the street!
	level.scr_sound[Truck][ "berlin_trk_guysonroof" ]		= "berlin_trk_guysonroof";
	//Sandman: Take care of em!
	level.scr_sound[Sandman][ "berlin_cby_takecare" ]		= "berlin_cby_takecare";
	//Sandman: Frost, clear that roof so Granite can land!
	level.scr_sound[Sandman][ "berlin_cby_canland" ]		= "berlin_cby_canland";
	
	//Little Bird Pilot: Granite Team is on the deck now.
	level.scr_radio[ "berlin_lbp_ondecknow" ]		= "berlin_lbp_ondecknow";
	//Truck: Granite's got company.  Doorway on the left.
	level.scr_sound[Truck][ "berlin_trk_gotcompany" ]		= "berlin_trk_gotcompany";
	//Granite Leader: We're taking fire!
	level.scr_radio[ "berlin_grl_takingfire" ]		= "berlin_grl_takingfire";

	//Sandman: Four more.
	level.scr_sound[Sandman][ "berlin_cby_4enemies" ]		= "berlin_cby_4enemies";
	//Sandman: You're clear, Granite.  Keep movin.
	level.scr_sound[Sandman][ "berlin_cby_areaclear" ]		= "berlin_cby_areaclear";
	//Sandman: Good hit.
	level.scr_sound[Sandman][ "berlin_cby_goodhit2" ]		= "berlin_cby_goodhit2";
	//Sandman: Good kill.
	level.scr_sound[ Sandman ][ "goodkill" ] 		= "berlin_cby_goodkill2";
	//Sandman: Good effects on target.
	level.scr_sound[Sandman][ "berlin_cby_goodeffect" ]		= "berlin_cby_goodeffect";
	
	//Truck: T90's on the road!
	level.scr_sound[Truck][ "berlin_brvl_btrcrawl" ]		= "berlin_brvl_btrcrawl";
	//Sandman: Overlord, we have Russian tanks firing on Granite's position.  Requesting fire mission!
	level.scr_sound[Sandman][ "berlin_cby_firemission" ]		= "berlin_cby_firemission";
	//Overlord: Solid copy, Zero-One, the air corridor is clear for our A-10s to commence gun-runs.
	level.scr_radio[ "race_track_clear" ] 		= "berlin_hqr_racetrackclear";
	//A10: Metal Zero-One, this is Valkyrie Two-Six.  In the airspace and at your service.  Standing by for you to laze the first target.
	level.scr_radio["berlin_plt_standingby"]="berlin_plt_standingby";
	
	//tank stuff
	//Sandman: Frost - paint targets for the A-10.
	level.scr_sound[Sandman]["paint_targets"] = "berlin_cby_laserdesignate";
	//Sandman: Frost, hit the tank on the street!
	level.scr_sound[Sandman][ "berlin_cby_tankonstreet" ]		= "berlin_cby_tankonstreet";
	//Sandman: Frost, the tank's on the street below us!
	level.scr_sound[Sandman][ "berlin_cby_belowus" ]		= "berlin_cby_belowus";
	//Sandman: Stop looking at the building, Frost! Eyes on the street!
	level.scr_sound[Sandman][ "berlin_cby_stoplooking" ]		= "berlin_cby_stoplooking";
	//Sandman: Two more tanks approaching! Take 'em out!
	level.scr_sound[Sandman][ "berlin_cby_twomoretanks" ]		= "berlin_cby_twomoretanks";
	//Sandman: Target the tanks on the street!
	level.scr_sound[Sandman][ "berlin_cby_targettanks" ]		= "berlin_cby_targettanks";
	//Sandman: Frost, keep your eyes on Granite!
	level.scr_sound[Sandman][ "berlin_cby_eyesongranite" ]		= "berlin_cby_eyesongranite";
	//Sandman: Take out that tank!  We need to get to the girl!
	level.scr_sound[Sandman][ "berlin_cby_gettogirl" ]		= "berlin_cby_gettogirl";
	//Sandman: Direct hit!
	level.scr_sound[Sandman][ "berlin_cby_directhit2" ]		= "berlin_cby_directhit2";
	
	//granite team goes into hotel
	//Sandman: All hard targets neutralized! Your flank is clear.
	level.scr_sound[Sandman][ "berlin_cby_flankclear" ]		= "berlin_cby_flankclear";
	//Granite Leader: Roger, commencing assault!
	level.scr_radio[ "berlin_grl_assault" ]		= "berlin_grl_assault";
	//Sandman: Frost, maintain eyes on the building.
	level.scr_sound[Sandman][ "berlin_cby_maintaineyes" ]		= "berlin_cby_maintaineyes";
	//Granite Leader: We're going in!
	level.scr_radio[ "berlin_grl_goingin" ]		= "berlin_grl_goingin";
	//Sandman: Granite, do you have eyes on the president's daughter?!
	level.scr_sound[Sandman][ "berlin_cby_eyesondaughter" ]		= "berlin_cby_eyesondaughter";
	//Granite Leader: Affirmative, but there's too many of them! We can't get to her!
	level.scr_radio[ "berlin_grl_cantgettoher" ]		= "berlin_grl_cantgettoher";
	
	//granite team death scene
	//Grinch: I don't see anything movin' down there.
	level.scr_sound[Grinch][ "berlin_rno_anythingmoving" ]		= "berlin_rno_anythingmoving";
	//Truck: They're gone.
	level.scr_sound[Truck][ "berlin_trk_damn" ]		= "berlin_trk_damn";
	//Sandman: Granite! Granite!
	level.scr_sound[Sandman][ "berlin_cby_granitegranite" ]		= "berlin_cby_granitegranite";
	//Grinch: What the hell!?
	level.scr_sound[Grinch][ "berlin_rno_eaglesdown" ]		= "berlin_rno_eaglesdown";
	//Sandman: Overlord, Granite Team is down.  I repeat, eagles down.  We're going after Athena.
	level.scr_sound[Sandman][ "berlin_cby_pcteam" ]		= "berlin_cby_pcteam";
	//Overlord: Affirmative, Sandman.  Link up with the German tank column south of your position and proceed to the target building, over.
	level.scr_radio[ "berlin_hqr_linkup" ]		= "berlin_hqr_linkup";
	//Truck: Thanks for the guns, Valkyrie.  We'll take it from here.
	level.scr_radio[ "berlin_trk_takeit" ]		= "berlin_trk_takeit";


//A10
	
	//Target acquired.
	level.scr_radio["berlin_plt_targetaquired"]="berlin_plt_targetaquired";
	//Tally target.
	level.scr_radio["berlin_plt_tallytarget"]="berlin_plt_tallytarget";
	//Contact.
	level.scr_radio["berlin_plt_contact"]="berlin_plt_contact";
	//I got a tally on the target.
	level.scr_radio["berlin_plt_tallyontarget"]="berlin_plt_tallyontarget";
	//SANDMAN: Valkyrie 2-6 tally target, in from the north.
	//level.scr_sound[Sandman]["berlin_cby_tallytarget"]="berlin_cby_tallytarget";
	//Going hot.
	level.scr_radio["berlin_plt_goinghot"]="berlin_plt_goinghot";
	//Target hit.
	//level.scr_radio["berlin_plt_targethit"]="berlin_plt_targethit";
	
	//Valkyrie - In position.
	//level.scr_radio["berlin_plt_inposition"]="berlin_plt_inposition";
	//Standing by for targets.
	level.scr_radio["berlin_plt_standingby3"]="berlin_plt_standingby3";
	//Metal 0-4, I am in position.
	level.scr_radio["berlin_plt_inposition2"]="berlin_plt_inposition2";
	//Ready for tasking.
	level.scr_radio["berlin_plt_ready"]="berlin_plt_ready";
	//Metal 0-4, I am standing by.
	level.scr_radio["berlin_plt_standingby4"]="berlin_plt_standingby4";
	
	//Negative, I am not in position.
	level.scr_radio["berlin_plt_notinposition"]="berlin_plt_notinposition";
	//Wait for us to circle back.
	level.scr_radio["berlin_plt_circleback"]="berlin_plt_circleback";
	//Negative, Whiskey Zero-Four.
	level.scr_radio["berlin_plt_negative"]="berlin_plt_negative";
	//Not in position.
	level.scr_radio["berlin_plt_notinposition2"]="berlin_plt_notinposition2";
	//Hold fast - in the turn.
	level.scr_radio["berlin_plt_holdfast"]="berlin_plt_holdfast";
	
	//A10 can't get there
	//Female A-10 pilot: Recommend change to attack direction.
	level.scr_radio[ "berlin_plt_direction" ]		= "berlin_plt_direction";
	//Request alternate attack heading.
	level.scr_radio["berlin_plt_altattack"]="berlin_plt_altattack";
	//Recommend change to attack direction to maximize weapon effects.
	level.scr_radio["berlin_plt_maxeffects"]="berlin_plt_maxeffects";
	//That heading is no good, request reciprocal.
	level.scr_radio["berlin_plt_reciprocal"]="berlin_plt_reciprocal";
	//Valkyrie 2-6 is unable to make that heading.
	level.scr_radio["berlin_plt_unable"]="berlin_plt_unable";
	//Valkyrie requires new run-in.
	level.scr_radio["berlin_plt_newrunin"]="berlin_plt_newrunin";
	//Negative, that is a bad approach vector.
	level.scr_radio["berlin_plt_badapproach"]="berlin_plt_badapproach";
	
	
//rappel

	//rappel nag
	//Sandman: Frost, over here!
	level.scr_sound[Sandman][ "berlin_cby_overhere" ]		= "berlin_cby_overhere";
	//Sandman: Frost, let's move!
	level.scr_sound[Sandman][ "berlin_cby_letsmove2" ]		= "berlin_cby_letsmove2";
	//Sandman: This way!
	level.scr_sound[Sandman][ "berlin_cby_thisway2" ]		= "berlin_cby_thisway2";
	//Sandman: Hook up.
	level.scr_sound[Sandman][ "berlin_cby_hookup2" ]		= "berlin_cby_hookup2";
	//Sandman: Frost, hook up. We need to hit the street.
	level.scr_sound[Sandman][ "berlin_cby_hookup" ]		= "berlin_cby_hookup";
	

//Alley to bridge

	//Sandman: Solid copy.  Sandman out.
	level.scr_sound[Sandman][ "berlin_cby_sandmanout" ]		= "berlin_cby_sandmanout";
	//Truck: Got some casualties here.
	level.scr_sound[Truck][ "berlin_trk_casualties" ]		= "berlin_trk_casualties";
	//Truck: It's Onyx Team.
	level.scr_sound[Truck][ "berlin_trk_onyxteam" ]		= "berlin_trk_onyxteam";
	//Sandman: Grab their patches and tags.
	level.scr_sound[Sandman][ "berlin_cby_patchestags" ]		= "berlin_cby_patchestags";
	//Truck: Rog'.
	level.scr_sound[Truck][ "berlin_trk_rog" ]		= "berlin_trk_rog";
	//Truck: Overlord, this is Metal Zero Two.  I need evac for three casualties.  Coordinates follow: Seven Romeo Eight Five One.
	level.scr_radio[ "berlin_trk_needevac" ]		= "berlin_trk_needevac";
	//Overlord: Copy that, Zero Two.  We'll send in a SAR brid for evac.
	level.scr_radio[ "berlin_hqr_sarbird" ]		= "berlin_hqr_sarbird";
	//Grinch: Not a good day to be Delta…
	level.scr_sound[Grinch][ "berlin_rno_notagoodday" ]		= "berlin_rno_notagoodday";
	
	
//clear bridge
	
	//German Tank Commander: American Team - we have Russian armor firing on the bridge.  We need you to take out their tank!
	level.scr_radio[ "berlin_gtc_pinneddown" ]		= "berlin_gtc_pinneddown";
	//Sandman: Let's go! Move out!
	level.scr_sound[Sandman][ "berlin_cby_moveout" ]		= "berlin_cby_moveout";
	//Truck: They got a T90 dug in - straight ahead!
	level.scr_sound[Truck][ "berlin_trk_dugin" ]		= "berlin_trk_dugin";
	
	//RPG nag
	//Grinch: You gonna kill that thing or what?!
	level.scr_sound[Grinch][ "berlin_rno_killthatthing" ]		= "berlin_rno_killthatthing";
	//German Tank Commander: We're getting hit hard!  We can't take much more!
	level.scr_radio[ "berlin_gtc_hithard" ]		= "berlin_gtc_hithard";
	//Sandman: Grab an RPG and take out that tank!
	level.scr_sound[Sandman][ "berlin_cby_grabrpg" ]		= "berlin_cby_grabrpg";
	//Sandman: Take out that tank with an RPG!
	level.scr_sound[Sandman][ "berlin_cby_takeouttank" ]		= "berlin_cby_takeouttank";
	//Sandman: Frost - take care of it!  We'll cover you!
	level.scr_sound[Sandman][ "berlin_cby_takecareofit" ]		= "berlin_cby_takecareofit";
	//Our armor is moving.  Hurry!
	level.scr_sound[Sandman]["berlin_cby_armormoving"] = "berlin_cby_armormoving";
	
	
//Parkway

	//German Tank Commander: We're clear. Advancing now!
	level.scr_radio[ "berlin_gtc_advancing" ]		= "berlin_gtc_advancing";
	
	//German Tank Commander: Firing!
	level.scr_radio[ "berlin_gtc_firing" ]		= "berlin_gtc_firing";
	
	// add nag if player stays at the back of parkway
	//Sandman: Follow those tanks. Stay close till we reach the hotel!
	level.scr_sound[Sandman][ "berlin_cby_followtanks" ]		= "berlin_cby_followtanks";
	//Sandman: Move up!
	level.scr_sound[Sandman]["move_up"] = "berlin_cby_moveup";
	//Sandman: Push forward!
	level.scr_sound[Sandman]["push_forward"] = "berlin_cby_pushfwd";
	//Sandman: Contact, up ahead!
	level.scr_sound[Sandman][ "berlin_cby_contactahead" ]		= "berlin_cby_contactahead";
	//Sandman: Keep moving with the tanks!  Use 'em for cover!
	level.scr_sound[Sandman][ "berlin_cby_useem" ]		= "berlin_cby_useem";
	
	//German Tank Commander: Straight ahead!
	level.scr_radio[ "berlin_gtc_straightahead" ]		= "berlin_gtc_straightahead";
	
	//Sandman: We're almost there!  Let's go!  C'mon!
	level.scr_sound[Sandman][ "berlin_cby_almostthere" ]		= "berlin_cby_almostthere";
	//Sandman: They're falling back - press the attack!
	level.scr_sound[Sandman][ "press_attack" ]		= "berlin_cby_presstheattack";

	//right side
	//German Tank Commander: Acquiring targets by the bank!
	level.scr_radio[ "berlin_gtc_acquiring" ]		= "berlin_gtc_acquiring";
	//Sandman: They're in the bank!  Right side!
	level.scr_sound[Sandman][ "inside_bank" ]		= "berlin_cby_insidebank2";
	//German Tank Commander: More targets on the right!
	level.scr_radio[ "berlin_gtc_moretargets" ]		= "berlin_gtc_moretargets";
	
	//left side
	//German Tank Commander: Left!  Twenty Degrees!
	level.scr_radio[ "berlin_gtc_left20degrees" ]		= "berlin_gtc_left20degrees";
	//German Tank Commander: Multiple targets by the office building! Engaging!
	level.scr_radio[ "berlin_gtc_office" ]		= "berlin_gtc_office";
	
/* not using but could
//Sandman: Frost, get over here!
level.scr_sound[Sandman][ "berlin_cby_frostcomehere" ]		= "berlin_cby_frostcomehere";
*/
	

//Building Collapse

/* cut doesn't work with explosions and audio
//American Soldier: OH SHIT!!!!!
level.scr_sound[AmericanSoldier][ "berlin_as1_ohshit" ]		= "berlin_as1_ohshit";
//American Soldier: GET DOWN!!!!!
level.scr_sound[AmericanSoldier][ "berlin_as1_getdown" ]		= "berlin_as1_getdown";
//American Soldier 2: MOVE!!  MOVE!!!
level.scr_sound[AmericanSoldier2][ "berlin_as2_move" ]		= "berlin_as2_move";
//Overlord: Metal Zero One, come in.  Metal Zero One, do you copy?
level.scr_radio[ "berlin_hqr_comein" ]		= "berlin_hqr_comein";
*/

	
//Aftermath/Intro
	
	//Sandman: (CONT’D)It’s an ambush! We gotta get the hell out of the kill zone! Move! Move! Move!
	level.scr_sound[Sandman]["an_ambush"] = "berlin_cby_anambush";
	//Sandman: (CONT’D)Head for the building!
	//This line has been moved to berlin_anim.gsc for facial animation
	//Overlord: Metal 0-1, we've lost contact with the German division commander. What's the status on the ground?
	level.scr_radio[ "berlin_hqr_lostcontact" ]		= "berlin_hqr_lostcontact";
	//Sandman: They're gone! Conventional forces are combat ineffective and getting overrun! This A.O. is lost!
	level.scr_sound[Sandman][ "berlin_cby_aoislost" ]		= "berlin_cby_aoislost";
	//Overlord: Missed your last, Zero One - say again.
	level.scr_radio[ "berlin_hqr_missedyourlast" ]		= "berlin_hqr_missedyourlast";
	//Sandman: They dropped a damn building on us!
	level.scr_sound[Sandman][ "berlin_cby_damnbuilding" ]		= "berlin_cby_damnbuilding";
	

//Fallen Building

	//Overlord: Roger - advise immediate pull back to extraction point.
	level.scr_radio[ "berlin_hqr_pullback" ]		= "berlin_hqr_pullback";
	//Sandman: Negative Overlord - we are going for the girl. Her beacon is still active.
	level.scr_sound[Sandman][ "berlin_cby_goingforgirl" ]		= "berlin_cby_goingforgirl";
	//Overlord: You'll need to move fast - Berlin is falling. We'll maintain ISR, over.
	level.scr_radio[ "berlin_hqr_berlinfalling" ]		= "berlin_hqr_berlinfalling";
	
	//Sandman: Through here.
	level.scr_sound[Sandman][ "berlin_cby_throughhere" ]		= "berlin_cby_throughhere";
	//Grinch: This thing's gonna come down on us any second.
	level.scr_sound[Grinch][ "berlin_rno_comedown" ]		= "berlin_rno_comedown";
	//Truck: Easy, easy.
	level.scr_sound[Truck][ "berlin_trk_easy" ]		= "berlin_trk_easy";
	//Grinch: Man…this is some bullshit.
	level.scr_sound[Grinch][ "berlin_rno_thisissome" ]		= "berlin_rno_thisissome";
	//Truck: Just keep moving.
	level.scr_sound[Truck][ "berlin_trk_keepmoving" ]		= "berlin_trk_keepmoving";
	//Truck: They must have rigged the building to blow if our tanks got this far…
	level.scr_sound[Truck][ "berlin_trk_rigged" ]		= "berlin_trk_rigged";
	
	//Truck: Got a doorway over here.
	level.scr_sound[Truck][ "berlin_trk_doorway" ]		= "berlin_trk_doorway";
	//Sandman: I'm on it.
	level.scr_sound[Sandman][ "berlin_cby_imonit" ]		= "berlin_cby_imonit";
	
	
//Emerge

	//Sandman: There's the hotel!
	level.scr_sound[Sandman][ "berlin_cby_theresthehotel" ]		= "berlin_cby_theresthehotel";
	//Sandman: Overlord, we're at the target building! Any update on the girl?
	level.scr_sound[Sandman][ "berlin_cby_updateongirl" ]		= "berlin_cby_updateongirl";
	//Overlord: They're moving her to the third floor for extraction. You have zero time.
	level.scr_radio[ "berlin_hqr_zerotime" ]		= "berlin_hqr_zerotime";
	//Sandman: We're losing her! Go! Go!
	level.scr_sound[Sandman][ "berlin_cby_losingher" ]		= "berlin_cby_losingher";
	
	
//in hotel

	//Overlord: Metal Zero One, ISR shows they're extracting the girl now. Advise you stand down and head to an alternate LZ.
	level.scr_radio[ "berlin_hqr_standdown" ]		= "berlin_hqr_standdown";
	//Sandman: No!  We can make it!
	level.scr_sound[Sandman][ "berlin_cby_canmakeit" ]		= "berlin_cby_canmakeit";
	
	//hotel nags
	//Sandman: Head for the roof! 
	level.scr_sound[Sandman]["head_for_roof"] = "berlin_cby_headforroof";
	//Sandman: Get to the roof!!
	level.scr_sound[Sandman]["get_to_roof"] = "berlin_cby_gettoroof";
	//Sandman: Frost, this way!
	level.scr_sound[Sandman][ "berlin_cby_frostthisway" ]		= "berlin_cby_frostthisway";
	//Sandman: Let's go! Let's go!
	level.scr_sound[Sandman][ "berlin_cby_letsgoletsgo" ]		= "berlin_cby_letsgoletsgo";
	//Sandman: Go! Go! Go!
	level.scr_sound[Sandman][ "berlin_cby_gogogo3" ]		= "berlin_cby_gogogo3";
	//Sandman: Keep moving!
	level.scr_sound[Sandman][ "berlin_cby_keepmoving2" ]		= "berlin_cby_keepmoving2";
	//Sandman: Frost, stack up!
	level.scr_sound[Sandman][ "berlin_cby_stackup" ]		= "berlin_cby_stackup";
	//Sandman: Frost, hit the door!
	level.scr_sound[Sandman][ "berlin_cby_hitthedoor" ]		= "berlin_cby_hitthedoor";
	//Sandman: Up the stairs!
	level.scr_sound[Sandman][ "berlin_cby_upstairs" ]		= "berlin_cby_upstairs";
	//Sandman: She's behind the door! Move!
	level.scr_sound[Sandman][ "berlin_cby_behindthedoor" ]		= "berlin_cby_behindthedoor";
	
/* cut
//Grinch: I see her!
level.scr_sound[Grinch][ "berlin_rno_iseeher" ]		= "berlin_rno_iseeher";
*/
	
	
//reverse breach
	
	//Alena: Scream 1
	level.scr_sound[Alena][ "berlin_aln_scream1" ]		= "berlin_aln_scream1";
	//Alena: Help me!
	level.scr_sound[Alena][ "berlin_aln_helpme" ]		= "berlin_aln_helpme";
	//Alena: Scream 2
	level.scr_sound[Alena][ "berlin_aln_scream2" ]		= "berlin_aln_scream2";
	//Alena: Scream 3
	level.scr_sound[Alena][ "berlin_aln_scream3" ]		= "berlin_aln_scream3";
	//Alena: Help me!
	level.scr_sound[Alena][ "bln_daughter_scream_exit" ]		= "bln_daughter_scream_exit";
}

play_dialogue()
{
	thread berlin_intro_dialog();
	thread berlin_heli_ride_dialog();
	thread berlin_chopper_crash_dialog();
	thread berlin_aa_roof_clear_dialog();
	thread berlin_sniper_dialog();
	thread berlin_rappel_dialog();
	thread berlin_rappel_complete_dialog();
	thread berlin_clear_bridge_dialog();
	thread berlin_advance_pkway_dialog();
	thread berlin_building_collapse_dialog();
	thread berlin_traverse_building_dialog();
	thread berlin_emerge_dialog();
	thread berlin_last_stand_dialog();
	thread berlin_reverse_breach_hallway_dialog();
	thread berlin_reverse_breach_dialog();
}


berlin_intro_dialog()
{
	flag_wait( "is_intro" );
	berlin_shared_ambush_dialog();
	
	flag_set( "intro_dialogue_complete" );
	
	//Sandman: They're gone! Conventional forces are combat ineffective and getting overrun! This A.O. is lost!
	level.lone_star dialogue_queue("berlin_cby_aoislost");	
}

/*not using but could
berlin_intro_whiteout_dialog()
{
	flag_wait("intro_outro_full_white");
	
	//Pilot 1: Got targets in the killbox - missiles loose.
	radio_dialogue("berlin_plt1_killbox");
	
	//Pilot 2: Chalk 1 - customers on the ground. I'm out. Chalk 2 is in.
	radio_dialogue("berlin_plt2_imout");
	
	//Pilot 1: Hammer 6-4 established in off-set orbit. Minimum two minues out. Standing by for recall.
	radio_dialogue("berlin_plt1_standingby");
}
*/


berlin_heli_ride_dialog()
{
	//berlin_intro_whiteout_dialog();  //Taking out per audio.
	
	flag_wait("start_sandman_vo");
	
	//Little Bird Pilot: 30 seconds!
	radio_dialogue( "berlin_lbp_deltaboys" );
	
	//Grinch: Berlin's getting ripped apart down there.
	radio_dialogue( "berlin_rno_rippedapart" );
	
	flag_wait( "rpg_attacker_fires" );
	
	wait( 0.2 );
	//Grinch: RPG! Look out!
	level.essex dialogue_queue( "berlin_rno_rpglookout" );
	
	wait( 3 );
	
	//Sandman: Bird is down! Bird is down!
	level.lone_star dialogue_queue( "berlin_cby_birdisdown" );
	
	//Littlebird Pilot: Viper Five touching down at target.
	//radio_dialogue( "berlin_lbp_touchingdown" );
	
	//Littlebird Pilot: Metal One is on the deck.  Viper Five going in to holding pattern.
	radio_dialogue( "berlin_lbp_ondeck" );
}

berlin_chopper_crash_dialog()
{
	flag_wait("player_unloaded_from_intro_flight");
	
	thread aa_building_first_floor_clear_dialog( "vo_reached_second_level" );
	thread aa_building_second_floor_clear_dialog( "aa_building_obj_loc_3" );
	
	//Sandman: Go! Go! Go!	
	level.lone_star dialogue_queue( "go_go_go" );	
	
	wait( 2 );
	
	//Grinch: Contact!  Second floor!
	level.essex dialogue_queue( "berlin_rno_secondfloor2" );	
	
	wait( 6 );
	
	//Sandman: Head up!
	level.lone_star dialogue_queue( "berlin_cby_headup" );
	
	//SANDMAN: We need to get to the roof!
	level.lone_star dialogue_queue(	"berlin_cby_destroysam" );
	
	if( !flag( "aa_building_flank_right" ) )//start nagging if player doesn't go into the building
		thread aa_building_keep_moving_nag( "aa_building_flank_right" );

	flag_wait( "aa_building_flank_right" );
	
	wait( 3 );
	
	//SANDMAN: We need to get to the roof!
	level.lone_star dialogue_queue(	"berlin_cby_destroysam" );
	
	//SANDMAN: Frost, with me!	
	level.lone_star dialogue_queue( "frost_with_me" );	
	
	if( !flag( "aa_building_flank_left" ) )
		thread aa_building_keep_moving_nag( "aa_building_flank_left" );
	
	flag_wait( "aa_building_flank_left" );
	
	wait( 7.3 );
	
	level notify( "vo_reached_second_level" );
	
	//SANDMAN: Move!		
	level.lone_star dialogue_queue( "berlin_cby_move" );
	
	//GRINCH: Moving!
	level.essex dialogue_queue( "berlin_rno_moving" );	
	
	if( !flag( "aa_building_obj_loc_3" ) )
		thread aa_building_keep_moving_nag( "aa_building_obj_loc_3" );
	
	flag_wait( "aa_building_obj_loc_3" );//entering the stairwell
	
	//Sandman: Up the stairs!	
	level.lone_star dialogue_queue( "berlin_cby_upthestairs" );	
}

aa_building_first_floor_clear_dialog( endon_msg )
{
	if( isDefined( endon_msg ) )
	{
		level endon( endon_msg );
	}
	
	flag_wait( "vo_aa_first_floor_clear" );
	
	//Truck: Clear!
	level.truck dialogue_queue( "berlin_trk_clear" );
}

aa_building_second_floor_clear_dialog( endon_msg )
{
	if( isDefined( endon_msg ) )
	{
		level endon( endon_msg );
	}
	
	flag_wait( "vo_aa_second_floor_clear" );
	
	//Truck: Clear!
	level.truck dialogue_queue( "berlin_trk_clear2" );
	
	//Grinch: Rog'!
	level.essex dialogue_queue( "berlin_rno_rog" );
}

create_nag_prompt( how, line, who )
{
	foo = [];
	foo["how"] = how;
	foo["line"] = line;
	foo["who"] = who;
	return foo;	
}

generic_nag_loop( guy, prompt_arr, endon_msg, wait_min, wait_max, start_delay, flag_start )
{
	if( isarray( endon_msg ) )
	{
		foreach( msg in endon_msg )
		{
			level endon( msg );
		}
	}
	else
	{
		level endon( endon_msg );
	}
	
	if(isdefined(flag_start))
		flag_wait(flag_start);
	
	if(isdefined(start_delay))
		wait( start_delay );

	prompt_idx = 0;
	prompt_size = prompt_arr.size;
	
	while( 1 )
	{
		vo_info = undefined; //reset array
		vo_info = prompt_arr[prompt_idx];
		assert( isdefined( vo_info["how"] ) );
		assert( isdefined( vo_info["line"] ) );
		
		if( !isDefined( vo_info["who"] ) )
		{
			vo_info["who"] = guy;
		}

		choose_vo( vo_info["who"], vo_info["how"], vo_info["line"]);

		prompt_idx = get_next_prompt_idx( prompt_idx, prompt_size );
		wait( randomintrange( wait_min, wait_max ) );
	}
}

aa_building_keep_moving_nag( endon_msg )
{
	prompt_arr = [];
	prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_keepmoving2" ); //Sandman: Keep moving!
	prompt_arr[1] = create_nag_prompt("queue", "go_go_go" ); //Sandman: Go! Go! Go!
	prompt_arr[2] = create_nag_prompt("queue", "berlin_cby_waitingfor" ); //Sandman: Frost, what are you waiting for?
	
	generic_nag_loop( level.lone_star, prompt_arr, endon_msg, 16, 18, 3);
}

berlin_aa_roof_clear_dialog()
{
	level endon( "aa_building_level4_dead" );
	
	flag_wait("player_on_roof");
	
	//Sandman: Secure this area fast!
	level.lone_star dialogue_queue( "berlin_cby_visontarget" );
}

berlin_sniper_dialog()
{
	thread sniper_get_into_pos_nag();
	
	flag_wait("snipe_player_in_position");
	
	//Sandman: Granite 0-1, we're in position.
	radio_dialogue( "berlin_cby_inposition" );
	
	//Littlebird Pilot: Solid Copy, Zero One.  Will relay.
	radio_dialogue( "berlin_lbp_willrelay" );
	
	level.player sniper_rifle_pickup_nag();
	
	if( !flag( "sniper_hotel_roof_clear" ) )
	{
		thread sniper_wave_1_player_kills_dialog();
		thread sniper_clear_roof_top_nag();
	}
	
	flag_wait( "bravo_team_spawned" );
	
	//Littlebird Pilot: Granite Zero One, overwatch established.  
	radio_dialogue( "berlin_lbp_overwatch" );
	
	//Granite Leader: Copy that.  We're inbound.
	radio_dialogue( "berlin_grl_breaching" );
	wait( .5 );
	
	//Apache Gunner: Got targets in the LZ - missiles loose.
	radio_dialogue( "berlin_apg_missilesloose" );
	
	flag_wait( "sniper_delta_support_squad_unloaded" );

	//Little Bird Pilot: Granite Team is on the deck now.
	radio_dialogue( "berlin_lbp_ondecknow" );
	
	level.in_monitor_kills_dialogue = false; //var to check to prevent overlapping lines
	thread sniper_kills_dialog();
	
	wait( 2 );
	
	//Granite Leader: We're taking fire!
	radio_dialogue("berlin_grl_takingfire");
	
	//Truck: Granite's got company.  Doorway on the left.
	level.truck dialogue_queue( "berlin_trk_gotcompany" );
	
	wait( 1 );
	
	//Sandman: Keep em covered.
	level.lone_star dialogue_queue( "berlin_cby_giveemcover" );
	
	wait( 1 );
	
	if( !flag( "snipe_hotel_roof_complete" ) )
	{
		level.player sniper_rifle_pickup_nag();
	}
	
	if( !flag( "snipe_hotel_roof_complete" ) )
	{	
		thread sniper_wave_2_player_kills_dialog();
		thread sniper_rooftop_wave_2_nag();
	}
	
	flag_wait("tanks_scripted_fire");
	
	//Truck: T90's on the road!
	level.truck dialogue_queue("berlin_brvl_btrcrawl");
	
	wait( 1 );
	
	//Sandman: Overlord, we have Russian tanks firing on Granite's position.  Requesting fire mission!
	level.lone_star dialogue_queue( "berlin_cby_firemission" );
	
	//Overlord: Solid copy, Zero-One, the air corridor is clear for our A-10s to commence gun-runs.
	radio_dialogue("race_track_clear");
	
	//A10 Pilot: Metal Zero-One, this is Valkyrie Two-Six.  In the airspace and at your service.  Standing by for you to laze the first target.
	radio_dialogue("berlin_plt_standingby");
	
	flag_set("paint_targets_vo");	
	
	loc = getstruct( "player_looking_at_hotel_loc", "targetname" );
	if( !flag( "sniper_tanks_one_dead" ) )
	{
		thread sniper_ignore_tank_nag( "sniper_tanks_one_dead", loc );
	}
	
	flag_wait("sniper_tanks_one_dead");
	wait( 4 );
	
	//Sandman: Direct hit!
	level.lone_star dialogue_queue( "berlin_cby_directhit2" );
	
	if( !flag( "parkway_tank_dead" ) )
	{
		//Sandman: Two more tanks approaching! Take 'em out!
		level.lone_star dialogue_queue("berlin_cby_twomoretanks");
	}
	
	if( !flag( "parkway_tank_dead" ) )
	{
		thread sniper_ignore_tanks_nag( "parkway_tank_dead", loc );
	}
	
	flag_wait( "parkway_tank_dead" );
	
	wait( 3.25 );
	
	//Truck: Thanks for the guns, Valkyrie.  We'll take it from here.
	radio_dialogue( "berlin_trk_takeit" );
	
	wait( 1 );

	//Sandman: All hard targets neutralized! Your flank is clear.
	level.lone_star dialogue_queue( "berlin_cby_flankclear" );
	
	//Granite Leader: Roger, commencing assault!
	radio_dialogue("berlin_grl_assault");
	
	aud_send_msg("prime_granite_breach");//give priming a chance to prime
	
	flag_wait( "bravo_team_reached_lower_rooftop" );
	
	//Sandman: Frost, maintain eyes on the building.
	level.lone_star dialogue_queue( "berlin_cby_maintaineyes" );
		
	if( !flag( "player_looking_at_granite" ) )
	{
		thread sniper_granite_death_scene_nag();
	}
	
	flag_wait( "player_looking_at_granite" );
	
	//Granite Leader: We're going in!
	radio_dialogue( "berlin_grl_goingin" );
	
	/*** Begin Granite Team Death Radiomatic ***/
	
	flag_wait("delta_support_breach_kick");
	
	aud_send_msg("play_granite_breach");
	
	wait(3.5);
	level.lone_star dialogue_queue( "berlin_cby_eyesondaughter" );
	
	wait(5.2);
	aud_send_msg("prime_granite_explosion");
	wait(1.0);
	flag_set( "sniper_delta_support_guys_dead" );
	aud_send_msg("play_granite_explosion");
	
	wait( 4 );	
	
	//Sandman: Granite! Granite!
	level.lone_star dialogue_queue( "berlin_cby_granitegranite" );
	
	wait( 1 );
	
	//leaving this line out since the delivery is un-emotional, and it seems out of place.
	//Grinch: I don't see anything movin' down there.
	//level.essex dialogue_queue( "berlin_rno_anythingmoving" );
	
	//Truck: They're gone.
	level.truck dialogue_queue( "berlin_trk_damn" );
	
	//Grinch: What the hell!?
	level.essex dialogue_queue( "berlin_rno_eaglesdown" );
	
	wait( .5 );
	//Sandman: Overlord, Granite Team is down.  I repeat, eagles down.  We're going after Athena.
	level.lone_star dialogue_queue( "berlin_cby_pcteam" );
	
	flag_set( "sniper_vo_complete" );
	
	//Overlord: Affirmative, Sandman.  Link up with the German tank column south of your position and proceed to the target building, over.
	radio_dialogue( "berlin_hqr_linkup" );
	
	//Sandman: Solid copy.  Sandman out.
	level.lone_star dialogue_queue("berlin_cby_sandmanout");
	
	flag_set( "begin_rappel_vo" );
}

sniper_granite_death_scene_nag()
{
	prompt_arr = [];
	prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_eyesongranite" ); //Sandman: Frost, keep your eyes on Granite!
	prompt_arr[1] = create_nag_prompt("queue", "berlin_cby_maintaineyes" ); //Sandman: Frost, maintain eyes on the building.
		
	generic_nag_loop( level.lone_star, prompt_arr, "player_looking_at_granite", 7, 9, 5);
}

sniper_rooftop_wave_2_nag()
{
	level endon("snipe_hotel_roof_complete");
	
	wait( 5 );
	
	prompt = 0;
	prompt_size = 2;
	vo_line = "berlin_trk_guysonroof";
	dude = level.truck;
	
	while( 1 )
	{
		switch( prompt )
		{
			case 0: //Truck: Still got guys on the roof - building across the street!
				vo_line = "berlin_trk_guysonroof";
				dude = level.truck;		
				break;
			case 1: //Grinch: Hostiles on the roof!
				vo_line = "berlin_rno_ontheroof";
				dude = level.essex;
				break;
		}
		
		dude thread dialogue_queue_no_overlap( vo_line );
		
		prompt = get_next_prompt_idx( prompt, prompt_size );
		wait( randomIntRange( 13,15 ) );
	}
}

sniper_wave_1_player_kills_dialog()
{	
	level endon("bravo_team_spawned");
	level endon("sniper_hotel_roof_clear");
	
	total_kills = level.total_rooftop_patrollers;
	
	while( 1 )
	{
		level waittill( "snipe_hotel_roof_player_kill" );
		wait( .05 );
		if(level.player_sniper_kills == 1)
		{
			//Sandman: Good hit.
			level.lone_star dialogue_queue("berlin_cby_goodhit2");
		}
		else if(level.player_sniper_kills == total_kills)
		{
			//Sandman: Good kill.
			level.lone_star dialogue_queue("goodkill");
		}
	}
}

sniper_wave_2_player_kills_dialog()
{
	level endon("snipe_hotel_roof_complete");
	
	first_line_played = false;
	total_kills = level.total_roof_kills_needed;
	
	while( 1 )
	{
		level waittill( "snipe_hotel_roof_player_kill" );
		wait( .05 );
		if( level.sniper_kills >= (level.total_roof_kills_needed - level.total_upperroof_enemies + 1) && !first_line_played  )
		{
			//Sandman: Good effects on target.
			level.lone_star thread dialogue_queue_no_overlap("berlin_cby_goodeffect");
			first_line_played = true;
		}
		else if( level.sniper_kills == (total_kills - 3) )
		{
			//Sandman: Good hit.
			level.lone_star thread dialogue_queue_no_overlap("berlin_cby_goodhit2");
		}
		else if( level.sniper_kills == total_kills)
		{
			//Sandman: Good kill.
			level.lone_star thread dialogue_queue_no_overlap("goodkill");
		}
	}	
}

dialogue_queue_no_overlap( line )
{
	if( level.in_monitor_kills_dialogue )
	{
		while( level.in_monitor_kills_dialogue )
		{
			wait( .1 );
		}
	}
	level.in_monitor_kills_dialogue = true;
	self dialogue_queue( line );
	level.in_monitor_kills_dialogue = false;
}

sniper_kills_dialog()
{
	level endon( "paint_targets_vo" );
	
	while(1)
	{	
		level waittill("snipe_hotel_roof_death");
		wait(.05);
		if( level.sniper_kills == (level.total_roof_kills_needed - 4) )
		{
			//Sandman: Four more.
			level.lone_star thread dialogue_queue_no_overlap( "berlin_cby_4enemies" );
		}
		else if( level.sniper_kills == level.total_roof_kills_needed )
		{
			//Sandman: You're clear, Granite.  Keep movin.
			level.lone_star thread dialogue_queue_no_overlap( "berlin_cby_areaclear" );
		}
	}
}

sniper_clear_roof_top_nag()
{
	endon_arr = [];
	endon_arr[0] = "sniper_hotel_roof_clear";
	endon_arr[1] = "bravo_team_spawned";
	
	foreach( msg in endon_arr )
	{
		level endon( msg );
	}
	
	//Grinch: Hostiles on the roof!
	level.essex dialogue_queue( "berlin_rno_ontheroof" );
	
	prompt_arr = [];
	prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_takecare" ); //Sandman: Take care of em!
	prompt_arr[1] = create_nag_prompt("queue", "berlin_cby_canland" ); //Sandman: Frost, clear that roof so Granite can land!
	prompt_arr[2] = create_nag_prompt("queue", "berlin_rno_ontheroof", level.essex ); //Grinch: Hostiles on the roof!
	
	generic_nag_loop( level.lone_star, prompt_arr, endon_arr, 15, 17, 16 );
}

sniper_get_into_pos_nag()
{
	level endon( "snipe_player_in_position" );
	flag_wait( "aa_building_level4_dead" );
	
	wait( 2 );
	
	//Sandman: Strongpoint the roof and get eyes on the hotel across the street!
	level.lone_star dialogue_queue( "berlin_cby_strongpoint" );
	
	wait( 2 );
	
	prompt_arr = [];
	prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_overwatch" ); //Sandman: Frost, get on overwatch!
	prompt_arr[1] = create_nag_prompt("queue", "berlin_cby_wastingtime" ); //Sandman: You're wasting time, Frost, let's go!
	
	generic_nag_loop( level.lone_star, prompt_arr, "snipe_player_in_position", 15, 17 );
}

sniper_ignore_tank_nag( endon_msg, loc )
{
	if( isDefined( endon_msg ) )
	{
		level endon ( endon_msg );
	}
	
	wait( 8 );
	
	prompt = 0;
	prompt_size = 3;
	how = "";
	
	while( 1 )
	{
		vo_line = "paint_targets";
		switch( prompt )
		{
			case 0: 
				//Sandman: Stop looking at the building, Frost! Eyes on the street!
				if ( within_fov( level.player.origin, level.player.angles, loc.origin, 0.766 ) )
				{
					how = "queue";
					vo_line = "berlin_cby_stoplooking";		
				}
				//Sandman: Frost, hit the tank on the street!
				else
				{
					how = "queue";
					vo_line = "berlin_cby_tankonstreet";		
				}
				break;
			case 1: //Sandman: Frost - paint targets for the A-10.
				how = "queue";
				vo_line = "paint_targets";
				break;
			case 2: //Sandman: Frost, the tank's on the street below us!
				how = "queue";
				vo_line = "berlin_cby_belowus";		
				break;
		}
				
		choose_vo( level.lone_star, how, vo_line );
		
		prompt = get_next_prompt_idx( prompt, prompt_size );
		wait( randomIntRange( 10, 13 ) );
	}
}

choose_vo( guy, how, line )
{
	switch( how )
	{
		case "radio":
			radio_dialogue( line );
			break;
		case "hint":
			IPrintlnBold( line );
			break;
		case "queue":
			assert( isdefined( guy ) );
			assert( isai( guy ) );
			assert( isalive( guy ) );
			guy dialogue_queue( line );
			break;
		default:
			assertEx( 0, "unknown vo play type");
			break;
	}
}

get_next_prompt_idx( prompt, prompt_size )
{
	prompt++;
	return prompt % prompt_size;
}

sniper_ignore_tanks_nag( endon_msg, loc )
{
	if( isDefined( endon_msg ) )
	{
		level endon ( endon_msg );
	}
	
	wait( 10 );
	
	how = "";
	prompt = 0;
	prompt_size = 2;
	
	while( 1 )
	{
		vo_line = "berlin_cby_waitingfor";
		switch( prompt )
		{
			case 0: //Sandman: Frost, what are you waiting for?
				how = "queue";
				vo_line = "berlin_cby_waitingfor";
				break;
			case 1: 
				how = "queue";
				if ( within_fov( level.player.origin, level.player.angles, loc.origin, 0.766 ) )
				{
					//Sandman: Stop looking at the building, Frost! Eyes on the street!
					vo_line = "berlin_cby_stoplooking";
				}

				else
				{
					//Sandman: Target the tanks on the street!
					vo_line = "berlin_cby_targettanks";		
				}
			break;				
		}
		
		choose_vo( level.lone_star, how, vo_line );			
		
		prompt = get_next_prompt_idx( prompt, prompt_size );
		wait( randomIntRange( 10, 13 ) );
	}
}

sniper_rifle_pickup_nag()
{
	assert(isplayer(self));
	cur_weapon_list = self GetWeaponsListPrimaries();
	nag = true;
	foreach(weap in cur_weapon_list)
	{
		if(weap == level.sniper_rifle)
		{
			nag = false; //dont nag
			break;
		}
	}
	
	if(nag)
	{
		//Sandman: Frost, grab a sniper rifle!
		level.lone_star dialogue_queue( "berlin_cby_grabrifle" );
	}
	else if(self GetCurrentWeapon() != level.sniper_rifle)
	{
		//Sandman: Frost, use your sniper rifle!
		level.lone_star dialogue_queue( "berlin_cby_userifle" );
	}
}

/********************
***ROOF TOP SNIPE END*
*********************/

berlin_rappel_dialog()
{
	flag_wait( "begin_rappel_vo" );
	aud_send_msg( "mus_sniper_complete" );
	
	endon_arr = [];
	endon_arr[0] = "player_near_rappel";
	endon_arr[1] = "ai_near_rappel";
	
	if( !flag( endon_arr[0] ) && !flag( endon_arr[1] ) )
	{
		prompt_arr_1 = [];
		prompt_arr_1[0] = create_nag_prompt("queue", "berlin_cby_frostthisway" );//Sandman: Frost, this way!
		prompt_arr_1[0] = create_nag_prompt("queue", "berlin_cby_overhere" );//Sandman: Frost, over here!
		prompt_arr_1[1] = create_nag_prompt("queue", "berlin_cby_letsmove2" );//Sandman: Frost, let's move!
		prompt_arr_1[2] = create_nag_prompt("queue", "berlin_cby_thisway2" );//Sandman: This way!
		thread generic_nag_loop( level.lone_star, prompt_arr_1, endon_arr, 8, 10, 4 );
	}
	
	flag_wait_either( "ai_near_rappel", "player_near_rappel" );
	
	endon_msg = "player_rappels";
	
	if( !flag( endon_msg ) )
	{
		prompt_arr_2 = [];
		prompt_arr_2[0] = create_nag_prompt("queue", "berlin_cby_hookup" );//Sandman: Frost, hook up. We need to hit the street.
		prompt_arr_2[1] = create_nag_prompt("queue", "berlin_cby_hookup2" );//Sandman: Hook up.
		prompt_arr_2[2] = create_nag_prompt("queue", "berlin_cby_letsmove2" );//Sandman: Frost, let's move!
		thread generic_nag_loop( level.lone_star, prompt_arr_2, endon_msg, 8, 10 );
	}
}

berlin_rappel_complete_dialog()
{
	flag_wait( "vo_check_wounded_soldier" );
	
	//Truck: Got some casualties here.
	level.truck dialogue_queue( "berlin_trk_casualties" );
	//Sandman: Grab their patches and tags.
	level.lone_star dialogue_queue( "berlin_cby_patchestags" );
	//Truck: Rog'.
	level.truck dialogue_queue( "berlin_trk_rog" );
	
	alley_downed_apache_dialog( "start_bridge_battle" ); //don't thread
	
	flag_set( "vo_downed_apache_complete" );
}

alley_downed_apache_dialog( endon_msg )
{
	level endon( endon_msg );
	
	//Truck: It's Onyx Team.
	level.truck dialogue_queue( "berlin_trk_onyxteam" );

	//Truck: Overlord, this is Metal Zero Two.  I need evac for three casualties.  Coordinates follow: Seven Romeo Eight Five One.
	radio_dialogue( "berlin_trk_needevac" );

	//Overlord: Copy that, Zero Two.  We'll send in a SAR brid for evac.
	radio_dialogue( "berlin_hqr_sarbird" );

	//Grinch: Not a good day to be Delta…
	level.essex dialogue_queue( "berlin_rno_notagoodday" );
}

berlin_clear_bridge_dialog()
{
	flag_wait( "start_bridge_battle" );
	flag_wait( "vo_downed_apache_complete" );
	wait( 3 );
	
	if(!flag("rus_all_tanks_dead"))
	{
		//German Tank Commander: American Team - we have Russian armor firing on the bridge.  We need you to take out their tank!
		radio_dialogue("berlin_gtc_pinneddown");
	}
	
	if(!flag("rus_all_tanks_dead"))
	{
		//Truck: They got a T90 dug in - straight ahead!
		level.truck dialogue_queue( "berlin_trk_dugin" );
	}
	
	if(!flag("rus_all_tanks_dead"))
	{
		//Sandman: Frost - take care of it!  We'll cover you!
		level.lone_star dialogue_queue( "berlin_cby_takecareofit" );
	}
	
	wait( .5 );
	
	//only one tank now
	if(!flag("rus_all_tanks_dead"))
	{
		thread bridge_kill_rus_tank_nag( "rus_all_tanks_dead" );
		thread bridge_tanks_moving_dialog("rus_all_tanks_dead");//waits for flag ("usa_tanks_starting_on_bridge");
		thread bridge_deadtank_death_dialog( "rus_all_tanks_dead" );//waits for flag ( "bridge_deadtank_dead" );
	}
	
	flag_wait( "rus_all_tanks_dead" );
	wait( 1 );
	
	//Sandman: Direct hit.
	level.lone_star dialogue_queue("berlin_cby_goodhit2");
	
	wait( 2 );
	
	//Sandman: Let's go! Move out!
	level.lone_star dialogue_queue( "berlin_cby_moveout" );	
	
	if( !flag( "usa_tanks_start_parkway" ) )
	{
		thread bridge_player_stays_back_nag( "usa_tanks_start_parkway" ); // add nag if player stays at the back of parkway
	}
}

bridge_deadtank_death_dialog( endon_msg )
{
	level endon( endon_msg );
	
	flag_wait( "bridge_deadtank_dead" );
	
	//German Tank Commander: We're getting hit hard!  We can't take much more!
	radio_dialogue( "berlin_gtc_hithard" );
}

bridge_kill_rus_tank_nag( endon_msg )
{
	level endon( endon_msg );
	
	prompt_arr = [];
	prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_grabrpg" ); //Sandman: Grab an RPG and take out that tank!
	prompt_arr[1] = create_nag_prompt("queue", "berlin_rno_killthatthing", level.essex); //Grinch: You gonna kill that thing or what?!
	prompt_arr[2] = create_nag_prompt("queue", "berlin_cby_takeouttank" ); //Sandman: Take out that tank with an RPG!
	prompt_arr[3] = create_nag_prompt("queue", "berlin_cby_gettogirl" ); //Sandman: Take out that tank!  We need to get to the girl!
	
	generic_nag_loop( level.lone_star, prompt_arr, endon_msg, 10, 13, 1 );
}

bridge_player_stays_back_nag( endon_msg )
{
	level endon( endon_msg );
	
	wait( 16 );

	prompt = 0;
	prompt_size = 3;
	vo_line = "move_up";
	
	while( 1 )
	{
		switch( prompt )
		{
			case 0: //Sandman: Move up!
				vo_line = "move_up";
				break;
			case 1: //Sandman: Push forward!
				vo_line = "push_forward";	
				break;
			case 2: //Sandman: Contact, up ahead!
				vo_line = "berlin_cby_contactahead";
				break;
		}
		
		level.lone_star dialogue_queue( vo_line );
		
		prompt = get_next_prompt_idx( prompt, prompt_size );
		wait( randomIntRange( 15, 16 ) );
	}
}

bridge_tanks_moving_dialog( msg )
{
	assert( !flag( msg ) );
	level endon( msg );

	flag_wait("usa_tanks_starting_on_bridge");
	
	//Our armor is moving.  Hurry!
	level.lone_star dialogue_queue("berlin_cby_armormoving");
}

berlin_advance_pkway_dialog()
{
	flag_wait( "usa_tanks_start_parkway" );
	
	thread parkway_bank_dialog();
	thread parkway_office_dialog();
	thread parkway_tank_scripted_fire_dialog();
	
	//German Tank Commander: We're clear. Advancing now!
	radio_dialogue( "berlin_gtc_advancing" );
	
	thread parkway_player_stays_back_nag( "player_interacting_with_wounded_lonestar" ); // Sandman nag that plays through parkway
	
	flag_wait( "vo_move_up" );//trig in radiant
	//German Tank Commander: Straight ahead!
	radio_dialogue( "berlin_gtc_straightahead" );
	
	flag_wait( "vo_push_forward" );//trig in radiant
	//Sandman: Push forward!
	level.lone_star dialogue_queue( "push_forward" );
	
	flag_wait( "vo_lay_down_fire" );//trig in radiant
	//Sandman: We're almost there!  Let's go!  C'mon!
	level.lone_star dialogue_queue( "berlin_cby_almostthere" );
	
	flag_wait( "vo_press_the_attack" );//trig in radiant
	//Sandman: They're falling back - press the attack!
	level.lone_star dialogue_queue( "press_attack" );
}

parkway_bank_dialog()
{
	flag_wait("parkway_player_near_bank");
	
	//German Tank Commander: Acquiring targets by the bank!
	radio_dialogue( "berlin_gtc_acquiring" );
	
	wait( 1 );
	
	//Sandman: They're in the bank!  Right side!
	level.lone_star dialogue_queue( "inside_bank" );
	
	flag_wait( "bridge_bradleys_move_up" );//this comes from radiant on a vehicle node
	
	//German Tank Commander: More targets on the right!
	radio_dialogue( "berlin_gtc_moretargets" );
}

parkway_office_dialog()
{
	flag_wait( "vo_parkway_near_office_building" );//this comes from radiant on a vehicle node
	
	//German Tank Commander: Left!  Twenty Degrees!
	radio_dialogue( "berlin_gtc_left20degrees" );
	
	wait( 2 );
	
	//German Tank Commander: Multiple targets by the office building! Engaging!
	radio_dialogue( "berlin_gtc_office" );
}

parkway_tank_scripted_fire_dialog( endon_msg )
{
	if( isDefined( endon_msg ) )
	{
		level endon( endon_msg );
	}
	
	flag_wait( "usa_tank2_in_pos" );
	flag_wait( "parkway_tank_shot" );
	
	//German Tank Commander: Firing!
	radio_dialogue( "berlin_gtc_firing" );
}

parkway_player_stays_back_nag( endon_msg )
{
	level endon( endon_msg );
	
	wait( 2 );

	prompt = 0;
	prompt_size = 4;
	vo_line = "berlin_cby_followtanks";
	cover_line_played = false;
	
	while( 1 )
	{
		switch( prompt )
		{
			case 0: //Sandman: Follow those tanks. Stay close till we reach the hotel!
				vo_line = "berlin_cby_followtanks";
				break;
			case 1: //Sandman: Keep moving with the tanks!  Use 'em for cover!
				vo_line = "berlin_cby_useem";
				cover_line_played = true; //only play this line once
				break;
			case 2: //Sandman: Move up!
				vo_line = "move_up";
				break;
			case 3: //Sandman: Contact, up ahead!
				vo_line = "berlin_cby_contactahead";
				break;
		}
		
		level.lone_star dialogue_queue( vo_line );
		
		prompt = get_next_prompt_idx( prompt, prompt_size );
		if( prompt == 1 && cover_line_played )
		{
			prompt = get_next_prompt_idx( prompt, prompt_size );
		}
		wait( randomIntRange( 15, 16 ) );
	}
}

berlin_building_collapse_dialog()
{
	flag_wait( "parkway_retreat_start" );
	aud_send_msg( "bln_ivan_falling_back" );
	
	berlin_shared_ambush_dialog();
	
	//Sandman: They're gone! Conventional forces are combat ineffective and getting overrun! This A.O. is lost!
	level.lone_star dialogue_queue("berlin_cby_aoislost");
	
	//Overlord: Missed your last, Zero One - say again.
	radio_dialogue( "berlin_hqr_missedyourlast" );
	
	//Sandman: They dropped a damn building on us!
	level.lone_star dialogue_queue( "berlin_cby_damnbuilding" );	
	
	//Overlord: Roger - advise immediate pull back to extraction point.
	radio_dialogue( "berlin_hqr_pullback" );

	//Sandman: Negative Overlord - we are going for the girl. Her beacon is still active.
	level.lone_star dialogue_queue( "berlin_cby_goingforgirl" );	
	
	//Overlord: You'll need to move fast - Berlin is falling. We'll maintain ISR, over.
	radio_dialogue( "berlin_hqr_berlinfalling" );
	
	flag_set( "vo_building_collapse_complete" );
}

berlin_traverse_building_dialog()
{
	flag_wait( 	"ceiling_collapse_complete" );
	aud_send_msg( "mus_ceiling_collapse_complete" );
	
	flag_wait( "vo_building_collapse_complete" );
	
	//Sandman: Through here.
	level.lone_star dialogue_queue( "berlin_cby_throughhere" );
	wait( 5.5 );
	
	//Truck: They must have rigged the building to blow if our tanks got this far…
	level.truck dialogue_queue( "berlin_trk_rigged" );
	
	//Grinch: Man…this is some bullshit.
	level.essex dialogue_queue( "berlin_rno_thisissome" );
	
	level.lone_star waittill( "sliding_complete" );
	
	//Grinch: This thing's gonna come down on us any second.
	level.essex dialogue_queue( "berlin_rno_comedown" );	

	//Truck: Just keep moving.
	level.truck dialogue_queue( "berlin_trk_keepmoving" );
	
	flag_wait( "aud_ibeam_fall_complete" );//comes from audio
	wait( 5 );
	
	//Truck: Easy, easy.
	if( !flag( "truck_at_emerge_door" ) )
	{
		level.truck dialogue_queue( "berlin_trk_easy" );
	}

	flag_wait( "lone_star_at_emerge_door" );//comes from monitor dudes at emerge door function. waits for lone star to get to the door
	flag_wait( "building_traverse_end" );//comes from the player in radiant
	
	//Truck: Got a doorway over here.
	level.truck dialogue_queue( "berlin_trk_doorway" );	
	
	//Sandman: I'm on it.
	level.lone_star dialogue_queue( "berlin_cby_imonit" );	
}

berlin_shared_ambush_dialog()
{
	flag_wait("ambush_after_building_collapse_start");
	wait( 6.0 );
	
	//hack for 2 vo lines during one anim but only one line has facial associated with it ( this one does not).
	dummy = spawn( "script_origin", level.lone_star.origin );
	dummy.animname = "lone_star";
	
	//Sandman: It’s an ambush! We gotta get the hell out of the kill zone! Move! Move! Move!
	dummy dialogue_queue("an_ambush");
	
	/*this is handled in berlin_code.gsc as facial anim 
	//Sandman: Head for the building!
	level.lone_star dialogue_queue("head_for_building");
	*/
	
	flag_wait( "intro_lone_star_facial_anim_complete" );
	//wait( 1 );
	
	//Overlord: Metal 0-1, we've lost contact with the German division commander. What's the status on the ground?
	radio_dialogue( "berlin_hqr_lostcontact" );
}

berlin_emerge_dialog()
{
	level.emerge_hotel_nag_played = false;
	
	flag_wait( "emerge_door_open" );
	
	if( level.emerge_hotel_nag_played == false )
	{
		//Sandman: There’s the hotel!
		level.lone_star dialogue_queue( "berlin_cby_theresthehotel" );
		level.emerge_hotel_nag_played = true;
	}
	
	aud_send_msg( "mus_emerge_door_open" );
	
	flag_wait_either( "emerge_dudes_dead", "start_last_stand" );
	
	//Sandman: Overlord, we're at the target building! Any update on the girl?
	level.lone_star dialogue_queue( "berlin_cby_updateongirl" );

	//Overlord: They're moving her to the third floor for extraction. You have zero time.
	radio_dialogue( "berlin_hqr_zerotime" );
	
	//Sandman: We're losing her! Go! Go!
	level.lone_star dialogue_queue( "berlin_cby_losingher" );
	
	thread emerge_hotel_nag();
	
	flag_set( "emerge_dialogue_done" );
}

emerge_hotel_nag()
{
	flag_wait("vo_theres_the_hotel");
	wait( 2.5 );
	//COWBOY (CONT’D) There’s the hotel!
	if(!flag("emerge_hotel_in_view") && level.emerge_hotel_nag_played == false )
	{
		level.lone_star dialogue_queue( "berlin_cby_theresthehotel" );
		level.emerge_hotel_nag_played = true;
	}
}

berlin_last_stand_dialog()
{
	flag_wait("start_last_stand");
	
	//setup for dialog to play if enemies are in the building
	//thread defend_enemies_in_building();
	//thread defend_enemies_behind_player();
	//thread defend_monitor_player_outside();

	flag_wait( "emerge_dialogue_done" );
	flag_wait( "last_stand_get_to_roof" );
	
	//Sandman: Head for the roof! 
	level.lone_star dialogue_queue("head_for_roof");
	
	thread last_stand_get_to_roof_nag();
	
	flag_wait( "door_hotel_stairs_1_open" );
	
	//Sandman: Up the stairs!
	level.lone_star dialogue_queue( "berlin_cby_upstairs" );
	
	//Sandman: Get to the roof!!
	level.lone_star dialogue_queue( "get_to_roof" );
	
	//Overlord: Metal Zero One, ISR shows they're extracting the girl now. Advise you stand down and head to an alternate LZ.
	radio_dialogue( "berlin_hqr_standdown" );
	
	//Sandman: No!  We can make it!
	level.lone_star dialogue_queue( "berlin_cby_canmakeit" );
	
	thread last_stand_stairwell_nag();
	
	flag_wait("player_top_of_hotel_stairwell");
}

last_stand_get_to_roof_nag()
{
	prompt_arr = [];
	prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_letsgoletsgo" ); //Sandman: Let's go! Let's go!
	prompt_arr[1] = create_nag_prompt("queue", "head_for_roof" ); //Sandman: Head for the roof!
	
	generic_nag_loop( level.lone_star, prompt_arr, "door_hotel_stairs_1_open", 13, 15, 16);	
}

last_stand_stairwell_nag()
{
	prompt_arr = [];
	prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_frostthisway" ); //Sandman: Frost, this way!
	prompt_arr[1] = create_nag_prompt("queue", "head_for_roof" ); //Sandman: Head for the roof!
	prompt_arr[2] = create_nag_prompt("queue", "berlin_cby_letsgoletsgo" ); //Sandman: Let's go! Let's go!
	prompt_arr[3] = create_nag_prompt("queue", "berlin_cby_gogogo3" ); //Sandman: Go! Go! Go!
	prompt_arr[4] = create_nag_prompt("queue", "berlin_cby_keepmoving2" ); //Sandman: Keep moving!	
	
	generic_nag_loop( level.lone_star, prompt_arr, "player_top_of_hotel_stairwell", 8, 10, 2);
}

reverse_breach_hall_nag()
{
	prompt_arr = [];
	prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_stackup" ); //Sandman: Frost, stack up!
	prompt_arr[1] = create_nag_prompt("queue", "berlin_cby_hitthedoor" ); //Sandman: Frost, hit the door!
	prompt_arr[2] = create_nag_prompt("queue", "berlin_cby_frostthisway" ); //Sandman: Frost, this way!
		
	generic_nag_loop( level.lone_star, prompt_arr, "reverse_breach_start", 8, 10, 2, "exfil_hallway_dudes_dead");
}

berlin_reverse_breach_hallway_dialog()
{
	flag_wait("player_top_of_hotel_stairwell");
	
	level.alena dialogue_queue("berlin_aln_scream1");
	
	//Sandman: She's behind the door! Move!
	level.lone_star dialogue_queue( "berlin_cby_behindthedoor" );
	
	thread reverse_breach_hall_nag();
	
	flag_wait( "exfil_hallway_dudes_dead" );
	level.alena dialogue_queue("berlin_aln_scream2");
}

berlin_reverse_breach_dialog()
{	
	flag_wait("reverse_breach_complete");
	wait( .5 );
	level.alena dialogue_queue("berlin_aln_scream3");
	
	flag_wait( "reverse_breach_getup_slowmo_start" );
	level.alena dialogue_queue("berlin_aln_helpme");
	
	flag_wait( "reverse_breach_player_back_in_business" );
	
	wait( 4.5 );
	
	flag_set( "reverse_breach_ending_vo_complete" );
}
