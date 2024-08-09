# Chapter 14 시스템 및 서비스 관리(systemd)
### 14.1 CentOS7 부팅과정
#### CentOS7부터는 systemd 도입으로 부팅 과정이 바뀌었다.
* 시스템이 부팅되면, 시스템 BIOS에 의해 Disck의 MBR을 읽어 들인다. MBR에는 부트로더 GRUB이 설치되어 있으며 GRUB에는 /boot/grub2/grub.cfg 파일을 읽어 부팅할 커널 리스트를 보여줄 것이다. 
* 기본 커널을 선택했다면, 커널이 저장된 /boot/vmlinuz-3.10.0-123.el7.x86_64파일을 실행하고 메모리 Disk(RAM Disk)를 생성하여 initramfs-3.10.0-123.el7.x86_64.img 파일을 압축해제하여 chroot로 최상위 / 디렉토리를 압축이 해제된 경로로 변경하게 되며, 변경된 /의 /init 파일을 실행하게 된다. ( 이 과정에서 CentOS5 와 CentOS6은 init 프로세스가 호출된다. CentOS7은 sysyemd 프로세스가 호출된다.)

### 14.2 서비스 관리
#### CentOS7부터는 서비스 관리 스크립트들은 몇몇 서비스를 제외하고 각 서비스 유닛(Unit)으로 변경되었다.
* CentOS6 이전 버전의 리눅스는 /etc/rc.d/init.d/ 디렉토리에 서비스 관리 스크립트가 존재했다. 하지만 CentOS7부터는 서비스 관리 스크립트들은 몇몇 서비스를 제외하고 각 서비스 유닛(Unit)으로 변경되었다.
* 서비스 유닛은 .service으로 끝나는 파일이며, systemclt에 의해 제어된다. 물론 예전에 사용하던 service 명령어와 chkconfig  명령어의 사용은 가능하다. service 명령어와 chkconfig 명령어를 실행하면 systemcl으로 매핑되어 실행된다.

* 예전 버전의 서비스를 제어하기 위한 `service`와 `systemctl` 명령어의 사용법을 비교.

| 명령          | `service` 명령어            | `systemctl` 명령어                                            |
| ----------- | ------------------------ | ---------------------------------------------------------- |
| 시작          | `service <서비스명> start`   | `systemctl start <서비스명>`                                   |
| 중지          | `service <서비스명> stop`    | `systemctl stop <서비스명>`                                    |
| 재시작         | `service <서비스명> restart` | `systemctl restart <서비스명>`                                 |
| 상태 확인       | `service <서비스명> status`  | `systemctl status <서비스명>`                                  |
| 재로드         | `service <서비스명> reload`  | `systemctl reload <서비스명>`                                  |
| 활성화         | 사용 불가                    | `systemctl enable <서비스명>`                                  |
| 비활성화        | 사용 불가                    | `systemctl disable <서비스명>`                                 |
| 부팅 시 자동 시작  | `chkconfig <서비스명> on`    | `systemctl enable <서비스명>`                                  |
| 부팅 시 자동 중지  | `chkconfig <서비스명> off`   | `systemctl disable <서비스명>`                                 |
| 활성화된 서비스 목록 | `chkconfig --list`       | `systemctl list-unit-files --type=service --state=enabled` |
| 모든 서비스 상태   | `service --status-all`   | `systemctl list-units --type=service`                      |
##### 자동 시작 서비스 관리
```
// 1. 시스템 부팅 시 자동 시작되는 서비스 리스트 확인
systemctl list-unit-files --type service |grep enable

// 2. 예시) 프린트 관련 서비스 cups를 시스템 부팅 시 비활성화 되도록 설정
systemctl disable cups.service // 관련된 심볼릭 링크 파일이 삭제

// 3. 다시 cups서비스를 활성화
systemctl enable cups.service // 관련된 피일을 심볼릭 링크를 건다
```

##### 서비스 시작/상태확인/재시작/종료
```
// 1. 시작되지 않은 서비스 조회
systemctl list-units --type service -a |grep -w inactive

// 2. 예시) 정지된 서비스 중 파일 및 디렉토리 원격 동기화를 위해 사용하는 rsyncd 서비스를 시작
systemctl start rsyncd

// 3. 서비스 상태 확인
systemctl status rsyncd

// 4. 서비스 재시작
systemctl restart rsyncd

// 5. 서비스 종료
systemctl stop rsyncd
```

