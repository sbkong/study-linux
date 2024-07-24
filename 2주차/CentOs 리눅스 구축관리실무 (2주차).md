## Chapter 05 CentOS 기본 설정
### 5.1 키보드 및 마우스 설정
#### 5.1.1  키보드 설정
##### Setting > Region & Language
![[Pasted image 20240722134241.png]]
* ###### 한/영 변환: window+space bar

##### Setting > Devices
![[Pasted image 20240722135627.png]]

#### 5.1.2  마우스 설정
##### Setting > Device
![[Pasted image 20240722140706.png]]

### 5.2 날짜 및 시간 설정
##### Setting > Details > Data & Time
![[Pasted image 20240722140031.png]]

```
// 시간대 확인
# timedatectl list-timezones | grep Asia

//Asia/Seoul으로 시간대 설정
# timedatectl set-timezones Asia/Seoul
```

### 5.3 로케일 설정
#### 5.3.1  로케일 및 키보드 설정 정보 확인
```
// 로케일 및 키보드 설정 정보 확인
loclaectl
```
![[Pasted image 20240722144838.png]]
```
// 설정 가능한 로케일 출력
# loclaectl list-locales

// 로케일 설정
# loclaectl set-locale "LANG=ko_KR.utf8"
```

#### 5.3.2  locale으로 로케일 확인
```
// 현 시스템의 설정된 로케일 확인
# locale
```
![[Pasted image 20240722150108.png]]

```
// 사용 가능한 로케일 확인
# locale -a
```
## Chapter 06 네트워크
### 6.1 네트워크의 개념
#### 6.1.1  네트워크의 개요와 통신망 구조
##### 네트워크란?
네트워크란 컴퓨터를 통신망에 의하여 상호 연결하여 소프트웨어나 데이터베이스를 공유하도록 함으로써 컴퓨터의 효율적인 이용을 목적으로 하거나, 대형 컴퓨터를 원격지에서 이용하기 위한 방법으로 여러 가지 통신망을 구성한다.

##### 통신망의 종류
* LAN(Local Area Network : 근거리 통신망): 1km 이내의 컴퓨터 시스템 간에 데이터 통신을 하기 위한 통신망 
* MAN(Metropolitan Area Network :  대도시 통신망): 대도시와 같은 넓은 지역에 데이터, 음성, 영상 등의 서비스를 제공하는 통신망
* WAN(Wide Area network :  광대역 통신망): 매우 넓은 네트워크 범위를 갖는 통신망
* VAN(Value Added Network : 부가가치 통신망): 통신 회선을 직접 보유하거나 통신 사업자가 제공하는 회선을 임차 또는 이용하여 정보를 축적, 가공, 변환, 처리 등을 통해 데이터에 높은 부가가치를 부여하여 제공하는 광범위하고 복합적인 서비스의 집합
  
##### LAN의 토폴로지(Topology)에 따른 분류
![[Pasted image 20240722155408.png]]

| 분류                 | 설명                                                                                                                                   |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| 스타형(Star Topology) | 네트워크의 모든 노드(node)들의 중심의 한 노드에 집중되어 외부의 모든 노드들은 중심의 한 노드와 일대일(Point to Point) 형식으로 연결 되어 있으며 중심의 한 노드는 나머지 노드들에 대하여 교환기의 역활을 수행하게 된다. |
| 버스형(Bus Topology)  | 하나의 회선에 여러 노드들이 연결되어 있으며 하나의 회선의 종단에는 터미네이터(Terminator)가 부착되어 있는 형태이다.                                                               |
| 링형(Ring Topology)  | 모든 노드들이 폐쇠된 하나의 네트워크로 연결된 형태이다.                                                                                                      |
| 트리형(Tree Topology) | 여러 개의 허브를 사용하여 계층적인 구조를 가지게 하는 네트워크 구조의 하나이다.                                                                                        |
| 망형(Mesh Topology)  | 스타형과 링형이 결합된 형태로, 각 컴퓨터가 임의의 다른 사용자 시스템들과 직접 상호 연결이 되어 있어 전체적으로 그물과 같은 형태를 이루는 구조이다.                                                 |

##### 광대역 통신망(WAN : Wide Area Network)
WAN은 광대역 통신만으로 정의되나 오늘날 네트워킹 기술에서는 먼 거리에 있는 서로 다른 LAN, MAN을 연결하는 네트워크를 의미한다. WAN은 ISP(Internet Service Provide)에 의해서 제공되어 조직의 LAn과 라우터 또는 유/무선 공유기에 의해 인터넷으로 연결된다. 라우터나 유/무선 공유기의 경우 인터넷과 연결되는 포트에 "WAN"이라고 표시되기도 한다.

#### 6.1.3 통신 프로토콜
![[Pasted image 20240722164332.png]]
##### OSI 7계층
* Upper Layer

| 계층        | 설명                                     |
| --------- | -------------------------------------- |
| 애플리케이션 계층 | 응용 소프트웨어 프로토콜(Telnet, FRP 전자 우편용 프로토콜) |
| 프레젠테이션 계층 | 데이터의 입력, 표시, 제어, 코드화(SMTP 등)           |
| 세션 계층     | 세션의 설정, 결합, 해방,. 데이터 송수신(TFTP 등))      |
| 트랜스포트 계층  | 데이터 송/수신 간의 흐름, 에러 제어 및 관리(TCP, UDP 등) |
|           |                                        |

* Lower Layer

