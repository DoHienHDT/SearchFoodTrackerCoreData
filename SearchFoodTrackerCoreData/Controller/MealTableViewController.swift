//
//  MealTableViewController.swift
//  Foodtracker
//
//  Created by dohien on 6/9/18.
//  Copyright © 2018 hiền hihi. All rights reserved.
//

import UIKit
import os.log
import CoreData
class MealTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating, UISearchDisplayDelegate{
    
    var fetchedResultsController = DataService.shared.fetchedResultsController
    var meal : [PlistMeal] = []
    var meals = [PlistMeal]()
    let controller = UISearchController(searchResultsController : nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        //        if let savedMeals = loadMeals(){
        //            meals += savedMeals
        //        }else{
        //             loadSampleMeals()
        //        }
        controller.searchResultsUpdater = self
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.sizeToFit()
        self.tableView.tableHeaderView = controller.searchBar
        controller.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = controller.searchBar
        // truyền sang mất nút search
        definesPresentationContext = true
        ////
        fetchedResultsController.delegate = self
        meals = fetchedResultsController.fetchedObjects ?? []
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if controller.isActive {
            return meal.count
        } else {
            let sectionInfor = fetchedResultsController.sections![section]
            return sectionInfor.numberOfObjects
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MealTableViewCell
        let plistMeal: PlistMeal?
        if controller.isActive {
            plistMeal = meal[indexPath.row]
        } else {
            plistMeal = fetchedResultsController.object(at: indexPath)
        }
        configureCell(cell!, withPlistMeal: plistMeal!)
        return cell!
    }
    func configureCell(_ cell: MealTableViewCell, withPlistMeal plistMeal: PlistMeal) {
        cell.nameLabel.text = plistMeal.name
        cell.ratingControl.rating = Int(plistMeal.rating)
        cell.photoImageView.image = plistMeal.photo as? UIImage
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            DataService.shared.removeData(at: indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)! as! MealTableViewCell, withPlistMeal: anObject as! PlistMeal)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)! as! MealTableViewCell, withPlistMeal: anObject as! PlistMeal)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if let detailViewController = segue.destination as? MealViewController{
            if let index = tableView.indexPathForSelectedRow {
                detailViewController.object = fetchedResultsController.object(at: index)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        meal = meals.filter({(mealStudent : PlistMeal) -> Bool in
            return (mealStudent.name?.lowercased().contains(searchController.searchBar.text!.lowercased()))!
        })
        tableView.reloadData()
    }
    
}

