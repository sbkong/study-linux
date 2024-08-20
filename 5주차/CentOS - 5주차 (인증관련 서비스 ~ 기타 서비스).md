# Chapter.17 인증관리 서비스
본 챕터는 사용자 인증(사용자 정보, 그룹 등) 정보를 관리하는 데 사용되는 프로토콜과 리눅스 명령어에 대한 내용이다.
## NIS와 LDAP
- **NIS(Network Information Service)** 는 주로 Unix 시스템 환경에서 네트워크를 통해 사용자, 그룹, 호스트 정보 등을 중앙에서 관리할 수 있도록 하는 서비스이다.이에 따라 NIS는 분산된 여러 컴퓨터 시스템에서 동일한 사용자 및 그룹 정보를 일관되게 사용할 수 있도록 도와준다.

- **LDAP(Lightweight Directory Access Protocol)** 는 디렉토리 서비스를 질의하고 수정하기 위한 응용 계층 프로토콜이다. LDAP는 TCP/IP 네트워크를 통해 디렉토리 정보를 접근하는 표준 프로토콜로, 널리 사용되는 디렉토리 서비스의 기반이다. LDAP는 분산 디렉토리 정보를 쉽게 관리하고 검색할 수 있도록 설계되었으며, 보안, 확장성, 유연성이 뛰어나다.

### NIS 인증 서비스의 개요와 구조
- **NIS의 작동 개요**:
  - NIS는 클라이언트-서버 모델로 동작하며, NIS 서버는 데이터베이스 형태로 사용자, 그룹, 호스트 정보를 저장하는 서비스이다. NIS 클라이언트는 이 정보를 서버에서 가져와 로컬 시스템에서 사용한다.
  - NIS는 단일 도메인에서 모든 정보를 관리하며, 도메인 내의 모든 클라이언트는 동일한 서버에서 데이터를 가져온다. 이를 통해 사용자 및 그룹 정보를 중앙에서 관리할 수 있다.

- **NIS의 구조**:
  - **NIS 서버**는 중앙에 위치하며 모든 사용자 정보, 패스워드, 그룹 정보 등을 관리한다. NIS 서버는 데이터를 관리하고, 클라이언트의 요청에 따라 필요한 데이터를 제공한다.
  - **NIS 클라이언트**는 NIS 서버로부터 데이터를 요청하고 이를 로컬 시스템에서 사용한다. 클라이언트는 정기적으로 서버와 동기화하여 최신 정보를 유지한다.
  - **NIS 맵**은 NIS 서버가 관리하는 데이터베이스 파일로, 예를 들어 `/etc/passwd`, `/etc/group` 등의 파일을 맵 형식으로 관리한다.
### NIS의 Master-Slave 구조![[nis.gif]]

- **NIS의 Master-Slave 구조**는 NIS 서버의 데이터를 중앙에서 관리하고, 이를 여러 클라이언트에 분산하여 제공하기 위한 시스템이다. 이 구조는 중앙의 **Master NIS 서버**와 여러 **Slave NIS 서버**로 구성된다.

- **Master NIS 서버**는 모든 NIS 맵(map)의 원본 데이터를 관리하고, 변경 사항을 작성하거나 갱신하는 역할을 한다. Master 서버는 정기적으로 Slave 서버에 데이터를 전송하여, Slave 서버들이 최신 정보를 유지할 수 있도록 한다.

- **Slave NIS 서버**는 Master 서버로부터 동기화된 NIS 맵의 복사본을 가지고 있다. Slave 서버들은 클라이언트로부터의 요청을 처리하며, Master 서버와 동일한 정보를 제공한다. 이 구조는 부하 분산(load balancing)과 가용성 향상을 위해 사용된다.

### 주요 NIS 명령어들
```bash
# NIS 도메인 이름 설정
# NIS 도메인을 설정하거나 확인할 때 사용된다.
domainname <NIS_DOMAIN_NAME>

# NIS 맵 갱신
# NIS 서버에서 맵을 수동으로 갱신할 때 사용된다. 주로 변경 사항을 적용하기 위해 사용된다.
sudo make -C /var/yp

# NIS 서버 시작
# NIS 서버를 시작하는 명령어이다.
sudo systemctl start nis

# NIS 서버 재시작
# NIS 서버를 재시작하여 설정 변경 사항을 반영할 때 사용된다.
sudo systemctl restart nis

# NIS 서버 상태 확인
# NIS 서버의 현재 상태를 확인할 때 사용된다.
sudo systemctl status nis

# NIS 클라이언트 설정
# 클라이언트에서 NIS 서버에 접속할 도메인과 서버를 설정한다.
sudo ypbind -d <NIS_SERVER>

# NIS 맵 검색
# NIS 맵에서 특정 항목을 검색하는 데 사용된다. 예를 들어, 사용자의 정보를 검색할 수 있다.
ypcat passwd

# NIS 사용자 정보 확인
# 현재 시스템의 사용자 정보를 NIS를 통해 확인할 때 사용된다.
ypmatch <username> passwd
```

### Master-Slave 설정

NIS의 Master-Slave 설정은 중앙의 Master 서버와 여러 Slave 서버 간의 데이터 동기화를 설정하는 작업이다. 이 설정은 NIS 시스템의 확장성 및 가용성을 높이기 위해 사용된다.

```
# <Master 서버 설정>
# NIS 서버의 도메인 설정
domainname <NIS_DOMAIN_NAME>

# NIS 데이터베이스(맵) 생성
cd /var/yp
sudo make

# Slave 서버에 대한 액세스 허용 설정
# /var/yp/Makefile에서 SLAVES 변수를 편집하여 Slave 서버를 지정한다.
# 예:
# SLAVES="slave1 slave2"

# Master에서 Slave로 맵 전송
# 각 Slave 서버에 대한 NIS 맵을 수동으로 전송한다.
sudo yppush -d <NIS_DOMAIN_NAME> <mapname>

# <Slave 서버 설정>
# Slave 서버의 도메인 설정
domainname <NIS_DOMAIN_NAME>

# Slave 서버에서 NIS 데이터베이스 받기
# Master 서버로부터 맵을 받아오는 작업이다.
sudo ypinit -s <MASTER_SERVER>

# NIS 서버 시작
# 설정이 완료된 후 NIS 서버를 시작한다.
sudo systemctl start nis

```
NIS의 Master-Slave 구조를 설정함으로써, Master 서버에서 관리하는 데이터를 Slave 서버에 동기화하여 다수의 클라이언트 요청을 분산 처리할 수 있다. 이를 통해 시스템의 확장성과 안정성을 확보할 수 있다.

