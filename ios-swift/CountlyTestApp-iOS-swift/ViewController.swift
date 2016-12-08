// ViewController.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate
{
}

class ViewController: UIViewController
{
    let sections : [String] = [
                                "Custom Events",
                                "Crash Reporting",
                                "User Details",
                                "APM",
                                "View Tracking",
                                "Push Notifications",
                                "Multi Threading",
                                "Others"
                              ]

    let tests : [[String]] =  [
                                ["record event",
                                 "record event with count",
                                 "record event with sum",
                                 "record event with duration",
                                 "record event with segm.",
                                 "record event with segm. & count",
                                 "record event with segm. count & sum",
                                 "record event with segm. count, sum & dur.",
                                 "start event",
                                 "end event",
                                 "end event with segm. count & sum"],
                                ["unrecognized selector",
                                 "out of bounds",
                                 "NULL pointer",
                                 "invalid geometry",
                                 "assert fail",
                                 "kill",
                                 "custom crash log",
                                 "record handled exception"],
                                ["record user details",
                                 "custom modifiers 1",
                                 "custom modifiers 2",
                                 "user logged in",
                                 "user logged out"],
                                ["dataTaskWith request",
                                 "dataTaskWith request & completion",
                                 "dataTaskWith URL & completion",
                                 "downloadTaskWith request & completion",
                                 "add exception",
                                 "remove exception"],
                                ["turn off auto",
                                 "turn on auto",
                                 "present modal",
                                 "navigation controller push / pop",
                                 "add exception",
                                 "remove exception",
                                 "manual report"],
                                                            ["ask for notification permission",
                                 "ask for notification permission with completion handler",
                                 "record location"],
                                                            ["thread 1",
                                 "thread 2",
                                 "thread 3",
                                 "thread 4",
                                 "thread 5",
                                 "thread 6",
                                 "thread 7",
                                 "thread 8"],
                                                            ["set custom header field value",
                                 "ask for star-rating",
                                 "set new device id",
                                 "set new device id with server merge"]
                              ]

