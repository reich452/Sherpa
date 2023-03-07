//
//  ReportViewModel.swift
//  Cloud.vs.Fire
//
//  Created by Nick Reichard on 3/1/23.
//  Copyright © 2023 Nick Reichard. All rights reserved.
//

import Foundation

// Non mutation, read only for the report flow.
struct ReportViewModel {
    
    // MARK: - properties
    
    let title: String
    let subTitle: String
    private let post: Post
    
    // MARK: - Init
    
    init(title: String, subTitle: String, post: Post) {
        self.title = title
        self.subTitle = subTitle
        self.post = post
    }
    
   static func buildReportSelectionFrom(post: Post) -> [ReportViewModel] {
        let report1 = ReportViewModel(title: "Self Injury", subTitle: "Eating disorders, cutting or promoting suicide.", post: post)
        let report2 = ReportViewModel(title: "Violence or Harm", subTitle: "Graphic injury, unlawful activity, dangerous or criminal organization.", post: post)
        let report3 = ReportViewModel(title: "Sale or promotion of filearms", subTitle: "Any promotion or sale of firearms.", post: post)
        let report4 = ReportViewModel(title: "Harassment or bullying", subTitle: "Including cyber bullying.", post: post)
        let report5 = ReportViewModel(title: "Hate speech or symbols", subTitle: "Racest, homophobic or sexist slurs.", post: post)
        let report6 = ReportViewModel(title: "Nudity or pornography", subTitle: "Any relation to XXX images.", post: post)
        let report7 = ReportViewModel(title: "Copyright or trademark infringement", subTitle: "Intellectual property violation.", post: post)
        let report8 = ReportViewModel(title: "I just don't like it", subTitle: "I don't want to see this.", post: post)
        
        let reportVMs = [report1, report2, report3, report4, report5, report6, report7, report8]
        return reportVMs
    }
}
