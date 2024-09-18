//
//  TestDatabseReference.swift
//  Roomie
//
//  Created by David Shapiro on 9/7/24.
//

import Foundation
import FirebaseDatabase

//Thank you chatGPT
class TestDatabaseReference: DatabaseReference {
    var childPaths: [String] = []
    var updatedValues: [String: Any]?
    var didCallUpdate = false
    
    override func child(_ pathString: String) -> DatabaseReference {
        childPaths.append(pathString)
        return self
    }
    
    override func updateChildValues(_ values: [AnyHashable: Any], withCompletionBlock block: @escaping (Error?, DatabaseReference) -> Void) {
            updatedValues = values as? [String: Any]
            didCallUpdate = true
            block(nil, self)
    }
}
