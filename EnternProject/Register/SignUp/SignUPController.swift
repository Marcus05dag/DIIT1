//
//  SignUPController.swift
//  EnternProject
//
//  Created by Мухтарпаша on 27.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit
import Firebase
class SignUPController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //MARK:Properties
    
    var imageSelected = false
    
    fileprivate let selectPhotoButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.rgb(red: 149, green: 204, blue: 244).cgColor
        button.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
       return button
    }()
    
    @objc fileprivate func selectPhoto () {
        let imagePiker = UIImagePickerController()
        imagePiker.delegate = self
        imagePiker.allowsEditing = true
        self.present(imagePiker, animated: true, completion: nil)
        
    }
    
    fileprivate let emailTextField = UITextField.setupTextField(placeholder: "Email...", IsSecureTextEntry: false)
    
    
    fileprivate let fullNameTextField = UITextField.setupTextField(placeholder: "Full name...", IsSecureTextEntry: false)
    
    fileprivate let userNameTextField = UITextField.setupTextField(placeholder: "User name...", IsSecureTextEntry: false)
    
    fileprivate let passwordTextField = UITextField.setupTextField(placeholder: "Password...", IsSecureTextEntry: true)
    
    fileprivate let SignUPButton = UIButton.setupButton(title: "Sign In", color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
    
    fileprivate let alreadyHaveAccountbutton: UIButton = {
           let button = UIButton(type: .system)
           // первая часть кнопки
           let attributedTitle = NSMutableAttributedString(string: "Already have an account    ", attributes: [.font:UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.lightGray])
           //вторая часть кнопки
           attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [.font:UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
           button.setAttributedTitle(attributedTitle, for: .normal)
           button.addTarget(self, action: #selector(gotoSignIN), for: .touchUpInside)
           return button
           
       }()
    
    @objc fileprivate func gotoSignIN () {
        //данный код вернет обратно на тот контроллер, с которого пришли
//        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
        }
    
    //MARK:VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()
        setupNotificationObserver()
        
        setupTapGesture()
        hadleres()
    }
    
    
    //MARK: UIImagePicker
    // метод чтоб загружать наше фото в selectPhoto 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {
            imageSelected = false
            return
        }
        
        imageSelected = true
        //нужно чтоб наша фотка уместилась именно в рамки selectPhotoButton
        selectPhotoButton.layer.cornerRadius = selectPhotoButton.frame.width / 2
        selectPhotoButton.layer.masksToBounds = true
        selectPhotoButton.layer.backgroundColor = UIColor.black.cgColor
        //рамки вокруг фото
        selectPhotoButton.layer.borderWidth = 2
        //цвет рамки SelectPhoto
        selectPhotoButton.layer.borderColor = UIColor.rgb(red: 149, green: 204, blue: 244).cgColor
        //чтоб фото была нормального вида
        selectPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        //убираем пикерконтроллер
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:hadleres
    // прописываем действие для кнопки при которой она станет активной (Sign Up)
    fileprivate func hadleres(){
        emailTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        SignUPButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
                
    }
    
    @objc fileprivate func handleSignUp () {
        self.handleTapDismiss()
        // новые переменные равняются тексту который будет введен в текстовые поля
        //lowercased - это для того,чтоб независимо что вел пользователь то и другое поле загрузилось в поле данных с маленькой буквы
        guard let email = emailTextField.text?.lowercased() else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullNameTextField.text else {return}
        guard let username = userNameTextField.text?.lowercased() else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            print("Пользователь успешно создан")
            
            //загружаем нашу фотку в базу данных
            guard let profileImage = self.selectPhotoButton.imageView?.image else {return}
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else {return}
            
            let filname = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_image").child(filname)
            
            storageRef.putData(uploadData, metadata: nil) { (_, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                print("загрузка прошла успешно")
                storageRef.downloadURL { (downloadUrl, err) in
                    guard let profileImageUrl = downloadUrl?.absoluteString else {return}
                    if let err = err {
                        print("Profile Image is nil", err.localizedDescription)
                        return
                    }
                    print("Успешно получена ссылка на картинку")
                    
                    
                    guard let uid = user?.user.uid else {return}
                    
                    let dictionaryValues = ["name":fullname,"username":username,"profileImageUrl": profileImageUrl]
                    let values = [uid:dictionaryValues]
                    
                    Firestore.firestore().collection("users").document(uid).setData(values) { (err) in
                        if let err = err {
                            print("failed" , err.localizedDescription)
                            return
                        }
                        print("Данные успешно сохранены")
                    }
                }
            }
            
        }
    }
    
    @objc fileprivate func formValidation () {
        guard
            emailTextField.hasText,
            fullNameTextField.hasText,
            userNameTextField.hasText,
            passwordTextField.hasText,
            imageSelected == true else {
                SignUPButton.isEnabled = false
                SignUPButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                return
        }
        SignUPButton.isEnabled = true
        SignUPButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
     lazy var stackView = UIStackView(arrangedSubviews: [emailTextField,fullNameTextField,userNameTextField,passwordTextField,SignUPButton])
    
    
    //MARK:ConficureViewComponents
    fileprivate func configureViewComponents ()  {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(selectPhotoButton)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 250, height: 250))
        selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //размер нашей кнопки
        selectPhotoButton.layer.cornerRadius = 250 / 2
        
        
        
       
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: selectPhotoButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 280))
        
        view.addSubview(alreadyHaveAccountbutton)
        alreadyHaveAccountbutton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 40, bottom: 10, right: 40))
    }

    //MARK:-KEYBOARD
    fileprivate func  setupNotificationObserver() {
        //данный код будет отслеживать размеры клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //примечание: если вызвать обсерверы , то нужно вызвать willdisappear. Если это не сделать, то это негативно повлияет на память
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //клавиатура поднимается вверх
    @objc fileprivate func handleKeyboardShow (notification: Notification) {
        // узнаем размеры рамки клавиатуры
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return}
        //передаем  размер рамки нашей клавиатуры keyboardFrame
        let keyboardFrame = value.cgRectValue
        //размер промежутка который должен сдвинуться наверх
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        //рассчитаем разницу между keyboardFrame и bottomspace
        let difference = keyboardFrame.height - bottomSpace
        //это движение
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 10)
    }
    //клавиатура отпускается вниз
    @objc fileprivate func handleKeyboardHide () {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
    //данный код означает,что как только клавиатура исчезает, наш интерфейс должен вернуться вниз
            self.view.transform = .identity
        }, completion: nil)
        
        
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
        
    }
    
    @objc fileprivate func handleTapDismiss () {
        
        view.endEditing(true)
    }
    

}