| 계층        | 설명                                              |
| --------- | ----------------------------------------------- |
| 네트워크 계층   | 데이터 송/수신 경로 설정(IP등)                             |
| 데이터 링크 계층 | 데이터 패킷 형성(예: MAC), 전송(예: CSMA/CD), 에러체크(예: CRC) |
| 물리적 계층    | 데이터 교환을 위한 물리적 장치(케이블, 커넥터 등)                   |

##### TCP/IP
TCP/IP는 TCP(Transmission Control Protocol)와 IP(Internet Protocol)를 동시에 지칭하는 것이다. TCP/IP는 일관성 있고 널리 사용 가능한 사용자 서비스를 위해서 표준화 된 높은 레벨의 프로토콜이다.


### 6.2 네트워크 설정
### 6.3 네트워크 관련 명령어
#### 6.3.1 ip :  통합 네트워크 설정 프로그램
```
// 네트워크 연결 확인
# ip link //네트워크에 연결되지 않았다면 state DOWN으로 나타난다.

// 네트워크 IP 확인
# ip addr
// 네트워크 IPv4 확인
# ip -4 addr

// 라우팅 테이블 확인
# ip route

// 네트워크 모니터링??
# ip monitor

// TCP 통계
# ip tcp_metrics
```

#### 6.3.1 ip :  통합 네트워크 설정 프로그램
```
// 서버에 설치된 모든 네트워크 인터페이스의 사용해제와 활성화
# ifconfig

// 특정 네트워크 인터페이스의 사용해제와 활성화
# ifconfig ens33 down //사용 해제
# ifconfig ens33 up   //사용

// 네트워크 환경 설정
# ifconfig ens33 192.168.0.150 netmask 255.255.255.0 braodcast 192.168.0,255 up
```

#### 6.3.1 netstat : 인터페이스 통계 및 기타 정보 확인
netstat는 현재 연결된 네트워크의 연결과 라우팅 테이블, 인터페이스에 대한 통계, 마스커레이딩 연결, 멀티캐스팅 정보 등을 보여준다.

##### 주요 옵션

| 옵션   | 설명                               |
| ---- | -------------------------------- |
| `-a` | 모든 소켓을 표시 (리슨 중인 소켓 포함)          |
| `-t` | TCP 프로토콜 소켓만 표시                  |
| `-u` | UDP 프로토콜 소켓만 표시                  |
| `-n` | 숫자로 된 주소와 포트 번호를 표시 (DNS 해석 안 함) |
| `-l` | 리슨 상태의 소켓만 표시                    |
| `-p` | 소켓과 연결된 프로세스 ID(PID)와 이름을 표시     |
| `-r` | 라우팅 테이블을 표시                      |
| `-e` | 확장된 정보를 표시 (예: 인터페이스의 추가 정보)     |
| `-s` | 각 프로토콜의 통계를 표시                   |
| `-c` | 지정한 간격마다 반복적으로 업데이트              |

##### 인터페이스의 표시
```
# netstat -i
```

##### 라우팅 정보 출력하기
```
# netstat -rn
```

##### 열려진 소켓들 출력하기
```
# netstat
```

##### ping : 원격 호스트 응답 테스트
```
# ping -c 3 192.168.43.128
```
##### nslookup : 도메인 네임 서버 질의
```
# nslookup naver.com
```

## Chapter 07 사용자 그룹 관리
### 7.1 사용자 관리

| 명령어        | 설명                            | 사용 예시                                   |
| ---------- | ----------------------------- | --------------------------------------- |
| `useradd`  | 새 사용자 계정을 생성합니다.              | `useradd username`                      |
| `userdel`  | 사용자 계정을 삭제합니다.                | `userdel username`                      |
| `usermod`  | 사용자 계정을 수정합니다.                | `usermod -aG groupname username`        |
| `passwd`   | 사용자 계정의 비밀번호를 변경합니다.          | `passwd username`                       |
| `groupadd` | 새 그룹을 생성합니다.                  | `groupadd groupname`                    |
| `groupdel` | 그룹을 삭제합니다.                    | `groupdel groupname`                    |
| `groupmod` | 그룹을 수정합니다.                    | `groupmod -n newgroupname oldgroupname` |
| `gpasswd`  | 그룹 비밀번호를 설정하거나 그룹 관리자를 지정합니다. | `gpasswd -a username groupname`         |
| `id`       | 사용자의 UID, GID 및 그룹 정보를 출력합니다. | `id username`                           |
| `groups`   | 사용자가 속한 그룹을 표시합니다.            | `groups username`                       |
| `chown`    | 파일이나 디렉토리의 소유자 및 그룹을 변경합니다.   | `chown owner:group filename`            |
| `chgrp`    | 파일이나 디렉토리의 그룹을 변경합니다.         | `chgrp groupname filename`              |
| `newgrp`   | 현재 세션의 기본 그룹을 변경합니다.          | `newgrp groupname`                      |



### 7.2 그룹 관리
##### 사용자 추가
```
// 자동 생성
# useradd woohyuk1
# passwd woohyuk1
```

```
// 수동 생성
# useradd woohyuk1 -c "신우혁" -s /bin/bash -m -d /home/woohyuk1 -u 1003 -g 1003
```

| 설명                 | 명령어                 |
| ------------------ | ------------------- |
| 이름(F)              | -c 이름               |
| 로그인 쉘(L)           | -s 쉘                |
| 홈디렉토리 생성(H)        | -d 홈 디렉토리           |
| 사용자의 개인 그룹 생성(G)   | 기본 생성, -N : 생성하지 않음 |
| 수동으로 사용자 아이디 지정(G) | -u UID              |
| 수동으로 그룹 ID 지정(R)   | g GID               |

