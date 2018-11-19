# Add your SSH public key to all hosts of your cluster easily!

Adding a SSH key to all the hosts in the environment is tedious, this script makes it easy!


## Example DaemonSet manifest file:

Follow the two steps in the following yaml file and launch it using "kubectl"

`kubectl apply -f ssh.yaml`


### ssh.yaml

```
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: add-ssh-key
spec:
  selector:
    matchLabels:
      name: add-ssh-key
  template:
    metadata:
      labels:
        name: add-ssh-key
    spec:
      containers:
      - name: add-ssh-key
        image: leodotcloud/add-ssh-key
        imagePullPolicy: Always
        volumeMounts:
        - name: userhomedir
          mountPath: /tmp/user
        env:
          - name: SSH_KEY_TO_ADD
            value: "ssh-rsa blahblahblah username@rancher.com"    # Step 1: Replace the value with your SSH public key
      volumes:
      - name: userhomedir
        hostPath:
          path: /home/ubuntu    # Step 2: Replace this user home directory path accordingly
```
