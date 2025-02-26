////
////  Friends.swift
////  Cashi
////
////  Created by Ghala Alnemari on 27/08/1446 AH.
////
//
//import SwiftUI
//import CloudKit
//import UIKit
//import CoreImage.CIFilterBuiltins
//
//// نموذج بيانات المستخدم في CloudKit
//class User: Identifiable, ObservableObject {
//    var id: String
//    var name: String
//    var goal: Double
//    var collected: Double
//    
//    init(id: String, name: String, goal: Double, collected: Double) {
//        self.id = id
//        self.name = name
//        self.goal = goal
//        self.collected = collected
//    }
//}
//
//// نموذج المجموعة في CloudKit
//class SavingGroup: Identifiable, ObservableObject {
//    var id: String
//    var name: String
//    var totalTarget: Double
//    var collectedAmount: Double
//    var members: [User]
//    
//    init(id: String, name: String, totalTarget: Double, collectedAmount: Double, members: [User]) {
//        self.id = id
//        self.name = name
//        self.totalTarget = totalTarget
//        self.collectedAmount = collectedAmount
//        self.members = members
//    }
//}
//
//// إدارة البيانات باستخدام CloudKit
//class CloudKitManager: ObservableObject {
//    @Published var users: [User] = []
//    @Published var groups: [SavingGroup] = []
//    let container = CKContainer.default()
//    
//    func fetchUsers() {
//        let query = CKQuery(recordType: "User", predicate: NSPredicate(value: true))
//        let database = container.publicCloudDatabase
//        
//        database.perform(query, inZoneWith: nil) { records, error in
//            if let records = records {
//                DispatchQueue.main.async {
//                    self.users = records.map { record in
//                        User(id: record.recordID.recordName,
//                             name: record["name"] as? String ?? "",
//                             goal: record["goal"] as? Double ?? 0.0,
//                             collected: record["collected"] as? Double ?? 0.0)
//                    }
//                }
//            }
//        }
//    }
//    
//    func fetchGroups() {
//        let query = CKQuery(recordType: "SavingGroup", predicate: NSPredicate(value: true))
//        let database = container.publicCloudDatabase
//        
//        database.perform(query, inZoneWith: nil) { records, error in
//            if let records = records {
//                DispatchQueue.main.async {
//                    self.groups = records.map { record in
//                        SavingGroup(id: record.recordID.recordName,
//                                    name: record["name"] as? String ?? "",
//                                    totalTarget: record["totalTarget"] as? Double ?? 0.0,
//                                    collectedAmount: record["collectedAmount"] as? Double ?? 0.0,
//                                    members: [])
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct SavingRaceApp: View {
//    @State private var selectedTab = 0
//    @StateObject private var cloudKitManager = CloudKitManager()
//    
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            SharedGoalView(groups: cloudKitManager.groups)
//                .tabItem {
//                    Label("هدف مشترك", systemImage: "person.3.fill")
//                }
//                .tag(0)
//            
//            IndividualGoalsView(users: cloudKitManager.users)
//                .tabItem {
//                    Label("سباق الادخار", systemImage: "flag.checkered")
//                }
//                .tag(1)
//            
//            InviteFriendsView()
//                .tabItem {
//                    Label("دعوة الأصدقاء", systemImage: "person.badge.plus")
//                }
//                .tag(2)
//        }
//        .onAppear {
//            cloudKitManager.fetchUsers()
//            cloudKitManager.fetchGroups()
//        }
//    }
//}
//
//// نموذج الهدف المشترك
//struct SharedGoalView: View {
//    var groups: [SavingGroup]
//    
//    var body: some View {
//        VStack {
//            Text("المجموعات")
//                .font(.title)
//            List(groups, id: \..id) { group in
//                VStack(alignment: .leading) {
//                    Text(group.name)
//                        .font(.headline)
//                    ProgressView(value: group.collectedAmount, total: group.totalTarget)
//                }
//            }
//        }
//        .padding()
//    }
//}
//
//// نموذج سباق الادخار
//struct IndividualGoalsView: View {
//    var users: [User]
//    
//    var body: some View {
//        VStack {
//            Text("سباق الادخار")
//                .font(.title)
//            
//            List(users.sorted { $0.collected / $0.goal > $1.collected / $1.goal }, id: \..id) { user in
//                VStack(alignment: .leading) {
//                    Text(user.name)
//                        .font(.headline)
//                    ProgressView(value: user.collected, total: user.goal)
//                }
//                .padding()
//            }
//        }
//        .padding()
//    }
//}
//
//// نموذج دعوة الأصدقاء
//struct InviteFriendsView: View {
//    let inviteLink = "https://yourapp.com/invite?groupId=12345"
//    
//    var body: some View {
//        VStack {
//            Text("شارك الدعوة مع أصدقائك")
//                .font(.title)
//            
//            Button(action: shareInvite) {
//                Label("مشاركة الرابط", systemImage: "square.and.arrow.up")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//        }
//        .padding()
//    }
//    
//    func shareInvite() {
//        let activityVC = UIActivityViewController(activityItems: [inviteLink], applicationActivities: nil)
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let rootVC = windowScene.windows.first?.rootViewController {
//            rootVC.present(activityVC, animated: true, completion: nil)
//        }
//    }
//}
//
//struct SavingRaceApp_Previews: PreviewProvider {
//    static var previews: some View {
//        SavingRaceApp()
//    }
//}
//
//
//struct SimpleTestView: View {
//    @StateObject private var cloudKitManager = CloudKitManager()
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("اختبار التطبيق")
//                    .font(.largeTitle)
//                    .padding()
//                
//                List(cloudKitManager.users, id: \..id) { user in
//                    HStack {
//                        Text(user.name)
//                            .font(.headline)
//                        Spacer()
//                        Text("\(user.collected, specifier: "%.2f") / \(user.goal, specifier: "%.2f") ريال")
//                            .foregroundColor(.gray)
//                    }
//                }
//                .onAppear {
//                    cloudKitManager.fetchUsers()
//                }
//                
//                Button(action: {
//                    cloudKitManager.fetchUsers()
//                }) {
//                    Text("تحديث البيانات")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding()
//            }
//            .navigationTitle("اختبار الادخار")
//        }
//    }
//}
//
//struct SimpleTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        SimpleTestView()
//    }
//}
//
//
//struct ContentView: View {
//    var body: some View {
//        SavingRaceApp() // تشغيل التطبيق الرئيسي
//    }
//}
//
//@main
//struct CashiApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
