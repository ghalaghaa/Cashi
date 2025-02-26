////
////  CashiApp.swift
////  Cashi
////
////  Created by Ghala Alnemari on 24/08/1446 AH.
////
//
//import SwiftUI
//
//@main
//struct CashiApp: App {
//    
//     let currentUserIsSignedIn: Bool
//    
//        init() {
//        //let userIsSignedIn: Bool = CommandLine.arguments. contains("-UITest_startSignedIn" ) ? t
//        let userIsSignedIn: Bool = ProcessInfo.processInfo.arguments.contains("-UITest_startSignedIn") ? true : false
//        //let value = ProcessInfo.processInfo.environment["-UITest_startSignedIn2" ]
//        //let userIsSignedIn: Bool = value == "true" ? true: false
//        self.currentUserIsSignedIn = userIsSignedIn
//       
//     }
//
//    var body: some Scene {
//        WindowGroup {
//            CloudKitUserBootcamp()
////        UITestingBootcampView(currentUserIsSignedIn: currentUserIsSignedIn)
//
//
//        }
//    }
//}

import SwiftUI
import CloudKit

@main
struct CashiApp: App {
    let currentUserIsSignedIn: Bool

    init() {
        let userIsSignedIn: Bool = ProcessInfo.processInfo.arguments.contains("-UITest_startSignedIn") ? true : false
        self.currentUserIsSignedIn = userIsSignedIn
    }

    var body: some Scene {
        WindowGroup {
            CloudKitUserBootcamp() // ✅ تأكد من أن الاسم صحيح
        }
    }
}
