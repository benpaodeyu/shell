#!/usr/bin/bash
# push rsa
#v1
user=root
pass=123456
>$PWD/ok.txt
>$PWD/fail.txt
rpm -q expect &>/dev/null
if [ $? -ne 0 ];then
	echo "installing...."
	yum -y install expect
fi

if [ ! -f ~/.ssh/id_rsa ];then
# -P 非交互方式生成，也可以使用-N ；  -f  生成秘钥的路径
	ssh-keygen -P "" -f ~/.ssh/id_rsa
fi

for i in {149..152}
do
{
ip=192.168.126.$i
ping -c 2 $ip &> /dev/null
if [ $? -eq 0 ];then
echo "$ip" >> $PWD/ok.txt
/usr/bin/expect <<-EOF
spawn ssh-copy-id $user@$ip
expect {
	"yes/no" { send "yes\r"; exp_continue }
	"password:" { send "$pass\r" }
}
expect eof
EOF
else
echo "$ip" >> $PWD/fail.txt
fi
} &
done
wait
echo "finish...."
