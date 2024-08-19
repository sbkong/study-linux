# LSCP(Linux System Check Project) 소개
- SSU([Superuser Server Utility](https://www.linux.co.kr/bbs/board.php?bo_table=lecture&wr_id=761))의 점검 부분을 특화하여 저자가 만든 오픈소스 프로젝트
![[Pasted image 20240819211844.png]]

### 주요 기능
#### 보안 점검 기능
- 백도어, Root소유 SetUid 파일, tmp 점검
- LISTEN port 점검
- Linux 기본 방화벽 점검
- 실행 프로세스 점검
- 하루 동안 변경된 파일 점검
- chkrootkit 이용한 rootkit 점검
- 초기 실행 스크립트 점검
- 중요 파일 속성 및 퍼미션 점검
- 계정 점검
- 접속자 점검

#### 리소스 점검 기능
- 부하, 프로세스, 트래픽, 메모리 점검 (그래프)
- 디스크 파티션 점검 (그래프)
- cpu 변경, 가동 시간 점검

#### 시스템 상태 점검 기능
- 용량 큰 파일 점검
- Mail Queue 점검
- LOG 파일 점검
- CRON 설정 점검
- 사용자 정보

#### 문제점 보고
- 문제점 보고

#### 월간 리포팅 기능(월간 보고서)
- 하드웨어 정보점검
- 소프트웨어 정보 점검
- 네트워크 정보점검
- 월간 서버 부하 점검
- 월간 프로세스 수 변화 점검
- 월간 트래픽 변화량 점검
- 월간 메모리 사용량 점검
- 월간 디스크 사용량 점검
- 기타 정보 점검
- 사용자 정보 점검

# 설치
### 다운로드
- 소스코드 및 프로그램 다운로드
  https://sourceforge.net/projects/lscp
### 설치 전 고려 사항
- 웹 서버 : LSCP의 결과는 html로 제공됨. 하지만 웹 서버는 포함되어 있지 않음. 그러므로 `Apache`, `tomcat`등의 웹 서버가 필요함
- CRON : LSCP의 주기적인 실행에 사용

### 라이선스
- GPL (http://www.gru.org/licenses)

### 다운로드 및 설치
- https://sourceforge.net/projects/lscp > Download 버튼 클릭 > 다운로드 > 리눅스 서버에 업로드
- 프로그램 설치(unix 표준 설치법에 의거함)
```bash
tar vxfpj lscp-1.0.2.tar.bz2
cd lscp-1.0.2/
./configure --prefix=/usr/local/lscp #prefix를 설정하지 않으면 /usr/local에 설치됨
make
make install
```

### 설정
아래와 같은 2개의 설정파일이 있다.
- 설정파일 1 : `/usr/local/lscp/conf/lscp.conf`
- 설정파일 2 : `/usr/local/lscp/conf/lscp_system_files.conf`

>`/usr/local/lscp/conf/lscp.conf`
>설정파일 1 ( lscp.conf )은 아래의 표와 같은 항목이 있다. 모든 옵션은 ‘변수=”값“’과 같은 형식으로 설정한다. 변수와 값 사이에는 ‘=’ 이외의 공백이 들어가면 작동하지 않는다. (예) a ="b" 또는 a= "b" 는 작동하지 않음)
```bash
# This file is lscp configuration file.
# Please keep the following format:
# variable="value"
# Variables and the value = the connection, and must not have spaces.
# 사용할 LSCP 모듈 정의
conf_lscp_modules="resource_graph resource_disk backdoor listen_ports firewall status_bigfiles status_mailqueue status_cron status_users process chkrootkit modify_files init_scripts system_files users login_users resource_version status_logfiles error_report report_hw report_sw report_etc report_net"

## Administrator mail address ( 문제점 발생시 받을 메일 주소 입력 )
conf_admin_mail="관리자메일주소입력"

# min big file size(Mbyte) (큰 파일 검색시 최소 파일 크기)
conf_min_big_file_size=50

# max mailqueue count count ( 최대 메일 큐의 메일 수 )
conf_max_mailqueue_count=200

# Apache configuration file ( Apache 설정파일 및 실행 경로 지정 )
conf_httpd_conf="/usr/local/apache/conf/httpd.conf"
conf_httpd_bin="/usr/local/apache/bin"

## LSCP Result Page security ( 보안 설정 )
conf_htauth=yes
conf_htuser="lscp"
conf_htpasswd="sulinux"

# The list of Draw graph process ( max : 5 process) ( 그래프를 그릴 프로세스 )
conf_graph_process="httpd mysql"

# monitor ethernet device ( 그래프를 그릴 네트웍 디바이스 )
conf_graph_eth_dev="eth0"

# check time ( Minute must has 00,05,10 ... 55) ( 매일 점검 할 시간 )
conf_check_time="07:00"

# Archive period ( 점검 결과를 보관 할 일 수 )
conf_archive_period="60"

# safe process lists ( 문제 없는 프로세스 리스트 정의 )
conf_safe_process="awk uptime lscp_cron"
```

> [!info] 지시자 정의
>
**conf_lscp_modules**
LSCP의 여러 기능을 가진 단위 모듈의 사용 여부를 지정한다. 여러 모듈을 열거 할 수 있으며, 모듈과 모듈 사이에는 공백으로 띄워 구분한다.
예) conf_lscp_modules="resource_graph resource_disk"
>
**conf_admin_mail**
LSCP에 의해 시스템을 점검 한 결과 문제점이 발생되면, 메일을 보내게 된다. 이 문제점에 대한 내용을 받을 메일 주소를 입력한다.
예) conf_admin_mail="doly@sulinux.net"
>
**conf_min_big_file_size**
LSCP 큰 파일 점검 모듈에서 기준으로 사용할 파일 사이즈이다. 명시한 사이즈 이상인 파일만 리스팅 하게 된다. (단뒤: MByte)
예) conf_min_big_file_size=50
>
**conf_max_mailqueue_count**
LSCP 메일 큐 점검 모듈에서 기준으로 사용할 메일 큐에 쌓이 메일 수이다. 명시한 수 이상의 메일이 쌓였을 때 점검 문제점 보고에 출력하고, 메일을 발송하게 된다.
예) conf_max_mailqueue_count=200
>
**conf_httpd_conf**
LSCP에서 웹서버 설정 도메인 등을 조사하기 위해 아파치 설정파일(httpd.conf)를 사용한다. 이 httpd.conf파일의 위치를 지정한다.
예) conf_httpd_conf="/usr/local/apache/conf/httpd.conf"
>
**conf_httpd_bin**
웹서버(아파치)의 실행프로그램 경로를 지정한다.
예) conf_httpd_bin="/usr/local/apache/bin"
>
**conf_htauth**
웹서버(아파치)의 페이지 보안 설정기능을 사용하여 웹페이지 접근을 통제를 할 것인지 여부를 결정한다. ( 입력 값 : yes 또는 no )
예) conf_htauth=yes
>
**conf_htuser**
웹서버(아파치)의 페이지 보안 설정기능을 사용한다면(conf_htauth=yes) 인증할 사용자를 설정한다.
예) conf_htuser="lscp"
>
**conf_htpasswd**
웹서버(아파치)의 페이지 보안 설정기능을 사용한다면(conf_htauth=yes) 인증할 사용자의 비밀번호를 설정한다.
예) conf_htpasswd="sulinux"
>
**conf_graph_process**
LSCP 자원 그래프 모듈에서 프로세스 수를 그래프로 보여준다. 그래프에서 보여줄 프로세스 종류를 선택한다. 프로세스는 여러개 그릴 수 있으며, 공백으로 구분하여 열거한다. (최대 5개)
예) conf_graph_process="httpd mysql"
>
**conf_graph_eth_dev**
LSCP 자원 그래프 모듈에서 이더넷 인터페이스에 대한 트래픽을 그래프로 그린다. 리눅스 시스템에는 있는 여러 인터페이스 중 그래프를 그릴 디바이스를 선택하기 위해 본 지시자를 사용한다.
예) conf_graph_eth_dev="eth0"
>
**conf_check_time**
LSCP는 cron에 의해 5분에 1회 실행된다. 시스템의 전반적인 상황은 매 분 점검하게 되면, 시스템에 많은 부하를 주게 된다. 시스템 전반적인 점검은 하루에 1회 수행한다. 수행하는 시간을 설정하는 지시자이다.
예) conf_check_time="07:00"
>
**conf_archive_period**
LSCP는 매일 전반적으로 시스템을 점검하게 된다. 이 점검 된 결과는 시간이 지나서 필요할 때가 있다. 그렇지만, 너무 많이 남게 되면, 많은 디스크 공간을 필요로 하기 때문에 주기적으로 지워주는 것이 필요하다. 본 지시자를 사용하여 점검 결과를 보관할 기간을 정할 수 있다.
예) conf_archive_period="60"
>
**conf_safe_process**
LSCP의 실행 프로세스 점검기능에서 안전한 프로세스가 수상한 프로세스로 오탐하는 경우가 있다. 이러한 경우 안전한 프로세스 명을 넣어 줄 수 있는 지시자이다.
예) conf_safe_process="awk uptime lscp_cron"


