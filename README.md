# sdalr
Package of R functions used at SDAL

# Installation

```r
devtools::install_github('bi-sdal/sdalr')
```
# Detailed Installation Instructions

### Arch Linux

```
pacaur -S gdal geos proj udunits
pacaur -S v8-3.14
pacaur -S v8-3.14-bin
```

### CentOS

```
yum install -y udunits2 udunits2-devel
yum install -y geos-devel v8-314-devel

wget http://download.osgeo.org/gdal/2.2.0/gdal220.zip && \
unzip gdal220.zip && \
cd gdal-2.2.0 && \
./configure && \
make && \
make install

wget http://download.osgeo.org/proj/proj-4.9.3.tar.gz && \
tar xvf proj-4.9.3.tar.gz && \
cd proj-4.9.3 && \
./configure && \
make && \
make install

# fix rgdal
echo "/usr/local/lib" >> /etc/ld.so.conf.d/R-dependencies-x86_64.conf && \
    ldconfig
```

### Random code snippets to get things working

build and reload

```shell
R CMD INSTALL --no-multiarch --with-keep.source -l ~/R/x86_64-pc-linux-gnu-library/3.3/ .

```

document

```r
devtools::document(roclets=c('rd', 'collate', 'namespace', 'vignette'))
```
