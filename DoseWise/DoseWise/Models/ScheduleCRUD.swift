import Foundation
import SQLite3

class ScheduleCRUD{
    var db:OpaquePointer?
    let tableName="schedule"
    init(){}
    
    func initTables(){
        createdrugScheduleTable()
    }
    
    private func openDbConnection(){
        let fileUrl=try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("schedule.sqlite")
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening database")
            return
        }
    }
    
    private func createdrugScheduleTable(){
        openDbConnection()
        let createTableQuery="CREATE TABLE IF NOT EXISTS schedule (id INTEGER PRIMARY KEY, time Text, dosage Text, name Text)"
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
            print("Error creating table")
            return
        }
        print("DB created")
        sqlite3_close(db)
    }
    
    //let files = text.split(separator: ",")
    
    func addSchedule(schedule: Schedule, id: Int){
        openDbConnection()
        let dosage = schedule.dosage.joined(separator: ",")
        let medicine = schedule.medicineName.joined(separator: ",")
        let time = schedule.timing
        
        let insertStatement = "INSERT INTO schedule (id, time, dosage, name) VALUES("+id+", "+time+", "+dosage+", "+medicine+");"
        
        if sqlite3_exec(db, insertStatement , nil, nil, nil) != SQLITE_OK{
            print("Error Inserting into \(tableName)")
            return
        }
        print("Insert Successfull")
        sqlite3_close(db)
    }
    
}