> `/usr/local/lscp/conf/lscp_system_files.conf`
> 설정파일 2 (lscp_system_files.conf)는 시스템의 중요한 파일을 열거해 ‘중요파일 점검’시 점검하게 될 항목들을 명시한다.
```bash
# This file is lscp configuration file(system file list for lscp_mod_system_files)
# Please keep the following format:
# /path/files
/bin/chgrp
/bin/chmod
/bin/chown
/bin/cp
/bin/df

## 중간 생략 ##

/usr/bin/passwd
/usr/bin/pstree
/usr/bin/ssh
/usr/bin/top
/usr/bin/w
/usr/bin/wget
/usr/bin/who
/usr/sbin/lsof
/usr/sbin/sendmail
```

- 설정 변경 후에는 lscp_init 을 실행한다.
  `/usr/local/lscp/bin/lscp_init`
![[Pasted image 20240819230817.png]]

![[Pasted image 20240819231613.png]]
### 웹서버 설정
LSCP는 점검 결과를 HTML형태로 출력하며, 웹서버의 도움을 받아 웹으로 보여주게 된다. 웹 서버 설정은 다음과 같이 한다.

#### 아파치(Apache) 웹서버
설정파일`(/etc/httpd/conf/httpd.conf`)파일을 열어 다음과 같이 가상호스트에 추가한다.
( Apache 2.2.x의 경우는 `extra/httpd-vhosts.conf`에 설정한다.)
![[Pasted image 20240819231104.png]]
```bash
NameVirtualHost *:80
<VirtualHost *:80>
   DocumentRoot /usr/local/lscp/result_html
   ServerName lscp.bigdata
   <Directory /usr/local/lscp/result_html>
      AllowOverride AuthConfig
   </Directory>
</VirtualHost>

```
위와 같이 서브 도메인을 할당하여 설정한다.
- 설정 변경 후에는 웹서버를 재시작 한다.
- 웹서버의 종류 및 버전에 따라 설정법은 차이가 있으니, 각 웹서버 매뉴얼을 참조하기 바란다.

