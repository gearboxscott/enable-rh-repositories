# enable-rh-repositories

This script will enable Red Hat Repositories that you have subscription for from Red Hat in Satellite 6.x.

This was tested with Satellite version 6.3.1

Usage Information:

```
$ ./enable-rh-repositories.sh 
Usage:
./enable-rh-repositories.sh [[-o or --org ] organization] [-l or --list] [-e or --enable] -f filename
 
-l or --list    : create listing to modify for enabling Red Hat Repositories.
-e or --enable  : enabling Red Hat Repositories.
-f or --file    : filename to output to modified and filename to read in to enable repos.
-h or --help    : help information.
-o or --org     : organization. 
```

This script will be call the first time to make a list of repositories to enable into a file.

```
$ ./enable-rh-repositories.sh -l -f repolist.txt
```

If you don't have `~/.hammer/cli_config.yml` you will be prompted for a password. 
If you don't have `~/.hammer/defaults.yml` with a default organization then add `-o` or `--org` to your command.

Once the script is run it will produce a file in the current directory.

Excerpt from a example file:

```
n,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server,x86_64,6.5,1999,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server
n,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server,i386,6.6,1999,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server
n,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server,x86_64,6.6,1999,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server
n,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server,i386,6.7,1999,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server
n,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server,x86_64,6.7,1999,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server
n,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server,i386,6.8,1999,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server
```

To enable repository a repository, change the letter `n` to a `y` for the repositories that are to be enabled.

```
n,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server,x86_64,6.5,1999,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server
n,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server,i386,6.6,1999,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server
y,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server,x86_64,6.6,1999,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server
n,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server,i386,6.7,1999,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server
y,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server,x86_64,6.7,1999,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server
n,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server,i386,6.8,1999,Red Hat Software Collections Source RPMs for Red Hat Enterprise Linux 6 Server
```


Save the file.

Re-run the script this time with a different flag:

```
$ ./enable-rh-repositories.sh -e -f repolist.txt
```

This will enable the repositories.  

After it's done, add the repositories to a sync plan and sync the content from Red Hat.


