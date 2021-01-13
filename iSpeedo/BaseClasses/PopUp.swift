//
//  PopUp.swift
//  STest
//
//  Created by Pm Abi on 22/10/20.
//  Copyright © 2020 Pm Abi. All rights reserved.
//

import UIKit


struct PopUpBaseItem: PopUpItem {
    var title: String
    var id: NSInteger
}
struct PopUpDataItem: PopUpData {
    var popUpTitle: String
    var popUpItems: [PopUpItem]
}
protocol PopUpData {
    var popUpTitle: String { get set }
    var popUpItems: [PopUpItem] { get set }
}
protocol PopUpItem {
    var title: String { get set }
    var id: NSInteger { get set }
}

enum PopUpConfiguratiuons {
    case customWidth(width: CGFloat)
    case customMultiplier(multiplier: CGFloat)
}
//infix operator =>
enum PopUpStyle: Equatable, RawRepresentable {
    
    case `default`(title: String?)
    case cancelEnabled(title: String)
    public static func == (lhs: PopUpStyle, rhs:PopUpStyle) -> Bool {
        switch (lhs, rhs) {
        case (.default, .default):
            return true
        case (.cancelEnabled, .cancelEnabled):
            return true
        default:
            return false
        }
    }
    init?(rawValue: String) {
        switch rawValue {
        case "default": self = .default(title: "")
        case "cancelEnabled": self = .cancelEnabled(title: "nil")
        default:
            return nil
        }
    }
    var rawValue: String {
        return ""
    }
}
// Note:- Since this is a generic class the delegates are added as a single file .
class PopUp<T: RawRepresentable>: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate  {

    var popUpHandlerType: PopUpHandleType = .basic
    var cellSize: CGFloat = 44
    var headerHeight: CGFloat = 40
    var footerHeight: CGFloat = 40
    var popUpData: PopUpData?
    var popUpTitle: String?// = "Select Priority"
//    var popUpItems: [String] = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
    var popUpItems: [PopUpItem] = [PopUpItem]()

    var popUpWidth: CGFloat = 280
    var maxNumberOfItems = 6
    var popUpBackgroundView: UIView = {
        let popUpBackgroundView = UIView()
        popUpBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        popUpBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return popUpBackgroundView
    }()
    
    var popUpContainer: UIView = {
        let container: UIView = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .red
        container.clipsToBounds = true
        container.layer.cornerRadius = 8
        return container
    }()
    
    lazy var popupTable: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = .red
        tableView.separatorStyle = .none