### 14.3 Target(런레벨)관리
#### CentOS7에서 사용하는 systemd는 CentOS6 이전 버전의 런 레벨(run level)을 타겟(target) 유닛으로 변경하였다.
* CentOS6 이전 버전은 시스템 초기화를 위해 사용하는 0부터 6까지의 런 레벨(run level)이 존재했다.
  예) 런 레벨 0: 종료, 런 레벨 3: Text 모드, 런 레벨 5: XWindows를 사용한 GUI 환경. 런 레벨 6: 리부팅

| 런 레벨(run level) | 타겟 유닛(target unit)  | 설명                   |
| :-------------: | :-----------------: | -------------------- |
|        0        |  `poweroff.target`  | 시스템 종료 (Power off)   |
|        1        |   `rescue.target`   | 구조 모드 (Rescue mode)  |
|        2        | `multi-user.target` | 다중 사용자 모드 (네트워크 포함)  |
|        3        | `multi-user.target` | 다중 사용자 모드 (네트워크 포함)  |
|        4        |         N/A         | 사용자 정의 가능 (기본 정의 없음) |
|        5        | `graphical.target`  | 다중 사용자 모드 (GUI 포함)   |
|        6        |   `reboot.target`   | 시스템 재부팅 (Reboot)     |

##### 현재 타겟(런 레벨) 확인
```
// 예전 방식의 런 레벨 확인
run level

// systemctl을 사용해 확인
systemctl get-default
```

##### Target(런 레벨) 변경
```
// 시스템의 기본 타겟을 변경

// 1. multi-user 타겟으로 변경 (예전의 런 레벨3)
systemctl set-default multi-user.target

// 2. multi-user 타겟으로 전환
systemctl isolate multi-user.target

// 3. 변경된 런 레벨 확인
runlevel

// 4. systemctl을 이용해 확인
systemctl get-default
```
### 14.4 원격 시스템 systemd 제어
#### SSH를 이용하여 원격지에 있는 systemd를 제어할 수 있다.
```
// SSH 를 이용하기 때문에 계정@아이피를 -H 옵션을 사용하여 입력 

// 192.168.0.201 서버의 rsyncd 서비스를 재시작
systemctl -H root@192.168.0.201 restart rsyncd

// 192.168.0.201 서버의 rsyncd 서비스 상태를 확인
systemctl -H root@192.168.0.201 status rsyncd
```

### 14.5 sytemd 유틸리티
##### systemd-cgtop : 서비스 그룹별 모니터링
* systemd에 의해 실행된 서비스 그룹별 CPU 사용률, 메모리 사용량, 프로세스 개수 등을 top 유틸리티와 비슷하게 실시간 모니터링 할 수 있다. 
```
systemd-cgtop
```

##### systemd-cgls : Cgroup 트리 확인
```
systemd-cgls
```

##### systemd-analyze : 각 유닛의 시작 시간 분석
```
// 시스템 시작에 소요된 시간 분석
systemd-analyze

// 유닛별 소요된 시간이 분석되며, 오랜 시간이 소요된 서비스 시간 기준으로 정렬
systemd-analyze blame

// 최악의 시간이 소요된 유닛들의 실행내역 (각 유닛의 의존관계와 소요시간 등을 파악 가능)
systemd-analyze critical-chain

// 각 유닛의 시작 시간을 SVG를 이용하여 그래프로 보여준다
systemd-analyze plot > analyze.svg
```

##### journalctl : systemd 로그 검색
* CentOS7은 syslog에 의해 기록되는 부분을 변경했다
```
// rsyncd 서비스 유닛에 대한 로그를 검색
journalctl -u rsyncd -a

// 중요도에 따른 로그 검색
journalctl -p 3 // 0: EMERGENCY
				// 1: ALERT
				// 2: Critical-chain
				// 3: ERROE
				// 4: WARNING
				// 5. NOTICE
				// 6: INFO
				// 7: DEBUG
```

##### 기간 설정 로그 검색
```
// --since 옵션을 사용해서 2015-04-12 16:00:00 이후 로그를, --until 옵션을 사용해서 현재 시간에서  60분 이전까지의 로그를 검색
journalctl --since="2015-04-12 16:00:00" --until="- 60 minutes"
```
### 14.6 systemadm : system GUI 관리자

# Chapter 15 웹 & was 서비스
### 15.1 웹서비스의 이해
* 웹 서비스는 클라이언트-서버 모델을 기반으로, 클라이언트 요청에 따라 서버가 웹 페이지나 데이터 등을 제공하는 서비스입니다. 이는 HTTP 프로토콜을 통해 이루어지며, 웹 서버 소프트웨어(예: Apache, Nginx 등)가 주요 구성 요소입니다.

