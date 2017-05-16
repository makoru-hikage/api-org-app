# Installation

## Windows:

1. Install Strawberry Perl (It comes with CPAN)
2. Do `git clone https://github.com/makoru-hikage/api-org-app`
3. Assure that you have `Carton`, if you don't have, just do `cpan Carton`, it's your project package manager (like PHP's Composer)
4. Traverse to the `api-org-app` folder (which resulted from git clone) then do `carton install`
5. Once the installation finishes, run Plack by doing `plackup -p 3000` when you are in the `bin` folder. Everybody knows `bin`
6. ????
7. YEHEY!

## Linux:
1. Most linux distros have perl installed on them, if there is no perl, read the docs of your distro's package manager to install perl (if you are using Gentoo or LFS, then compile it yourself)
2. Again, download Carton by using cpan, if you dont have it...
3. ... AHHHHHHHHH to continue this list, see items 4-7 in Windows section.

ASSURE THAT YOU HAVE MYSQL AND IMPORT THE `Yoyotest.sql` INTO IT, THEN KEEP IT RUNNING.

Pssssssssst, the sample user is "cmoran" and her password is "eisley"
