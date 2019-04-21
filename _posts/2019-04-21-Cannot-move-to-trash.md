---
layout: post
title: Cannot move to trash nfs mount error
excerpt_separator: <!--more-->
---

I had a NTFS hard disk mounted using `/etc/fstab` on `/mnt/data`. Whenever I delete a file it won't go into the **Trash**, instead it asks me to delete the file permanently. I had to find a way to enable the trash for this mount.

![Move to trash]({{ site.url }}/img/moveTrash/moveToTrash.png)

<!--more-->

It seems like we had trouble with some permissions related to trash.
The following was my `/etc/fstab` entry.
```bash
UUID=EA10ABB810AB8A61 /mnt/data ntfs-3g defaults       0 0
```

**Solution:**
Find what is the user id.
```bash
id
```
My user id is: 1000. So, I change my `/etc/fstab` entry to
```bash
UUID=EA10ABB810AB8A61 /mnt/data ntfs-3g defaults,uid=1000       0 0
```

Soon I will be writing a post on How linux trash works for better understanding of this problem.