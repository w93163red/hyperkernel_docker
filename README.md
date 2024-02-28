# HyperKernel Docker Verifier Environment

This is for building a docker environment for running hv6 verifier.

```
docker build -t hyperkernelenv .
docker run -it -v ${YOUR PATH TO hyperkernel}:/code hyperkernelenv:latest /bin/bash
cd /code
make hv6-verify
```