### NIS의 취약점
![[3-Figure2-1.png]]
> NIS 서버의 정보를 가로채는 공격자
#### 1. **인증되지 않은 Master-Slave 동기화**:
   - Master 서버와 Slave 서버 간의 데이터 동기화는 기본적으로 인증되지 않는다. 공격자는 Slave 서버를 가장하여 Master 서버로부터 민감한 정보를 획득하거나, Master 서버를 가장하여 Slave 서버에 잘못된 데이터를 전송할 수 있다.
#### 2. **중간자 공격**:
   - Master 서버와 Slave 서버 간의 통신은 암호화되지 않기 때문에, 공격자가 이 통신을 가로채거나 변조할 수 있다. 이로 인해, Master-Slave 구조는 중간자 공격(Man-in-the-Middle Attack)에 매우 취약하다.
#### 3. **Slave 서버의 스푸핑**:
   - 공격자는 합법적인 Slave 서버를 가장하여 클라이언트에게 잘못된 데이터를 제공할 수 있다. 클라이언트는 이 정보를 신뢰하게 되며, 이를 통해 공격자는 시스템에 악의적인 영향을 미칠 수 있다.
#### 4. **분산된 보안 취약점**:
   - 여러 Slave 서버로 데이터를 분산하여 관리하는 구조에서는, 각 Slave 서버의 보안 상태가 전체 시스템의 보안성에 큰 영향을 미친다. 하나의 Slave 서버라도 취약하게 설정되어 있으면, 전체 NIS 시스템이 공격에 노출될 수 있다.
#### 5. **데이터 일관성 문제**:
   - Master 서버와 Slave 서버 간의 동기화가 즉각적으로 이루어지지 않는 경우, 데이터 일관성 문제로 인해 클라이언트가 서로 다른 정보를 받는 상황이 발생할 수 있다. 공격자는 이 틈을 이용해 데이터의 무결성을 해칠 수 있다.
### 결론
NIS의 Master-Slave 구조는 네트워크의 확장성과 가용성을 높이는 데 기여하지만, 기본적인 보안 메커니즘이 부족하여 여러 가지 취약점을 가지고 있다. 이러한 취약점들은 네트워크 환경에서의 보안 위협을 초래할 수 있으므로, NIS를 사용하는 환경에서는 추가적인 보안 조치(예: SSL/TLS 사용, VPN 설정 등)가 필요하다. 현대의 보안 요구 사항을 충족하기 위해서는 LDAP와 같은 대체 기술로의 전환이 권장된다.

### LDAP의 개요와 구조![[스크린샷 2024-08-13 오전 10.43.26.png]]
> LDAP의 동작 방식, NIS와 다르게 각 부분(각 서버나 엔드포인트)을 가리키는 포인터로 분산되어 있다.

- **LDAP의 개요**:
  - LDAP는 디렉토리 서비스에 접근하기 위한 경량화된 프로토콜로, 주로 사용자의 정보, 그룹, 권한 등을 관리하는데 사용되는 서비스이다. LDAP는 조직의 구조를 반영한 트리 형태의 디렉토리 구조를 가지며, 사용자 및 리소스에 대한 계층적 정보를 쉽게 관리할 수 있다.
  - LDAP는 보안 설정, 확장성, 유연한 쿼리 기능을 제공하여, 다양한 환경에서 사용자 인증 및 권한 관리를 수행할 수 있다.

- **LDAP의 구조**:
  - **LDAP 서버**는 디렉토리 정보를 저장하고, 클라이언트의 요청에 따라 정보를 제공하는 역할을 한다. 서버는 디렉토리 정보를 트리 구조로 관리하며, 각 노드는 디렉토리 항목(예: 사용자, 그룹, 조직 단위)을 나타낸다.
  - **LDAP 클라이언트**는 서버에 접근하여 필요한 정보를 검색하거나 수정하는 역할을 한다. LDAP 클라이언트는 주로 인증, 검색, 수정 작업을 수행한다.
  - **LDAP 트리 구조**는 최상위 도메인(Domain Component, DC)을 루트로 하여, 조직 단위(Organizational Unit, OU), 사용자, 그룹 등이 계층적으로 배치되는 구조이다.

### NIS와 LDAP의 차이점

- **중앙 관리 방식**: NIS는 단일 도메인 내에서 사용자 및 그룹 정보를 중앙 관리하는 반면, LDAP는 보다 복잡하고 계층적인 구조(트리)를 제공하여 큰 조직에서도 효율적으로 사용할 수 있는 서비스이다.
  
- **보안**: NIS는 보안 측면에서 비교적 취약하며, 패스워드와 같은 민감한 정보가 암호화되지 않고 전송될 수 있다. 반면 LDAP는 SSL/TLS를 사용하여 보안을 강화할 수 있다.

- **확장성**: NIS는 소규모 네트워크에서 주로 사용되며, 대규모 네트워크에서는 확장성의 한계가 있다. LDAP는 확장성이 뛰어나 대규모 환경에서도 효율적으로 사용할 수 있다.

- **데이터 구조**: NIS는 단순한 키-값 형태의 데이터를 관리하지만, LDAP는 트리 구조를 사용하여 복잡한 계층적 데이터를 관리할 수 있다.
### LDAP의 복제 모델: Provider-Consumer와 Multi-Master

LDAP에서 복제(Replication)는 서버 간에 디렉토리 정보를 동기화하는 방법으로, 두 가지 주요 방식이 있다. "Master-Slave"라는 표현 대신, **Provider-Consumer**와 **Multi-Master Replication (MMR)**이라는 용어가 적절하게 사용된다.

#### Provider-Consumer Replication

- **Provider 서버**는 LDAP 디렉토리 정보를 제공하는 서버로, 과거의 Master 서버 역할에 해당한다.
- **Consumer 서버**는 Provider로부터 데이터를 받아 사용하는 서버로, 과거의 Slave 서버 역할에 해당한다.
- 일방향 복제(unidirectional replication) 방식으로, Consumer 서버는 Provider 서버의 데이터를 읽어오기만 한다.

#### Multi-Master Replication (MMR)

- **Multi-Master Replication**은 여러 서버가 동시에 데이터를 수정할 수 있는 복제 방식이다.
- 각 서버가 다른 서버들과 데이터를 동기화하며, 모든 서버가 동일한 역할을 수행한다.
- 높은 가용성을 제공하지만, 데이터 충돌 관리가 필요하다.