    var queue : [DispatchQueue?] = Array(repeating: nil, count: 15)

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        cell.selectionStyle = .none
        cell.textLabel?.text = tests[indexPath.section][indexPath.row]
            return cell
    }


    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        NSLog("Test: %@ - %", sections[indexPath.section], tests[indexPath.section][indexPath.row]);

        switch indexPath.section
        {
            case 0: //MARK: Custom Events
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

                case 9: Countly.sharedInstance().endEvent("timed-event", segmentation:["k" : "v"], count:1, sum:0)
                break

                default:
                break
            }
            break


            case 1: //MARK: Crash Reporting
            switch (indexPath.row)
            {
                case 0: CountlyCrashReporter.sharedInstance().crashTest()
                break

                case 1: CountlyCrashReporter.sharedInstance().crashTest2()
                break

                case 2: CountlyCrashReporter.sharedInstance().crashTest3()
                break

                case 3: CountlyCrashReporter.sharedInstance().crashTest4()
                break

                case 4: CountlyCrashReporter.sharedInstance().crashTest5()
                break

                case 5: CountlyCrashReporter.sharedInstance().crashTest6()
                break

                case 6:
                    // Thanks to Swift, it is not possible to call variadic methods without modification:
                    // http://stackoverflow.com/questions/33706250/how-to-call-an-objective-c-variadic-method-from-swift
                    // http://stackoverflow.com/questions/24374110/swift-call-variadics-c-function-defined-in-objective-c
                    //Countly.sharedInstance().crashLog("This is a custom crash log.")
                    //Countly.sharedInstance().crashLog("This is another custom crash log with argument: %i!", 2)
                break

                case 7:
                    let myException : NSException = NSException.init(name:NSExceptionName(rawValue: "MyException"), reason:"MyReason", userInfo:["key":"value"])
                    Countly.sharedInstance().recordHandledException(myException)
                break

                default:
                break
            }
            break


            case 2: //MARK: User Details
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

                    Countly.user().record()
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

                case 3: Countly.sharedInstance().userLogged(in:"OwnUserID")
                break

                case 4: Countly.sharedInstance().userLoggedOut()
                break

                default:
                break
            }
            break


            case 3: //MARK: APM
            let urlString : String = "http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json"
            //let urlString : String = "http://www.bbc.co.uk/radio1/playlist.json"
            //let urlString : String = "https://maps.googleapis.com/maps/api/geocode/json?address=Ebisu%20Garden%20Place,Tokyo"
            //let urlString : String = "https://itunes.apple.com/search?term=Michael%20Jackson&entity=musicVideo"

            let url : URL = URL.init(string: urlString)!
            let request : URLRequest = URLRequest.init(url: url)
            
            switch (indexPath.row)
            {
                case 0:
                    let testTask : URLSessionDataTask = URLSession.shared.dataTask(with: request)
                    testTask.resume()
                    //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) { testTask.resume() }
                break

                case 1:
                    let testTask : URLSessionDataTask = URLSession.shared.dataTask(with: request, completionHandler:
                    { (data, response, error) in
                            NSLog("dataTaskWithRequest finished!");
                    })
                    testTask.resume()
                break

                case 2:
                    let testTask : URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler:
                    { (data, response, error) in
                            NSLog("dataTaskWithRequest finished!");
                    })
                    testTask.resume()
                break
 
                case 3:
                    let testTask : URLSessionDownloadTask = URLSession.shared.downloadTask(with: request, completionHandler:
                    { (url, response, error) in
                        NSLog("downloadTaskWithRequest finished!");
                    })
                    testTask.resume()
                break

                case 4: Countly.sharedInstance().addException(forAPM: "http://finance.yahoo.com")
                break

                case 5: Countly.sharedInstance().removeException(forAPM: "http://finance.yahoo.com")
                break

                default:break
            }
            break


            case 4: //MARK: View Tracking
            switch (indexPath.row)
            {
                case 0: Countly.sharedInstance().isAutoViewTrackingEnabled = false;
                break

                case 1: Countly.sharedInstance().isAutoViewTrackingEnabled = true;
                break

                case 2:
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let testVC = storyboard.instantiateViewController(withIdentifier: "TestViewControllerModal") as! TestViewControllerModal
                    self.present(testVC, animated: true, completion: nil)
                break

                case 3:
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let testVC = storyboard.instantiateViewController(withIdentifier: "TestViewControllerPushPop") as! TestViewControllerPushPop
                    let nc = UINavigationController(rootViewController: testVC)
                    nc.title = "TestViewControllerPushPop"
                    self.present(nc, animated: true, completion: nil)
                break

                case 4: Countly.sharedInstance().addException(forAutoViewTracking:object_getClass(TestViewControllerModal.self))
                break

                case 5: Countly.sharedInstance().removeException(forAutoViewTracking:object_getClass(TestViewControllerModal.self))
                break

                case 6: Countly.sharedInstance().reportView("ManualViewReportExample")
                break

                default: break
            }
            break


            case 5: //MARK: Push Notifications
            switch (indexPath.row)
            {
                case 0: Countly.sharedInstance().askForNotificationPermission()
                break

                case 1:
                    let authorizationOptions : UNAuthorizationOptions = [.badge, .alert, .sound]
                    Countly.sharedInstance().askForNotificationPermission(options: authorizationOptions, completionHandler:
                    { (granted : Bool, error : Error?) in
                        NSLog("granted \(granted)")
                        NSLog("error \(error)")
                    })
                break

                case 2: Countly.sharedInstance().recordLocation(CLLocationCoordinate2D(latitude:33.6789, longitude:43.1234))
                break

                default: break
            }
            break


            case 6: //MARK: Multi Threading
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


            case 7: //MARK: Others
            switch (indexPath.row)
            {
                case 0: Countly.sharedInstance().setCustomHeaderFieldValue("thisismyvalue")
                break

                case 1: Countly.sharedInstance().ask(forStarRating:
                { (rating : Int) in
                    NSLog("rating \(rating)")
                })
                break

                case 2: Countly.sharedInstance().setNewDeviceID("user@example.com", onServer:false)
                break

                case 3: Countly.sharedInstance().setNewDeviceID(CLYIDFV, onServer:true)
                break

                default: break
            }
            break

            default:break
        }
    }
}
