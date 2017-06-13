//
//  CareCardViewController.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-10.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import UIKit
import CareKit
import ResearchKit


class CareKitViewController: UITabBarController {
    //Define a persistent directory url
    fileprivate var myCarePlanStore: OCKCarePlanStore!
    fileprivate var insightsBuilder: InsightsBuilder!
    
    var insights: [OCKInsightItem] {
        return insightsBuilder.insights
    }
    
    weak var carePlanDelegate: CarePlanStoreManagerDelegate?
    

    //Define view controllers
    var careCardViewController: OCKCareCardViewController!
    var symptomViewController : OCKSymptomTrackerViewController!
    var insightsViewController : OCKInsightsViewController!
    var insightsViewController2 : OCKInsightsViewController!
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
       

        myCarePlanStore = setupCarePlanStore()
        
        
        myCarePlanStore.delegate = self
        // Add activity to CarePlanStore
        for activity in CareCardActivities().activities{
            myCarePlanStore.add(activity.createCareCardActivity()){ success, error in
                if !success {
                    //  Error handling
                    print("Error: adding big CellCept activity to CarePlanStore")
                }
            }
        }
        
        insightsBuilder = InsightsBuilder(carePlanStore: myCarePlanStore)
        
        careCardViewController = createCareCardViewController()
        symptomViewController = createSymptonTrackerViewController()
        symptomViewController.delegate = self
        insightsViewController = createInsightsViewControlelr()
        insightsViewController2 = createInsightsViewController2()
        
        
        // Embed the view controller in a navigation controller
        self.viewControllers = [
            UINavigationController(rootViewController: careCardViewController),
            UINavigationController(rootViewController: symptomViewController),
            UINavigationController(rootViewController: insightsViewController),
            UINavigationController(rootViewController: insightsViewController2)
        ]
        // Start to build the initial array of insights
        updateInsights()
        
    }
    
    fileprivate func updateInsights() {
        insightsBuilder.updateInsights { [weak self] completed, newInsights in
            // If new insights have been created, notifiy the delegate.
            guard let storeManager = self, let newInsights = newInsights , completed else { return }
            storeManager.carePlanDelegate?.carePlanStoreManager(storeManager, didUpdateInsights: newInsights)
        }
    }
    
    
    fileprivate func setupCarePlanStore() -> OCKCarePlanStore{
        
        //Determin the file URL for the store
        let searchPath = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true)
        
        let applicationSupportPath = searchPath[0]
        let myDictionaryURL = URL(fileURLWithPath: applicationSupportPath)
        
        
        if !FileManager.default.fileExists(atPath: myDictionaryURL.absoluteString, isDirectory: nil) {
            try! FileManager.default.createDirectory(at: myDictionaryURL, withIntermediateDirectories: true, attributes: nil)
        }
        // Create the store.
        var storeManager = OCKCarePlanStore(persistenceDirectoryURL: myDictionaryURL)
      
        return storeManager
    }
    
    fileprivate func createCareCardViewController() -> OCKCareCardViewController{
        
        // Create CareCard, link Care Card to Care Plan Store
        let careCardViewController = OCKCareCardViewController(carePlanStore: myCarePlanStore)
        careCardViewController.title = NSLocalizedString("Care Card", comment:"")
        careCardViewController.tabBarItem = UITabBarItem(title: careCardViewController.title, image: UIImage(named:"tabBarItem-carecard"), selectedImage: UIImage(named: "tabBarItem-carecard-filled"))
        
        return careCardViewController
    }
    
    fileprivate func createSymptonTrackerViewController() -> OCKSymptomTrackerViewController{
        let symptonViewController = OCKSymptomTrackerViewController(carePlanStore: myCarePlanStore)
        symptonViewController.delegate = self
        symptonViewController.title = NSLocalizedString("Sympton Tracker", comment:"")
        symptonViewController.tabBarItem = UITabBarItem(title: symptonViewController.title, image: UIImage(named:"tabBarItem-symptoms"), selectedImage: UIImage(named: "tabBarItem-symptoms-filled"))
        return symptonViewController
    }
    
    fileprivate func createInsightsViewControlelr() -> OCKInsightsViewController{
        var bloodPresureMessageItem : OCKInsightItem
        var bloodPresureBarChartItem : OCKInsightItem
        
        // Create BloodPresureMessageItem with fixed data
        bloodPresureMessageItem = OCKMessageItem(title: "Blood Presure Changes", text: "Last week your blood presure was good", tintColor: UIColor.blue, messageType: .tip)
        
        // Create BloodPresureBarChartItem with fixed data
        let bloodPresureSeries = OCKBarSeries(title: "BloodPresure", values: [60,70,65,60,70,80,80], valueLabels: ["60","70","65","60","70","80","80"], tintColor: UIColor.purple)
        
        // Create BarChart with fixed data
        let medicationSeries = OCKBarSeries(title: "Medication Taken", values: [100, 50, 100, 50, 50, 0, 0], valueLabels: ["100", "50", "100", "50", "50", "0", "0"], tintColor: UIColor.purple.withAlphaComponent(0.5))
        
        bloodPresureBarChartItem = OCKBarChart(title: "Blood Presure", text: "With medication", tintColor: UIColor.orange, axisTitles: ["M", "T", "W", "T", "F", "S", "S", ], axisSubtitles: ["10/4", "11/4","12/4", "13/4", "14/4", "15/4", "16/4"], dataSeries: [bloodPresureSeries, medicationSeries])
 
        
        let calendar = Calendar.current
        let insightsViewController = OCKInsightsViewController(insightItems: [bloodPresureMessageItem, bloodPresureBarChartItem], headerTitle: "Weekly Blood Presure", headerSubtitle: String(calendar.getWeekNumber()))
        
        insightsViewController.title = NSLocalizedString("Insights Dash Board", comment: "")
        insightsViewController.tabBarItem = UITabBarItem(title: insightsViewController.title, image: UIImage(named:"tabBarItem-insights"), selectedImage: UIImage(named: "tabBarItem-insights-filled"))
        
        return insightsViewController
    }
    
    fileprivate func createInsightsViewController2() -> OCKInsightsViewController {
        // Create an `OCKInsightsViewController` with sample data.
        let headerTitle = NSLocalizedString("Weekly Charts", comment: "")
        let viewController = OCKInsightsViewController(insightItems: insightsBuilder.insights, headerTitle: headerTitle, headerSubtitle: "")
        
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("Insights", comment: "")
        viewController.tabBarItem = UITabBarItem(title: insightsViewController.title, image: UIImage(named:"tabBarItem-insights"), selectedImage: UIImage(named: "tabBarItem-insights-filled"))
        
        return viewController
    }

    
}
extension CareKitViewController: OCKSymptomTrackerViewControllerDelegate{
    // Sympton tracker delegate. Implement delegate to present assessment
    func symptomTrackerViewController(_ viewController: OCKSymptomTrackerViewController, didSelectRowWithAssessmentEvent assessmentEvent: OCKCarePlanEvent) {
        
        // Lookup the assessment the row represents.
        if let activityType = ActivityType(rawValue: assessmentEvent.activity.identifier){
            if let assessments = CareCardActivities().activityWithType(activityType) as? AccessmentProtocol{
                //Show a ORKTaskViewController for the assessment task
                let taskViewController = ORKTaskViewController(task: assessments.task(), taskRun: nil)
                taskViewController.delegate = self
                present(taskViewController, animated: true, completion: nil)
            }
        }
    }
}

