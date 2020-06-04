//
//  LoginViewController.swift
//  EnternProject
//
//  Created by Мухтарпаша on 26.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit
import  Firebase

class LoginViewController: UIViewController {
    //MARK:Properties

    
    
    // наша картинка ДИИТ
    private let logoContainerView:UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "51835808_1926561584119715_8264635087555919872_o").withRenderingMode(.alwaysOriginal))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 420, height: 150))
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        
        return view
    }()
    
    private let emailTextField = UITextField.setupTextField(placeholder: "Email...", IsSecureTextEntry: false)
    
    private let passwordTextField = UITextField.setupTextField(placeholder: "Password...", IsSecureTextEntry: true)
    
    // кнопка логин
    private let loginButton = UIButton.setupButton(title: "Login", color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
    
    private let dontHaveAccountbutton: UIButton = {
        let button = UIButton(type: .system)
        // первая часть кнопки
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account ?   ", attributes: [.font:UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.lightGray])
        //вторая часть кнопки
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [.font:UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(gotoSignUp), for: .touchUpInside)
        return button
        
    }()
    
    
    @objc fileprivate func gotoSignUp () {
        let signUpcontroller = SignUPController()
        let navController = UINavigationController(rootViewController: signUpcontroller)
//        navigationController?.pushViewController(signUpcontroller, animated: true)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
       
    }
    //MARK:VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
               
        configureViewComponents()
        setupNotificationObserver()
        setupTapGesture()
        
        handlers()

    }
    
    
    fileprivate func handlers () {
        emailTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
    }
    
    @objc fileprivate func handleLogin () {
        print("Handle login")
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print("failed to login" , err.localizedDescription)
                return
            }
            
            print("Successfuly signed user in")
            
            let maintabVc = MainTabVC()
            maintabVc.modalPresentationStyle = .fullScreen
            self.present(maintabVc, animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func formValidation () {
        guard
            emailTextField.hasText,
            passwordTextField.hasText else {
                self.loginButton.isEnabled = false
                self.loginButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                return
        }
        
        loginButton.isEnabled = true
        loginButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    
    @objc fileprivate
    
    
    lazy var stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton])
    
    
    
    //MARK:configureViewComponents
    private func configureViewComponents() {
        view.backgroundColor = .white
        // чтоб убрать непонятные вещи в навигейшн бар
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 220))
        
        
        //указываем как наши элементы будут отображаться
        stackView.axis = .vertical
        //расстояние между нашими элементами
        stackView.spacing = 16
        //указываем как наши элементы будут распростроняться. то есть мы выбрали,чтоб одинаково
        stackView.distribution = .fillEqually
        //располагаем н аэкране
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 180))
        
        view.addSubview(dontHaveAccountbutton)
        dontHaveAccountbutton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 40, bottom: 10, right: 40))
    }
    
    
    //MARK:KEYBOARD
    
    fileprivate func setupNotificationObserver () {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func handleKeyboardShow (notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return}
        
        let keyBoardFrame = value.cgRectValue
        
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        
        let difference = keyBoardFrame.height - bottomSpace
        
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 10)
    }
    
    @objc fileprivate func handleKeyboardHide () {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
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
