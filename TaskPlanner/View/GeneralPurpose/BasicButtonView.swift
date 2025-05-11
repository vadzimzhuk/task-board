//
//  BasicButtonVIew.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 09/05/2025.
//

import SwiftUI

struct BasicButtonView: View {
    var title: String = ""
    var isActive: Bool = true
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color.white)
                .frame(height: 50)
                .overlay(
                    Rectangle()
                        .stroke(isActive ? Color.black : Color.gray, lineWidth: 1)
                )
            Text(title)
                .foregroundStyle(isActive ? Color.black : Color.gray)
        }
    }
}

#Preview {
    VStack {
        BasicButtonView(title: "Active Button")
        BasicButtonView(title: "Inactive Button", isActive: false)
    }
    .padding(.horizontal)
}
