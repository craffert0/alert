// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct ChecklistView: View {
    let checklist: eBirdChecklist

    var body: some View {
        VStack {
            Text(checklist.userDisplayName).font(.largeTitle)
            Text(checklist.comments ?? "no comment")
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(checklist.obs) { o in
                        HStack {
                            if let how = o.howManyStr {
                                Text(how)
                            }
                            Text(o.speciesCode)
                            if let c = o.comments {
                                Text(c)
                            }
                        }
                    }
                }
            }
        }
    }
}