### OpenLDAP를 조작하는 명령어들

OpenLDAP 서비스를 설정하고 관리하기 위한 명령어들이다. 아래 명령어들은 OpenLDAP 서버와 클라이언트 설정, 데이터 관리에 사용된다.
#### 주요 OpenLDAP 명령어들

```bash
# LDAP 서버 상태 확인
# OpenLDAP 서버의 상태를 확인하는 명령어이다.
sudo systemctl status slapd

# LDAP 서버 시작
# OpenLDAP 서버를 시작하는 명령어이다.
sudo systemctl start slapd

# LDAP 서버 재시작
# 설정 변경 사항을 반영하기 위해 OpenLDAP 서버를 재시작할 때 사용된다.
sudo systemctl restart slapd

# LDAP 데이터베이스 검색
# OpenLDAP 데이터베이스에서 특정 항목을 검색하는 데 사용된다.
ldapsearch -x -b "dc=example,dc=com" "(objectClass=*)"

# LDAP 항목 추가
# 새로운 항목을 OpenLDAP 데이터베이스에 추가할 때 사용된다. LDIF 파일을 사용하여 입력한다.
ldapadd -x -D "cn=admin,dc=example,dc=com" -W -f new_entry.ldif

# LDAP 항목 수정
# 기존 항목을 수정할 때 사용되며, LDIF 파일을 통해 변경 사항을 입력한다.
ldapmodify -x -D "cn=admin,dc=example,dc=com" -W -f modify_entry.ldif

# LDAP 데이터베이스 백업
# 현재 OpenLDAP 데이터베이스를 백업하는 명령어이다.
slapcat > backup.ldif

# LDAP 데이터베이스 복원
# 백업된 데이터를 OpenLDAP 데이터베이스에 복원할 때 사용된다.
sudo slapadd -l backup.ldif
```

#### Provier - Consumer 설정
```bash
# Provider 서버 설정

# olcServerID 설정
# Provider 서버의 ID를 설정한다.
ldapmodify -Y EXTERNAL -H ldapi:/// -f provider_serverid.ldif

# SyncProv 모듈 로드
# Provider 서버에서 데이터 동기화를 위한 SyncProv 모듈을 로드한다.
ldapmodify -Y EXTERNAL -H ldapi:/// -f syncprov.ldif

# 동기화 리플리케이션 설정
# Provider 서버에서 데이터베이스 동기화 설정을 진행한다.
ldapmodify -Y EXTERNAL -H ldapi:/// -f provider_syncrepl.ldif

# Consumer 서버 설정

# Consumer 서버의 ID 설정
ldapmodify -Y EXTERNAL -H ldapi:/// -f consumer_serverid.ldif

# 동기화 클라이언트 설정
# Consumer 서버에서 Provider 서버로부터 데이터를 동기화하기 위한 설정을 진행한다.
ldapmodify -Y EXTERNAL -H ldapi:/// -f consumer_syncrepl.ldif

# 초기 데이터베이스 설정
# Provider 서버로부터 초기 데이터를 받아온다.
slapadd -l provider_backup.ldif

# LDAP 서버 시작
# 설정이 완료된 후 OpenLDAP 서버를 시작한다.
sudo systemctl start slapd
```

#### Multi-Master Replication 설정
```bash
# 각 서버에서 Multi-Master 설정을 동일하게 수행

# olcServerID 설정
# 각 서버의 고유 ID를 설정한다.
ldapmodify -Y EXTERNAL -H ldapi:/// -f multimaster_serverid.ldif

# SyncProv 모듈 로드
# 각 서버에서 데이터 동기화를 위한 SyncProv 모듈을 로드한다.
ldapmodify -Y EXTERNAL -H ldapi:/// -f syncprov.ldif

# Multi-Master 동기화 설정
# 각 서버에서 다른 서버들과의 동기화 설정을 진행한다.
ldapmodify -Y EXTERNAL -H ldapi:/// -f multimaster_syncrepl.ldif

# 서버 시작 및 동기화 테스트
# 설정 후 서버를 시작하고, 동기화 상태를 확인한다.
sudo systemctl start slapd
```

# Chapter.18 파일관련 서비스
### SAMBA 파일 관리 시스템

SAMBA는 Windows와 Unix/Linux 시스템 간에 파일과 프린터를 공유할 수 있도록 하는 오픈 소스 소프트웨어이다. SAMBA는 SMB/CIFS(서버 메시지 블록/Common Internet File System) 프로토콜을 구현하여, 이기종 운영 체제 간에 파일 및 프린터 자원을 자유롭게 공유할 수 있게 한다.

#### SAMBA의 주요 기능:
- Windows 네트워크 환경에서 Linux/Unix 파일 시스템을 공유
- Windows 클라이언트에서 Linux/Unix 프린터 접근
- Active Directory 통합을 통한 사용자 인증
- 다중 사용자 지원 및 권한 관리

### SAMBA 서버 동작 과정 예시
SAMBA 서버가 동작하는 과정은 다음과 같다:

1. **클라이언트 요청**:
   - Windows 또는 다른 클라이언트 시스템에서 SAMBA 서버로 파일 또는 프린터 자원에 접근하려고 한다. 클라이언트는 SMB/CIFS 프로토콜을 통해 요청을 전송한다.

2. **SAMBA 서버 수신**:
   - SAMBA 서버는 클라이언트의 요청을 수신한다. 이 요청에는 사용자 인증 정보와 함께 요청된 자원(파일, 폴더, 프린터 등)에 대한 세부 정보가 포함된다.

3. **인증 및 권한 확인**:
   - SAMBA 서버는 클라이언트의 인증 정보를 확인하고, 사용자가 요청한 자원에 접근할 권한이 있는지 검토한다. 이 과정에서 SAMBA는 로컬 사용자 데이터베이스나 Active Directory와 연동될 수 있다.

4. **요청 처리**:
   - 인증이 성공하면, SAMBA 서버는 클라이언트의 요청을 처리하여 파일에 접근하거나, 프린터 작업을 시작한다. 필요 시, SAMBA는 클라이언트에게 데이터를 전송하거나 파일 시스템 작업을 수행한다.

5. **응답 전송**:
   - 요청이 처리된 후, SAMBA 서버는 클라이언트에게 응답을 전송하여, 파일 작업의 성공 여부나 프린터 상태 등을 알린다.

### SAMBA 서버 설치와 관리 (CentOS7)
#### SAMBA 서버 설치 및 설정

