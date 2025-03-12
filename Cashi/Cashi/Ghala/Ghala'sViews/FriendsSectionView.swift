//
//  FriendsSectionView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//

import SwiftUI
import CloudKit

struct FriendsSectionView: View {
    var body: some View {
        HStack {
            Text("Friends")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .padding(.leading, 16)
            Spacer()
        }
        .padding(.top, 20)
    }
}
