import SwiftUI
import RealityKit
import ARKit
import Combine

// MARK: - Model
struct ARCampingModel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let modelName: String

    static var defaultModels: [ARCampingModel] = [
        .init(name: "Tent", imageName: "tent.fill", modelName: "camping_tent"),
        .init(name: "Campfire", imageName: "flame.fill", modelName: "campfire"),
        .init(name: "Chair", imageName: "chair.fill", modelName: "camping_chair"),
        .init(name: "Cooler", imageName: "refrigerator.fill", modelName: "camping_cooler"),
        .init(name: "Backpack", imageName: "bag.fill", modelName: "hiking_backpack"),
        .init(name: "Cabin", imageName: "house.fill", modelName: "camping_cabin")
    ]
}

// MARK: - AR View
struct CameraARView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedModel: ARCampingModel?
    @State private var models: [ARCampingModel] = ARCampingModel.defaultModels
    @State private var modelConfirmationShown = false
    @State private var showSearch = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                ARViewContainer(selectedModel: $selectedModel)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                        Spacer()
                    }

                    Spacer()

                    if let selectedModel = selectedModel {
                        Button(action: {
                            modelConfirmationShown = true
                        }) {
                            HStack {
                                Image(systemName: selectedModel.imageName)
                                Text("Place \(selectedModel.name)")
                                    .bold()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                        }
                        .alert(isPresented: $modelConfirmationShown) {
                            Alert(
                                title: Text("Place \(selectedModel.name)"),
                                message: Text("The object will be placed in front of you."),
                                primaryButton: .default(Text("Place")) {
                                    NotificationCenter.default.post(name: Notification.Name("placeModel"), object: selectedModel)
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        .padding(.bottom, 20)
                    }
                }

                // Sidebar with plus button
                HStack {
                    Spacer()
                    VStack {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(models) { model in
                                    Button(action: {
                                        selectedModel = model
                                    }) {
                                        VStack {
                                            Image(systemName: model.imageName)
                                                .font(.system(size: 30))
                                                .padding(12)
                                                .background(selectedModel?.id == model.id ? Color.blue : Color.gray.opacity(0.8))
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                            Text(model.name)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                            .padding(12)
                        }

                        // Plus button
                        Button(action: { showSearch = true }) {
                            Image(systemName: "plus")
                                .font(.title)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding(.bottom, 10)
                    }
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(12)
                    .frame(width: 100)
                    .padding(.trailing, 10)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSearch) {
                ModelSearchView(models: $models)
            }
        }
    }
}

// MARK: - ARView Container
struct ARViewContainer: UIViewRepresentable {
    @Binding var selectedModel: ARCampingModel?

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        arView.session.run(config)

        NotificationCenter.default.addObserver(forName: Notification.Name("placeModel"), object: nil, queue: .main) { notification in
            if let model = notification.object as? ARCampingModel {
                let entity = context.coordinator.loadCampingModel(named: model.modelName)
                entity.generateCollisionShapes(recursive: true)
                arView.installGestures([.rotation, .scale, .translation], for: entity)

                // Tap to delete
                let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
                arView.addGestureRecognizer(tapGesture)
                context.coordinator.entities.append(entity)

                var transform = matrix_identity_float4x4
                transform.columns.3.z = -1.0
                let anchor = AnchorEntity(world: transform)
                anchor.addChild(entity)
                arView.scene.addAnchor(anchor)
            }
        }

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var entities: [Entity] = []

        func loadCampingModel(named modelName: String) -> ModelEntity {
            let mesh = MeshResource.generateBox(size: 0.3)
            let material = SimpleMaterial(color: .cyan, isMetallic: false)
            return ModelEntity(mesh: mesh, materials: [material])
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = gesture.view as? ARView else { return }
            let tapLocation = gesture.location(in: arView)

            if let entity = arView.entity(at: tapLocation),
               let anchor = entity.anchor {
                entity.removeFromParent()
                anchor.removeFromParent()
                print("🗑️ Deleted object")
            }
        }
    }
}
