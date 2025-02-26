//
//  TaskSheetView.swift
//  TaskPlanner
//

import SwiftUI
import SwiftData

struct TaskSheetView: View {
    @State private var taskTitle: String
    @State private var hasDate: Bool
    @State private var dueDate: Date?
    @State private var taskDate: Date
    @State private var editedTask: Task
    @State private var newTask: Bool
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    init(editedTask: Task = Task(title: "")) {
        self.newTask = editedTask.title.isEmpty
        self.editedTask = editedTask
        self.taskTitle = editedTask.title
        self.dueDate = editedTask.dueDate
        self.hasDate = editedTask.dueDate != nil
        self.taskDate = editedTask.dueDate ?? Date()
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
                            let task = editedTask
                            do {
                                if newTask {
                                    context.insert(task)
                                }
                                try context.save()
                                dismiss()
                            } catch {
                                print(error.localizedDescription)
                            }
                        } label: {
                            Text(newTask ? "Create" : "Save")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Spacer()
                    
                    TextField("Title", text: $taskTitle)
                        .padding(10)
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .font(.body)
                        .frame(height: 25)
//                        .foregroundColor(Color.secondaryText)
                        
                    Toggle("Due date", isOn: $hasDate)
                        .padding(10)
                        .font(.body)
                        .foregroundColor(Color.primary)
                    
                    ZStack {
                        if hasDate {
                            DatePicker("", selection: $taskDate)
                                .datePickerStyle(.compact)
                                .padding(.horizontal)
                        }
                    }
                    .frame(height: 35)
                }
                .padding()
                
                Spacer()
                
                Button {
                    let task = editedTask
                    do {
                        if newTask {
                            context.insert(task)
                        }
                        try context.save()
                        dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    Text(newTask ? "Create" : "Save")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.white)
                        .foregroundColor(Color.accentColor)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .ignoresSafeArea()
            .padding(.bottom)
            .onChange(of: hasDate) { _, hasDate in
                if hasDate {
                    dueDate = taskDate
                } else {
                    dueDate = nil
                }
            }
            .onChange(of: taskDate) { _, taskDate in
                dueDate = taskDate
            }
            .onChange(of: taskTitle) { _, taskTitle in
                editedTask.title = taskTitle
            }
            .onChange(of: dueDate) { _, dueDate in
                editedTask.dueDate = dueDate
            }
    }
}

#Preview {
    TaskSheetView()
}
