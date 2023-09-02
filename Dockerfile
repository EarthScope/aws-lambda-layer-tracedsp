# syntax=docker/dockerfile:1

# Fetch source, build using amazonlinux base
FROM public.ecr.aws/amazonlinux/amazonlinux:2023 AS builder

ARG GITREPO
ARG GITTAG
ARG BINARY

RUN dnf update
RUN dnf -y install clang git make

WORKDIR /build/
RUN git clone ${GITREPO} .

# Build version from expected tag
RUN make clean
RUN git checkout ${GITTAG}
RUN CFLAGS="-O2" CC="clang" make -j
RUN cp ${BINARY} /${BINARY}-${GITTAG}