import SwiftUI

struct CalculationPage: View {
    let user: User
    let goal: Goal
    let cost: Double
    let salary: Double
    let savingsType: Goal.SavingsType
    
    @State private var savingsPerPeriod: Double = 0
    @State private var duration: Int = 0
    @State private var savingRate: Double = 0.2 // Default savings rate (20%)
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            backgroundGradient()
            
            VStack(spacing: 15) {
                headerView()
                
                VStack(spacing: 15) {
                    inputField(title: "Your \(savingsType.rawValue.capitalized) Payment", value: String(format: "%.2f $", savingsPerPeriod))
                    
                    inputField(title: "Time Needed to Reach Your Goal", value: "\(duration) \(savingsType.rawValue.lowercased())s")
                }
                .frame(width: 380, height: 220)
                .background(RoundedRectangle(cornerRadius: 30).fill(Color(hex: "1C215B")))
                .padding(.horizontal)
                
                savingsRateSlider()
                
                Spacer()
            }
        }
        .onAppear {
            calculateSavings()
        }
        .onChange(of: savingRate) { _ in
            calculateSavings()
        }
    }
    
    // 🔹 Background Gradient
    private func backgroundGradient() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1F0179"), Color(hex: "160158"), Color(hex: "0E0137")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // 🔹 Header View
    private func headerView() -> some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
            
            Text("Good evening, \(user.name)")
                .foregroundColor(.white)
                .font(.headline)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 50)
    }
    
    // 🔹 Input Field
    private func inputField(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
            
            Text(value)
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
        .padding(.vertical, 5)
    }
    
    // 🔹 Adjustable Savings Rate Slider
    private func savingsRateSlider() -> some View {
        VStack {
            Text("Adjust Savings Rate: \(Int(savingRate * 100))%")
                .foregroundColor(.white)
                .font(.headline)
            
            Slider(value: $savingRate, in: 0.05...0.5, step: 0.05)
                .padding(.horizontal)
        }
    }
    
    // 🔹 Calculation Function
    private func calculateSavings() {
        guard salary > 0, cost > 0 else {
            print("⚠️ Error: Salary and cost must be greater than zero.")
            savingsPerPeriod = 0
            duration = 0
            return
        }
        
        let savingFactor: Double
        switch savingsType {
        case .daily: savingFactor = 30.0
        case .weekly: savingFactor = 4.0
        case .monthly: savingFactor = 1.0
        }
        
        let calculatedSavingsPerPeriod = (salary * savingRate) / savingFactor
        let calculatedDuration = calculatedSavingsPerPeriod > 0 ? Int(ceil(cost / calculatedSavingsPerPeriod)) : 0
        
        DispatchQueue.main.async {
            self.savingsPerPeriod = calculatedSavingsPerPeriod
            self.duration = max(1, calculatedDuration) // Ensure at least 1 period
        }
    }
}
