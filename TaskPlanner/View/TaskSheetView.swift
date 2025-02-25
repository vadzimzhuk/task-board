//
//  TaskSheetView.swift
//  TaskPlanner
//

import SwiftUI
import SwiftData

struct TaskSheetView: View {
    @State private var taskTitle: String = ""
    @State private var hasDate: Bool = false
    @State private var taskDate: Date = .init()
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
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
                            let task = Task(title: taskTitle, date: taskDate)
                            do {
                                context.insert(task)
                                try context.save()
                                dismiss()
                            } catch {
                                print(error.localizedDescription)
                            }
                        } label: {
                            Text("Add")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Spacer()
                    
                    TextField("  Title", text: $taskTitle)
                        .font(.body)
                        .frame(height: 35)
                        .foregroundColor(Color.secondaryText)
                        .cornerRadius(6)
                        .border(Color.gray)
                        
                    Toggle("Due date", isOn: $hasDate)
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
                    let task = Task(title: taskTitle, date: taskDate)
                    do {
                        context.insert(task)
                        try context.save()
                        dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    Text("Add Task")
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
            .preferredColorScheme(.dark)
            .padding(.bottom)
    }
}

#Preview {
    TaskSheetView()
}
