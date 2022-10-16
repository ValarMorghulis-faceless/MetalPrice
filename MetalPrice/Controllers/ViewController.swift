//
//  ViewController.swift
//  MetalPrice
//
//  Created by Giorgi Samkharadze on 16.10.22.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MetalManagerDelegate, UITextFieldDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return metalManager.metal.count
        case 2:
            return metalManager.currency.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return metalManager.elmetal[row]
        case 2:
            return metalManager.currency[row]
        default:
            return "dasda"
        }
    }
    
    var metal = ""
    var elmetal = ""
    var currency = ""
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            metalTetxField.text = metalManager.elmetal[row]
            elmetal = metalTetxField.text!
            metalTetxField.placeholder = metalManager.metal[row]
            metalTetxField.resignFirstResponder()
        case 2:
            currencyTextField.text = metalManager.currency[row]
            currencyTextField.placeholder = metalManager.currency[row]
            currencyTextField.resignFirstResponder()
        default:
            print("not found")
        }
        currency = currencyTextField.placeholder!
        metal = metalTetxField.placeholder!
        if currency.count == 3 && metal.count == 3 {
        metalManager.getPrice(for: metal, for: currency)
        }
    }
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var metalTetxField: UITextField!
    @IBOutlet weak var metalMass: UITextField!
    
    
    var metalManager = MetalManager()
    
    var metalPickerView = UIPickerView()
    var currencyPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalManager.delegate = self
        currencyTextField.inputView = currencyPickerView
        metalTetxField.inputView = metalPickerView
        
        metalPickerView.delegate = self
        metalPickerView.dataSource = self
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        
        metalPickerView.tag = 1
        currencyPickerView.tag = 2
        
        metalMass.delegate = self
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        metalMass.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if metalMass.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ScrollView.setContentOffset(CGPoint(x: 0,y: 250), animated: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        ScrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
    }
    
    var resstring = ""
    func didUpdatePrice(price: String) {
        DispatchQueue.main.async {
            self.resstring = price
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
    self.performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.descriptionValue = "Price of \(metalMass.text!) KG \(elmetal) in \(currency) is:"
            //let resser = String((Double(resstring) ?? 0.0) * (Double(metalMass.text ?? "0.0") ?? 0.0 ) )
            destinationVC.resultValue = String((Double(resstring) ?? 0.0) * (Double(metalMass.text ?? "0.0") ?? 0.0 ) )   + " " + currency
        }
    }
}