# 사용법(점검 결과 확인)
### 초기 점검 결과 확인
LSCP 프로그램 설치 후 바로, 결과 페이지를 확인하지는 못한다. 이유는 리눅스 시스템 점검 프로그램이기 때문에 점검을 수행하거나, 정보를 수집하여 보여주기 때문이다. 프로그램 설치 후 5분 이내에 접속하게 되면, 아무런 페이지 및 결과를 확인할 수 없으며, 5분이 지난 후 다음과 같이 확인된다.

### 사용자 인증
LSCP 결과를 아무나보지 못하게 lscp.conf 설정에서 htauth를 사용하게 설정하였다면, 다음과 같은 아이디/비밀번호 입력창이 뜰 것이다.
![[Pasted image 20240819232014.png]]

사용자 이름 및 암호를 lscp.conf 설정된 값을 입력하면 다음 화면을 만나게 된다.

### LSCP 메인 화면
![[Pasted image 20240819232039.png]]
위 점검 결과는 시스템의 부하만을 볼 수 있으며, 다른 점검결과를 볼 수 없다. 이는 시스템의 전반적 점검이 수행되지 않아서 이며, 좌측 상단의 “점검항목”에 보여지는 명령어를 다음과 같이 수행한다.
```
[root@sul2-64bit result_html]# cd /usr/local/lscp/bin
[root@sul2-64bit bin]# ./lscp_cron --check
1. 점검중 lscp_mod_resource_graph ..... [ 활동 없음 ]
2. 점검중 lscp_mod_resource_disk ..... [ 확인 ]
3. 점검중 lscp_mod_backdoor ..... [ 확인 ]
4. 점검중 lscp_mod_listen_ports ..... [ 확인 ]
5. 점검중 lscp_mod_firewall ..... [ 확인 ]
6. 점검중 lscp_mod_status_bigfiles ..... [ 확인 ]
7. 점검중 lscp_mod_status_mailqueue ..... [ 확인 ]
8. 점검중 lscp_mod_status_cron ..... [ 확인 ]
9. 점검중 lscp_mod_status_users ..... [ 확인 ]
10. 점검중 lscp_mod_process ..... [ 확인 ]
11. 점검중 lscp_mod_chkrootkit ..... [ 확인 ]
12. 점검중 lscp_mod_modify_files ..... [ 확인 ]
13. 점검중 lscp_mod_init_scripts ..... [ 확인 ]
14. 점검중 lscp_mod_system_files ..... [ 확인 ]
15. 점검중 lscp_mod_users ..... [ 확인 ]
16. 점검중 lscp_mod_login_users ..... [ 확인 ]
17. 점검중 lscp_mod_resource_version ..... [ 확인 ]
18. 점검중 lscp_mod_status_logfiles ..... [ 확인 ]
19. 점검중 lscp_mod_error_report ..... [ 메뉴 생성 안함 ]
20. 점검중 lscp_mod_report_hw ..... [ 메뉴 생성 안함 ]
21. 점검중 lscp_mod_report_sw ..... [ 메뉴 생성 안함 ]
22. 점검중 lscp_mod_report_etc ..... [ 메뉴 생성 안함 ]
23. 점검중 lscp_mod_report_net ..... [ 메뉴 생성 안함 ]
```
위 명령어 수행 후 다음과 같은 결과를 확인 할 수 있다.
![[Pasted image 20240819232122.png]]
위 결과와 같이 좌측 상단에 “점검항목”이 표시되는 것을 확인 할 수 있다.
“월간보고” 기능역시 명령어를 실행 시켜 결과를 확인 할 수 있다.

