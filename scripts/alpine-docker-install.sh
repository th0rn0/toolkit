adduser -s /bin/sh -G users docker
apk add docker shadow
usermod -aG docker docker
rc-update add docker boot 
service docker start
