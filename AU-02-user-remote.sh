cat > podreader-csr.json <<EOF
{
  "CN": "podreader",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "podreader",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  podreader-csr.json | cfssljson -bare podreader

kubectl config set-credentials podreader \
  --client-certificate=podreader.pem \
  --client-key=podreader-key.pem

kubectl config set-context podreaderx \
  --cluster=kubernetes-the-hard-way \
  --user=podreader

kubectl config use-context podreaderx