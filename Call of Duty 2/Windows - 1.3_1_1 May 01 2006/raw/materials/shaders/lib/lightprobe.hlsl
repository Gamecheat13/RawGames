#include "globals.hlsl"

#define FOGVAR fog


struct VertexInput
{
	float4 position : POSITION;
	float3 normal : NORMAL;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
	float3 tangent : TEXCOORD1;
	float3 binormal : TEXCOORD2;
};


struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
	float3 tangent : TEXCOORD1;
	float3 binormal : TEXCOORD2;
	float3 normal : TEXCOORD3;
	float4 screenCoords : TEXCOORD4;
#if USE_SPECULAR
	float3 halfAngle : TEXCOORD5;
#endif
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
#include "normalmap.hlsl"
#include "shade.hlsl"
#include "phong.hlsl"
#include "texscroll.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel = (PixelInput)0;
	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.color = vertex.color;
	pixel.texCoords = TexScroll( vertex.texCoords );
	pixel.screenCoords = Transform_ClipSpacePosToTexCoords( pixel.position );

	Normal_VertexSetup( vertex, worldMatrix, pixel );
	Phong_VertexSetup( vertex, lightPosition0, pixel );
	Fog_VertexCalc( vertex, pixel );

	return pixel;
}


half3 ProbeLighting( half3 worldNormal )
{
	half4 weights[2];
	half3 color;

	weights[0] = texCUBE( lightGridWeightSampler0, worldNormal );
	weights[1] = texCUBE( lightGridWeightSampler1, worldNormal );

	color.r = dot( weights[0], lightGridColorsR0 ) + dot( weights[1], lightGridColorsR1 );
	color.g = dot( weights[0], lightGridColorsG0 ) + dot( weights[1], lightGridColorsG1 );
	color.b = dot( weights[0], lightGridColorsB0 ) + dot( weights[1], lightGridColorsB1 );

	return color;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput	fragment;

	half4		diffuseColor;
	half3		lightprobeDiffuse;
	half3		sunlightVisibility;
	half3		sunlightVisibilitySpec;
	half3		sunlightDiffuse;
	half3		sunlightSpecular;
	half3		worldNormal;

	diffuseColor = ColoredTexturedDiffuse( pixel.color, pixel.texCoords );

	worldNormal = Normal_GetWorldSpace( pixel );
	lightprobeDiffuse = ProbeLighting( worldNormal );

	sunlightVisibility = lightColor0.a * tex2Dproj( dynamicShadowSampler, pixel.screenCoords );
	sunlightVisibilitySpec = Phong_SpecularVisibility( sunlightVisibility );
	sunlightDiffuse = sunlightVisibility * Phong_DiffuseLighting( pixel, worldNormal, lightPosition0 );
	sunlightSpecular = sunlightVisibilitySpec * Phong_SpecularLighting( pixel, worldNormal );

	fragment.color.rgb = diffuseColor.rgb * (lightprobeDiffuse + sunlightDiffuse) + sunlightSpecular;
#if USE_ALPHA
	fragment.color.a = diffuseColor.a;
#else
	fragment.color.a = 1.0f;
#endif

	Fog_PixelCalc( pixel, fragment );

	return fragment;
}
