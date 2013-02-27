import bb.cascades 1.0

GroupDataModel {
    grouping: ItemGrouping.ByFullValue
    sortingKeys: [
        "done",
        "title"
    ]
    onItemAdded: {
        if (addShown) {
            if (nav.top == taskListPage) {
                tasksList.clearSelection();
                tasksList.scrollToItem(indexPath, ScrollAnimation.Default);
            }
        }
    }
    onItemRemoved: {
        var lastIndexPath = last();
        if (lastIndexPath[0] == undefined) {
            if (nav.top != taskListPage) {
                nav.popAndDelete();
            }
        }
    }
    onItemUpdated: {
        contentView = data(indexPath);
    }
}