##### 사용자 추가 시 홈 디렉토리에 생성되는 파일 
```
[root@localhost ~]# ls -al /home/woohyuk1/
total 12
drwx------. 3 woohyuk1 woohyuk1  78 Jul 22 19:38 .
drwxr-xr-x. 4 root     root      36 Jul 22 19:38 ..
-rw-r--r--. 1 woohyuk1 woohyuk1  18 Apr  1  2020 .bash_logout
-rw-r--r--. 1 woohyuk1 woohyuk1 193 Apr  1  2020 .bash_profile
-rw-r--r--. 1 woohyuk1 woohyuk1 231 Apr  1  2020 .bashrc
drwxr-xr-x. 4 woohyuk1 woohyuk1  39 Jul 22 11:43 .mozilla
```

##### 계정정보 확인
```
chage -l woohyuk1
```
### 7.3 관리자 권환
##### root 권한으로 전환 
* ###### sudo (SuperUser Do) : 현재 계정에서 단순히 root의 권한을 빌려 명령어를 실행하기 위함.
```
$ sudo [COMMNAND]
```

* ###### su (Switch User) : 계정을 전환하기 위함.
```
$ su - // root 사용자로 전환된다.

$ su   // root 사용자의 환경변수를 읽어오지 않아 root 전용 명령어를 찾지 못하는 경우가 발생.
       // 현재 계정의 환경변수를 사용.

// sudo로 전환 했을 때와 다른 것은 root 사용자로 전환과 동시에 root 사용자의 홈 디렉토리로 현재 디렉토리가 바귄다는 것이다. 
```
## Chapter 08 파일 및 디렉토리 관리
### 8.1 파일 브라우저 노틸러스
```
$ nautilus
```
![[Pasted image 20240723074838.png]]
### 8.2 파일관리자 mc(Midnight Commander)
yum 안됨
### 8.3 명령어 공통부분 및 사전 지식
#### 8.3.1 명령어 구조
```
// 명령어 규칙
명령어 [옵션...] [인자...]
명령어 [옵션...] 명령 [인자...]

// 공통 옵션
-h, --help : 명령어 사용법
-v : 자세한(verbose) 출력
-f : 강제실행
-v, --version : 명령어의 버전정보
```

#### 8.3.2 와일드 카드
| 와일드 카드 | 설명                  |
| ------ | ------------------- |
| ?      | 어떤 문자이던지 한 문자       |
| *      | 어떤 문자도 없거나 그 이상인 경우 |
| []     | [] 내에 지정된 각각의 문자    |
* [a-d] 로 표시하면 a, b, c, d 각각을 의미
* [ac]와 같이 비연속적 문자의 지정 가능
* [abcd]* 로 표시하면 a, b, c, d로 시작하는 모든 파일
* [rst]? 로 표시하면 r, s, t로 시작하고 다음에 하나의 문자가 오는 모든 파일

#### 8.3.4 파이프 라인(Pipeline)
```
// 파이프라인 형식
[ ! ] command [ [||&] commnad2 ... ]
```

```
$ df | grep dev

```

```
$ cat errFileasdf
cat: errFileasdf: No such file or directory

$ cat errFileasdf |echo echoCommand
echoCommand
cat: errFileasdf: No such file or directory

$ cat errFileasdf |echo echoCommand ; echo $?
echoCommand
cat: errFileasdf: No such file or directory
0

// 실행 순서는 cat, echo가 되지만 오류 메세지 출력은 echo, cat 순으로 된 갓을 확인 할 수 있다. 그리고 명령어의 종료 상태값(echo $)은 정상 실행되었기 때문에 정상 종료 0이 된다.
```

#### 8.3.5 기타 ( ||, &&, ;, &)
#### 8.3.6 디렉토리 구조
| 기호  | 설명             |
| --- | -------------- |
| .   | 현재 디렉토리        |
| ..  | 부모 디렉토리        |
| ~   | 현재 사용자의 홈 디렉토리 |

#### 8.3.8 파일의 접근 권한 및 소유
##### 소유권
```
$ ls -l ./testtxt.txt
-rw-rw-r--. 1 whshin whshin 0 Jul 23 08:36 ./testtxt.txt
// 세 번째 필드가 이 파일에 대한 소유권을 가진 사용자 정보
// 네 번째 필드가 이 파일에 소유권을 가진 그룹 정보
```

##### 퍼미션

| 권한 기호 | 설명    | 파일에 대한 의미       | 디렉토리에 대한 의미              |
| ----- | ----- | --------------- | ------------------------ |
| `r`   | 읽기    | 파일 내용을 읽을 수 있음  | 디렉토리의 파일 목록을 볼 수 있음      |
| `w`   | 쓰기    | 파일 내용을 변경할 수 있음 | 디렉토리 안에 파일을 생성, 삭제할 수 있음 |
| `x`   | 실행    | 파일을 실행할 수 있음    | 디렉토리를 탐색할 수 있음           |
| `-`   | 권한 없음 | 해당 작업을 수행할 수 없음 | 해당 작업을 수행할 수 없음          |

##### 퍼미션 변경 명령어

* `chmod` 명령어를 사용하여  퍼미션 변경 예시.

