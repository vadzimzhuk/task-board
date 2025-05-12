//
//  TaskSheetView.swift
//  TaskPlanner
//

import SwiftUI
import SwiftData

final class TaskSheetViewModel: ObservableObject {
    @Published var taskTitle: String
    @Published var hasDate: Bool
    @Published var dueDate: Date?
    @Published var taskDate: Date
    @Published var editedTask: Task
    @Published var newTask: Bool
    @Published var project: Project?
    @Published var projectCreationMode: Bool = false
    
    private var context: ModelContext

    init(editedTask: Task = Task(title: ""), context: ModelContext) {
        self.editedTask = editedTask
        self.newTask = editedTask.title.isEmpty
        self.taskTitle = editedTask.title
        self.dueDate = editedTask.dueDate
        self.hasDate = editedTask.dueDate != nil
        self.taskDate = editedTask.dueDate ?? Date()
        self.project = editedTask.project
        
        self.context = context
    }
    
    func save() {
        editedTask.title = taskTitle
        editedTask.dueDate = hasDate ? dueDate : nil
        editedTask.project = project
        
        do {
            if newTask {
                context.insert(editedTask)
            }
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskSheetView: View {
    
    @StateObject private var viewModel: TaskSheetViewModel
    
    @Environment(\.dismiss) var dismiss
    
    init(editedTask: Task = Task(title: ""), context: ModelContext) {
        _viewModel = StateObject(wrappedValue: TaskSheetViewModel(editedTask: editedTask, context: context))
    }
    
    var createButton: some View {
        Button {
            viewModel.save()
            dismiss()
        } label: {
            BasicButtonView(title: viewModel.newTask ? "Create" : "Save", isActive: true)
                .padding(.horizontal)
        }
    }
    
    var body: some View {
            VStack(alignment: .leading, spacing: 25) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button {
                            viewModel.save()
                            dismiss()
                        } label: {
                            Text(viewModel.newTask ? "Create" : "Save")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        ProjectSelectorView(selectedProject: $viewModel.project)
                        
                        Button (action: {
                            viewModel.projectCreationMode = true
                        }, label:
                                    {
                            Text(viewModel.project == nil ? "New project" : "Edit project")
                        })
                    }
                    
                    TextField("Title", text: $viewModel.taskTitle)
                        .padding(10)
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .font(.body)
                        .frame(height: 25)
                    
                    Toggle("Due date", isOn: $viewModel.hasDate)
                        .padding(10)
                        .font(.body)
                        .foregroundColor(Color.primary)
                    
                    ZStack {
                        if viewModel.hasDate {
                            DatePicker("", selection: $viewModel.taskDate)
                                .datePickerStyle(.compact)
                                .padding(.horizontal)
                        }
                    }
                    .frame(height: 35)
                }
                .padding()
                
                Spacer()
                
                createButton
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .ignoresSafeArea()
            .padding(.bottom)
            
            .sheet(isPresented: $viewModel.projectCreationMode) {
                ProjectCreationSheetView(project: $viewModel.project)
            }
//        }
    }
}

#Preview {
    TaskSheetView(context: .preview)
}

// Move away
extension ModelContext {
    static var preview: ModelContext {
        let schema = Schema([Task.self, Project.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)

        do {
            let container = try ModelContainer(for: schema, configurations: config)
            let context = ModelContext(container)
            return context
        } catch {
            fatalError("Failed to create preview ModelContext: \(error)")
        }
    }
}
