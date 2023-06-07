//
//  TempRecipeViewModel.swift
//  Cookcode
//
//  Created by 노우영 on 2023/06/02.
//

import Foundation

final class RecipeSearchViewModel: RecipeFetcher, Refreshable {
    typealias Dto = RecipeCellDto
    typealias T = RecipeCell
    
    let refreshThreshold: CGFloat = 40
    let spaceName: String = "recipeSearchViewModel"
    
    @Published var dragVelocity: CGFloat = .zero
    @Published var scrollOffset: CGFloat = .zero
    @Published var contents: [RecipeCell] = .init()
    @Published var filterType: RecipeFilterType = .all
    @Published var serviceAlert: ServiceAlert = .init()
    @Published var pageState: PageState = .wait(0)
    
    internal let recipeService: RecipeServiceProtocol
    @Published var fetchTriggerOffset: CGFloat = .zero
    internal let pageSize: Int = 10
    private let query: String
    
    init(recipeService: RecipeServiceProtocol, query: String) {
        self.recipeService = recipeService
        self.query = query
        
        Task {
            await onFetch()
        }
    }
    
    @MainActor
    func onFetch() async {
        let curPage = pageState.page
        pageState = .loading(curPage)
        print("page(\(curPage)) loading start")
        
        let result = await recipeService.searchRecipeCells(query: query, coockable: false, page: curPage, size: pageSize)
        
        switch result {
        case .success(let success):
            appendCell(success)
            controllPageState(success, curPage)
        case .failure(let failure):
            serviceAlert.presentAlert(failure)
            pageState = .noRemain
        }
    }
    
    @MainActor
    func onRefresh() async {
        pageState = .wait(0)
        contents.removeAll()
        await onFetch()
    }
    
    @MainActor
    func appendCell(_ success: ServiceResponse<PageResponse<RecipeCellDto>>) {
        let newCells = success.data.content.map { RecipeCell(dto: $0) }
        contents.append(contentsOf: newCells)
    }
}