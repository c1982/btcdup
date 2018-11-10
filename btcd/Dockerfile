FROM golang:1.10-alpine as builder

RUN apk add --no-cache \
    git \
&&  go get -u github.com/Masterminds/glide

WORKDIR $GOPATH/src/github.com/btcsuite/btcd

RUN git clone https://github.com/btcsuite/btcd . \
&&  glide install \
&&  go install . ./cmd/...

FROM iron/base as final

LABEL author=oğuzhan
LABEL email=aspsrc@gmail.com

ENV RPCUSER admin
ENV RCPPASS password
ENV WALLETACCOUNT dev

#for simnet development 
EXPOSE 18555 18556

COPY --from=builder /go/bin/addblock /bin/
COPY --from=builder /go/bin/btcctl /bin/
COPY --from=builder /go/bin/btcd /bin/
COPY --from=builder /go/bin/findcheckpoint /bin/
COPY --from=builder /go/bin/gencerts /bin/

RUN apk --no-cache add \
bash \
su-exec \
ca-certificates \
&& update-ca-certificates

RUN mkdir /root/.btcd
RUN mkdir /root/.btcctl
COPY btcd-run.sh /root
COPY btcd.conf /root/.btcd

WORKDIR /root
ENTRYPOINT ["/root/btcd-run.sh"]