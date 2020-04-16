//
//  TranslatorViewController.swift
//  JpTranslator
//
//  Created by Buddhika Pallewela on 2020/04/16.
//  Copyright © 2020 Buddhika Pallewela. All rights reserved.
//

import UIKit

protocol TranslatorUserInterface: class {
    typealias ViewModel = (pageTitle:String, inputLabelText: String, outputLabelText: String, translateButtonText: String)
    func setupView(viewModel: ViewModel)
    func displayOutput(output: String)
    func showAlert(title: String, message: String)
    func inputTextViewResignFirstResponder()
}

/// Translator home view controller
class TranslatorViewController: UIViewController {
    // Outlets
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var outputTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var inputTextViewHeightConstraint: NSLayoutConstraint!
    
    // variables
    private var presenter: TranslatorPresenterProtocol?
    private var selectedOutputMode: TranslationOutputType {
        get {
            outputTypeSegmentedControl.selectedSegmentIndex == 0 ? .hiragana : .katakana
        }
        set {
            outputTypeSegmentedControl.selectedSegmentIndex = newValue == .hiragana ? 0 : 1
            outputTypeSegmentedControl.tintColor = UIColor.purple
        }
    }
    
    @IBAction func translateButtonTapped(_ sender: Any) {
        presenter?.handleTranslateButtonTapped(inputText: inputTextView.text, outputMethod: selectedOutputMode)
    }
}

// MARK: UIViewController protocol conformance
extension TranslatorViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TranslatorPresenter(self, usecase: KanaTranslatorUseCase(apiClient: KanaTranslatorAPIClient()))
        presenter?.viewDidLoad()
    }
}

// MARK: TranslatorUserInterface protocol conformance
extension TranslatorViewController: TranslatorUserInterface {
    /// 画面表示設定
    func setupView(viewModel: TranslatorViewController.ViewModel) {
        // UIコントロール設定
        setupUIControls()
        
        // UIの表示テキスト設定
        navigationBar.topItem?.title = viewModel.pageTitle
        inputLabel.text = viewModel.inputLabelText
        outputLabel.text = viewModel.outputLabelText
        translateButton.setTitle(viewModel.translateButtonText, for: .normal)
        outputTypeSegmentedControl.setTitle(TranslationOutputType.hiragana.rawValue, forSegmentAt: 0)
        outputTypeSegmentedControl.setTitle(TranslationOutputType.katakana.rawValue, forSegmentAt: 1)
    }
    
    /// 変換結果を表示
    func displayOutput(output: String) {
        self.outputTextView.text = output
    }
    
    /// アラート表示
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    /// キーボードを閉じる
    func inputTextViewResignFirstResponder() {
        self.inputTextView.resignFirstResponder()
    }
    
    /// 画面のUIコントロール設定
    private func setupUIControls() {
        // set Input text views height to 1/3 of the screen height(to make equal propostion for every size class)
        inputTextViewHeightConstraint.constant = UIScreen.main.bounds.height / 3
        
        inputLabel.textColor = ViewColor.basicText
        outputLabel.textColor = ViewColor.basicText
        
        outputTextView.tintColor = ViewColor.basicText
        inputTextView.layer.cornerRadius = ViewProperties.cornerRadius
        inputTextView.layer.borderWidth = ViewProperties.borderWidth
        inputTextView.layer.borderColor = ViewColor.basicBorder.cgColor
        
        if #available(iOS 13.0, *) {
            outputTypeSegmentedControl.selectedSegmentTintColor = ViewColor.basicText
            outputTypeSegmentedControl.backgroundColor = ViewColor.defaultBackground
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: ViewColor.basicButtonText]
            outputTypeSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        }
        
        outputTypeSegmentedControl.layer.borderWidth = ViewProperties.borderWidth
        outputTypeSegmentedControl.layer.cornerRadius = ViewProperties.cornerRadius
        outputTypeSegmentedControl.layer.borderColor = ViewColor.basicBorder.cgColor
        
        translateButton.layer.cornerRadius = ViewProperties.cornerRadius
        translateButton.backgroundColor = ViewColor.basicButtonBackground
        translateButton.tintColor = ViewColor.basicButtonText
        
        outputTextView.layer.cornerRadius = ViewProperties.cornerRadius
        outputTextView.layer.borderWidth = ViewProperties.borderWidth
        outputTextView.layer.borderColor = ViewColor.basicBorder.cgColor
        
        inputTextView.delegate = self
        inputTextView.addAccessoryButtons()
    }
}

// MARK: UIViewController protocol conformance
extension TranslatorViewController: UITextViewDelegate {}
