import Foundation
import CoreData
import UIKit

enum ActivitiesType: String, Codable {
    case long
    case short
}

//@objc(Activity)
//public class Activity: NSManagedObject {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
//        return NSFetchRequest<Activity>(entityName: "Activity")
//    }
//
//    @NSManaged public var id: UUID
//    @NSManaged public var type: String
//    @NSManaged public var descriptionText: String
//    @NSManaged public var tag: String
//}
//extension Activity: Identifiable {
//
//}

struct ActivitiesModel: Decodable{
    var id: UUID
    var type: ActivitiesType
    var description: String
    var tag: String
}

protocol SettingsDataProtocol {
    func fetchActivities() -> [Activity]
    func fetchTags(completion: @escaping ([String]) -> Void)
    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void)
    func deleteActivity(at id: UUID, completion: @escaping (Bool) -> Void)
}

class SettingsData: SettingsDataProtocol {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let userDefaultsKeyTags = "tagsData"
    
    func fetchActivities() -> [Activity] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let contexts = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<Activity> = Activity.fetchRequest() 
        
        do {
            let activities = try contexts.fetch(request)
            return activities
            
        } catch {
            print("Failed to fetch activities: \(error)")
            return []
//            completion([])
        }
    }
    
    func fetchTags(completion: @escaping ([String]) -> Void) {
        guard let savedData = UserDefaults.standard.stringArray(forKey: userDefaultsKeyTags) else {return}
        completion(savedData)
    }
    
    func addActivity(_ activityModel: ActivitiesModel, completion: @escaping (Bool) -> Void) {
        let activity = Activity(context: context)
        activity.id = activityModel.id
        activity.type = activityModel.type.rawValue
        activity.descriptionText = activityModel.description
        activity.tag = activityModel.tag
        
        do {
            try context.save()
            completion(true)
        } catch {
            print("Failed to add activity: \(error)")
            completion(false)
        }
    }
    
    func deleteActivity(at id: UUID, completion: @escaping (Bool) -> Void) {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest() as! NSFetchRequest<Activity>
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let activityToDelete = try context.fetch(request).first {
                context.delete(activityToDelete)
                try context.save()
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            print("Failed to delete activity: \(error)")
            completion(false)
        }
    }
}
