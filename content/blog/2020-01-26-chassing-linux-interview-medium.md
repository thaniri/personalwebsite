---
date: 2020-01-26T00:00:00+00:00
title: Chassing Sysadmin Interview Questions (Medium)
description: Working through these questions. Any question I could not answer immediately has a citation.
tags:
  - linux
  - sysadmin
  - interview
weight: -210
---

# Linux System Administrator/DevOps Interview Questions

I worked through the easy questions [last year](https://thaniri.com/blog/2019-01-01/). Since then I've studied for the LPIC 1 and 2 so I'm going to work through some more difficult material.

## Medium Questions

The link to these questions can be found [here](https://github.com/chassing/linux-sysadmin-interview-questions#medium)


* **What do the following commands do and how would you use them?**

  * tee: receives input and redirects it to both the terminal and an output file.
  * awk: allows scanning of input (file or STDIN) for patterns. Useful for things like retrieving the nth column from a CSV file.
  * tr: used to delete certain characters from text 
  * cut: used to remove a column from a file
  * tac: prints a file but with the line numbers reversed
  * curl: sends an HTTP request over the command line
  * wget: fetches the result of on HTTP request over the command line
  * watch: used before a command to keep running said command repeatedly and print the output each time
  * head: looks at the first n rows of an input
  * tail: looks at the last n rows of an input
  * less: creates a buffer for an input which allows scrolling up and down the lines
  * cat: mostly used to print the content of a file to a terminal, actually was originally designed to concatenate files together
  * touch: used to create an empty file, can also be used to modify the access or modify time of a file
  * sar: used to see resource usage (CPU, memory, disk IO) of the server at a point in time
  * netstat: prints network information about the server, such as ports in use, network interfaces, routing tables
  * tcpdump: records all of the packets going over a network interface
  * lsof: checks for open file handles

<br/>

* **What does an `&` after a command do?**

& after a command is meant to run the command in the background. This way a long running command is not blocking. If the parent process dies, this background command will still die as well.

* **What does `& disown` after a command do?**

The difference between `command &` and `command & disown` is that disowning the process results in it no longer showing up in the list of jobs attached to a shell.

If a user runs `command &` then `jobs`, they will see that command is currently running on a certain PID. Then the user can run the `fg` command to bring this job into the foreground.

Following the same process, running `command & disown` results in the back-grounded process not showing up in the list of jobs.

However, in both cases the command will start a process which is still owned by the terminal that started it. So if the terminal is closed, the process will die in both cases.

Source: [1](https://unix.stackexchange.com/a/148698)

* **What is a packet filter and how does it work?**

A packet filter is something that inspects packet headers on a network interface. This can be implemented on a firewall, or on a Linux server directly.

The filter looks at the contents of each packet, and compares it to a list of rules for acceptable traffic. If the packet is considered acceptable, then it is allowed through the network interface.

* **What is Virtual Memory?**

Virtual memory in Linux is the ability to use a disk to extend Memory. There are a couple of ways to do this:

1. Create swap space
2. Create a swap file
3. Write a program which takes advantage of [memory mapped IO](https://en.wikipedia.org/wiki/Memory-mapped_I/O)

Source: [1](https://www.tldp.org/LDP/sag/html/vm-intro.html)

* **What is swap and what is it used for?**

Swap is a portion of the disk that the server uses as an extension to memory when the server is running out of memory.

A good reason to use swap is to prevent a server from crashing if it begins to run out of memory. Instead it will try to extend memory using dedicated space on the disk, and continue operations, albeit at a considerably slower pace.

* **What is an A record, an NS record, a PTR record, a CNAME record, an MX record?**

  * A Record: maps a hostname to an IP address
  * NS Record: a name server record which indicates which DNS server(s) are authoritative for a specific domain
  * PTR Record: maps an IP address in reverse to a hostname
  * CNAME Record: creates an "alias" name which maps typically to an A record, but can also be an alias of another alias.
  * MX Record: a mail record which represents a mail server

Source: [1](https://www.cloudflare.com/learning/dns/dns-records/dns-ns-record/)

* **Are there any other RRs and what are they used for?**

There are plenty of other DNS Resource Records:

  * SOA: Start of authority, includes information like who is the admin
  * AAAA: An A record for IPV6
  * SPF: Used to verify a mail server for security purposes
  * TXT: Literally human readable text
  * SRV: Maps the type of service on a given server to a port and hostname

* **What is a Split-Horizon DNS?**

Split Horizon DNS is the ability to return different results to DNS queries based on the IP address of the requester.

This is beneficial if you have a service (A) running on a public IP address within a corporate (firewalled) network, that must be accessed by another service (B) running on a private IP address within the corporate network. Instead of service B resolving service A to a public IP address and thus needing to go out of the firewall to route to it, is is possible using Split-Horizon DNS to get service B to get a different result which is the private IP address of service A.

Sources: [1](https://ns1.com/resources/split-horizon-or-multiview-dns), [2](https://security.stackexchange.com/questions/98088/how-important-is-split-horizon-dns)

* **What is the sticky bit?**

The sticky bit on a file is used to grant it additional properties in terms of permissions. In a typical file, there is octal notation to denote the permissions it has. A file can have permissions set to 755 for example. However, there is a fourth octal bit which is not often talked about, which is the sticky bit at the beginning. The file actually has permissions of 0755.

The sticky bit can be set by doing `chmod +t file.txt`. What this particular permission does is prevent anyone but the owner of the file from renaming or deleting this file.

* **What does the immutable bit do to a file?**

The immutable bit on a file is set by running `chmod +i file.txt`. It prevents the file from being modified, deleted, renamed, or linked to.

* **What is the difference between hard links and symlinks? What happens when you remove the source to a symlink/hardlink?**

  1. A symlink can cross file systems, but a hardlink cannot.
  2. A symlink has a different inode for the link, whereas the hardlink uses the same inode.
  3. If you delete the source file, the symlink becomes a "dead link" that points to nowhere. The hardlink will continue to point to the old file because it wasn't wiped from the hard drive, so the hard link can still be used to read the content of the old file.

* **What is an inode and what fields are stored in an inode?**

An inode contains metadata about a file but not the file itself.

It contains information such as:

  * The block at which a file is found
  * The permissions of that file
  * The number of the inode (there is a limit of inodes on a per-filesystem basis)

Source [1](https://linoxide.com/linux-command/linux-inode/#What_is_an_inode_in_Linux)

* **How to force/trigger a file system check on next reboot?**

You can force a file system check on reboot by running `tune2fs -c 1 /dev/device` which will change the maximum number of times a filesystem has been mounted before requiring a check.

* **What is SNMP and what is it used for?**

SNMP stands for Simple Network Management Protocol. It is mostly used for monitoring devices over the a network. So long as the correct MIBs are presented, it is possible to use an SNMP walk to collect metrics from given devices.

* **What is a runlevel and how to get the current runlevel?**

A runlevel is a description of what is running on a server at a particular runlevel.

There are 6 standard runlevels, but more can be added:

* 0 - Shutdown. The server will shut down at this runlevel.
* 1 - Single-user mode, no networking.
* 2 - Multi-user mode, no networking.
* 3 - Multi-user mode, with networking.
* 4 - Skipped.
* 5 - Multi-user mode, with networking and GUI.
* 6 - Reboot. The server will restart at this runlevel.

To get the current (and previous) runlevel, just run the `runlevel` command.

* **What is SSH port forwarding?**

SSH port forwarding is the running of a service over the SSH protocol. For example it is possible to serve a remote desktop over SSH if port forwarding is used.

This is also called SSH tunneling and is generally considered a security risk in most networks.

* **What is the difference between local and remote port forwarding?**

Local SSH port forwarding allows connecting from your local computer to a remote server. You set up a tunnel from localhost on port 1234 to remote host on port 4321. Then you can access the remote host on port 4321 by making a request against port 1234 locally.

Remote SSH port forwarding allows connecting from a remote to server to your local computer. Then, you can run a similar command to local port forwarding which allows accessing an application running on localhost port 1234 by making a request to the remote server on port 4321.

Source: [1](https://www.tecmint.com/create-ssh-tunneling-port-forwarding-in-linux/)

* **What are the steps to add a user to a system without using useradd/adduser?**

  1. Create an entry for the user in /etc/passwd
  2. Create an entry for the user in /etc/shadow
  3. Create an entry for the user in /etc/group
  4. Create a home directory and make sure it is owned by the correct user and group

* **What is MAJOR and MINOR numbers of special files?**

Special files, such as files which represent devices, have major and minor numbers which represent which drivers are responsible for that class of device, and what specific device is of that class, respectively.

Sources: [1](https://unix.stackexchange.com/a/124233), [2](https://www.oreilly.com/library/view/linux-device-drivers/0596000081/ch03s02.html)

* **Describe the `mknod` command and when you'd use it.**

From the man page, `mknod` is used to create block or character special files found in /dev.

These days this command is not used becaused `udev` automatically handlese the creation and removal of devices in /dev.

Sources: [1](https://unix.stackexchange.com/a/10725)

* **Describe a scenario when you get a "filesystem is full" error, but `df` shows there is free space.**

One possibility for this error is running out of inodes on a filesystem. This can happen when many tiny files are written to the filesystem that don't take up much space but do each take up an inode.

* **Describe a scenario when deleting a file, but `df` not showing the space being freed.**

If a process currently has a file open, and you delete the file, the space is still considered in use on the filesystem. Killing the process with the file open fixes this.

Source: [1](https://techosaurs.com/df-says-disk-is-full-but-it-is-not/)

* **Describe how 'ps' works.**

`ps` reads from /proc to know about all running processes and information about said processes.

* **What happens to a child process that dies and has no parent process to wait for it and what’s bad about this?**

When a child process dies and has no parent process waiting for it, it is considered a zombie process. Processes that stay zombies for a long time without being reaped are sign of resource leakage and will eventually cause the system to slow down.

It is possible to run out of PIDs which can be assigned if too many zombies have been made.

* **Explain briefly each one of the process states.**

  * R: the process is being run by the CPU or is ready to be run (runnable)
  * S: The process is waiting for an event, such as the output of another process, and can be interrupted
  * D: The process is waitting for an event, but cannot be killed or interrupted by a signal
  * T: The process has been suspended or stopped
  * Z: the process has sent an exit signal, but still has an entry in the process table

Source: [1](https://linuxjourney.com/lesson/process-states)

* **How to know which process listens on a specific port?**

The easiest way to find this out is to run `ss -tlpn | grep <port>`.

* **What is a zombie process and what could be the cause of it?**

A zombie process is a process started by a parent, which has completed running, but the parent process has failed to catch the exit call from the child.

The cause for a zombie process could be a poorly programmed piece of software, or by sending a `kill -9` to the parent process. Sending a `kill -9` signal kills the process, but does not clean up child processes.

* **You run a bash script and you want to see its output on your terminal and save it to a file at the same time. How could you do it?**

`./script.sh | tee output.txt`

* **Explain what echo "1" > /proc/sys/net/ipv4/ip_forward does.**

This will change the settings for ip forwarding at runtime. Since it is putting "1" into this file, we can assume that it is enabling ip forwarding. A better way to do this would be to find the equivalent kernel configuration and put it into `/etc/sysctl.conf`.

* **Describe briefly the steps you need to take in order to create and install a valid certificate for the site https://foo.example.com.**

I am going to assume this is running on a webserver such as NGINX or Apache.

1. Create a certificate signing request (CSR) for foo.example.com
2. Present the CSR to a valid certificate authority, and generate a new TLS certificate and private key
3. Put the newly issued certificate and private key onto the webserver hosting foo.example.com. Make sure you put the files into appropriate directories with appropriate file permissions.
4. Configure the webserver to use TLS and specify which certificate and key files to use.
5. Reload the webserver configuration.

* **Can you have several HTTPS virtual hosts sharing the same IP?**

It is absolutely possible to configure this. [Apache](https://httpd.apache.org/docs/2.4/vhosts/examples.html), [NGINX](https://www.nginx.com/resources/wiki/start/topics/examples/server_blocks/).

The only time this would be invalid is if the certificate itself was not valid for the different IP address. It is possible to get around this by adding in [Subject Alternative Names](https://www.digicert.com/subject-alternative-name.htm).

* **What is a wildcard certificate?**

A wildcard cert is something valid for any hostname under a subdomain.

An example wildcard certificate is `*.foo.example.com`

Valid hostnames for this certificate would include `abc.foo.example.com` or `bar.foo.example.com`

* **Which Linux file types do you know?**

In Linux technically everything is a file ;)

The standard file types are regular files, and directories.

Other file types include links and devices. We can get into more detail by looking at some articles [online](https://www.linux.com/tutorials/file-types-linuxunix-explained-detail/).

  * Regular file: a file that is readable, executable, an image, or an archive.
  * Directory: a file which contains other files for organizational purposes
  * Block file: a file which represents a device in /dev
  * Character file: a file which represents a stream of input or output
  * Pipe files: a file like a pipe `|` but which can be accessed as part of the file system. (Source)[http://man7.org/linux/man-pages/man7/fifo.7.html]
  * Symbolic links: it is a file which links to another file
  * Socket files: a file representing a socket which is listening for an application

* **What is the difference between a process and a thread? And parent and child processes after a fork system call?**

A process is the program being executed in memory. A thread is a separate instruction set being executed within a process.

`fork()` is the system call used to start another process. The process which called `fork()` is the parent. The child is different in that in can be killed or finish execution without the parent also being killed or finishing. However, if the parent is killed, then the child is supposed to be reaped as well. Child processes inherit most attributes from thee parent process.

Sources: [1](https://www.programmerinterview.com/operating-systems/thread-vs-process/), [2](https://www.tutorialspoint.com/process-vs-parent-process-vs-child-process)

* **What is the difference between exec and fork?**

The exec system call replaces the program that a process is running with an entirely different program. Exec is used when you want to launch a new program in the same process.

The fork system call is used to start a new process, that is running concurrently with the parent process which started it.

Sources: [1](https://linuxhint.com/linux-exec-system-call/), [2](https://www.geeksforgeeks.org/fork-system-call/)

* **What is "nohup" used for?**

`nohup` is a command line utility to start processes which cannot be interrupted.

A good case for using `nohup` is when executing a long running command in the background of a terminal, but not wanting this command to stop when the terminal is terminated. You can run `nohup verylongcommand &` to run a very long command in the background and then you can log out and the command will continue to run until completion.

If the command has output to STDOUT, it will send STDOUT to a file called nohup.out in the directory in which the command was executed. STDERR will be redirected to STDOUT and finally into nohup.out.

Source: [1](https://linux.101hacks.com/unix/nohup-command/)

* **What is the difference between these two commands? `myvar=hello` and `export myvar=hello`**

Both commands create a variable called myvar local to the shell in which they were created. The difference is that using `export` makes this variable available to child processes started by that shell.

* **How many NTP servers would you configure in your local ntp.conf?**

Having 3 or more servers is ideal as it allows for NTP on a client to smooth out the jitter between NTP servers. Most distributions default to a minimum of 4.

* **What does the column 'reach' mean in ntpq -p output?**

Reach is a base 10 number representing how many successful connections have been made to a particular NTP server.

Reach is actually tracked by 8 octal bits which are constantly left shifted. Each successful connection left shifts the reach number, and sets the rightmost bit to 1. Each failed connection does the same left shift, and sets the rightmost bit to 0.

The sum of the bit values is represented in decimal form, and is a quick overview of how many successful connections of the past 8 connections have been made to an NTP server.

Source: [1](https://www.linuxjournal.com/article/6812)

* **You need to upgrade kernel at 100-1000 servers, how you would do this?**

The easiest way to do this is by running an Ansible playbook with sudo to upgrade the kernel and providing the 1,000 servers as the inventory.

On a Debian based system this would be (simplified):

  1. `sudo apt update`
  2. `sudo apt dist-upgrade -y --force-confdef --force-confold`
  3. `sudo reboot`

This gets considerably more complex when factoring in servers that depend on other servers, or gracefully shutting down services, or doing particular subsets of servers in a particular manner to maintain quorum in a cluster.

* **How can you get Host, Channel, ID, LUN of SCSI disk?**

Assuming the SCSI disk is actually connected then all of this information can be found with `cat /proc/scsi/scsi`

Source: [1](https://www.thegeekdiary.com/how-to-identifymatch-lun-presented-from-san-with-underlying-os-disk/)

* **How can you limit process memory usage?**

A quick way to do this is to run `timeout -m 

* **What is bash quick substitution/caret replace(^x^y)?**

@!#$

* **Do you know of any alternative shells? If so, have you used any?**

I've heard of shells like zsh, ksh, fish. I haven't been convinced to try any.

* **What is a tarpipe (or, how would you go about copying everything, including hardlinks and special files, from one server to another)?**

I would use `rsync -avzH /source/dir remote.example.com:/destination/dir` to copy everything including hardlinks and special files from one server to another.

* **How can you tell if the httpd package was already installed?**

`httpd` is the name for the Apache webserver on Red Hat based systems.

So `yum list installed` is a good start.

* **How can you list the contents of a package?**

`dpkg -c filename.deb` will list the contents of the Debian package.

`rpm2cpio filename.rpm | cpio -idmv`

This will extract the contents of an RPM package. Since RPM packages are essentially CPIO archives the `rpm2cpio` utility will first convert the rpm file to a CPIO archive (via STDOUT) and then we pipe into `cpio` to actually unpack the archive.

* **How can you determine which package is better: openssh-server-5.3p1-118.1.el6_8.x86_64 or openssh-server-6.6p1-1.el6.x86_64 ?**

These packages are following the RPM naming convention.

The name of the package is `openssh-server`. The versions are `5.3p1-118.1.el6_8` and `6.6p1-1.el6`. The version differences are the actual version difference (5.3p1 vs 6.6p1), the OS version (RHEL 6.8 vs RHEL 6), They both use the `x86_64` OS architecture.

If we follow the principle of "newer is better" then the second option is "better".

Source: [1](https://access.redhat.com/discussions/1434473)

* **Can you explain to me the difference between block based, and object based storage?**

Block based storage is the most common type of storage. Data is written (mostly) sequentially to a disk in defined block sizes (such as 4Kb). The data has a minimal amount of metadata, such as which sector on the disk it starts, and where the next block of the contiguous piece of data is found.

Object based storage is a way of storing chunks of data in their entirety with more ability to label that storage with metadata. An object does not need to be a direct 1:1 mapping between files and objects. An object can contain many files, or even portions of files. Instead of organizing objects into a hierarchy, the data store is "flat" and each object is accessed using a globally unique identifier. The metadata is the key to differentiate between objects.

The benefit of object based storage is in the way data is written. An entire object needs to be written at once, and it is possible to rely on a distributed system with eventual consistency in order to ensure that the entire object is created or updated. This can make a write operation much more heavy than a block based storage system, however, getting rid of the need for transactions allows for distribution of the object to be much easier. This solves a fundamental scaling problem.

A great use case for needing to store enormous amounts of data where the access to that data is distributed in many geographic locations, is a CDN. In fact, this website is powered by block storage. It is static HTML content stored in an AWS S3 bucket, and served over AWS Cloudfront. You can see how I did it [here](https://thaniri.com/blog/2019-11-11-deploying-this-static-website/)

Sources: [1](https://www.druva.com/blog/object-storage-versus-block-storage-understanding-technology-differences/), [2](https://cloudian.com/blog/object-storage-vs-block-storage/), [3](https://cloudacademy.com/blog/object-storage-block-storage/)

## Reflection

This set of questions was considerably more difficult than the previous one. There were some things that I was not that bothered by not knowing. Things like knowing the RPM package naming convention or SCSI trivia. I also was not bothered by needing to search up certain trivia such as the sticky bit. Lots of information I know exists, but I don't memorize exactly every single detail about. Obviously because this exercise is as part of interview preparation I need to brush up on some things (like SOA DNS records) to be able to rattle off the information and look smart, but I know enough about DNS that an internet search will quickly fill in anything that I have momentarily forgotten or half remembered.

Despite that, this exercise has revealed a large gap in my Linux knowledge. My next study step will be to learn more about the internals of the Linux kernel and even spend time learning a low level programming language like C or Rust. The questions about system calls and process states specifically seemed to be pretty fundamental knowledge that I was missing. As a pretty successful [YAML engineer](https://yaml.engineering/), this is not the type of information I use in my day-to-day, but I have greater ambitions than to just keep using applications and generating YAML config files for them. I don't even like YAML.

The next step of my learning journey will include studying these materials:

1. [Linux Insides](https://github.com/0xAX/linux-insides/blob/master/SUMMARY.md)
2. [Linux Kernel Development](https://www.amazon.ca/Linux-Kernel-Development-Robert-Love/dp/0672329468)
3. [Procedural Programming in C](https://www.bcit.ca/study/courses/comp2511)

