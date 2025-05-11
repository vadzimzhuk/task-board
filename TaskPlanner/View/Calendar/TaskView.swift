//
//  TaskView.swift
//  TaskPlanner
//

import SwiftUI
import SwiftData

struct TaskView: View {
    @StateObject var viewModel = TaskViewModel()
    @State private var createNewTask: Bool = false
    @State var currentDate: Date = .init()
    @Environment(\.modelContext) private var context
        
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading) {
                    Text(self.viewModel.currentDate.formatted(.dateTime.year().month(.wide).day().weekday(.wide)))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.secondaryText)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    WeekHeaderView(viewModel: viewModel)
                        .frame(height: 89)
                    
                    ScrollView(.vertical) {
                        TaskListView(date: $viewModel.currentDate)
                    }
                    .scrollIndicators(.hidden)
                }
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        HStack {
                            Text(self.viewModel.currentDate.formatted(.dateTime.month(.wide)))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text(self.viewModel.currentDate.formatted(.dateTime.year()))
                                .foregroundColor(Color.theme.secondaryText)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                    }
                    
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
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        TaskView()
            .modelContainer(for: Task.self)
    }
}