```bash
# SAMBA 패키지 설치
# CentOS7에서 SAMBA 서버를 설치하는 명령어이다.
sudo yum install samba samba-client samba-common -y

# SAMBA 설정 파일 편집
# /etc/samba/smb.conf 파일을 편집하여 공유 디렉토리 설정, 네트워크 설정 등을 구성한다.
sudo nano /etc/samba/smb.conf

# 예시: [shared] 섹션을 추가하여 공유 디렉토리를 설정
[shared]
   path = /srv/samba/shared
   browsable =yes
   writable = yes
   guest ok = yes
   read only = no

# SAMBA 사용자 추가
# SAMBA에 새로운 사용자를 추가하고 비밀번호를 설정한다.
sudo smbpasswd -a <username>

# SAMBA 서비스를 위한 디렉토리 생성 및 권한 설정
sudo mkdir -p /srv/samba/shared
sudo chown -R nobody:nobody /srv/samba/shared
sudo chmod -R 0775 /srv/samba/shared
```
#### SAMBA 서버 시작과 종료
```
# SAMBA 서버 시작
# SAMBA 서비스를 시작하는 명령어이다.
sudo systemctl start smb

# SAMBA 서비스 부팅 시 자동 시작 설정
sudo systemctl enable smb

# SAMBA 서버 종료
# SAMBA 서비스를 중지하는 명령어이다.
sudo systemctl stop smb
```
#### SAMBA 서버 접속
```
# SAMBA 공유 디렉토리 접속 (Linux 클라이언트)
# Linux 클라이언트에서 SAMBA 서버에 설정된 공유 디렉토리에 접근하는 명령어이다.
sudo mount -t cifs -o username=<username> //server_ip/shared /mnt/samba

# SAMBA 공유 디렉토리 접속 (Windows 클라이언트)
# Windows 탐색기에서 "\\server_ip\shared" 경로를 입력하여 SAMBA 공유 디렉토리에 접근할 수 있다.
```

### Windows에서 SAMBA 서버 자원을 공유받는 간단한 예시

Windows 클라이언트에서 SAMBA 서버의 자원을 공유받는 방법은 매우 간단하다. 아래는 단계별로 설명한 예시이다.

1. **시작 -> 실행**:
   - 먼저 Windows에서 **시작** 버튼을 클릭한 후, **실행**을 선택한다. 또는 `Windows + R` 키를 눌러 실행 창을 열 수 있다.

2. **주소 입력**:
   - 실행 창이 열리면, 다음과 같이 SAMBA 서버의 네트워크 주소를 입력한다:
     ```
     \\server_ip\shared
     ```
   - 여기서 `server_ip`는 SAMBA 서버의 IP 주소, `shared`는 SAMBA 서버에서 설정한 공유 디렉토리의 이름이다.

3. **사용자 이름과 암호 입력**:
   - SAMBA 서버에 접속하려면 사용자 인증이 필요하다. 사용자 이름과 SAMBA 서버에서 설정한 비밀번호를 입력한다.
   - 만약 SAMBA에서 **guest** 접근이 허용된 경우, 사용자 이름과 비밀번호 없이 접근이 가능하다.

4. **접속 및 파일 관리**:
   - 인증이 완료되면, Windows 탐색기에서 SAMBA 서버의 공유 디렉토리에 접근할 수 있다. 이 디렉토리에서 파일을 복사하거나 이동하는 등의 작업을 할 수 있다.

5. **네트워크 드라이브로 연결(선택 사항)**:
   - 공유 폴더를 자주 사용해야 하는 경우, 네트워크 드라이브로 연결해두면 편리하다. Windows 탐색기에서 "네트워크 드라이브 연결"을 선택하고, `\\server_ip\shared` 경로를 입력하면 된다.

### NFS 서버
![[0_JB8OfDhLqJNduPz6.jpg]]
NFS(Network File System) 서버는 네트워크를 통해 파일 시스템을 공유하기 위해 사용되는 분산 파일 시스템 프로토콜이다. NFS를 통해 사용자는 네트워크에 연결된 원격 서버의 파일을 로컬 디스크처럼 접근하고 사용할 수 있다.

#### NFS 서버의 주요 특징
- **파일 공유**: NFS는 여러 클라이언트 시스템이 동일한 파일 시스템을 공유하고 접근할 수 있도록 한다. 이를 통해 데이터를 중앙에서 관리하고 여러 사용자가 협업할 수 있다.
- **플랫폼 간 호환성**: NFS는 주로 Unix/Linux 시스템에서 사용되지만, Windows 등 다른 운영 체제와도 호환될 수 있다.
- **투명한 접근**: 클라이언트 시스템에서는 NFS 서버의 파일이 로컬 파일 시스템처럼 보이기 때문에, 사용자가 네트워크의 복잡성을 신경 쓰지 않고 파일을 사용할 수 있다.

### NFS 서버 동작 원리

1. **서버 측 설정**: 
   - NFS 서버는 특정 디렉토리를 네트워크를 통해 공유하도록 설정된다. 이 디렉토리는 `export`라고 불리며, `/etc/exports` 파일에서 정의된다.

2. **클라이언트 측 마운트**:
   - NFS 클라이언트는 NFS 서버에서 공유된 디렉토리를 로컬 파일 시스템의 특정 디렉토리에 마운트한다. 마운트된 디렉토리는 클라이언트 시스템에서 마치 로컬 디스크처럼 사용된다.

3. **파일 접근**:
   - 클라이언트는 NFS 서버에 저장된 파일에 읽기 및 쓰기 작업을 수행할 수 있다. NFS는 이 작업을 원격 파일 시스템에 반영하여, 데이터를 일관되게 유지한다.

### NFS 서버 기본 명령어 (CentOS7)

#### NFS 서버 설치 및 설정

```bash
# NFS 서버 설치
# CentOS7에서 NFS 서버를 설치하는 명령어이다.
sudo yum install nfs-utils -y

# NFS 설정 파일 편집
# /etc/exports 파일을 편집하여 공유할 디렉토리와 접근 권한을 설정한다.
sudo nano /etc/exports

# 예시: /srv/nfs/shared 디렉토리를 모든 클라이언트에 대해 읽기/쓰기 권한으로 공유
/srv/nfs/shared  *(rw,sync,no_root_squash,no_subtree_check)

# NFS 서비스 시작
# NFS 서버를 시작하고 부팅 시 자동으로 시작되도록 설정한다.
sudo systemctl start nfs-server
sudo systemctl enable nfs-server

# 방화벽 설정
# NFS 서버가 클라이언트로부터 접근할 수 있도록 방화벽 규칙을 추가한다.
sudo firewall-cmd --permanent --add-service=nfs
sudo firewall-cmd --reload
```

