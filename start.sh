mysql-proxy \
  --proxy-backend-addresses=0.0.0.0:3306 \
  --proxy-skip-profiling \
  --proxy-address=0.0.0.0:3307 \
  --proxy-lua-script=`pwd`/arel.lua
