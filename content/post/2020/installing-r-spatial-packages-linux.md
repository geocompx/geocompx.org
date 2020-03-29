Installing spatial R packages on Linux
================
Robin Lovelace
2020-03-30

This post explains how to quickly get key R packages for geographic
research installed on Linux machines.

<!-- ![](/home/robin/geocompr/geocompr.github.io/static/img/geocompr-linux.png) -->

A recent thread on the [r-spatial GitHub
organization](https://github.com/r-spatial/discuss/issues/35) alludes to
many considerations when choosing a Linux set-up for geocomputational
work, ranging from whether to get close to the bleeding edge to the
choice of Linux distribution (distro) and whether to use binary or
compiled versions of packages and upstream libraries (binaries are
faster to install). This post touches on some of these things but, its
main purpose is to **provide advice on getting R’s key spatial packages
up-and-running on a future-proof Linux operating system** (Ubuntu).\[1\]

Now is an excellent time to be thinking about the topic because changes
are in the pipeline and getting set-up (or preparing to get set-up) now
could save hours in the future. These imminent changes include:

  - The next major release of R
    ([4.0.0](https://stat.ethz.ch/R-manual/R-devel/doc/html/NEWS.html)),
    scheduled for the 24<sup>th</sup> April
    ([2020-04-24](https://developer.r-project.org/))
  - The next major release of Ubuntu
    ([20.04](https://www.omgubuntu.co.uk/2019/10/ubuntu-20-04-release-features)),
    a Long Term Support ([LTS](https://wiki.ubuntu.com/LTS)) version
    that will be used by millions of servers and research computers
    worldwide for years to come. Coincidentally, Ubuntu 20.04 will be
    released a day earlier than R 4.0.0, on 23<sup>rd</sup> April
    ([2020-04-23](https://itsfoss.com/ubuntu-20-04-release-features/)).
  - Ongoing changes to the OSGeo stack on which key geographic R
    packages, leading to a huge amount of heroic
    [r-spatial](https://github.com/r-spatial/) development activity to
    support the new features, including more precise [coordinate
    reference system
    definitions](https://www.r-spatial.org/r/2020/03/17/wkt.html).

There many ways of getting Linux OSs set-up for installing and using
spatial R packages and a benefit of Linux operating systems is that they
offer choice and prevent ‘lock-in’. However, the guidance in the next
section should reduce set-up time and improve maintainability (with
updates managed by Ubuntu) compared with other ways of doing things,
especially for beginners and people planning to switch to Linux as the
basis of their geographic work.

By ‘key packages’ I mean the following, which are the basis of much of
[Geocomputation with R](https://geocompr.robinlovelace.net/). These
three packages provide huge power and flexibility, enabling you to do
perhaps 80% of day-to-day geographic data processing and visualization
tasks:

  - [**sf**](https://github.com/r-spatial/sf#installing) for reading,
    writing and working with a range geographic vector file formats and
    geometry types
  - [**raster**](https://github.com/rspatial/raster/), a mature package
    for working with geographic raster data (see the
    [**terra**](https://github.com/rspatial/terra/) for an
    in-development replacement for **raster**)
  - [**tmap**](https://github.com/mtennekes/tmap), a flexible package
    for making static and interactive maps

The focus is on Ubuntu because that’s what I’ve got most experience with
and it is well supported by the community. Links for installing
geographic R packages on other distros are provided in a subsequent.

The pre-requisite for this next section is a computer with a recent
Ubuntu or Ubuntu-based (such as Mint) operating system. You can buy a
computer with Ubuntu and other Linux distros installed from [hardware
company that supports open-source
software](https://itsfoss.com/get-linux-laptops/) such as
[System 76](https://system76.com/) or
[Entroware](https://www.entroware.com/) (that supplied to computer on
which this post was written, shown below). The lower cost and more
environmentally friendly option is to install Ubuntu to give a new lease
of life to a pre-existing computer by following this [online
guide](https://ubuntu.com/tutorials/tutorial-install-ubuntu-desktop#1-overview).

![](https://www.entroware.com/store/image/cache/catalog/entroware/products/laptops/el07r3/proteus-el07r3-front-left-open-1000x800.jpg)

# 1\. Installing spatial R packages on Ubuntu

<!-- Of course, it depends on what Linux distribution you're running, and we'll cover installation on some of the most popular [distros](https://distrowatch.com/). -->

<!-- ## Ubuntu -->

R’s spatial packages can be installed from source on the latest version
of this popular operating system, once the appropriate repository has
been set-up, meaning faster install times (only a few minutes including
the installation of upstream dependencies). The following bash commands
should install key geographic R packages on Ubuntu 19.10:

``` bash
# add a repository that ships the latest version of R:
sudo add-apt-repository ppa:marutter/rrutter3.5
# update the repositories so the software can be found:
sudo apt update
# install system dependencies and binary versions of key R packages:
sudo apt install libudunits2-dev libgdal-dev libgeos-dev libproj-dev 
sudo apt install r-base-dev r-cran-sf r-cran-raster r-cran-rjava
```

If you are using an older version of Ubuntu and don’t want to upgrade to
19.10, which will upgrade to (20.04) by the end of April 2020, see
instructions at
[github.com/r-spatial/sf](https://github.com/r-spatial/sf#installing)
and detailed instructions on the blog
[rtask.thinkr.fr](https://rtask.thinkr.fr/blog/installation-of-r-3-5-on-ubuntu-18-04-lts-and-tips-for-spatial-packages/),
which contains this additional shell command:

``` bash
# will work on Ubuntu 18.04 and (from May 2020) Ubuntu 20.04
sudo add-apt-repository ppa:marutter/c2d4u3.5
```

That adds a repository that ships hundreds of binary versions of R
packages, meaning faster install times for packages that contain lots
for C/C++ code that needs to be compiled. The c2d4u3.5 repository only
supports LTS Ubuntu versions, meaning it is unavailable for Ubuntu
19.10, but will be available for Ubuntu 20.04, allowing hundreds of
packages to be installed quickly from the system terminal. The following
command, for example, will install **tmap** on LTS versions of Ubuntu
that have the `c2d4u3.5` repository enabled much faster than the
alternative `install.packages()` approach.

    sudo apt install r-cran-tmap

To test your installation of R has worked, try running R in an IDE such
as RStudio or in the terminal by entering `R`. You should be able to run
the following commands without problem:

``` r
library(sf)
#> Linking to GEOS 3.7.2, GDAL 2.4.2, PROJ 5.2.0
install.packages("tmap")
```

<!-- ## Fedora -->

<!-- The following command should install all the dependencies required: -->

<!-- ``` -->

<!-- sudo dnf install gdal-devel proj-devel proj-epsg proj-nad geos-devel udunits2-devel -->

<!-- ``` -->

<!-- ## Arch -->

<!-- ## Other Linux distros -->

<!-- # 3. Which operating system to use? -->

# 2\. Why Linux?

Linux operating systems are free and open-source, like R itself, and
provide a number of
[advantages](https://itsfoss.com/linux-better-than-windows/) over
Windows, including:

  - Continuous upgrades: while Microsoft pushes
    [updates](https://www.catalog.update.microsoft.com/Search.aspx?q=windows%20security%20update%202020)
    every month or so, updates on Linux distributions tend to be more
    regular, ensuring you can access more up-to-date, secure, stable and
    performant software sooner
  - Ideal for learning to program: while Windows (and to some extent
    Mac) tries to reduce the need for computing skills such, Linux
    encourages you to learn to program via access to a powerful
    command-line interface (which will use below)
  - Freedom: Most Linux distributions are free to download, modify and
    pass-on, so you can install up-to-date operating systems on all your
    computers without worrying about licensing issues

Like R, you cannot learn to use Linux overnight but distributions
designed with user-friendliness in mind, such as Ubuntu and Mint, mean
that Linux is now something you can recommend to your
[grandmother](https://www.computerworld.com/article/2468094/linux-for-grandma---grandpa.html).

There is also a strong community around Linux and open source more
generally, and a culture of asking questions and swift answers. If you
have issues installing geographic R packages on Linux following
instructions as documented here, you can find a wealth of answers on
site such as [StackOverflow](https://stackoverflow.com/), the [sf issue
tracker](https://github.com/r-spatial/sf/issues),
[r-sig-geo](https://stat.ethz.ch/pipermail/r-sig-geo/) and
[Debian](https://stat.ethz.ch/pipermail/r-sig-debian/2020-March/thread.html)
special interest group (SIG) email lists (the latter of which provided
input into this blog post, thanks to Dirk Eddelbuettel and Michael
Rutter) and even the geocompr issue tracker, where you’re free to ask
relevant questions.

# 3\. Installing geographic R packages on other Linux operating systems

If you are in the fortunate position of switching to Linux and being
able to choose the distribution that best fits your needs, it’s worth
thinking about which distribution will be both user-friendly (more on
that soon), performant and future-proof. Ubuntu is a solid choice, with
a large user community and repositories such as ‘ubuntugis’ providing
more up-to-date versions of upstream geographic libraries such as GDAL.

QGIS is also well-supported on Ubuntu.

However, you can install R and key geographic packages on other
operating systems, although it may take longer. Useful links on
installing R and geographic libraries are provided below for reference:

  - Installing R on **Debian** is covered on the [CRAN
    website](https://cran.r-project.org/bin/linux/debian/). Upstream
    dependencies such as GDAL can be installed on recent versions of
    Debian, such as [buster](https://www.debian.org/releases/), with
    commands such as `apt-get install libgdal-dev` as per instructions
    on the
    [rocker/geospatial](https://github.com/rocker-org/geospatial/blob/eaf5e92f90737ce9771753cab48f3a2f1d779216/Dockerfile).

  - Installing R on **Fedora/Red Hat** is straightforward, as outlined
    on [CRAN](https://cran.r-project.org/bin/linux/redhat/README). GDAL
    and other spatial libraries can be installed from Fedora’s `dnf`
    package manager, e.g. as documented
    [here](https://github.com/r-spatial/sf#fedora) for **sf**.

  - **Arch Linux** has a growing R community. Information on installing
    and setting-up R can be found on the [ArchLinux
    wiki](https://wiki.archlinux.org/index.php/R). Installing upstream
    dependencies such as [GDAL on
    Arch](https://www.archlinux.org/packages/community/x86_64/gdal/) is
    also relatively straightforward. There is also a detailed guide for
    installing R plus geographic packages by [Patrick
    Schratz](https://pat-s.me/post/arch-install-guide-for-r/).

# 4\. How close to the bleeding edge should you get?

One of the greatest things about the freedom provided by using Linux is
also one of the scariest: you can go as deep into the operating system
and as close to the ‘cutting edge’ of computing as you want, with few
restrictions. This can be exciting but it can also be wasteful if you
end up spending hours fiddling with your set-up.

It’s worth considering the stability-bleeding continuum before diving
into a particular set-up if the previous section hasn’t already made-up
your mind. Even if you have decided on a particular OS there are many
options that can take you closer to the bleeding edge that you may or
may not want to take.

For me, that means the latest version of Ubuntu plus CRAN versions of
most R packages. For most people I recommend installing the release
version as follows:

``` r
install.packages("tmap")
```

It is good practice to keep your packages up-to-date. To do so you run
the following command regularly:

``` r
update.packages()
```

If you want to test development versions of various packages, you can
always do so from inside R with commands such as the following (which
installs the development versions of **tmap** and **tmaptools**):

``` r
remotes::install_github("mtennekes/tmap")
remotes::install_github("mtennekes/tmaptools")
```

You can get more recent versions on OSGeo packages on Ubuntu by adding
the `ubuntugis` repository as follows:

    sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
    sudo apt-get update

# 5\. Geographic R packages on Docker

As with cars, ease of use is important for the popularity of computer
technology.\[2\] The Ubuntu installation instructions outlined above
provide such an easy and future-proof set-up. But if you want an even
easier way to get the power of key geographic packages running on Linux,
and have plenty of RAM and HD space, running R on the ‘[Docker
Engine](https://docs.docker.com/install/)’ may be an attractive option.

Advantages of using Docker include **reproducibility** (code will always
run the same on any given image, and images can be saved),
**portability** (Docker can run on Linux, Windows and Mac) and
**scalability** (Docker provides a platform for scaling-up computations
across multiple nodes).

For an introduction to using R/RStudio in Docker, see the [Rocker
project](https://www.rocker-project.org/).

Using that approach, I recommend the following Docker images for using R
as a basis for geographic research:

  - [`rocker/geospatial`](https://hub.docker.com/r/rocker/geospatial)
    which contains key geographic packages, including those listed above
  - [`robinlovelace/geocompr`](https://hub.docker.com/r/robinlovelace/geocompr/)
    which contains all the packages needed to reproduce the contents of
    the [book](https://geocompr.robinlovelace.net/), and which you can
    run with the following command in a shell in which Docker is
    installed:

<!-- end list -->

``` bash
docker run -e PASSWORD=yourpassword --rm -p 8787:8787 robinlovelace/geocompr
```

To test-out the Ubuntu 19.10 set-up recommended above I created a
[Dockerfile](https://github.com/Robinlovelace/geocompr/blob/master/docker/ubuntu-eoan/Dockerfile)
and associated image on Dockerhub that you can test-out as follows:

``` bash
docker run -it robinlovelace/geocompr:ubuntu-eoan
R
library(sf)
#> Linking to GEOS 3.7.2, GDAL 2.4.2, PROJ 5.2.0
library(raster)
library(tmap) 
```

The previous commands should take you to a terminal inside the docker
container where you try out the Linux command line and R.

# 6\. Fin

In summary, R is an open-source language heavily inspired by Unix/Linux
so it should come as no surprise that it runs well on a variety of Linux
distributions, Ubuntu (covered in this post) in particular. Building on
[OSGeo](https://www.osgeo.org/) libraries, key geographic R packages are
also easy to set-up, run and develop on Linux. I hope that this tutorial
provides some useful pointers and encourages more people to switch from
proprietary software to open source solutions as the basis of their
geographic and computational work.

![](https://www.osgeo.org/wp-content/themes/roots/assets/img/logo-osgeo.svg)

Be the [FOSS4G](https://wiki.osgeo.org/wiki/FOSS4G) change you want to
see in the world\!

1.   I plan to keep this post updated with new developments such as the
    release of Ubuntu 20.04 (due to be released
    [2020-04-23](https://itsfoss.com/ubuntu-20-04-release-features/))
    and R 4.0.0 (due to be released the day after, on
    [2020-04-24](https://developer.r-project.org/)).

2.   The history of cars can provide insight into the importance of ease
    of use of technologies today. Cars, have arguably transformed our
    settlements and lifestyles more than any other technology, were
    initially hard to use. Before they became a consumer product in the
    1950s (by the end of which 1/6<sup>th</sup> of jobs in the USA were
    in the [car
    industry](https://en.wikipedia.org/wiki/1950s_American_automobile_culture))
    relied on a [hand
    cranks](https://www.youtube.com/watch?v=iFd8uo7ogpM) to start them
    until the proliferation of electric starter motors following U.S.
    Patent [1,150,523](https://patents.google.com/patent/US1150523),
    which was subsequently used by Cadillac in
    [1912](https://www.hemmings.com/blog/2012/02/27/the-accident-that-started-it-all/)
    and onwards. Like cars, people tend to go for computer technologies
    that are easy to use, that are ‘plug and play’, so it’s important
    for the future of open-source software that the solutions I
    recommend are easy to set-up and use.
