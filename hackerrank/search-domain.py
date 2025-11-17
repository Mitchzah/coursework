#!/bin/python3

import math
import os
import random
import re
import sys



if __name__ == '__main__':
    N = int(input().strip())

    list = []

    for N_itr in range(N):
        first_multiple_input = input().rstrip().split()

        firstName = first_multiple_input[0]

        emailID = first_multiple_input[1]
        
        emailSplit = emailID.split("@")
        
        if emailSplit[1] == "gmail.com":
            list.append(firstName)
            
    for name in sorted(list):
        print (name)
            
