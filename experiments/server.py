# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import json
import os.path
from pathlib import Path
from http.client import *


class Server:
    def __init__(self):
        rc = json.loads(Path(os.path.expanduser("~/.ebirdrc")).read_text())
        self.headers = {"x-ebirdapitoken": rc["apikey"]}
        self.conn = HTTPSConnection("api.ebird.org")

    def get(self, path, params=""):
        fullpath = "/v2/" + path + "?fmt=json" + params
        req = self.conn.request("GET", fullpath, headers=self.headers)
        response = self.conn.getresponse()
        if response.status != 200:
            raise RuntimeError(f"{response.status}: {response.reason}")
        return json.loads(response.read())
