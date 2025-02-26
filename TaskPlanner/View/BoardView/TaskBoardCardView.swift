//
//  TaskItemView.swift
//  TaskPlanner
//

import SwiftUI
import SwiftData

struct TaskBoardCardView: View {
    @Bindable var task: Task
    @Environment(\.modelContext) private var context
    
    @State private var offset = CGSize.zero
    @State private var isSwipingToDelete = false
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                if task.isCompleted {
                    Text(task.title)
                        .fixedSize(horizontal: false, vertical: false)
                        .font(Font.system(size: 12, weight: .bold))
                        .strikethrough()
//                    Label("\(task.date.format("DD:MM a"))", systemImage: "clock")
//                        .font(.subheadline)
//                        .strikethrough()
                } else {
                    Text(task.title)
                        .font(Font.system(size: 12, weight: .bold))
//                    Label("\(task.date.format("hh:mm a"))", systemImage: "clock")
//                        .font(.subheadline)
                }
            }
            .frame(height: 55)
            .frame(maxWidth: .infinity, maxHeight: 55, alignment: .leading)
            .padding()
            .background(isSwipingToDelete ? Color.red.opacity(0.7) : Color.theme.darkBackground)
            .clipShape(.rect(cornerRadius: 15))
            .onTapGesture {
            }
            .opacity(2 - Double(abs(offset.width / 90)))
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Task.self, configurations: config)
    
    let task = Task(title: "Example Task", dueDate: Date())
    
    return TaskBoardCardView(task: task)
        .modelContainer(container)
}
