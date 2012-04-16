from view import *
from controller import *
from PyQt4.QtGui import *
from PyQt4.QtCore import *
import sys

view = View()
controller = Controller(view)

view.window.show()
sys.exit(view.app.exec_())