* 웹 서비스의 주요 구성 요소에는 웹 서버, 응용 프로그램 서버, 데이터베이스 서버 등이 포함됩니다. 클라이언트의 요청이 웹 서버에 도달하면, 서버는 정적 또는 동적 콘텐츠를 제공하기 위해 필요한 컴포넌트를 호출하고, 결과를 클라이언트에게 반환합니다
### 15.2 웹서비스의 운영
#### 웹 서버 설정
(CentOS에서 제동되는 rpm 패키지를 사용하여 설치한 경우)
##### 아파치 주요 디렉토리

| 디렉토리 경로                               | 용도                                                  |
| ------------------------------------- | --------------------------------------------------- |
| `/etc/httpd/conf`                     | 메인 설정 파일(`httpd.conf`)이 위치한 디렉토리입니다.                |
| `/etc/httpd/conf.d`                   | 추가 설정 파일을 포함하는 디렉토리로, 모듈이나 가상 호스트 설정 파일이 여기에 위치합니다. |
| `/etc/httpd/conf.modules.d`           | 로드할 모듈의 설정 파일이 위치한 디렉토리입니다.                         |
| `/etc/httpd/logs` 또는 `/var/log/httpd` | 서버 로그 파일(액세스 로그, 에러 로그 등)이 저장되는 디렉토리입니다.            |
| `/var/www/html`                       | 기본 웹 문서의 루트 디렉토리로, 웹 페이지 파일들이 위치합니다.                |
| `/var/www/cgi-bin`                    | CGI 스크립트가 저장되는 디렉토리입니다.                             |
| `/etc/httpd/modules`                  | 동적으로 로드할 모듈(.so 파일)이 저장되는 디렉토리입니다.                  |
| `/usr/lib64/httpd/modules`            | 64비트 시스템에서 아파치 모듈이 위치하는 디렉토리입니다.                    |
| `/etc/httpd/run` 또는 `/run/httpd`      | 런타임 상태 정보, PID 파일 등이 저장되는 디렉토리입니다.                  |
| `/etc/httpd/mime.types`               | 파일 확장자와 MIME 유형 간의 매핑을 정의한 파일입니다.                   |
##### 아파치 실행 파일

| 실행 파일 경로               | 실행 파일 이름     | 용도                                                                     |
| ---------------------- | ------------ | ---------------------------------------------------------------------- |
| `/usr/sbin/httpd`      | `httpd`      | Apache HTTP Server의 메인 실행 파일. 웹 서버를 시작, 중지, 재시작할 때 사용됩니다.              |
| `/usr/sbin/apachectl`  | `apachectl`  | Apache HTTP Server를 제어하는 스크립트. `httpd` 실행 파일을 쉽게 제어하기 위한 인터페이스를 제공합니다. |
| `/usr/sbin/htpasswd`   | `htpasswd`   | 사용자 계정과 비밀번호를 관리하는 도구. `.htpasswd` 파일에 암호화된 비밀번호를 저장합니다.               |
| `/usr/sbin/htdigest`   | `htdigest`   | 다이제스트 인증용 사용자 계정과 비밀번호를 관리하는 도구.                                       |
| `/usr/bin/ab`          | `ab`         | Apache HTTP 서버의 성능을 테스트하기 위한 도구(ApacheBench).                          |
| `/usr/bin/logresolve`  | `logresolve` | Apache 로그 파일에 있는 IP 주소를 호스트 이름으로 변환하는 도구.                              |
| `/usr/bin/httxt2dbm`   | `httxt2dbm`  | 텍스트 기반의 해시 파일을 DBM 파일로 변환하는 도구. 주로 인증이나 접근 제어에 사용됩니다.                  |
| `/usr/sbin/rotatelogs` | `rotatelogs` | Apache 로그 파일을 관리하기 위해 사용되는 로그 파일 회전 도구.                                |
| `/usr/sbin/suexec`     | `suexec`     | CGI 프로그램이 다른 사용자로 실행되도록 설정하는 도구. 주로 보안 목적을 위해 사용됩니다.                   |
##### 아파치 환경경 설정
```
apachectl configtest

// httpd.conf 파일의 설정에 이상이 없을 경우: "Syntax OK"
// 파일 설정에 문제가 있는 경우 문제가 된느 부분을 알려준다
```

