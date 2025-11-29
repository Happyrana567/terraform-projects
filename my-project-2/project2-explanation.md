# 📌 Project 2 – Terraform + Custom VPC + Load Balancer + Auto Scaling + Userdata
🎯 Project Goal

Is project mein humne ek real production style architecture banaya hai jisme:

Custom VPC

2 Public Subnets (different AZs)

Internet Gateway

Route Table

Security Groups

Load Balancer

Target Group

Auto Scaling Group

Launch Template (userdata ke sath)

Sab free-tier friendly resources banaye gaye hain.

📘 Project Architecture (Diagram Style)
                     ┌───────────────────────────────┐
                     │        AWS Cloud               │
                     └───────────────────────────────┘
                                   │
                          ┌────────────────┐
                          │   VPC (10.0.0.0/16) 
                          └────────────────┘
                                   │
                ┌───────────────────────────────┐
                │        Public Subnet 1        │
                │      (10.0.1.0/24, us-east-1a)│
                └───────────────────────────────┘
                           │            │
                           │            └── EC2 (via ASG)
                           │
                ┌───────────────────────────────┐
                │        Public Subnet 2        │
                │      (10.0.2.0/24, us-east-1b)│
                └───────────────────────────────┘
                           │
                           └── EC2 (via ASG)

                  ┌──────────────────────────────┐
                  │      Application Load Balancer│
                  └──────────────────────────────┘
                                  │
                        ┌────────────────┐
                        │  Target Group  │
                        └────────────────┘
                                  │
                        ┌────────────────┐
                        │ Auto Scaling   │
                        │     Group      │
                        └────────────────┘


🧩 Why each Terraform component is needed?
1️⃣ VPC

Custom network banane ke liye

Better control milta hai IP ranges par

2️⃣ Public Subnets

EC2 ko internet se access mil sake

Load Balancer ko public rakhna hota hai

3️⃣ Internet Gateway

VPC ko internet connectivity deta hai

4️⃣ Route Table

Public subnet ka traffic → Internet Gateway

5️⃣ Security Groups

ALB SG: port 80 world ke liye open

EC2 SG: sirf ALB SG EC2 par traffic bhej sakta hai

6️⃣ Load Balancer

User incoming traffic ko EC2s me distribute karta hai

7️⃣ Target Group

ALB ko batata hai ki traffic kisko bhejna hai

8️⃣ Launch Template

EC2 ka blueprint

AMI, instance type, userdata sab yaha set hota hai

9️⃣ Auto Scaling Group

Load ke hisaab se EC2 increase/decrease

High availability ensure karta hai

📝 Project Folder Structure
my-project-2/
│── main.tf
│── variables.tf
│── provider.tf
│── locals.tf
│── userdata.tpl
└── outputs.tf

🚀 How to Deploy (Step-by-Step)
1️⃣ Go to terraform folder
cd ~/terraform

2️⃣ Initialize providers
terraform init

3️⃣ Show plan
terraform plan

4️⃣ Apply changes
terraform apply

5️⃣ ALB ka DNS copy karke browser me open karo

Traffic → ALB → EC2 instance → userdata HTML dikhega.

🧹 How to Destroy
terraform destroy

📤 GitHub Push Steps

(Your permanent rule: all git commands terraform folder me run karne hain)

cd ~/terraform
git add .
git commit -m "Added Project 2 complete architecture"
git push origin main

✅ README Completed

Yeh README simple, clear, Hinglish style me hai — bilkul aapki requirement ke hisaab se.

Aap bas batao:

👉 Kya main yeh README.md file ko abhi aapke project-2 folder me create kar du?

(You can paste it yourself or I can guide you to create and commit it.)

You said:
mere paas ek plan hai. readme.md ka naam nahi rakhunga wo terraform-projects ke andar already hai. mene project 1 ke andar project-explanation.md file banayi thi usme mene ye sab likha tha aur jo tumne readme.md ke liye content prepare kara hai wo bahot acha hai bas me ye chahta hu ki project2-explanation.md naam ki file banao usme ye sab paste karu ye jo content hai isme diagram bhi hai aur ye sab terminal pe paste nahi hoga to tum mujhe github website pe add karna batao nahi to agar ye add ho sakta hai terminal se bhi to uska bataoi
ChatGPT said:

Bilkul perfect plan hai!
Aap project2-explanation.md file banao — README ko touch nahi karenge.
Yeh professional bhi lagega aur projects clean rahenge.

Ab main 2 METHODS de raha hoon:

✅ METHOD 1: Terminal se file banana (Recommended, fastest)

Diagram wale ASCII boxes terminal me perfectly kaam karte hain, koi issue nahi hota.
Aap seedha file bana sakte ho → content paste kar sakte ho → commit & push.

👉 Step 1: File banao
cd ~/terraform/my-project-2
nano project2-explanation.md

👉 Step 2: Nano editor me pura content paste kar do

(jo README content maine diya tha).
ASCII diagram 100% sahi paste ho jayega.

👉 Step 3: Save & Exit

Press: CTRL + O

Press: ENTER

Press: CTRL + X

👉 Step 4: Git commit & push
cd ~/terraform
git add .
git commit -m "Added project 2 explanation with architecture"
git push origin main


Bas! File GitHub pe appear ho jayegi.

✅ METHOD 2: GitHub website se file banana

Agar aap terminal avoid karna chahte ho to GitHub se bhi easily ho jayega.

👉 Step-by-step:

GitHub open karo:
https://github.com/Happyrana567/terraform-projects

Folder my-project-2 me jao

Right top me "Add file" → "Create new file" click karo

File ka naam dal do:

project2-explanation.md


Neeche editor me pura content paste kar do (diagram bhi paste ho jayega)

Neeche jaakar commit message likho:

Added project 2 explanation file


Green button "Commit new file" press karo

Ho gaya! 🎉
