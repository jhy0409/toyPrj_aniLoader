//
//  ViewController.swift
//  aniLoader
//
//  Created by jinhee ye on 2023/09/05.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    /// loader button .touchUpInside에 동작
    /// 로더뷰를 보여준 뒤 0.3초 뒤에 로더 애니메이션 멈춤
    @IBAction func btnShowLD(_ sender: UIButton) {
        Util().startLoading(view: view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let `self` = self else { return }
            Util().stopLoading(view: self.view)
        }
    }
    
    
}

class Util: NSObject {
    static let shared = Util()
    
    var imgView: UIImageView = UIImageView()
    
    var spinsPngs: [UIImage]? {
        var tmp: [UIImage] = []
        for i in 1...30 {
            tmp.append(.init(named: "spin/\(i)") ?? UIImage())
        }
        return tmp
    }
    
    func startLoading(view: UIView) {
        let viewHgt: CGFloat = 50
        imgView = .init(frame: .init(x: (view.frame.width - viewHgt) / 2, y: (view.frame.height / 2) - (viewHgt * 2), width: viewHgt, height: viewHgt))
        
        imgView.contentMode             = .scaleToFill
        imgView.restorationIdentifier   = Tag.LOADER_IMG_VIEW.rawValue
        
        imgView.animationImages         = spinsPngs
        imgView.animationDuration       = 1.3
        
        view.addSubview(imgView)
        imgView.startAnimating()
    }
    
    func stopLoading(view: UIView) {
        imgView.stopAnimating()
        /// 뷰 태그가 일치하는 뷰
        /// 0.3초 뒤 불투명도 0%
        /// 애니메이션 끝난 뒤 뷰에서 제거
        if let v = view.subviews.filter({ $0.restorationIdentifier == Tag.LOADER_IMG_VIEW.rawValue }).first {
            UIView.animate(withDuration: 0.3,
                           animations: { v.alpha = 0 },
                           completion: { _ in v.removeFromSuperview() }
            )
        }
    }
    
    
}

enum Tag: String {
    case LOADER_IMG_VIEW
}
