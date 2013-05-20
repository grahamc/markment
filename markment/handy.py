# -*- coding: utf-8 -*-
# <markment - markdown-based documentation generator for python>
# Copyright (C) <2013>  Gabriel Falcão <gabriel@nacaolivre.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
from __future__ import unicode_literals

import re


def slugify(text):
    return re.sub(r'\W', '-', text.strip().lower())


def underlinefy(text):
    return slugify(text).replace('-', '_')


class nicepartial(object):
    def __init__(self, func, *args, **kw):
        self.func = func
        self.args = args
        self.kwargs = kw

    def __call__(self, *args, **kw):
        new = self.kwargs.copy()
        new.update(kw)
        return self.func(*(self.args + args), **new)

    def __repr__(self):
        return b'partial:{0}'.format(self.func.__name__)