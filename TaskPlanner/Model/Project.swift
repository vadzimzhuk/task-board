//
//  Project.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 10/05/2025.
//

import Foundation
import SwiftData

@Model
class Project: Identifiable, Codable {
    var id: UUID
    var name: String
    var color: String
    var tasks: [Task] = []
    
    init(name: String, color: String = "", tasks: [Task] = []) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.tasks = tasks
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.color = try container.decode(String.self, forKey: .color)
        self.tasks = try container.decode([Task].self, forKey: .tasks)
        
        for task in tasks {
            task.project = self
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(color, forKey: .color)
        
//        let tasksWithoutProject = tasks.map { task in
//            Task(title: task.title)
//        }
        
        let tasksWithoutProject = tasks.map {
            $0.project = nil
            return $0
        }
        
        try container.encode(tasksWithoutProject, forKey: .tasks)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, color, tasks
    }
}
