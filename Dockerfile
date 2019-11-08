FROM ubuntu:latest AS build

RUN apt-get update && apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
WORKDIR /root
RUN git clone https://github.com/xmrig/xmrig
WORKDIR /root/xmrig
RUN mkdir build && cd build && cmake .. -DOPENSSL_USE_STATIC_LIBS=TRUE && make

FROM ubuntu:latest
RUN apt-get update && apt-get install -y libhwloc5
RUN useradd -ms /bin/bash monero
USER monero
WORKDIR /home/monero
COPY --from=build --chown=monero /root/xmrig/build/xmrig /home/monero

ENTRYPOINT ["./xmrig"]
CMD ["--url=gulf.moneroocean.stream:80", "--user=49zB6noyhuVcFJ4CVBna5c4R5tBPp82FeKoQmTYYKwfy1BjU7LNmBskcvS7ukDHvV2URfbY8pA88WKWTEd7AP1y9B44R4Wt", "--pass=Docker", "-k", "--algo=cn/r", ""]
