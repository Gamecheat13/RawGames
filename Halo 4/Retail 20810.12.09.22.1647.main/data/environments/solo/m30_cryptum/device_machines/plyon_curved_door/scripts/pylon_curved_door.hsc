//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m30_donut_device
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

static real datt = 3; // device animtation time total
static real dcp = 1; //device complete percentage 0-1 

script startup instanced f_init()
	print ("pylontop door has been set up");
	device_set_position_track(this, 'any:idle', 0);
 end

script static instanced void f_animate()
	dprint ("pylon door opening");
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_forerunner_small_tunnel_door_opening', this, 1.0 ); //start door opening noise
	sound_looping_start ("sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\ambience\amb_m30_forerunner_small_tunnel_door_open", this, 1.0);

	device_animate_position (this, 0.5, 3.0, 0.1, 0.1, TRUE);
	sleep_until (device_get_position (this) == 0.5);
	
	sound_looping_stop ("sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\ambience\amb_m30_forerunner_small_tunnel_door_open");
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_forerunner_small_tunnel_door_opened', this, 1.0 ); //stop door opening noise	
end
