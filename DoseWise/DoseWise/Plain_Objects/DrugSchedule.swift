//
//  DrugSchedule.swift
//  DoseWise
//
//  Created by Hasini Vasudevan on 4/9/18.
//  Copyright © 2018 Monash. All rights reserved.
//

import Foundation

class DrugSchedule {
    let TableName="drugSchedule"
    var id: Int?
    var name: String!
    var no_of_days: Int!
    var no_of_times_per_day: Int!
    var no_of_pills_per_dose: Int!
    var timings = [String]()
    var type_of_pill: String!
    
    init(id: Int, name: String, no_of_days: Int, no_of_times_per_day: Int, no_of_pills_per_dose:Int, timings: [String], type_of_pill: String){
        self.id = id
        self.name = name
        self.no_of_times_per_day = no_of_times_per_day
        self.no_of_pills_per_dose = no_of_pills_per_dose
        self.timings = timings as [String]
        self.type_of_pill = type_of_pill as String
        self.no_of_days = no_of_days
    }
    
    init() {}
    
    func getInsertQuery(TableName:String) ->String{
        let timings=self.timings.joined(separator: ";");
        let values="VALUES(\'\(self.name!)\',\(self.no_of_days!),\(self.no_of_times_per_day!),\(self.no_of_pills_per_dose!),\'\(timings)\',\'\(self.type_of_pill!)\')"
        let insert="INSERT INTO "+TableName+"(name, no_of_days, no_of_times_per_day, no_of_pills_per_dose, timings, type_of_pill) "+values
       
        return(insert)
    }
    
    func getSelectQuery(TableName:String) ->String{
        
        return("SELECT * FROM "+TableName)
    }
    
    func getUpdateQuery() ->String{
        let timings=self.timings.joined(separator: ";");
        let update="UPDATE \(TableName) SET name=\'\(self.name!)\', no_of_days=\(self.no_of_days!), no_of_times_per_day=\(self.no_of_times_per_day!), no_of_pills_per_dose=\(self.no_of_pills_per_dose!), timings=\'\(timings)\', type_of_pill=\'\(self.type_of_pill!)\' WHERE id=\(self.id!)"
        
        return(update)
    }
    
    func getDeleteQuery() ->String{
        let delete="DELETE FROM \(TableName) WHERE id=\(self.id!)"
        return(delete)
    }
    func getDeleteAllQuery()->String{
        let delete="DELETE FROM \(TableName);"
        return(delete)
    }
}