#### NFS 클라이언트 마운트
> NFS로 설정할 디렉토리를 마운트하여 자유롭게 공유할 수 있도록 설정한다.
```
# NFS 클라이언트 마운트
# 클라이언트에서 NFS 서버의 공유 디렉토리를 로컬 디렉토리에 마운트한다.
sudo mount -t nfs server_ip:/srv/nfs/shared /mnt/nfs

# 자동 마운트 설정 (옵션)
# /etc/fstab 파일에 NFS 마운트를 추가하여 부팅 시 자동으로 마운트되도록 설정할 수 있다.
echo "server_ip:/srv/nfs/shared /mnt/nfs nfs defaults 0 0" | sudo tee -a /etc/fstab
```

# Chapter.19 메일관련 서비스
리눅스 자체를 메일 서버로 삼아 작동하는 방법에 대한 내용을 다룬다.
### CentOS7의 메일 관련 서비스
CentOS7에서 메일 서비스는 주로 SMTP, IMAP, POP3와 같은 프로토콜을 통해 메일 송수신을 처리한다. 메일 서버 구성은 여러 도구와 서비스로 이루어지며, 일반적으로 **Postfix**, **Dovecot** 등을 사용하여 SMTP 서버와 IMAP/POP3 서버를 설정한다. 추가적으로, **mutt**와 같은 메일 클라이언트 및 **telnet**과 같은 도구를 사용해 메일 서버의 기능을 테스트할 수 있다.
### Postfix
**Postfix**는 CentOS7에서 기본적으로 제공되는 SMTP 서버 소프트웨어다.
#### 주요 Postfix 명령어
```bash
# Postfix 설치
# CentOS7에서 Postfix를 설치하는 명령어이다.
sudo yum install postfix -y

# Postfix 시작
# Postfix 서비스를 시작하는 명령어이다.
sudo systemctl start postfix

# Postfix 부팅 시 자동 시작 설정
sudo systemctl enable postfix

# Postfix 상태 확인
# Postfix 서비스의 상태를 확인하는 명령어이다.
sudo systemctl status postfix

# Postfix 재시작
# 설정 변경 후 Postfix 서비스를 재시작하는 명령어이다.
sudo systemctl restart postfix
```
#### Postconf
Postconf는 postfix의 설정을 관리하는 명령어이다.
```
# 모든 Postfix 설정을 출력
postconf -n

# 특정 설정 항목의 값을 조회
postconf <parameter_name>

# 특정 설정 항목의 값을 변경
sudo postconf -e '<parameter_name>=<value>'
```

# Chapter.20 가상화 관리
### CentOS7의 가상화 관리 개요

CentOS7에서 가상화는 여러 운영 체제를 단일 물리적 호스트에서 동시에 실행할 수 있게 하는 기술이다. 가상화는 크게 하드웨어 가상화와 데스크탑 가상화로 나눌 수 있다.

### 가상화의 종류
#### 하드웨어 가상화
- **전가상화(Full Virtualization)**: 전가상화는 가상 머신이 실제 하드웨어를 완전히 에뮬레이션하는 방식이다. 가상 머신은 물리적 하드웨어와 동일한 기능을 갖춘 가상 하드웨어를 사용하며, 하이퍼바이저가 이 과정에서 주요 역할을 한다. 운영 체제는 가상화 환경에서 실행되는지 알 수 없다.
  
- **반가상화(Paravirtualization)**: 반가상화는 가상 머신이 가상화 환경을 인지하고, 가상화된 하드웨어에 맞춰 수정된 운영 체제를 사용한다. 이 방식은 전가상화에 비해 성능이 더 우수하지만, 운영 체제를 수정해야 하는 단점이 있다.
#### 데스크탑 가상화
- **데스크탑 가상화**: 데스크탑 가상화는 개인 컴퓨터에서 여러 운영 체제를 동시에 실행하거나, 원격 서버에서 데스크탑 환경을 제공하는 기술이다. 사용자들은 가상화된 환경에서 다른 운영 체제를 실행할 수 있으며, 보통 VMware, VirtualBox 등의 소프트웨어가 사용된다.

### KVM 구축법 (CentOS7)
KVM(커널 기반 가상 머신)은 Linux 커널의 가상화 확장 기능을 활용한 가상화 기술이다. CentOS7에서 KVM을 구축하고 관리하기 위해 다음 단계를 따른다.
#### KVM 설치

```bash
# KVM 패키지 설치
# KVM 및 관련 도구를 설치하는 명령어이다.
sudo yum install -y qemu-kvm libvirt libvirt-python libguestfs-tools virt-install

# libvirtd 서비스 시작
# KVM 관리 서비스를 시작하고, 부팅 시 자동 시작되도록 설정한다.
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

# KVM 설치 확인
# KVM 모듈이 올바르게 로드되었는지 확인한다.
lsmod | grep kvm
```
#### CentOS7에서 KVM 접속
##### virsh 명령어를 통한 접속
`virsh`는 KVM 가상 머신을 관리할 수 있는 명령어 인터페이스이다. `virsh console` 명령을 사용하여 텍스트 기반 콘솔에서 가상 머신에 접속할 수 있다.
   ```bash
   # 가상 머신 목록 확인
   sudo virsh list --all

   # 가상 머신 콘솔 접속
   sudo virsh console <vm_name>
```

#### #### Windows에서 KVM 접속
Windows에서도 KVM 가상 머신에 네트워크를 통해 접속할 수 있다. 주로 사용되는 방법은 VNC(Viewer Network Computing)와 SSH를 활용하는 것이다.
```
# VNC 클라이언트를 설치하고, ip로 접속한다.
IP Address: <KVM_Host_IP>:<VNC_Port>
```
이외에도 putty를 통한 ssh 접속 등을 할 수 있다.

# Chapter.21 기타 서비스
### DNS(Domain Name System)

**DNS(Domain Name System)** 는 인터넷 또는 사설 네트워크에서 도메인 이름을 IP 주소로 변환하는 시스템이다. 예를 들어, 사용자가 `www.example.com`과 같은 도메인 이름을 입력하면, DNS는 이 도메인에 해당하는 IP 주소를 반환하여 사용자가 웹사이트에 접속할 수 있게 한다.
![[IMG_0812.jpeg]]
DNS는 계층적 구조로 구성되어 있으며, 루트 도메인, 최상위 도메인(TLD), 서브도메인으로 구성된다. DNS 서버는 이러한 이름과 IP 주소 간의 매핑 정보를 저장하고 제공하는 역할을 한다. DNS는 인터넷에서 중요한 역할을 하며, 웹사이트 접근, 이메일 전송 등 여러 인터넷 서비스의 기초가 된다.

