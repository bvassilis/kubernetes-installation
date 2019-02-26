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



kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=podreader.kubeconfig

kubectl config set-credentials podreader \
  --client-certificate=podreader.pem \
  --client-key=podreader-key.pem \
  --embed-certs=true \
  --kubeconfig=podreader.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=podreader \
  --kubeconfig=podreader.kubeconfig

kubectl config use-context default --kubeconfig=podreader.kubeconfig



for instance in controller-0 controller-1 controller-2; do
  gcloud compute scp podreader.kubeconfig ${instance}:~/
done
