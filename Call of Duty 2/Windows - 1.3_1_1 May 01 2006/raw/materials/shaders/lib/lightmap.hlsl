#include "globals.hlsl"

#ifdef PIXEL_FOG
#define	FOGVAR texCoords.z
typedef float3 tcType;
#else
#define	FOGVAR fog
typedef float2 tcType;
#endif


struct VertexInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
	float2 lmapCoords : TEXCOORD1;
	float3 tangent : TEXCOORD2;
	float3 binormal : TEXCOORD3;
	float3 normal : NORMAL;
};


struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	tcType texCoords : TEXCOORD0;
	float2 lmapCoords : TEXCOORD1;
	float3 tangent : TEXCOORD2;
	float3 binormal : TEXCOORD3;
	float3 normal : TEXCOORD4;
	float4 screenCoords : TEXCOORD5;
#if USE_SPECULAR
	float3 halfAngle : TEXCOORD6;
#endif
#if USE_FOG && !defined( PIXEL_FOG )
	float fog : FOG_SEMANTIC;
#endif
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "transform.hlsl"
#include "fog.hlsl"
#include "normalmap.hlsl"
#include "shade.hlsl"
#include "phong.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel = (PixelInput)0;

	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.color = vertex.color;
	pixel.texCoords.xy = vertex.texCoords;
	pixel.lmapCoords = vertex.lmapCoords;
	pixel.screenCoords = Transform_ClipSpacePosToTexCoords( pixel.position );

	Normal_VertexSetup( vertex, worldMatrix, pixel );
	Phong_VertexSetup( vertex, lightPosition0, pixel );
	Fog_VertexCalc( vertex, pixel );

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput	fragment;

	half4		diffuseColor;
	half4		lightmapCoeffsR;
	half4		lightmapCoeffsG;
	half4		lightmapCoeffsB;
	half4		coeffWeights;
	half3		lightmapDiffuse;
	half3		sunlightVisibility;
	half3		sunlightVisibilitySpec;
	half3		sunlightDiffuse;
	half3		sunlightSpecular;
	half2		normalSample;
	half3		worldNormal;

	diffuseColor = ColoredTexturedDiffuse( pixel.color, pixel.texCoords.xy );

	normalSample = Normal_GetSample( pixel.texCoords.xy );
	coeffWeights = tex2D( lightmapWeightSampler, normalSample );

	lightmapCoeffsR = tex2D( lightmapSamplerR, pixel.lmapCoords );
	lightmapCoeffsG = tex2D( lightmapSamplerG, pixel.lmapCoords );
	lightmapCoeffsB = tex2D( lightmapSamplerB, pixel.lmapCoords );

	lightmapDiffuse.r = dot( lightmapCoeffsR, coeffWeights );
	lightmapDiffuse.g = dot( lightmapCoeffsG, coeffWeights );
	lightmapDiffuse.b = dot( lightmapCoeffsB, coeffWeights );

	worldNormal = Normal_DecodeNormalizedWorldSpace( pixel, normalSample );
	sunlightVisibility = tex2D( lightmapSamplerSun, pixel.lmapCoords ) * tex2Dproj( dynamicShadowSampler, pixel.screenCoords );
	sunlightVisibilitySpec = Phong_SpecularVisibility( sunlightVisibility );
	sunlightDiffuse = sunlightVisibility * Phong_DiffuseLighting( pixel, worldNormal, lightPosition0 );
	sunlightSpecular = sunlightVisibilitySpec * Phong_SpecularLighting( pixel, worldNormal );

	fragment.color.rgb = diffuseColor.rgb * (lightmapDiffuse + sunlightDiffuse) + sunlightSpecular;
#if USE_ALPHA
	fragment.color.a = diffuseColor.a;
#else
	fragment.color.a = 1.0f;
#endif

	Fog_PixelCalc( pixel, fragment );

	return fragment;
}
