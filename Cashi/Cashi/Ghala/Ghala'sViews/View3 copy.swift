//
//  View3 2.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//
//
//
//import SwiftUI
//import CloudKit
//
//struct View3: View {
//    @State private var selectedTab: String = "Qattah"
//    @State private var showFullTracker = false
////    @StateObject private var viewModel = ViewModel2(user: nil)
//    @ObservedObject var viewModel: ViewModel2
//    @State private var showGoalSelectionView = false
//    @State private var updatingCalculationID: String?
//    @State private var updatingGoalID: CKRecord.ID?
//    @State private var isSelectingCalculations = false
//    @State private var selectedGoalToEdit: Goal? // تعديل النوع ليكون Goal وليس Calculation
//
//    @State private var isSelectingGoals = false // تعريف المتغير
////    @State private var selectedCalculations = [Calculation]()
//    @State private var selectedGoals = [Goal]()
//    @State private var showDeleteSheet = false
//    @State private var showEditSheet = false
//    @State private var newAmount: String = ""
//    @State private var shouldOpenEditSheet = false
//    @State private var selectedCalculationToEdit: Calculation?
//    @State private var showOptionsSheet = false
//    @State private var selectedCategory: String = "Main" // أو أي خيار تريده
//    @State private var showQattahOptionsSheet = false
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
//                            Image(systemName: "plus.circle.fill")
//                                .resizable()
//                                .frame(width: 40, height: 40)
//                                .symbolRenderingMode(.palette)
//                                .foregroundStyle(Color(hex: "290B83"), Color(hex: "4B7EDA"))
//                                .padding(.trailing, 16)
//                                .onTapGesture {
//                                    showGoalSelectionView = true
//                                }
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
//                            // ✅ زر "Select" لتفعيل أو إيقاف وضع التحديد
//                            Button(action: {
//                                withAnimation {
//                                    isSelectingCalculations.toggle()
//                                    if !isSelectingCalculations {
//                                        selectedGoals.removeAll()
//                                    } else {
//                                        showDeleteSheet = true
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
//                            // استخدم `viewModel.goals` مباشرة في `ForEach`
//                            ForEach(viewModel.goal, id: \.id) { goals in
//                                ZStack(alignment: .topLeading) {
//                                    // خلفية البطاقة
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .fill(Color.white.opacity(0.2))
//                                        .frame(width: 220, height: 140)
//                                        .shadow(radius: 4)
//
//                                    // عرض صورة الهدف أو النص في حال عدم وجود الصورة
//                                    if let imageData = goals.imageData, let uiImage = UIImage(data: imageData) {
//                                        Image(uiImage: uiImage)
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 220, height: 140)
//                                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                                    } else {
//                                        Text(goals.emoji)
//                                            .font(.system(size: 40))
//                                            .frame(width: 220, height: 140)
//                                            .background(Color.black.opacity(0.3))
//                                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                                    }
//
//                                    // معلومات الحساب
//                                    VStack(alignment: .leading) {
//                                        Text(goals.name)
//                                            .font(.caption)
//                                            .foregroundColor(.white.opacity(0.8))
//                                            .bold()
//
//                                        Text("$\(Int(goals.cost))")
//                                            .font(.title3)
//                                            .bold()
//                                            .foregroundColor(.white)
//
////                                        Text("\(calculateProgress(goal: goal))%")
////                                            .font(.caption)
////                                            .bold()
////                                            .foregroundColor(.white.opacity(0.8))
//                                    }
//                                    .padding()
//                                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                                    .padding(10)
//                                }
//                            }
//                        }
//                        .padding(.horizontal, 16)
//                    }
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
//                                ZStack(alignment: .topTrailing) {
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .fill(Color(hex: "290B83"))
//                                        .frame(width: 240, height: 300)
//                                        .shadow(radius: 4)
//                                    
//                                    // ✅ زر الثلاث نقاط خارج ScrollView لضمان التفاعل
//                                    Button(action: {
//                                        showOptionsSheet = true
//                                    }) {
//                                        Image(systemName: "ellipsis")
//                                            .resizable()
//                                            .frame(width: 22, height: 5)
//                                            .foregroundColor(.white)
//                                            .padding(12)
//                                    }
//                                    .zIndex(2)
//                                    
//                                    ScrollView(.vertical, showsIndicators: false) {
//                                        VStack(alignment: .leading, spacing: 10) {
//                                            // ✅ باقي محتوى البطاقة (Progress و الأصدقاء)
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
//                                HStack(spacing: 25) { // ✅ ترتيب العناصر في صف مع تباعد مناسب
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
//                        }
//                    }
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
//        .fullScreenCover(isPresented: $showGoalSelectionView) {
//            GoalSelectionView()
//            
//        }
//        
//        .sheet(isPresented: Binding<Bool>(
//            get: { !selectedGoals.isEmpty },
//            set: { newValue in
//                if !newValue {
//                    selectedGoals.removeAll()
//                    isSelectingCalculations = false
//                }
//            }
//        )) {
//            VStack(spacing: 20) {
//                Capsule()
//                    .frame(width: 40, height: 5)
//                    .foregroundColor(.white.opacity(0.6))
//                    .padding(.top, 10)
//                
//                // ✅ زر التعديل
//                if var selectedGoal = selectedGoals.first {
//                    Button {
//                        newAmount = String(Int(selectedGoal.cost))
//                        selectedGoalToEdit = selectedGoal
//                        shouldOpenEditSheet = true
//                        // إغلاق هذا الشيت لفتح شيت التعديل لاحقًا
//                        selectedGoals.removeAll()
//                    } label: {
//                        HStack {
//                            Text("Edit")
//                                .font(.body)
//                                .bold()
//                                .foregroundColor(.white)
//                            Spacer()
//                            Image(systemName: "pencil")
//                                .foregroundColor(.white)
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.white.opacity(0.1))
//                        .cornerRadius(15)
//                    }
//                    .padding(.horizontal)
//                }
//                
//                // ✅ زر الحذف
//                Button(role: .destructive) {
//                 
//                        selectedGoals.removeAll() // إزالة الأهداف المحددة بعد الحذف
//                        isSelectingGoals = false // إعادة تعيين وضع التحديد
//                    
//                } label: {
//                    HStack {
//                        Text("Delete")
//                            .font(.body)
//                            .bold()
//                            .foregroundColor(.red)
//                        Spacer()
//                        Image(systemName: "trash")
//                            .foregroundColor(.red)
//                    }
//                
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(15)
//                }
//                .padding(.horizontal)
//                
//                Spacer()
//            }
//            .padding()
//            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [Color(hex: "24326D"), Color(hex: "160158")]),
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                .ignoresSafeArea()
//            )
//            .presentationDetents([.fraction(0.25)])
//            .interactiveDismissDisabled(false)
//            .onDisappear {
//                // بعد إغلاق الشيت، افتح شيت التعديل إن لزم
//                if shouldOpenEditSheet {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                        showEditSheet = true
//                        shouldOpenEditSheet = false
//                    }
//                }
//            }
//        }
//        
//        .sheet(isPresented: $showEditSheet) {
//            VStack(alignment: .leading, spacing: 20) {
//                Capsule()
//                    .frame(width: 40, height: 5)
//                    .foregroundColor(.white.opacity(0.6))
//                    .padding(.top, 10)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                
//                Text("Edit Goal")
//                    .font(.title)
//                    .bold()
//                    .foregroundColor(.white)
//                    .padding(.horizontal)
//                
//                Text("Enter Amount")
//                    .foregroundColor(.white)
//                    .padding(.horizontal)
//                
//                TextField("Enter Amount", text: $newAmount)
//                    .keyboardType(.numberPad)
//                    .padding()
//                    .background(Color(hex: "1A0F66")) // نفس لون المثال بالصورة
//                    .cornerRadius(10)
//                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
//                    .padding(.horizontal)
//                
//                // زر الحفظ
//                Button {
//                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                    
//                    guard let amount = Double(newAmount),
//                          var selectedCalc = selectedCalculationToEdit else {
//                        print("❌ لم يتم العثور على calculation")
//                        return
//                    }
//                    
////                    selectedGoals.cost = amount
//                    
//                    if let index = viewModel.calculations.firstIndex(where: { $0.id == selectedCalc.id }) {
//                        viewModel.calculations[index] = selectedCalc
//                    }
//                    
////                    Task {
////                        await viewModel.updateCalculation(selectedCalc)
////                    }
//                    
//                    showEditSheet = false
//                    selectedCalculationToEdit = nil
//                } label: {
//                    Text("Save")
//                        .font(.body)
//                        .bold()
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(15)
//                }
//                .padding(.horizontal)
//                
//                Spacer()
//            }
//            .padding()
//            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [Color(hex: "24326D"), Color(hex: "160158")]),
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                .ignoresSafeArea()
//            )
//            .presentationDetents([.fraction(0.75)]) // ✅ ٣/٤ الشاشة
//        }
//        .onChange(of: showDeleteSheet) { newValue in
//            if !newValue && shouldOpenEditSheet {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                    showEditSheet = true
//                    shouldOpenEditSheet = false
//                }
//            }
//        }
//        .sheet(isPresented: $showOptionsSheet) {
//            VStack(spacing: 20) {
//                // المؤشر العلوي
//                Capsule()
//                    .frame(width: 40, height: 5)
//                    .foregroundColor(.white.opacity(0.6))
//                    .padding(.top, 10)
//                
//                // العنوان
//                Text("Edit Your Progress")
//                    .font(.title2)
//                    .bold()
//                    .foregroundColor(.white)
//                
//                // إدخال المبلغ
//                Text("Enter Amount")
//                    .foregroundColor(.white)
//                
//                TextField("Amount", text: $newAmount)
//                    .keyboardType(.numberPad)
//                    .padding()
//                    .background(Color(hex: "1A0F66"))
//                    .cornerRadius(10)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.blue, lineWidth: 1)
//                    )
//                
//                // التقدم الخاص بالأصدقاء
//                Text("Your Friends Progress")
//                    .font(.headline)
//                    .bold()
//                    .foregroundColor(.white)
//                    .padding(.top)
//                
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 20) {
//                        ForEach([
//                            ("Ghala", "person.circle.fill", 0.35),
//                            ("Sara", "person.circle.fill", 0.05),
//                            ("Yara", "person.circle.fill", 0.30),
//                            ("Talal", "person.circle.fill", 0.10)
//                        ], id: \.0) { friend in
//                            VStack(spacing: 8) {
//                                ZStack {
//                                    // الخلفية الأساسية
//                                    RoundedRectangle(cornerRadius: 40)
//                                        .fill(Color.white.opacity(0.1))
//                                        .frame(width: 80, height: 120)
//
//                                    // تعبئة التقدم من الأسفل للأعلى داخل الشكل فقط
//                                    RoundedRectangle(cornerRadius: 40)
//                                        .fill(
//                                            LinearGradient(
//                                                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
//                                                startPoint: .bottom,
//                                                endPoint: .top
//                                            )
//                                        )
//                                        .frame(width: 80, height: 120)
//                                        .mask(
//                                            VStack {
//                                                Spacer()
//                                                RoundedRectangle(cornerRadius: 40)
//                                                    .frame(height: 120 * friend.2)
//                                            }
//                                        )
//
//                                    // الإطار الخارجي الأزرق
//                                    RoundedRectangle(cornerRadius: 40)
//                                        .stroke(Color.blue, lineWidth: 2)
//                                        .frame(width: 80, height: 120)
//
//                                    // صورة البروفايل والنسبة
//                                    VStack(spacing: 6) {
//                                        Image(systemName: friend.1)
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 35, height: 35)
//                                            .foregroundColor(.white)
//
//                                        Text("\(Int(friend.2 * 100))%")
//                                            .font(.footnote)
//                                            .bold()
//                                            .foregroundColor(.white)
//                                    }
//                                }
//
//                                Text(friend.0)
//                                    .foregroundColor(.white)
//                                    .font(.caption)
//                                    .bold()
//                             }
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//
//                Button {
//                    showOptionsSheet = false
//                } label: {
//                    Text("Next")
//                        .font(.body)
//                        .bold()
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(15)
//                }
//
//                Spacer()
//                }
//                .padding()
//                .background(
//                    LinearGradient(
//                        gradient: Gradient(colors: [Color(hex: "24326D"), Color(hex: "160158")]),
//                        startPoint: .top,
//                        endPoint: .bottom
//                    )
//                    .ignoresSafeArea()
//                )
//                .presentationDetents([.fraction(0.75)])
//        }
//    }
//    
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
//        }
//    }
//}
//
//
//
//#Preview {
//    View3()
//}
//
//
//
//
//
//
//
//  ContentView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 24/08/1446 AH.
//import SwiftUI
//import CloudKit
//
//struct View3: View {
//    @State private var selectedTab: String = "Qattah"
//    @State private var showFullTracker = false
//    @StateObject private var viewModel = ViewModel2(user: nil)
//    @State private var selectedGoals: [Goal] = [] // لتخزين الأهداف المحددة
//    @State private var isSelectingCalculations = false
//    @State private var newAmount: String = ""
//    @State private var selectedGoalToEdit: Goal?
//    @State private var shouldOpenEditSheet = false
//    @State private var showEditSheet = false
//    @State private var showDeleteSheet = false
//    @State private var showOptionsSheet = false
//    @State private var isSelectingGoals = false
//    @State private var showProgressSheet = false  // حالة لإظهار الشيت عند الضغط على الثلاث نقاط
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
//                            Image(systemName: "plus.circle.fill")
//                                .resizable()
//                                .frame(width: 40, height: 40)
//                                .symbolRenderingMode(.palette)
//                                .foregroundStyle(Color(hex: "290B83"), Color(hex: "4B7EDA"))
//                                .padding(.trailing, 16)
//                        }
//                        
//                        // ✅ عنوان "Goals" وكلمة "Select"
//                        HStack {
//                            Text("Goals")
//                                .font(.title2)
//                                .bold()
//                                .foregroundColor(.white)
//                                .padding(.leading, 16)
//                            
//                            Spacer()
//                            
//                            Button("Select") {
//                                selectedGoals = [
//                                    Goal(id: CKRecord.ID(recordName: "1"), name: "Goal 1", cost: 100, salary: 50, savingsType: .monthly, emoji: "📱", goalType: .individual, imageData: nil),
//                                    Goal(id: CKRecord.ID(recordName: "2"), name: "Goal 2", cost: 200, salary: 100, savingsType: .monthly, emoji: "💻", goalType: .individual, imageData: nil)
//                                    // يمكنك إضافة أهداف أخرى حسب الحاجة
//                                ]
//                                // التحقق من أنه تم تحديد الأهداف بنجاح
//                                isSelectingCalculations = true
//                            }
//                            .foregroundColor(.blue)
//                            .padding(.trailing, 16)
//                        }
//                    }
//                    
//                    // عرض الشيت الأول عند الضغط على Select
//                    .sheet(isPresented: Binding<Bool>(
//                        get: { !selectedGoals.isEmpty && isSelectingCalculations },
//                        set: { newValue in
//                            if !newValue {
//                                selectedGoals.removeAll()
//                                isSelectingCalculations = false
//                            }
//                        }
//                    )) {
//                        VStack(spacing: 20) {
//                            Capsule()
//                                .frame(width: 40, height: 5)
//                                .foregroundColor(.white.opacity(0.6))
//                                .padding(.top, 10)
//                            
//                            // ✅ زر التعديل
//                            if var selectedGoal = selectedGoals.first {
//                                Button {
//                                    newAmount = String(Int(selectedGoal.cost))
//                                    selectedGoalToEdit = selectedGoal
//                                    shouldOpenEditSheet = true
//                                    // إغلاق هذا الشيت لفتح شيت التعديل لاحقًا
//                                    selectedGoals.removeAll()
//                                } label: {
//                                    HStack {
//                                        Text("Edit")
//                                            .font(.body)
//                                            .bold()
//                                            .foregroundColor(.white)
//                                        Spacer()
//                                        Image(systemName: "pencil")
//                                            .foregroundColor(.white)
//                                    }
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(Color.white.opacity(0.1))
//                                    .cornerRadius(15)
//                                }
//                                .padding(.horizontal)
//                            }
//                            
//                            // ✅ زر الحذف
//                            Button(role: .destructive) {
//                                selectedGoals.removeAll() // إزالة الأهداف المحددة بعد الحذف
//                                isSelectingGoals = false // إعادة تعيين وضع التحديد
//                            } label: {
//                                HStack {
//                                    Text("Delete")
//                                        .font(.body)
//                                        .bold()
//                                        .foregroundColor(.red)
//                                    Spacer()
//                                    Image(systemName: "trash")
//                                        .foregroundColor(.red)
//                                }
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.white.opacity(0.1))
//                                .cornerRadius(15)
//                            }
//                            .padding(.horizontal)
//                            
//                            Spacer()
//                        }
//                        .padding()
//                        .background(
//                            LinearGradient(
//                                gradient: Gradient(colors: [Color(hex: "24326D"), Color(hex: "160158")]),
//                                startPoint: .top,
//                                endPoint: .bottom
//                            )
//                            .ignoresSafeArea()
//                        )
//                        .presentationDetents([.fraction(0.25)])
//                        .interactiveDismissDisabled(false)
//                        .onDisappear {
//                            // بعد إغلاق الشيت، افتح شيت التعديل إن لزم
//                            if shouldOpenEditSheet {
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                    showEditSheet = true
//                                    shouldOpenEditSheet = false
//                                }
//                            }
//                        }
//                    }
//                    
//                    // عرض الشيت الثاني عند الضغط على Edit
//                    .sheet(isPresented: $showEditSheet) {
//                        VStack(alignment: .leading, spacing: 20) {
//                            Capsule()
//                                .frame(width: 40, height: 5)
//                                .foregroundColor(.white.opacity(0.6))
//                                .padding(.top, 10)
//                                .frame(maxWidth: .infinity, alignment: .center)
//                            
//                            Text("Edit Goal")
//                                .font(.title)
//                                .bold()
//                                .foregroundColor(.white)
//                                .padding(.horizontal)
//                            
//                            Text("Enter Amount")
//                                .foregroundColor(.white)
//                                .padding(.horizontal)
//                            
//                            TextField("Enter Amount", text: $newAmount)
//                                .keyboardType(.numberPad)
//                                .padding()
//                                .background(Color(hex: "1A0F66")) // نفس لون المثال بالصورة
//                                .cornerRadius(10)
//                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
//                                .padding(.horizontal)
//                            
//                            // زر الحفظ
//                            Button {
//                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                                
//                                guard let amount = Double(newAmount),
//                                      var selectedCalc = selectedGoalToEdit else {
//                                    print("❌ لم يتم العثور على calculation")
//                                    return
//                                }
//                                
//                                //                                if let index = viewModel.calculations.firstIndex(where: { $0.id == selectedCalc.id }) {
//                                //                                    viewModel.calculations[index] = selectedCalc
//                                //                                }
//                                
//                                showEditSheet = false
//                                selectedGoalToEdit = nil
//                            } label: {
//                                Text("Save")
//                                    .font(.body)
//                                    .bold()
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(Color.blue)
//                                    .foregroundColor(.white)
//                                    .cornerRadius(15)
//                            }
//                            .padding(.horizontal)
//                            
//                            Spacer()
//                        }
//                        .padding()
//                        .background(
//                            LinearGradient(
//                                gradient: Gradient(colors: [Color(hex: "24326D"), Color(hex: "160158")]),
//                                startPoint: .top,
//                                endPoint: .bottom
//                            )
//                            .ignoresSafeArea()
//                        )
//                        .presentationDetents([.fraction(0.75)]) // ✅ ٣/٤ الشاشة
//                    }
//                }
//                
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 16) {
//                        // Loop through goals array and display only goals with goalType "individual"
//                        ForEach(viewModel.goals.filter { $0.goalType == .individual }, id: \.id) { goal in
//                            VStack {
//                                ZStack(alignment: .topLeading) {
//                                    // Display image if available
//                                    if let imageData = goal.imageData, let uiImage = UIImage(data: imageData) {
//                                        Image(uiImage: uiImage)
//                                            .resizable()
//                                            .scaledToFill()  // Ensures the image fills the container
//                                            .frame(width: 220, height: 120) // مستطيل: العرض أكبر من الارتفاع
//                                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                                            .overlay(
//                                                Color.black.opacity(0.3) // Dark overlay with transparency
//                                                    .clipShape(RoundedRectangle(cornerRadius: 15)) // Make sure overlay has same shape
//                                            )
//                                    } else {
//                                        // Display a default image if no image data is available
//                                        Image(systemName: "photo")
//                                            .resizable()
//                                            .frame(width: 220, height: 120) // مستطيل: العرض أكبر من الارتفاع
//                                            .scaledToFill()
//                                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                                            .overlay(
//                                                Color.black.opacity(0.3) // Dark overlay with transparency
//                                                    .clipShape(RoundedRectangle(cornerRadius: 15))
//                                            )
//                                    }
//                                    
//                                    // VStack for all text labels inside the image without background
//                                    VStack(alignment: .leading, spacing: 2) {
//                                        Text(goal.name) // Goal name
//                                            .font(.title2) // Increase font size by two steps
//                                            .fontWeight(.bold) // Make the text bold
//                                            .foregroundColor(.white)
//                                            .lineLimit(1) // Prevent text from overflowing
//                                        
//                                        Text("Price: $\(goal.cost, specifier: "%.2f")") // Price
//                                            .font(.caption2) // Smaller font size
//                                            .fontWeight(.bold) // Make the text bold
//                                            .foregroundColor(.white)
//                                            .lineLimit(1) // Prevent text from overflowing
//                                        
//                                        Text("Collected: $\(goal.salary, specifier: "%.2f")") // Collected amount
//                                            .font(.caption2) // Smaller font size
//                                            .fontWeight(.bold) // Make the text bold
//                                            .foregroundColor(.white)
//                                            .lineLimit(1) // Prevent text from overflowing
//                                    }
//                                    .padding(8) // Space around the text
//                                    .frame(width: 220, alignment: .leading) // Ensure the text stays within image width
//                                    // Removed the background color
//                                    .clipShape(RoundedRectangle(cornerRadius: 15)) // Keep the rounded corners
//                                    .padding([.top, .leading], 8) // Position text slightly off the top-left corner
//                                }
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 16)
//                }
//                
//                // ✅ "Friends"
//                HStack {
//                    Text("Friends")
//                        .font(.title2)
//                        .bold()
//                        .foregroundColor(.white)
//                        .padding(.leading, 16)
//                    
//                    Spacer()
//                }
//                .padding(.top, 20)
//                
//                // ✅ التبويبات بين "Qattah" و "Challenge"
//                VStack(alignment: .leading, spacing: 8) {
//                    HStack(spacing: 30) {
//                        Button(action: { withAnimation { selectedTab = "Qattah" } }) {
//                            Text("Qattah")
//                                .font(.headline)
//                                .bold()
//                                .foregroundColor(selectedTab == "Qattah" ? .white : .gray)
//                        }
//                        
//                        Button(action: { withAnimation { selectedTab = "Challenge" } }) {
//                            Text("Challenge")
//                                .font(.headline)
//                                .bold()
//                                .foregroundColor(selectedTab == "Challenge" ? .white : .gray)
//                        }
//                    }
//                    .padding(.horizontal, 26)
//                    
//                    // ✅ الخط الأزرق
//                    ZStack(alignment: .leading) {
//                        Rectangle()
//                            .frame(height: 2)
//                            .foregroundColor(.blue.opacity(0.5))
//                            .frame(maxWidth: .infinity)
//                        
//                        RoundedRectangle(cornerRadius: 5)
//                            .frame(width: selectedTab == "Qattah" ? 70 : 95, height: 4)
//                            .foregroundColor(.white)
//                            .offset(x: selectedTab == "Qattah" ? 0 : 85)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding(.leading, 16)
//                }
//                .padding(.top, 5)
//                
//                // ✅ جعل QattahView قابلة للتمرير بالكامل
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 16) {  // تكرار المربعات بجانب بعضها
//                        if selectedTab == "Qattah" {
//                            // تكرار المربعات الكبيرة مع إيموجي
//                            ForEach(viewModel.qattahGoals, id: \.id) { goal in
//                                ZStack {
//                                    // المربع الكبير
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .fill(Color(hex: "290B83"))
//                                        .frame(width: 240, height: 300)
//                                        .shadow(radius: 4)
//                                    
//                                    VStack(alignment: .leading, spacing: 10) {
//                                        HStack {
//                                            Spacer()
//                                            Button(action: {
//                                                showOptionsSheet = true
//                                            }) {
//                                                Image(systemName: "ellipsis")
//                                                    .foregroundColor(.white)
//                                                    .padding()
//                                            
//                                            .zIndex(3)
//                                        }
//                                            
//                                            ZStack {
//                                                Circle()
//                                                    .stroke(lineWidth: 6)
//                                                    .foregroundColor(.gray.opacity(0.3))
//                                                    .frame(width: 60, height: 60)
//                                                
//                                                Circle()
//                                                    .trim(from: 0, to: 0.2)
//                                                    .stroke(Color(hex: "007AFF"), lineWidth: 6)
//                                                    .frame(width: 60, height: 60)
//                                                    .rotationEffect(.degrees(-90))
//                                                
//                                                // عرض الإيموجي داخل الدائرة
//                                                Text(goal.emoji)
//                                                    .font(.title3)
//                                                    .foregroundColor(.white)
//                                            }
//                                            .padding(.top, 0)  // رفع الدائرة للأعلى بشكل أكبر
//                                            
//                                            // عرض اسم الهدف بجانب الدائرة
//                                            Text(goal.name)
//                                                .font(.subheadline)
//                                                .foregroundColor(.white)
//                                                .padding(.leading, 8)
//                                            
//                                            Spacer()
//                                        }
//                                        .padding(.leading, 12) // محاذاة النص مع الدائرة
//                                        
//                                        // عرض النسبة المئوية أسفل النص
//                                        Text("\(goal.salary)% Achieved")
//                                            .font(.headline)
//                                            .bold()
//                                            .foregroundColor(.white)
//                                            .padding(.leading, 12)
//                                    }
//                                    .padding(.top, 10) // رفع جميع العناصر إلى الأعلى
//                                }
//                                .padding(.horizontal, 16)  // إضافة مسافة بين المربعات
//                                .frame(width: 240, height: 300)
//                                .padding(.leading, 16)
//                            }
//                            
//                            
//                        }else if selectedTab == "Challenge" {
//                            HStack(spacing: 25) { // ✅ ترتيب العناصر في صف مع تباعد مناسب
//                                // نعرض الأهداف التي تكون من نوع "challenge"
//                                ForEach(viewModel.goals.filter { $0.goalType == .challenge }, id: \.id) { goal in
//                                    VStack(spacing: 3) { // ✅ تقليل التباعد بين العناصر
//                                        ZStack {
//                                            Circle()
//                                                .stroke(lineWidth: 6)
//                                                .foregroundColor(.gray.opacity(0.3))
//                                                .frame(width: 90, height: 90) // ✅ تكبير حجم الدائرة قليلاً
//                                            
//                                            Circle()
//                                                .trim(from: 0, to: CGFloat(goal.salary) / 100)
//                                                .stroke(Color(hex: "007AFF"), lineWidth: 6)
//                                                .frame(width: 90, height: 90)
//                                                .rotationEffect(.degrees(-90))
//                                            
//                                            // عرض صورة البروفايل داخل الدائرة
//                                            Image(systemName: goal.emoji) // استخدم الإيموجي المرتبط بالهدف
//                                                .resizable()
//                                                .scaledToFill()
//                                                .frame(width: 65, height: 65)
//                                                .clipShape(Circle())
//                                                .padding(5)
//                                        }
//                                        
//                                        // ✅ وضع الاسم والنسبة مباشرة تحت الدائرة
//                                        Text(goal.name) // اسم الهدف
//                                            .font(.caption)
//                                            .foregroundColor(.white)
//                                            .bold()
//                                        
//                                        // عرض النسبة المحققة باستخدام القيمة من CloudKit
//                                        Text("\(Int(goal.salary))% achieved")
//                                            .font(.caption2)
//                                            .foregroundColor(.white)
//                                    }
//                                    .padding(.horizontal, 8) // ✅ ضبط المسافات الجانبية بين العناصر
//                                }
//                            }
//                            .padding(.top, -20) // ✅ رفع كل المكون للأعلى بطريقة آمنة دون حاجز
//                        }
//                    }
//                }
//                .frame(height: 350)
//                
//                // ✅ "CashTrack" مثل "Friends" و "Goals"
//                HStack {
//                    Text("CashTrack")
//                        .font(.title2)
//                        .bold()
//                        .foregroundColor(.white)
//                        .padding(.leading, 16)
//                    
//                    Spacer()
//                }
//                .padding(.top, 20)
//                
//                CashTrackerView()
//                    .onTapGesture {
//                        showFullTracker = true // ✅ عند الضغط، تفتح الصفحة الكاملة
//                    }
//            }
//            .sheet(isPresented: $showProgressSheet) {
//                VStack(spacing: 20) {
//                    // عنوان الشيت
//                    Text("Friends Progress")
//                        .font(.headline)
//                        .bold()
//                        .foregroundColor(.white)
//                        .padding(.top)
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 20) {
//                            ForEach([
//                                ("Ghala", "person.circle.fill", 0.35),
//                                ("Sara", "person.circle.fill", 0.05),
//                                ("Yara", "person.circle.fill", 0.30),
//                                ("Talal", "person.circle.fill", 0.10)
//                            ], id: \.0) { friend in
//                                VStack(spacing: 8) {
//                                    ZStack {
//                                        // الشكل الأساسي الخلفي
//                                        RoundedRectangle(cornerRadius: 40)
//                                            .fill(Color.white.opacity(0.1))
//                                            .frame(width: 80, height: 120)
//                                        
//                                        // تعبئة التقدم من الأسفل للأعلى داخل الشكل فقط باستخدام mask
//                                        ZStack(alignment: .bottom) {
//                                            RoundedRectangle(cornerRadius: 40)
//                                                .fill(
//                                                    LinearGradient(
//                                                        gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
//                                                        startPoint: .bottom,
//                                                        endPoint: .top
//                                                    )
//                                                )
//                                                .frame(width: 80, height: 120 * friend.2)
//                                        }
//                                        .frame(width: 80, height: 120)
//                                        .clipShape(RoundedRectangle(cornerRadius: 40)) // هذا هو المهم: يجعل التعبئة محصورة داخل الشكل
//                                        
//                                        // الإطار الخارجي الأزرق
//                                        RoundedRectangle(cornerRadius: 40)
//                                            .stroke(Color.blue, lineWidth: 2)
//                                            .frame(width: 80, height: 120)
//                                        
//                                        // صورة البروفايل والنسبة
//                                        VStack(spacing: 6) {
//                                            Image(systemName: friend.1)
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(width: 35, height: 35)
//                                                .foregroundColor(.white)
//                                            
//                                            Text("\(Int(friend.2 * 100))%")
//                                                .font(.footnote)
//                                                .bold()
//                                                .foregroundColor(.white)
//                                        }
//                                    }
//                                    
//                                    // اسم الصديق
//                                    Text(friend.0)
//                                        .foregroundColor(.white)
//                                        .font(.caption)
//                                        .bold()
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//                    
//                    }
//            }
//        }
//        }
//        
//        .fullScreenCover(isPresented: $showFullTracker) {
//            CashTrackerView()
//            
//   
//                
//        }
//    }
//}
//
