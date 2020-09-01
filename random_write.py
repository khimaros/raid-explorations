#!/usr/bin/python3

import os
import random
import sys

# parse command line arguments
of = sys.argv[1]
count = int(sys.argv[2])
start_pad = 20 * 1024 * 1024
if len(sys.argv) > 3:
    start_pad = int(sys.argv[3])
end_pad = 16 * 1024 * 1024
if len(sys.argv) > 4:
    end_pad = int(sys.argv[4])

# determine the size of the drive in bytes
fd = os.open(of, os.O_RDONLY)
end = os.lseek(fd, 0, os.SEEK_END)
os.close(fd)

changes = 0
while changes < count:
    seek = random.randint(start_pad, end - end_pad)

    with open(of, 'rb') as f:
        f.seek(seek)
        cur = f.read(1)

    with open(of, 'wb') as f:
        f.seek(seek)
        new = bytes([random.randint(0, 255)])
        if not cur[0] or cur == new:
            continue

        changes += 1
        print('[*] changing 0x%x to 0x%x on %s at byte %d (%d / %d)' % (cur[0], new[0], of, seek, changes, count))
        f.write(new)