#### 웹 서버 작동 확인
##### 아파치 웹서버 시작
```
systemctl start httpd
```
##### 아파치 웹서버 작동 확인
```
// 1. 아파치 웹서버 동작 확인
systemctl status httpd

// 2. apache 프로세스 점검
ps -ef |grep http

// 3. 아파치 포트 리스닝
netstat -anp |grep httpd

// 4. 웹 브라우저를 통한 확인
```

#### 웹 서버 SSL 설정
##### 키 쌍 생성
먼저 키를 보관할 위치를 정한다. 대부분은 아파치 웹서버의 설정파일 디렉토리에 위치시키며, conf 디렉토리는 일반 사용자가 접근하지 못하도록 700 권한을 가지는 것이 좋다
* 키 보관 위치: etc/httpd/conf/ssl

```
// 키 보관 위치로 이동해서 다음 명령어로 키 쌍을 생성한다
openssl genrsa -des3 -out sunlinux.net.key 2048 // 서버 키 알고리즘은 RSA를 사용하고 2048bit 키를 생성한다
```

##### CSR(Certification Signing Request) 생성
```
openssl req -new -key sunlinux.net.key -out sunlinux.net.csr

// 국가코드: KR
// 시/도 이름: Seoul
// 구/군 이름: Gangnam
// 회사 이름: SUPERUSER Co., Ltd
// 부서명: Korea Linux Laboratory
// 도메인 명: www.sunlinux.net
// Email 주소: sunlinux@sunlinux.net

// 가장 중요한 것은 도메인. 입력한 주소에서만 사용할 수 있는 인증서가 된다.
```

##### 아파치 mod_ssl 설치
```
// CentOS의 rpm 패키지로 Apache를 설치했다면, mod_ssl패키지를 설치
yum -y install mod_ssl
```

##### 아파치 ssl 설정
1. mod_ssl을 설치한 경우 /etc/httpd/conf.d/ssl.conf 파일이 생성된 것을 확인할 수 있다
2. sssl.conf 파일을 설정한다
3. 설정파일 수정 후 웹서버를 정지 후 시작한다 (SSL 적용 시 꼭 stop 후 start 해야 한다) ``
```
// SSL 적용하고 아파치 웹서버 시작
apachectl startssl // Apache 2.0.X
apachectl start // Apache 2.2.X 이상
```

```
// CentOS7의 systemctl을 사용해서 SSL이 설정된 Apache 웹서버를 시작
systemctl start httpd
```
### 15.3 PHP
### 15.4 WAS(Tomcat)
톰캣만으로 웹서버 및 웹 어플리케이션 서버 역활을 모두 다 할 수 있다. 그렇지만, 성능 및 보안 등의 이유로 웹서버와 WAS는 분리하게 된다. 웹서버에서는 정적콘텐츠를 빠르게 처리 가능한 역활을 하며 누구나 접근 가능한 공개된 네트워크에 서버를 둔다. 톰켓 서버는 동적콘텐츠인 웹 어플리케이션을 처리하며 웹서버에서만 접근 가능하게 구성한 로컬네트워크에 두어 성능 및 보안을 강화시키는 구성을 한다.

#### JDK 설치
```
// 다운로드 받은 java를 /usr/local 아래 디렉토리에 압축을 풀어준다
tar xvfp jdk-8u40-linux-x64.tar.gz -C /csr/local/

// -C 옵션을 사용해서 압푹을 풀어서 저장할 디렉토리를 지정할 수 있다

// 쉘의 환경변수 JAVA_HOME과 java의 실행파일에 대한 패스(path)를 다음과 같이 설정해 준다
echo "export JAVA_HOME=/usr/local/jdk1.8.0_40/" >> /etc/profile
echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
source /etc/profile
```

#### Tomcat 설치 및 실행
```
// tomcat.apache.org 사이트에서 Tomacat을 다운로드 후 tar 명령어에 -C 옵션을 줘 /usr/local 디렉토리 아래에 압축을 푼다
tar xvfp apache-tomcat-8.0.21.tar.gz -C /usr/local/
```

#### Tomcat 시작
```
// Tomcat 시작
cd /usr/local/apache-tomcat-8.0.21/bin/
./catlina.sh start
```

#### Tomcat 정지
```
// tomcat 정지
cd /usr/local/apache-tomcat-8.0.21/bin/
./catlina.sh stop
```

#### Tomcat 프로세스 확인
```
// Tomcat이 시작되면 아래의 명령어로 java 프로세스를 확인할 수 있다
ps -ef |grep tomcat
```

