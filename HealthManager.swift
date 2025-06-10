import Foundation
import HealthKit

class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()

    func requestAuthorization() {
        let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        healthStore.requestAuthorization(toShare: [], read: [stepsType]) { success, error in
            if !success {
                print("Autoryzacja nieudana: \(String(describing: error))")
            }
        }
    }

    func fetchSteps(completion: @escaping (Double) -> Void) {
        let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let query = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let steps = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            DispatchQueue.main.async {
                completion(steps)
            }
        }
        healthStore.execute(query)
    }
}