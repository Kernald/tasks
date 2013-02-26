import bb.cascades 1.0

Container {
    layout: DockLayout {
    }
    Label {
        objectName: "count"
        horizontalAlignment: HorizontalAlignment.Left
        verticalAlignment: VerticalAlignment.Top
        //textStyle.color: Color.create("#ebebeb")
        textStyle.fontSize: FontSize.Small
    }
    
    Label {
        objectName: "randomTask"
        horizontalAlignment: HorizontalAlignment.Left
        verticalAlignment: VerticalAlignment.Center
        textStyle.fontSize: FontSize.Small
    }
}
