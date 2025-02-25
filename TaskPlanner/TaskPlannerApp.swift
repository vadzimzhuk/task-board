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
                                        TabBarItem(title: "Calendar",
                                                   iconName: "calendar",
                                                   contentView: {AnyView({
                                                       TaskView()
                                                   }())
                                                   }),
                                        TabBarItem(title: "Board",
                                                   iconName: "list.bullet",
                                                   contentView: {AnyView({
                                                       BoardView()
                                                           .frame(maxHeight: .infinity)
                                                   }())
                                                   })
                                                   
                                      ])
        }
        .modelContainer(for: Task.self)
    }
}
