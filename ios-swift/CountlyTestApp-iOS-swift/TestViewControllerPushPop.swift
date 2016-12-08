// TestViewControllerPushPop.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import UIKit

class TestViewControllerPushPop: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }


    @IBAction func onClick_push(_ sender: Any)
    {
        let nc : UINavigationController = self.parent as! UINavigationController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let testVC = storyboard.instantiateViewController(withIdentifier: "TestViewControllerPushPop") as! TestViewControllerPushPop
        testVC.title = "TestViewControllerPushPop \(nc.viewControllers.count)"
        nc.pushViewController(testVC, animated: true)
    }


    @IBAction func onClick_dismiss(_ sender: Any)
    {
        self.dismiss(animated:true, completion: (() -> Void)?{})
    }
}
