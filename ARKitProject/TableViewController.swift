//
//  TableViewController.swift
//  ARKitProject
//
//  Created by Francesco Paolo dellaquila on 09/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var TableData:Array< String > = Array < String >()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        get_data_from_url("http://idia.altervista.org/gameObjects.php?parameter=Allobjects")

    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = TableData[indexPath.row]
        
        return cell
    }
    
    
    
    
    
    
    func get_data_from_url(_ link:String)
    {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            
            self.extract_json(data!)
            
            
        })
        
        task.resume()
        
    }
    
    
    func extract_json(_ data: Data)
    {
        
        
        let json: Any?
        
        do
        {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch
        {
            return
        }
        
        guard let data_list = json as? NSArray else
        {
            return
        }
        
        
        if let vr_list = json as? NSArray
        {
            for i in 0 ..< data_list.count
            {
                if let vr_obj = vr_list[i] as? NSDictionary
                {
                    if let obj_name = vr_obj["name"] as? String
                    {
                        if let obj_cost = vr_obj["cost"] as? String
                        {
                            if let obj_productionyear = vr_obj["production_year"] as? String
                            {
                                TableData.append(obj_name + " " + obj_cost + "        " + "(" + obj_productionyear + ")")
                            }

                        }
                    }
                }
            }
        }
        
        
        
        DispatchQueue.main.async(execute: {self.do_table_refresh()})
        
    }
    
    func do_table_refresh()
    {
        self.tableView.reloadData()
        
    }
    

    

}