#### Tomcat 프로세스 확인
```
netstat -anp |grep java

// 기본 설정
// 8080포트: 브라우저에서 직접 접근할 수 있는 HTTP 커넥터 포트
// 8009포트: 웹서버 등을 통해 통신할 수 있는 AJP(Apache JServ Protocol) 커넥터 포트
// 8005포트: Tomcat을 정지할 때 사용하는 SHUTDOWN 포트
```

#### Apache와 Tomcat 연동
##### mod_jk를 Apache에 모듈로 설치
```
// tomcat.apache.org 사이트에서 다운로드 후 다음과 같이 압축을 풀고 프로그램 소스 디렉토리로 이동한다
tar xvfp tomcat-connectors-1.2.40-src.tar.gz

cd tomcat-connectors-1.2.40-src/native

// mod_jk를 Apache모듈로 설치하기 위해서는 apxs가 필요하다
// apxs는 http-devel 패키지에 속해 있으며, http-devel패키지를 설치해 준다
yum -y install http-devel

// 모듈 컴파일 및 설치를 위해 환경설정 및 환경 점검을 한다
./configure --with-apxs=/usr/bin/apxs // '--with-apxs' 인자로 아파치 웹서버의 apxs 명령어가 있는 곳을 지정해 준다
```

##### 모듈 컴파일
```
// make 명령어로 모듈을 컴파일
make -j 4 // '-j 4' 옵션으로 4개의 jpb으로 나눠 컴파일 해서 컴파일 속도를 높인다
```

##### 모듈 설치
```
// 컴파일 된 모듈(mod_jk.so)을 아파치 웹서버의 modules 디렉토리에 설치해 준다
make install

// 아파치 웹서버 설정을 한다
// 아파치 웹서버 설정파일(httpd.conf)의 가장 아래쪽에 다음 내용을 추가한다
LoadModule jk_module modules/mod_jk.so
 <IfModule mod_jk.c >
 JkWorkersFile conf/workers_jk.properties
 JkShmFile run/mod_jk.shm
 JkLogFile logs/mod_jk.log

 JkLogLevel info
 JkLogStampFormat "[%a %b %d %H:%M:%S %Y] "

 JkMountFile conf/uriworkermap.properties
 </IfModule>
```

##### worker.properties 파일
```
// 아파치 설정파일(https.conf)과 동일한 위치에 workers.properties 파일에 작성한다
worker.list=tomcat
worker.tomcat.type=ajp13
worker.tomcat.host=localhost
worker.tomcat.port=8009
```
# Chapter 16 데이터베이스
### 16.1 데이터베이스의 정의
관계형 데이터베이스(RDBMS, Relational Database Management System)는 데이터를 테이블 형식으로 관리하는 데이터베이스 시스템이다. 각 테이블은 행과 열로 구성되며, 행은 개별 데이터 항목(레코드)을 나타내고 열은 데이터의 속성(필드)을 정의한다. 테이블 간의 관계는 외래 키를 통해 설정된다. 관계형 데이터베이스는 데이터를 정규화하여 중복을 최소화하고 데이터 무결성을 유지하는 데 중점을 둔다.

* 주요 특징
1. 정규화: 데이터 중복을 줄이고 무결성을 유지하기 위해 데이터를 여러 테이블로 분리
2. SQL(Structured Query Language): 데이터베이스의 데이터 정의, 조작, 제어 등을 위한 표준 언어
3. 무결성: 데이터 정확성과 일관성을 보장하기 위해 제약 조건을 사용

##### 데이터 정의 언어 (DDL)
DDL(Data Definition Language)은 데이터베이스 구조(스키마)를 정의하고 수정하는 데 사용되는 SQL의 하위 언어

*  주요 명령어

- CREATE: 새로운 데이터베이스, 테이블, 인덱스 등을 생성
- ALTER: 기존 테이블의 구조를 수정
- DROP: 데이터베이스, 테이블, 인덱스 등을 삭제
- TRUNCATE: 테이블의 모든 데이터를 삭제하지만 구조는 유지

##### 데이터 조작 언어 (DML)
DML(Data Manipulation Language)은 데이터베이스 내의 데이터를 조작하는 데 사용되는 SQL의 하위 언어

* 주요 명령어

- SELECT: 데이터베이스에서 데이터를 조회
- INSERT: 새로운 데이터를 테이블에 삽입
- UPDATE: 기존 데이터의 값을 수정
- DELETE: 데이터베이스에서 데이터를 삭제

