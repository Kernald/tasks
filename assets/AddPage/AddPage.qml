import bb.cascades 1.0

Page {
    id: addPage
    signal addPageClose()
    
    titleBar: TitleBar {
        id: addBar
        title: qsTr("Add")
        visibility: ChromeVisibility.Visible
        
        dismissAction: ActionItem {
            title: qsTr("Cancel")
            onTriggered: {
                addPage.addPageClose();
            }
        }
        
        acceptAction: ActionItem {
            title: qsTr("Save")
            enabled: false
            onTriggered: {
                _taskApp.addNewRecord(titleField.text, descriptionField.text);
                addPage.addPageClose();
            }
        }
    }
    
    Container {
        id: editPane
        background: backgroundPaint.imagePaint
        property real margins: 40
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
                hintText: qsTr("Title")
                
                onTextChanging: {
                    addPage.titleBar.acceptAction.enabled = text.length > 0;
                }
            }
            
            TextArea {
                id: descriptionField
                hintText: qsTr("Description")
                topMargin: editPane.margins
                bottomMargin: topMargin
                preferredHeight: 450
                maxHeight: 450
                horizontalAlignment: HorizontalAlignment.Fill
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
    
    function newTask() {
        titleField.text = "";
        titleField.enabled = true;
        descriptionField.text = "";
        descriptionField.enabled = true;
        addPage.titleBar.acceptAction.enabled = false;
    }
}
