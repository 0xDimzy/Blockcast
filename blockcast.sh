#!/bin/bash

set -e

clear
echo "=============================================="
echo "     🚀 Blockcast Beacon Node Installer 🚀     "
echo "=============================================="
echo " 📦 Auto setup Docker + Beacon Node (Blockcast)"
echo " 🌐 blockcast.network"
echo "----------------------------------------------"
echo " 💡 Pastikan Anda menggunakan Ubuntu 20.04/22.04"
echo ""
echo "⏳ Instalasi akan dimulai dalam 5 detik..."
echo "   Tekan CTRL+C untuk membatalkan."
echo "=============================================="
sleep 5

echo "===> Mengecek Docker..."

if ! command -v docker &> /dev/null
then
    echo "===> Docker belum terinstal. Memulai instalasi..."

    sudo apt update
    sudo apt install -y ca-certificates curl gnupg lsb-release git

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    sudo usermod -aG docker $USER
    echo "===> 🚨 Harap logout & login ulang agar grup docker aktif."
else
    echo "===> ✅ Docker sudah terinstal."
fi

echo "===> Cloning repository beacon-docker-compose..."
git clone https://github.com/Blockcast/beacon-docker-compose.git
cd beacon-docker-compose

echo "===> Menjalankan docker compose..."
docker compose up -d

echo "===> Inisialisasi blockcastd..."
docker compose exec blockcastd blockcastd init

echo ""
echo "🎉 Instalasi selesai!"
echo "=============================================="
echo "ℹ️  Perintah penting yang bisa Anda gunakan:"
echo ""
echo "📜 Cek log node:"
echo "   docker logs -f blockcastd"
echo ""
echo "🆔 Cek Hardware ID & Challenge Key:"
echo "   docker compose exec blockcastd blockcastd show-info"
echo ""
echo "🛑 Hentikan node:"
echo "   docker compose down"
echo ""
echo "🔁 Jalankan ulang node:"
echo "   docker compose up -d"
echo ""
echo "🧹 Reset node & hapus semua data:"
echo "   docker compose down -v"
echo ""
echo "=============================================="
