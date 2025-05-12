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
    @Query private var projects: [Project]
    
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
    @State private var itemDragged: TaskDTO?
    
    @State private var selectedProjects: Set<String> = []
    
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
        
        let projectDescriptor = FetchDescriptor<Project>()
        self._projects = Query(projectDescriptor)
    }
    
    private func filteredTasks(_ inputTasks: [Task]) -> [Task] {
        let outputTasks = inputTasks.filter { task in
            selectedProjects.contains(task.projectIdString)
        }
        
        return outputTasks
    }
    
    private func handleDropDestination(droppedTasks: [TaskDTO], droppedState: TaskState) -> Bool {
        for droppedTask in droppedTasks {
            if let task = (self.tasks.first { $0.id == droppedTask.id }){
                // switch state on model object
                task.taskState = droppedState
            }
        }
        itemDragged = nil
        try? context.save()
        
        return true
    }
    
    var body: some View {
            VStack {
                HorizontalProjectsSelectorView(projects: projects, selectedProjects: $selectedProjects)
                
                HStack {
                    Text("Open".capitalized)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                    Text("In Progress".capitalized)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                    Text("Done".capitalized)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray)
                
                Spacer()
                
                ScrollView(.vertical, showsIndicators: true) {
                    VStack{
                        HStack(alignment: .top) {
                            LazyVStack {
                                
                                ForEach(filteredTasks(openTasks)) { task in
                                    TaskBoardCardView(task: task)
                                        .draggable({
                                            itemDragged = task.dto
                                            return task.dto
                                        }())
                                        .onTapGesture {
                                            editedTask = task
                                        }
                                }
                                
                                NewTicketButton(createNewTask: $createNewTask)
                                    .padding(.top)
                                
                                Background(isTargeted: $isTargeted1)
                                    .frame(minHeight: 600)
                            }
                            .dropDestination(for: TaskDTO.self) { tasks, location in
                                return handleDropDestination(droppedTasks: tasks, droppedState: .open)
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
                                
                                ForEach(filteredTasks(inProgressTasks)) { task in
                                    TaskBoardCardView(task: task)
                                        .draggable({
                                            itemDragged = task.dto
                                            return task.dto
                                        }())
                                        .onTapGesture {
                                            editedTask = task
                                        }
                                }
                                
                                Background(isTargeted: $isTargeted2)
                                    .frame(minHeight: 600)
                            }
                            .dropDestination(for: TaskDTO.self) { tasks, location in
                                return handleDropDestination(droppedTasks: tasks, droppedState: .inProgress)
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
                                
                                ForEach(filteredTasks(completedTasks)) { task in
                                    TaskBoardCardView(task: task)
                                        .draggable({
                                            itemDragged = task.dto
                                            return task.dto
                                        }())
                                        .onTapGesture {
                                            editedTask = task
                                        }
                                }
                                
                                Background(isTargeted: $isTargeted3)
                                    .frame(minHeight: 600)
                            }
                            .dropDestination(for: TaskDTO.self) { tasks, location in
                                return handleDropDestination(droppedTasks: tasks, droppedState: .completed)
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
                }
                .padding(10)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            createNewTask = true
                        }, label: {
                            Image(systemName: "plus")
                                .foregroundColor(.primary)
                        })
                        .sheet(isPresented: $createNewTask) {
                            TaskSheetView(context: context)
                                .presentationDetents([.height(380)])
                                .presentationBackground(.thinMaterial)
                        }
                        .sheet(isPresented: $editTask) {
                            if let editedTask {
                                TaskSheetView(editedTask: editedTask, context: context)
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
                .onAppear() {
                    var projectIds = Set(projects.map{$0.id.uuidString})
                    projectIds.insert("")
                    selectedProjects = projectIds
                    
                }
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 50)
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

private extension Task {
    var projectIdString: String {
        self.project?.id.uuidString ?? ""
    }
}
