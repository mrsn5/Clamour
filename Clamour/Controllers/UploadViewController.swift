//
//  UploadViewController.swift
//  Clamour
//
//  Created by Anne Manzhura on 09.04.2018.
//  San Nguyen and Anne Manzhura

import Foundation
import UIKit
import SwiftyJSON

class UploadViewController : UIViewController
{
    
    @IBOutlet weak var indicatorActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var myImageView: UIImageView!
    var imagePicker = UIImagePickerController()
    
    var dataResult: Data?
    
    func chooseSourceOfPhoto()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose from Camera Roll", style: .default, handler: { _ in
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
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "No camera on this devise", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    func openGallary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseSourceOfPhoto()
        indicatorActivity.isHidden = true
        indicatorActivity.hidesWhenStopped = true
        indicatorActivity.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (myImageView.image == nil) {
            chooseSourceOfPhoto()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        myImageView.image = nil
    }
}

//MARK: - UIImagePickerControllerDelegate
extension UploadViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.myImageView.image = image
            submit(image: image)
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.myImageView.image = image
            submit(image: image)
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func submit(image: UIImage) {
        indicatorActivity.isHidden = false
        indicatorActivity.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        guard let url = URL(string: "https://server-clamour.appspot.com/clamour-api") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var resizedImage = image
        if (image.size.width >= 700) {
            resizedImage = image.resizeWithWidth(width: 700)!
        }
        let imageData: Data = UIImageJPEGRepresentation(resizedImage, 0.4)!
        let imageStr = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        
        request.httpBody = imageStr.data(using: String.Encoding.utf8)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Something went wrong: \(error)")
                self.dataResult = nil
            }
            
            if let data = data {
                self.dataResult = data
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "resultsShow", sender: self)
            }
        }
        
        dataTask.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let data = dataResult {
            let destVC : ResultsViewController = segue.destination as! ResultsViewController
            let json = try! JSON(data: data)
            
            var type: String = ""
            if let t = json["main-type"].string { type = t }
            
            let stypes = json["suitable-types"].arrayValue.map({$0.stringValue})
            
            var suitCol: [UIColor] = []
            for (_, object) in json["suitable-colors"] {
                suitCol += [UIColor(
                    red: (CGFloat(object["red"].double!)/255),
                    green: (CGFloat(object["green"].double!)/255),
                    blue: (CGFloat(object["blue"].double!)/255),
                    alpha: 1)]
            }
            
            var suitClothes: [String] = []
            for (_, object) in json["suitable-clothes"] {
                suitClothes.append(object.string!)
            }
            
            indicatorActivity.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if (suitClothes.count == 0) {
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                
                let alertC = UIAlertController(title: "No matches found", message: "Please, retake a photo and try again.", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (alert) in
                    self.myImageView.image = nil
                    self.chooseSourceOfPhoto()
                    blurEffectView.removeFromSuperview()
                }
                alertC.addAction(ok)
                blurEffectView.frame = self.view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.view.addSubview(blurEffectView)
                self.present(alertC, animated: true, completion: nil)
            }else {
                destVC.dataResult = Result.init(type: type, suitable: stypes, suitColors: suitCol, suitClothes: suitClothes )
                destVC.miniatureImage = myImageView.image
            }
        }
    }
    
}

extension UIImage {
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

