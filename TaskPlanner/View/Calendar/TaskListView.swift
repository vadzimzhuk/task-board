//
//  TaskListView.swift
//  TaskPlanner
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    @Binding var date: Date
    @Query private var tasks: [Task]
    
    init(date: Binding<Date>) {
        self._date = date
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date.wrappedValue)
        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        let predicate = #Predicate<Task> {
            return $0.dueDate ?? $0.creationDate >= startDate && $0.dueDate ?? $0.creationDate < endOfDate
        }
        
        let sortDescriptor = [
            SortDescriptor(\Task.dueDate, order: .forward)
        ]
        self._tasks = Query(filter: predicate, sort: sortDescriptor, animation: .snappy)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(tasks) { task in
                    TaskItemView(task: task)
                        .background(alignment: .leading) {
                            if tasks.last?.id != task.id {
                                Rectangle()
                                    .frame(width: 1)
                                    .foregroundColor(Color.theme.secondaryText)
                                    .offset(x: 35, y: 38)
                            }
                        }
                }
            }
            .padding(.top, 20)       
        }
    }
}

#Preview {
    TaskListView(date: .constant(Date()))
        .modelContainer(for: Task.self)
}
