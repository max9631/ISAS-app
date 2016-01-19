//
//  SubjectTableView.swift
//  ISAS
//
//  Created by Adam Salih on 14/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import UIKit
import CoreData

class SubjectTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    lazy var fetchController:NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: "Grade")
        let sort = NSSortDescriptor(key: "subject", ascending: true)
        let secsort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort, secsort]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Database.getManagedObjectContext(), sectionNameKeyPath: "subject", cacheName: nil)
        do{
            try controller.performFetch()
        }catch{
            fatalError()
        }
        return controller
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
    }
    
    override func reloadData() {
        do{
            try self.fetchController.performFetch()
        }catch{
            fatalError()
        }
        super.reloadData()
    }
    
    /**
     This method returns a number of section in table view. This is a dataSource method.
     
     - Parameter tableView: This tableView.
     
     - Returns: Number of section in table view.
     */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchController.sections!.count
    }
    
    /**
     This method instanciate a custom headerView, sets its properties and returns it. This is a delegate method.
     
     - Parameter tableView: This table view.
     
     - Parameter viewForHeaderInSection: A number of section for which table view to make the headerView.
     
     - Returns: Custom header view with a subject label and average grade label.
     */
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderView()
        var sum = 0 as Float
        var num = 0
        for grade in self.fetchController.sections![section].objects as! [Grade]{
            if grade.gradeValue != 0{
                sum = sum + (grade.gradeValue as! Float)
                num++
            }
        }
        header.setAverage(sum/Float(num))
        header.setSubject(self.fetchController.sections![section].name)
        header.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        return header
    }
    
    /**
     This method returns a number of rows in given section. This is a dataSource method.
     
     - Parameter numberOfRowsInSection: A number of section.
     
     - Returns: A number of rows in given section.
     */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchController.sections![section].numberOfObjects
    }
    
    /**
     This method constructs an individual cell for given indexPath. This is a dataSource method.
     
     - Parameter tableView: This table view.
     
     - Parameter indexPath: An object with information about a section and row.
     
     - Returns: A cell view.
     */
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let grade = self.fetchController.objectAtIndexPath(indexPath) as! Grade
        let cell = tableView.dequeueReusableCellWithIdentifier("ProtoCell") as! PrototypeCell
        let formatter = NSDateFormatter()
        formatter.dateFormat = "d.M."
        cell.dateLabel.text = "\(formatter.stringFromDate(grade.date!))"
        cell.mainLabel.text = grade.examLabel!
        cell.detailedLabel.text = grade.typeOfExam
        cell.gradeLabel.text = "\(grade.grade!)"
        return cell
    }
    
}
