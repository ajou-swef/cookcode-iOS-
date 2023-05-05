//
//  RefrigeratorViewModel.swift
//  Cookcode
//
//  Created by 노우영 on 2023/05/04.
//

import Foundation

class RefrigeratorViewModel: SelectIngredientViewModel {
    
    @Published var searchText: String = ""
    @Published var ingredientQuantity: String = ""
    @Published var date: Date = .now
    
    @Published var ingredientFormIsPresented: Bool = false
    @Published var selectIngredientViewIsPresented: Bool = false
    @Published var selectedIngredientId: IngredientCell?
    
    @Published private(set) var ingredientCell: [IngredientCell] = []
    @Published var serviceAlert: ServiceAlert = .init()
    
    private(set) var fridgeService: RefrigeratorServiceProtocol
    
    init (fridgeService: RefrigeratorServiceProtocol) {
        self.fridgeService = fridgeService
        
        Task {
            await fetchIngredients()
        }
    }
    
    @MainActor
    func fetchIngredients() async {
        let result = await fridgeService.getMyIngredientCells()
        switch result {
        case .success(let success):
            ingredientCell = success.data.map { IngredientCell(dto: $0) }
        case .failure(let failure):
            serviceAlert.presentAlert(failure)
        }
    }
    
    func ingredientCellTapped(_ ingredientID: Int) {
        ingredientFormIsPresented = true 
    }
    
    func isNotSelected(_ ingredientID: Int) -> Bool {
        true
    }
    
    
}
