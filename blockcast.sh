#!/bin/bash

set -e

clear
echo "============================================="
echo "    🚀 Blockcast Beacon Node Installer 🚀     "
echo "============================================="
echo "  Otomatis install Docker & jalankan node!   "
echo "---------------------------------------------"
echo "  ⚠️  Gunakan di Ubuntu 20.04 / 22.04 (64-bit)"
echo "============================================="
echo ""

echo "===> Mengecek apakah Docker sudah terinstal..."

if ! command -v docker &> /dev/null
then
    echo "===> Docker belum terinstal. Memulai instalasi Docker..."

    sudo apt update
    sudo apt install -y ca-certificates curl gnupg lsb-release git

    echo "===> Menambahkan GPG key Docker..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "===> Menambahkan repository Docker..."
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    echo "===> Instalasi Docker Engine..."
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    echo "===> Menambahkan user ke grup docker..."
    sudo usermod -aG docker $USER
    echo "===> ⚠️ Harap logout dan login ulang agar bisa menjalankan docker tanpa sudo."
else
    echo "===> ✅ Docker sudah terinstal. Melewati instalasi."
fi

echo ""
echo "===> Cloning repository beacon-docker-compose..."
git clone https://github.com/Blockcast/beacon-docker-compose.git
cd beacon-docker-compose

echo "===> Menjalankan docker compose up..."
docker compose up -d

echo "===> Menjalankan blockcastd init..."
docker compose exec blockcastd blockcastd init

echo ""
echo "🎉 Instalasi selesai!"
echo "============================================="
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
echo "============================================="
