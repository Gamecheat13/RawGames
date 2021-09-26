#ifndef USE_DETAIL
#error "USE_DETAIL must be defined"
#endif // #ifndef USE_DETAIL

half4 TexturedDiffuse( const float2 texCoords )
{
	half4 sample;

	sample = tex2D( colorMapSampler, texCoords );
#if USE_DETAIL
	sample.rgb += tex2D( detailMapSampler, texCoords * detailScale.xy ).rgb - 0.5f;
#endif // #if USE_DETAIL
	return sample;
}


half4 ColoredTexturedDiffuse( const half4 color, const float2 texCoords )
{
	return color * TexturedDiffuse( texCoords );
}
