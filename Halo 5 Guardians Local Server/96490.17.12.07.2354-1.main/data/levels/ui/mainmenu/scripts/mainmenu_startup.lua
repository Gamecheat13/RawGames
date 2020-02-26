--## SERVER

global var_play_prowler = false;
global var_play_float_grunt = false;
global var_dont_grunt = false;
global var_fem_infinity:number=nil;



function startup.mainmenu()
	print ("starting mainmenu");
	fade_out(0, 0, 0, 0);
	var_fem_infinity = composer_play_show ("vin_fem_infinity");
	CreateThread (prowler);
	CreateThread (float_grunt);
	sleep_s (4);
	fade_in(0, 0, 0, 60);
end


function prowler():void
	sleep_s(random_range(836,996));
	var_play_prowler = true;
	print ("PROWLER");
end

function float_grunt():void
	sleep_s(343);
	var_play_float_grunt = true;
	print ("GRUNT");
end
