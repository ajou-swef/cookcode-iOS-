//
//  PostIngredientViewModel.swift
//  Cookcode
//
//  Created by 노우영 on 2023/05/10.
//

import SwiftUI

class PostIngredientViewModel: PatchIngredientViewModel {
    @Published var ingredientForm: IngredientForm
    @Published var ingredientCell: IngredientCell
    @Published var serviceAlert: ServiceAlert = .init()
    @Published var deleteAlertIsPresented: Bool = false
    
    let useTrashButton: Bool = false
    internal let refridgeratorService: RefrigeratorServiceProtocol
    
    init (ingredientCell: IngredientCell, refridgeratorService: RefrigeratorServiceProtocol) {
        ingredientForm = IngredientForm(ingredId: ingredientCell.ingredId)
        self.ingredientCell = ingredientCell
        self.refridgeratorService = refridgeratorService
    }
    
    func deleteOkButtonTapped(dismissAction: DismissAction) async {
        // do nothing
    }
    
    
    @MainActor
    func mainButtonTapped(dismissAction: DismissAction) async {
        let dto = IngredientFormDTO(form: ingredientForm)
        let result = await refridgeratorService.postIngredient(dto: dto)

        switch result {
        case .success(_):
            print("??")
            dismissAction()
        case .failure(let failure):
            serviceAlert.presentAlert(failure)
        }
    }
    
    
}