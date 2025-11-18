#!/bin/python3

import math
import os
import random
import re
import sys


T = input()
T = int(T)
for i in range(T):
    S = input()
    N = len(S)
    even = "" 
    odd = ""
    for j in range(N):
        if ( j % 2 == 0):
            even = even + S[j]
        else:
            odd = odd + S[j]
        
    print (even, odd)
