# Local CA

## Key

```bash
openssl ecparam -name prime256v1 -genkey -out keys/local_ca.key
```

## Encrypted Key

```bash
openssl ec -in keys/local_ca.key -out keys/local_ca_encrypted.key -aes256
```
## Cert

```bash
openssl req -x509 -new -nodes -key keys/local_ca_encrypted.key -sha256 -days 3650 \
  -out crts/local_ca.crt \
  -subj "/CN=Finkelmann Root CA/O=Finkelmann/OU=Robin"
```

## PKCS12

```bash
openssl pkcs12 -export -out keys/local_ca.p12 -inkey keys/local_ca_encrypted.key -in crts/local_ca.crt
```
# Leaf Node

## Key

```bash
openssl ecparam -name prime256v1 -genkey -out keys/finkelmann.net.key
```

## Request

```bash
openssl req -new -key keys/finkelmann.net.key -out keys/finkelmann.net.csr \
  -subj "/CN=finkelmann.net/O=Finkelmann"
```

## SAN

```bash
cat << EOF > keys/finkelmann.net.san.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = finkelmann.net
DNS.2 = app.local
IP.1  = 127.0.0.1
EOF
```

## Cert

```bash
openssl x509 -req -in keys/finkelmann.net.csr \
  -CA crts/local_ca.crt -CAkey keys/local_ca_encrypted.key -CAserial keys/local_ca.srl \
  -out crts/finkelmann.net.crt -days 825 -sha256 -extfile keys/finkelmann.net.san.ext
```
