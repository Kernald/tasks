import bb.cascades 1.0

Container {
    id: editControls
    property bool updateEnabled: false
    signal update()
    signal cancel()
    bottomPadding: 40
    
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    
    Button {
        text: qsTr("Cancel")
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        
        onClicked: {
            updateEnabled = false;
            editControls.cancel();
        }
    }
    
    Container {
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
    }
    
    Button {
        id: updateButton
        text: qsTr("Update")
        enabled: updateEnabled
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        
        onClicked: {
            editControls.update();
        }
    }
}