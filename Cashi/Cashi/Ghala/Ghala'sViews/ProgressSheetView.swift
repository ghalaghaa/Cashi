//
//  ProgressSheetView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//

import SwiftUI
import CloudKit

struct ProgressSheetView: View {
    @Binding var showProgressSheet: Bool

    var body: some View {
        EmptyView()
            .sheet(isPresented: $showProgressSheet) {
                VStack(spacing: 20) {
                    Text("Friends Progress")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach([
                                ("Ghala", "person.circle.fill", 0.35),
                                ("Sara", "person.circle.fill", 0.05),
                                ("Yara", "person.circle.fill", 0.30),
                                ("Talal", "person.circle.fill", 0.10)
                            ], id: \.0) { friend in
                                VStack(spacing: 8) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(Color.white.opacity(0.1))
                                            .frame(width: 80, height: 120)

                                        ZStack(alignment: .bottom) {
                                            RoundedRectangle(cornerRadius: 40)
                                                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]), startPoint: .bottom, endPoint: .top))
                                                .frame(width: 80, height: 120 * friend.2)
                                        }
                                        .frame(width: 80, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 40))

                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(Color.blue, lineWidth: 2)
                                            .frame(width: 80, height: 120)

                                        VStack(spacing: 6) {
                                            Image(systemName: friend.1)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 35, height: 35)
                                                .foregroundColor(.white)

                                            Text("\(Int(friend.2 * 100))%")
                                                .font(.footnote)
                                                .bold()
                                                .foregroundColor(.white)
                                        }
                                    }

                                    Text(friend.0)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                        .bold()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
    }
}

