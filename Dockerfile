FROM hashicorp/vault-enterprise:latest
COPY vault.hclic /
RUN apk add git go
RUN git clone https://github.com/LeSuisse/vault-gpg-plugin
RUN cd vault-gpg-plugin&&mkdir plugin&&go build -o plugin/gpg-plugin main.go
