// ViewController.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate
{
}

enum TestSection : Int
{
    case CustomEvents = 0
    case Views
    case CrashReporting
    case UserDetails
    case RemoteConfig
    case APM
    case ViewTracking
    case PushNotifications
    case MultiThreading
    case Others
}

class ViewController: UIViewController
{
    let sections : [String] = [
        "Custom Events",
        "Views",
        "Crash Reporting",
        "User Details",
        "Remote Config",
        "APM",
        "View Tracking",
        "Push Notifications",
        "Multi Threading",
        "Others"
    ]
    
    let tests : [[String]] =  [
        ["Record Event",
         "Record Event with Count",
         "Record Event with Sum",
         "Record Event with Duration",
         "Record Event with Segmentation",
         "Record Event with Segmentation & Count",
         "Record Event with Segmentation, Count & Sum",
         "Record Event with Segmentation, Count, Sum & Dur.",
         "Start Event",
         "End Event",
         "End Event with Segmentation, Count & Sum",
         "Basic Internal NPS Event",
         "Basic Internal Survey Event",
         "Basic Internal Stat Rating Event",
         "Basic Internal Orientation Event"],
        
        ["Record View A",
         "Record View B",
         "Record View C",
         "Record View D"],
        
        ["Unrecognized Selector",
         "Out of Bounds",
         "Unwrapping nil Optional",
         "Invalid Geometry",
         "Assert Fail",
         "Terminate",
         "Terminate 2",
         "Custom Crash Log",
         "Record Handled Exception",
         "Record Handled Exception With Stack Trace"],
        
        ["Record User Details",
         "Custom Modifiers 1",
         "Custom Modifiers 2"],
        
        ["Download All RC Values",
         "Download Specific RC Values",
         "Download Omitting Specific RC Values",
         "Get All RC Values",
         "Get Specific RC Values",
         "Clear All RC Values",
         "Register RC Download Callback",
         "Remove RC Download Callback",
         "Get All RC Values And Enroll",
         "Get Specific RC Values And Enroll",
         "Enroll Into AB Tests",
         "Exit AB Tests",
         "Fetch All Test Variants",
         "Fetch Specific Test Variants",
         "Download Experiment Information"],
        
        ["sendSynchronous",
         "sendAsynchronous",
         "connectionWithRequest",
         "initWithRequest",
         "initWithRequest:startImmediately NO",
         "initWithRequest:startImmediately YES",
         "dataTaskWithRequest",
         "dataTaskWithRequest:completionHandler",
         "dataTaskWithURL",
         "dataTaskWithURL:completionHandler",
         "downloadTaskWithRequest",
         "downloadTaskWithRequest:completionHandler",
         "downloadTaskWithURL",
         "downloadTaskWithURL:completionHandler"],
        
        ["Turn off AutoViewTracking",
         "Turn on AutoViewTracking",
         "Present Modal View Controller",
         "Push / Pop with Navigation Controller ",
         "Add Exception with Class Name",
         "Remove Exception with Class Name",
         "Add Exception with Title",
         "Remove Exception with Title",
         "Add Exception with Custom titleView",
         "Remove Exception with Custom titleView",
         "Report View Manually"],
        
        ["Ask for Notification Permission",
         "Ask for Notification Permission with Completion Handler",
         "Record Geo-Location for Push",
         "Record Push Notification Action"],
        
        ["Thread 1",
         "Thread 2",
         "Thread 3",
         "Thread 4",
         "Thread 5",
         "Thread 6",
         "Thread 7",
         "Thread 8"],
        
        ["Ask for Star-Rating",
         "Present Rating Widget",
         "Present NPS",
         "Present Survey",
         "Set New Device ID",
         "Set New Device ID with Server Merge"]
    ]
    
    var queue : [DispatchQueue?] = Array(repeating: nil, count: 15)
    
    @IBOutlet weak var tableView: UITableView!
    
