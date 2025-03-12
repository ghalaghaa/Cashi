//
//  TabsHeaderView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//

import SwiftUI
import CloudKit

struct TabsHeaderView: View {
    @Binding var selectedTab: String

    var body: some View {
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

            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.blue.opacity(0.5))
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: selectedTab == "Qattah" ? 70 : 95, height: 4)
                    .foregroundColor(.white)
                    .offset(x: selectedTab == "Qattah" ? 0 : 85)
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, 16)
        }
        .padding(.top, 5)
    }
}
