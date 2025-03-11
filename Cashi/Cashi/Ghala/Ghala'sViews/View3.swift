//
//  ContentView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 24/08/1446 AH.
//  Created by Ghala Alnemari on 24/08/1446 AH.
//
//  View3.swift
//  Cashi
//
//  Created by Ghala Alnemari on 24/08/1446 AH.
//

//import SwiftUI
//import CloudKit
//
//struct View3: View {
//    @State private var selectedTab: String = "Qattah"
//    @State private var showFullTracker = false
//    @StateObject private var viewModel = ViewModel2(user: nil)
//    @State private var showGoalSelectionView = false
//    @State private var updatingCalculationID: String?
//    @State private var updatingGoalID: CKRecord.ID?
//    @State private var isSelectingCalculations = false
//    @State private var selectedCalculations = [Calculation]()
//    @State private var showDeleteSheet = false
//    @State private var showEditSheet = false
//    @State private var newAmount: String = ""
//    @State private var shouldOpenEditSheet = false
//    @State private var selectedCalculationToEdit: Calculation?
//    @State private var showOptionsSheet = false
//    @State private var selectedCategory: String = "Main"
//    @State private var showQattahOptionsSheet = false
//
//    var body: some View {
//        ZStack {
//            LinearGradient(gradient: Gradient(colors: [
//                Color(hex: "1F0179"),
//                Color(hex: "160158"),
//                Color(hex: "0E0137")
//            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
//            .ignoresSafeArea()
//
//            ScrollView(.vertical, showsIndicators: false) {
//                VStack {
//                    headerSection
//                    calculationsScrollView
//                    friendsSection
//                    goalTypeTabs
//                    if selectedTab == "Qattah" {
//                        qattahView
//                    } else {
//                        challengeView
//                    }
//                    cashTrackSection
//                }
//            }
//        }
//        .fullScreenCover(isPresented: $showGoalSelectionView) {
//            GoalSelectionView()
//        }
//        .sheet(isPresented: $showEditSheet) {
//            editGoalSheet
//        }
//    }
//
//    private var headerSection: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            HStack {
//                Image(systemName: "person.circle.fill")
//                    .resizable()
//                    .frame(width: 40, height: 40)
//                    .symbolRenderingMode(.palette)
//                    .foregroundStyle(Color(hex: "290B83"), Color(hex: "4B7EDA"))
//                    .padding(.leading, 16)
//
//                Spacer()
//
//                Image(systemName: "plus.circle.fill")
//                    .resizable()
//                    .frame(width: 40, height: 40)
//                    .symbolRenderingMode(.palette)
//                    .foregroundStyle(Color(hex: "290B83"), Color(hex: "4B7EDA"))
//                    .padding(.trailing, 16)
//                    .onTapGesture {
//                        showGoalSelectionView = true
//                    }
//            }
//
//            HStack {
//                Text("Goals")
//                    .font(.title2)
//                    .bold()
//                    .foregroundColor(.white)
//                    .padding(.leading, 16)
//
//                Spacer()
//
//                Button(action: {
//                    withAnimation {
//                        isSelectingCalculations.toggle()
//                        if !isSelectingCalculations {
//                            selectedCalculations.removeAll()
//                        } else {
//                            showDeleteSheet = true
//                        }
//                    }
//                }) {
//                    Text("Select")
//                        .font(.body)
//                        .bold()
//                        .foregroundColor(.blue)
//                }
//                .padding(.trailing, 16)
//            }
//        }
//    }
//
//    private var calculationsScrollView: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 16) {
//                ForEach(viewModel.calculations, id: \.id) { calculation in
//                    CalculationCard(calculation: calculation)
//                }
//            }
//            .padding(.horizontal, 16)
//        }
//    }
//
//    private var friendsSection: some View {
//        HStack {
//            Text("Friends")
//                .font(.title2)
//                .bold()
//                .foregroundColor(.white)
//                .padding(.leading, 16)
//            Spacer()
//        }
//        .padding(.top, 20)
//    }
//
//    private var goalTypeTabs: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack(spacing: 30) {
//                Button(action: { withAnimation { selectedTab = "Qattah" } }) {
//                    Text("Qattah")
//                        .font(.headline)
//                        .bold()
//                        .foregroundColor(selectedTab == "Qattah" ? .white : .gray)
//                }
//
//                Button(action: { withAnimation { selectedTab = "Challenge" } }) {
//                    Text("Challenge")
//                        .font(.headline)
//                        .bold()
//                        .foregroundColor(selectedTab == "Challenge" ? .white : .gray)
//                }
//            }
//            .padding(.horizontal, 26)
//        }
//        .padding(.top, 5)
//    }
//
//    private var cashTrackSection: some View {
//        HStack {
//            Text("CashTrack")
//                .font(.title2)
//                .bold()
//                .foregroundColor(.white)
//                .padding(.leading, 16)
//            Spacer()
//        }
//        .padding(.top, 20)
//    }
//
//    private var qattahView: some View {
//        Text("Qattah View Content Here")
//            .foregroundColor(.white)
//    }
//
//    private var challengeView: some View {
//        Text("Challenge View Content Here")
//            .foregroundColor(.white)
//    }
//
//    private var editGoalSheet: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            Capsule()
//                .frame(width: 40, height: 5)
//                .foregroundColor(.white.opacity(0.6))
//                .padding(.top, 10)
//
//            Text("Edit Goal")
//                .font(.title)
//                .bold()
//                .foregroundColor(.white)
//                .padding(.horizontal)
//
//            TextField("Enter Amount", text: $newAmount)
//                .keyboardType(.numberPad)
//                .padding()
//                .background(Color(hex: "1A0F66"))
//                .cornerRadius(10)
//                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
//                .padding(.horizontal)
//
//            Button {
//                guard let amount = Double(newAmount), let selectedCalc = selectedCalculationToEdit else { return }
//
//                let updatedCalculation = Calculation(
//                    record: CKRecord, id: selectedCalc.id,
//                    goalName: selectedCalc.goalName,
//                    cost: selectedCalc.cost,
//                    salary: amount,
//                    savingsType: selectedCalc.savingsType,
//                    savingsRequired: selectedCalc.savingsRequired,
//                    emoji: selectedCalc.emoji
//                )
//
//                Task {
//                    await viewModel.updateCalculation(calculation: updatedCalculation)
//                }
//
//                showEditSheet = false
//                selectedCalculationToEdit = nil
//            } label: {
//                Text("Save")
//                    .font(.body)
//                    .bold()
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(15)
//            }
//            .padding(.horizontal)
//
//            Spacer()
//        }
//    }
//}
//
//struct CalculationCard: View {
//    let calculation: Calculation
//
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            RoundedRectangle(cornerRadius: 15)
//                .fill(Color.white.opacity(0.2))
//                .frame(width: 220, height: 140)
//                .shadow(radius: 4)
//
//            VStack(alignment: .leading) {
//                Text(calculation.goalName)
//                    .font(.caption)
//                    .foregroundColor(.white.opacity(0.8))
//                    .bold()
//
//                Text("$\(Int(calculation.cost))")
//                    .font(.title3)
//                    .bold()
//                    .foregroundColor(.white)
//            }
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    View3()
//}



    
    
    //
    //
    ////
    ////  ContentView.swift
    ////  Cashi
    ////
    ////  Created by Ghala Alnemari on 24/08/1446 AH.
    //import SwiftUI
    //import CloudKit
    //
    //struct View3: View {
    //    @State private var selectedTab: String = "Qattah"
    //    @State private var showFullTracker = false
    //    @State private var showGoalSelectionView = false
    //    @StateObject private var viewModel = ViewModel2(user: nil) // جلب البيانات من CloudKit
    //    @State private var updatingCalculationID: String?
    //    @State private var updatingGoalID: CKRecord.ID? // ✅ تتبع الهدف الذي يتم تحديثه حالياً
    //    @State private var isSelectingCalculations = false
    //    // استخدام معرّف السجل بدلاً من goalName لتحديد الحسابات المختارة
    //    @State private var selectedCalculationIDs = Set<CKRecord.ID>()
    //
    //    var body: some View {
    //        ZStack {
    //            // الخلفية المتدرجة
    //            LinearGradient(gradient: Gradient(colors: [
    //                Color(hex: "1F0179"),
    //                Color(hex: "160158"),
    //                Color(hex: "0E0137")
    //            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
    //            .ignoresSafeArea()
    //
    //            ScrollView(.vertical, showsIndicators: false) {
    //                VStack {
    //                    // ✅ العناصر العلوية
    //                    VStack(alignment: .leading, spacing: 16) {
    //                        HStack {
    //                            Image(systemName: "person.circle.fill")
    //                                .resizable()
    //                                .frame(width: 40, height: 40)
    //                                .symbolRenderingMode(.palette)
    //                                .foregroundStyle(Color(hex: "290B83"), Color(hex: "4B7EDA"))
    //                                .padding(.leading, 16)
    //
    //                            Spacer()
    //
    //
    //                        }
    //
    //                        // عنوان "Goals" وزر "Select" + زر "Delete Selected" عند التحديد
    //                        HStack {
    //                            Text("Goals")
    //                                .font(.title2)
    //                                .bold()
    //                                .foregroundColor(.white)
    //                                .padding(.leading, 16)
    //
    //                            Spacer()
    //
    //                            // زر "Delete Selected" يظهر عند التحديد ووجود سجلات مختارة
    //                            if isSelectingCalculations && !selectedCalculationIDs.isEmpty {
    //                                Button(action: {
    //                                    Task {
    //                                        for calcID in selectedCalculationIDs {
    //                                            if let calc = viewModel.calculations.first(where: { $0.id == calcID }) {
    //                                                await viewModel.deleteCalculation(calculation: calc)
    //                                            }
    //                                        }
    //                                        selectedCalculationIDs.removeAll()
    //                                        isSelectingCalculations = false
    //                                    }
    //                                }) {
    //                                    Text("Delete Selected")
    //                                        .font(.body)
    //                                        .bold()
    //                                        .foregroundColor(.red)
    //                                }
    //                                .padding(.trailing, 8)
    //                            }
    //
    //                            // زر "Select" لتفعيل أو إيقاف وضع التحديد
    //                            Button(action: {
    //                                withAnimation {
    //                                    isSelectingCalculations.toggle()
    //                                    if !isSelectingCalculations {
    //                                        selectedCalculationIDs.removeAll()
    //                                    }
    //                                }
    //                            }) {
    //                                Text("Select")
    //                                    .font(.body)
    //                                    .bold()
    //                                    .foregroundColor(.blue)
    //                            }
    //                            .padding(.trailing, 16)
    //                        }
    //                    }
    //
    //                    // ✅ شريط الصور - عرض سجلات Calculations
    //                    ScrollView(.horizontal, showsIndicators: false) {
    //                        HStack(spacing: 16) {
    //                            // استخدم id: \.id بدلاً من goalName للحصول على قيمة فريدة
    //                            ForEach(viewModel.calculations, id: \.id) { calculation in
    //                                ZStack(alignment: .topLeading) {
    //                                    // خلفية البطاقة
    //                                    RoundedRectangle(cornerRadius: 15)
    //                                        .fill(Color.white.opacity(0.2))
    //                                        .frame(width: 220, height: 140)
    //                                        .shadow(radius: 4)
    //
    //                                    // عرض صورة الهدف: البحث عن Goal مطابق باستخدام goalName مع تجاهل المسافات والحالة
    //                                    if let matchedGoal = viewModel.goals.first(where: {
    //                                        $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ==
    //                                        calculation.goalName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    //                                    }) {
    //                                        if let imageData = matchedGoal.imageData,
    //                                           let uiImage = UIImage(data: imageData) {
    //                                            Image(uiImage: uiImage)
    //                                                .resizable()
    //                                                .scaledToFill()
    //                                                .frame(width: 220, height: 140)
    //                                                .clipShape(RoundedRectangle(cornerRadius: 15))
    //                                        } else {
    //                                            Text(calculation.emoji)
    //                                                .font(.system(size: 40))
    //                                                .frame(width: 220, height: 140)
    //                                                .background(Color.black.opacity(0.3))
    //                                                .clipShape(RoundedRectangle(cornerRadius: 15))
    //                                        }
    //                                    } else {
    //                                        Text(calculation.emoji)
    //                                            .font(.system(size: 40))
    //                                            .frame(width: 220, height: 140)
    //                                            .background(Color.black.opacity(0.3))
    //                                            .clipShape(RoundedRectangle(cornerRadius: 15))
    //                                    }
    //
    //                                    // معلومات الحساب
    //                                    VStack(alignment: .leading) {
    //                                        Text(calculation.goalName)
    //                                            .font(.caption)
    //                                            .foregroundColor(.white.opacity(0.8))
    //                                            .bold()
    //
    //                                        Text("$\(Int(calculation.cost))")
    //                                            .font(.title3)
    //                                            .bold()
    //                                            .foregroundColor(.white)
    //
    //
    //
    //                                        Text("\(calculateProgress(calculation: calculation))% ")
    //                                            .font(.caption)
    //                                            .bold()
    //                                            .foregroundColor(.white.opacity(0.8))
    //                                    }
    //                                    .padding()
    //                                    .clipShape(RoundedRectangle(cornerRadius: 10))
    //                                    .padding(10)
    //
    //                                    // شريط التقدم وأزرار التحكم
    //                                    VStack {
    //                                        Spacer()
    //                                        HStack {
    //                                            // زر نقصان (-)
    //                                            Button(action: {
    //                                                updateCalculationProgress(calculation: calculation, increase: false)
    //                                            }) {
    //                                                Circle()
    //                                                    .fill(Color.blue)
    //                                                    .frame(width: 30, height: 30)
    //                                                    .overlay(
    //                                                        Image(systemName: "minus")
    //                                                            .foregroundColor(.white)
    //                                                    )
    //                                            }
    //                                            .padding(.leading, 10)
    //
    //                                            VStack {
    //                                                ProgressView(value: calculateProgress(calculation: calculation) / 100, total: 1.0)
    //                                                    .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
    //                                                    .frame(width: 130)
    //                                                    .animation(.easeInOut, value: calculateProgress(calculation: calculation))
    //                                            }
    //
    //                                            // زر زيادة (+)
    //                                            Button(action: {
    //                                                updateCalculationProgress(calculation: calculation, increase: true)
    //                                            }) {
    //                                                Circle()
    //                                                    .fill(Color.blue)
    //                                                    .frame(width: 30, height: 30)
    //                                                    .overlay(
    //                                                        Image(systemName: "plus")
    //                                                            .foregroundColor(.white)
    //                                                    )
    //                                            }
    //                                            .padding(.trailing, 10)
    //                                        }
    //                                        .padding(.bottom, 10)
    //                                    }
    //
    //                                    // عند تفعيل وضع التحديد، عرض أيقونة الاختيار في أعلى يمين البطاقة
    //                                    if isSelectingCalculations {
    //                                        let isSelected = selectedCalculationIDs.contains(calculation.id)
    //                                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
    //                                            .resizable()
    //                                            .frame(width: 24, height: 24)
    //                                            .foregroundColor(isSelected ? .blue : .white)
    //                                            .padding(8)
    //                                            .onTapGesture {
    //                                                if isSelected {
    //                                                    selectedCalculationIDs.remove(calculation.id)
    //                                                } else {
    //                                                    selectedCalculationIDs.insert(calculation.id)
    //                                                }
    //                                            }
    //                                    }
    //
    //
    //                        }
    //                        .padding(.horizontal, 16)
    //                    }
    //
    //                    Button(action: {
    //                                showGoalSelectionView = true
    //                            }) {
    //                                ZStack {
    //                                    RoundedRectangle(cornerRadius: 15)
    //                                        .fill(Color.white.opacity(0.2))
    //                                        .frame(width: 220, height: 140)
    //                                        .shadow(radius: 4)
    //
    //                                    VStack {
    //                                        ZStack {
    //                                            Circle()
    //                                                .fill(Color.blue.opacity(0.8))
    //                                                .frame(width: 50, height: 50)
    //
    //                                            Image(systemName: "plus")
    //                                                .resizable()
    //                                                .frame(width: 24, height: 24)
    //                                                .foregroundColor(.white)
    //                                        }
    //
    //                                        Text("Add Goals")
    //                                            .font(.headline)
    //                                            .bold()
    //                                            .foregroundColor(.white.opacity(0.8))
    //                                    }
    //                                }
    //                            }
    //                            .fullScreenCover(isPresented: $showGoalSelectionView) {
    //                                GoalSelectionView()
    //                            }
    //                        }
    //                        .padding(.horizontal, 16)
    //                    }
    //
    //
    //                    // ✅ "Friends"
    //                    HStack {
    //                        Text("Friends")
    //                            .font(.title2)
    //                            .bold()
    //                            .foregroundColor(.white)
    //                            .padding(.leading, 16)
    //
    //                        Spacer()
    //                    }
    //                    .padding(.top, 20)
    //
    //                    // ✅ التبويبات بين "Qattah" و "Challenge"
    //                    VStack(alignment: .leading, spacing: 8) {
    //                        HStack(spacing: 30) {
    //                            Button(action: { withAnimation { selectedTab = "Qattah" } }) {
    //                                Text("Qattah")
    //                                    .font(.headline)
    //                                    .bold()
    //                                    .foregroundColor(selectedTab == "Qattah" ? .white : .gray)
    //                            }
    //
    //                            Button(action: { withAnimation { selectedTab = "Challenge" } }) {
    //                                Text("Challenge")
    //                                    .font(.headline)
    //                                    .bold()
    //                                    .foregroundColor(selectedTab == "Challenge" ? .white : .gray)
    //                            }
    //                        }
    //                        .padding(.horizontal, 26)
    //
    //                        // ✅ الخط الأزرق
    //                        ZStack(alignment: .leading) {
    //                            Rectangle()
    //                                .frame(height: 2)
    //                                .foregroundColor(.blue.opacity(0.5))
    //                                .frame(maxWidth: .infinity)
    //
    //                            RoundedRectangle(cornerRadius: 5)
    //                                .frame(width: selectedTab == "Qattah" ? 70 : 95, height: 4)
    //                                .foregroundColor(.white)
    //                                .offset(x: selectedTab == "Qattah" ? 0 : 85)
    //                        }
    //                        .frame(maxWidth: .infinity)
    //                        .padding(.leading, 16)
    //                    }
    //                    .padding(.top, 5)
    //
    //                    // ✅ جعل QattahView قابلة للتمرير بالكامل
    //                    ScrollView(.horizontal, showsIndicators: false) {
    //                        HStack(spacing: 16) {
    //                            if selectedTab == "Qattah" {
    //                                ZStack {
    //                                    RoundedRectangle(cornerRadius: 15)
    //                                        .fill(Color(hex: "290B83"))
    //                                        .frame(width: 240, height: 300)
    //                                        .shadow(radius: 4)
    //
    //                                    ScrollView(.vertical, showsIndicators: false) {
    //                                        VStack(alignment: .leading, spacing: 10) {
    //                                            HStack {
    //                                                Spacer()
    //                                                Image(systemName: "ellipsis")
    //                                                    .resizable()
    //                                                    .frame(width: 22, height: 5)
    //                                                    .foregroundColor(.gray)
    //                                                    .padding(.trailing, 14)
    //                                                    .padding(.top, 20)
    //                                            }
    //
    //                                            VStack(alignment: .leading) {
    //                                                HStack {
    //                                                    ZStack {
    //                                                        Circle()
    //                                                            .stroke(lineWidth: 6)
    //                                                            .foregroundColor(.gray.opacity(0.3))
    //                                                            .frame(width: 60, height: 60)
    //
    //                                                        Circle()
    //                                                            .trim(from: 0, to: 0.2)
    //                                                            .stroke(Color(hex: "007AFF"), lineWidth: 6)
    //                                                            .frame(width: 60, height: 60)
    //                                                            .rotationEffect(.degrees(-90))
    //
    //                                                        Text("🏡")
    //                                                            .font(.title3)
    //                                                    }
    //                                                    Spacer()
    //                                                }
    //                                                .padding(.leading, 12)
    //
    //                                                Text("20% Achieved")
    //                                                    .font(.headline)
    //                                                    .bold()
    //                                                    .foregroundColor(.white)
    //                                                    .padding(.leading, 12)
    //                                                    .padding(.top, 3)
    //                                            }
    //
    //                                            VStack(alignment: .leading, spacing: 12) {
    //                                                ForEach([
    //                                                    ("Sara", 5),
    //                                                    ("Yara", 30),
    //                                                    ("Talal", 35),
    //                                                    ("Ghala", 10)
    //                                                ], id: \.0) { user in
    //                                                    VStack(alignment: .leading) {
    //                                                        Text(user.0)
    //                                                            .font(.subheadline)
    //                                                            .foregroundColor(.white)
    //
    //                                                        ZStack(alignment: .leading) {
    //                                                            RoundedRectangle(cornerRadius: 20)
    //                                                                .frame(height: 20)
    //                                                                .foregroundColor(.gray.opacity(0.3))
    //
    //                                                            RoundedRectangle(cornerRadius: 20)
    //                                                                .frame(width: max(CGFloat(user.1) * 2.5, 30), height: 20)
    //                                                                .foregroundColor(Color(hex: "007AFF"))
    //
    //                                                            HStack {
    //                                                                Image(systemName: "person.circle.fill")
    //                                                                    .resizable()
    //                                                                    .frame(width: 20, height: 20)
    //                                                                    .clipShape(Circle())
    //                                                                    .foregroundColor(.white)
    //                                                                    .padding(.leading, 4)
    //
    //                                                                Spacer()
    //
    //                                                                Text("\(user.1)%")
    //                                                                    .font(.caption2)
    //                                                                    .bold()
    //                                                                    .foregroundColor(.white)
    //                                                                    .padding(.trailing, 8)
    //                                                            }
    //                                                        }
    //                                                    }
    //                                                }
    //                                            }
    //                                            .padding(.horizontal, 15)
    //                                        }
    //                                    }
    //                                }
    //                                .frame(width: 240, height: 300)
    //                                .padding(.leading, 16)
    //                            }
    //                            else if selectedTab == "Challenge" {
    //                                HStack(spacing: 25) {
    //
    //                                    ForEach([
    //                                        ("Ali", "profile4", 75),
    //                                        ("Reem", "profile5", 50),
    //                                        ("Omar", "profile6", 90)
    //                                    ], id: \.0) { user in
    //                                        VStack(spacing: 3) { // ✅ تقليل التباعد بين العناصر
    //                                            ZStack {
    //                                                Circle()
    //                                                    .stroke(lineWidth: 6)
    //                                                    .foregroundColor(.gray.opacity(0.3))
    //                                                    .frame(width: 90, height: 90)
    //
    //                                                Circle()
    //                                                    .trim(from: 0, to: CGFloat(user.2) / 100)
    //                                                    .stroke(Color(hex: "007AFF"), lineWidth: 6)
    //                                                    .frame(width: 90, height: 90)
    //                                                    .rotationEffect(.degrees(-90))
    //
    //                                                Image(user.1)
    //                                                    .resizable()
    //                                                    .scaledToFill()
    //                                                    .frame(width: 65, height: 65)
    //                                                    .clipShape(Circle())
    //                                                    .padding(5)
    //                                            }
    //
    //                                            Text(user.0)
    //                                                .font(.caption)
    //                                                .foregroundColor(.white)
    //                                                .bold()
    //
    //                                            Text("\(user.2)% achieved")
    //                                                .font(.caption2)
    //                                                .foregroundColor(.white)
    //                                        }
    //                                        .padding(.horizontal, 8)
    //                                    }
    //                                }
    //                                .padding(.top, -20)
    //                            }
    //
    //
    //
    //                    Button(action: {
    //                                        showGoalSelectionView = true
    //                                    }) {
    //                                        ZStack {
    //                                            RoundedRectangle(cornerRadius: 15)
    //                                                .fill(Color(hex: "290B83"))
    //                                                .frame(width: 240, height: 300)
    //                                                .shadow(radius: 4)
    //
    //                                            VStack {
    //                                                ZStack {
    //                                                    Circle()
    //                                                        .fill(Color.blue.opacity(0.8))
    //                                                        .frame(width: 50, height: 50)
    //
    //                                                    Image(systemName: "plus")
    //                                                        .resizable()
    //                                                        .frame(width: 24, height: 24)
    //                                                        .foregroundColor(.white)
    //                                                }
    //
    //                                                Text("Add Challenge")
    //                                                    .font(.headline)
    //                                                    .bold()
    //                                                    .foregroundColor(.white.opacity(0.8))
    //                                            }
    //                                        }
    //                                    }
    //                                    .fullScreenCover(isPresented: $showGoalSelectionView) {
    //                                        GoalSelectionView() // ✅ نفس الصفحة المستخدمة في "إضافة هدف"
    //                                    }
    //                                }
    //                                .padding(.top, -20)
    //                            }
    //
    //
    //                    // ✅ "CashTrack" مثل "Friends" و "Goals"
    //                    HStack {
    //                        Text("CashTrack")
    //                            .font(.title2)
    //                            .bold()
    //                            .foregroundColor(.white)
    //                            .padding(.leading, 16)
    //
    //                        Spacer()
    //                    }
    //                    .padding(.top, 20)
    //
    //                    CashTrackerView()
    //                        .onTapGesture {
    //                            showFullTracker = true // ✅ عند الضغط، تفتح الصفحة الكاملة
    //                        }
    //                }
    //            }
    //        }
    //        .fullScreenCover(isPresented: $showFullTracker) {
    //            CashTrackerView()
    //        }
    //    }
    //
    //    private func calculateProgress(calculation: Calculation) -> Double {
    //        let progress = (calculation.salary / calculation.cost) * 100
    //        return progress > 100 ? 100 : progress
    //    }
    //
    //    // دالة تحديث الحساب (Calculation) في iCloud مع تحديث الواجهة فورًا
    //    private func updateCalculationProgress(calculation: Calculation, increase: Bool) {
    //        Task {
    //            var newSalary = calculation.salary
    //            let increment = calculation.cost * 0.05 // زيادة أو نقصان 5% من التكلفة الإجمالية
    //
    //            if increase {
    //                newSalary += increment
    //            } else {
    //                newSalary = max(0, newSalary - increment)
    //            }
    //
    //            let updatedCalculation = Calculation(
    //                id: calculation.id,
    //                goalName: calculation.goalName,
    //                cost: calculation.cost,
    //                salary: newSalary,
    //                savingsType: calculation.savingsType,
    //                savingsRequired: calculation.savingsRequired,
    //                emoji: calculation.emoji
    //            )
    //
    //            // 1) تحديث المصفوفة محليًا ليظهر التغيير مباشرةً
    //            if let index = viewModel.calculations.firstIndex(where: { $0.id == calculation.id }) {
    //                viewModel.calculations[index] = updatedCalculation
    //            }
    //
    //            // 2) حفظ التحديث في iCloud
    //            await viewModel.updateCalculation(calculation: updatedCalculation)
    //        }
    //    }
    //}
    //
    //#Preview {
    //    View3()
    //}

