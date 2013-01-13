import bb.cascades 1.0

Page {
    id: addPage
    signal addPageClose()
    
    titleBar: TitleBar {
        id: addBar
        title: "Add"
        visibility: ChromeVisibility.Visible
        
        dismissAction: ActionItem {
            title: "Cancel"
            onTriggered: {
                addPage.addPageClose();
            }
        }
        
        acceptAction: ActionItem {
            title: "Save"
            enabled: false
            onTriggered: {
                _taskApp.addNewRecord(titleField.text, descriptionField.text);
                addPage.addPageClose();
            }
        }
    }
    
    Container {
        id: editPane
        property real margins: 40
        background: Color.create("#f8f8f8")
        topPadding: editPane.margins
        leftPadding: editPane.margins
        rightPadding: editPane.margins
        
        layout: DockLayout {
        }
        
        Container {
            layout: StackLayout {}
            
            TextField {
                id: titleField
                topMargin: editPane.margins
                bottomMargin: topMargin
                hintText: "Title"
                
                onTextChanging: {
                    addPage.titleBar.acceptAction.enabled = text.length > 0;
                }
            }
            
            TextArea {
                id: descriptionField
                hintText: "Description"
                topMargin: editPane.margins
                bottomMargin: topMargin
                preferredHeight: 450
                maxHeight: 450
                horizontalAlignment: HorizontalAlignment.Fill
            }
        }
    }
    
    function newTask() {
        titleField.text = "";
        titleField.enabled = true;
        descriptionField.text = "";
        descriptionField.enabled = true;
        addPage.titleBar.acceptAction.enabled = false;
    }
}
