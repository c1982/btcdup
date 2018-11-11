FROM golang:1.11.2-alpine as builder

RUN apk add --no-cache \
    git \
&&  go get -u github.com/Masterminds/glide

WORKDIR $GOPATH/src/github.com/btcsuite/btcd

RUN git clone https://github.com/btcsuite/btcd . \
&&  glide install \
&&  go install . ./cmd/...

FROM iron/base as final

LABEL author=Oğuzhan
LABEL email=aspsrc@gmail.com

ENV RPCUSER admin
ENV RCPPASS password
ENV WALLETACCOUNT dev

#for simnet development 
EXPOSE 18555 18556

COPY --from=builder /go/bin/addblock /root
COPY --from=builder /go/bin/btcctl /root
COPY --from=builder /go/bin/btcd /root
COPY --from=builder /go/bin/findcheckpoint /root
COPY --from=builder /go/bin/gencerts /root

RUN apk --no-cache add \
bash \
su-exec \
ca-certificates \
&& update-ca-certificates

RUN mkdir /root/.btcd
RUN mkdir /root/.btcwallet
RUN mkdir /root/.btcctl
ADD btcd-run.sh /root
RUN chmod +x /root/btcd-run.sh

WORKDIR /root
ENTRYPOINT ["/root/btcd-run.sh"]