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
            background: backgroundPaint.imagePaint
            
            ListView {
                id: tasksList
                objectName: "tasksList"
                layout: StackListLayout {
                    headerMode: ListHeaderMode.Sticky
                }
                dataModel: TaskModel {
                    id: tasksModel
                    objectName: "tasksModel"
                }
                
                function updateDoneStatusTriggered() {
                    _taskApp.updateSelectedRecordDoneStatus(contentView.done == 0 ? 1 : 0);
                }
                
                function deleteTriggered() {
                    _taskApp.deleteRecord();
                }
                
                function updateMultiStatus() {
                    if (selectionList().length > 1) {
                        multiSelectHandler.status = qsTr("%1 items selected").arg(selectionList().length);
                    } else if (selectionList().length == 1) {
                        multiSelectHandler.status = qsTr("1 item selected");
                    } else {
                        multiSelectHandler.status = qsTr("None selected");
                    }
                }
                
                multiSelectHandler {
                    status: qsTr("None selected")
                    actions: [
                        DeleteActionItem {
                            title: qsTr("Delete")
                            onTriggered: {
                                var selectionList = tasksList.selectionList();
                                tasksList.clearSelection();
                                _taskApp.deleteRecords(selectionList);
                            }
                        }
                    ]
                }
                
                listItemComponents: [
                    ListItemComponent {
                        id: rootId
                        type: "item"
                        StandardListItem {
                            imageSpaceReserved: false
                            property string taskTitle: ListItemData.title
                            title: (ListItemData.done == 1 ? "<html><span style='text-decoration:line-through'>" : "") + taskTitle + (ListItemData.done == 1 ? "</span></html>" : "")
                            id: taskItemId
                            
                            contextActions: [
                                ActionSet {
                                    title: taskItemId.taskTitle
                                    ActionItem {
                                        title: ListItemData.done == 0 ? qsTr("Done") : qsTr("Todo")
                                        imageSource: "asset:///images/Done.png"
                                        
                                        onTriggered: {
                                            taskItemId.ListItem.view.updateDoneStatusTriggered();
                                        }
                                    }
                                    InvokeActionItem {
                                        query {
                                            mimeType: "text/plain"
                                            invokeActionId: "bb.action.SHARE"
                                        }
                                        onTriggered: {
                                            data = ListItemData.title + (ListItemData.description != "" ? " - " + ListItemData.description : "");
                                        }
                                    }
                                    MultiSelectActionItem {
                                        multiSelectHandler: taskItemId.ListItem.view.multiSelectHandler
                                        onTriggered: {
                                            multiSelectHandler.active = true
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
                        select(indexPath);
	                    contentView = dataModel.data(indexPath);
	                    var page = taskPageDefinition.createObject();
	                    nav.push(page)
	                }
                }
                onSelectionChanged: {
                    if (indexPath.length > 1)
                        contentView = dataModel.data(indexPath);
	                updateMultiStatus();
                }
            }
            attachedObjects: [
                ImagePaintDefinition {
                    id: backgroundPaint
                    imageSource: "asset:///images/background.amd"
                    repeatPattern: RepeatPattern.XY
                }
            ]
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
            tasksList.clearSelection();
        }
    }
    
    onPopTransitionEnded: {
        page.destroy();
    }
}