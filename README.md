# [TeleDiamond](http://telegram.me/telediamondch)

# برای نصب کد زیر را در ترمینال وارد کنید
```
git clone http://github.com/Mohammadrezar/darkdiamond.git && cd darkdiamond && chmod +x launch.sh && ./launch.sh install && ./launch.sh
```
# سپ درس شماره خود را با کد کشور مورد نظر وارد کنید
# سپس خود را سودو کرده و اتولان چ یا لانچر را فعال کنید

# آموزش فعال سازی اتولانچ<<
# کدهای زیر را بترتیب وارد کنید
```
sed -i "s/root/$(whoami)/g" etc/pika.conf; sed -i "s_telegrambotpath_$(pwd)_g" etc/pika.conf && sudo cp etc/pika.conf /etc/init/ && chmod 777 pika && nohup ./pika &>/dev/null &
```
```
sudo start pika
```
```
screen ./pika
```
# در صورت خاموش شدن ربات برای لانچ
```
cd darkdiamond

screen ./pika
```

# آموزش زدن لانچر
# بترتیب
```
cd darkdiamond

tmux new-session -s script "bash steady.sh -t"
```

# برای یوزرغیر روت لانچر توصیه میشه 

# آموزش های بیشتر در کانال ما

# برای ورود به کانال کلیک کن

# [ورود به کانال](http://telegram.me/telediamondch)
# نوشته شده توسط:
By : # [@Mrr619](http://telegram.me/mrr619) 
