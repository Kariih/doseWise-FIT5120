import Foundation

class Quiz{
    
    //list for quiz & answer
    var qLs:[Int:String]=[:]
    var aLs:[Int:String]=[:]
    //current question
    var currentQ=""
    var curQsKey = -1
    
    // create all quizzes,
    func createQuizzes(){
        
        //list of questions, do not add questions that will result in a same answer with other existing questions
        let queLs  = [1:"8 * 2 =",
                      2:"4 + 3 =",
                      3:"100 - 4 =",
                      4:"What is abbreviation of Australia (2 charactors only)?",
                      5:"9 + 3 =",
                      6:"12 / 2 =",
                      7:"10 - 7 =",
                      8:"6 + 3 =",]
        
        qLs=queLs
        
        //list of answers, must not have duplicate answers, meaning every value must be unique, and must not be -1
        let ansLs = [1:"16",
                     2:"7",
                     3:"96",
                     4:"AU",
                     5:"12",
                     6:"6",
                     7:"3",
                     8:"9",]
        
        aLs=ansLs
        
    }
    
    
    //randomly choose a int from 1-8, and find the according value in qLs by the number just chosen
    func ranSeleQue()->String{
        
        curQsKey = Int(arc4random_uniform(8))+1
        
        currentQ=qLs[curQsKey]!
        
        return currentQ
        
    }
    
    
    // take user input as parameter and compare it against every value of aLs, if true, go to check whether the answer's key match with question's key, if true, answer is correct
    func verifyAnswer(ans:String)->Bool{
        var isCorrect = false
        let currentA=ans.trimmingCharacters(in: .whitespacesAndNewlines)
        
        for i in aLs{
            if i.value==currentA{
                if i.key==curQsKey{
                    isCorrect=true
                    return isCorrect
                }
            }
        }
        return isCorrect
    }
}
