//
//  TimeTableView.swift
//  ISAS
//
//  Created by Adam Salih on 13/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import UIKit
import CoreData

class TimeTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    lazy var fetchController:NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: "Grade")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Database.getManagedObjectContext(), sectionNameKeyPath: nil, cacheName: nil)
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
        cell.setCell(grade: grade)
        return cell
    }

}
