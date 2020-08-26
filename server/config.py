# server/config.py

import os

from flask import Flask

basedir = os.path.abspath(os.path.dirname(__file__))
app = Flask(__name__)

class BaseConfig(object):
    """Base configuration."""
    BASE_DIR = basedir
    TEMP_DIR = basedir+'/../temp'

