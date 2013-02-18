import bb.cascades 1.0
import "AddPage"

NavigationPane {
    id: nav
    property variant contentView
    property bool addShown: false
    
    Page {
        id: taskListPage
        titleBar: TitleBar {
            title: qsTr("Tasks")
        }
        
        Container {
            ListView {
                id: tasksList
                objectName: "tasksList"
                layout: StackListLayout {
                    headerMode: ListHeaderMode.Sticky
                }
                dataModel: tasksModel
                
                function viewTriggered() {
                    var page = taskPageDefinition.createObject();
                    nav.push(page);
                }
                
                function updateDoneStatusTriggered() {
                    _taskApp.updateSelectedRecordDoneStatus(contentView.done == 0 ? 1 : 0);
                }
                
                function deleteTriggered() {
                    _taskApp.deleteRecord();
                }
                                            
                listItemComponents: [
                    ListItemComponent {
                        id: rootId
                        type: "item"
                        StandardListItem {
                            imageSpaceReserved: false
                            title: (ListItemData.done == 1 ? "<html><span style='text-decoration:line-through'>" : "") + ListItemData.title + (ListItemData.done == 1 ? "</span></html>" : "")
                            id: taskItemId
                            
                            contextActions: [
                                ActionSet {
                                    title: contentView.title
                                    ActionItem {
                                        title: qsTr("View")
                                        imageSource: "asset:///images/ViewDetails.png"
                                        
                                        onTriggered: {
                                            taskItemId.ListItem.view.viewTriggered();
                                        }
                                    }
                                    ActionItem {
                                        title: ListItemData.done == 0 ? qsTr("Done") : qsTr("Todo")
                                        imageSource: "asset:///images/Done.png"
                                        
                                        onTriggered: {
                                            taskItemId.ListItem.view.updateDoneStatusTriggered();
                                        }
                                    }
                                    DeleteActionItem {
                                        objectName: "DeleteAction"
                                        title: qsTr("Delete")
                                        
                                        onTriggered: {
                                            taskItemId.ListItem.view.deleteTriggered();
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    ListItemComponent {
                        type: "header"
                        Header {
                            title: ListItemData == 1 ? qsTr("Done") : qsTr("Todo")
                        }
                    }
                ]
                onTriggered: {
                    if (indexPath.length > 1) {
                        clearSelection();
                        select(indexPath);
                        var page = taskPageDefinition.createObject();
                        nav.push(page)
                    }
                }
                onSelectionChanged: {
                    if (selected) {
                        contentView = dataModel.data(indexPath);
                    }
                }
                attachedObjects: [
                    GroupDataModel {
                        id: tasksModel
                        objectName: "tasksModel"
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
                ]
            }
        }
        attachedObjects: [
            Sheet {
                id: addSheet
                AddPage {
                    id: add
                    onAddPageClose: {
                        tasksList.clearSelection();
                        addSheet.close();
                    }
                }
                onClosed: {
                    add.newTask();
                }
            },
            ComponentDefinition {
                id: taskPageDefinition
                source: "TaskPage/TaskPage.qml"
            }
        ]
        
        actions: [
            ActionItem {
                title: qsTr("Add")
                imageSource: "asset:///images/Add.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    displayAddSheet();
                }
            }
        ]
    }
    
	function displayAddSheet() {
        addSheet.open();
        nav.addShown = true;
    }
    
    onTopChanged: {
        if (page == taskListPage) {
            taskList.clearSelection();
        }
    }
    
    onPopTransitionEnded: {
        page.destroy();
    }
}