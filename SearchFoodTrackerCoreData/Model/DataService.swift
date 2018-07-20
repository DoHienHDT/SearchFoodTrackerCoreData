//
//  DataService.swift
//  Foodtracker
//
//  Created by dohien on 7/19/18.
//  Copyright © 2018 hiền hihi. All rights reserved.
//

import UIKit
import CoreData
class DataService {
    static let shared: DataService = DataService()
    private var _fetchedResultsController: NSFetchedResultsController<PlistMeal>?
    var fetchedResultsController: NSFetchedResultsController<PlistMeal> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let fetchRequest: NSFetchRequest<PlistMeal> = PlistMeal.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        let sortDescrip = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescrip]
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: "Master")
        do {
            try _fetchedResultsController?.performFetch()
        } catch  {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return _fetchedResultsController!
    }
    func saveData() {
        let context = _fetchedResultsController?.managedObjectContext
        do {
            try context?.save()
            print("Save")
        } catch  {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    func removeData(at indexPath: IndexPath) {
        guard let fetResults = _fetchedResultsController else { return }
        let context = fetResults.managedObjectContext
        context.delete(fetResults.object(at: indexPath))
        do {
            try context.save()
            print("Saved")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

