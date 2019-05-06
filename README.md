- disable password during login:

```
$ nano /etc/passwd
```

replace the `root:x:0:0:root:/root:/bin/bash` with `root::0:0:root:/root:/bin/bash`

- edit start applications

```
$ gnome-session-properties

```
