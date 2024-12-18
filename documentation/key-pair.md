Create key pair:
```
 ssh-keygen -t rsa -b 4096 -f [key-name] -N "" -C "[email]" -m PEM
 ```
Import AWS key pair
```
aws ec2 import-key-pair --key-name [key-name] --public-key-material [key-name].pub --region eu-west-2
```
Copy key pair files to S3
```
aws s3 cp . S3://ds-[account]-kpf-adminstation/[target-folder]/ --exclude "*" --include "[key-name]*"
```
