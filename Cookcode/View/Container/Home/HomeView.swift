//
//  HomeView.swift
//  Cookcode
//
//  Created by 노우영 on 2023/04/19.
//

import SwiftUI
import Introspect

struct HomeView: View {
    
    @EnvironmentObject var navigateViewModel: NavigateViewModel
    @StateObject private var viewModel = HomeViewModel()
    
    let columns: [GridItem] = [
        GridItem(.flexible())
    ]
    
    let recipeCellHeight: CGFloat = 200
    let offsetY: CGFloat = 20
    
    var body: some View {
        VStack {
            header()
            homeRows()
        }
        .overlay(alignment: .bottomTrailing) {
           presentRecipeFormViewButton()
        }
    }
    
    @ViewBuilder
    private func presentRecipeFormViewButton() -> some View {
        Button {
            navigateViewModel.navigateToOuter(.recipe)
        } label: {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .roundedRectangle(.ORANGE_80_FILLE)
                .padding(.bottom, 10)
                .padding(.trailing, 15)
        }
    }
    
    @ViewBuilder
    private func homeRows() -> some View {
        List {
            ForEach(0..<10, id: \.self) {  _ in
               Button {
                   navigateViewModel.navigateWithHome(RecipeCellDto.MOCK_DATA)
               } label: {
                   CellView(cell: RecipeCell.mock())
                       .frame(height: recipeCellHeight)
                       .foregroundColor(.black)
               }
           }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private func header() -> some View {
        HStack(spacing: 15) {
            Text("cookcode logo")
                .font(CustomFontFactory.INTER_BOLD_16)
            
            Spacer()
            
            Button {
                navigateViewModel.navigateWithHome(HomePath.search)
            } label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 20, height: 20)
            }
            
            Button {
                navigateViewModel.navigateToOuter(.profile)
            } label: {
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal, 10)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}