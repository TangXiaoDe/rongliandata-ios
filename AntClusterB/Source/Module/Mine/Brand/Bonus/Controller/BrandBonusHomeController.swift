//
//  BrandBonusHomeController.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/7/26.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  渠道分红主页

import UIKit

class BrandBonusHomeController: BaseViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "渠道分红"
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
