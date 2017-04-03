//
//  LogViewController.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 4/3/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadFile() {
        let url = AppDelegate.sharedInstance().logFileURL()
        let content = try? String(contentsOf: url)
        textView.text = content
    }
    
    private func clearFile() {
        let fileManager = FileManager()
        try? fileManager.removeItem(at: AppDelegate.sharedInstance().logFileURL())
        textView.text = ""
    }
    
    @IBAction func reload(_ sender: Any) {
        loadFile()
    }
    
    @IBAction func clear(_ sender: Any) {
        clearFile()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
