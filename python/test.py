from PyQt4.QtGui import *
from PyQt4.QtCore import *
import sys
 
class MapView(QGraphicsView):
 
    def __init__(self, parent = None):
        QGraphicsView.__init__(self, parent)

 
    def mouseMoveEvent(self, event):
        mousePos = self.mapToScene(event.pos())

        pen = QPen()
        pen.setWidth(10)

        self.scene().addRect(mousePos.x(), mousePos.y(), 10, 10, pen)

    def resizeEvent(self, qResizeEvent):
        self.fitView()

    def showEvent(self, qShowEvent):
        self.fitView()

    def fitView(self):
        rect = QRectF(0, 0, 400, 300)
        self.fitInView(rect, Qt.KeepAspectRatio)
        self.setSceneRect(rect)


app = QApplication(sys.argv)

window = QWidget()

scene = QGraphicsScene()
mapview = MapView()
mapview.setScene(scene)
mapview.setFixedSize(400, 300)

resetButton = QPushButton("Reset")
computeButton = QPushButton("Compute")
result = QLineEdit("Trololo")
result.setReadOnly(1)

layout = QGridLayout()
layout.addWidget(mapview, 0, 0, 3, 1)
layout.addWidget(resetButton, 0, 1)
layout.addWidget(computeButton, 1, 1)
layout.addWidget(result, 2, 1)

window.setLayout(layout)

window.show()
sys.exit(app.exec_())
