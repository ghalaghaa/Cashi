import SwiftUI
import CloudKit

struct View3: View {
    @State private var selectedTab: String = "Qattah"
    @State private var showFullTracker = false
    @StateObject private var viewModel = ViewModel2(user: nil)
    @State private var selectedGoals: [Goal] = []
    @State private var isSelectingCalculations = false
    @State private var newAmount: String = ""
    @State private var selectedGoalToEdit: Goal?
    @State private var shouldOpenEditSheet = false
    @State private var showEditSheet = false
    @State private var showDeleteSheet = false
    @State private var showOptionsSheet = false
    @State private var isSelectingGoals = false
    @State private var showProgressSheet = false
    @State private var navigateToGoalSelectionView = false
    @State private var selectedGoal: Goal? = nil
    @State private var userName: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "1F0179"), Color(hex: "160158"), Color(hex: "0E0137")]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            Text("🔍 Username: \(userName)")
                                .foregroundColor(.white)

                            Text("🎯 Goals count: \(viewModel.goals.count)")
                                .foregroundColor(.white)
                            TopHeaderView(
                                onAddTapped: {
                                    navigateToGoalSelectionView = true
                                },
                                selectedGoals: $selectedGoals,
                                isSelectingCalculations: $isSelectingCalculations,
                                userName: userName // ✅ تمرير اسم المستخدم بدلاً من viewModel
                            )

                            GoalsSheetView(
                                selectedGoals: $selectedGoals,
                                isSelectingCalculations: $isSelectingCalculations,
                                selectedGoalToEdit: $selectedGoalToEdit,
                                shouldOpenEditSheet: $shouldOpenEditSheet,
                                showEditSheet: $showEditSheet,
                                isSelectingGoals: $isSelectingGoals
                            )

                            EditGoalSheetView(
                                showEditSheet: $showEditSheet,
                                newAmount: $newAmount,
                                selectedGoalToEdit: $selectedGoalToEdit
                            )

                            // ✅ عرض الأهداف بعد تحميلها
                            if !viewModel.goals.isEmpty {
                                IndividualGoalsScrollView(
                                    viewModel: viewModel,
                                    onAddGoalTapped: {
                                        navigateToGoalSelectionView = true
                                    },
                                    selectedGoal: $selectedGoal
                                )
                            } else {
                                Text("⏳ Loading goals...")
                                    .foregroundColor(.white)
                                    .onAppear {
                                        Task {
                                            await viewModel.fetchGoals()
                                        }
                                    }
                            }

                            FriendsSectionView()
                            TabsHeaderView(selectedTab: $selectedTab)

                            if selectedTab == "Qattah" {
                                QattahGoalsView(viewModel: viewModel, showOptionsSheet: $showOptionsSheet)
                                    .padding(.top, 10)
                            } else {
                                ChallengeGoalsView(viewModel: viewModel)
                                    .padding(.top, 25)
                                    .padding(.leading, 4)
                                    .padding(.top, 10)
                            }

                            Spacer(minLength: 20)

                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("CashTrack")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.leading, 16)
                                    Spacer()
                                }

                                CashTrackerView()
                                    .onTapGesture {
                                        showFullTracker = true
                                    }
                            }
                            .padding(.top, 10)
                        }
                        .padding(.top)
                    }
                    .navigationDestination(isPresented: $navigateToGoalSelectionView) {
                        GoalSelectionView()
                    }
                    .fullScreenCover(isPresented: $showFullTracker) {
                        CashTrackerView()
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchUsers()
                    await viewModel.fetchGoals()
                    userName = viewModel.user?.name ?? "Guest" // ✅ جلب اسم المستخدم
                }
            }
        }
    }
}

// ✅ Preview
struct View3_Previews: PreviewProvider {
    static var previews: some View {
        View3()
    }
}
