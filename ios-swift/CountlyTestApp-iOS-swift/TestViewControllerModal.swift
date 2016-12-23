// TestViewControllerModal.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import UIKit

class TestViewControllerModal: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }


    @IBAction func onClick_dismiss(_ sender: Any)
    {
        self.dismiss(animated:true, completion: (() -> Void)?{})
    }
}
