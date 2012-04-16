from PyQt4.QtGui import *
from PyQt4.QtCore import *
from PyQt4.QtSvg import *
import sys
 
class DrawingArea(QGraphicsView):
 
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
        rect = QRectF(0, 0, 400, 400)
        self.fitInView(rect, Qt.KeepAspectRatio)
        self.setSceneRect(rect)

class View:

    def __init__(self):
        
        self.app = QApplication(sys.argv)

        self.window = QWidget()

        self.scene = QGraphicsScene()
        self.drawingArea = DrawingArea()
        self.drawingArea.setScene(self.scene)
        self.drawingArea.setFixedSize(400, 400)

        self.resetButton = QPushButton("Reset")
        self.computeButton = QPushButton("Compute")
        self.result = QLineEdit("Trololo")
        self.result.setReadOnly(1)
        self.quitButton = QPushButton("Quit")
    
        layout = QGridLayout()
        layout.addWidget(self.drawingArea, 0, 0, 4, 1)
        layout.addWidget(self.resetButton, 0, 1)
        layout.addWidget(self.computeButton, 1, 1)
        layout.addWidget(self.result, 2, 1)
        layout.addWidget(self.quitButton, 3, 1)
    
        self.window.setLayout(layout)

    def render(self):
        
        pixmap = QImage(400, 400, QImage.Format_ARGB32_Premultiplied)
        p = QPainter()
        p.begin(pixmap)
        self.scene.render(p)
        p.end()
        pixmap.save("../scene.png", "PNG")