```
// 파일에 모든 사용자에 대해 읽기, 쓰기, 실행 권한을 설정 
# chmod 777 filename  

// 소유자에게 읽기, 쓰기, 실행 권한을 설정하고 그룹과 기타 사용자에게 읽기 권한만 설정 
# chmod 744 filename  

// 소유자와 그룹에게 읽기, 쓰기 권한을 설정하고 기타 사용자에게는 권한을 주지 않음 
# chmod 660 filename
```

```

#쉘 스크립트 생성 시 (.sh)

755권한을 줄 것

```


* 숫자 형식 계산

- 읽기(r) = 4
- 쓰기(w) = 2
- 실행(x) = 1

위 값을 합산하여 각 사용자 그룹(소유자, 그룹, 기타 사용자)에 대한 권한을 설정합니다. 예를 들어, `chmod 754 filename`는 소유자에게 `rwx` (4+2+1=7), 그룹에게 `r-x` (4+1=5), 기타 사용자에게 `r--` (4=4) 권한을 부여.

##### 허가권
```
$ ls -l
total 0
drwxr-xr-x. 2 whshin whshin 6 Jul 22 11:58 Desktop
drwxr-xr-x. 2 whshin whshin 6 Jul 22 11:58 Documents
drwxr-xr-x. 2 whshin whshin 6 Jul 22 11:58 Downloads
drwxr-xr-x. 2 whshin whshin 6 Jul 22 11:58 Music
drwxr-xr-x. 2 whshin whshin 6 Jul 22 11:58 Pictures
drwxr-xr-x. 2 whshin whshin 6 Jul 22 11:58 Public
drwxr-xr-x. 2 whshin whshin 6 Jul 22 11:58 Templates
-rw-rw-r--. 1 whshin whshin 0 Jul 23 08:36 testtxt.txt
drwxr-xr-x. 2 whshin whshin 6 Jul 22 11:58 Videos
```

* 퍼미션 부분

| -     | r w -  | r - x    | r - x      |
| ----- | ------ | -------- | ---------- |
| 파일 유형 | 소유자 권한 | 그룹소속자 권한 | 일반다른사용자 권한 |

* 파일 유형

| 기호  | 파일 유형           | 설명                                  |
| --- | --------------- | ----------------------------------- |
| `-` | 일반 파일           | 텍스트 파일, 바이너리 파일, 데이터 파일 등 일반적인 파일   |
| `d` | 디렉토리            | 디렉토리(폴더)                            |
| `l` | 심볼릭 링크          | 다른 파일을 가리키는 링크                      |
| `c` | 문자 장치 파일        | 문자 단위로 데이터를 처리하는 장치 파일 (예: 터미널)     |
| `b` | 블록 장치 파일        | 블록 단위로 데이터를 처리하는 장치 파일 (예: 하드 드라이브) |
| `s` | 소켓              | 네트워크 소켓 파일                          |
| `p` | FIFO(이름 있는 파이프) | FIFO 파일                             |

##### 파일 속성
```
// 파일의 속성을 변경합니다.
$ chattr
```

| 옵션   | 설명                                      | 예시                   |
| ---- | --------------------------------------- | -------------------- |
| `+a` | 파일에 추가 모드 설정 (파일에 데이터를 추가할 수만 있고 수정 불가) | `chattr +a filename` |
| `+i` | 파일을 변경할 수 없도록 설정 (삭제, 이름 변경, 링크 생성 불가)  | `chattr +i filename` |
| `-a` | 파일의 추가 모드 해제                            | `chattr -a filename` |
| `-i` | 파일의 변경 금지 속성 해제                         | `chattr -i filename` |
| `+A` | 파일이 마지막 액세스 시간 수정하지 않도록 설정              | `chattr +A filename` |
| `+c` | 파일을 자동으로 압축하도록 설정                       | `chattr +c filename` |
| `+d` | 파일이 백업에서 제외되도록 설정                       | `chattr +d filename` |
| `+e` | 확장 속성을 사용하도록 설정                         | `chattr +e filename` |
| `+s` | 파일이 삭제될 때 안전하게 지우도록 설정                  | `chattr +s filename` |
| `+u` | 파일이 삭제될 때 복구 가능하도록 설정                   | `chattr +u filename` |

```
// 파일의 속성을 표합니다.
$ lsattr
```

| 옵션   | 설명                      | 예시                   |
| ---- | ----------------------- | -------------------- |
| `-a` | 모든 파일과 디렉토리의 속성을 표시     | `lsattr -a`          |
| `-d` | 디렉토리 자체의 속성을 표시 (내용 제외) | `lsattr -d dirname`  |
| `-R` | 하위 디렉토리를 재귀적으로 표시       | `lsattr -R`          |
| `-v` | 파일의 버전을 표시              | `lsattr -v filename` |

### 8.4 파일 및 디렉토리 관리 명령어
#### 8.4.1 pwd, realpath : 현재 작업 디렉토리 위치 확인
##### pwd(Print Working Directory)
```
$ pwd
/home/whshin
```

##### realpath\
```
$ cd /bin

$ pwd
/bin

$ realpath
/usr/bin
```

#### 8.4.2 cd : 작업 디렉토리의 이동 
##### cd(Change Directory)
```
// 기본 사용법
cd [-L|[-P [-e]]] [dir]
```

