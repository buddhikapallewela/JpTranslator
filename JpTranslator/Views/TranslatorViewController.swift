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
//    func inputTextViewFocusFirstResponder()
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

// MARK: UIViewController protocol conformance
extension TranslatorViewController: UITextViewDelegate {}

// MARK: TranslatorUserInterface protocol conformance
extension TranslatorViewController: TranslatorUserInterface {
    
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
    
    func inputTextViewResignFirstResponder() {
        self.inputTextView.resignFirstResponder()
    }
    
    private func setupUIControls() {
        inputTextViewHeightConstraint.constant = UIScreen.main.bounds.height / 3
        
        inputLabel.textColor = UIColor.purple
        outputLabel.textColor = UIColor.purple
        
        outputTextView.tintColor = UIColor.purple
        inputTextView.layer.cornerRadius = 5.0
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.borderColor = UIColor.purple.cgColor
        
        if #available(iOS 13.0, *) {
            outputTypeSegmentedControl.backgroundColor = UIColor.lightGray
            outputTypeSegmentedControl.tintColor = UIColor.yellow
            outputTypeSegmentedControl.selectedSegmentTintColor = UIColor.purple
        } 
        
        //let titleTextAttributes2 = []
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow, NSAttributedString.Key.backgroundColor: UIColor.purple]
        outputTypeSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        outputTypeSegmentedControl.layer.backgroundColor = UIColor.lightGray.cgColor
        
        translateButton.layer.cornerRadius = 5.0
        translateButton.backgroundColor = UIColor.purple
        translateButton.tintColor = UIColor.yellow
        
        outputTextView.layer.cornerRadius = 5.0
        outputTextView.layer.borderWidth = 1
        outputTextView.layer.borderColor = UIColor.purple.cgColor
        
        inputTextView.delegate = self
        inputTextView.addAccessoryButtons()
    }
}
