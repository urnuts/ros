```

# Debian/Ubuntu 直接安装RouterOS
 wget --no-check-certificate https://raw.githubusercontent.com/urnuts/ros/main/RouterOS.sh && chmod +x RouterOS.sh && bash RouterOS.sh
     
# CentOS7 直接安装RouterOS  
 wget --no-check-certificate https://raw.githubusercontent.com/urnuts/ros/main/RouterOS.sh && chmod +x RouterOS.sh && sed -i 's/apt/yum/g' /root/RouterOS.sh && bash RouterOS.sh
     
     
# 群晖虚拟机可按照Linux后dd ros,登录admin,密码为空
# 关于升降级：最新版WinBox登录版本限制v6.43，v6.47含FWD功能,推荐最低v6.48

```
