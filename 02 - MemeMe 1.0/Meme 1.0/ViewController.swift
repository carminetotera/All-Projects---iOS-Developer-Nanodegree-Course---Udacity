//
//  ViewController.swift
//  Meme 1.0
//
//  Created by Carmine Totera on 04/06/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var toolbarBottom: UIToolbar!
    @IBOutlet weak var toolbarUp: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textUp: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIButton!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -1.0
    ]
    
    func setupTextField(textField: UITextField, text: String) {
            textField.defaultTextAttributes = memeTextAttributes
            textField.text = text
            textField.textAlignment = .center
            textField.delegate = self
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupTextField(textField: textUp, text: "TOP")
        setupTextField(textField: textBottom, text: "BOTTOM")
        
        textUp.defaultTextAttributes = memeTextAttributes
        textBottom.defaultTextAttributes = memeTextAttributes
        
        textUp.autocapitalizationType = .allCharacters
        textBottom.autocapitalizationType = .allCharacters
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        if imageView.image == nil {
                   shareButton.isEnabled = false
               } else {
                   shareButton.isEnabled = true
               }
        super.viewWillAppear(animated)
           subscribeToKeyboardNotifications()

    }
    
    func pickAnImageFromSource(sourceType: UIImagePickerController.SourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            present(imagePicker, animated: true, completion: nil)
        }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        
        pickAnImageFromSource(sourceType: .camera)

        
    }
    
    @IBAction func albumButtonAction(_ sender: Any) {
        
        pickAnImageFromSource(sourceType: .photoLibrary)

        
        //dismiss(animated: true, completion: nil)
    }
    
    func save() {
            let memedImage = generateMemedImage()
            // Create the meme
            _ = Meme(topText: textUp.text!, bottomText: textBottom.text!, originalImage: imageView.image!, memedImage: memedImage)
        }
        
        func setVisibilityForBars(isHidden: Bool) {
            toolbarUp.isHidden = isHidden
            toolbarBottom.isHidden = isHidden
        }
        
        func generateMemedImage() -> UIImage {
            // Hide toolbar and navbar
            setVisibilityForBars(isHidden: true)
            
            // Render view to an image
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            // Show toolbar and navbar
           setVisibilityForBars(isHidden: false)
            
            return memedImage
        }

    @IBAction func optionButtonAction(_ sender: Any) {
        let memedImage = generateMemedImage()
                let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
                activityController.completionWithItemsHandler = {
                    activity, success, items, error in
                    
                    if success {
                        self.save()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
                present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        shareButton.isEnabled = false;
        textUp.text = "TOP"
        textBottom.text = "BOTTOM"
        imageView.image = nil
        
    }
    
    
    //TEXTFIELD DELEGATE
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        print("TextField did begin editing method called")

        
        if(textField == self.textUp)
        {
            textUp.text = ""
        }
        else if (textField == self.textBottom)
        {
            textBottom.text = ""
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    
    //IMAGEPICKER DELEGATE
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("dismiss")
        dismiss(animated: true, completion: nil)

        
    }
    
    //KEYBOARD
    
    @objc func keyboardWillChange(_ notification:Notification) {
        
        
        if (textBottom.isFirstResponder) {
                    view.frame.origin.y = 0
                    view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
     
        if (textBottom.isFirstResponder) {
            // Reset View to it's original position
            view.frame.origin.y = 0
        }
        
    }
    
 
    
    
    func getKeyboardHeight(_ notification:Notification) ->CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
        
    }
    
    
    
    func subscribeToKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
           // Removes all notification observers
           NotificationCenter.default.removeObserver(self)
    }
    
        
        
    
  
    
}