    let startSection = TestSection.CustomEvents.rawValue //start section of testing app can be set here.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.scrollToRow(at: IndexPath(row: 0, section:startSection), at:UITableView.ScrollPosition.top, animated:false)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections[section]
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let headerView: UITableViewHeaderFooterView  = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = UIColor.gray
        headerView.textLabel?.textColor = UIColor.white
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tests[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CountlyTestCell")
        cell.textLabel?.text = tests[indexPath.section][indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize:12)
        return cell
    }
    
    @available(iOS, deprecated:10.0)
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Test: \(sections[indexPath.section]) - \(tests[indexPath.section][indexPath.row])");
        
        switch indexPath.section
        {
        case TestSection.CustomEvents.rawValue: //MARK: Custom Events
            switch (indexPath.row)
            {
            case 0: Countly.sharedInstance().recordEvent("button-click")
                break
                
            case 1: Countly.sharedInstance().recordEvent("button-click", count:5)
                break
                
            case 2: Countly.sharedInstance().recordEvent("button-click", sum:1.99)
                break
                
            case 3: Countly.sharedInstance().recordEvent("button-click", duration:3.14)
                break
                
            case 4: Countly.sharedInstance().recordEvent("button-click", segmentation:["k" : "v"])
                break
                
            case 5: Countly.sharedInstance().recordEvent("button-click", segmentation:["k" : "v"], count:5)
                break
                
            case 6: Countly.sharedInstance().recordEvent("button-click", segmentation:["k" : "v"], count:5, sum:1.99)
                break
                
            case 7: Countly.sharedInstance().recordEvent("button-click", segmentation:["k" : "v"], count:5, sum:1.99, duration:0.314)
                break
                
            case 8: Countly.sharedInstance().startEvent("timed-event")
                break
                
            case 9: Countly.sharedInstance().endEvent("timed-event")
                break
                
            case 10: Countly.sharedInstance().endEvent("timed-event", segmentation:["k" : "v"], count:1, sum:0)
                break
                
            case 11: Countly.sharedInstance().recordEvent(kCountlyReservedEventNPS)
                break
                
            case 12: Countly.sharedInstance().recordEvent(kCountlyReservedEventSurvey)
                break
                
                
            case 13: Countly.sharedInstance().recordEvent("[CLY]_star_rating")
                break
                
            case 14: Countly.sharedInstance().recordEvent("[CLY]_orientation")
                break
                
            default:
                break
            }
            break
            
        case TestSection.Views.rawValue: //MARK: Custom Events
            switch (indexPath.row)
            {
            case 0: Countly.sharedInstance().recordView("View A")
                break
                
            
            case 1: Countly.sharedInstance().recordView("View B")
                break
                
                
            case 2: Countly.sharedInstance().recordView("View C")
                break
                
                
            case 3: Countly.sharedInstance().recordView("View D")
                break
                
            
                
            default:
                break
            }
            break
            
            
            
        case TestSection.CrashReporting.rawValue: //MARK: Crash Reporting
            switch (indexPath.row)
            {
            case 0:
                crashTest0()
                break
                
            case 1:
                crashTest1()
                break
                
            case 2:
                crashTest2()
                break
                
            case 3:
                crashTest3()
                break
                
            case 4:
                crashTest4()
                break
                
            case 5:
                crashTest5()
                break
                
            case 6:
                crashTest6()
                break
                
            case 7:
                Countly.sharedInstance().recordCrashLog("This is a custom crash log.")
                break
                
            case 8:
                let myException : NSException = NSException.init(name:NSExceptionName(rawValue: "MyException"), reason:"MyReason", userInfo:["key":"value"])
                Countly.sharedInstance().recordHandledException(myException)
                
                Countly.sharedInstance().recordHandledException(myException, withStackTrace: Thread.callStackSymbols)
                break
                
            case 9:
                let myException : NSException = NSException.init(name:NSExceptionName(rawValue: "MyException"), reason:"MyReason", userInfo:["key":"value"])
                
                Countly.sharedInstance().recordHandledException(myException, withStackTrace: Thread.callStackSymbols)
                break
                
            default:
                break
            }
            break
            
            
        case TestSection.UserDetails.rawValue: //MARK: User Details
            switch (indexPath.row)
            {
            case 0:
                let documentsDirectory : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
                let localImagePath : String = documentsDirectory.appendingPathComponent("SamplePicture.jpg").absoluteString
                // SamplePicture.png or SamplePicture.gif can be used too.
                
                Countly.user().name = "John Doe" as CountlyUserDetailsNullableString
                Countly.user().email = "john@doe.com" as CountlyUserDetailsNullableString
                Countly.user().birthYear = 1970 as CountlyUserDetailsNullableNumber
                Countly.user().organization = "United Nations" as CountlyUserDetailsNullableString
                Countly.user().gender = "M" as CountlyUserDetailsNullableString
                Countly.user().phone = "+0123456789" as CountlyUserDetailsNullableString
                //Countly.user().pictureURL = "http://s12.postimg.org/qji0724gd/988a10da33b57631caa7ee8e2b5a9036.jpg" as CountlyUserDetailsNullableString
                Countly.user().pictureLocalPath = localImagePath as CountlyUserDetailsNullableString
                Countly.user().custom = ["testkey1":"testvalue1","testkey2":"testvalue2"] as CountlyUserDetailsNullableDictionary
                
                Countly.user().save()
                break
                
            case 1:
                Countly.user().set("key101", value:"value101")
                Countly.user().increment(by:"key102", value:5)
                Countly.user().push("key103", value:"singlevalue")
                Countly.user().push("key104", values:["first","second","third"])
                Countly.user().push("key105", values:["a","b","c","d"])
                Countly.user().save()
                break
                
            case 2:
                Countly.user().multiply("key102", value:2)
                Countly.user().unSet("key103")
                Countly.user().pull("key104", value:"second")
                Countly.user().pull("key105", values:["a","d"])
                Countly.user().save()
                break
                
            default:
                break
            }
            break
//                "Download Experiment Information"
        case TestSection.RemoteConfig.rawValue: //MARK: User Details
            switch (indexPath.row)
            {
                case 0:
                    Countly.sharedInstance().remoteConfig().downloadKeys { response, error, fullValueUpdate , downloadedValues in
                        if(response == .responseSuccess) {
                            print(downloadedValues);
                        }
                        else {
                            print(error?.localizedDescription ?? "");
                        }
                    }
                    break
                    
                case 1:
                    Countly.sharedInstance().remoteConfig().downloadSpecificKeys(["RC_KEY"]) { response, error, fullValueUpdate , downloadedValues in
                        if(response == .responseSuccess) {
                            print(downloadedValues);
                        }
                        else {
                            print(error?.localizedDescription ?? "");
                        }
                    }
                    break
                case 2:
                    Countly.sharedInstance().remoteConfig().downloadOmittingKeys(["RC_KEY"]) { response, error, fullValueUpdate , downloadedValues in
                        if(response == .responseSuccess) {
                            print(downloadedValues);
                        }
                        else {
                            print(error?.localizedDescription ?? "");
                        }
                    }
                    break
                case 3:
                    let rcValues : [String : CountlyRCData] = Countly.sharedInstance().remoteConfig().getAllValues();
                    print(rcValues);
                    break
                case 4:
                    let rcValue = Countly.sharedInstance().remoteConfig().getValue("RC_KEY");
                    print(rcValue)
                    break
                case 5:
                    Countly.sharedInstance().remoteConfig().clearAll()
                    break
                case 6:
                    Countly.sharedInstance().remoteConfig().registerDownloadCallback(rcCallback1);
                    break
                case 7:
                    Countly.sharedInstance().remoteConfig().removeDownloadCallback(rcCallback1);
                    break
                case 8:
                    Countly.sharedInstance().remoteConfig().getAllValuesAndEnroll();
                    break
                case 9:
                    Countly.sharedInstance().remoteConfig().getValueAndEnroll("RC_KEY")
                    break
                case 10:
                    Countly.sharedInstance().remoteConfig().enrollIntoABTests(forKeys: ["RC_KEY"])
                    break
                case 11:
                    Countly.sharedInstance().remoteConfig().exitABTests(forKeys: ["RC_KEY"])
                    break
                case 12:
                    Countly.sharedInstance().remoteConfig().downloadOmittingKeys(["RC_KEY"]) { response, error, fullValueUpdate , downloadedValues in
                        if(response == .responseSuccess) {
                            print(downloadedValues);
                        }
                        else {
                            print(error?.localizedDescription ?? "");
                        }
                    }
                    break
                case 13:
                    let allVairiants = Countly.sharedInstance().remoteConfig().testingGetAllVariants();
                    break
                case 14:
                    let variant = Countly.sharedInstance().remoteConfig().testingGetVariants(forKey: "RC_KEY");
                    break
                case 15:
                    Countly.sharedInstance().remoteConfig().testingDownloadExperimentInformation { response, error in
                        if(response == .responseSuccess) {
                           let allExperiments =  Countly.sharedInstance().remoteConfig().testingGetAllExperimentInfo();
                            print(allExperiments ?? "");
                        }
                        else {
                            print(error?.localizedDescription ?? "");
                        }
                    }
                    break
                    
                default:
                    break
            }
            break
        
            
        case TestSection.APM.rawValue: //MARK: APM
            let urlString : String = "http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json"
            //let urlString : String = "http://www.bbc.co.uk/radio1/playlist.json"
            //let urlString : String = "https://maps.googleapis.com/maps/api/geocode/json?address=Ebisu%20Garden%20Place,Tokyo"
            //let urlString : String = "https://itunes.apple.com/search?term=Michael%20Jackson&entity=musicVideo"
            
            let url : URL = URL.init(string: urlString)!
            let request : URLRequest = URLRequest.init(url: url)
            var response: URLResponse?
            switch (indexPath.row)
            {
            case 0:
                do { try NSURLConnection.sendSynchronousRequest(request, returning: &response) }
                catch { print(error) }
                break
                
            case 1:
                NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler:
                                                            { (response, data, error) in
                    print("sendAsynchronousRequest:queue:completionHandler: finished!")
                })
                break
                
            case 2:
                print("connectionWithRequest is not available on Swift")
                break
                
            case 3:
                let testConnection : NSURLConnection? = NSURLConnection.init(request:request, delegate:self)
                print(testConnection!)
                break
                
            case 4:
                let testConnection : NSURLConnection? = NSURLConnection.init(request:request, delegate:self, startImmediately: false)
                testConnection?.start()
                break
                
            case 5:
                let testConnection : NSURLConnection? = NSURLConnection.init(request:request, delegate:self, startImmediately: true)
                print(testConnection!)
                break
                
            case 6:
                let testTask : URLSessionDataTask = URLSession.shared.dataTask(with: request)
                testTask.resume()
                //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) { testTask.resume() }
                break
                
            case 7:
                let testTask : URLSessionDataTask = URLSession.shared.dataTask(with: request, completionHandler:
                                                                                { (data, response, error) in
                    print("dataTaskWithRequest:completionHandler: finished!")
                })
                testTask.resume()
                break
                
            case 8:
                let testTask : URLSessionDataTask = URLSession.shared.dataTask(with: url)
                testTask.resume()
                break
                
            case 9:
                let testTask : URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler:
                                                                                { (data, response, error) in
                    print("dataTaskWithRequest finished!");
                })
                testTask.resume()
                break
                
