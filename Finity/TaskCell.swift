//
//  TableViewCell.swift
//  Finity
//
//  Created by Casey Chin on 4/17/24.
//

import UIKit

class TaskCell: UITableViewCell {
    
    
    @IBOutlet weak var taskName: UILabel!
    
    @IBOutlet weak var emoji: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        self.sizeToFit()
        self.bounds.size = CGSize(width: 500.0, height: 100.0)
        self.emoji.bounds.size = CGSize(width: 100.0, height: 100.0)
        self.taskName.bounds.size = CGSize(width: 200.0, height: 100.0)
        
    }
    
    func setPriorityImage(priority: Int) {
        
        if priority <= 25 {
            
            emoji.text = "☁️"
            
        } else if priority > 25 && priority <= 50 {
            
            emoji.text = "🔶"
            
        } else if priority > 50 && priority <= 75 {
            
            emoji.text = "⚠️"
            
        } else if priority > 75 && priority <= 100{
            
            emoji.text = "❗️"
            
        }
        
        
    }
    
    func configure(with task: Task, onCompleteButtonTapped: ((Task) -> Void)?) {

        self.taskName.text = task.name
        
        self.setPriorityImage(priority: task.priority)
    }
    


}
