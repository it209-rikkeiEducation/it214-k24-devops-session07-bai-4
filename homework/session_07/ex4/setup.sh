#!/usr/bin/env bash

# Thoát script nếu có lỗi xảy ra
set -e

echo "==============================================="
echo "BẮT ĐẦU CẤU HÌNH REVERSE PROXY NGINX"
echo "==============================================="

# 1. Tạo thư mục chứa trang tĩnh
echo "[1/6] Tạo thư mục /var/www/html/..."
sudo mkdir -p /var/www/html

# 2. Copy file index.html vào thư mục tĩnh
echo "[2/6] Copy index.html vào /var/www/html/..."
sudo cp index.html /var/www/html/index.html

# 3. Copy file cấu hình spring-proxy.conf vào sites-available
echo "[3/6] Cấu hình virtual host trong Nginx..."
sudo mkdir -p /etc/nginx/sites-available
sudo mkdir -p /etc/nginx/sites-enabled
sudo cp spring-proxy.conf /etc/nginx/sites-available/spring-proxy.conf

# 4. Kích hoạt cấu hình thông qua Symbolic Link
echo "[4/6] Kích hoạt cấu hình (tạo symlink)..."
sudo ln -sf /etc/nginx/sites-available/spring-proxy.conf /etc/nginx/sites-enabled/

# Vô hiệu hóa cấu hình default cũ để tránh xung đột port 80 (nếu có)
if [ -f /etc/nginx/sites-enabled/default ]; then
    echo "[!] Phát hiện tệp default cấu hình cũ, tiến hành vô hiệu hóa để tránh trùng cổng..."
    sudo rm /etc/nginx/sites-enabled/default
fi

# 5. Kiểm tra cú pháp Nginx
echo "[5/6] Kiểm tra cú pháp Nginx..."
sudo nginx -t

# 6. Reload lại service Nginx để áp dụng thay đổi
echo "[6/6] Reloading Nginx service..."
sudo systemctl reload nginx || sudo service nginx reload || sudo nginx -s reload

echo "==============================================="
echo "CẤU HÌNH HOÀN TẤT VÀ THÀNH CÔNG!"
echo "==============================================="