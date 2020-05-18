//
//  ViewController.swift
//  header
//
//  Created by wwly on 2020/5/18.
//  Copyright © 2020 wwly. All rights reserved.
//

import UIKit

class Header: UIView {
    
    var heightChanged: ((CGFloat) -> ())?
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.red
        label.numberOfLines = 0
        return label
    }()
    
    lazy var line: UIView = {
        let v = UIView()
        v.backgroundColor = .green
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(line)
        
        label.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        line.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            make.left.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
            make.top.equalTo(label.snp.bottom).offset(10).priority(.required)
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heightChanged?(self.frame.size.height)
    }
    
    func change() {
        label.text = "212132121321213212132121321213212132121321213212132121321213212132121321213212132121321213212132121321213212132121321213212132121321213212132121321213212132121321213"
        label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let h = Int(arc4random_uniform(100))
        line.snp.updateConstraints { (make) in
            make.height.equalTo(h)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    lazy var header: Header = {
        let v = Header(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80))
        v.backgroundColor = .blue
        return v
    }()
    
    lazy var tableView: UITableView = {
        let v = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        v.register(UITableViewCell.self, forCellReuseIdentifier: "CELL_ID")
        v.delegate = self
        v.dataSource = self
        v.backgroundColor = .gray
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var _header = header
        header.heightChanged = {[unowned self] height in
            _header?.frame = CGRect(x: 0, y: 0, width: _header?.frame.size.width ?? 0, height: height)
            
            self.tableView.tableHeaderView = _header
        }
        tableView.tableHeaderView = header
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        header.setNeedsLayout()
        header.layoutIfNeeded()
        
        header.label.text = "111111111111111111111111111111111111111111111111111111"
        header.label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let btn = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        tableView.addSubview(btn)
    }

    @objc func clickBtn() {
        header.change()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL_ID", for: indexPath)
        cell.backgroundColor = .yellow
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