| 명령어                | 설명                        | 예시                      |
| ------------------ | ------------------------- | ----------------------- |
| `cd`               | 사용자의 홈 디렉토리로 이동           | `cd`                    |
| `cd ~`             | 사용자의 홈 디렉토리로 이동           | `cd ~`                  |
| `cd /`             | 루트 디렉토리로 이동               | `cd /`                  |
| `cd ..`            | 현재 디렉토리의 부모 디렉토리로 이동      | `cd ..`                 |
| `cd ../..`         | 현재 디렉토리의 상위 두 단계 디렉토리로 이동 | `cd ../..`              |
| `cd -`             | **이전 작업 디렉토리로 이동**        | `cd -`                  |
| `cd /path/to/dir`  | 지정한 절대 경로의 디렉토리로 이동       | `cd /usr/local/bin`     |
| `cd relative/path` | 현재 디렉토리를 기준으로 상대 경로로 이동   | `cd projects/myproject` |
| `cd ~/dir`         | 홈 디렉토리를 기준으로 경로 이동        | `cd ~/Documents`        |
| `cd ./dir`         | 현재 디렉토리를 기준으로 경로 이동       | `cd ./scripts`          |

##### 심볼릭 링크로 연결된 디렉토리의  원본 디렉토리로 이동
```
$ cd /bin
$ pwd
/bin

// 심볼릭 링크로 연결된 디렉토리의 원본 디렉토리로 이동하기 위해서는 -P옵션을 사용한다.
$ cd -P /bin
$ pwd
/usr/bin
```

#### 8.4.3 ls : 파일목록 보기
##### ls
```
// 기본 사용법
ls [<옵션>] ... [<파일>]

ls -al 
# c.f. ll

ls -altr
```

| 옵션        | 설명                                    | 예시           |
| --------- | ------------------------------------- | ------------ |
| `-a`      | 숨김 파일을 포함한 모든 파일을 표시                  | `ls -a`      |
| `-l`      | 상세한 정보를 포함한 목록 형식으로 표시                | `ls -l`      |
| `-h`      | 사람이 읽기 쉬운 형식으로 파일 크기를 표시 (KB, MB, GB) | `ls -lh`     |
| `-R`      | 하위 디렉토리를 재귀적으로 표시                     | `ls -R`      |
| `-t`      | 수정 시간 기준으로 정렬                         | `ls -t`      |
| `-r`      | 역순으로 정렬                               | `ls -r`      |
| `-S`      | 파일 크기 기준으로 정렬                         | `ls -S`      |
| `-d`      | 디렉토리 자체를 표시 (내용을 표시하지 않음)             | `ls -d`      |
| `-1`      | 각 파일을 한 줄씩 표시                         | `ls -1`      |
| `-F`      | 파일 유형을 나타내는 기호를 파일 이름 뒤에 추가           | `ls -F`      |
| `-i`      | 각 파일의 inode 번호를 표시                    | `ls -i`      |
| `-n`      | 소유자와 그룹을 이름 대신 UID와 GID로 표시           | `ls -n`      |
| `-p`      | 디렉토리 이름 뒤에 슬래시(`/`) 추가                | `ls -p`      |
| `--color` | 파일 유형에 따라 색상을 구분하여 표시                 | `ls --color` |
| `-X`      | 파일 확장자 기준으로 정렬                        | `ls -X`      |
| `-A`      | `.` 및 `..`을 제외한 모든 숨김 파일을 표시          | `ls -A`      |
| `-G`      | 그룹 이름을 표시하지 않음                        | `ls -G`      |

#### 8.4.4 tree : 파일 및 디렉토리 트리 보기
#### 8.4.5 touch : **파일 생성, 날짜 시간정보 변경

#### 8.4.6 mkdir : 디렉토리 생성
##### mkdir (Make Directory)
```
// 기본 사용법
mkdir [OPTION]... DIRECTORY...
```

```
$ mkdir test
$ ls
Desktop  Documents  Downloads  Music  Pictures  Public  Templates  test  test.sh  testtxt.txt  Videos
```

##### -p 옵션
```
$ mkdir /a/b/c
// '/a/b/c' 디렉토리를 만들 수 없습니다: 그런 파일이나 디렉터리가 없습니다.

$ mkdir -p /a/b/c
$ ls -d /a/b/c
/a/b/c
```

##### -m 옵션
```
$ mkdir -m 700 testDir2
$ ls -ld testDir2/

// testDir2 디렉토릴를 생성하고, 퍼미션은 700으로 할당.
// 700은 소유자 본인만 접근하고, 읽고, 쓸 수 잇는 권한.
```

#### 8.4.7 cp : 파일 및 디렉토리 복사
```bash
cp -R 
```
#### 8.4.8 mv : 파일 및 디렉토리 이동, 이름 변경
##### mv (Move)
* ###### 파일 이동
```
// 기본 사용법
mv [OPTION]... [-T] SOURCE DEST

mv [OPTION]... SOURCE...  DIRECTORY

mv [OPTION]... -t DIRECTORY SOURCE...
```

```
// mv 파일 디렉토리
$ mv testtxt.txt test
$ cd test
$ ls
testtxt.txt
```

* ###### 파일 이름 변경
```
// 파일명 변경
$ mv testtxt.txt test.txt
$ ls
test.txt
```

