//
//  ProfileView.swift
//  Cookcode
//
//  Created by 노우영 on 2023/05/01.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var navigateViewModel: NavigateViewModel
    
    var body: some View {
        NavigationStack(path: $navigateViewModel.profilePath) {
            VStack {
                Text("프로필")
            }
            .navigationTitle("프로필")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        navigateViewModel.dismissOuter()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }

                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}