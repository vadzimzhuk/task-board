//
//  ProjectCreationSheetView.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 10/05/2025.
//

import SwiftUI
import SwiftData

struct ProjectCreationSheetView: View {
    @Binding var project: Project?
    @State private var isCreation: Bool = false
    
    @State var projectName: String = ""
    @State var selectedColor: Color = .blue
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    var body: some View {
//        Form {
            VStack {
                TextField("Name", text: $projectName)
                    .padding(10)
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .font(.body)
                    .frame(height: 25)
                
                ColorPickerView(selectedColor: $selectedColor)
                
                Button {
                    if let _ = project {
                        project?.name = projectName
                        project?.color = selectedColor
                    } else {
                        let project = Project(name: projectName)
                        project.color = selectedColor
                        self.project = project
                        context.insert(project)
                    }
                    
                    do {
                        try context.save()
                        dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    Text(project == nil ? "Create" : "Save")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.white)
                        .foregroundColor(Color.accentColor)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding()
                }
                
            }
            .onAppear() {
                projectName = project?.name ?? ""
            }
//        }
    }
}

#Preview {
    ProjectCreationSheetView(project: .constant(nil))
}
