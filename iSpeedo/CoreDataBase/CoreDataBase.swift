//
//  CoreDataHelper.swift
//  iSpeedo
//
//  Created by admin on 12/01/21.
//

import Foundation
import UIKit
import CoreData

class CoreDataBase {
    
    static let `default`: CoreDataBase = CoreDataBase()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iSpeedo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func addNewRide(rideData: [RideData], startDate: Date?, image: UIImage? = nil) {
        do {
            let rideDbObject = RawRideData(context: self.persistentContainer.viewContext)
            for rideDetail in rideData {
                switch rideDetail {
                case .averageSpeed:
                    rideDbObject.averageSpeed = rideDetail.value
                case .rideTime:
                    rideDbObject.rideTime = rideDetail.value
                case .distanceCovered:
                    rideDbObject.distanceTravelled = rideDetail.value
                default:
                    break
                }
            }
            rideDbObject.startDate = startDate
            rideDbObject.rideImage = image?.pngData()
            saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func clearAllRides() {
        guard let rides = fetAllRides() else { return }
        rides.forEach { (ride) in
            self.persistentContainer.viewContext.delete(ride)
        }
    }
    func fetAllRides() -> [RawRideData]? {
        var fetchedRides: [RawRideData]?
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RawRideData")
            let context = self.persistentContainer.viewContext
            guard let rides = try context.fetch(fetchRequest) as? [RawRideData] else { return fetchedRides  }
            fetchedRides = rides
        } catch {
            print(error.localizedDescription)
        }
        return fetchedRides
    }
}
