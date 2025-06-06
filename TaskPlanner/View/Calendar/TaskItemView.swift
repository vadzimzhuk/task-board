//
//  TaskItemView.swift
//  TaskPlanner
//

import SwiftUI
import SwiftData

struct TaskItemView: View {
    @Bindable var task: Task
    @Environment(\.modelContext) private var context
    
    @State private var offset = CGSize.zero
//    @State private var isSwipingToDelete = false
    
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(Color.theme.ocean)
                .frame(width: 8, height: 8)
                .padding(.horizontal, 15)
            VStack(alignment: .leading, spacing: 10) {
                if task.isCompleted {
                    Text(task.title)
                        .font(.headline)
                        .strikethrough()
                    if let dueDate = task.dueDate {
                        Label("\(dueDate.format("hh:mm a"))", systemImage: "clock")
                            .font(.subheadline)
                            .strikethrough()
                    }
                } else {
                    Text(task.title)
                        .font(.headline)
                    if let dueDate = task.dueDate {
                        Label("\(dueDate.format("hh:mm a"))", systemImage: "clock")
                            .font(.subheadline)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 35, alignment: .leading)
            .padding()
            .clipShape(.rect(cornerRadius: 15))
            .opacity(2 - Double(abs(offset.width / 90)))
        }
        .padding(.horizontal)
        .padding(.bottom, 25)
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Task.self, configurations: config)
    
    let task = Task(title: "Example Task", dueDate: Date())
    
    return TaskItemView(task: task)
        .modelContainer(container)
}