### DNS 질의 과정: 루트에서 .com 도메인까지
![[IMG_0811.jpeg]]

DNS 질의 과정은 사용자가 입력한 도메인 이름을 IP 주소로 변환하기 위해 DNS 서버 간의 계층적 질의를 거치는 절차이다. 이 과정은 아래와 같이 진행된다:

1. **루트 DNS 서버**:
   - 사용자가 `www.example.com`을 요청하면, 처음으로 DNS 질의는 루트 DNS 서버로 전송된다.
   - 루트 서버는 모든 최상위 도메인(TLD, Top-Level Domain) `.com`, `.org`, `.net` 등의 정보를 가지고 있다.

2. **TLD DNS 서버**:
   - 루트 서버는 요청된 도메인이 `.com`이므로, `.com` TLD를 담당하는 DNS 서버의 주소를 클라이언트에 반환한다.
   - 클라이언트는 이 정보를 받아 `.com` TLD DNS 서버로 질의를 전송한다.

3. **권한 있는 DNS 서버**:
   - `.com` TLD DNS 서버는 `example.com` 도메인에 대한 정보를 가지고 있는 권한 있는(Authoritative) DNS 서버의 주소를 반환한다.
   - 클라이언트는 이 권한 있는 DNS 서버로 질의를 보내 `www.example.com`의 IP 주소를 요청한다.

4. **최종 IP 주소 반환**:
   - 권한 있는 DNS 서버는 `www.example.com`에 대한 정확한 IP 주소를 클라이언트에게 반환한다.
   - 클라이언트는 이 IP 주소를 사용해 `www.example.com` 웹사이트에 접속할 수 있다.

이러한 과정은 매우 빠르게 이루어지며, DNS 서버 간의 협력으로 사용자가 원하는 도메인 이름을 IP 주소로 변환하는 작업이 완료된다.

### 캐싱 DNS 서버 개요

**캐싱 DNS 서버**는 도메인 이름을 IP 주소로 변환하는 과정에서 이전에 조회된 DNS 쿼리의 결과를 저장하고, 같은 쿼리가 들어왔을 때 다시 원래 DNS 서버에 질의하지 않고, 캐시된 데이터를 사용하여 응답하는 DNS 서버이다. 이를 통해 네트워크 성능을 향상시키고, 외부 DNS 서버로의 불필요한 쿼리 트래픽을 줄일 수 있다.

### 캐싱 DNS 서버의 주요 기능

- **속도 향상**: 캐싱 DNS 서버는 자주 조회되는 도메인 이름에 대한 쿼리를 빠르게 응답할 수 있어, 사용자 경험을 개선한다.
- **네트워크 부하 감소**: 반복적인 DNS 쿼리가 외부로 나가지 않고 캐싱 서버에서 처리되기 때문에, 네트워크 트래픽과 부하를 줄일 수 있다.
- **응답 시간 단축**: 로컬 네트워크 내에 캐싱 DNS 서버가 존재하면, 원격 DNS 서버와의 통신을 줄여 응답 시간을 단축할 수 있다.

### 캐싱 DNS 서버의 작동 원리

1. **첫 번째 요청**:
   - 클라이언트가 특정 도메인에 대한 IP 주소를 요청하면, 캐싱 DNS 서버는 이 요청을 외부 DNS 서버에 전달한다.
   - 외부 DNS 서버가 IP 주소를 반환하면, 캐싱 DNS 서버는 이 결과를 클라이언트에 전달함과 동시에 캐시에 저장한다.

2. **후속 요청**:
   - 동일한 도메인에 대한 후속 요청이 들어오면, 캐싱 DNS 서버는 이전에 저장된 캐시를 사용하여 신속하게 응답한다.
   - 캐시된 데이터는 TTL(Time to Live) 값에 따라 일정 시간이 지나면 자동으로 갱신되거나 삭제된다.

캐싱 DNS 서버는 네트워크 성능 최적화와 빠른 DNS 응답을 위해 필수적인 역할을 하며, 특히 대규모 네트워크 환경에서 그 효과가 두드러진다.
![[dns_modern.png]]
	캐싱 과정이 포함된 DNS 질의 과정
### CentOS7에서 DNS 관리
CentOS7에서는 DNS 서버 소프트웨어로 주로 **BIND**(Berkeley Internet Name Domain)를 사용한다. BIND는 가장 널리 사용되는 DNS 서버 소프트웨어 중 하나로, 안정성과 유연성이 뛰어나다.

#### 리눅스 DNS 정보 명령어
```bash# 현재 DNS 서버 정보 확인
# CentOS7에서 현재 사용 중인 DNS 서버와 네트워크 설정 정보를 확인하는 명령어이다.

# resolv.conf 파일을 확인하여 현재 설정된 DNS 서버를 확인
cat /etc/resolv.conf

# 현재 활성화된 네트워크 인터페이스의 상세 정보와 DNS 설정 확인
nmcli device show | grep IP4.DNS

# 또는
# 네트워크 인터페이스 별로 할당된 DNS 서버와 기타 네트워크 설정 정보를 확인
ip addr show

# 시스템에서 지정된 모든 DNS 서버 정보 확인
systemd-resolve --status
```
#### DNS 관리 명령어
```bash
# BIND 패키지 설치
# CentOS7에서 BIND DNS 서버 소프트웨어를 설치하는 명령어이다.
sudo yum install bind bind-utils -y

# DNS 서버 시작
# BIND DNS 서버를 시작하는 명령어이다.
sudo systemctl start named

# DNS 서버 부팅 시 자동 시작 설정
sudo systemctl enable named

# DNS 서버 상태 확인
# BIND DNS 서버의 상태를 확인하는 명령어이다.
sudo systemctl status named

# DNS 서버 재시작
# 설정 변경 후 BIND DNS 서버를 재시작하는 명령어이다.
sudo systemctl restart named

# DNS 쿼리 테스트
# 'dig' 명령어를 사용하여 특정 도메인에 대한 DNS 쿼리를 테스트할 수 있다.
dig example.com

# DNS 역방향 조회
# 'dig' 명령어로 IP 주소를 도메인 이름으로 변환하는 역방향 조회를 수행한다.
dig -x 192.168.1.1
```

