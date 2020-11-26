#!/bin/bash

## Test the successful, automatic formation of a CaaS Platform cluster
## Includes testing a default storage class

. /home/sles/.bashrc

## This is hardcoded to the StorageClass. Adjust as needed
kubectl wait --for=condition=available --timeout=300s deployment/susecon-nfs-nfs-client-provisioner

echo "Verify all nodes are ready:" > /tmp/k8s.txt
kubectl get nodes -o wide >> /tmp/k8s.txt
echo "" >> /tmp/k8s.txt
echo "Verify kube-system and StorageClass pods are running:" >> /tmp/k8s.txt
kubectl get pods -A -o wide >> /tmp/k8s.txt
echo "" >> /tmp/k8s.txt
echo "Verify StorageClass is registered and is default:" >> /tmp/k8s.txt
kubectl get sc -o wide >> /tmp/k8s.txt

kubectl apply -f - << *EOF*
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
*EOF*

kubectl apply -f - <<*EOF*
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: alpine
    image: alpine
    command: ["sleep","3600"]
    volumeMounts:
    - mountPath: /mnt/test-vol
      name: test-vol
  volumes:
  - name: test-vol
    persistentVolumeClaim:
      claimName: test-pvc
*EOF*

kubectl wait --for=condition=Ready --timeout=300s pod/test-pod
echo "" >> /tmp/k8s.txt
echo "Verify that PVC is mounted in the test pod:" >> /tmp/k8s.txt
kubectl exec -it test-pod -- mount | grep test-vol >> /tmp/k8s.txt
sleep 10
kubectl delete pod test-pod
kubectl delete pvc test-pvc

