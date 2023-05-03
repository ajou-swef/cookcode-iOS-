//
//  MembershipViewModel.swift
//  Cookcode
//
//  Created by 노우영 on 2023/04/17.
//

import SwiftUI

class MembershipViewModel: ObservableObject {
    
    let accountService: AccountServiceProtocol
    @Published var membershipForm = MembershipForm()
    @Published var serviceAlert: ServiceAlert = .init()
    
    var nicknameIsEmpty: Bool {
        membershipForm.nicknameIsEmpty
    }
    
    var nicknameCheckComplete: Bool {
        membershipForm.nicknameCheckComplete
    }
    
    var nicknameIsUnique: Bool {
        membershipForm.nicknameIsUnique
    }
    
    var completeButtonIsAvailable: Bool {
        !membershipForm.emailIsEmpty && membershipForm.passwordIsValid &&
        membershipForm.passwordMatch && membershipForm.nicknameIsUnique
        && membershipForm.nicknameCheckComplete
    }
 
    var hidePasswordValidText: Bool {
        membershipForm.passwordIsEmpty || membershipForm.passwordIsValid
    }
    
    var hidePasswordMismatchText: Bool {
        !(hidePasswordValidText && !membershipForm.passwordMatch)
    }
    
    init (accountService: AccountServiceProtocol) {
        self.accountService = accountService
    }
    
    @MainActor
    func checkNickname() async {
        let result = await accountService.check(membershipForm.nickname)
        
        switch result {
        case .success(let data):
            membershipForm.setNicknameIsUnique(data.isUnique)
        case .failure(let serviceError):
            serviceAlert.presentAlert(serviceError)
        }
    }
    
    func setNicknameCheckComplteToFalse() {
        membershipForm.setNicknameCheckComplte(false)
    }
    
    @MainActor
    func signUp(dismiss: DismissAction) async {
        let result = await accountService.signUp(membershipForm: membershipForm)
        
        switch result {
        case .success(_):
            dismiss()
        case .failure(let failure):
            serviceAlert.presentAlert(failure)
        }
    }
}
