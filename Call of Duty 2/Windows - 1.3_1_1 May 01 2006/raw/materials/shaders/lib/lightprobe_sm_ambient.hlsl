#ifndef CACHED_SMODEL
#error "CACHED_SMODEL not defined"
#endif

#include "globals.hlsl"

#define FOGVAR fog


struct VertexInput
{
	float4 position : POSITION;
	float3 normal : NORMAL;
	float4 color : COLOR0;
	float2 texCoords : TEXCOORD0;
	float3 tangent : TEXCOORD1;
	float3 binormal : TEXCOORD2;
#if CACHED_SMODEL
	float3 lightingCoords : TEXCOORD3;
#endif // #if CACHED_SMODEL
};


struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR0;
	float4 colorTimesSun : COLOR1;
	float2 texCoords : TEXCOORD0;
	float3 lightingCoords : TEXCOORD1;

#if USE_FOG
	float fog : FOG_SEMANTIC;
#endif
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "transform.hlsl"
#include "fog.hlsl"
#include "shade.hlsl"
#include "phong.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	float3 baseLightingCoordsToUse;

	PixelInput pixel;

	pixel = (PixelInput)0;
	pixel.position = Transform_ObjectToClip( vertex.position );

	pixel.color = vertex.color;
	pixel.colorTimesSun = vertex.color;
	pixel.colorTimesSun.rgb *= lightColor0.rgb;
	pixel.texCoords = vertex.texCoords;

#if CACHED_SMODEL
	baseLightingCoordsToUse = vertex.lightingCoords * (1.0f / 32768) + float3( 0, 0, 0.5f );
#else
	baseLightingCoordsToUse = baseLightingCoords;
#endif

        pixel.lightingCoords = baseLightingCoordsToUse;

	Fog_VertexCalc( vertex, pixel );

	return pixel;
}

PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput	fragment;

	half4		texColor;
	half4           lightingSample;

	texColor = tex2D( colorMapSampler, pixel.texCoords );
	lightingSample = tex3D( smodelLightingSampler, pixel.lightingCoords );

	fragment.color.rgb = texColor * pixel.color * lightingSample;
	fragment.color.rgb += texColor * pixel.colorTimesSun * lightingSample.a;

#if USE_ALPHA
	fragment.color.a = texColor.a * pixel.color.a;
#else
	fragment.color.a = 1.0f;
#endif

	Fog_PixelCalc( pixel, fragment );

	return fragment;
}
