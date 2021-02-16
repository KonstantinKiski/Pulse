//
//  MenuBar.swift
//  Bricket
//
//  Created by Константин Киски on 23.09.2020.
//

import Foundation
import UIKit

class MenuBar: UIView {
    
    // MARK: - UI Elements

    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var todayButton: UIButton!
    @IBOutlet private weak var eventsButton: UIButton!
    @IBOutlet private weak var newsButton: UIButton!
    
    private var view: UIView!

    // MARK: - Closure
    
    var todayAction: () -> Void = { }
    var eventsAction: () -> Void = { }
    var newsAction: () -> Void = { }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
        
    // MARK: - UI Controller
    
    private func setButtonActive(button: UIButton) {
        button.backgroundColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
    }
    
    private func setButtonNotActive(button: UIButton) {
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 13)
    }
    
    func setTodayButtonActive() {
        setButtonActive(button: todayButton)
        setButtonNotActive(button: eventsButton)
        setButtonNotActive(button: newsButton)
    }
    
    func setEventsButtonActive() {
        setButtonActive(button: eventsButton)
        setButtonNotActive(button: todayButton)
        setButtonNotActive(button: newsButton)
    }
    
    func setNewsButtonActive() {
        setButtonActive(button: newsButton)
        setButtonNotActive(button: eventsButton)
        setButtonNotActive(button: todayButton)
    }
    
    // MARK: - UI Actions
    
    @IBAction private func todayButton(_ sender: Any) {
        setTodayButtonActive()
        todayAction()
    }
    
    @IBAction private func eventsButton(_ sender: Any) {
        setEventsButtonActive()
        eventsAction()
    }
    
    @IBAction private func newsButton(_ sender: Any) {
        setNewsButtonActive()
        newsAction()
    }
    
    // MARK: - Functions

    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MenuBar", bundle: bundle)
        
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        view?.prepareForInterfaceBuilder()
    }
}