#### DNS 설정 파일
CentOS7에서 BIND DNS 서버의 주요 설정 파일은 `/etc/named.conf`이다. 이 파일에서 DNS 서버의 기본 설정과 영역(zone)을 정의한다. 추가적으로, 각 영역에 대한 설정은 개별 파일로 정의된다.
``` config
options {
    listen-on port 53 { 127.0.0.1; any; };  # DNS 서버가 듣는 포트를 설정
    directory "/var/named";  # DNS 설정 파일들이 저장된 디렉토리
    dump-file "/var/named/data/cache_dump.db";  # 캐시 덤프 파일 위치
    statistics-file "/var/named/data/named_stats.txt";  # 통계 파일 위치
    memstatistics-file "/var/named/data/named_mem_stats.txt";  # 메모리 통계 파일 위치
    allow-query { any; };  # 모든 호스트가 DNS 서버를 쿼리할 수 있도록 허용

    recursion yes;  # 재귀적 쿼리를 허용
    dnssec-enable yes;  # DNSSEC 사용
    dnssec-validation yes;  # DNSSEC 검증 사용
    dnssec-lookaside auto;

    /* If you are building an AUTHORITATIVE DNS server, do not enable recursion. */
    /* If you are building a RECURSIVE (caching) DNS server, you need to enable recursion. */

    /* Path to ISC DLV key */
    bindkeys-file "/etc/named.iscdlv.key";

    managed-keys-directory "/var/named/dynamic";
};

zone "." IN {
    type hint;
    file "named.ca";  # 루트 힌트 파일
};

zone "example.com" IN {
    type master;
    file "example.com.zone";  # example.com 도메인의 영역 파일
    allow-update { none; };
};

zone "1.168.192.in-addr.arpa" IN {
    type master;
    file "192.168.1.zone";  # 192.168.1.0 네트워크에 대한 역방향 조회 파일
    allow-update { none; };
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
```

### 프록시(Proxy) 서버

**프록시 서버**는 클라이언트와 서버 사이에 중계 역할을 하는 서버로, 클라이언트의 요청을 대신 처리하거나 요청을 필터링, 캐싱하는 역할을 한다. 프록시 서버는 보안 강화, 웹 트래픽 관리, 콘텐츠 필터링 등의 목적을 위해 사용된다.

### 프록시 서버의 종류

- **일반 프록시 (Forward Proxy)**:![[images_vpdls1511_post_ea33bcaa-db3c-48df-97a1-dbe785340a2c_스크린샷 2022-02-21 오후 10.25.42.png]]
  - 클라이언트의 요청을 받아 외부 서버로 전달하는 프록시 서버이다. 클라이언트는 직접 외부 서버에 접근하지 않고 프록시를 통해 간접적으로 접근한다. 주로 웹 필터링, 캐싱, 익명화 목적으로 사용된다.

- **투명 프록시 (Transparent Proxy)**:
  - 클라이언트가 프록시 서버를 사용하고 있다는 사실을 알지 못하는 프록시이다. 클라이언트의 요청을 강제로 프록시 서버를 거쳐가도록 설정하며, 클라이언트 설정 변경 없이 네트워크 레벨에서 적용된다.

- **역 프록시 (Reverse Proxy)**:![[images_vpdls1511_post_b519564f-66a6-46d6-a70d-22c287534672_스크린샷 2022-02-21 오후 10.32.41.png]]
  - 외부 클라이언트의 요청을 받아 내부 서버로 전달하는 프록시 서버이다. 주로 로드 밸런싱, 보안 강화, SSL 암호화 처리 등을 위해 사용된다. 클라이언트는 프록시 서버와만 통신하고, 프록시 서버가 내부 서버에 요청을 전달한다.

### SQUID 프록시 설정 및 명령어 (CentOS7)

**SQUID**는 널리 사용되는 프록시 서버 소프트웨어로, HTTP, HTTPS, FTP 프로토콜을 지원하며, 캐싱 및 필터링 기능을 제공한다. CentOS7에서 SQUID를 설치하고 설정하는 방법은 다음과 같다.
#### SQUID 설치 및 기본 설정

```bash
# SQUID 설치
# CentOS7에서 SQUID를 설치하는 명령어이다.
sudo yum install squid -y

# SQUID 서비스 시작
# SQUID 서비스를 시작하는 명령어이다.
sudo systemctl start squid

# SQUID 부팅 시 자동 시작 설정
sudo systemctl enable squid

# SQUID 서비스 상태 확인
# SQUID 서비스의 상태를 확인하는 명령어이다.
sudo systemctl status squid

# SQUID 설정 파일 편집
# /etc/squid/squid.conf 파일을 편집하여 프록시 서버 설정을 구성한다.
sudo nano /etc/squid/squid.conf

# 설정 변경 후 SQUID 재시작
# 설정 파일을 수정한 후 SQUID 서비스를 재시작하여 변경 사항을 적용한다.
sudo systemctl restart squid
```

#### SQUID 설정 파일 (`/etc/squid/squid.conf`)
```
# 기본적인 접근 제어 설정
acl localnet src 192.168.1.0/24  # 내부 네트워크 IP 범위 정의
http_access allow localnet       # 내부 네트워크에서의 접근 허용
http_access deny all             # 그 외 모든 접근 차단

# 프록시 포트 설정
http_port 3128                   # 프록시 서버가 듣는 포트 번호 설정

# 캐싱 디렉토리 설정
cache_dir ufs /var/spool/squid 100 16 256  # 캐시 저장소 디렉토리 및 크기 설정

# 로그 파일 설정
access_log /var/log/squid/access.log squid  # 접근 로그 파일 경로 설정

# DNS 설정
dns_nameservers 8.8.8.8 8.8.4.4  # 구글의 공용 DNS 서버 사용 설정

# 프록시 서버 식별 정보 제거 (익명화)
forwarded_for delete             # 클라이언트의 원래 IP 주소를 삭제

# 시간 제한 설정
connect_timeout 60 seconds       # 클라이언트와의 연결 시간 제한 설정
request_timeout 5 minutes        # 요청 처리 시간 제한 설정

# 캐시 만료 설정
refresh_pattern ^ftp:           1440 20% 10080
refresh_pattern ^gopher:        1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern .               0 20% 4320
```

