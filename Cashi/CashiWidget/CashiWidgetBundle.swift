//
//  CashiWidgetBundle.swift
//  CashiWidget
//
//  Created by Ghala Alnemari on 08/09/1446 AH.
//

import WidgetKit
import SwiftUI

@main
struct CashiWidgetBundle: WidgetBundle {
    var body: some Widget {
        CashiWidget()
        CashiWidgetControl()
        CashiWidgetLiveActivity()
    }
}
