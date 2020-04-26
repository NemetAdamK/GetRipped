//
//  HomeViewController.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 22/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    // Outlets
    
    @IBOutlet weak var tableWorkouts: UITableView!
    
    @IBOutlet weak var homeScreenAddButton: UIButton!
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var signOutButton: UIButton!
    
    // Variables
    
    var profilePictureImage: String = ""
    var userName: String = ""
    
    // A list for filling up tableView with workouts.
    
    var workoutList = [WorkoutModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpHomeScreen()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async{
            self.tableWorkouts.reloadData()
        }
        refreshProfilePictureUrl()
    }
    @IBAction func profileTapped(_ sender: Any) {
        
        var ref: DatabaseReference!
        var name = ""
        
        ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let userDict = snapshot.value as! [String: Any]
            
            name = userDict["username"] as! String
            
            self.changeUserNameAlert(string: name)
            
        })
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutList.count
    }

    // Seague added to selected row, selected row number refreshed, for fetching in next viewcontroller
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexOfWorkout = indexPath.row
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segue", sender: self)
        }
        
    }
    
    // Populating tableview with fetched data
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        let workout: WorkoutModel
        
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        let borderColor: UIColor = .black
        cell.layer.borderColor = borderColor.cgColor
        
        workout = workoutList[indexPath.row]
        
        cell.workoutNameLabel.text = workout.workoutName
        cell.workoutDateLabel.text = workout.pickedDate
        if let url = URL(string: workout.photoLink ?? ""){
            do {
                let data = try Data(contentsOf: url)
                cell.workoutImage.image = UIImage(data: data)
            } catch let err{
                print(err.localizedDescription)
            }
        }
        return cell
    }
    
    // Set up home screen layout and data from back end
    
    func setUpHomeScreen(){
        
        setHomeScreenLayout()
        
        populateTableView()
        
    }
    
    // Add layout for home screen and saving authenticated user again to UserDefaults
    
    func setHomeScreenLayout(){
        
        UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "uid")
        UserDefaults.standard.synchronize()
        
        self.tableWorkouts.rowHeight = 120;
        
        tableWorkouts.layer.masksToBounds = true
        tableWorkouts.layer.borderWidth = 1
        let borderColor: UIColor = .black
        tableWorkouts.layer.borderColor = borderColor.cgColor
        tableWorkouts.bounces = false
        setCircularButtonLayout(button: homeScreenAddButton,view: view)
        setCircularButtonLayout(button: signOutButton,view: view)
        setCircularButtonLayout(button: profileButton,view: view)
    }
    
    
    // Populate table view with data fetched from firebase database
    
    func populateTableView(){
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        
        ref.observe(.value, with: { (snapshot) in
            
            self.workoutList.removeAll()
            for workouts in snapshot.children.allObjects as! [DataSnapshot] {
                
                if workouts.key != "user"{
                    if let workoutObject = workouts.value as? [String: AnyObject]{
                        let workoutName = workoutObject["workoutName"]
                        let workoutDate = workoutObject["pickedDate"]
                        let workoutTime = workoutObject["workoutDuration"]
                        let photo = workoutObject["photoLink"]
                        let calories = workoutObject["burnedCalories"]
                        let createdDate = workoutObject["createdDate"]
                        
                        let workout = WorkoutModel(workoutName: workoutName as! String?,
                                                   workoutDuration: workoutTime as! String?,
                                                   pickedDate: workoutDate as! String?,
                                                   photoLink: photo as! String?,
                                                   burnedCalories: calories as! String?,
                                                   createdDate: createdDate as! String?)
                        self.workoutList.append(workout)
                    }
                }
            }
            DispatchQueue.main.async{
                self.tableWorkouts.reloadData()
            }
        })
    }
    
    // Alert for changing username and profile picture
    
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
        alert.addImage(image: image)
        
        alert.addAction(UIAlertAction(title: "Upload new profile picture", style: .default, handler: { (_) in
            
            self.setNewProfilePicture()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Set new username in database
    
    func setNewUserName(newUserName: String){
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("user").setValue(["username":newUserName,"profilePicture": profilePictureImage])
    }
    
    // Loading profile picture into
    
    func loadProfilePicture() -> UIImage{
        var profileImage: UIImage
        let defaultImage = UIImage(named: "AppIcon")!
        
        if profilePictureImage != "AppIcon"{
            
            
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
        } else {
            
            return defaultImage
        }
    }
    
    // Refresh local reference to image URL
    
    func refreshProfilePictureUrl(){
        var ref: DatabaseReference!
        var url = ""
        
        ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let userDict = snapshot.value as! [String: Any]
            
            if snapshot.exists(){
                
                if userDict["profilePicture"] != nil {
                    url = userDict["profilePicture"] as! String
                    
                    
                    
                    self.profilePictureImage = url
                }
            }
            
            
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
    
    // Setting new image as profile picture
    
    func setNewProfilePicture(){
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        image.allowsEditing = false
        self.present(image,animated: true){
            
        }
    }
    
    // Upload image to Firestore and saving the reference locally
    
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
    
    

}

// Scaling image to fit alert.

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

