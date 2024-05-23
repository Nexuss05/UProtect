//
//  Controller.swift
//  UProtect
//
//  Created by Simone Sarnataro on 22/05/24.
//

import Firebase
import FirebaseAuthUI
import FirebasePhoneAuthUI

class AuthViewController: UIViewController, FUIAuthDelegate {
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if Auth.auth().currentUser == nil {
      let authUI = FUIAuth.defaultAuthUI()!
      authUI.delegate = self
      authUI.providers = [FUIPhoneAuth(authUI: authUI)]

      let authViewController = authUI.authViewController()
      self.present(authViewController, animated: true, completion: nil)
    }
  }

  func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
    if let error = error {
//      print("Errore durante l'autenticazione: \(error.localizedDescription)")
      return
    }
    // L'utente ha effettuato correttamente l'accesso
  }
}
