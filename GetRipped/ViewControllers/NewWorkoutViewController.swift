//
//  NewWorkoutViewController.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 23/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage
import FirebaseFirestore


class NewWorkoutViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var workoutNameTextField: UITextField!
    
    @IBOutlet weak var burnedCaloriesTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var workoutDurationTextField: UITextField!
    
    @IBOutlet weak var backButtonOnNewWorkout: UIButton!
    
    @IBOutlet weak var addWorkoutButton: UIButton!
    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    @IBOutlet weak var uploadImageButton: UIButton!
    
    var imageURL: String = ""
    var pickedDate: String = ""
    var workOutName: String = ""
    var burnedCalories: String = ""
    var workoutDuration: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCurrentDate()
        setCircularButtonLayout(button: backButtonOnNewWorkout, view: view)
        setButtonLayout(button: addWorkoutButton)
        setButtonLayout(button: uploadImageButton)
        setTextFieldLayout(textField: workoutNameTextField)
        setTextFieldLayout(textField: burnedCaloriesTextField)
        setTextFieldLayout(textField: workoutDurationTextField)
        
    }
    
    func setupCurrentDate(){
        let dateNow = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY hh:mm"
        pickedDate = dateFormatter.string(from: dateNow)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            uploadImageView.image = image
            uploadImagePic(img1: image)
        }
        else {
            presentAlert(title: "Error", message: "Cannot upload")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImage(_ sender: Any) {
        
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary

        
        image.allowsEditing = false
        self.present(image,animated: true){

        }
        
    }
    
    
    
    func uploadImagePic(img1 :UIImage) {
        guard let imageData: Data = img1.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference(withPath: personalID)
        
        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                
            }
            
            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                self.imageURL = url!.absoluteString
                
            })
            
        }
        
    }
    
    @IBAction func datePickerData(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY hh:mm"
        pickedDate = dateFormatter.string(from: sender.date)
    }
    
    func presentAlert(title: String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToHomeScreen(){
        
        let homeScreenViewController = storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC")
        view.window?.rootViewController = homeScreenViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func addWorkoutPressed(_ sender: Any) {
        burnedCalories = (burnedCaloriesTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        workoutDuration = (workoutDurationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        if  burnedCalories == "" ||
             workoutDuration == ""{
            presentAlert(title: "Waring", message: "Please fill out calorie count and workout duration")
            
        } else {
            
            
            workOutName = (workoutNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
            if workOutName == ""{
                workOutName = pickedDate
                }
                
                
            }
            var ref: DatabaseReference!
            
            ref = Database.database().reference()
            ref.child("users").child(personalID).childByAutoId().setValue(["workoutName": workOutName,"burnedCalories": burnedCalories,"pickedDate": pickedDate,"workoutDuration": workoutDuration, "photoLink" : imageURL])
            
            presentAlert(title: "Success", message: "Workout added")
            
            self.navigateToHomeScreen()
            
        }


}
