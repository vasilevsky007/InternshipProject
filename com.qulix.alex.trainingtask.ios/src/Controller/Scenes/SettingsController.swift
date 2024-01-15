//
//  SettingsController.swift
//  trainingtask
//
//  Created by Alex on 15.01.24.
//

import UIKit

class SettingsController: UIViewController {
    
    var settings: Settings!
    
    @IBOutlet weak var serverUrlField: UITextField!
    @IBOutlet weak var maxEntriesField: UITextField!
    @IBOutlet weak var numberOfDaysField: UITextField!
    
    @IBAction func saveTapped(_ sender: Any) {
        if let textUrl = serverUrlField.text {
            if let serverUrl = URL(string: textUrl) {
                settings.server = serverUrl
            }
        }
        if let textMaxEntries = maxEntriesField.text {
            if let maxEntries = Int(textMaxEntries) {
                settings.maxEntries = maxEntries
            }
        }
        if let textNumberOfDays = numberOfDaysField.text {
            if let numberOfDays = Int(textNumberOfDays) {
                settings.defaultIntervalBetweenStartAndEndInDays = numberOfDays
            }
        }
        
        if let encodedSettings = try? JSONEncoder().encode(settings) {
            
            UserDefaults.standard.set(encodedSettings, forKey: "settings")
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serverUrlField.text = settings.server?.absoluteString
        maxEntriesField.text = settings.maxEntries.description
        numberOfDaysField.text = settings.defaultIntervalBetweenStartAndEndInDays.description
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
