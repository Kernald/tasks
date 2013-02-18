import bb.cascades 1.0

Page {
    titleBar: TitleBar {
        title: taskDetails.editMode ? qsTr("Edit") : qsTr("Details")
    }
    
    Container {
        id: taskDetails
        property bool editMode: false
        background: backgroundPaint.imagePaint
        property real margins: 40
        topPadding: taskDetails.margins
        leftPadding: taskDetails.margins
        rightPadding: taskDetails.margins
        
        layout: DockLayout {}
        
        Container {
            id: dataView
            layout: StackLayout {}
            
	        Label {
	            id: titleLabel
	            horizontalAlignment: HorizontalAlignment.Center
	            text: contentView.title
	            
	            textStyle {
	                base: SystemDefaults.TextStyles.BigText
	            }
	        }
	        
	        TextField {
	            id: titleField
 	            horizontalAlignment: HorizontalAlignment.Center
 	            text: contentView.title
 	            visible: taskDetails.editMode
 	            hintText: qsTr("Title")
                textStyle.textAlign: TextAlign.Center
                inputMode: TextFieldInputMode.Text
                onTextChanging: {
                    editControls.updateEnabled = editControls.updateEnabled || text != contentView.title;
                }
            }
	        
	        CheckBox {
	            id: doneCB
	            text: qsTr("Done")
	            checked: contentView.done == 1
	            enabled: taskDetails.editMode
	            onCheckedChanged: {
	                editControls.updateEnabled = editControls.updateEnabled || checked != (contentView.done == 1);
	            }
            }
	        
	        TextArea {
	            id: descriptionLabel
	            horizontalAlignment: HorizontalAlignment.Center
	            editable: taskDetails.editMode
	            text: contentView.description
	            hintText: qsTr("Description")
                onTextChanging: {
                    editControls.updateEnabled = editControls.updateEnabled || text != contentView.description;
                }
	        }
	    }
        
        EditControls {
            id: editControls
            visible: taskDetails.editMode
            
            onCancel: {
                titleField.text = contentView.title
                titleLabel.text = contentView.title;
                descriptionLabel.text = contentView.description;
                doneCB.checked = contentView.done == 1;
                taskDetails.editMode = false;
            }
            
            onUpdate: {
                _taskApp.updateSelectedRecord(titleField.text, descriptionLabel.text, doneCB.checked ? 1 : 0);
                titleLabel.text = titleField.text;
                taskDetails.editMode = false;
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
    
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            title: qsTr("Tasks")
            onTriggered: {
                nav.pop();
                taskDetails.editMode = false;
            }
        }
    }
    
    actions: [
        ActionItem {
            title: qsTr("Edit")
            imageSource: "asset:///images/Edit.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: {
                taskDetails.editMode = true;
                titleLabel.text = "";
            }
        },
        
        DeleteActionItem {
            objectName: "DeleteAction"
            title: qsTr("Delete")
            
            onTriggered: {
                _taskApp.deleteRecord();
                nav.pop();
                taskDetails.editMode = false;
            }
        }
    ]
}