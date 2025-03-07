import SwiftUI
import PhotosUI
import CloudKit

struct GoalSelectionView: View {
    @StateObject private var vm = CloudKitUserViewModel()
    @StateObject private var viewModel = ViewModel2(user: nil) // ✅ تأكدنا أن ViewModel2 هو @StateObject
    
    @State private var name = ""
    @State private var cost = ""
    @State private var salary = ""
    
    @State private var savedGoal: Goal?
    @State private var selectedSavingsType: Goal.SavingsType = .monthly
    @State private var selectedGoal: String?
    @State private var image: UIImage?
    @State private var isImagePickerPresented = false
    @State private var navigateToSetGoalCost = false
    @State private var showGoalSelectionError = false

    let goals = ["👜", "📱", "🚗", "🌴", "📸", "🎮", "📚", "🏡"]

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient()
                    .ignoresSafeArea()

                VStack {
                    headerView()
                    goalSelectionView()
                        .padding(.top, 100)
                        .padding(.horizontal)
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear(perform: loadUser) // ✅ استدعاء `loadUser`
            .alert("Error", isPresented: $showGoalSelectionError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please select a goal, enter a name, and upload an image before proceeding.")
            }

            NavigationLink(
                destination: SetGoalCostView(goal: savedGoal ?? Goal(
                    id: CKRecord.ID(recordName: UUID().uuidString),
                    name: "Temporary Goal",
                    cost: 0,
                    savingsType: .monthly,
                    emoji: "🎯"
                )),
                isActive: $navigateToSetGoalCost
            ) { EmptyView() }
            .hidden()
        }
    }

    // MARK: - Load User ✅
    private func loadUser() {
        Task {
            try await vm.fetchUsers()
            DispatchQueue.main.async {
                viewModel.user = vm.currentUser
            }
        }
    }

    // MARK: - Background Gradient
    private func backgroundGradient() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1F0179"), Color(hex: "160158"), Color(hex: "0E0137")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Header View
    private func headerView() -> some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)

            if let user = vm.currentUser {
                Text("Good evening, \(user.name)")
                    .foregroundColor(.white)
                    .font(.headline)
            } else {
                Text("Loading user...")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 50)
    }

    // MARK: - Goal Selection View
    private func goalSelectionView() -> some View {
        VStack(spacing: 20) {
            Text("Choose your Goal")
                .foregroundColor(.white)
                .font(.title2)
                .fontWeight(.semibold)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(goals, id: \.self) { goal in
                        Text(goal)
                            .font(.largeTitle)
                            .padding(20)
                            .background(
                                Circle()
                                    .fill(selectedGoal == goal ? Color.blue.opacity(0.7) : Color.clear)
                                    .overlay(
                                        Circle().stroke(Color.white, lineWidth: selectedGoal == goal ? 3 : 0)
                                    )
                            )
                            .onTapGesture {
                                selectedGoal = goal
                            }
                    }
                }
                .padding(.horizontal)
            }

            goalNameTextField()
            imagePickerView()
            nextButton()
        }
        .frame(width: 420, height: 650)
        .background(LinearGradient(
            gradient: Gradient(colors: [Color(hex: "243470"), Color(hex: "1C215B"), Color(hex: "120248")]),
            startPoint: .topLeading,
            endPoint: .bottomLeading
        ).cornerRadius(30))
    }

    // MARK: - Goal Name TextField
    private func goalNameTextField() -> some View {
        TextField("Type your Goal", text: $name)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
            .foregroundColor(.white)
            .accentColor(.white)
            .padding(.horizontal)
    }

    // MARK: - Image Picker View ✅
    private func imagePickerView() -> some View {
        VStack(spacing: 8) {
            Text("Upload the image")
                .foregroundColor(.white)
                .font(.headline)

            Button(action: { isImagePickerPresented.toggle() }) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    ZStack {
                        Circle().fill(Color.white.opacity(0.1)).frame(width: 60, height: 60)
                        Image(systemName: "plus").font(.title).foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $image)
            }
        }
    }

    // MARK: - Next Button ✅
    private func nextButton() -> some View {
        Button(action: saveGoal) {
            Text("Next")
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(Color.blue)
                .cornerRadius(25)
        }
        .padding(.top, 30)
    }

    // MARK: - Save Goal ✅
    private func saveGoal() {
        guard let selectedGoal = selectedGoal, !name.isEmpty, image != nil else {
            showGoalSelectionError = true
            return
        }

        let newGoal = Goal(
            id: CKRecord.ID(recordName: UUID().uuidString),
            name: name,
            cost: Double(cost) ?? 0,
            salary: Double(salary) ?? 0,
            savingsType: selectedSavingsType,
            emoji: selectedGoal
        )

        Task {
            await viewModel.saveGoal(goal: newGoal) // ✅ تصحيح استدعاء `saveGoal`
        }

        savedGoal = newGoal
        navigateToSetGoalCost = true
    }
}

// MARK: - ImagePicker ✅
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
