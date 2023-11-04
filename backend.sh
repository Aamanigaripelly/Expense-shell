log_file=/tmp/expense.log
color="\e[36m"

echo -e "${color} Disable NodeJS default Version \e[0m"
dnf module disable nodejs -y &>>$log_file
echo $?


echo -e "${color} Enable NodeJS 18 Version \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
echo $?


echo -e "${color} Install NodeJS \e[0m"
dnf install nodejs -y &>>$log_file
echo $?

echo -e "${color} Copy Backend Service File \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
echo $?

useradd expense

mkdir /app

echo -e "${color} delete old content \e[0m"
rm -rf /app/* &>>$log_file

curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
cd /app
unzip /tmp/backend.zip

cd /app


echo -e "${color} Download NodeJS Dependencies \e[0m"
npm install &>>$log_file
echo $?

echo -e "${color} Install MySQL Client to Load Schema \e[0m"
dnf install mysql -y &>>$log_file
echo $?

echo -e "${color} Load Schema \e[0m"
mysql -h  mysql-dev.vmoturidevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$log_file

echo -e "${color} Starting Backend Service \e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
echo $?



