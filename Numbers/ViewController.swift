//
//  ViewController.swift
//  Numbers
//
//  Created by Леонид Лукашевич on 28.11.2020.
//

import UIKit

class ViewController: UIViewController {
    
    //    var ten: Int?
    //    var unit: Int?
    //    var isTen: Bool? = false
    //    var generalPrefix: Int = 0
    //    var flag = false
    
    var words: Array<String> = []
    var errorMessage: Bool = true
    var isHundred: Bool = false
    var isTen: Bool = false
    var isUnit: Bool = false
    var isSingle: Bool = false
    
    var pref: String?
    var centf: String?
    var suf: String?
    
    let unitsRus: Dictionary<Int,String> = [1: "аз", 2: "веди", 3: "глаголь", 4: "добро",
                                            5: "есть", 6: "зело", 7: "земля", 8: "иже", 9: "фита"]
    
    let tensRus: Dictionary<Int,String> = [10: "и", 20:"како", 30: "люди", 40: "мыслете",
                                           50: "наш", 60: "кси", 70: "он", 80: "покой", 90: "червь"]
    
    let hundredsRus: Dictionary<Int,String> = [100: "рцы", 200: "слово", 300: "твердь", 400: "ук",
                                               500: "ферт", 600: "ха", 700: "пси", 800: "о", 900: "цы"]
    
    let units: Dictionary<String,Int> = ["null": 0, "ein": 1, "eins": 1, "zwan": 2,
                                         "zwei": 2, "drei": 3, "vier": 4, "funf": 5, "sechs": 6,
                                         "sieb": 7,"sieben": 7, "acht": 8, "neun": 9]
    
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
        
        toCheckString()
        toReadString()
    }
    
    func toCheckString() {
        
        let string = TF.text!
        
        for hundred in hundreds {
            if string.contains(hundred.key) {
                isHundred = true
            }
        }
        for ten in tens {
            if string.contains(ten.key) {
                isTen = true
            }
        }
        if isTen != true {
            for unit in units {
                if string.contains(unit.key) {
                    isUnit = true
                }
            }
        }
    }
    
    func toReadString() {
        
        if isHundred == true && (isTen == true || isUnit == true) {
            
            let string = TF.text!
            var num: Int = 0
            var word: String = ""
            var lastChar: Character?
            
            for char in string {
                if char != " " {
                    word.append(char)
                    if string.count == num {
                        words.append(word)
                        word = ""
                    }
                } else {
                    if lastChar != " " || lastChar == nil {
                        words.append(word)
                        word = ""
                    }
                }
                num += 1
                lastChar = char
            }
            numberRecognizer()
        } else {
            resultLabel.text = "Введено неверное число1"
        }
    }
    
    func numberRecognizer() {
        
        var preparedWord: String?
        var afterUndWord: String?
        var afterZigWord: String?
        
        if isTen == true {
            for word in words {
                for ten in tens {
                    if word == ten.key {
                        suf = word
                        errorMessage = false
                        if isSingle == false {
                            isSingle = true
                        } else {
                            errorMessage = true
                        }
                    }
                }
            }
            if errorMessage == true {
                resultLabel.text = "Введено неверное число2"
                return
            }
        } else if isUnit == true {
            for word in words {
                if word == "und" {
                    if afterUndWord != nil {
                        resultLabel.text = "Введено неверное число3"
                        return
                    }
                    afterUndWord = preparedWord
                }
                if word == "zig" {
                    if afterZigWord != nil {
                        resultLabel.text = "Введено неверное число4"
                        return
                    }
                    afterZigWord = preparedWord
                }
                for unit in units {
                    if word == unit.key {
                        preparedWord = word
                        errorMessage = false
                    }
                }
            }
            if errorMessage == true {
                resultLabel.text = "Введено неверное число5"
                return
            }
            if afterUndWord != nil && afterZigWord != nil {
                centf = afterUndWord
                suf = afterZigWord
            } else if afterUndWord != nil && afterZigWord == nil {
                centf = preparedWord
            } else if afterUndWord == nil && afterZigWord == nil {
                suf = preparedWord
            }
        } else if words.count > 1 {
            resultLabel.text = "Введено неверное число6"
            return
        }
        
        for hundred in hundreds {
            if words[0] == hundred.key {
                pref = words[0]
                errorMessage = false
            }
        }
        if errorMessage == true {
            resultLabel.text = "Введено неверное число7"
            return
        }
        numberReworker()
    }
    
    func numberReworker() {
        
        if centf != nil && suf != nil {
            resultLabel.text = "\(pref ?? "") \(centf ?? "") \(suf ?? "")"
        } else if centf != nil && suf == nil {
            resultLabel.text = "\(pref ?? "") \(centf ?? "")"
        } else if centf == nil && suf != nil {
            resultLabel.text = "\(pref ?? "") \(suf ?? "")"
        } else if centf == nil && suf == nil {
            resultLabel.text = "\(pref ?? "")"
        }
        
        words = []
        errorMessage = true
        isHundred = false
        isTen = false
        isUnit = false
        isSingle = false
        
        pref = nil
        centf = nil
        suf = nil
        
        
        //        let subUnit: Int = suffix % 10
        //
        //        if isTen == true {
        //            resultLabel.text = "\(hundredsRus[prefix]!) \(tensRus[10]!) \(unitsRus[subUnit] ?? "") \n (\(prefix/100)\(suffix/1))"
        //        } else if isTen == false {
        //            resultLabel.text = "\(hundredsRus[prefix] ?? "") \(tensRus[suffix] ?? "") \(unitsRus[centerfix] ?? "") \n (\(prefix/100)\(suffix/10)\(centerfix))"
        //        } else if isTen == nil {
        //            resultLabel.text = "\(hundredsRus[prefix] ?? "") \(unitsRus[suffix] ?? "") \n (\(prefix/10)\(suffix))"
        //        }
        //
        //        generalPrefix = 0
        //        self.ten = nil
        //        self.unit = nil
        //        self.isTen = false
        //        words = []
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
