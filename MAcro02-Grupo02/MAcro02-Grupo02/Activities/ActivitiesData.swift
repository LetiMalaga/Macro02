//import Foundation
//
//// Model
//struct ActivitiesModel: Codable {
//    var id = UUID()
//    var tittle: String
//}
//
//// Protocol for Activities Data
//protocol ActivitiesDataProtocol {
//    func fetchActivities(completion: @escaping ([ActivitiesModel]) -> Void)
//    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void)
//    func deleteActivity(at id: UUID, completion: @escaping (Bool) -> Void)
//}
//
//// Data management class using UserDefaults
//class ActivitiesData: ActivitiesDataProtocol {
//    private let userDefaultsKey = "activitiesData"
//    
//    // Fetch stored activities from UserDefaults
//    func fetchActivities(completion: @escaping ([ActivitiesModel]) -> Void) {
//        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
//           let decodedActivities = try? JSONDecoder().decode([ActivitiesModel].self, from: savedData) {
//            completion(decodedActivities)
//        } else {
//            // Return an empty list if nothing is stored yet
//            completion([])
//        }
//    }
//    
//    // Add a new activity and save it in UserDefaults
//    func addActivity(_ activity: ActivitiesModel, completion: @escaping (Bool) -> Void) {
//        fetchActivities { activities in
//            var updatedActivities = activities
//            updatedActivities.append(activity)
//            
//            if let encodedData = try? JSONEncoder().encode(updatedActivities) {
//                UserDefaults.standard.set(encodedData, forKey: self.userDefaultsKey)
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }
//    }
//    
//    // Delete an activity by its UUID and update UserDefaults
//    func deleteActivity(at id: UUID, completion: @escaping (Bool) -> Void) {
//        fetchActivities { activities in
//            if let index = activities.firstIndex(where: { $0.id == id }) {
//                var updatedActivities = activities
//                updatedActivities.remove(at: index)
//                
//                if let encodedData = try? JSONEncoder().encode(updatedActivities) {
//                    UserDefaults.standard.set(encodedData, forKey: self.userDefaultsKey)
//                    completion(true)
//                } else {
//                    completion(false)
//                }
//            } else {
//                completion(false)
//            }
//        }
//    }
//}
