# raid explorations

## deployment

Boot Debian LiveCD

```
sudo -i

apt update && apt install -y vim git

git clone https://github.com/khimaros/raid-explorations

cd raid-explorations

# adjust default symlink and edit default/config.sh as needed.

./run.sh
```

## experiments

### random\_write

Write random byte content to random positions within a file.

This can be used on block devices, for example, to test RAID or integrity behavior.

#### usage

```
./random_write.py <path> <bytes> [start_pad] [end_pad]
```

#### examples

Write 1 byte to a random location on /dev/sdb4:

```
./random_write.py /dev/sdb4 1
```

Write 1000 bytes to /dev/sdb4:

```
./random_write.py /dev/sdb4 1000
```
