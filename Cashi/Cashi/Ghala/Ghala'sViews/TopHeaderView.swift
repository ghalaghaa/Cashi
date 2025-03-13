//
//  TopHeaderView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//
import SwiftUI
import CloudKit

struct TopHeaderView: View {
    var onAddTapped: () -> Void
    @Binding var selectedGoals: [Goal]
    @Binding var isSelectingCalculations: Bool
    
    @State private var selectedImage: UIImage? // متغير لحفظ الصورة المختارة
    @State private var selectedGoal: Goal?  // الهدف المحدد عند الاختيار
    @Binding var userName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color(hex: "290B83"), Color(hex: "4B7EDA"))
                    .padding(.leading, 16)
                
                // إضافة النص "Hi" مع اسم المستخدم بجانب صورة البروفايل
                Text("Hi, \(userName)") // عرض الاسم هنا
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.leading, 8) // تعديل المسافة بين صورة البروفايل والنص
                
                Spacer()
                
                
                
                // وضع NavigationLink حول الزر "+" ليقوم بالانتقال عند الضغط
                NavigationLink(destination: GoalSelectionView()) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color(hex: "290B83"), Color(hex: "4B7EDA"))
                        .padding(.trailing, 16)
                        .onTapGesture {
                            onAddTapped() // أو أي منطق آخر قد تحتاجه هنا
                        }
                }
            }
            HStack {
                Text("Goals")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.leading, 16)
                
                Spacer()
                
                Button("Select") {
                    if let selectedGoal = selectedGoal {
                        // عند الضغط على Select نحدد الهدف المختار
                        selectedGoals = [selectedGoal]
                        isSelectingCalculations = true
                    }
                }
                .foregroundColor(.blue)
                .padding(.trailing, 16)
            }
            
            
            .foregroundColor(.blue)
        }
    }
    
}
