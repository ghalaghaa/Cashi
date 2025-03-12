import SwiftUI
import CloudKit
import Foundation

struct GoalSelectionView: View {
    @StateObject private var vm = CloudKitUserViewModel()
    @StateObject private var viewModel: ViewModel2
    
    @State private var name = ""
    @State private var savedGoal: Goal?
    @State private var selectedGoal: String?
    @State private var imageData: Data?
    @State private var isImagePickerPresented = false
    @State private var navigateToSetGoalCost = false
    @State private var showGoalSelectionError = false

    let goals = ["👜", "📱", "🚗", "🌴", "📸", "🎮", "📚", "🏡"]

    init() {
        let initialUser = CloudKitUserViewModel().currentUser
        _viewModel = StateObject(wrappedValue: ViewModel2(user: initialUser))
    }

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
//            .navigationBarBackButtonHidden(true)
            .onAppear(perform: loadUser)
            .alert("Error", isPresented: $showGoalSelectionError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please select a goal, enter a name, and upload an image before proceeding.")
            }

            if let currentUser = viewModel.user, let savedGoal = savedGoal {
                NavigationLink(
                    destination: SetGoalCostView(goal: savedGoal, user: currentUser),
                    isActive: $navigateToSetGoalCost
                ) { EmptyView() }
                .hidden()
            }
        }
    }

    // ✅ جلب المستخدم عند فتح الصفحة
    private func loadUser() {
        Task {
            do {
                try await vm.fetchUsers()
                DispatchQueue.main.async {
                    if let fetchedUser = vm.currentUser {
                        viewModel.user = fetchedUser
                        print("✅ User fetched successfully: \(fetchedUser.name)")
                    } else {
                        print("⚠️ No user found.")
                    }
                }
            } catch {
                print("⚠️ Error fetching user: \(error.localizedDescription)")
            }
        }
    }

    // ✅ الخلفية المتدرجة
    private func backgroundGradient() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1F0179"), Color(hex: "160158"), Color(hex: "0E0137")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // ✅ الهيدر العلوي
    private func headerView() -> some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)

            Text("Good evening, \(viewModel.user?.name ?? "Guest")")
                .foregroundColor(.white)
                .font(.headline)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 50)
    }

    // ✅ واجهة اختيار الهدف
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
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "243470"), Color(hex: "1C215B"), Color(hex: "120248")]),
                startPoint: .topLeading,
                endPoint: .bottomLeading
            ).cornerRadius(30)
        )
    }

    // ✅ إدخال اسم الهدف
    private func goalNameTextField() -> some View {
        TextField("Type your Goal", text: $name)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
            .foregroundColor(.white)
            .accentColor(.white)
            .padding(.horizontal)
    }

    // ✅ اختيار صورة للهدف
    private func imagePickerView() -> some View {
        VStack {
            Button(action: { isImagePickerPresented.toggle() }) {
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
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
                ImagePicker(imageData: $imageData)
            }
        }
    }

    // ✅ زر الانتقال للصفحة التالية
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

    // ✅ دالة حفظ الهدف
    private func saveGoal() {
        guard let selectedGoal = selectedGoal, !name.isEmpty, let imageData = imageData else {
            showGoalSelectionError = true
            return
        }

        let newGoal = Goal(
            id: CKRecord.ID(recordName: UUID().uuidString),
            name: name,
            cost: 0.0, // ✅ القيمة الافتراضية
            salary: 0.0, // ✅ القيمة الافتراضية
            savingsType: .monthly, // ✅ يمكن تغييره لاحقًا
            emoji: selectedGoal,
            goalType: .individual,
            imageData: imageData
        )

        savedGoal = newGoal

        DispatchQueue.main.async {
            navigateToSetGoalCost = true
        }
    }
}

// ✅ مكون لاختيار الصور
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?
    

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.imageData = image.jpegData(compressionQuality: 0.8)
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

