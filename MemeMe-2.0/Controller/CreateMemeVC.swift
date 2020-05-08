//
//  ViewController.swift
//  PickerExperiment
//
//  Created by Mohamed Abdelkhalek Salah on 4/28/20.
//  Copyright © 2020 Mohamed Abdelkhalek Salah. All rights reserved.
//

import UIKit

class CreateMemeVC: UIViewController {

    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var buttonTextField: UITextField!
    @IBOutlet var buttomToolBar: UIToolbar!
    @IBOutlet var topToolBar: UIToolbar!
    @IBOutlet var sharBtn: UIBarButtonItem!
    @IBOutlet var cancelBtn: UIBarButtonItem!
    
    var activeTextField: UITextField!
    let memTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black ,
        NSAttributedString.Key.foregroundColor: UIColor.white ,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -5.0
    ]
    
    // default top and buttom text field
    let topDefaultText = "TOP"
    let buttomDefaultText = "BUTTOM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotification()
        configureTextFieldUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotification()
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && (self.view.frame.height - self.activeTextField.frame.origin.y) <= keyboardSize.height {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func setupTextField(textField: UITextField, defaultText: String) {
        textField.defaultTextAttributes = memTextAttributes
        textField.delegate = self
        textField.text = defaultText
        textField.textAlignment = .center
    }
    func configureTextFieldUI() {
        sharBtn.isEnabled = imagePickerView.image != nil
        setupTextField(textField: topTextField, defaultText: topDefaultText)
        setupTextField(textField: buttonTextField, defaultText: buttomDefaultText)
    }
    
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, buttomText: buttonTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    func hideTopAndBottomBars(_ hide: Bool) {
        buttomToolBar.isHidden = hide
        topToolBar.isHidden = hide
        navigationController?.isNavigationBarHidden = hide
    }
    func generateMemedImage() -> UIImage {
        
        hideTopAndBottomBars(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideTopAndBottomBars(false)
        return memedImage
    }
    
    func pickFromSource(source: UIImagePickerController.SourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        pickFromSource(source: .photoLibrary)
    }
    
    @IBAction func pickImageCamera(_ sender: Any) {
        pickFromSource(source: .camera)
    }
    
    @IBAction func sharePressed(_ sender: Any){
        let memedImage = generateMemedImage()
        let activityControll = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityControll, animated: true, completion: nil)
        activityControll.completionWithItemsHandler = {activity, completed, items, error -> Void in
            if completed {
                self.save(memedImage: memedImage)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        topTextField.text = topDefaultText
        buttonTextField.text = buttomDefaultText
        imagePickerView.image = nil
        sharBtn.isEnabled = false
        navigationController?.popViewController(animated: true)
    }
}

extension CreateMemeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
        sharBtn.isEnabled = imagePickerView.image != nil
    }
}

extension CreateMemeVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {

        self.activeTextField = textField
        if textField.text == topDefaultText {
            textField.text = ""
        } else if textField.text == buttomDefaultText {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
