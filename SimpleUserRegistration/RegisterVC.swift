//
//  FirstViewController.swift
//  SimpleUserRegistration
//
//  Created by Peter Zeman on 28.6.17.
//  Copyright © 2017 Procus s.r.o. All rights reserved.
//

import UIKit
import CoreLocation

class RegisterVC: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate,  UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var addPhotoBtn: UIButton!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var nameTxt: UITextField!
    @IBOutlet var surnameTxt: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var birthdayTxt: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let locationManager = CLLocationManager()
    var longitude = 0.0
    var latitude = 0.0
    var image: UIImage!
    var datePckr: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let theWidth = self.view.frame.width
        let theHeight = self.view.frame.height
        registerBtn.addTarget(self, action: #selector(RegisterVC.registerClicked(_:)), for: UIControlEvents.touchUpInside)
        addPhotoBtn.addTarget(self, action: #selector(RegisterVC.showPhotoMenu(_:)), for: UIControlEvents.touchUpInside)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.dismissKeyboard))
        
        nameTxt.delegate = self
        surnameTxt.delegate = self
        
        datePckr = UIDatePicker(frame: CGRect(x: 0, y: 0, width: theWidth, height: theHeight/2))
        datePckr.datePickerMode = .date
        datePckr.maximumDate = Date()
        birthdayTxt.inputView = datePckr
        birthdayTxt.inputAccessoryView = self.createToolBarWithTag(1)
        
        view.addGestureRecognizer(tap)
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        longitude = locValue.longitude
        latitude = locValue.latitude
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func registerClicked (_ sender:UIButton){
        var valid = true
        if let name = nameTxt.text{
            if name.isEmpty{
                valid = false
                let alertController = UIAlertController(title:
                    "Missing name", message:
                    "Insert your name", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        if let surname = surnameTxt.text{
            if surname.isEmpty{
                valid = false
                let alertController = UIAlertController(title:
                    "Missing surname", message:
                    "Insert your surname", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        if valid {
            let userData = UserData(context: context)
            userData.name = nameTxt.text
            userData.surname = surnameTxt.text
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy-HH:mm:SS"
            userData.time = formatter.string(from: date)
            userData.id = UIDevice.current.identifierForVendor!.uuidString
            userData.longitude = longitude as NSNumber
            userData.lattitude = latitude as NSNumber
            
            if let imageToSave = image{
                if let imgData = UIImageJPEGRepresentation(imageToSave, 1){
                    userData.photo = imgData as NSData
                }
            }
            if let birthday = birthdayTxt.text{
                if !birthday.isEmpty{
                    userData.birthday = birthday
                }
            }
            
            birthdayTxt.text = ""
            nameTxt.text = ""
            surnameTxt.text = ""
            image = nil
            imageView.image = UIImage(named: "no-image")
            datePckr.setDate(Date(), animated: false)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            let alertController = UIAlertController(title:
                "Success", message:
                "Successfuly registered", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
       
        
    }
    
    func addImage() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self as UIImagePickerControllerDelegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickerController.allowsEditing = true
        
        self.present(pickerController, animated: true, completion: nil)
        
    }
    
    func addImageFromCamera() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self as UIImagePickerControllerDelegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        pickerController.sourceType = UIImagePickerControllerSourceType.camera
        pickerController.allowsEditing = true
        
        self.present(pickerController, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            self.image = info[UIImagePickerControllerEditedImage] as! UIImage
            self.imageView.image = self.image
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func showPhotoMenu(_ sender: UIButton){
        let alertController = UIAlertController(title: "Photo", message: "Choose photo", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
            self.addImageFromCamera()
        })
        alertController.addAction(camera)
        
        let library = UIAlertAction(title: "Library", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
            self.addImage()
        })
        alertController.addAction(library)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert :UIAlertAction) in
        })
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func createToolBarWithTag(_ tag: Int) -> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneToolBarButton))
        doneButton.tag = tag
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelToolBarButton))
        cancelButton.tag = tag
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        
        return toolBar
    }
    
    func cancelToolBarButton(_ sender: UIBarButtonItem){
        
        birthdayTxt.text = ""
        birthdayTxt.resignFirstResponder()
        datePckr.setDate(Date(), animated: false)
        
    }
    
    func doneToolBarButton(_ sender: UIBarButtonItem){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        birthdayTxt.text = formatter.string(from: datePckr.date)
        birthdayTxt.resignFirstResponder()
        
      
    }

}

