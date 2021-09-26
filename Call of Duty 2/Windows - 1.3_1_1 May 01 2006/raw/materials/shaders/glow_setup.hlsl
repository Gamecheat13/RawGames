#include "lib/globals.hlsl"

sampler colorMapPostSunSampler;

struct VertexInput
{
	float4 position : POSITION;
	float2 texCoords : TEXCOORD0;
};


struct PixelInput
{
	float4 position : POSITION;
	float2 texCoords[4] : TEXCOORD0;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "lib/transform.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.texCoords[0] = vertex.texCoords - 0.5 * float2( renderTargetSize[SIZECONST_INV_WIDTH], renderTargetSize[SIZECONST_INV_HEIGHT] );
	pixel.texCoords[1] = vertex.texCoords - 0.5 * float2( renderTargetSize[SIZECONST_INV_WIDTH], -renderTargetSize[SIZECONST_INV_HEIGHT] );
	pixel.texCoords[2] = vertex.texCoords + 0.5 * float2( renderTargetSize[SIZECONST_INV_WIDTH], -renderTargetSize[SIZECONST_INV_HEIGHT] );
	pixel.texCoords[3] = vertex.texCoords + 0.5 * float2( renderTargetSize[SIZECONST_INV_WIDTH], renderTargetSize[SIZECONST_INV_HEIGHT] );

	return pixel;
}


half4 SampleContribution( const PixelInput pixel, int coordIndex )
{
	half4 sample;
	half4 screenPixel;
	half alphaPostSun;
	half intensity;
	half nonSkyFraction;

	screenPixel = tex2D( colorMapSampler, pixel.texCoords[coordIndex] );
	alphaPostSun = tex2D( colorMapPostSunSampler, pixel.texCoords[coordIndex] ).a;
	intensity = dot( screenPixel.rgb, half3( 0.299f, 0.587f, 0.114f ) );
	sample.rgb = (intensity >= glowSetup[GLOW_SETUP_CUTOFF]) ? 1 + (screenPixel.rgb - 1) * glowSetup[GLOW_SETUP_CUTOFF_RESCALE] : 0;
	nonSkyFraction = saturate( 4 * max( screenPixel.a, alphaPostSun ) );
	sample.rgb *= nonSkyFraction;
	sample.a = 1 - nonSkyFraction;

	return sample;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;
	int coordIndex;
	half4 screenPixel;
	half intensity;

	fragment.color = SampleContribution( pixel, 0 );
	fragment.color += SampleContribution( pixel, 1 );
	fragment.color += SampleContribution( pixel, 2 );
	fragment.color += SampleContribution( pixel, 3 );
	fragment.color *= 0.25;

	intensity = dot( fragment.color.rgb, half3( 0.299f, 0.587f, 0.114f ) );
	fragment.color.rgb = lerp( fragment.color.rgb, intensity, glowSetup[GLOW_SETUP_DESATURATION] );

	return fragment;
}
