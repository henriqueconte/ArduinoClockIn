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
        loginPresenter = LoginPresenter()
    }
    
    private func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleLoginWithApplePress), for: .touchUpInside)
        authorizationButton.frame = CGRect(x: view.frame.size.width * 0.27,
                                           y: view.frame.size.height * 0.5,
                                           width: view.frame.size.width * 0.5,
                                           height: view.frame.size.height * 0.08)
        view.addSubview(authorizationButton)
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
            
            loginPresenter?.saveLoggedUser(userID: userIdentifier)
            
            performSegue(withIdentifier: "goToFirstScreen", sender: nil)
            // TODO: Pegar identifier e mandar para banco de dados/airtable
        }
    }
    
    // Shows sign in window
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}
