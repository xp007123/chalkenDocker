FROM ubuntu
MAINTAINER chalken

ENV MYPATH /home/chalken
WORKDIR $MYPATH

RUN apt-get update && apt-get install -y vim curl docker.io docker-compose python3 python3-pip wget tar net-tools iputils-ping git unzip zip \
	&& git clone https://gitee.com/chalken/fisco-repository.git \
	&& curl -#LO https://gitee.com/FISCO-BCOS/console/raw/master/tools/download_console.sh \
	&& bash download_console.sh \
	&& sed -i 's/3.4.0/3.2.0/g' download_console.sh \
	&& curl -#LO https://osp-1257653870.cos.ap-guangzhou.myqcloud.com/FISCO-BCOS/FISCO-BCOS/releases/v3.2.0/BcosBuilder.tgz && tar -xvf BcosBuilder.tgz
	
RUN unzip $MYPATH/fisco-repository/dist.zip \
	&& unzip $MYPATH/fisco-repository/fiscoSrc.zip \
	&& cp -r $MYPATH/console/lib $MYPATH/dist \
	&& cd $MYPATH/BcosBuilder \
	&& pip3 install -r requirements.txt \
	&& cd $MYPATH/BcosBuilder/pro \
	&& python3 build_chain.py download_binary -t cdn \
	&& cp -r binary/ $MYPATH/fiscoSrc/pro/

EXPOSE 80

CMD tail -f /dev/null

