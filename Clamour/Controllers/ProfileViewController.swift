//
//  ProfileViewController.swift
//  Clamour
//
//  Created by Anne Manzhura on 10.04.2018.
//  Developed by San Nguyen and Anne Manzhura

import UIKit
import ExpandableCell

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: ExpandableTableView!
    
    
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @IBAction func editProfile(_ sender: Any) {
        //chooseSourceOfPhoto()
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
        
    }
    
    var lastImagesCount = 0
    override func viewWillAppear(_ animated: Bool) {
        tableView.animation = .right
        
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            print("App has launched before")
        } else {
            print("This is the first launch ever!")
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.set(0, forKey: "lastFoundImage")
            UserDefaults.standard.set(0, forKey: "lastSearchedImage")
            UserDefaults.standard.synchronize()
        }
    }
    
    var isOpened = false
    override func viewDidAppear(_ animated: Bool) {
        if (!isOpened) {
            tableView.openAll()
            isOpened = true
        }
        tableView.animation = .none
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

//MARK: - TableView
extension ProfileViewController: ExpandableDelegate {
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        if (indexPath.row >= 1) {
            let cell: ExpandedViewCell!
            cell = tableView.dequeueReusableCell(withIdentifier: "ExpCell") as! ExpandedViewCell
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
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
        } else {
            let cell: ExpandableCell!
            cell = expandableTableView.dequeueReusableCell(withIdentifier: "ExbleCell") as! ExpandableCell
            return cell
        }
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
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


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserDefaults.standard.integer(forKey: "lastFoundImage")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryItem", for: indexPath) as! CategoryCollectionViewCell
        
        let code = UserDefaults.standard.integer(forKey: "lastFoundImage")
        cell.imageView.image = UIImage(contentsOfFile: getDocumentsDirectory()
            .appendingPathComponent("f\(code - 1 - indexPath.row).jpeg").path)
        cell.imageView.layer.cornerRadius = cell.imageView.bounds.height/2
        cell.clipsToBounds = true
        cell.imageView.contentMode = .scaleAspectFill
        
        return cell
    }

}
