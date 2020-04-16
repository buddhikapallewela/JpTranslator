//
//  TranslatorPresenter.swift
//  JpTranslator
//
//  Created by Buddhika Pallewela on 2020/04/16.
//  Copyright © 2020 Buddhika Pallewela. All rights reserved.
//

import Foundation

/// Constants
private struct Constants {
    static let pageTitle = "Kana Translator"
    static let inputLabelText = "Original Text"
    static let outputLabelText = "Translation"
    static let translateButtonText = "Translate"
    static let inputTextErrorTitle = "Invalid Input"
    static let inputTextEmptyErrorMessage = "\(inputLabelText) is empty"
}

/// ConverterHomePresenter  Protocol
protocol TranslatorPresenterProtocol: class {
    func viewDidLoad()
    func handleTranslateButtonTapped(inputText: String?, outputMethod: TranslationOutputType)
}

/// Translator Presenter
final class TranslatorPresenter: NSObject {
    private weak var userInterface: TranslatorUserInterface?
    private let usecase: KanaTranslatorUseCaseProtocol
    
    init(_ userInterface: TranslatorUserInterface, usecase: KanaTranslatorUseCaseProtocol) {
        self.userInterface = userInterface
        self.usecase = usecase
    }
}

// MARK: TranslatorPresenterProtocol protocol conformance
extension TranslatorPresenter: TranslatorPresenterProtocol {
    func viewDidLoad() {
        self.userInterface?.setupView(viewModel: (pageTitle: Constants.pageTitle, inputLabelText: Constants.inputLabelText, outputLabelText: Constants.outputLabelText, translateButtonText: Constants.translateButtonText))
    }
    
    func handleTranslateButtonTapped(inputText: String?, outputMethod: TranslationOutputType) {
        self.userInterface?.inputTextViewResignFirstResponder()
        guard let inputText = inputText, !inputText.isEmpty else {
            self.userInterface?.showAlert(title: Constants.inputTextErrorTitle, message: Constants.inputTextEmptyErrorMessage)
            self.userInterface?.inputTextViewFocusFirstResponder()
            return
        }
        
        //userInterface?.showHUD()
        self.usecase.translateText(originalText: inputText, outputMethod: outputMethod.rawValue) { [weak self] result in
            guard let self = self else { return }
            //self.userInterface?.hideHUD()
            switch result {
            case .success(let response):
                self.userInterface?.displayOutput(output: response.output)
            case .failure(let error):
                self.userInterface?.showAlert(title: error.errorTitle, message: error.errorMessage)
                //self.userInterface?.focusFirstResponder()
                return
            }
        }
    }
}
