//
//  metal.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/05/18.
//

import SwiftUI
import MetalKit



struct MetalContentView: View {
    var body: some View {
        MetalView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct MetalContentView_Previews: PreviewProvider {
    static var previews: some View {
        MetalContentView()
    }
}

struct MetalView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.delegate = context.coordinator
        return mtkView
    }

    func updateUIView(_ uiView: MTKView, context: Context) { }

    class Coordinator: NSObject, MTKViewDelegate {
        var parent: MetalView
        var commandQueue: MTLCommandQueue!
        var pipelineState: MTLRenderPipelineState!
        var vertexBuffer: MTLBuffer!

        let vertexData: [Float] = [
            0.0,  1.0, 0.0,
           -1.0, -1.0, 0.0,
            1.0, -1.0, 0.0
        ]

        init(_ parent: MetalView) {
            self.parent = parent
            super.init()
            setupMetal()
        }

        func setupMetal() {
            let device = MTLCreateSystemDefaultDevice()!
            let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
            vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])

            let defaultLibrary = device.makeDefaultLibrary()
            let vertexFunction = defaultLibrary?.makeFunction(name: "vertex_main")
            let fragmentFunction = defaultLibrary?.makeFunction(name: "fragment_main")

            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunction
            pipelineDescriptor.fragmentFunction = fragmentFunction
            pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

            pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            commandQueue = device.makeCommandQueue()
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }

        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let descriptor = view.currentRenderPassDescriptor else { return }

            descriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

            let commandBuffer = commandQueue.makeCommandBuffer()!
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
            renderEncoder.setRenderPipelineState(pipelineState)
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
            renderEncoder.endEncoding()

            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
}
