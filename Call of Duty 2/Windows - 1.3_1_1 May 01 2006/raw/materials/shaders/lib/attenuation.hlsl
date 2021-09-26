half3 Attenuation( const PixelInput pixel )
{
	// Hardware texture coordinate clamping is inadequate for small lights that exceed the max texture reptitions,
	// so we have to explicitly saturate the coordinates.
	return tex1D( attenuationSampler, saturate( length( pixel.lightDelta ) ) ).rgb;
}
