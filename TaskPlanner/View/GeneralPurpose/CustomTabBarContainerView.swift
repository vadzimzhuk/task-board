//
//  CustomTabBarContainerView.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 23/02/2025.
//

import SwiftUI

struct CustomTabBarContainerView: View {
    
    @ObservedObject var viewModel: TabViewModel

    let tabBarItems: [TabBarItem]

    var body: some View {
            ZStack {
                tabBarItems[viewModel.selectedTabIndex].contentView()
                
                    VStack {
                        Spacer()
                        CustomTabBarView(selectedIndex: $viewModel.selectedTabIndex, tabBarItems: tabBarItems)
                            .frame(height: 92)
                    }
            }
            .ignoresSafeArea()
    }
}

class TabViewModel: ObservableObject {
    @Published var selectedTabIndex: Int = 0
}

#Preview {
    CustomTabBarContainerView(viewModel: TabViewModel(),
                              tabBarItems: [
                                .init(title: "First", iconName: ""){AnyView(Color.green)},
                                .init(title: "Second", iconName: ""){AnyView(Color.red)},
                                .init(title: "Thrid", iconName: ""){AnyView(Color.red)}
                              ])
}
