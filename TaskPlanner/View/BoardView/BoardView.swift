//
//  BoardView.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 23/02/2025.
//

import SwiftUI
import SwiftData

struct BoardView: View {
    
    @Query private var tasks: [Task]
    
    @Query private var openTasks: [Task]
    @Query private var inProgressTasks: [Task]
    @Query private var completedTasks: [Task]
    
    @Environment(\.modelContext) private var context
    
    @State private var isTargeted1: Bool = false
    @State private var isTargeted2: Bool = false
    @State private var isTargeted3: Bool = false
    
    @State private var createNewTask: Bool = false
    @State private var editTask: Bool = false
    @State private var editedTask: Task?
    @State private var itemDragged: Task?
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init() {
        let openRawValue: String = TaskState.open.rawValue
        let openPredicate = #Predicate<Task>{ $0.taskState.rawValue == openRawValue}
        let openDescriptor = FetchDescriptor(predicate: openPredicate)
        self._openTasks = Query(openDescriptor)
        
        let inProgressRawValue: String = TaskState.inProgress.rawValue
        let inProgressPredicate = #Predicate<Task>{ $0.taskState.rawValue == inProgressRawValue}
        let inProgressDescriptor = FetchDescriptor(predicate: inProgressPredicate)
        self._inProgressTasks = Query(inProgressDescriptor)
        
        let completedRawValue: String = TaskState.completed.rawValue
        let completedPredicate = #Predicate<Task>{ $0.taskState.rawValue == completedRawValue}
        let completedDescriptor = FetchDescriptor(predicate: completedPredicate)
        self._completedTasks = Query(completedDescriptor)
        
        let descriptor = FetchDescriptor<Task>()
        self._tasks = Query(descriptor)
    }
    
    var body: some View {
        
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack{
                    HStack(alignment: .top) {
                        LazyVStack {
                            Text("Open")
                                .font(.headline)
                            
                            ForEach(openTasks) { task in
                                TaskBoardCardView(task: task)
                                    .draggable({
                                        itemDragged = task
                                        return task
                                    }())
                                    .onTapGesture {
                                        editedTask = task
                                    }
                            }
                            
                            Background(isTargeted: $isTargeted1)
                                .frame(minHeight: 500)
                        }
                        .dropDestination(for: Task.self) { tasks, location in
                            for task in tasks {
                                if let task = (self.tasks.first { $0.id == task.id }){
                                    task.taskState = .open
                                }
                            }
                            itemDragged = nil
                            try? context.save()
                            
                            return true
                        }
                        isTargeted: { targeted in
                            guard let item = itemDragged,
                                  item.taskState != .open else  { return }
                            
                            withAnimation(.easeIn) {
                                isTargeted1 = targeted
                            }
                        }
                        .background(Background(isTargeted: $isTargeted1))
                        
                        LazyVStack {
                            Text("In Progress")
                                .font(.headline)
                            
                            ForEach(inProgressTasks) { task in
                                TaskBoardCardView(task: task)
                                    .draggable({
                                        itemDragged = task
                                        return task
                                    }())
                                    .onTapGesture {
                                        editedTask = task
                                    }
                            }
                            
                            Background(isTargeted: $isTargeted2)
                                .frame(minHeight: 500)
                        }
                        .dropDestination(for: Task.self) { tasks, location in
                            for task in tasks {
                                if let task = (self.tasks.first { $0.id == task.id }){
                                    task.taskState = .inProgress
                                }
                            }
                            itemDragged = nil
                            try? context.save()
                            
                            return true
                        }
                        isTargeted: { targeted in
                            guard let item = itemDragged,
                                  item.taskState != .inProgress else  { return }
                            
                            withAnimation(.easeIn) {
                                isTargeted2 = targeted
                            }
                        }
                        .background(Background(isTargeted: $isTargeted2))
                        
                        LazyVStack {
                            Text("Done")
                                .font(.headline)
                            
                            ForEach(completedTasks) { task in
                                TaskBoardCardView(task: task)
                                    .draggable({
                                        itemDragged = task
                                        return task
                                    }())
                                    .onTapGesture {
                                        editedTask = task
                                    }
                            }
                            
                            Background(isTargeted: $isTargeted3)
                                .frame(minHeight: 500)
                        }
                        .dropDestination(for: Task.self) { tasks, location in
                            for task in tasks {
                                if let task = (self.tasks.first { $0.id == task.id }){
                                    task.taskState = .completed
                                }
                            }
                            itemDragged = nil
                            try? context.save()
                            
                            return true
                        } isTargeted: { targeted in
                            guard let item = itemDragged,
                                  item.taskState != .completed else  { return }
                            
                            withAnimation(.easeIn) {
                                isTargeted3 = targeted
                            }
                        }
                        .background(Background(isTargeted: $isTargeted3))
                    }
                }
                .padding(.top, 100)
            }
            .padding(10)
            .ignoresSafeArea()
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        createNewTask = true
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.primary)
                    })
                    .sheet(isPresented: $createNewTask) {
                        TaskSheetView()
                            .presentationDetents([.height(380)])
                            .presentationBackground(.thinMaterial)
                    }
                    .sheet(isPresented: $editTask) {
                        if let editedTask {
                            TaskSheetView(editedTask: editedTask)
                                .presentationDetents([.height(380)])
                                .presentationBackground(.thinMaterial)
                        } else { EmptyView() }
                    }
                }
            }
            .onChange(of: editedTask) { oldValue, newValue in
                editTask = editedTask != nil
            }
            .onChange(of: editTask) { _, editTask in
                if !editTask {
                    editedTask = nil
                }
            }
        }
    }
}

private struct Background: View {
    @Binding var isTargeted: Bool
    
    var body: some View {
        isTargeted ? Color.red.opacity(0.8) : Color.theme.background
    }
}

#Preview{
    BoardView()
}
