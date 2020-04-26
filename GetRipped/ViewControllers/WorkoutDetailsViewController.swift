//
//  WorkoutDetailsViewController.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 23/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseStorage
import FirebaseFirestore

class WorkoutDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    @IBOutlet weak var burnedCaloriesLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var workoutImage: UIImageView!
    
    @IBOutlet weak var detalisScreenBackButton: UIButton!
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var signOutButton: UIButton!
    
    var profilePictureImage: String = ""
    var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCircularButtonLayout(button: detalisScreenBackButton, view: view)
        setCircularButtonLayout(button: signOutButton,view: view)
        
        setCircularButtonLayout(button: profileButton,view: view)
        
        
        var indexSearch = 0
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        
        ref.observe(.value, with: { (snapshot) in
            
            
            for workouts in snapshot.children.allObjects as! [DataSnapshot] {
                if indexSearch==indexOfWorkout {
                    if let workoutObject = workouts.value as? [String: AnyObject]{
                        let workoutName = workoutObject["workoutName"]
                        let workoutDate = workoutObject["pickedDate"]
                        let workoutTime = workoutObject["workoutDuration"]
                        let photo = workoutObject["photoLink"]
                        let calories = workoutObject["burnedCalories"]
                        
                        self.workoutNameLabel.text = workoutName as? String
                        self.burnedCaloriesLabel.text = calories as? String
                        self.dateLabel.text = workoutDate as? String
                        self.durationLabel.text = workoutTime as? String
                        
                        if let url = URL(string:  photo as? String ?? ""){
                            do {
                                let data = try Data(contentsOf: url)
                                self.workoutImage.image = UIImage(data: data)
                            } catch let err{
                                print(err.localizedDescription)
                            }
                        }
                        
                    }
                    
                }
                indexSearch = indexSearch + 1
            }
            
        })
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshProfilePictureUrl()
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        
        var ref: DatabaseReference!
        var name = ""
        
        ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let userDict = snapshot.value as! [String: Any]
            
            name = userDict["username"] as! String
            
            self.changeUserNameAlert(string: name)
            
    })
    }
        
        func changeUserNameAlert(string: String){
            userName = string
            let alert = UIAlertController(title: "Do you want to change/update your username or profile picture ?", message: "Your current username: \(string)",  preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = ""
            }
            
            alert.addAction(UIAlertAction(title: "Change username", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                let newName = textField?.text
                if newName != ""{
                    self.setNewUserName(newUserName: newName!)
                    self.presentAlert(title: "Success", message: "Username updated")
                }
                
            }))
            
            let image = loadProfilePicture()
                    print("profile pic url", profilePictureImage)
            alert.addImage(image: image)
            
            alert.addAction(UIAlertAction(title: "Upload new profile picture", style: .default, handler: { (_) in
            
                    self.setNewProfilePicture()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        func setNewUserName(newUserName: String){
            var ref: DatabaseReference!
            
            ref = Database.database().reference()
            ref.child("users").child(Auth.auth().currentUser!.uid).child("user").setValue(["username":newUserName,"profilePicture": profilePictureImage])
        }
    
    func loadProfilePicture() -> UIImage{
        var profileImage: UIImage
        let defaultImage = UIImage(named: "AppIcon")!
        
        print("profile pic url", profilePictureImage)
        
        
        if let url = URL(string: profilePictureImage){
            do {
                let data = try Data(contentsOf: url)
                profileImage = UIImage(data: data)!
                return profileImage
            } catch let err{
                print(err.localizedDescription)
                
                return defaultImage
            }
        }
        return defaultImage
    }
    
    func refreshProfilePictureUrl(){
        var ref: DatabaseReference!
        var url = ""
        
        ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let userDict = snapshot.value as! [String: Any]
            
            url = userDict["profilePicture"] as! String
            
            
            self.profilePictureImage = url
            
             print("profile pic url Firebasee", self.profilePictureImage)
            
            
        })
    }
    func presentAlert(title: String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            uploadImagePic(img1: image)
        }
        else {
            presentAlert(title: "Error", message: "Cannot upload")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func setNewProfilePicture(){
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
        let storageRef = Storage.storage().reference(withPath: Auth.auth().currentUser!.uid).child("user").child("profilePicture")
        
        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                
            }
            
            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                var ref: DatabaseReference!
                
                ref = Database.database().reference()
                ref.child("users").child(Auth.auth().currentUser!.uid).child("user").setValue(["username":self.userName,"profilePicture":url!.absoluteString])
                self.refreshProfilePictureUrl()
                self.presentAlert(title: "Success", message: "Profile picture updated")
                
            })
            
        }
        
    }
        
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure ?", preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { action in
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "uid")
            defaults.synchronize()
            let homeScreenViewController = self.storyboard?.instantiateViewController(withIdentifier: "initController")
            self.view.window?.rootViewController = homeScreenViewController
            self.view.window?.makeKeyAndVisible()
            
        })
        alert.addAction(ok)
        let cancel = UIAlertAction(title: "No", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    
}

extension UIImage{
    func scaled(to maxSize: CGFloat) -> UIImage? {
        let aspectRatio: CGFloat = min(maxSize / size.width, maxSize / size.height)
        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { context in
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
    }
}

extension UIAlertController {
    

    func addImage(image: UIImage){
        
        let resizeParams = CGFloat(signOf: 250, magnitudeOf: 250)
        let resizedImage = image.scaled(to: resizeParams)
        let imageAction = UIAlertAction(title: "", style: .default, handler: nil)
        imageAction.isEnabled = false
        imageAction.setValue(resizedImage!.withRenderingMode(.alwaysOriginal), forKey: "image")
        self.addAction(imageAction)
    }
    
    
    
    
    
}
