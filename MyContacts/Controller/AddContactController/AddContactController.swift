//
//  AddContactController.swift
//  MyContacts
//
//  Created by Mangi on 8/15/19.
//  Copyright © 2019 BajajAllianz. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class AddContactController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var phoneTXT: UITextField!
    @IBOutlet weak var emailTXT: UITextField!
    @IBOutlet weak var lastNameTXT: UITextField!
    @IBOutlet weak var firstNameTXT: UITextField!
    @IBOutlet weak var addContactBtn: UIButton!
    @IBOutlet weak var countryTXT: UITextField!
    
    @IBOutlet weak var Profile: UIButton!
    //let pickerData = ["11", "12", "13"]
    var clickedTextField = UITextField()
    var PreseDataArray:[Any] = []
    var dict1:Dictionary<String,AnyObject>?
    var dict2:[Any] = []
    var CountryArr:[Any] = []
    var CountryNameStr:String?
    var ImgData:UIImage?
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        fetchCountryList()
        Profile.addTarget(self, action: #selector(imageBtn), for: .touchUpInside)
        addContactBtn.layer.cornerRadius = 10;
        addContactBtn.clipsToBounds = true;
        
        //PickerView Code
        self.imageView.clipsToBounds = true;
        self.imageView.layer.cornerRadius = self.imageView.frame.width/2;
        Profile.clipsToBounds = true
        
        let picker: UIPickerView
        picker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 250))
        picker.delegate = self as UIPickerViewDelegate
        picker.backgroundColor = .white
        picker.tintColor = .black
        picker.showsSelectionIndicator = true
        countryTXT.inputView = picker
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func imageBtn(_ sender: Any) {
        openGallery()
    }
    
    func openGallery() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        if firstNameTXT.text == "" || lastNameTXT.text == "" || emailTXT.text == "" || phoneTXT.text == ""{
            let alert = UIAlertController(title: "Alert", message: "All fields are mandatory", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            //Validate Email and phone number
            let isValidmail = isValidEmail(emailStr: emailTXT.text!)
            if isValidmail{
                if(phoneTXT.text?.count == 10){
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let contact = Person(context: context)
                    
                    let str = "\(firstNameTXT.text!)\(" ")\(lastNameTXT.text!)"
                    
                    contact.name = str
                    contact.email = emailTXT.text
                    contact.phonenumber = phoneTXT.text
                    let data = (imageView.image)!.pngData()
                    contact.profileImage = data
                    //save data
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    navigationController?.popViewController(animated:true)
                }
                else{
                    let alert = UIAlertController(title: "Alert", message: "Invalid Phone number", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                let alert = UIAlertController(title: "Alert", message: "Invalid Email", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    //validations
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    func validateMobile(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    //API Integration...
    func fetchCountryList(){
        self.CountryArr.removeAll()
        let url = URL(string: "https://restcountries.eu/rest/v1/all")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do {
                self.PreseDataArray = [try JSONSerialization.jsonObject(with: data, options: .allowFragments)]
                print(self.PreseDataArray)
                print(String(data: data, encoding: .utf8)!)
                for i in 0..<self.PreseDataArray.count{
                    self.dict2=((self.PreseDataArray[i] as!NSArray) as! [Any])
                    for i in 0..<self.dict2.count{
                        self.dict1=self.dict2[i] as? Dictionary<String, AnyObject>
                        print("here",(self.dict1?["name"] as! String))
                        self.CountryNameStr = (self.dict1?["name"] as! String)
                        self.CountryArr.append(self.CountryNameStr!)
                    }
                }
            } catch {
                print("json error: \(error)")
            }
        }
        task.resume()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clickedTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}

extension AddContactController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.imageView.image = editedImage
                self.imageView.setNeedsDisplay()
                // create NSData from UIImage
                self.ImgData = editedImage
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        dismiss(animated: true, completion: nil)
    }
}

extension AddContactController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CountryArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.countryTXT.text = CountryArr[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CountryArr[row] as? String
    }
}
