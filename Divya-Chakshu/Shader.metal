#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position [[attribute(0)]];
    float4 color    [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

vertex VertexOut vertexMain(VertexIn in [[stage_in]],
                            constant float4x4 &transform [[buffer(1)]]) {
    VertexOut out;
    out.position = transform * float4(in.position, 1.0);
    out.color = in.color;
    return out;
}

fragment float4 fragmentMain(VertexOut in [[stage_in]]) {
    return in.color;
}
