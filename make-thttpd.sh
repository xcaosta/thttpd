root=${HOME}/Public
if [[ -d ${root} ]]; then
  mydir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  (
    cd ${mydir}/thttpd
    echo ${PWD}
    sed -i "s#WEBGROUP =	www#WEBGROUP = $(groups $USER | awk '{print $3}')#g" Makefile.in
    sed -i "s#-o bin -g bin#-o ${USER} -g $(groups $USER | awk '{print $3}')#g" Makefile.in
    ./configure --prefix=$root
    git checkout Makefile.in
    make
    killall thttpd
    make install

    root=$(realpath $HOME)/Public
    chmod -R a+rx $root/www/data
    $root/sbin/thttpd -u $USER -C $root/thttpd.conf
    ps -eo pid,args | grep '[t]httpd'
  )
fi
