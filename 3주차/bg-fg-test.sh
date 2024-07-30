#!/bin/bash

# 무한 루프
while true
do
    # 5초 대기
    sleep 5
    # wait 출력
    echo "wait"

    # 키 입력 감지
    read -t 0.1 -n 1 key
    if [[ $key = "A" ]]; then
        # A키 입력 시 루프 종료
        echo "프로세스를 종료합니다."
        break
    fi
done
