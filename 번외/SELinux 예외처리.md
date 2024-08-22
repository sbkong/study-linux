
# 포트
### 확인
```bash
sudo semanage port -l | grep {PORT}
```

### 추가
```bash
sudo semanage port -a -t {SELinux 유형} -p {tcp/udp {PORT}

sudo semanage port -a -t syslogd_port_t -p tcp 8880
```

### 삭제
```bash
sudo semanage port -d -t {SELinux 유형} -p {tcp/udp {PORT}

sudo semanage port -d -t syslogd_port_t -p tcp 8880
```
# 컨텍스트
- 디렉터리 예외 처리
### 확인
```bash
sudo semanage fcontext -l | grep '{경로}'

```

### 추가
```bash
sudo semanage fcontext -a -t {SELinux 유형} '{경로}'

### e.g.
sudo semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/uploads(/.*)?'
```

### 규칙 적용
```bash
sudo restorecon -Rv {경로}

sudo restorecon -Rv /var/www/html/uploads
```
### 삭제
```bash
sudo semanage fcontext -d -t {SELinux 유형} '{경로}'

# e.g.
sudo semanage fcontext -d -t httpd_sys_rw_content_t '/var/www/html/uploads(/.*)?'
```

#### 일시적인 추가
```bash
chcon -t {SELinux 유형} {YOUR_PATH}

# e.g.
chcon -t httpd_sys_rw_content_t /var/www/html/uploads
```
- 위 설정은 일시적인 적용으로, 서버 재부팅 혹은 `restorecon`명령어를 사용하면 초기화된다.

# See Also
{{SELinux}}
