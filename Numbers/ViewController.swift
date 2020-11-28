//
//  ViewController.swift
//  Numbers
//
//  Created by Леонид Лукашевич on 28.11.2020.
//

import UIKit

class ViewController: UIViewController {
    
    var ten: Int?
    var unit: Int?
    var isTen: Bool? = false
    
//    let unitsRus: Dictionary<Int,String> = [0: "ноль", 1: "один", 2: "два", 3: "три", 4: "четыре",
//                                            5: "пять", 6: "шесть", -7: "семь", 7: "семь", 8: "восемь", 9: "девять"]
//
//    let tensRus: Dictionary<Int,String> = [10: "десять", 11: "одинадцать", 12: "двенадцать", 13: "тринадцать",
//                                        14: "четрынадцать", 15: "пятнадцать", 16: "шестнадцать", 17: "семнадцать",
//                                        18: "восемнадцать", 19: "девятнадцать", 20: "двадцать"]
//
//    let hundredsRus: Dictionary<Int,String> = [100: "сто", 200: "двести", 300: "триста",
//                                            400: "четыреста", 500: "пятьсот", 600: "шестьсот",
//                                            700: "семьсот", 800: "восемьсот", 900: "девятьсот"]
    
    let units: Dictionary<String,Int> = ["null": 0, "ein": 1, "eins": 1, "zwan": 2, "zwei": 2, "drei": 3, "vier": 4, "funf": 5,
                                         "sechs": 6, "sieb": 7, "sieben": 7, "acht": 8, "neun": 9]
    
    let tens: Dictionary<String,Int> = ["zehn": 10, "elf": 11, "zwolf": 12, "dreizehn": 13,
                                        "vierzehn": 14, "funfzehn": 15, "sechzehn": 16, "siebzehn": 17,
                                        "achtzehn": 18, "neunzehn": 19]
    
    let hundreds: Dictionary<String,Int> = ["einhundert": 100, "zweihundert": 200, "dreihundert": 300,
                                            "vierhundert": 400, "funfhundert": 500, "sechshundert": 600,
                                            "siebenhundert": 700, "achthundert": 800 , "neunhundert": 900 ]
    
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
        
        if TF.text!.contains("hundert") {
            for ten in tens {
                if TF.text!.contains(ten.key) {
                    self.ten = ten.value
                    isTen = true                    
                }
            }
            for unit in units {
                if TF.text!.hasSuffix(unit.key) {
                    self.unit = unit.value
                    isTen = nil
                    break
                }
            }
        } else {
            resultLabel.text = "Введено неверное число"
            return
        }
        numberRecognizer()
    }
    
    func numberRecognizer() {
        var generalPrefix: Int = 0
        var generalCenterfix: Int = 0
        var generalSuffix: Int = 0
        
        for hundred in hundreds {
            //let prefix: String = "\(unit.value)hundert"
            if TF.text!.hasPrefix(hundred.key) {
                generalPrefix = hundred.value
            }
        }
        
        if isTen == true {
            generalSuffix = ten!
        } else if isTen == false {
            for unit in units {
                //let centerfix = "\(unit.value)und"
                //let suffix = "\(unit.value)zig"
                if TF.text!.contains("\(unit.key)und") {
                    generalCenterfix = unit.value
                }
                if TF.text!.hasSuffix("\(unit.key)zig") {
                    generalSuffix = unit.value
                }
            }
        } else if isTen == nil {
            generalSuffix = unit!
        }
        
        //resultLabel.text = generalPrefix + generalCenterfix + generalSuffix
        numberReworker(generalPrefix, generalCenterfix, generalSuffix)
    }
    
    func numberReworker(_ prefix: Int, _ centerfix: Int, _ suffix: Int) {
        
        if isTen == true {
            resultLabel.text = "\(prefix/100)\(suffix)"
        } else if isTen == false {
            resultLabel.text = "\(prefix/100)\(suffix)\(centerfix)"
        } else if isTen == nil {
            resultLabel.text = "\(prefix/10)\(suffix)"
        }
        self.ten = nil
        self.unit = nil
        self.isTen = false
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
