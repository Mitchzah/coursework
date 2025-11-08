#!/bin/python3

import math
import os
import random
import re
import sys



if __name__ == '__main__':
    n = int(input().strip())

b = str(format(n,'b'))
count = 0
result = 0

for i in range(len(b)):
    if (b[i] == "0"):
        count = 0
    else:
        count += 1
        result = max(count,result)
            
print(result)
