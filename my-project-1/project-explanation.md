📘 Project 1 – What We Learned (Terraform + AWS EC2)
📝 Introduction

Is project me humne ground-level se lekar practical deployment tak Terraform ka complete workflow sikha. AWS me EC2 ko automate karke launch kiya, keys generate ki, Nginx install kiya, aur Git me correctly commit karna bhi seekha.

Ye project kisi bhi DevOps beginner ke liye ek perfect starting point hai.

🔍 What We Learned in Project 1
1️⃣ Terraform Basics
✅ Terraform ka role samjha

Ye “Infrastructure as Code (IaC)” tool hai

Hum cloud resources code likh kar manage kar sakte hain

Deployment repeatable, predictable, aur automated ho jata hai

✅ Important Terraform Commands
Command	Purpose
terraform init	Providers download karta hai
terraform validate	Code errors check karta hai
terraform plan	Batata hai kya create/modify hoga
terraform apply	Real AWS resources create karta hai
terraform destroy	Sab resources delete kar deta hai
2️⃣ Proper Terraform Project Structure

Humne ek clean folder structure banaya:

my-project-1/
└── main.tf
└── variables.tf
└── outputs.tf
└── keys/
└── script.sh

Har file ka kaam:

main.tf → AWS provider + EC2 + key pair + security group

variables.tf → region, instance-type jaise variables

outputs.tf → EC2 ka public IP output

keys/ → auto-generated SSH key pair

script.sh → EC2 me Nginx install karne ka script

3️⃣ Generating Key Pair Inside Terraform

Tumhari preference ke hisaab se humne har project me unique SSH key pair generate karna seekha:

Terraform ne automatically private key + public key banayi

AWS me same public key upload hui

EC2 instance usi key se SSH allow karta hai

Isse:
✔️ Duplicate keys ka problem khatam
✔️ Har project ka apna secure key pair hota hai

4️⃣ EC2 Instance Creation

Humne Terraform se automated tarike se:

Ubuntu EC2 instance launch kiya

Free-tier t2.micro use kiya

Security group me HTTP (port 80) open kiya

5️⃣ EC2 Provisioning Using Script

Humne user-data script se Nginx install karna sikha:

sudo apt update -y
sudo apt install -y nginx
echo "Hello from Terraform on Ubuntu!" > /var/www/html/index.html


Jab bhi EC2 create hota hai → Nginx ready ho jata hai.

6️⃣ Understanding the .terraform Folder

Humne sikha:

.terraform/ folder ke andar providers aur backend info hoti hai

Ye local folder hota hai, ise Git me push nahi karna chahiye

Isko .gitignore me add karna compulsory hai

7️⃣ Why the Large File Error Happened

Git me error aaya kyunki:

Humse galti se .terraform/ folder commit ho gaya

Is folder me provider plugin file 750MB thi

GitHub limit → 100MB

Fir humne:
✔️ .gitignore set kiya
✔️ Folder cached se remove kiya
✔️ Purani history ko clean kiya using filter-branch
✔️ Finally force push kiya

Aur repository clean ho gayi.

8️⃣ Git & GitHub Best Practices Learned

Never commit .terraform/

Commit only source code (tf files, scripts)

Clean history if large files get added accidentally

SSH key use karke secure push karna

9️⃣ Full Lifecycle: Create → Test → Destroy

Project 1 me humne complete workflow sikha:

Code likhna

Validate karna

Plan dekhna

Deploy (apply)

Browser me output test karna

End me destroy

Ye real DevOps lifecycle ka foundation hai.

🎯 Why This Project Was Important

✔️ AWS + Terraform basics clear huye
✔️ Real world jaisa project structure sikha
✔️ Keys, scripts, EC2 provisioning — sab practical
✔️ Git errors handle karna sikha (pro-level learning)
✔️ Tumhara confidence terraform me solid ho gaya