extension CareKitViewController: ORKTaskViewControllerDelegate {
    
    /// Called with then user completes a presented `ORKTaskViewController`.
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        // Defer: You use a defer statement to execute a set of statements just before code execution leaves the current block of code. This statement lets you do any necessary cleanup that should be performed regardless of how execution leaves the current block of code—whether it leaves because an error was thrown or because of a statement such as return or break. For example, you can use a defer statement to ensure that file descriptors are closed and manually allocated memory is freed.  A defer statement defers execution until the current scope is exited. This statement consists of the defer keyword and the statements to be executed later. The deferred statements may not contain any code that would transfer control out of the statements, such as a break or a return statement, or by throwing an error. Deferred actions are executed in reverse order of how they are specified—that is, the code in the first defer statement executes after code in the second, and so on.
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        // Check the state of task controller, if not complete return
        guard reason == .completed else { return }
        
        // Determin the specific completed event from all the event in Care Plane Store
        guard let event = symptomViewController.lastSelectedAssessmentEvent,
            let activityType = ActivityType(rawValue: event.activity.identifier),
            let accessment = CareCardActivities().activityWithType(activityType) as? AccessmentProtocol else { return }
        
        // Create result object : OCKCarePlanEventResult
        let carePlanResult = accessment.buildResultForCarePlanEvent(event, taskResult: taskViewController.result)
        
