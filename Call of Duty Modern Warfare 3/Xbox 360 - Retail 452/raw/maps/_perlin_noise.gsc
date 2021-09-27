


GetPerlinNoiseSample( def, x, y )
{
	xref = x * def.xscale;
	yref = y * def.yscale;
	xf = xref - def.xoff;
	yf = yref - def.yoff;
	refscale = def.refscale;
	if (def.tile)
	{	// repeating texture style
		octaves = def.octaves;
		lacunarity = def.lacunarity;
		gain = def.gain;
		val = (refscale-yref)*( (refscale-xref)*PerlinNoise2D( xf, yf, octaves, lacunarity, gain )          + xref*PerlinNoise2D( xf-refscale, yf, octaves, lacunarity, gain ) ) +
			  yref           *( (refscale-xref)*PerlinNoise2D( xf, yf-refscale, octaves, lacunarity, gain ) + xref*PerlinNoise2D( xf-refscale, yf-refscale, octaves, lacunarity, gain ) );
	}
	else
	{	// faster version
		val = PerlinNoise2D( xf, yf, def.octaves, def.lacunarity, def.gain );
	}
	
	val -= def.sum;
	val *= def.refsc;
	val += 127.0;
	if (val < 0.0)
		val = 0.0;
	if (val > 255.0)
		val = 255.0;
	return val;
}
