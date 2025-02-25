//
//  TabBarItem.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 23/02/2025.
//

import SwiftUI

struct TabBarItem {
    let title: String
    let iconName: String
    let contentView: () -> AnyView
}