        // Check if accessment can be associate with HealthKit or not
        if let healthSampleBuilder = accessment as? HealthKitProtocol{
//            var quantityType: HKQuantityType { get }
//            var unit: HKUnit { get }
//            func buildSampleWithTaskResult(_ result: ORKTaskResult) -> HKQuantitySample
//            func localizedUnitForSample(_ sample: HKQuantitySample) -> String
            
            //Create a sample to store data in HealthKit
            let sample = healthSampleBuilder.buildSampleWithTaskResult(taskViewController.result)
            let sampleTypes: Set<HKSampleType> = [sample.sampleType]
            
            // Request authorizatin to store the HealthKit sample
            // Create a HealthKit store first
            let healthStore = HKHealthStore()
            healthStore.requestAuthorization(toShare: sampleTypes, read: sampleTypes, completion: { success, _ in
                //Check if authorization was franted
                if !success{
                    // fall back to save sample in OCKCarePlanStore
                    self.completeEvent(event, inStore: self.myCarePlanStore, withResult: carePlanResult)
                    return
                }
                // Save sample into HealthKit
                healthStore.save(sample, withCompletion: { success, _ in
                    if success{
                        // Sample has saved in HealthKit sotre.Now we use it to create an OCKCarePlanEventResult
                        // and save that object in the general CarePlanStore
                        let healthKitAssociatedResult = OCKCarePlanEventResult(
                            quantitySample: sample,
                            quantityStringFormatter: nil,
                            display: healthSampleBuilder.unit,
                            displayUnitStringKey: healthSampleBuilder.localizedUnitForSample(sample),
                            userInfo: nil
                        )
                        self.completeEvent(event, inStore: self.myCarePlanStore, withResult: healthKitAssociatedResult)
                    }
                })
                
            })
            
        } else {
            //if accessment can NOT be associate with HealthKit, store this sample into general CarePlanStore
            completeEvent(event, inStore: self.myCarePlanStore, withResult: carePlanResult)
        }
        
        
        // Save newly built OCKCarePlanEventResult into OCKCarePlanStore(general one)
        myCarePlanStore.update(event, with: carePlanResult, state: .completed, completion: {
            success, event, error in
            if !success {
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    fileprivate func completeEvent(_ event: OCKCarePlanEvent, inStore store: OCKCarePlanStore, withResult result: OCKCarePlanEventResult) {
        store.update(event, with: result, state: .completed) { success, _, error in
            if !success {
                print(error?.localizedDescription as Any)
            }
        }
    }
}

extension CareKitViewController: OCKCarePlanStoreDelegate {
    func carePlanStoreActivityListDidChange(_ store: OCKCarePlanStore) {
        updateInsights()
    }
    
    func carePlanStore(_ store: OCKCarePlanStore, didReceiveUpdateOf event: OCKCarePlanEvent) {
        updateInsights()
    }
}

protocol CarePlanStoreManagerDelegate: class {
    
    func carePlanStoreManager(_ manager: CareKitViewController, didUpdateInsights insights: [OCKInsightItem])
    
}

































