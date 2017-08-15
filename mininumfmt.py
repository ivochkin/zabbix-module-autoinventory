#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Copyright (c) 2017 Stanislav Ivochkin <isn@extrn.org>
# License: MIT (see LICENSE for details)

from __future__ import print_function
import sys
import argparse

ALL_UNITS = ["auto", "si", "iec", "iec-i"]
SUPPORTED_UNITS = ["iec-i"]

IEC_I_MULTS = [
    (1024 ** 6, "Ei"),
    (1024 ** 5, "Pi"),
    (1024 ** 4, "Ti"),
    (1024 ** 3, "Gi"),
    (1024 ** 2, "Mi"),
    (1024, "Ki"),
]

parser = argparse.ArgumentParser()
parser.add_argument("--suffix", default="", metavar="SUFFIX")
parser.add_argument("--from-unit", type=int, default=1, metavar="N")
parser.add_argument("--to", required=True, metavar="UNIT", choices=SUPPORTED_UNITS)
args = parser.parse_args()

for line in sys.stdin:
    line = line.strip()
    value = float(line)
    value = value * args.from_unit
    if args.to == "iec-i":
        suffix = ""
        for mult, suff in IEC_I_MULTS:
            if 1 < value / mult and value / mult < 1000:
                value = value / mult
                suffix = suff
                break
        print("{0:.2f}".format(value) + suffix + args.suffix)