##### 데이터 제어 언어 (DCL)
DCL(Data Control Language)은 데이터베이스의 접근 권한과 보안을 관리하는 데 사용되는 SQL의 하위 언어

* 주요 명령어

- GRANT: 사용자에게 권한을 부여
- REVOKE: 사용자의 권한을 취소

### ACID 속성

ACID는 데이터베이스 트랜잭션의 안정성을 보장하기 위한 네 가지 핵심 속성을 의미합니다. 이는 데이터베이스의 일관성과 신뢰성을 유지하는 데 중요한 역할

*  ACID의 네 가지 속성
1. Atomicity (원자성): 트랜잭션의 모든 연산이 완전히 수행되거나 전혀 수행되지 않아야 함
2. Consistency (일관성): 트랜잭션이 성공적으로 완료되면 데이터베이스는 일관성 있는 상태를 유지해야 함
3. Isolation (고립성): 트랜잭션 간의 간섭이 없도록 해야 함. 즉, 각각의 트랜잭션이 독립적으로 수행되어야 함
4. Durability (지속성): 트랜잭션이 완료되면 그 결과가 영구적으로 저장되어야 함

### 16.2 MySQL
#### MySQL 운영
MtSQL의 시작과 종료, 확인 등은 MySQL에서 제공하는 스크립트(mysql.server)를 이용하면 된다.
이 스크립트느 리눅스의 서비스로 등록하면 서버부팅 시 자동으로 시작하게 될 수 있고 편리하게 관리할 수 있다.

```
ln -s /usr/local.myql/support-files/mysql.server /etc/init.d/mysqld
chkconfig --add mysql
chkconfig mysqld on

// 만약, CentOS7에 MariaDB가 설치되어 있다면, 올바르게 작동하지 않을 수가 있다. 아래와 같이 설정파일을 백업하고 링크 시켜준다
mv /etc.my.cnf /etc/my.cnf.bk
ln -s /usr/local/mysql/my.cnf /etc/my.cnf

//서비스 명령어로 MySQL을 시작한다
service mysqld start

// MySQL 동작 확인
service mysqld status

// MySQL 정지
service mysqld stop

// mysqladmin 명령어로 mysql root 번호를 생성한다
/usr/local/mysql/bin/mysqladmin password 비밀번호

// mysql 명령어로 MySQL 서버에 접속한다
/usr/local/mysql/bin/mysql -uroot -p
```

#### 연동 테스트를 위한 DB 및 사용자 생성
* sunlinux DB를 생성하고 , sunlinux 사용자를 생성하여 sunlinux DB에 모든 권한을 주는 것이며, "FLUSH PRIVILEGES"는 마지막에 권한에 대한 설정이 저장된 mysql DB의 내용을 읽어들여 적용한다
```
/usr/local/mysql/bin/mysql -uroot -p

mysql> CREATE DATABASE sinlinux;

mysql> GRANT ALL PRIVILEGES ON sunlinux.* TO sunlinux@localhost IDENTIFIED BY '비밀번호' WITH GRANT OPTION;

mysql> FLUSH PRIVILEGES;
```

#### DB 연동 테스트
```
// php에서 MySQL을 사용하기 위해 php-mysql 및 php-pdo 모듈응 설치해야 한다
// php-mysql 패키지를 설치한다
yum -y install php-mysql

// php 및 Apache 설정 변경 후에는 꼭 Apache를 재시작하여 설정 내역을 적용하도록 한다
systemctl restart httpd
```

```
// 간단한 프로그램을 작성하여 테스트

<?php
echo "DB Connect<BR>";
$mysql = mysql_connect("localhost", "sulinux", "비밀번호") or die("DB Connect Faied");
echo "Select sulinux DB<BR>";
$status = mysql_select_db("sulinux",$mysql);
echo "Create sutable table<BR>";
$result = mysql_query("CREATE TABLE sutable ( a text )",$mysql);
echo "Insert data<BR>";
$result = mysql_query("INSERT INTO sutable VALUES('DataBase Test')",$mysql);
echo "Select data<BR>";
$result = mysql_query("SELECT * FROM sutable",$mysql);
echo "Fetch data<BR>";
$row = mysql_fetch_array($result);
echo "Result : <FONT color=red>".$row["a"]."</FONT><BR>";
echo "Drop sutable table<BR>";
$result = mysql_query("DROP TABLE sutable",$mysql);
?>
```
### 16.3 MariaDB

### 16.4 postgreSQL

### 16.5 MongoDB(NoSQL)

