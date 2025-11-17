DR, MR, YR = input().split(" ")
DD, MD, YD = input().split(" ")

MR = int(MR)
DR = int(DR)
YR = int(YR)
MD = int(MD)
DD = int(DD)
YD = int(YD)


if YR < YD:
    print (0)
elif YR == YD and MR == MD and DR <= DD:
    print(0)
elif YR == YD and MR == MD and DR <= DD:
    print(0)
elif YR == YD and MR < MD:
    print(0)
elif YR == YD and MR == MD and DR > DD:
    print ((DR-DD)*15)
elif YR == YD and MR > MD:
    print ((MR-MD)*500)
else:
    print (10000)
