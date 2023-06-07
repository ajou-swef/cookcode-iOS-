//
//  HomeReicpeViewModel.swift
//  Cookcode
//
//  Created by 노우영 on 2023/06/07.
//

import SwiftUI

final class HomeReicpeViewModel: RefreshableRecipeFetcher {
    typealias Dto = RecipeCellDto
    typealias T = RecipeCell
    
    @Published var myAccountViewIsPresented: Bool = false
    @Published var presentOnlyCookable: Bool = false
    
    @Published var refreshThreshold: CGFloat = 40
    @Published var dragVelocity: CGFloat = .zero
    @Published var scrollOffset: CGFloat = .zero
    @Published var serviceAlert: ServiceAlert = .init()
    
    @Published var topOffset: CGFloat = .zero
    @Published var contents: [RecipeCell] = .init()
    @Published var pageState: PageState = .wait(0)
    @Published var fetchTriggerOffset: CGFloat = .zero
    
    @Published private(set) var contentTypeButtonIsShowing: Bool = false
    
    internal let spaceName: String = "homeRecipeViewModel"
    internal let recipeService: RecipeServiceProtocol
    internal let pageSize: Int = 10
    
    init(recipeService: RecipeServiceProtocol) {
        self.recipeService = recipeService
        
        Task { await onFetch() }
    }
    
    var topOpacity: CGFloat {
        (20 + topOffset) * 2
    }
    
    
    @MainActor
    func onRefresh() async {
        pageState = .wait(0)
        contents.removeAll()
        await onFetch()
    }
    
    @MainActor
    func onFetch() async {
        let curPage = pageState.page
        pageState = .loading(curPage)
        print("page(\(curPage)) loading start")
        
        let result = await recipeService.fetchRecipeCells(page: curPage, size: pageSize, sort: nil, month: nil, cookcable: presentOnlyCookable)
        
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
    func appendCell(_ success: ServiceResponse<PageResponse<RecipeCellDto>>) {
        let newCells = success.data.content.map { RecipeCell(dto: $0) }
        contents.append(contentsOf: newCells)
    }
    
    
    @MainActor
    func createContentButtonTapped() {
        contentTypeButtonIsShowing.toggle()
    }
    
    @MainActor
    func updateCell(_ info: [CellType: CellUpdateInfo]) {
        guard let info = info[.recipe] else { return }
        
        switch info.updateType {
        case .delete:
            deleteCell(info.cellId)
        case .patch:
            Task { await patchCell(info.cellId) }
        }
    }
    
    @MainActor
    private func deleteCell(_ cellId: Int) {
        guard let index = contents.firstIndex(where: { $0.recipeId == cellId }) else { return }
        contents.remove(at: index)
    }
    
    @MainActor
    private func patchCell(_ cellId: Int) async {
        guard let index = contents.firstIndex(where: { $0.recipeId == cellId }) else { return }

        let page = index / 10
        let result = await recipeService.fetchRecipeCells(page: page, size: pageSize, sort: nil, month: nil, cookcable: presentOnlyCookable)
        
        switch result {
        case .success(let success):
            let firstIndex = success.data.content.firstIndex { $0.recipeID == cellId }
            guard let matchIndex = firstIndex else { return }
            contents[index] = RecipeCell(dto: success.data.content[matchIndex])
        case .failure(let failure):
            serviceAlert.presentAlert(failure)
        }
    }
}