| 옵션                | 설명                              | 예시                                       |
| ----------------- | ------------------------------- | ---------------------------------------- |
| `-f`              | 대상 파일을 덮어쓸 때 확인하지 않음            | `mv -f source.txt target.txt`            |
| `-i`              | 대상 파일을 덮어쓸 때 확인 메시지 표시          | `mv -i source.txt target.txt`            |
| `-n`              | 대상 파일이 있을 경우 덮어쓰지 않음            | `mv -n source.txt target.txt`            |
| `-u`              | 대상 파일이 존재하지 않거나 더 최신 파일일 때만 덮어씀 | `mv -u source.txt target.txt`            |
| `-v`              | 이동 및 이름 변경 작업을 상세히 설명           | `mv -v source.txt target.txt`            |
| `-b`              | 대상 파일이 존재할 경우 백업본 생성            | `mv -b source.txt target.txt`            |
| `--backup`        | 백업본 생성, 백업 접미사를 지정할 수 있음        | `mv --backup source.txt target.txt`      |
| `--suffix=SUFFIX` | 백업 파일에 사용할 접미사 지정 (기본은 `~`)     | `mv --suffix=.bak source.txt target.txt` |
| `-t`              | 파일을 지정한 디렉토리로 이동                | `mv -t target_dir source1 source2`       |
| `--help`          | 도움말 출력                          | `mv --help`                              |
| `--version`       | 버전 정보 출력                        | `mv --version`                           |

#### 8.4.9 rename : 파일 및 디렉토리 이름 변경
#### 8.4.10 rm : 파일 및 디렉토리 삭제
```bash
#해보세요
rm -rf /

#1
ls [delete_target]

# [delete_target] 복사 붙여넣기
rm [delete_target]
```
#### 8.4.11 rmdir : 디렉토리 삭제
#### 8.4.12 **.find : 파일 및 디렉토리 검색**
#### 8.4.13 du : **파일 및 디렉토리 용량 확인**
#### 8.4.14 file : 파일 종류 확인
#### 8.4.15 stat : 파일 및 파일 시스템 상태 표시
#### 8.4.16 tar : 파일 및 디렉토리 묶기
##### tar
```
// 기본 사용법
tar [OPTION] FILEDSET FILESRC...

tar [OPTION] FILEDSET DIRECORY...
```

| 옵션                   | 설명                        | 예시                                                    |
| -------------------- | ------------------------- | ----------------------------------------------------- |
| `-c`                 | 새로운 아카이브 파일을 생성           | `tar -cvf archive.tar file1 file2`                    |
| `-x`                 | 아카이브 파일을 추출               | `tar -xvf archive.tar`                                |
| `-t`                 | 아카이브 파일의 내용을 나열           | `tar -tvf archive.tar`                                |
| `-v`                 | 자세한 정보를 출력                | `tar -cvf archive.tar file1 file2 -v`                 |
| `-f`                 | 아카이브 파일 이름을 지정            | `tar -cvf archive.tar file1 file2`                    |
| `-z`                 | gzip으로 압축 또는 해제           | `tar -czvf archive.tar.gz file1 file2`                |
| `-j`                 | bzip2로 압축 또는 해제           | `tar -cjvf archive.tar.bz2 file1 file2`               |
| `-J`                 | xz로 압축 또는 해제              | `tar -cJvf archive.tar.xz file1 file2`                |
| `-C`                 | 지정한 디렉토리로 변경              | `tar -xvf archive.tar -C /target/directory`           |
| `-r`                 | 기존 아카이브에 파일 추가            | `tar -rvf archive.tar newfile`                        |
| `--delete`           | 아카이브에서 파일 삭제              | `tar --delete -f archive.tar file1`                   |
| `--strip-components` | 경로에서 지정된 수만큼의 상위 디렉토리 제거  | `tar -xvf archive.tar --strip-components=1`           |
| `-W`                 | 아카이브 파일의 무결성을 검사          | `tar -Wvf archive.tar`                                |
| `--exclude`          | 아카이브에서 특정 파일 또는 디렉토리 제외   | `tar -cvf archive.tar --exclude=file1 dir`            |
| `-k`                 | 덮어쓰기를 방지                  | `tar -xvkf archive.tar`                               |
| `--wildcards`        | 와일드카드 패턴을 사용하여 아카이브 내용 선택 | `tar -xvf archive.tar --wildcards "*.txt"`            |
| `--transform`        | 파일명을 변환하여 아카이브에 저장        | `tar -cvf archive.tar --transform='s/orig/new/' file` |
* ###### 예시 사용법
```
// 새로운 아카이브 파일 생성
`tar -cvf archive.tar file1 file2`

// gzip으로 압축하여 새로운 아카이브 파일 생성
`tar -czvf archive.tar.gz file1 file2`

// 아카이브 파일 추출
`tar -xvf archive.tar`

// gzip 압축된 아카이브 파일 추출
`tar -xzvf archive.tar.gz`

// 아카이브 파일의 내용을 나열
`tar -tvf archive.tar`

// 지정한 디렉토리로 아카이브 파일 추출
`tar -xvf archive.tar -C /target/directory`

// 기존 아카이브에 파일 추가
`tar -rvf archive.tar newfile`

// 아카이브에서 파일 삭제
`tar --delete -f archive.tar file1`

// 아카이브에서 특정 파일 또는 디렉토리 제외
`tar -cvf archive.tar --exclude=file1 dir`
```

#### 8.4.17 gzip : 파일 압축
#### 8.4.18 bzip2 : 파일 압축
#### 8.4.19 xz : 파일 압축
#### 8.4.20 chmod : 파일 권한 바꾸기
#### 8.4.21 **chown** : 파일 소유자 변경
```bash
chown root:root ./* -R
```

#### 8.4.22 chgrp : 소유 그룹 변경
#### 8.4.23 umask : 파일 퍼미션 마스크


## Chapter 09 파일 편집
### 9.1 gedit 텍스트 편집기(GUI)
### 9.2 vi 텍스트 편집기
 * ###### 편집하기
