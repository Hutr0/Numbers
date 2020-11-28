//
//  ViewController.swift
//  Numbers
//
//  Created by Леонид Лукашевич on 28.11.2020.
//

import UIKit

class ViewController: UIViewController {
    
    var ten: String?
    
    let units: Dictionary<Int,String> = [0: "null", -1: "ein", 1: "eins", 2: "zwei", 3: "drei", 4: "vier", 5: "funf",
                                         6: "sechs", -7: "sieb", 7: "sieben", 8: "acht", 9: "neun"]
    
    let tens: Dictionary<Int,String> = [10: "zehn", 11: "elf", 12: "zwolf", 13: "dreizehn",
                                        14: "vierzehn", 15: "funfzehn", 16: "sechzehn", 17: "siebzehn",
                                        18: "achtzehn", 19: "neunzehn", 20: "zwanzig"]
    
    let hundreds: Dictionary<Int,String> = [100: "einhundert", 200: "zweihundert", 300: "dreihundert",
                                            400: "vierhunfert", 500: "funfhundert", 600: "sechshundert",
                                            700: "siebenhundert", 800: "achthundrrt", 900: "neunhundert"]
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var TF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = ""
        button.layer.cornerRadius = 16
        TF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @IBAction func actionButton(_ sender: Any) {
        var isTen: Bool = false
        
        if TF.text!.contains("hundert") {
            for ten in tens {
                if TF.text!.contains(ten.value) {
                    self.ten = ten.value
                    isTen = true
                }
            }
        } else {
            resultLabel.text = "Введено неверное число"
            return
        }
        numberRecognizer(isTen: isTen)
    }
    
    func numberRecognizer(isTen: Bool) {
        var generalPrefix: String = ""
        var generalCenterfix: String = ""
        var generalSuffix: String = ""
        
        for unit in units {
            let prefix = "\(unit.value)hundert"
            if TF.text!.hasPrefix(prefix) {
                generalPrefix = prefix
            }
        }
        
        if isTen {
            
        } else {
            for unit in units {
                let centerfix = "\(unit.value)und"
                let suffix = "\(unit.value)zig"
                if TF.text!.contains(centerfix) {
                    generalCenterfix = centerfix
                }
                if TF.text!.hasSuffix(suffix) {
                    generalSuffix = suffix
                }
            }
        }
        
        resultLabel.text = generalPrefix + generalCenterfix + generalSuffix
    }
}

// MARK: - Text field delegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text?.isEmpty == false {
            actionButton(button as Any)
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func textFieldChanged() {
        if TF.text?.isEmpty == false {
            button.isEnabled = true
        } else {
            button.isEnabled = false
        }
    }
}
