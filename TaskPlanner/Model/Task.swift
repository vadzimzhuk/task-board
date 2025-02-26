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
    var dueDate: Date?
    var completionDate: Date?
    var creationDate: Date
    var isCompleted: Bool {
        taskState == .completed
    }
    var taskState: TaskState
    
    init(id: UUID = .init(), title: String, dueDate: Date? = nil, taskState: TaskState = .open, creationDate: Date = Date(), completionDate: Date? = nil) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.taskState = taskState
        self.creationDate = creationDate
        self.completionDate = completionDate
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        dueDate = try? values.decode(Date.self, forKey: .dueDate)
        taskState = (try? values.decode(TaskState.self, forKey: .taskState)) ?? .open
        creationDate = (try? values.decode(Date.self, forKey: .creationDate)) ?? Date()
        completionDate = try? values.decode(Date?.self, forKey: .completionDate)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(taskState, forKey: .taskState)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(completionDate, forKey: .completionDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case dueDate
        case isCompleted
        case taskState
        case creationDate
        case completionDate
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
