//
//  BasicButtonVIew.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 09/05/2025.
//

import SwiftUI

struct BasicButtonVIew: View {
    var title: String = ""
    var isSelected: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color.white)
                .frame(height: 50)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: isSelected ? 2 : 1)
                )
            Text(title)
                .foregroundStyle(isSelected ? Color.black : Color.gray)
        }
    }
}

#Preview {
    BasicButtonVIew()
}
