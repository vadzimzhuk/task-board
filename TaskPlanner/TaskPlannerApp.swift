//
//  TaskPlannerApp.swift
//  TaskPlanner
//

import SwiftUI

@main
struct TaskPlannerApp: App {
    
    var body: some Scene {
        WindowGroup {
            CustomTabBarContainerView(viewModel: TabViewModel(),
                                      tabBarItems: [
                                        
                             TabBarItem(title: "Board",
                                        iconName: "list.bullet",
                                        contentView: {AnyView({
                                            BoardView()
                                                .frame(maxHeight: .infinity)
                                        }())
                                        }),
                                        TabBarItem(title: "Calendar",
                                                   iconName: "calendar",
                                                   contentView: {AnyView({
                                                       TaskView()
                                                   }())
                                                   })
                                      ])
        }
        .modelContainer(for: Task.self)
    }
}
