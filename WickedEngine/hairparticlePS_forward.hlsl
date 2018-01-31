#include "globals.hlsli"
#include "objectHF.hlsli"
#include "hairparticleHF.hlsli"
#include "ditherHF.hlsli"

GBUFFEROutputType_Thin main(VertexToPixel input)
{
#ifdef GRASS_FADE_DITHER
	clip(dither(input.pos.xy) - input.fade);
#endif

	float4 color = float4(texture_0.Sample(sampler_linear_clamp, input.tex).rgb, 1);
	ALPHATEST(color.a)
	float opacity = 1; // keep edge diffuse shading
	color.rgb = DEGAMMA(color.rgb);
	float3 V = g_xCamera_CamPos - input.pos3D;
	float dist = length(V);
	V /= dist;
	float emissive = 0;
	Surface surface = CreateSurface(input.pos3D, input.nor, V, color, 0, 0, 1);
	float ao = 1;
	float sss = 0;
	float2 pixel = input.pos.xy;
	float depth = input.pos.z;
	float3 diffuse = 0;
	float3 specular = 0;
	float2 velocity = ((input.pos2DPrev.xy / input.pos2DPrev.w - g_xFrame_TemporalAAJitterPrev) - (input.pos2D.xy / input.pos2D.w - g_xFrame_TemporalAAJitter)) * float2(0.5f, -0.5f);

	OBJECT_PS_LIGHT_BEGIN

	OBJECT_PS_LIGHT_FORWARD

	OBJECT_PS_LIGHT_END

	OBJECT_PS_FOG

	OBJECT_PS_OUT_FORWARD
}