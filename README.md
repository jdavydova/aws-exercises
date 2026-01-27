# aws-exercises

# AWS Comands

### How to configure and set credentials:

   aws configure

AWS Access Key ID [None]: AKIA3PGWxxxxxxCSR46MS
AWS Secret Access Key [None]: VLddj3Sxxxxxxa4q0s
Default region name [None]: eu-north-1  
Default output format [None]: json

    aws sts get-caller-identity

	aws configure list

	aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 788577008603.dkr.ecr.eu-north-1.amazonaws.com

### To create security group:

	aws ec2 create-security-group --group-name my-sg --description "Mt SG"	

	aws ec2 describe-vpcs

	aws ec2 create-security-group --group-name my-sg --description "Mt SG" --vpc-id vpc-054cf680083727d58

	aws ec2 describe-security-groups     

	aws aws ec2 describe-security-groups --group-ids sg-0cbf57155c8e870e6

	aws ec2 authorize-security-group-ingress \
		--group-id sg-0cbf57155c8e870e6 \
		--protocol tcp \
		--port 22 \  
		--cidr 79.131.39.46/32

### To Create Key pair

 	aws ec2 create-key-pair \                                                                            
		 --key-name MyKpCli \
		 --query 'KeyMaterial' \
		 --output text > MyKpCli.pem

### To create Instance:

	aws ec2 run-instances \
	--image-id ami-04233b5aecce09244 \
	--count 1 \
	--instance-type t3.micro \
	--key-name MyKpCli \
	--security-group-ids sg-0cbf57155c8e870e6 \
	--subnet-id subnet-0b3376ca8dee484f2

### To get information about instances :

	aws ec2 describe-instances

	chmod 400 ~/MyKpCli.pem 

	ssh -i MyKpCli.pem ec2-user@13.60.232.93

### To create IAM group:

	aws iam create-group --group-name MyGroupCli

### To create IAM user:

	aws iam create-user --user-name MyUserCli

### IAM user to group:

	aws iam add-user-to-group --user-name MyUserCli --group-name MyGroupCli

### To Get info about IAM group

	aws iam get-group --group-name MyGroupCli

### To attach policy:

	aws iam attach-group-policy --group-name MyGroupCli --policy-arn arn:aws:iam::awe:policy/AmazonEC2FullAccess

### To show attached group policy:

	aws iam list-attached-group-policies --group-name MyGroupCli

### To createLogin profile :

	aws iam create-login-profile --user-name MyUserCli --password MyPassword! --password-reset-required

### To show account ID:

	aws iam get-user --user-name MyUserCli 

### How to attach policy to Change Password for user

	aws iam attach-user-policy \
  	--user-name MyUserCli \
  	--policy-arn arn:aws:iam::aws:policy/IAMUserChangePassword



### How to create Acceess Key for a new user:

  aws iam create-access-key --user-name MyUserCli    

	{
    "AccessKey": {
        "UserName": "MyUserCli",
        "AccessKeyId": "AKIAxxxxxxxxxJ3OWP",
        "Status": "Active",
        "SecretAccessKey": "ka”ws ec2 ,
        "CreateDate": "2026-01-26T10:05:13+00:00"
    }
}


### How to Change AWS User for executing commands:

	export AWS_ACCESS_KEY_ID=xxxxxxxxxxOWP
	export AWS_SECRET_ACCESS_KEY=xxxxxxxxxpxBR

                                           
 
