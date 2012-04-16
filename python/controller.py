from PyQt4.QtCore import * 

import sys

class Controller:
    def __init__(self, view):
        self.view = view
        self.view.app.connect(self.view.resetButton,SIGNAL("clicked()"), self.reset)
        self.view.app.connect(self.view.computeButton,SIGNAL("clicked()"), self.compute)
        self.view.app.connect(self.view.quitButton,SIGNAL("clicked()"), self.quit)
    
    def reset(self):
        i=0
    
    def compute(self):
        self.view.render()

    def quit(self):
        sys.exit()
    
