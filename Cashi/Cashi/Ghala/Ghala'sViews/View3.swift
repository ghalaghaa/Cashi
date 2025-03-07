//
//  ContentView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 24/08/1446 AH.
import SwiftUI

struct View3: View {
    @State private var selectedTab: String = "Qattah" // الحالة الافتراضية

    var body: some View {
        ZStack {
            // الخلفية المتدرجة
            LinearGradient(gradient: Gradient(colors: [
                Color(hex: "1F0179"),
                Color(hex: "160158"),
                Color(hex: "0E0137")
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) { // ⬅️ السماح بالتمرير لأسفل
                VStack {
                    // ✅ العناصر العلوية (ثابتة)
                    VStack(alignment: .leading, spacing: 16) {
                        // الأيقونات العلوية
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.white, Color.blue)
                                .padding(.leading, 16)

                            Spacer()

                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.white, Color.blue)
                                .padding(.trailing, 16)
                        }

                        // عنوان "Goals" وكلمة "Select"
                        HStack {
                            Text("Goals")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.leading, 16)

                            Spacer()

                            Text("Select")
                                .font(.body)
                                .bold()
                                .foregroundColor(.blue)
                                .padding(.trailing, 16)
                                .padding(.top, 40)
                        }
                    }

                    // ✅ شريط الصور (ثابت)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<2, id: \.self) { _ in
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 250, height: 150)
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // ✅ "Friends" في مكانه الطبيعي دون تغيير المسافة
                    HStack {
                        Text("Friends")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.leading, 16)

                        Spacer()
                    }
                    .padding(.top, 30)

                    // ✅ التبويبات بين "Qattah" و "Challenge"
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 30) {
                            Button(action: {
                                withAnimation {
                                    selectedTab = "Qattah"
                                }
                            }) {
                                Text("Qattah")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(selectedTab == "Qattah" ? .white : .gray)
                            }

                            Button(action: {
                                withAnimation {
                                    selectedTab = "Challenge"
                                }
                            }) {
                                Text("Challenge")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(selectedTab == "Challenge" ? .white : .gray)
                            }
                        }
                        .padding(.horizontal, 26)

                        // ✅ الخط الأزرق الممتد والخط المتحرك فوقه
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.blue.opacity(0.5))
                                .frame(maxWidth: .infinity)

                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: selectedTab == "Qattah" ? 80 : 105, height: 4)
                                .foregroundColor(.white)
                                .offset(x: selectedTab == "Qattah" ? 0 : 85)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 16)
                    }
                    .padding(.top, 2)

                    // ✅ جعل QattahView و Challenge قابلين للتمرير أفقيًا بدون تغيير الحجم أو المكان
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            if selectedTab == "Qattah" {
                                QattahView()
                                    .scaleEffect(0.5)
                                    .offset(x: -80, y: -80)
                                    .frame(width: 350, height: 400) // ضمان الحجم نفسه
                                    .padding(.leading, 16)
                            } else {
                                Text("Challenge View هنا") // يمكنك استبدالها بـ ChallengeView الحقيقي
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 350, height: 400)
                                    .background(Color.blue.opacity(0.3))
                                    .cornerRadius(15)
                                    .padding(.leading, 16)
                            }
                        }
                    }
                    .padding(.top, 10)

                    // ✅ "CashTrack" أقرب إلى "QattahView"
                    HStack {
                        Text("CashTrack")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.leading, 17)

                        Spacer()
                    }
                    .padding(.top, -50) // ⬅️ رفع CashTrack للأعلى أكثر
                    .offset(y: -50) // ⬅️ تحريك CashTrack للأعلى أكثر
                }
            }
        }
    }
}

// تحويل كود الألوان من HEX إلى SwiftUI Color
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    View3()
}
