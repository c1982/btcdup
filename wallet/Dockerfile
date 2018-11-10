FROM golang:1.10-alpine as builder

RUN apk add --no-cache \
    git \
&&  go get -u github.com/Masterminds/glide

WORKDIR $GOPATH/src/github.com/btcsuite/btcwallet

RUN git clone clone https://github.com/btcsuite/btcwallet . \
&&  glide install \
&&  go install . ./cmd/...

FROM iron/base as final

LABEL author=oğuzhan
LABEL email=aspsrc@gmail.com

ENV RPCUSER admin
ENV RCPPASS password
ENV WALLET_ACCOUNT dev

EXPOSE 18554

COPY --from=builder /go/bin/btcwallet /bin/
COPY --from=builder /go/bin/gencerts /bin/

RUN apk --no-cache add \
bash \
su-exec \
ca-certificates \
&& update-ca-certificates

RUN mkdir /root/.btcwallet
RUN mkdir /root/.btcwallet
COPY wallet-run.sh /root
COPY btcwallet.conf /root/.btcwallet

WORKDIR /root
ENTRYPOINT ["/root/wallet-run.sh"]