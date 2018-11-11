FROM golang:1.11.2-alpine as builder

RUN apk add --no-cache \
    git \
&&  go get -u github.com/Masterminds/glide

WORKDIR $GOPATH/src/github.com/btcsuite/btcd

RUN git clone https://github.com/btcsuite/btcd . \
&&  glide install \
&&  go install . ./cmd/...

WORKDIR $GOPATH/src/github.com/btcsuite/btcwallet

RUN git clone https://github.com/btcsuite/btcwallet . \
&&  glide install \
&&  go install . ./cmd/...

FROM iron/base as final

LABEL author=Oğuzhan
LABEL email=aspsrc@gmail.com

ENV RPCUSER admin
ENV RCPPASS password

EXPOSE 18554

COPY --from=builder /go/bin/btcwallet /bin/
COPY --from=builder /go/bin/gencerts /bin/

RUN apk --no-cache add \
bash \
su-exec \
ca-certificates \
&& update-ca-certificates

RUN mkdir /root/.btcwallet
ADD wallet-run.sh /root
RUN chmod +x /root/wallet-run.sh

WORKDIR /root
ENTRYPOINT ["/root/wallet-run.sh"]