```
$ vi [파일이름]

// 읽기 전용 모드
$ vi -R [파일이름]

// 읽기 전용 모드로 파일을 열어서 파일의 편집까지 하고싶다면,
$ :view [파일이름]
```

* ###### 종료하기
```
// 종료
:q 입력 후 <Enter>

// 편집 중인 상태에서 종료
<Esc> 키를 누르고 :wq

// 파일명을 지정하여 저장하고 종료하는 경우
:wq <파일명>

// 여기서 w는 저장을, q는 종료, q!는 강제종료를 의미한다.
```

* ###### 임시파일 (vi를 시작하면 ".파일명.swp"과 같은 임시파일을 사용한다.)
```
// 모든 임시파일의 목록을 출력
$ vi -r

// 지정한 임시파일을 불러들임
$ vi -r [파일이름]
```


 * ###### vi 기초 명령
###### 모드 전환 명령어

| 명령어   | 설명           | 예시    |
| ----- | ------------ | ----- |
| `i`   | 입력 모드로 전환    | `i`   |
| `Esc` | 명령 모드로 전환    | `Esc` |
| `:`   | 명령 라인 모드로 전환 | `:`   |

###### 파일 조작 명령어

|명령어|설명|예시|
|---|---|---|
|`:w`|현재 파일 저장|`:w`|
|`:q`|vi 종료|`:q`|
|`:wq`|저장하고 종료|`:wq`|
|`:q!`|변경 사항 저장하지 않고 종료|`:q!`|
|`:e filename`|다른 파일 열기|`:e example.txt`|
|`:w filename`|다른 이름으로 저장|`:w newfile.txt`|

###### 커서 이동 명령어

| 명령어  | 설명           | 예시    |
| ---- | ------------ | ----- |
| `h`  | 왼쪽으로 한 칸 이동  | `h`   |
| `j`  | 아래로 한 줄 이동   | `j`   |
| `k`  | 위로 한 줄 이동    | `k`   |
| `l`  | 오른쪽으로 한 칸 이동 | `l`   |
| `0`  | 행의 처음으로 이동   | `0`   |
| `$`  | 행의 끝으로 이동    | `$`   |
| `gg` | 파일의 처음으로 이동  | `gg`  |
| `G`  | 파일의 끝으로 이동   | `G`   |
| `:n` | n번째 줄로 이동    | `:10` |

###### 텍스트 편집 명령어

| 명령어  | 설명                  | 예시   |
| ---- | ------------------- | ---- |
| `x`  | 커서 위치의 문자를 삭제       | `x`  |
| `dd` | 현재 줄을 삭제            | `dd` |
| `yy` | 현재 줄을 복사            | `yy` |
| `p`  | 복사한 내용을 커서 아래에 붙여넣기 | `p`  |
| `u`  | 마지막 작업을 되돌리기        | `u`  |
| `r`  | 커서 위치의 문자를 교체       | `r`  |
| `cw` | 단어를 수정              | `cw` |
| `cc` | 현재 줄을 수정            | `cc` |

###### 검색 및 치환 명령어

| 명령어             | 설명                     | 예시              |
| --------------- | ---------------------- | --------------- |
| `/pattern`      | 아래 방향으로 패턴 검색          | `/search_term`  |
| `?pattern`      | 위 방향으로 패턴 검색           | `?search_term`  |
| `n`             | 같은 방향으로 다음 검색 결과로 이동   | `n`             |
| `N`             | 반대 방향으로 다음 검색 결과로 이동   | `N`             |
| `:s/old/new`    | 현재 줄에서 첫 번째로 매칭된 패턴 치환 | `:s/old/new`    |
| `:s/old/new/g`  | 현재 줄에서 모든 매칭된 패턴 치환    | `:s/old/new/g`  |
| `:%s/old/new/g` | 파일 전체에서 모든 매칭된 패턴 치환   | `:%s/old/new/g` |

```
# visible number
:se nu 

# hide line number
:se nonu

# point line
:70 

```
### 9.3 nano 텍스트 편집기
### 9.4 mcedit 택스트 편집기
### 9.5 파일 편집 명령어
#### 9.5.1 cat : 파일 내용 출력

#### 9.5.2 more : 파일 내용 끊어보기
#### 9.5.3 less : 파일 내용 보기 및 검색
#### 9.5.4 head : 파일 앞부분 출력
#### 9.5.5 tail : 파일 뒷부분 출력
#### 9.5.6 cmp : 파일 내용 비교
#### 9.5.7 comm : 파일 내용 비교
#### 9.5.8 diff : 파일 내용 비교
#### 9.5.9 wc : 파일 내용통계
#### 9.5.10 cut : 파일 각 라인 필드 출력
#### 9.5.11 grep : 패턴 매칭 라인 출력
##### grep(Globally find Regular-Expression and Print) 
지정된 파일 내의 특정 문자나 단어를 검색하는 명령어로서 파일 편집이나 특정 문자를 포함한 단어를 찾는데 유욯하다.

###### 기본 정규 표현식 (Basic Regular Expressions, BRE)

