# VPS安装RouterOSs：

     wget --no-check-certificate https://raw.githubusercontent.com/urnuts/ros/main/RouterOS.sh && chmod +x RouterOS.sh  \
       //centos先执行执行：sed -i 's/apt/yum/g' /root/RouterOS.sh \
     bash RouterOS.sh \

    # PVE/EXSI，恩山有L6授权的镜像
    # 群晖虚拟机可按照Linux后dd ros,登录admin,密码为空
    # 关于升降级：最新版WinBox登录版本限制v6.43，v6.47含FWD功能
    # wr330/wr1200js刷RB750Gr3参考恩山
    # 建议直接购买ros硬路由/二手也行

<code>
1. 本地ros配置pppoe并上网； 获取license fuyu  
  //pppoe断网重拨
  //pppoe拨号后更新ip

2. cf动态ddns,及定时脚本

3. jump回流及端口转发

4. 方猫ipip隧道 ;
   //创建隧道
   //创建内网
   //cn list,gf.w list
   // proxy--本地网卡，及内网ip段
   
   //标记 / 劫持53端口</code>
