# https://github.com/patjak/bcwc_pcie/wiki/Get-Started

cd ~/
sudo apt-get install -y git curl debhelper dkms
git clone https://github.com/patjak/bcwc_pcie.git
cd bcwc_pcie/firmware
make
sudo make install
sudo dpkg -r bcwc-pcie
sudo mkdir /usr/src/facetimehd-0.1
cd ~/bcwc_pcie
sudo cp -r * /usr/src/facetimehd-0.1/
cd /usr/src/facetimehd-0.1/
make clean
sudo dkms add -m facetimehd -v 0.1
sudo dkms build -m facetimehd -v 0.1
sudo dkms mkdsc -m facetimehd -v 0.1 --source-only
sudo dkms mkdeb -m facetimehd -v 0.1 --source-only
sudo cp /var/lib/dkms/facetimehd/0.1/deb/facetimehd-dkms_0.1_all.deb ~
rm -r /var/lib/dkms/facetimehd/
sudo dpkg -i ~/facetimehd-dkms_0.1_all.deb
sudo modprobe -r bdc_pci
sudo modprobe facetimehd
