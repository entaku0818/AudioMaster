//
//  Shader.metal
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/05/18.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 vertex_main(const device float3 *vertex_array [[buffer(0)]], uint vertex_id [[vertex_id]]) {
    return float4(vertex_array[vertex_id], 1.0);
}

fragment float4 fragment_main() {
    return float4(1.0, 0.0, 0.0, 1.0); // 赤色で塗りつぶす
}
