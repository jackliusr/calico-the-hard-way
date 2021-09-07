cd /tmp
if ! command -v docker &> /dev/null
then
curl -fsSL https://get.docker.com -o get-docker.sh
sh /tmp/get-docker.sh
fi
