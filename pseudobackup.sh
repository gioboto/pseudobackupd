#!/bin/bash
#
#script pseudobackup.sh
# Version : 1.0
#Para generar respaldos de ciertas carpetas del sistema y guardarlos en una carpeta NFS
#Autor : Ing. Jorge Navarrete
#mail : jorge_n@web.de
#Fecha : 2015-02-24

#script pseudobackup.sh
#Para generar respaldos de ciertas carpetas del sistema y guardarlos en una carpeta NFS
#
#===========================================================================
PATH=/bin:/usr/bin:/usr/sbin/
#===========================================================================
#VARIABLES
NOMBREBACKUP=postgres-produccion
NFSSERVER=10.10.225.231
NFSCARPETAREMOTA=/home/temp
NFSCARPETALOCAL=/mnt
DIRECTORIO1=etc
DIRECTORIO2=opt
DIRECTORIO3=var/respaldos/backups/daily

#===========================================================================
FECHAINICIO=`date +%Y-%m-%d`
CADENALASTDAY="`echo $FECHAINICIO | sed 's/:/ /g'`"
ARCHIVO1=`echo $NOMBREBACKUP`"_"$DIRECTORIO1"_"`echo $CADENALASTDAY`".tar.bz2"
ARCHIVO2=`echo $NOMBREBACKUP`"_postgres-conf_"`echo $CADENALASTDAY`".tar.bz2"
ARCHIVO3=`echo $NOMBREBACKUP`"_bases_"`echo $CADENALASTDAY`".tar.bz2"

#echo $ARCHIVO1
#echo $ARCHIVO2

#Responde el NFS server?
rpcinfo -t "$NFSSERVER" nfs &>/dev/null
if [ $? -eq 0 ]; then
# NFS is up juas!
/bin/mount -t nfs $NFSSERVER:$NFSCARPETAREMOTA $NFSCARPETALOCAL
#ls $NFSCARPETALOCAL
#
tar -czpvf $NFSCARPETALOCAL/$ARCHIVO1 /$DIRECTORIO1
tar -czpvf $NFSCARPETALOCAL/$ARCHIVO2  /var/lib/pgsql/9.3/data/*.conf
tar -czpvf $NFSCARPETALOCAL/$ARCHIVO3 /$DIRECTORIO3
echo " "
echo " "
ls -lh $NFSCARPETALOCAL
#
#
echo " "
echo " "
echo "                Desmontando carpeta NFS"
/bin/umount $NFSCARPETALOCAL
ls -lah $NFSCARPETALOCAL
echo " "
echo " "
echo "                Gracias por usar este script"

else
echo " "
echo " "
echo "                No se puede montar el servidor NFS"
fi

