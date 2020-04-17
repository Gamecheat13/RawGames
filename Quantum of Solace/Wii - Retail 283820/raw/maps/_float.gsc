






#include common_scripts\utility;
main(range, freq, wavelength, rotation, origin)
{
	floaters = getentarray ("script_floater","targetname");
	
	if(!floaters.size)
		return;
	
	
	_range = 10;
	_freq = .5;
	_wavelength = 50;
	_origin = (0,0,0);
	_rotation = 10;
		
	
	if(isdefined(range))
		_range = range;
	if(isdefined(freq))
		_freq = freq;
	if(isdefined(wavelength))
		_wavelength = wavelength;
	if(isdefined(origin))
		_origin = origin;	
	if(isdefined(rotation))
		_rotation = rotation;
		
	for(i=0;i<floaters.size;i++)
		floaters[i] thread floater_think(_range, _freq, _wavelength, _rotation, _origin);
}

floater_think(range, freq, wavelength, rotation, origin)
{
	self.range 	= range;
	self.time 	= 1 / freq;
	self.acc 	= self.time * .25;
	center 		= self getorigin();
	
	
	
	
	conv_fac 	= 360 / wavelength;
	dist 		= distance(center, origin);
	degrees 	= dist * conv_fac;
	frac = sin(degrees);
	
	
	if(cos(degrees) < 0)
		self.range = -1 * self.range;
	
	org = spawn("script_origin", center);
	self linkto(org);
	
	angles = vectortoangles (center - origin);
	self.nangles = org.angles;
	org.angles = org.angles + (rotation, rotation * .25, angles[2]);
	self.rangles = org.angles;
	
	self thread floater_move(frac, org);
	self thread floater_bob(frac, org);
}

floater_bob(frac, org)
{
	self endon ("death");
	self endon ("stop_float_script");
	wait (abval(self.time * frac));
		
	while(1)
	{
		self.rangles = vectorScale(self.rangles, -1);
		org rotateto(self.rangles, self.time, self.acc, self.acc);
		org waittill("rotatedone");
	}
}

floater_move(frac, org)
{
	self endon ("death");
	self endon ("stop_float_script");
	wait (abval(self.time * frac));
	org moveZ(self.range * .5, self.time *.5, self.acc, self.acc);
		
	while(1)
	{
		org waittill("movedone");
		self.range = -1 * self.range;
		org moveZ(self.range, self.time, self.acc, self.acc);
	}
}

abval(num)
{
	if(num < 0)
		return (-1 * num);
	else
		return num;	
}