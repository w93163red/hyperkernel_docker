# HyperKernel Docker Verifier Environment

This is for building a docker environment for running hv6 verifier.

for hyperkernel repo: https://github.com/w93163red/hyperkernel
I made some simple changes on it. At Ubuntu 22, `python` is not an executable at default.
So need to manually change to those python scripts to point to `python2`

```
docker build -t hyperkernelenv .
docker run -it -v ${YOUR PATH TO hyperkernel}:/code hyperkernelenv:latest /bin/bash
cd /code
# to compile the hv6
USE_CLANG=1 make
# to run the verify
USE_CLANG=1 CXX=clang++ make hv6-verify
```

