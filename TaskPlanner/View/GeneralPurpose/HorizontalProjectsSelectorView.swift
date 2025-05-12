//
//  HorizontalScrollView.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 12/05/2025.
//

import SwiftUI

struct HorizontalProjectsSelectorView: View {
    private var projects: [ProjectDTO]
    @Binding var selectedProjects: Set<String>
    
    init(projects: [Project], selectedProjects: Binding<Set<String>>) {
        self.projects = projects.map{ ProjectDTO(id: $0.id.uuidString, name: $0.name, color: $0.color) }
        self.projects.append(ProjectDTO(id: "", name: "N/A", color: .black))
        self._selectedProjects = selectedProjects
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(projects) { project in
                    let isSelected = selectedProjects.contains(project.id)

                    Text(project.name)
                        .font(.subheadline.bold())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Rectangle()
                                .stroke(project.color.opacity(isSelected ? 1 : 0.5), lineWidth: 1)
                        )
                        .foregroundColor(project.color.opacity(isSelected ? 1 : 0.5))
                        .onTapGesture {
                            toggleSelection(for: project)
                        }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 50)
    }

    private func toggleSelection(for project: ProjectDTO) {
        if selectedProjects.contains(project.id) {
            selectedProjects.remove(project.id)
        } else {
            selectedProjects.insert(project.id)
        }
    }
}

#Preview {
    HorizontalProjectsSelectorView(projects: [
        Project(name: "Home"),
        Project(name: "Work"),
        Project(name: "Personal")
    ], selectedProjects: .constant([""]))
}

private struct ProjectDTO: Identifiable {
    let id: String
    let name: String
    let color: Color
}
