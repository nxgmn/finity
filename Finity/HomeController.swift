//
//  HomeController.swift
//  Finity
//
//  Created by Casey Chin on 4/16/24.
//

import UIKit

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let prompts = ["Hope you're having a great day!", "Are you ready?"]
    
    var focusTasks = 10
    
    var settings = SettingsViewController()
    
    var tasks = [Task]()
    
    @IBOutlet weak var promptLabel: UILabel!
    
    @IBOutlet weak var taskView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        focusTasks = settings.numTasks
        
        tasks = getDisplayedTasks()
        // Set delegate and data source
        taskView.delegate = self

        setContentScrollView(taskView)
        
        promptLabel.text = prompts.randomElement()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        taskView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return focusTasks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create and configure UITableViewCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        
        let task = tasks[indexPath.row]
        
        cell.configure(with: task) { [weak self] task in
            // 1.
            task.save()
            // ii.
            self?.refreshTasks()
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection
        print("Selected row \(indexPath.row)")
    }
    
    func getDisplayedTasks() -> [Task] {
        
        var allTasks = Task.getTasks()
        
        allTasks.sort(by: >)
        
        var displayTasks = [Task]()
        
        for i in stride(from: 0, to: focusTasks, by: 1) {
            
            displayTasks.append(allTasks.first!)
            
        }
        
        return displayTasks
        
    }
    
    func refreshTasks() {
        
        tasks = getDisplayedTasks()
        
        taskView.reloadSections(IndexSet(integer: 0), with: .automatic)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}


