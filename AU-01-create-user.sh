cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: podreader
rules:
  - apiGroups:
      - ""
    resources:
      - pods
    verbs:
      - "get"
      - "list"
      - "watch"
EOF


cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: cluster-podreader
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: podreader
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: podreader
EOF