from view import *
from PyQt4.QtGui import *
from PyQt4.QtCore import *
import sys

view = View()
view.window.show()
sys.exit(view.app.exec_())

