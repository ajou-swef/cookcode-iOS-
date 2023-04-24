//
//  StepFormView.swift
//  Cookcode
//
//  Created by 노우영 on 2023/04/20.
//

import AVKit
import SwiftUI
import PhotosUI

struct StepFormView: View {
    
    @ObservedObject var viewModel: RecipeFormViewModel
//    @State private var tabSelection: Int
    
    init(viewModel: RecipeFormViewModel, stepIndex: Int) {
        self.viewModel = viewModel
//        self.tabSelection = stepIndex
    }
    
    var body: some View {
        TabView(selection: $viewModel.stepSelction) {
            ForEach(viewModel.stepForms.indices, id: \.self) {  i in
                VStack(spacing: 40) {
                    HStack {
                        Text("\(i+1)단계")
                            .font(CustomFontFactory.INTER_SEMIBOLD_20)
                        
                        Spacer()
                        
                        SelectContentTypeButton(i)
                    }
                    .padding(.bottom, -20)
                    
                    PhotosPicker(selection: $viewModel.stepForms[i].photoPickerItems, maxSelectionCount: viewModel.stepForms[i].maxSelection, matching: viewModel.stepForms[i].phpFilter) {
                        if viewModel.stepForms[i].useImage {
                            SelectImageButton(i)
                        } else if viewModel.stepForms[i].useVideo {
                            SelectVideoButton(i)
                        }
                    }
                    .onChange(of: viewModel.stepForms[i].photoPickerItems) { _ in
                       Task {
                           await viewModel.stepForms[i].load()
                       }
                   }
                    
                    TitleSection(i)
                    DescriptionSection(i)
                    
                    Spacer()
                    
                    BottomButton(i)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .tag(i)
            }
        }
        .ignoresSafeArea(.keyboard)
        .tabViewStyle(.page(indexDisplayMode: .never))
//        .onChange(of: photoItem) { newItem in
//            print("onChange")
//            Task {
//                // Retrive selected asset in the form of Data
//                do {
//                    if let video = try? await newItem?.loadTransferable(type: VideoURL.self) {
//                        videoURL = video
//                    }
//                } catch {
//                    print("\(error)")
//                }
//            }
//        }
        
    }
    
    @ViewBuilder
    private func SelectImageButton(_ i: Int) -> some View {
        ForEach(0..<3, id: \.self) { j in
            if j < viewModel.stepForms[i].imageDatas.count, let uiImage = UIImage(data: viewModel.stepForms[i].imageDatas[j]) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .cornerRadius(15)
                
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .foregroundColor(.gray_bcbcbc)
            }
        }
    }
    
    @ViewBuilder
    private func SelectVideoButton(_ i: Int) -> some View {
        ForEach(0..<2, id: \.self) { j in
            if j < viewModel.stepForms[i].videoURLs.count {
                VideoPlayer(player: AVPlayer(url: viewModel.stepForms[i].videoURLs[j].url))
                    .frame(maxWidth: .infinity, maxHeight: 100)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .foregroundColor(.gray_bcbcbc)
                    .overlay {
                        Image(systemName: "video.fill")
                            .resizable()
                            .frame(width: 60, height: 40)
                            .foregroundColor(.white)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func SelectContentTypeButton(_ i: Int) -> some View {
        HStack {
            Button {
                viewModel.stepForms[i].contentType = .image
            } label: {
                Text("이미지")
                    .font(CustomFontFactory.INTER_SEMIBOLD_14)
            }
            .padding(.leading, 10)
            .foregroundColor(viewModel.stepForms[i].useImage ?
                .white : .primary)
            
            Spacer()
            
            Button {
                viewModel.stepForms[i].contentType = .video
            } label: {
                Text("동영상")
                    .font(CustomFontFactory.INTER_SEMIBOLD_14)
                
            }
            .padding(.trailing, 10)
            .foregroundColor(viewModel.stepForms[i].useVideo ?
                .white : .primary)

        }
        .frame(width: 140, height: 25)
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(
            
            HStack {
                Spacer()
                    .hidden(viewModel.stepForms[i].useImage)
                
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.mainColor)
                    .frame(width: 80)
                    .padding(5)
                
                Spacer()
                    .hidden(viewModel.stepForms[i].useVideo)
            }
        )
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray_bcbcbc)
        )
        .padding(.trailing, 10)
        .animation(.spring(), value: viewModel.stepForms[i].contentType)
    }
    @ViewBuilder
    private func BottomButton(_ i: Int) -> some View {
        HStack {
            Button {
                viewModel.trashButtonTapped(i)
            } label: {
                Image(systemName: "trash.square")
                    .resizable()
                    .frame(maxWidth: 50, maxHeight: 50)
                    .foregroundColor(.gray808080)
            }
            .hidden(!viewModel.isRemovableStep)

            
            Button {
                viewModel.addStepButotnTapped()
            } label: {
                Text("스텝 추가")
                    .foregroundColor(.white)
                    .font(CustomFontFactory.INTER_SEMIBOLD_14)
                    .roundedRectangle(.ORANGE_280_FILLED)
            }
        }
    }
    
    @ViewBuilder
    private func DescriptionSection(_ index: Int) -> some View {
        Section {
            VStack {
                TextField("입력해주세요", text: $viewModel.stepForms[index].stepForm.description)
                    .font(CustomFontFactory.INTER_REGULAR_14)
            }
            .padding(.top, -30)
        } header: {
            HStack {
                Text("자세한 설명")
                    .font(CustomFontFactory.INTER_SEMIBOLD_14)
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func TitleSection(_ index: Int) -> some View {
        Section {
            VStack {
                TextField("입력해주세요", text: $viewModel.stepForms[index].stepForm.title)
                
                CCDivider()
            }
            .padding(.top, -30)
            
        } header: {
            HStack {
                Text("간략한 설명")
                    .font(CustomFontFactory.INTER_SEMIBOLD_14)
                
                Spacer()
            }
        }
    }
}

struct StepFormView_Previews: PreviewProvider {
    static var previews: some View {
        StepFormView(viewModel: RecipeFormViewModel(true), stepIndex: 0)
    }
}
