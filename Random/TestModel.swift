//
//  TestModel.swift
//  Random
//
//  Created by FangZhongli on 2019/10/17.
//  Copyright © 2019 Lingju. All rights reserved.
//

import UIKit

class TestModel: NSObject {
    
    static func testFunction() {
        
        var node = SNode.init(Data: 1)
        var node1 = node
        node1.Data = 2
//        node.Data = 5
        node.changeData(5)
        
        print("\(String(describing: node.Data))===\(String(describing: node1.Data))===\(FNode.paddressNode(node))===\(FNode.paddressNode(node1))")
        
        let c = CNode()
        c.Data = 1
        let c1 = c
        c1.Data = 3
        
        print("\(String(describing: c.Data))===\(String(describing: c1.Data))===\(FNode.paddressNode(c))===\(FNode.paddressNode(c1))")
        
        
        
    }
    
    

}



struct SNode {
    var Data: Int?
}

extension SNode {
    mutating func changeData(_ data: Int) {
        self.Data = data
    }
}

class CNode {
    var Data: Int?
}


struct FNode {
    static func paddressNode(_ p: Any) -> UnsafeMutableRawPointer {
        return Unmanaged.passRetained(p as AnyObject).toOpaque()
    }
}