        return tableView
    }()
    
    lazy var footerView: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.frame = .zero CGRect(origin: .zero, size: CGSize(width: view.frame.width,
//                                                          height: headerHeight))
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = UIColor(hexString: "#EBEBEB")
        button.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
        return button
    }()
   
    var popUpTitleLabel: UILabel = {
        let titleLabel: UILabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    //MARK:- POPUP Basic types
    enum PopUpHandleType {
        case enumerated
        case basic
        case stringBased
    }
    
    typealias PopUpHandler = ((PopUpItem) -> ())
    typealias PopUpEnumeratedHandler = ((T) -> ())
    typealias PopUpStringHandler = ((String) -> ())

    var basicHandler: PopUpHandler?
    var enumeratedHandler: PopUpEnumeratedHandler?
    var stringHandler: PopUpStringHandler?

    var popUpStyle: PopUpStyle = .cancelEnabled(title: "Select Priority")
    
    init(popUpData: PopUpData, handler: @escaping PopUpHandler) {
        super.init(nibName: nil, bundle: nil)
        setImmediateDefaults()
        self.basicHandler = handler
        self.popUpTitle = popUpData.popUpTitle
        popUpStyle = .cancelEnabled(title: popUpData.popUpTitle)
        self.popUpItems = popUpData.popUpItems
        self.popUpHandlerType = .basic
        setConfigurations(configurations: [])
        initViews()
    }
    fileprivate func setImmediateDefaults() {
        self.modalPresentationStyle = .overCurrentContext
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    init(title: String, items: [T], handler: @escaping PopUpEnumeratedHandler) {
        super.init(nibName: nil, bundle: nil)
        setImmediateDefaults()
        self.popUpTitle = title
        self.enumeratedHandler = handler
        self.popUpHandlerType = .enumerated
        for (index, item) in items.enumerated() {
            guard let title = item.rawValue as? String else { return }
            let newPopUpItem = PopUpBaseItem(title: title, id: index)
            popUpItems.append(newPopUpItem)
        }
//        items.forEach { (item) in
//            guard let title = item.rawValue as? String else { return }
//            let newPopUpItem = PopUpBaseItem(title: title, id: UUID())
//            popUpItems.append(newPopUpItem)
//        }
        initViews()
    }
    //String based initialisation
    init(style: PopUpStyle, items: [String], configurations: [PopUpConfiguratiuons] = [], handler: @escaping PopUpStringHandler) {
        super.init(nibName: nil, bundle: nil)
        setImmediateDefaults()
        self.popUpStyle = style
        self.stringHandler = handler
        self.popUpHandlerType = .stringBased
        for (index, item) in items.enumerated() {
            let newPopUpItem = PopUpBaseItem(title: item, id: index)
            popUpItems.append(newPopUpItem)
        }
//        items.forEach { (item) in
//            let newPopUpItem = PopUpBaseItem(title: item, id: UUID())
//            popUpItems.append(newPopUpItem)
//        }
        setConfigurations(configurations: configurations)
        initViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func loadView() {
        super.loadView()
    }
    
    func setConfigurations(configurations: [PopUpConfiguratiuons]) {
        for configuration in configurations {
            switch configuration {
            case .customMultiplier(multiplier: let multiplier):
                self.popUpWidth =  UIScreen.main.bounds.width * multiplier
            case .customWidth(width: let width):
                self.popUpWidth = width
            }
        }
    }
    func initViews() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.addSubview(popUpContainer)

        popUpContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popUpContainer.heightAnchor.constraint(equalToConstant: calculateHeightForPopup()).isActive = true
        popUpContainer.widthAnchor.constraint(equalToConstant: popUpWidth).isActive = true
        
        popUpContainer.addSubview(popupTable)
        popupTable.leftAnchor.constraint(equalTo: popUpContainer.leftAnchor, constant: 0).isActive = true
        popupTable.rightAnchor.constraint(equalTo: popUpContainer.rightAnchor, constant: 0).isActive = true
//        popupTable.bottomAnchor.constraint(equalTo: popUpContainer.bottomAnchor, constant: 0).isActive = true
        popupTable.isScrollEnabled = popUpItems.count > maxNumberOfItems
    
        switch self.popUpStyle {
        case .cancelEnabled(title: let title):
            //Popup header adding mechanism
            addTitleToTableView(title: title)
            
            //PopUp footer adding mechanism
            popUpContainer.addSubview(footerView)
            footerView.leftAnchor.constraint(equalTo: popUpContainer.leftAnchor, constant: 0).isActive = true
            footerView.rightAnchor.constraint(equalTo: popUpContainer.rightAnchor, constant: 0).isActive = true
            footerView.bottomAnchor.constraint(equalTo: popUpContainer.bottomAnchor, constant: 0).isActive = true
            footerView.heightAnchor.constraint(equalToConstant: footerHeight).isActive = true
            
            popupTable.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: 0).isActive = true

            //PopUpTable Styles set here
            popupTable.separatorStyle = .singleLine
            
        case .default(title: let title):
            addTitleToTableView(title: title)
            //PopUpTable Styles set here
            self.popupTable.separatorStyle = .none
            popupTable.bottomAnchor.constraint(equalTo: popUpContainer.bottomAnchor, constant: 0).isActive = true

        }
    }
    
    func addTitleToTableView(title: String?) {
        popUpContainer.addSubview(popUpTitleLabel)
        popUpTitleLabel.leftAnchor.constraint(equalTo: popUpContainer.leftAnchor, constant: 0).isActive = true
        popUpTitleLabel.rightAnchor.constraint(equalTo: popUpContainer.rightAnchor, constant: 0).isActive = true
        popUpTitleLabel.topAnchor.constraint(equalTo: popUpContainer.topAnchor, constant: 0).isActive = true
        popUpTitleLabel.heightAnchor.constraint(equalToConstant: (title == nil) ? 0 : headerHeight).isActive = true
        popUpTitleLabel.text = title
        
        switch self.popUpStyle {
        case .default(title: _):
            popUpTitleLabel.backgroundColor = .white// UIColor(hexString: "#EBEBEB")
        case .cancelEnabled(title: _):
            popUpTitleLabel.font = .boldSystemFont(ofSize: 16)
            popUpTitleLabel.backgroundColor = UIColor(hexString: "#EBEBEB")
        }
        // TableLayout anchored to the popuptitle to ensure every item is visible
        popupTable.topAnchor.constraint(equalTo: popUpTitleLabel.bottomAnchor, constant: 0).isActive = true
    }
    
    func calculateHeightForPopup() -> CGFloat {
        let cellHeight = cellSize * CGFloat(min(popUpItems.count, maxNumberOfItems))
        let heightForHeader = (titleForPopUp() == nil) ? 0 : self.headerHeight
        let heightForFooter = (self.popUpStyle == .default(title: nil)) ? 0 : footerHeight

        let containerHeight = cellHeight + heightForHeader + heightForFooter
        return containerHeight
    }
    func titleForPopUp() -> String? {
        var popUpTitle: String?
        switch self.popUpStyle {
        case .default(title: let title):
            popUpTitle =  title
        case .cancelEnabled(title: let title):
            popUpTitle = title
        }
        return popUpTitle
    }
    @objc func dismissPopUp() {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popUpItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = popUpItems[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismissPopUp()
        switch self.popUpHandlerType {
        case .basic:
            guard let basicHandler = self.basicHandler else {
                print("No Basic handle set")
                return }
            let item = self.popUpItems[indexPath.row]
            basicHandler(item)
        case .enumerated:
            guard let enumeratedHandle = self.enumeratedHandler else {
                print("No Enumerated handle set")
                return }
            
            guard let rawValue = self.popUpItems[indexPath.row].title as? T.RawValue else {
                print("Unable to convert the popUp item title to rawvalue")
                return }
            guard let item = T.init(rawValue: rawValue) else {
                print("No enum present with the rawvalue provided")
                return }
            enumeratedHandle(item)
        case .stringBased:
            guard let stringHandle = self.stringHandler else {
                print("No String handle set")
                return }
            let stringValue = self.popUpItems[indexPath.row].title
            stringHandle(stringValue)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellSize
    }
    //MARK:- Gesture Recogniser Delegates
    // This will make the tapgesture avoid the tableview
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.popupTable) == true {
            return false
        }
        return true
    }
}