            case 10:
                let testTask : URLSessionDownloadTask = URLSession.shared.downloadTask(with: request)
                testTask.resume()
                break
                
            case 11:
                let testTask : URLSessionDownloadTask = URLSession.shared.downloadTask(with: request, completionHandler:
                                                                                        { (data, response, error) in
                    print("downloadTaskWithRequest:completionHandler: finished!")
                })
                testTask.resume()
                break
                
            case 12:
                let testTask : URLSessionDownloadTask = URLSession.shared.downloadTask(with: url)
                testTask.resume()
                break
                
            case 13:
                let testTask : URLSessionDownloadTask = URLSession.shared.downloadTask(with: url, completionHandler:
                                                                                        { (data, response, error) in
                    print("downloadTaskWithRequest finished!");
                })
                testTask.resume()
                break
                
            default:break
            }
            break
            
            
        case TestSection.ViewTracking.rawValue: //MARK: View Tracking
            switch (indexPath.row)
            {
            case 0: Countly.sharedInstance().isAutoViewTrackingActive = false;
                break
                
            case 1: Countly.sharedInstance().isAutoViewTrackingActive = true;
                break
                
            case 2:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let testVC = storyboard.instantiateViewController(withIdentifier: "TestViewControllerModal") as! TestViewControllerModal
                testVC.title = "MyViewControllerTitle"
                self.present(testVC, animated: true, completion: nil)
                break
                
            case 3:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let testVC = storyboard.instantiateViewController(withIdentifier: "TestViewControllerPushPop") as! TestViewControllerPushPop
                let titleView = UILabel(frame: CGRect(x:0,y:0,width:320,height:30))
                titleView.text = "MyViewControllerCustomTitleView"
                titleView.textAlignment = NSTextAlignment.center
                titleView.textColor = UIColor.red
                titleView.font = UIFont.systemFont(ofSize:12)
                testVC.navigationItem.titleView = titleView
                let nc = UINavigationController(rootViewController: testVC)
                nc.title = "TestViewControllerPushPop"
                self.present(nc, animated: true, completion: nil)
                break
                
            case 4: Countly.sharedInstance().addException(forAutoViewTracking:String.init(utf8String: object_getClassName(TestViewControllerModal.self))!)
                break
                
            case 5: Countly.sharedInstance().removeException(forAutoViewTracking:String.init(utf8String: object_getClassName(TestViewControllerModal.self))!)
                break
                
            case 6: Countly.sharedInstance().addException(forAutoViewTracking:"MyViewControllerTitle")
                break
                
            case 7: Countly.sharedInstance().removeException(forAutoViewTracking:"MyViewControllerTitle")
                break
                
            case 8: Countly.sharedInstance().addException(forAutoViewTracking:"MyViewControllerCustomTitleView")
                break
                
            case 9: Countly.sharedInstance().removeException(forAutoViewTracking:"MyViewControllerCustomTitleView")
                break
                
            case 10: Countly.sharedInstance().recordView("ManualViewReportExample")
                break
                
            default: break
            }
            break
            
            
        case TestSection.PushNotifications.rawValue: //MARK: Push Notifications
            switch (indexPath.row)
            {
            case 0: Countly.sharedInstance().askForNotificationPermission()
                break
                
            case 1:
                let authorizationOptions : UNAuthorizationOptions = [.badge, .alert, .sound]
                Countly.sharedInstance().askForNotificationPermission(options: authorizationOptions, completionHandler:
                                                                        { (granted : Bool, error : Error?) in
                    print("granted \(granted)")
                    print("error \(error.debugDescription)")
                })
                break
                
            case 2:
                Countly.sharedInstance().recordLocation(CLLocationCoordinate2D(latitude:33.6789, longitude:43.1234), city: "Tokyo", isoCountryCode: "JP", ip: "255.255.255.255")
                break
                
            case 3:
                let userInfo : Dictionary<String, AnyObject> = Dictionary() // notification dictionary
                let buttonIndex : Int = 1     // clicked button index
                // 1 for first action button
                // 2 for second action button
                // 0 for default action
                
                Countly.sharedInstance().recordAction(forNotification:userInfo, clickedButtonIndex:buttonIndex)
                break
                
                
                
            default: break
            }
            break
            
            
        case TestSection.MultiThreading.rawValue: //MARK: Multi Threading
            let t : Int = indexPath.row
            let tag : String = String(t)
            let commonQueueName : String = "ly.count.multithreading"
            let queueName : String = commonQueueName + tag
            
            if(queue[t] == nil)
            {
                queue[t] = DispatchQueue(label: queueName)
            }
            
            for i in 0..<15
            {
                let eventName : String = "MultiThreadingEvent" + tag
                let segmentation : Dictionary = ["k" : "v" + String(i)]
                queue[t]!.async { Countly.sharedInstance().recordEvent(eventName, segmentation:segmentation) }
            }
            break
            
            
        case TestSection.Others.rawValue: //MARK: Others
            switch (indexPath.row)
            {
            case 0: Countly.sharedInstance().ask(forStarRating:
                                                    { (rating : Int) in
                print("rating \(rating)")
            })
                break
                
            case 1:
                Countly.sharedInstance().presentRatingWidget(withID: "645de9d4b31eb33639e7022a") { error in
                    print("presentRatingWidget \(error.debugDescription)")
                }
                          break
                
            case 2:presentFeedbackWidget(widgetType: CLYFeedbackWidgetType.NPS)
                break
                
            case 3: presentFeedbackWidget(widgetType: CLYFeedbackWidgetType.survey)
                break
                
            case 4: Countly.sharedInstance().setNewDeviceID("user@example.com", onServer:false)
                break
                
            case 5: Countly.sharedInstance().setNewDeviceID(nil, onServer:true)
                break
                
            default: break
            }
            break
            
        default:break
        }
        
        tableView.deselectRow(at:indexPath, animated:true)
    }
    
    //MARK: Crash Tests
    
    func presentFeedbackWidget(widgetType: CLYFeedbackWidgetType) {
        Countly.sharedInstance().getFeedbackWidgets
        { (feedbackWidgets: [CountlyFeedbackWidget]?, error) in
            if (error != nil)
            {
                print("Getting widgets list failed. \n \(error!.localizedDescription) \n \((error! as NSError).userInfo)")
            }
            else
            {
                if(feedbackWidgets != nil) {
                    for feedbackWidget in feedbackWidgets! {
                        if(feedbackWidget.type == widgetType) {
                            feedbackWidget.present(
                                appear:{
                                    print("Appeared.")
                                    
                                },
                                andDismiss: {
                                    print("Dismissed.")
                                })
                            break;
                        }
                    }
                }
            }
        }
    }

    func crashTest0()
    {
        let s : Selector = Selector("thisIsTheUnrecognized"+"SelectorCausingTheCrash");
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: s, userInfo: nil, repeats: true)
    }
    
    func crashTest1()
    {
        let a : Array = ["one","two","three"]
        let s : String = a[5]
        print(s)
    }
    
    func crashTest2()
    {
        let crashingOptional: Int? = nil
        print("\(crashingOptional!)")
    }
    
    func crashTest3()
    {
        let aRect : CGRect = CGRect(x:0.0/0.0, y:0.0, width:100.0, height:100.0)
        let crashView : UIView  = UIView.init(frame: aRect);
        crashView.frame = aRect;
    }
    
    func crashTest4()
    {
        assert(0 == 1, "This is the test assert that failed!")
    }
    
    func crashTest5()
    {
        kill(getpid(), SIGABRT)
    }
    
    func crashTest6()
    {
        kill(getpid(), SIGTERM)
    }
    
    let rcCallback1 : RCDownloadCallback = { response, error, fullValueUpdate , downloadedValues in
        if(response == .responseSuccess) {
            print(downloadedValues);
        }
        else {
            print(error?.localizedDescription ?? "");
        }
    }
    
}

