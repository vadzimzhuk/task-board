//
//  Project.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 10/05/2025.
//

import SwiftUI
import SwiftData

struct ProjectSelectorView: View {
    @Query var projects: [Project]
    @Binding var selectedProject: Project?

    var body: some View {
        Picker("Project", selection: $selectedProject) {
            Text("None").tag(Optional<Project>(nil))
            
            ForEach(projects, id: \.id) { project in
                Text(project.name).tag(Optional(project))
            }
        }
        .pickerStyle(.menu)  // .wheel, .inline, .segmented
    }
}

#Preview {
    ProjectSelectorView(selectedProject: .constant(nil))
}
