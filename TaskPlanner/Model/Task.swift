//
//  Task.swift
//  TaskPlanner
//

import SwiftUI
import SwiftData

//@MainActor
@Model
class Task: Identifiable, Codable, Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .content)
    }
    
    var id: UUID
    var title: String
    var date: Date
    var isCompleted: Bool {
        taskState == .completed
    }
    var taskState: TaskState
    
    init(id: UUID = .init(), title: String, date: Date, isCompleted: Bool = false, taskState: TaskState = .open) {
        self.id = id
        self.title = title
        self.date = date
        self.taskState = taskState
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        date = try values.decode(Date.self, forKey: .date)
        taskState = (try? values.decode(TaskState.self, forKey: .taskState)) ?? .open
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(date, forKey: .date)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case date
        case isCompleted
        case taskState
    }
}

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
    
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}

struct TaskState: Codable, Equatable {
    let rawValue: String
    
    static let open = TaskState(rawValue: "open")
    static let inProgress = TaskState(rawValue: "in-progress")
    static let completed = TaskState(rawValue: "completed")
}
