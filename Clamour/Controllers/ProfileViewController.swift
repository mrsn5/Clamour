//
//  ProfileViewController.swift
//  Clamour
//
//  Created by Anne Manzhura on 10.04.2018.
//

import UIKit
import ExpandableCell

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: ExpandableTableView!
    
    
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.profileImage.layer.cornerRadius = profileImage.bounds.width/2
        //self.profileImage.layer.borderWidth = 1
        //self.profileImage.layer.borderColor = UIColor.lightGray.cgColor
        
        //self.btnEditProfile.layer.cornerRadius = 5
    }
    
    @IBAction func editProfile(_ sender: Any) {
        //chooseSourceOfPhoto()
        
        let url = URL(string: "https://clamour-server.appspot.com/loader")
        
        //let request = URLRequest(url: components.url!)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil {
                /*if let data = data {
                    let parsedData = String.init(data: data, encoding: String.Encoding.utf8)
                    DispatchQueue.main.async {
                       // self.userName.text = parsedData
                    }
                }*/
            }
        }
        task.resume()
    }
    
    
    func chooseSourceOfPhoto()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    //MARK: - Choose image from camera roll
    func openGallary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.expandableDelegate = self
        tableView.animation = .automatic
        tableView.openAll()
    }
}

//MARK: - TableView
extension ProfileViewController: /*UITableViewDelegate, UITableViewDataSource,*/ ExpandableDelegate {
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        if (indexPath.row == 1) {
            let cell: ExpandedViewCell!
            cell = tableView.dequeueReusableCell(withIdentifier: "ExpCell1") as! ExpandedViewCell
            return [cell]
        } else if (indexPath.row == 2) {
            let cell: ExpandedViewCell!
            cell = tableView.dequeueReusableCell(withIdentifier: "ExpCell2") as! ExpandedViewCell
            return [cell]
        }
        return nil;
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        return [100]
    }
    
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) { return 170; }
        return 40;
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell: ProfileCell!
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            cell.profilePhoto.image = UIImage(named: "jl")
            cell.profilePhoto.layer.cornerRadius = cell.profilePhoto.bounds.width/2
            cell.username.text = "Username"
            cell.profileInfo.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            cell.profilePhoto.focusOnFaces = true
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.frame.width)
            return cell
        } else if (indexPath.row == 1) {
            let cell: ExpandableCell!
            cell = expandableTableView.dequeueReusableCell(withIdentifier: "ExbleCell1") as! ExpandableCell
            return cell
        } else {
            let cell: ExpandableCell!
            cell = expandableTableView.dequeueReusableCell(withIdentifier: "ExbleCell2") as! ExpandableCell
            return cell
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRow:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ProfileCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        cell.profilePhoto.image = UIImage(named: "jl")
        cell.profilePhoto.layer.cornerRadius = cell.profilePhoto.bounds.width/2
        cell.username.text = "Username"
        cell.profileInfo.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        cell.profilePhoto.focusOnFaces = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row==0){
            return 130;
        } else { return 80; }
    }*/
    //
}

//MARK: - UIImagePickerControllerDelegate
extension ProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
    
       /*
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.profileImage.image = editedImage
        }
        */
        
        //Dismisss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}