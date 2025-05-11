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
    
    @State var projectName: String = ""
//    @State var selectedColor: Color = .blue
    
//    var colors: [Color] = [.blue, .orange, .pink, .purple, .brown, .yellow, .red, .green, .yellow]
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    var body: some View {
//        Form {
            VStack {
//                Picker("Color", selection: $selectedColor) {
//                    ForEach(colors, id: \.hashValue) { color in
//                        Text(color.description).tag(color)
//                    }
//                }
                
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
                
                Button {
                    let project = Project(name: projectName, color: ""/*selectedColor.description*/)
                    self.project = project
                    print(project)
                    
                    context.insert(project)
                    do {
                        try context.save()
                        dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    Text("Create")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.white)
                        .foregroundColor(Color.accentColor)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding()
                }
                
            }            
//        }
    }
}

#Preview {
    ProjectCreationSheetView(project: .constant(nil))
}
