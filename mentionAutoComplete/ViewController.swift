//
//  ViewController.swift
//  mentionAutoComplete
//
//  Created by Hafiz Wahid on 11/05/2017.
//  Copyright © 2017 hw. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var autoCompleteValues = ["ali", "$aada", "@joseph", "@john", "$IHSG", "$SYLA", "@jesus", "$test"]
    var autoComplete = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.isHidden = true
        textView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITextViewDelegate
{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let substring = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        
        self.autoComplete.removeAll()
        self.tableView.reloadData()
        
        
        if let result: (tag: String, range: NSRange) = otoCadang.sharedInstance.lookingForTag(substring, position: range)
        {
            otoCadang.sharedInstance.foundRange = result.range
            
            for val in autoCompleteValues
            {
                if result.tag.characters.count > 1 && val.range(of: result.tag, options: NSString.CompareOptions.caseInsensitive) != nil
                {
                    tableView.isHidden = false
                    self.autoComplete.append(val)
                }
            }
            
            if self.autoComplete.count > 0
            {
                self.tableView.reloadData()
            }
        } else {
            tableView.isHidden = true
        }
        
        return true
    }
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel!.text = autoComplete[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return autoComplete.count
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        let selectedWord: String = selectedCell.textLabel!.text! + " "
        
        var string: NSString = NSString(string: self.textView.text!)
        string = string.replacingCharacters(in: otoCadang.sharedInstance.foundRange, with: selectedWord) as NSString
        
        // change text field value
        textView.text = string as? String
        
        // change cursor position
        let positionOriginal = textView.beginningOfDocument
        if let cursorLocation: UITextPosition = self.textView.position(from: positionOriginal, offset: otoCadang.sharedInstance.foundRange.location + selectedWord.characters.count)
        {
            self.textView.selectedTextRange = self.textView.textRange(from: cursorLocation, to: cursorLocation)
        }
        
        
        
        // remove suggestion
        self.autoComplete.removeAll()
        self.tableView.reloadData()
        tableView.isHidden = true
    }
    
}

