# Arch-Install

##### Disclaimer: This scripts are made for intel-nvidia laptops

## Drive Partition

First, we need to start with the system partition. Check the drive name with `lsblk`. After having the name of the drive you're going to install arch, please make the partitions with `cfdisk`

```bash
cfdisk /dev/nvme0n1 
```
> Drive partition name isn't required to be the exact same one as the example above

You'll need two partitions for this setup, having a third one is completely optional and up to the person who installs the os with these scripts.

```
REQUIRED - Partition 1: `/dev/nvme0n1p1` => EFI SYSTEM : 500 MiB
REQUIRED - Partition 2: `/dev/nvme0n1p2` => LINUX FILESYSTEM : ? GiB
OPTIONAL - Partition 3: `/dev/nvme0n1p3` => LINUX SWAP : ? GiB (4GiB is recommended)
```
If you're going to use swap, please uncomment the lines 43 and 44 of `arch-install-02`

## Script Execution

After creating the drive partitions, you'll need to modify the name of the user, so it suits your needs. To do such task, all you need is `sed`

```bash
sed -i 's/xyz/[your-user]/g' arch-install-02.sh
sed -i 's/xyz/[your-user]/g' *arch-install-04.sh
sed -i 's/xyz/[your-user]/g' *arch-install-05.sh
sed -i 's/xyz/[your-user]/g' arch-install-03-as-user.sh
sed -i 's/xyz/[your-user]/g' .zshrc
```
Replace xyz -> username

- cambio de v1.0
