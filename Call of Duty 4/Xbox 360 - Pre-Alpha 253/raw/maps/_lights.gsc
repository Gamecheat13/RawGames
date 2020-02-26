// This function never returns.
flickerLight( color0, color1, minDelay, maxDelay )
{
	toColor = color0;
	delay = 0.0;

	for ( ;; )
	{
		fromColor = toColor;
		toColor = color0 + (color1 - color0) * randomfloat( 1.0 );

		if ( minDelay != maxDelay )
			delay += randomfloatrange( minDelay, maxDelay );
		else
			delay += minDelay;

		colorDeltaPerTime = (fromColor - toColor) * (1 / delay);
		while ( delay > 0 )
		{
			self setLightColor( toColor + colorDeltaPerTime * delay );
			wait 0.05;
			delay -= 0.05;
		}
	}
}

flickerLightIntensity( minDelay, maxDelay )
{
	on = self getLightIntensity();
	off = 0;
	curr = on;
	num = 0;
	
	for ( ;; )
	{
		num = randomintrange(1, 10);
		while( num )
		{
			wait( randomfloatrange(.05, .1) );
			if(curr > .2)
				curr = randomfloatrange(0, .3);
			else
				curr = on;
					
			self setLightIntensity(curr);
			num--;			
		}
		
		self setLightIntensity(on);	
		wait( randomfloatrange( minDelay, maxDelay ) );
	}	
}

// This function never returns.
strobeLight( intensity0, intensity1, period )
{
	frequency = 360 / period;
	time = 0;

	for ( ;; )
	{
		interpolation = sin( time * frequency ) * 0.5 + 0.5;
		self setLightIntensity( intensity0 + (intensity1 - intensity0) * interpolation );
		wait 0.05;
		time += 0.05;
		if ( time > period )
			time -= period;
	}
}


// This function is non-blocking.  It will probably need to be moved to code if scripted lights are needed in multiplayer.
changeLightColorTo( targetColor, totalTime, accelTime, decelTime )
{
	if ( !isdefined( accelTime ) )
		accelTime = 0;
	if ( !isdefined( decelTime ) )
		decelTime = 0;
	self thread changeLightColorToWorkerThread( targetColor, totalTime, accelTime, decelTime );
}


// Don't call directly; use 'changeLightColorTo' instead
changeLightColorToWorkerThread( targetColor, totalTime, accelTime, decelTime )
{
	// Interpolation goes from 0 to 1 over totalTime, with const acceleration and deceleration given by their respective times.
	// The descriptive equations are:
	//   midTime = totalTime - accelTime - decelTime
	//   fracAccel = 0.5 * accelRate * accelTime^2
	//   fracConst = velConst * midTime
	//   fracDecel = velConst * decelTime - 0.5 * decelRate * decelTime^2
	//   fracAccel + fracConst + fracDecel = 1
	//   velConst = accelRate * accelTime
	//   velConst = decelRate * decelTime
	// The unknowns are fracAccel, fracConst, fracDecel, accelRate, decelRate, and velConst.  We have six equations and six unknowns.
	// So, these can be solved to give the following:
	//   accelRate = 2 / (accelTime * (totalTime + midTime))
	//   decelRate = 2 / (decelTime * (totalTime + midTime))
	//   velConst = 2 / (totalTime + midTime)
	//   fracAccel = accelTime / (totalTime + midTime)
	//   fracDecel = decelTime / (totalTime + midTime)
	//   fracConst = 2 * midTime / (totalTime + midTime)

	startColor = self getLightColor();
	timeFactor = 1 / (totalTime * 2 - (accelTime + decelTime));
	time = 0;

	if ( time < accelTime )
	{
		halfRate = timeFactor / accelTime;
		
		while ( time < accelTime )
		{
			fraction = halfRate * time * time;
			self setLightColor( vectorlerp( startColor, targetColor, fraction ) );
			wait 0.05;
			time += 0.05;
		}
	}

	while ( time < totalTime - decelTime )
	{
		fraction = timeFactor * (2 * time - accelTime);
		self setLightColor( vectorlerp( startColor, targetColor, fraction ) );
		wait 0.05;
		time += 0.05;
	}

	time = totalTime - time;
	if ( time > 0 )
	{
		halfRate = timeFactor / decelTime;

		while ( time > 0 )
		{
			fraction = 1 - halfRate * time * time;
			self setLightColor( vectorlerp( startColor, targetColor, fraction ) );
			wait 0.05;
			time -= 0.05;
		}
	}

	self setLightColor( targetColor );
}
