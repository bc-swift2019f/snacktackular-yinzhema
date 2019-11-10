//
//  Reviews.swift
//  Snacktacular
//
//  Created by Yinzhe Ma on 11/10/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray:[Review]=[]
    var db: Firestore!
    init(){
        db=Firestore.firestore()
    }
    
    func loadData(spot: Spot, completed: @escaping () -> ()){
        guard spot.documentID != "" else{
            return
        }
    db.collection("spots").document(spot.documentID).collection("reviews").addSnapshotListener{ (querySnapshot,error) in
        guard error == nil else {
            print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
        }
        self.reviewArray=[]
        // There are querySnapshot!.documents.count ducments in the spots snapshots
        for document in querySnapshot!.documents {
            let review=Review(dictionary: document.data())
            review.documentID=document.documentID
            self.reviewArray.append(review)
        }
        completed()
        }
    }
}
