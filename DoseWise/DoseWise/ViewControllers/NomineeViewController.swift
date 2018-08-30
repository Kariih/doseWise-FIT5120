import UIKit

class NomineeViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let dbPresenter = DbPresenter()
    @IBOutlet weak var nomineeTableView: UITableView!
    private var nomineeList = [Nominee]()
    let cellHeight:CGFloat = 120
    var clickedCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad();
        print("featching possible nominees")
        nomineeList = dbPresenter.featchAllNominees()
        
        nomineeTableView.delegate = self
        nomineeTableView.dataSource = self
        //self.tableViewNominees.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nomineeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nomineeTableView.dequeueReusableCell(withIdentifier: "nomineeCell", for: indexPath)
        cell.textLabel?.text = "\(nomineeList[indexPath.item].name!) - \(nomineeList[indexPath.item].phoneNo!)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        clickedCell = indexPath.row
        performSegue(withIdentifier: "editNomineeSegueue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNomineeSegueue" {
            let viewController = segue.destination as! EditNomeneeViewController
            
            viewController.passedNominee = nomineeList[clickedCell]
        }
    }
}
