//
//  Task.swift
//  Finity
//
//  Created by Casey Chin on 4/18/24.
//

import Foundation

struct Task: Comparable {
    
    static func < (lhs: Task, rhs: Task) -> Bool {
        
        return lhs.priority < rhs.priority
        
    }
    
    static func > (lhs: Task, rhs: Task) -> Bool {
        
        return lhs.priority > rhs.priority
        
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        
        return lhs.priority == rhs.priority
        
    }
    

    var name: String
    var description: String?
    var date: Date
    public var priority: Int
    
    
    init(title: String, description: String? = nil, date: Date = Date(), priority: Int) {
        self.name = title
        self.description = description
        self.date = date
        self.priority = priority
    }
    
    var isComplete: Bool = false {

        didSet {
            if isComplete {
            
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }
    

    
    private(set) var completedDate: Date?

    var createdDate: Date = Date()

    var id: String = UUID().uuidString
}




extension Task : Codable {
    
    
    static var tasksKey: String {
        return "Tasks"
    }
    
    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {
        
        
        let savedTasks = UserDefaults.standard
        let encodedData = try! JSONEncoder().encode(tasks)
        savedTasks.set(encodedData, forKey: Task.tasksKey)
        
        
    }
    
    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        
        // TODO: Get the array of saved tasks from UserDefaults
        
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: Task.tasksKey){
            let decodedTasks = try! JSONDecoder().decode([Task].self,from: data)
            return decodedTasks
        } else {
            return []
        }
        
        // 👈 replace with returned saved tasks
    }
    
    // Add a new task or update an existing task with the current task.
    func save() {
        
        // TODO: Save the current task
        
        var tasks = Task.getTasks()
    
        if let i = tasks.firstIndex(where: { $0.id.elementsEqual(self.id) }) {
            
            tasks.remove(at: i)
            tasks.insert(self, at: i)
            
        } else {
            tasks.append(self)
            print("not match")
        }
        
        Task.save(tasks)
        
    }
    
    func getPriority() -> Int {
        
        return priority
        
    }
}
