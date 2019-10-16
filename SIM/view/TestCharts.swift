//
//  TestCharts.swift
//  SIM
//
//  Created by user147645 on 10/15/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class TestCharts: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var testCharts: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
      //  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let cell = testCharts.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
       
        cell.backgroundColor = .red
        cell.widthAnchor.constraint(equalToConstant: CGFloat(exactly: 50.0) ?? 10.0)
        cell.heightAnchor.constraint(equalToConstant: CGFloat(exactly: 35.0) ?? 10.0)
        
        return cell
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

       //testCharts.
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
