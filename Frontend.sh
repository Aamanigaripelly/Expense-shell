source common.sh

echo -e "${color} Installing Nginx \e[0m"
dnf install nginx -y &>>$log_file
status_check

echo -e "${color} Copy Expense Config file \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
status_check

echo -e "${color} Clean Old Nginx Content \e[0m"
rm -rf /usr/share/nginx/html/* &>>$log_file
status_check

echo -e "${color} Download Frontend Application Code \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
status_check

echo -e "${color} Extract Downloaded Application Content \e[0m"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
status_check

echo -e "${color} Starting Nginx Service \e[0m"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
status_check