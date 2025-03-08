
//
//  ContentView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 24/08/1446 AH.
import SwiftUI

struct View3: View {
    @State private var selectedTab: String = "Qattah"
    @State private var showFullTracker = false

    var body: some View {
        ZStack {
            // الخلفية المتدرجة
            LinearGradient(gradient: Gradient(colors: [
                Color(hex: "1F0179"),
                Color(hex: "160158"),
                Color(hex: "0E0137")
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // ✅ العناصر العلوية
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color(hex: "290B83"), Color(hex: "4B7EDA"))
                                .padding(.leading, 16)

                            Spacer()

                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color(hex: "290B83"), Color(hex: "4B7EDA"))
                                .padding(.trailing, 16)
                        }

                        // ✅ عنوان "Goals" وكلمة "Select"
                        HStack {
                            Text("Goals")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.leading, 16)

                            Spacer()

                            Text("Select")
                                .font(.body)
                                .bold()
                                .foregroundColor(.blue)
                                .padding(.trailing, 16)
                        }
                    }

                    // ✅ شريط الصور
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<2, id: \.self) { _ in
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 220, height: 120)
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // ✅ "Friends"
                    HStack {
                        Text("Friends")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.leading, 16)

                        Spacer()
                    }
                    .padding(.top, 20)

                    // ✅ التبويبات بين "Qattah" و "Challenge"
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 30) {
                            Button(action: { withAnimation { selectedTab = "Qattah" } }) {
                                Text("Qattah")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(selectedTab == "Qattah" ? .white : .gray)
                            }

                            Button(action: { withAnimation { selectedTab = "Challenge" } }) {
                                Text("Challenge")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(selectedTab == "Challenge" ? .white : .gray)
                            }
                        }
                        .padding(.horizontal, 26)

                        // ✅ الخط الأزرق
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.blue.opacity(0.5))
                                .frame(maxWidth: .infinity)

                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: selectedTab == "Qattah" ? 70 : 95, height: 4)
                                .foregroundColor(.white)
                                .offset(x: selectedTab == "Qattah" ? 0 : 85)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 16)
                    }
                    .padding(.top, 5)

                    // ✅ جعل QattahView قابلة للتمرير بالكامل
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            if selectedTab == "Qattah" {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(hex: "290B83"))
                                        .frame(width: 240, height: 300)
                                        .shadow(radius: 4)

                                    ScrollView(.vertical, showsIndicators: false) {
                                        VStack(alignment: .leading, spacing: 10) {
                                            HStack {
                                                Spacer()
                                                Image(systemName: "ellipsis")
                                                    .resizable()
                                                    .frame(width: 22, height: 5)
                                                    .foregroundColor(.gray)
                                                    .padding(.trailing, 14)
                                                    .padding(.top, 20)
                                            }

                                            VStack(alignment: .leading) {
                                                HStack {
                                                    ZStack {
                                                        Circle()
                                                            .stroke(lineWidth: 6)
                                                            .foregroundColor(.gray.opacity(0.3))
                                                            .frame(width: 60, height: 60)

                                                        Circle()
                                                            .trim(from: 0, to: 0.2)
                                                            .stroke(Color(hex: "007AFF"), lineWidth: 6)
                                                            .frame(width: 60, height: 60)
                                                            .rotationEffect(.degrees(-90))

                                                        Text("🏡")
                                                            .font(.title3)
                                                    }
                                                    Spacer()
                                                }
                                                .padding(.leading, 12)

                                                Text("20% Achieved")
                                                    .font(.headline)
                                                    .bold()
                                                    .foregroundColor(.white)
                                                    .padding(.leading, 12)
                                                    .padding(.top, 3)
                                            }

                                            VStack(alignment: .leading, spacing: 12) {
                                                ForEach([
                                                    ("Sara", 5),
                                                    ("Yara", 30),
                                                    ("Talal", 35),
                                                    ("Ghala", 10)
                                                ], id: \.0) { user in
                                                    VStack(alignment: .leading) {
                                                        Text(user.0)
                                                            .font(.subheadline)
                                                            .foregroundColor(.white)

                                                        ZStack(alignment: .leading) {
                                                            RoundedRectangle(cornerRadius: 20)
                                                                .frame(height: 20)
                                                                .foregroundColor(.gray.opacity(0.3))

                                                            RoundedRectangle(cornerRadius: 20)
                                                                .frame(width: max(CGFloat(user.1) * 2.5, 30), height: 20)
                                                                .foregroundColor(Color(hex: "007AFF"))

                                                            HStack {
                                                                Image(systemName: "person.circle.fill")
                                                                    .resizable()
                                                                    .frame(width: 20, height: 20)
                                                                    .clipShape(Circle())
                                                                    .foregroundColor(.white)
                                                                    .padding(.leading, 4)

                                                                Spacer()

                                                                Text("\(user.1)%")
                                                                    .font(.caption2)
                                                                    .bold()
                                                                    .foregroundColor(.white)
                                                                    .padding(.trailing, 8)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .padding(.horizontal, 15)
                                        }
                                    }
                                }
                                .frame(width: 240, height: 300)
                                .padding(.leading, 16)
                            }
                            else if selectedTab == "Challenge" {
                                HStack(spacing: 25) { // ✅ ترتيب العناصر في صف مع تباعد مناسب
                                    ForEach([
                                        ("Ali", "profile4", 75),
                                        ("Reem", "profile5", 50),
                                        ("Omar", "profile6", 90)
                                    ], id: \.0) { user in
                                        VStack(spacing: 3) { // ✅ تقليل التباعد بين العناصر
                                            ZStack {
                                                Circle()
                                                    .stroke(lineWidth: 6)
                                                    .foregroundColor(.gray.opacity(0.3))
                                                    .frame(width: 90, height: 90) // ✅ تكبير حجم الدائرة قليلاً

                                                Circle()
                                                    .trim(from: 0, to: CGFloat(user.2) / 100)
                                                    .stroke(Color(hex: "007AFF"), lineWidth: 6)
                                                    .frame(width: 90, height: 90)
                                                    .rotationEffect(.degrees(-90))

                                                Image(user.1) // ✅ صورة البروفايل داخل الدائرة
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 65, height: 65) // ✅ ضبط حجم الصورة لتناسب الدائرة
                                                    .clipShape(Circle())
                                                    .padding(5) // ✅ إضافة عازل صغير لجعل الصورة داخل الدائرة بشكل أفضل
                                            }

                                            // ✅ وضع الاسم والنسبة مباشرة تحت الدائرة
                                            Text(user.0)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .bold()

                                            Text("\(user.2)% achieved")
                                                .font(.caption2)
                                                .foregroundColor(.white)
                                        }
                                        .padding(.horizontal, 8) // ✅ ضبط المسافات الجانبية بين العناصر
                                    }
                                }
                                .padding(.top, -20) // ✅ رفع كل المكون للأعلى بطريقة آمنة دون حاجز
                            }
                    }
             }
        .frame(height: 350)

                    // ✅ "CashTrack" مثل "Friends" و "Goals"
                    HStack {
                        Text("CashTrack")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.leading, 16)

                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    CashTrackerView()
                                           .onTapGesture {
                                               showFullTracker = true // ✅ عند الضغط، تفتح الصفحة الكاملة
                                           }
                                   }
                               }
                           }
                           .fullScreenCover(isPresented: $showFullTracker) {
                               CashTrackerView()
        }
    }
}


#Preview {
    View3()
}
