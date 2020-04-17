
#include maps\_utility;
main()
{
     	ent = maps\_utility::createOneshotEffect("siena_horsetrack_dust");
     	ent.v["origin"] = (-754.916,-3763.75,-27.174);
     	ent.v["angles"] = (270,78.475,1.52504);
     	ent.v["fxid"] = "siena_horsetrack_dust";
     	ent.v["delay"] = -15;
 
     	ent = maps\_utility::createOneshotEffect("siena_collapse_aftermath1");
     	ent.v["origin"] = (-503.381,-378.786,141.158);
     	ent.v["angles"] = (270,4.80168,3.19828);
     	ent.v["fxid"] = "siena_collapse_aftermath1";
     	ent.v["delay"] = -15;
 
     	ent = maps\_utility::createLoopEffect("siena_taillight01");
     	ent.v["origin"] = (-637.701,-244.943,224.125);
     	ent.v["angles"] = (285.827,341.799,-10.8635);
     	ent.v["fxid"] = "siena_taillight01";
     	ent.v["delay"] = 0.8;
     	ent.v["targetname"] = "fx_car_alarm";
 
     	ent = maps\_utility::createLoopEffect("siena_taillight01");
     	ent.v["origin"] = (-594.318,-202.32,230.11);
     	ent.v["angles"] = (285.827,341.799,-10.8635);
     	ent.v["fxid"] = "siena_taillight01";
     	ent.v["delay"] = 0.8;
     	ent.v["targetname"] = "fx_car_alarm";
 
     	ent = maps\_utility::createLoopEffect("siena_headlight01");
     	ent.v["origin"] = (-504.672,-362.208,136.55);
     	ent.v["angles"] = (0,320,0);
     	ent.v["fxid"] = "siena_headlight01";
     	ent.v["delay"] = 0.8;
     	ent.v["targetname"] = "fx_car_alarm";
 
     	ent = maps\_utility::createLoopEffect("siena_headlight01");
     	ent.v["origin"] = (-463.491,-318.615,143.364);
     	ent.v["angles"] = (0,320,0);
     	ent.v["fxid"] = "siena_headlight01";
     	ent.v["delay"] = 0.8;
     	ent.v["targetname"] = "fx_car_alarm";
 
     	
     	
     	
     	
     	
 
     	ent = maps\_utility::createOneshotEffect("siena_room_dust2");
     	ent.v["origin"] = (-8385.39,-2773.33,508.125);
     	ent.v["angles"] = (270,0,0);
     	ent.v["fxid"] = "siena_room_dust2";
     	ent.v["delay"] = -15;
		ent.v["targetname"] = "fx_mitchell_fight";
 
     	ent = maps\_utility::createOneshotEffect("siena_bossfight_wood");
     	ent.v["origin"] = (-8232.5,-2969.67,979.859);
     	ent.v["angles"] = (270,63.9403,-107.94);
     	ent.v["fxid"] = "siena_bossfight_wood";
     	ent.v["delay"] = -15;
     	ent.v["targetname"] = "fx_boss_wood";
 
     	ent = maps\_utility::createOneshotEffect("siena_tower_hit1");
     	ent.v["origin"] = (-8038.69,-2627.88,1151.78);
     	ent.v["angles"] = (270,0,0);
     	ent.v["fxid"] = "siena_tower_hit1";
     	ent.v["delay"] = -15;
     	ent.v["targetname"] = "fx_tower_hit1";
 
     	ent = maps\_utility::createOneshotEffect("siena_tower_hit1");
     	ent.v["origin"] = (-8029.52,-2952.75,1076.7);
     	ent.v["angles"] = (270,0,0);
     	ent.v["fxid"] = "siena_tower_hit1";
     	ent.v["delay"] = -15;
     	ent.v["targetname"] = "fx_tower_hit2";
 
     	ent = maps\_utility::createOneshotEffect("siena_tower_hit2");
     	ent.v["origin"] = (-7987.61,-3063.22,1063.13);
     	ent.v["angles"] = (270,0,0);
     	ent.v["fxid"] = "siena_tower_hit2";
     	ent.v["delay"] = -15;
     	ent.v["targetname"] = "fx_tower_hit3";
 
}