|정규 표현식|설명|예시|
|---|---|---|
|`.`|임의의 단일 문자|`gr.p` (e.g., `grep 'gr.p' file`)|
|`*`|0회 이상 반복|`lo*` (e.g., `grep 'lo*' file`)|
|`^`|문자열의 시작|`^start` (e.g., `grep '^start' file`)|
|`$`|문자열의 끝|`end$` (e.g., `grep 'end$' file`)|
|`[...]`|문자 클래스, 대괄호 안의 문자 중 하나|`[abc]` (e.g., `grep '[abc]' file`)|
|`[^...]`|문자 클래스의 보수, 대괄호 안의 문자를 제외한 것|`[^0-9]` (e.g., `grep '[^0-9]' file`)|
|`a|b`|`a` 또는 `b`|
|`a{n}`|`a`가 정확히 `n`회 반복|`o{2}` (e.g., `grep 'o{2}' file`)|
|`a{n,}`|`a`가 최소 `n`회 반복|`o{2,}` (e.g., `grep 'o{2,}' file`)|
|`a{n,m}`|`a`가 최소 `n`회, 최대 `m`회 반복|`o{2,4}` (e.g., `grep 'o{2,4}' file`)|

###### 확장 정규 표현식 (Extended Regular Expressions, ERE)

| 정규 표현식         | 설명                             | 예시                                                       |
| -------------- | ------------------------------ | -------------------------------------------------------- |
| `?`            | 0회 또는 1회 반복                    | `gr?` (e.g., `grep 'gr?' file`)                          |
| `+`            | 1회 이상 반복                       | `lo+` (e.g., `grep 'lo+' file`)                          |
| `{n}`          | 정확히 `n`회 반복                    | `o{2}` (e.g., `grep -E 'o{2}' file`)                     |
| `{n,}`         | 최소 `n`회 반복                     | `o{2,}` (e.g., `grep -E 'o{2,}' file`)                   |
| `{n,m}`        | 최소 `n`회, 최대 `m`회 반복            | `o{2,4}` (e.g., `grep -E 'o{2,4}' file`)                 |
| `(a            | b)`                            | `a` 또는 `b`                                               |
| `(?:...)`      | 비캡처 그룹                         | `(?                                                      |
| `(?<name>...)` | 이름이 있는 캡처 그룹                   | `(?<year>\d{4})` (e.g., `grep -P '(?<year>\d{4})' file`) |
| `(?<=...)`     | 긍정적 전방탐색 (positive lookbehind) | `(?<=foo)bar` (e.g., `grep -P '(?<=foo)bar' file`)       |
| `(?<!...)`     | 부정적 전방탐색 (negative lookbehind) | `(?<!foo)bar` (e.g., `grep -P '(?<!foo)bar' file`)       |
| `(?=...)`      | 긍정적 후방탐색 (positive lookahead)  | `foo(?=bar)` (e.g., `grep -P 'foo(?=bar)' file`)         |
| `(?!...)`      | 부정적 후방탐색 (negative lookahead)  | `foo(?!bar)` (e.g., `grep -P 'foo(?!bar)' file`)         |

```
$ grep test /home/whshin/test/test.txt
this is test data
```

###### grep 명령어 옵션

| 옵션           | 설명                                                       | 예시                                      |
| ------------ | -------------------------------------------------------- | --------------------------------------- |
| `-i`         | 대소문자 구분 없이 검색                                            | `grep -i 'pattern' file`                |
| `-v`         | 패턴과 일치하지 않는 줄을 출력                                        | `grep -v 'pattern' file`                |
| `-r` or `-R` | 디렉토리와 하위 디렉토리에서 재귀적으로 검색                                 | `grep -r 'pattern' directory`           |
| `-l`         | 패턴이 포함된 파일의 이름만 출력                                       | `grep -l 'pattern' *`                   |
| `-L`         | 패턴이 포함되지 않은 파일의 이름만 출력                                   | `grep -L 'pattern' *`                   |
| `-n`         | 일치하는 줄 번호와 함께 출력                                         | `grep -n 'pattern' file`                |
| `-H`         | 파일 이름과 함께 일치하는 줄을 출력                                     | `grep -H 'pattern' file`                |
| `-h`         | 파일 이름을 제외하고 일치하는 줄만 출력                                   | `grep -h 'pattern' file`                |
| `-c`         | 패턴과 일치하는 줄의 개수만 출력                                       | `grep -c 'pattern' file`                |
| `-o`         | 패턴과 일치하는 부분만 출력                                          | `grep -o 'pattern' file`                |
| `-e`         | 여러 패턴을 검색                                                | `grep -e 'pattern1' -e 'pattern2' file` |
| `-f`         | 파일에서 패턴을 읽어 검색                                           | `grep -f patterns.txt file`             |
| `-w`         | 전체 단어와 일치하는 줄만 출력                                        | `grep -w 'word' file`                   |
| `-x`         | 전체 줄이 패턴과 일치하는 줄만 출력                                     | `grep -x 'exact pattern' file`          |
| `-d`         | 디렉토리에서 파일만 검색 (디렉토리의 내용은 무시)                             | `grep -d skip 'pattern' directory`      |
| `--color`    | 일치하는 부분에 색상 강조                                           | `grep --color 'pattern' file`           |
| `-A num`     | 패턴과 일치하는 줄과 그 아래 `num`줄을 함께 출력                           | `grep -A 3 'pattern' file`              |
| `-B num`     | 패턴과 일치하는 줄과 그 위 `num`줄을 함께 출력                            | `grep -B 3 'pattern' file`              |
| `-C num`     | 패턴과 일치하는 줄과 그 위아래 `num`줄을 함께 출력                          | `grep -C 3 'pattern' file`              |
| `-P`         | Perl 호환 정규 표현식 사용 (리눅스에서는 `grep -P`가 기본적으로 설치되지 않을 수 있음) | `grep -P 'pattern' file`                |

#### 9.5.12 sort : 파일 내용 정렬
#### 9.5.13 split : 파일 자르기

#### git upload