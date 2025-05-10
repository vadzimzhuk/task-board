//
//  CustomTabBarView.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 23/02/2025.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedIndex: Int
    let tabBarItems: [TabBarItem]

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<tabBarItems.count, id: \.self) { index in
                    BasicButtonVIew(title: tabBarItems[index].title, isSelected: selectedIndex == index)
                    .onTapGesture {
                        selectedIndex = index
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .background(_BlurVisualEffectViewRepresentable(style: .light))
        .clipShape(RoundedRectangle(cornerRadius: 32))
    }
}

#Preview {
    ZStack {
        Color.green
        
        VStack {
            Spacer()
            CustomTabBarView(selectedIndex: .constant(0), tabBarItems: [
                .init(title: "First", iconName: ""){AnyView(Color.green)},
                .init(title: "Second", iconName: ""){AnyView(Color.red)},
                .init(title: "Thrid", iconName: ""){AnyView(Color.red)}
              ])
            .frame(height: 100)
        }
    }
    .ignoresSafeArea()
}
