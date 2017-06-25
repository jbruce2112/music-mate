//
//  TraitsViewController.swift
//  Song Traits
//
//  Created by John on 4/9/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Cocoa

class TraitsViewController: NSViewController {
	
	var api: SpotifyAPI?
	
	@IBOutlet fileprivate var traitsTableView: NSTableView!
	fileprivate var traits: [(String, String)]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		traitsTableView.delegate = self
		traitsTableView.dataSource = self
	}
}

extension TraitsViewController: NSTableViewDataSource {
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		
		return traits?.count ?? 0
	}
}

extension TraitsViewController: NSTableViewDelegate {
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		guard let traits = traits else {
			return nil
		}
		
		var id: String
		var text: String
		if tableColumn == tableView.tableColumns[0] {
			id = "KeyID"
			text = traits[row].0
		} else {
			id = "ValueID"
			text = traits[row].1
		}
		
		if let cell = tableView.make(withIdentifier: id, owner: nil) as? NSTableCellView {
			cell.textField?.stringValue = text
			return cell
		}
		
		return nil
	}
}

extension TraitsViewController: SongChangeDelegate {
	
	func songDidChange(_ song: Song) {
		
		api?.features(forSong: song) { features in
			
			guard let features = features else {
				return
			}
			
			self.traits = features.formattedValues()
			self.traitsTableView.reloadData()
		}
	}
}
