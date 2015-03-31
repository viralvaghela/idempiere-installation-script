#!/bin/bash
# Created Version 1 Chuck Boecking

######################################
# This file is dangerous. It will overwrite your database.
# This script should only be executed from a development instance - NOT PRODUCTION.
######################################

CHUBOE_UTIL="/opt/chuboe_utils/"
CHUBOE_UTIL_HG="$CHUBOE_UTIL/idempiere-installation-script/"
CHUBOE_UTIL_HG_PROP="$CHUBOE_UTIL_HG/utils/properties/"
LOGFILE="/log/chuboe_db_obfuscate.log"
ADEMROOTDIR="/opt/idempiere-server"
UTILSDIR="chuboe_utils"
DATABASE="idempiere"
IDEMPIEREUSER="idempiere"
USER="adempiere"
ADDPG="-h localhost -p 5432"

echo LOGFILE="$CHUBOE_UTIL_HG"/"$LOGFILE" >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
echo ADEMROOTDIR="$ADEMROOTDIR" >> "$CHUBOE_UTIL_HG"/"$LOGFILE"

cd "$ADEMROOTDIR"/utils
echo ademres: ------------------------------------------------------------------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
echo ademres: -------            STARTING iDempiere Obfuscation           ------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
echo ademres: ------------------------------------------------------------------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"

RESULT=$(ls -l $CHUBOE_UTIL_HG_PROP/CHUBOE_TEST_ENV_YES.txt | wc -l)
if [ $RESULT -ge 1 ]; then
    echo ademres: ------------------------------------------------------------------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
    echo ademres: -------              This is a Dev Envrionment              ------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
    echo ademres: ------------------------------------------------------------------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
else
    echo ademres: ------------------------------------------------------------------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
    echo ademres: -------            STOPPING Not a Dev Envrionment           ------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
    echo ademres: ------------------------------------------------------------------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
    exit 1
fi #end if dev environment check
if sudo -u $IDEMPIEREUSER "$ADEMROOTDIR"/utils/RUN_DBExport.sh >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
then
    echo adembak: Local Backup Succeeded.  >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
else
    echo adembak: ------------------------------------------------------------------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
    echo adembak: -------          Local iDempiere Backup FAILED!             ------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
    echo adembak: ------------------------------------------------------------------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
    echo  .
    exit 1
fi

psql -d $DATABASE -U $USER $ADDPG -f "$CHUBOE_UTIL_HG"/utils/chuboe_obfuscation.sql >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
    echo adembak: ------------------------------------------------------------------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
    echo edembak: -------         FINISHED iDempiere Obfuscation              ------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
    echo adembak: ------------------------------------------------------------------- >> "$CHUBOE_UTIL_HG"/"$LOGFILE"
    echo .
exit 0