### 점검 결과 상세 확인
#### 시스템 자원 그래프(resourse_graph)
시스템 자원의 전반적인 상황을 5분 단위로 조사하여, 그래프를 그려 보여준다. CPU, 메모리, 부하, 프로세스, 스왑 등의 자원을 쉽게 확인 할 수 있다.

##### 평균 부하
- 시스템의 1분, 5분, 15분의 평균 부하율을 나태는 그래프이다.
![[Pasted image 20240819232151.png]]

##### 부하(%)
- CPU 및 IO 사용률을 보여주는 그래프이다. CPU를 부하를 지속적으로 파악하여 특정 시간대의 장애를 확인할 수 있으며, CPU자원을 지속적으로 모니터링 하여 교환 시기를 예측 할 수 있다.
![[Pasted image 20240819232215.png]]

##### 프로세스 수
- 프로세스 수를 조사하여 그래프로 보여준다. 리눅스 시스템 주요 프로세스를 모니터링 하므로 특정 시간 장애 발생시 원인을 쉽게 찾을 수 있다. 프로세스의 종류는 lscp.conf에 5개 까지 설정 할 수 있다.
![[Pasted image 20240819232233.png]]

##### 트래픽 현황
- 리눅스 시스템에서 발생하는 트래픽을 측정하여 그래프로 나타낸다. 네트워크와 연결된 리눅스 시스템의 트래픽을 쉽게 분석할 수 있다. 트래픽을 모니터링 하기 위한 이더넷 장치명은 lscp.conf에 설정 하여 여러 장치를 점검 할 수 있다. (기본 : eth0)
![[Pasted image 20240819232254.png]]

##### 메모리 사용량
- 메모리 사용량을 모니터링 한다. 메모리 사용량을 시간 단위로 표시하기 때문에 특정시간에 증가 및 지속적인 증가를 파악하여 메모리 증설 시점을 쉽게 파악 할 수 있다. 리눅스에서 사용하지 않는 메모리는 버퍼나, 캐쉬로 활용하여 가용한 메모리를 효율적으로 활용한다. 실 메모리 사용량은 사용량-버퍼-캐쉬 와 같이 계산 할 수 있다.
![[Pasted image 20240819232318.png]]

##### 스왑 사용량
- 스왑 사용량을 모니터링 한다. 스왑은 메모리가 부족하거나, 메모리에 로드 했지만, 거의 사용하지 않는 프로그램 또는 데이터를 저장하기 위한 공간이다. 메모리 대신 스왑을 사용하면 시스템은 많은 느려지기 때문에 스왑과 메모리 사용량을 모니터링 하여 메모리 증설 시점을 결정할 수 있다.
![[Pasted image 20240819232331.png]]

#### 디스크 용량 점검 (resource_disk)
##### 디스크 사용량

##### 디스크 사용량 그래프
#### 백도어 점검 (backdoor)
##### /dev 디렉토리 점검
##### Root 소유의 SetUid, SetGid 파일 점검
