////
////  CloudKitGroupManager.swift
////  Cashi
////
////  Created by Ghala Alnemari on 03/09/1446 AH.
////import CloudKit
//import SwiftUI
//import CloudKit
//
//
//class CloudKitGroupManager: ObservableObject {
//    private let container = CKContainer(identifier: "iCloud.CashiBackup")
//    private let database: CKDatabase
//
//    @Published var groups: [Group] = []
//
//    init() {
//        self.database = container.publicCloudDatabase
//        Task {
//            print(" بدء جلب المجموعات عند تشغيل التطبيق...")
//            await fetchGroups()
//        }
//    }
//
//    /// 🔹 إنشاء مجموعة جديدة
//    func createGroup(groupName: String, goalAmount: Double, createdBy: CKRecord.Reference) async throws -> CKRecord.ID {
//        print(" إنشاء مجموعة جديدة: \(groupName) بهدف \(goalAmount) ريال")
//
//        let groupRecord = CKRecord(recordType: "Groups")
//        groupRecord["groupName"] = groupName as CKRecordValue
//        groupRecord["goalAmount"] = goalAmount as CKRecordValue
//        groupRecord["createdBy"] = createdBy as CKRecordValue
//        groupRecord["members"] = [createdBy] as CKRecordValue
//        groupRecord["progressUsers"] = [createdBy] as CKRecordValue
//        groupRecord["progressAmounts"] = [0.0] as CKRecordValue
//
//        try await database.save(groupRecord)
//        print(" تم حفظ المجموعة في CloudKit بنجاح!")
//
//        await fetchGroups()
//        return groupRecord.recordID
//    }
//
//    /// 🔹 إنشاء رابط دعوة للمجموعة
//    func generateInvitationLink(groupID: CKRecord.ID) -> URL? {
//        let urlString = "https://cashi.com/invite?group=\(groupID.recordName)"
//        print("🔗 تم إنشاء رابط الدعوة: \(urlString)")
//        return URL(string: urlString)
//    }
//
//    /// 🔹 دعوة صديق باستخدام رابط
//    func handleInvitation(from url: URL, currentUserID: String) async throws {
//        print(" معالجة رابط الدعوة: \(url)")
//
//        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
//              let queryItems = components.queryItems,
//              let groupIDString = queryItems.first(where: { $0.name == "group" })?.value else {
//            print(" خطأ: رابط غير صالح")
//            return
//        }
//
//        print(" تم استخراج معرف المجموعة: \(groupIDString)")
//        let groupID = CKRecord.ID(recordName: groupIDString)
//        let newMemberRef = CKRecord.Reference(recordID: CKRecord.ID(recordName: currentUserID), action: .none)
//
//        try await addMemberToGroup(groupID: groupID, member: newMemberRef)
//    }
//
//    /// 🔹 إضافة عضو جديد إلى المجموعة
//    func addMemberToGroup(groupID: CKRecord.ID, member: CKRecord.Reference) async throws {
//        print("👥 إضافة عضو جديد للمجموعة \(groupID.recordName)")
//
//        let groupRecord = try await database.record(for: groupID)
//        
//        var members = groupRecord["members"] as? [CKRecord.Reference] ?? []
//        if !members.contains(member) {
//            members.append(member)
//            groupRecord["members"] = members as CKRecordValue
//            try await database.save(groupRecord)
//            print(" تمت إضافة العضو بنجاح!")
//            await fetchGroups()
//        } else {
//            print(" العضو موجود مسبقًا في المجموعة!")
//        }
//    }
//
//    func updateProgress(groupID: CKRecord.ID, userRef: CKRecord.Reference, amountSaved: Double) async throws {
//        print(" تحديث التقدم للمستخدم \(userRef.recordID.recordName) في المجموعة \(groupID.recordName) بالمبلغ: \(amountSaved) ريال")
//
//        let groupRecord = try await database.record(for: groupID)
//        
//        var progressUsers = groupRecord["progressUsers"] as? [CKRecord.Reference] ?? []
//        var progressAmounts = groupRecord["progressAmounts"] as? [Double] ?? []
//        
//        if let index = progressUsers.firstIndex(of: userRef) {
//            progressAmounts[index] = amountSaved
//        } else {
//            progressUsers.append(userRef)
//            progressAmounts.append(amountSaved)
//        }
//        
//        groupRecord["progressUsers"] = progressUsers as CKRecordValue
//        groupRecord["progressAmounts"] = progressAmounts as CKRecordValue
//        
//        try await database.save(groupRecord)
//        print(" تم تحديث التقدم في CloudKit بنجاح!")
//    }
//
//    func fetchGroups() async {
//        print(" بدء جلب جميع المجموعات من CloudKit...")
//
//        let query = CKQuery(recordType: "Groups", predicate: NSPredicate(value: true))
//
//        do {
//            let (results, _) = try await database.records(matching: query)
//            let fetchedGroups = results.compactMap { _, result -> Group? in
//                switch result {
//                case .success(let record):
//                    print(" تم جلب مجموعة: \(record["groupName"] ?? "اسم غير معروف")")
//                    return Group(record: record)
//                case .failure(let error):
//                    print(" خطأ أثناء جلب المجموعات: \(error.localizedDescription)")
//                    return nil
//                }
//            }
//
//            DispatchQueue.main.async {
//                self.groups = fetchedGroups
//                print(" تم تحديث المجموعات في الواجهة!")
//            }
//        } catch {
//            print(" خطأ في جلب المجموعات: \(error.localizedDescription)")
//        }
//    }
//}
//
//
//
//struct Group {
//    let id: CKRecord.ID
//    let name: String
//    let goalAmount: Double
//    let createdBy: CKRecord.Reference
//    let members: [CKRecord.Reference]
//    let progress: [String: Double]
//
//    init?(record: CKRecord) {
//        guard let name = record["groupName"] as? String,
//              let goalAmount = record["goalAmount"] as? Double,
//              let createdBy = record["createdBy"] as? CKRecord.Reference,
//              let members = record["members"] as? [CKRecord.Reference],
//              let progressUsers = record["progressUsers"] as? [CKRecord.Reference],
//              let progressAmounts = record["progressAmounts"] as? [Double],
//              progressUsers.count == progressAmounts.count else { return nil }
//
//        self.id = record.recordID
//        self.name = name
//        self.goalAmount = goalAmount
//        self.createdBy = createdBy
//        self.members = members
//        
//        var progressDict: [String: Double] = [:]
//        for (index, user) in progressUsers.enumerated() {
//            progressDict[user.recordID.recordName] = progressAmounts[index]
//        }
//        self.progress = progressDict
//    }
//}
//
//
//
//struct GroupsView: View {
//    @StateObject private var groupManager = CloudKitGroupManager()
//    @State private var enteredAmount: String = ""
//
//    let currentUserID: String = "currentUserID" // استبدله بمعرف المستخدم الحقيقي
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if groupManager.groups.isEmpty {
//                    Text(" لا توجد مجموعات بعد!")
//                        .foregroundColor(.gray)
//                        .padding()
//                } else {
//                    List(groupManager.groups, id: \.id) { group in
//                        VStack(alignment: .leading) {
//                            HStack {
//                                Text("\(group.name)")
//                                    .font(.title2)
//                                    .bold()
//                                Spacer()
//                                Text("🎯 \(group.goalAmount, specifier: "%.2f") ريال")
//                                    .foregroundColor(.gray)
//                            }
//                            .padding(.horizontal)
//
//                            VStack(alignment: .leading) {
//                                Text("\(calculateTotalProgress(for: group), specifier: "%.0f")% achieved")
//                                    .font(.headline)
//                                ProgressView(value: calculateTotalProgress(for: group) / 100)
//                                    .progressViewStyle(LinearProgressViewStyle())
//                                    .frame(height: 10)
//                            }
//                            .padding(.bottom)
//
//                            if let leader = findLeader(for: group) {
//                                Text(" المتصدر: \(leader.name) (\(leader.amount, specifier: "%.2f") ريال)")
//                                    .font(.headline)
//                                    .foregroundColor(.blue)
//                            }
//
//                            ForEach(group.members, id: \.recordID) { member in
//                                let progress = group.progress[member.recordID.recordName] ?? 0
//                                let percentage = (progress / group.goalAmount) * 100
//                                
//                                HStack {
//                                    Image(systemName: "person.circle.fill")
//                                        .resizable()
//                                        .frame(width: 40, height: 40)
//                                        .foregroundColor(.blue)
//
//                                    VStack(alignment: .leading) {
//                                        Text("\(member.recordID.recordName)")
//                                            .font(.headline)
//                                        ProgressView(value: percentage / 100)
//                                            .frame(height: 8)
//                                    }
//
//                                    Spacer()
//                                    Text("\(progress, specifier: "%.2f") ريال")
//                                        .font(.subheadline)
//                                }
//                            }
//
//                            HStack {
//                                TextField("أدخل المبلغ", text: $enteredAmount)
//                                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                                    .keyboardType(.decimalPad)
//                                    .frame(width: 150)
//
//                                Button(action: {
//                                    addSavingAmount(for: group)
//                                }) {
//                                    Image(systemName: "plus.circle.fill")
//                                        .resizable()
//                                        .frame(width: 40, height: 40)
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                            .padding(.top, 5)
//                        }
//                        .padding()
//                    }
//                }
//            }
//            .navigationTitle("🚀 المجموعات والتحديات")
//            .onAppear {
//                Task {
//                    await groupManager.fetchGroups()
//                }
//            }
//        }
//    }
//
//    private func addSavingAmount(for group: Group) {
//        guard let amount = Double(enteredAmount), amount > 0 else { return }
//        
//        Task {
//            let userRef = CKRecord.Reference(recordID: CKRecord.ID(recordName: currentUserID), action: .none)
//            try? await groupManager.updateProgress(groupID: group.id, userRef: userRef, amountSaved: amount)
//            enteredAmount = ""
//        }
//    }
//
//    private func calculateTotalProgress(for group: Group) -> Double {
//        let totalSaved = group.progress.values.reduce(0, +)
//        return (totalSaved / group.goalAmount) * 100
//    }
//
//    private func findLeader(for group: Group) -> (name: String, amount: Double)? {
//        let sortedProgress = group.progress.sorted { $0.value > $1.value }
//        if let top = sortedProgress.first {
//            return (name: top.key, amount: top.value)
//        }
//        return nil
//    }
//
//    private func shareInvitation(for group: Group) {
//        guard let inviteURL = groupManager.generateInvitationLink(groupID: group.id) else { return }
//        
//        let activityVC = UIActivityViewController(activityItems: [inviteURL], applicationActivities: nil)
//        if let topController = UIApplication.shared.windows.first?.rootViewController {
//            topController.present(activityVC, animated: true, completion: nil)
//        }
//    }
//}
//
//
//
//#Preview {
//    GroupsView()
//}
