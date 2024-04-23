//
//  CalendarController.swift
//  Finity
//
//  Created by Casey Chin on 4/17/24.
//

import UIKit

class CalendarController: UIViewController {
    
    
    private var calendarView: UICalendarView!
    
    var tableView: UITableView!
    
    var dailyTasks = DailyTasksController()
    
    var tasks: [Task] = []
    private var selectedTasks: [Task] = []
    
    @IBOutlet weak var calView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView = dailyTasks.tableView
        
        self.calendarView = UICalendarView()
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        calView.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: calView.leadingAnchor),
            calendarView.topAnchor.constraint(equalTo: calView.topAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calView.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: calView.bottomAnchor)
        ])
        
        calendarView.delegate = self
        // 2.
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        tasks = Task.getTasks()

        let todayComponents = Calendar.current.dateComponents([.year, .month, .weekOfMonth, .day], from: Date())

        let todayTasks = filterTasks(for: todayComponents)

        if !todayTasks.isEmpty {

            let selection = calendarView.selectionBehavior as? UICalendarSelectionSingleDate
  
            selection?.setSelected(todayComponents, animated: false)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refreshTasks()
    }
    
    
    private func filterTasks(for dateComponents: DateComponents) -> [Task] {
        // 1.
        let calendar = Calendar.current
        // 2.
        guard let date = calendar.date(from: dateComponents) else {
            return []
        }
        // 3.
        let tasksMatchingDate = tasks.filter { task in
            // i.
            return calendar.isDate(task.date, equalTo: date, toGranularity: .day)
        }
        // 4.
        return tasksMatchingDate
    }
    
    private func refreshTasks() {
        // 1.
        tasks = Task.getTasks()
        // 2.
        tasks.sort { lhs, rhs in
            if lhs.isComplete && rhs.isComplete {
                return lhs.completedDate! < rhs.completedDate!
            } else if !lhs.isComplete && !rhs.isComplete {
                return lhs.createdDate < rhs.createdDate
            } else {
                return !lhs.isComplete && rhs.isComplete
            }
        }
        // 3.
        if let selection = calendarView.selectionBehavior as? UICalendarSelectionSingleDate,
            let selectedComponents = selection.selectedDate {

            selectedTasks = filterTasks(for: selectedComponents)
        }
        // 4.
        let taskDueDates = tasks.map(\.date)
        // 5.
        var taskDueDateComponents = taskDueDates.map { dueDate in
            Calendar.current.dateComponents([.year, .month, .weekOfMonth, .day], from: dueDate)
        }
        // 6.
        taskDueDateComponents.removeDuplicates()
        // 7.
        calendarView.reloadDecorations(forDateComponents: taskDueDateComponents, animated: false)
        // 8.
//        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

extension CalendarController: UICalendarViewDelegate {

    // Configure the decorations for each calendar date.
    // Similar to how the table view's cellForRowAt datasource method allows us to create, configure and return a cell for each row of the table view, the `calendarView(_:decorationFor:)` delegate method of the calendar view allows for creating, configuring and returning a "decoration" to be shown (or not shown) for all dates displayed by the calendar.
    // In our case, we'll add a decoration for any date that matches one or more tasks due dates
    // If all of the tasks for that date are completed, we'll show a filled in circle to indicate all tasks are complete.
    // If there are incomplete tasks for a given date, we'll show an empty circle to indicate NOT all tasks are complete.
    // If there are no tasks for a date, we won't add any decoration.

    // 1. Filter tasks down to only tasks matching the date we're currently configuring decorations for.
    //    - (i.e. the dateComponents provided by the delegate method).
    // 2. Check if any of the tasks are incomplete.
    // 3. If there are one or more tasks for the given date....
    //    i. Create an image based on the task's completion status.
    //    ii. Use the image created above to create and return a `Decoration` of type, `.image`
    //    iii. If there are no tasks due on the given date, return nil so there is no decoration shown for the date.
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        // 1.
        let tasksMatchingDate = filterTasks(for: dateComponents)
        // 2.
        let hasUncompletedTask = tasksMatchingDate.contains { task in
            return !task.isComplete
        }
        // 3.
        if !tasksMatchingDate.isEmpty {
            // i.
            let image = UIImage(systemName: hasUncompletedTask ? "circle" : "circle.inset.filled")
            // ii.
            return .image(image, color: .systemBlue, size: .large)
        } else {
            // iii.
            return nil
        }
    }
}

// MARK: - Calendar Selection Delegate Methods
extension CalendarController: UICalendarSelectionSingleDateDelegate {

    // Similar to the `tableView(_:didSelectRowAt:)` delegate method, the Calendar View's `dateSelection(_:didSelectDate:)` delegate method is called whenever a user selects a date on the calendar.
    // 1. Unwrap the optional date components for the selected date.
    // 2. Update selectedTasks by filtering all tasks for the selected date.
    // 3. If there are no tasks associated with the selected date, deselect the date by setting the selection to nil
    // 4. Otherwise, if there are associated tasks for the date, reload the table view of selected tasks.
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        // 1.
        guard let components = dateComponents else { return }
        // 2.
        selectedTasks = filterTasks(for: components)
        // 3.
        if selectedTasks.isEmpty {
            selection.setSelected(nil, animated: true)
        }
        // 4.
//        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

// MARK: - Table View Datasource Methods
//extension CalendarController: UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // 1.
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
//        // 2.
//        let task = selectedTasks[indexPath.row]
//        // 3.
//        cell.configure(with: task) { [weak self] task in
//            // 1.
//            task.save()
//            // ii.
//            self?.refreshTasks()
//        }
//        // 4.
//        return cell
//    }
//    
//
//    // The number of rows to show based on the number of selected tasks (i.e. tasks associated with the current selected date)
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return selectedTasks.count
//    }
//    
//
//    // Create and configure a cell for each row of the table view (i.e. each task in the selectedTasks array)
//    // 1. Dequeue a Task cell.
//    // 2. Get the selected task associated with the current row.
//    // 3. Configure the cell with the selected task and add the code to be run when the complete button is tapped...
//    //    i. Save the task passed back in the closure.
//    //    ii. Refresh the tasks list to reflect the updates with the saved task.
//    // 4. Return the configured cell.
//    
//}

extension Array where Element: Equatable, Element: Hashable {

    // A helper method to remove any duplicate values from an array.
    // 1. Initialize a set with the given array
    //    - Sets guarantee that all values are unique, so any duplicates are removed.
    //    - This method is an array instance method so `self` references the array instance on which the method is being called.
    // 2. Initialize an array from the set to arrive at an array with no duplicate values.
    mutating func removeDuplicates() {
        // 1.
        let set = Set(self)
        // 2.
        self = Array(set)
    }
}



