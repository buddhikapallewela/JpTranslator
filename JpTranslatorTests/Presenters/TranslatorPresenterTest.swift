//
//  TranslatorPresenterTest.swift
//  JpTranslatorTests
//
//  Created by Buddhika Pallewela on 2020/04/17.
//  Copyright © 2020 Buddhika Pallewela. All rights reserved.
//

import XCTest

class TranslatorPresenterTest: XCTestCase {
    func testViewDidLoad() {
        let userInterfaceMock = UserInterfaceMock()
        let usecaseMock = UseCaseeMock()
        let presenter = TranslatorPresenter(userInterfaceMock, usecase: usecaseMock)
        presenter.viewDidLoad()
        XCTAssertTrue(userInterfaceMock.setupViewCalled)
        XCTAssertEqual(userInterfaceMock.pageTitleText, "Kana Translator")
        XCTAssertEqual(userInterfaceMock.inputLabelText, "Original Text")
        XCTAssertEqual(userInterfaceMock.outputLabelText, "Translation")
        XCTAssertEqual(userInterfaceMock.translateButtonText, "Translate")
    }

    func testHandleTranslateButtonTappedSuccess() {
        let userInterfaceMock = UserInterfaceMock()
        let usecaseMock = UseCaseeMock()
        let presenter = TranslatorPresenter(userInterfaceMock, usecase: usecaseMock)
        presenter.handleTranslateButtonTapped(inputText: "今日はいい天気です", outputMethod: .hiragana)
        XCTAssertTrue(userInterfaceMock.inputTextViewResignFirstResponderCalled)
        XCTAssertEqual(userInterfaceMock.outputText, "きょうは いい てんきです")
    }

    func testHandleTranslateButtonTappedError_NilInput() {
        let userInterfaceMock = UserInterfaceMock()
        let usecaseMock = UseCaseeMock()
        let presenter = TranslatorPresenter(userInterfaceMock, usecase: usecaseMock)
        presenter.handleTranslateButtonTapped(inputText: nil, outputMethod: .hiragana)
        XCTAssertTrue(userInterfaceMock.inputTextViewResignFirstResponderCalled)
        XCTAssertTrue(userInterfaceMock.showAlertCalled)
        XCTAssertEqual(userInterfaceMock.showAlertTitle, "Invalid Input")
        XCTAssertEqual(userInterfaceMock.showAlertMessage, "Original Text is empty")
    }
    
    func testHandleTranslateButtonTappedError_EmptyInput() {
        let userInterfaceMock = UserInterfaceMock()
        let usecaseMock = UseCaseeMock()
        let presenter = TranslatorPresenter(userInterfaceMock, usecase: usecaseMock)
        presenter.handleTranslateButtonTapped(inputText: "", outputMethod: .hiragana)
        XCTAssertTrue(userInterfaceMock.inputTextViewResignFirstResponderCalled)
        XCTAssertTrue(userInterfaceMock.showAlertCalled)
        XCTAssertEqual(userInterfaceMock.showAlertTitle, "Invalid Input")
        XCTAssertEqual(userInterfaceMock.showAlertMessage, "Original Text is empty")
    }

}

extension TranslatorPresenterTest {
    // UserInterface mock
    private class UserInterfaceMock: TranslatorUserInterface {
        private(set) var setupViewCalled = false
        private(set) var pageTitleText: String?
        private(set) var translateButtonText: String?
        private(set) var inputLabelText: String?
        private(set) var outputLabelText: String?
        private(set) var showAlertCalled = false
        private(set) var showAlertTitle: String?
        private(set) var showAlertMessage: String?
        private(set) var displayOutputCalled = false
        private(set) var outputText: String?
        private(set) var inputTextViewResignFirstResponderCalled = false
        private(set) var inputTextViewFocusFirstResponderCalled = false
        
        func setupView(viewModel: TranslatorPresenterTest.UserInterfaceMock.ViewModel) {
            setupViewCalled = true
            pageTitleText = viewModel.pageTitle
            translateButtonText = viewModel.translateButtonText
            inputLabelText = viewModel.inputLabelText
            outputLabelText = viewModel.outputLabelText
        }
        
        func showAlert(title: String, message: String) {
            showAlertCalled = true
            showAlertTitle = title
            showAlertMessage = message
        }
        
        func displayOutput(output: String) {
            displayOutputCalled =  true
            outputText = output
        }
        
        func inputTextViewResignFirstResponder() {
            inputTextViewResignFirstResponderCalled = true
        }
        
        func inputTextViewFocusFirstResponder() {
            inputTextViewFocusFirstResponderCalled = true
        }
    }
    
    // usecase mock
    private class UseCaseeMock: KanaTranslatorUseCaseProtocol {
        func translateText(originalText: String, outputMethod: String, completion: @escaping (Result<KanaTranslatorUseCase.KanaTranslationSuccessResponse, KanaTranslatorUseCase.KanaTranslationFailureResponse>) -> Void) {
            switch outputMethod {
            case "hiragana":
                completion(.success(KanaTranslatorUseCase.KanaTranslationSuccessResponse(output: "きょうは いい てんきです")))
            case "katakana":
                completion(.success(KanaTranslatorUseCase.KanaTranslationSuccessResponse(output: "キョウハ イイ テンキデス")))
            default:
                completion(.failure(KanaTranslatorUseCase.KanaTranslationFailureResponse(errorTitle: "Error Title", errorMessage: "Error Message", statusCode: 400)))
            }
        }
    }
}


