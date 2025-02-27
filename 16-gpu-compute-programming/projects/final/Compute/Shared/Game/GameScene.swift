/// Copyright (c) 2022 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import MetalKit

struct GameScene {
  lazy var warrior: Model = {
    Model(name: "Warrior.obj")
  }()

  var models: [Model] = []
  var camera = ArcballCamera()

  var defaultView: Transform {
    Transform(
      position: [1.4, 1.9, 2.6],
      rotation: [-0.14, 9.9, 0.0])
  }

  var lighting = SceneLighting()

  init() {
    camera.transform = defaultView
    camera.target = [0, 1.5, 0]
    camera.distance = 2.7
    models = [warrior]
    warrior.convertMesh()
  }

  mutating func update(size: CGSize) {
    camera.update(size: size)
  }

  mutating func update(deltaTime: Float) {
    let input = InputController.shared
    if input.keysPressed.contains(.one) {
      camera.transform = Transform()
    }
    if input.keysPressed.contains(.two) {
      camera.transform = defaultView
    }
    input.keysPressed.removeAll()
    camera.update(deltaTime: deltaTime)
  }

  mutating func convertMesh(_ model: Model) {
    let startTime = CFAbsoluteTimeGetCurrent()
    for mesh in model.meshes {
      // 1
      let vertexBuffer = mesh.vertexBuffers[VertexBuffer.index]
      let count =
        vertexBuffer.length / MemoryLayout<VertexLayout>.stride
      // 2
      var pointer = vertexBuffer
        .contents()
        .bindMemory(to: VertexLayout.self, capacity: count)
      // 3
      for _ in 0..<count {
        // 4
        pointer.pointee.position.z = -pointer.pointee.position.z
        pointer = pointer.advanced(by: 1)
      }
    }
    // 5
    print("CPU Time:", CFAbsoluteTimeGetCurrent() - startTime)
  }
}
