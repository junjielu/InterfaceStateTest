//
//  ViewController.swift
//  InterfaceStateTest
//
//  Created by 陆俊杰 on 2018/8/3.
//  Copyright © 2018年 陆俊杰. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ViewController: UIViewController {
    let tableNode = ASTableNode()
    var cellCount: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        let preloadTuningParamters = ASRangeTuningParameters(leadingBufferScreenfuls: 0.5, trailingBufferScreenfuls: 0.25)
        let displayTuningParameters = ASRangeTuningParameters(leadingBufferScreenfuls: 0.25, trailingBufferScreenfuls: 0.25)
        
        tableNode.setTuningParameters(displayTuningParameters, for: ASLayoutRangeType.display)
        tableNode.setTuningParameters(preloadTuningParamters, for: ASLayoutRangeType.preload)
        
        tableNode.view.isPagingEnabled = true
        tableNode.view.contentInsetAdjustmentBehavior = .never
        tableNode.frame = self.view.bounds
        tableNode.delegate = self
        tableNode.dataSource = self
        
        self.view.addSubnode(tableNode)
        
        let button = UIButton()
        button.setTitle("测试", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.frame = CGRect(x: UIScreen.main.bounds.width - 60 - 15, y: UIScreen.main.bounds.height - 30 - 34 - 15, width: 60, height: 30)
        self.view.addSubview(button)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.appendToBottom()
        }
    }
    
    @objc func didTapButton() {
        let testVC = TestViewController()
        self.navigationController?.pushViewController(testVC, animated: true)
    }
    
    func appendToBottom() {
        print("[LOG] append new")
        self.cellCount = 100
        let indexPaths = (1...99).map { IndexPath(row: $0, section: 0) }
        self.tableNode.insertRows(at: indexPaths, with: .fade)
    }
}

extension ViewController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let node = TestCellNode(index: indexPath.row)
            return node
        }
    }
}

class TestCellNode: ASCellNode {
    let textNode: RGTextNode
    let index: Int
    
    init(index: Int) {
        self.index = index
        self.textNode = RGTextNode(index: index)
        super.init()
        
        self.textNode.attributedText = NSAttributedString(string: "\(index)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        self.style.height = ASDimension(unit: .points, value: UIScreen.main.bounds.height)
        self.automaticallyManagesSubnodes = true
    }
    
    override func didEnterVisibleState() {
        super.didEnterVisibleState()
        print("[LOG] cell node visible: \(index)")
    }
    
    override func didEnterDisplayState() {
        super.didEnterDisplayState()
        print("[LOG] cell node display: \(index)")
    }
    
    override func didEnterPreloadState() {
        super.didEnterPreloadState()
        print("[LOG] cell node preload: \(index)")
    }
    
    override func didExitPreloadState() {
        super.didExitPreloadState()
        print("[LOG] cell node not preload: \(index)")
    }
    
    override func didExitDisplayState() {
        super.didExitDisplayState()
        print("[LOG] cell node not display: \(index)")
    }
    
    override func didExitVisibleState() {
        super.didExitDisplayState()
        print("[LOG] cell node not visible: \(index)")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: textNode)
    }
}

class RGTextNode: ASTextNode {
    let index: Int
    
    init(index: Int) {
        self.index = index
        super.init()
    }
    
    override func didEnterVisibleState() {
        super.didEnterVisibleState()
        print("[LOG] text node visible: \(index)")
    }
    
    override func didEnterDisplayState() {
        super.didEnterDisplayState()
        print("[LOG] text node display: \(index)")
    }
    
    override func didEnterPreloadState() {
        super.didEnterPreloadState()
        print("[LOG] text node preload: \(index)")
    }
    
    override func didExitPreloadState() {
        super.didExitPreloadState()
        print("[LOG] text node not preload: \(index)")
    }
    
    override func didExitDisplayState() {
        super.didExitDisplayState()
        print("[LOG] text node not display: \(index)")
    }
    
    override func didExitVisibleState() {
        super.didExitDisplayState()
        print("[LOG] text node not visible: \(index)")
    }
}

