#!/bin/python3

import math
import os
import random
import re
import sys


n = int(input())

phoneBook = {}
for i in range(n):
    words = input().split()
    phoneBook[words[0]] = words[1]
    
while True:
    try:
        lu = input()
        if lu in phoneBook:
            print(lu + "=" + phoneBook[lu])
        else:
            print("Not found")
            
    except EOFError:
        break