### DHCP 서버
**DHCP(Dynamic Host Configuration Protocol) 서버**는 네트워크에서 자동으로 IP 주소와 기타 네트워크 설정을 클라이언트 장치에 할당하는 역할을 하는 서버이다. DHCP 서버는 네트워크 관리자가 각 장치에 수동으로 IP 주소를 설정할 필요 없이, 장치가 네트워크에 연결될 때마다 동적으로 IP 주소를 할당해준다. 이를 통해 네트워크 관리가 단순화되고, IP 주소의 효율적인 사용이 가능해진다.
![[IMG_0810.jpeg]]
> ISP의 관점에서는 ip주소를 유동적으로 분배하며 서비스할 수 있고, 로컬 환경에서는 내부망에 연결된 pc 관리 등이 용이하다.
### DHCP 서버 설정 (CentOS7)
CentOS7에서 DHCP 서버를 설정하려면 `dhcp` 패키지를 설치하고, 설정 파일을 편집하여 DHCP 서버를 구성한다.
#### DHCP 서버 설치 및 설정
```bash
# DHCP 서버 설치
# CentOS7에서 DHCP 서버 소프트웨어를 설치하는 명령어이다.
sudo yum install dhcp -y

# DHCP 설정 파일 편집
# /etc/dhcp/dhcpd.conf 파일을 편집하여 DHCP 서버 설정을 구성한다.
sudo nano /etc/dhcp/dhcpd.conf

# 예시 설정 파일 내용
subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.100 192.168.1.200;  # 할당할 IP 주소 범위
    option routers 192.168.1.1;         # 기본 게이트웨이 설정
    option subnet-mask 255.255.255.0;   # 서브넷 마스크 설정
    option domain-name-servers 8.8.8.8, 8.8.4.4;  # DNS 서버 설정
    option domain-name "example.com";   # 도메인 이름 설정
    default-lease-time 600;             # 임대 시간(초) 기본값
    max-lease-time 7200;                # 임대 시간(초) 최대값
}

# DHCP 서비스 시작
# DHCP 서버를 시작하는 명령어이다.
sudo systemctl start dhcpd

# DHCP 서비스 부팅 시 자동 시작 설정
sudo systemctl enable dhcpd

# DHCP 서비스 상태 확인
# DHCP 서버의 상태를 확인하는 명령어이다.
sudo systemctl status dhcpd

# 방화벽 설정 (DHCP 포트 허용)
# DHCP 서버가 클라이언트로부터 요청을 받을 수 있도록 방화벽을 설정한다.
sudo firewall-cmd --permanent --add-service=dhcp
sudo firewall-cmd --reload
```

### NTP (Network Time Protocol) 서버
**NTP(Network Time Protocol)** 는 컴퓨터 시스템 간의 시간 동기화를 유지하기 위한 프로토콜이다. NTP 서버를 통해 클라이언트 장치들은 인터넷 또는 로컬 네트워크의 다른 서버와 시간을 동기화할 수 있다. 이를 통해 네트워크에서 일관된 시간 설정이 유지되며, 로그 파일 분석, 예약 작업, 보안 이벤트 관리 등에서 중요한 역할을 한다.
#### NTP 계층 (Stratum)
**NTP(Network Time Protocol)** 계층은 시간 서버의 정확도를 나타내는 지표로, "Stratum"이라는 용어로 표현된다. 계층 번호가 낮을수록 더 정확하고 신뢰할 수 있는 시간 서버를 의미한다. NTP는 계층 구조를 통해 시간 정보를 네트워크 전체에 걸쳐 동기화한다.
#### NTP 계층 (Stratum) 설명
- **Stratum 0 (계층 0 - 물리 시계)**:
  - **정의**: 물리적인 시계 원자, GPS, 라디오 시계와 같은 하드웨어 기반의 참조 시계.
  - **특징**: Stratum 0 장치는 네트워크에 직접 연결되지 않으며, 매우 높은 정확도를 가진다.
- **Stratum 1 (계층 1 - 타임 서버)**:
  - **정의**: Stratum 0 장치와 직접 연결된 서버로, 네트워크에서 가장 정확한 시간을 제공하는 NTP 서버.
  - **특징**: Stratum 1 서버는 주로 데이터 센터나 대형 네트워크의 기준 시간이 된다.

- **Stratum 2 (계층 2)**:
  - **정의**: Stratum 1 서버와 동기화된 서버들로, 일반적으로 클라이언트 시스템과 다른 하위 계층 서버들에게 시간을 제공한다.
  - **특징**: Stratum 2 서버는 Stratum 1보다 약간 덜 정확하지만, 여전히 높은 신뢰도를 가진다.

- **Stratum 3 (계층 3) 및 그 이하**:
  - **정의**: Stratum 2 서버와 동기화된 서버들로, 각 계층이 상위 계층 서버들과 동기화된다.
  - **특징**: 계층이 높아질수록 시간의 정확도는 낮아지며, 일반적인 네트워크에서 사용하는 클라이언트 시스템은 보통 Stratum 3이나 4에 동기화된다.
#### NTP 계층 요약

- **Stratum 0**: 물리적 시계 원자, GPS (직접 네트워크에 연결되지 않음)
- **Stratum 1**: Stratum 0과 연결된 서버 (가장 높은 정확도를 가짐)
- **Stratum 2**: Stratum 1 서버와 동기화된 서버
- **Stratum 3 및 이하**: 상위 계층과 동기화된 서버 및 클라이언트

NTP의 계층 구조는 네트워크 전체의 시간 동기화 정확성을 유지하는 데 중요한 역할을 하며, 높은 계층 서버일수록 더 많은 서버와 클라이언트를 동기화할 수 있다.
#### NTP 명령어 (CentOS7)
```
# NTP 서버 설치
# CentOS7에서 NTP 서버를 설치하는 명령어이다.
sudo yum install ntp -y

# NTP 설정 파일 편집
# /etc/ntp.conf 파일을 편집하여 NTP 서버를 설정한다.
sudo nano /etc/ntp.conf

# NTP 서비스 시작
# NTP 서비스를 시작하는 명령어이다.
sudo systemctl start ntpd

# NTP 서비스 부팅 시 자동 시작 설정
sudo systemctl enable ntpd

# NTP 서버 상태 확인
# NTP 서비스의 상태를 확인하는 명령어이다.
sudo systemctl status ntpd

# NTP 동기화 상태 확인
# 클라이언트에서 NTP 동기화 상태를 확인하는 명령어이다.
ntpq -p

# 즉시 시간 동기화 (옵션)
# NTP 서버와 즉시 시간을 동기화하는 명령어이다.
sudo ntpdate <ntp_server_ip>
```