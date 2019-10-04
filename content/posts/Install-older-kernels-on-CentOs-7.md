---
title: "Install Old Linux Kernel on CentOS 7"
date: 2019-09-20T12:44:40+05:30
draft: false
description: "Simple guide to install different (preferably older) kernel version on CentOS 7."
tags:
    - linux
    - centos
categories:
    - how-to
keywords: "kernel, centos"
---

I wanted to test few old privilege escalation exploits like [DirtyC0w](https://dirtycow.ninja/) on a CentOS 7 VM, but I had trouble switching to older kernel versions since the repository didn't had the kernel version I wanted to install and most of the tutorials were about updating to *latest* kernel version.

After referring to various guides, this is the method that worked for me:

1. Visit [CentOS Wikipedia](https://en.wikipedia.org/wiki/CentOS#CentOS_version_7) and refer to which version has the kernel version you require.

2. Navigate to the selected CentOS version on [CentOS vault](http://vault.centos.org/). 
    For example I selected version `7.1.1503`.

3. Copy the link similar to this -> `http://vault.centos.org/7.1.1503/updates/x86_64/` and add this to the repository in your local machine.

    ```bash
    sudo yum-config-manager --add-repo=http://vault.centos.org/7.1.1503/updates/x86_64/ && \
    yum repolist all
    ```

    You can go to [Packages](http://vault.centos.org/7.1.1503/updates/x86_64/Packages/) and select the kernel version you want to install.

    ![Kernel version list](/images/posts/install-older-kernels-on-centos-7/kernel-list.png)

    I selected **kernel-3.10.0-229.1.2.el7.x86_64.rpm** and execute the following:

    ```bash
    sudo yum install -y kernel-3.10.0-229.1.2.el7.x86_64
    ```

    **Note:** Install package name must be **without** `.rpm` extention.

4. List all the installed kernels.

    ```bash
    awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
    ```

    ![Installed kernel list](/images/posts/install-older-kernels-on-centos-7/installed-kernel-list.png)

5. Select the default kernel to boot

    ```bash
    sudo grub2-set-default 3
    ```

    **NOTE:** Label list starts from **0**, so **to select 4th entry we set 3 as default**.

6. Update the setting we just made.

    ```bash
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    ```

7. Reboot the system and check the kernel version using `uname -r`

#### References

1. [unix.stackexchange.com/questions/444651/how-to-add-a-centos-repo-having-url-of-packages](https://unix.stackexchange.com/questions/444651/how-to-add-a-centos-repo-having-url-of-packages)

2. [www.thegeekdiary.com/centos-rhel-7-change-default-kernel-boot-with-old-kernel](https://www.thegeekdiary.com/centos-rhel-7-change-default-kernel-boot-with-old-kernel/)