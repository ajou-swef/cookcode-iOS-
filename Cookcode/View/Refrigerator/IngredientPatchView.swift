//
//  IngredientPatchView.swift
//  Cookcode
//
//  Created by 노우영 on 2023/05/05.
//

import SwiftUI

struct IngredientPatchView: View {
    
    @StateObject private var viewModel = IngredientPatchViewModel()
    
    var body: some View {
        BasePatchView(viewModel: viewModel) {
            HStack {
                Text("종류")
                    .foregroundColor(.gray808080)
                    .font(CustomFontFactory.INTER_SEMIBOLD_20)
                
                Spacer()
            }
            
            CCDivider()
            
            HStack {
                Text("소비기한")
                    .foregroundColor(.gray808080)
                    .font(CustomFontFactory.INTER_SEMIBOLD_20)
                
                Spacer()
            }
            
            CCDivider()
            
            HStack {
                Text("양")
                    .foregroundColor(.gray808080)
                    .font(CustomFontFactory.INTER_SEMIBOLD_20)
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .navigationTitle("식재료 수정")
    }
}

struct IngredientPatchView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientPatchView()
    }
}
