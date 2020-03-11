//
//  LoginView.swift
//  ArduinoClockIn
//
//  Created by Henrique Figueiredo Conte on 05/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation
import UIKit
import AuthenticationServices


class LoginView: UIViewController {
    
    var loginPresenter: LoginProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProviderLoginView()
        setGradient()
        loginPresenter = LoginPresenter()
    }
    
    private func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleLoginWithApplePress), for: .touchUpInside)
        authorizationButton.frame = CGRect(x: view.frame.size.width * 0.26,
                                           y: view.frame.size.height * 0.7,
                                           width: view.frame.size.width * 0.5,
                                           height: view.frame.size.height * 0.08)
        view.addSubview(authorizationButton)
    }
    
    private func setGradient() {
        self.view.backgroundColor = UIColor().colorWithGradient(frame: view.frame, colors: [#colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0))
    }
    
    @objc func handleLoginWithApplePress() {
        requestAuthorization()
    }
}

extension LoginView: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @available(iOS 13.0, *)
    func requestAuthorization() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func performExistingAccountSetupFlows() {
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // Found error on sign in
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AuthorizationController Error: \(error.localizedDescription)")
    }
    
    // Completed sign in with success
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            let userName = appleIDCredential.fullName?.givenName
            
            loginPresenter?.saveLoggedUser(userID: userIdentifier, userName: userName ?? "")
            
            performSegue(withIdentifier: "goToFirstScreen", sender: nil)
        }
    }
    
    // Shows sign in window
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}
