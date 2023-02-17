for i in `ls -1 /proc/ | egrep "([0-9]+)"`
do
    echo "$i:[`cat /proc/$i/comm`] `cat /proc/$i/cmdline`"
done

